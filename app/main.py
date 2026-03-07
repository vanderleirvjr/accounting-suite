from fastapi import Depends, FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from starlette.middleware.sessions import SessionMiddleware
import os

from .database import engine, Base
from .routers import auth, pay_advices, budget, persons, transactions

# Create all tables on startup
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Pay Advice & Budget Tracker",
    description="Track your pay stubs, taxes, deductions, and budget goals",
    version="1.0.0",
)

app.add_middleware(
    SessionMiddleware,
    secret_key=os.getenv("SESSION_SECRET", "change-this-in-production"),
    same_site="lax",
    https_only=False,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files
static_dir = os.path.join(os.path.dirname(__file__), "..", "static")
templates_dir = os.path.join(os.path.dirname(__file__), "..", "templates")

app.mount("/static", StaticFiles(directory=static_dir), name="static")
templates = Jinja2Templates(directory=templates_dir)

def require_api_auth(request: Request):
    if not request.session.get("user_id"):
        raise HTTPException(status_code=401, detail="Authentication required")


# Include routers
app.include_router(auth.router)
app.include_router(persons.router, dependencies=[Depends(require_api_auth)])
app.include_router(pay_advices.router, dependencies=[Depends(require_api_auth)])
app.include_router(budget.router, dependencies=[Depends(require_api_auth)])
app.include_router(transactions.router, dependencies=[Depends(require_api_auth)])


@app.get("/")
@app.get("/dashboard")
@app.get("/people")
@app.get("/pay-advices")
@app.get("/add-pay")
@app.get("/tax-summary")
@app.get("/transactions")
@app.get("/expenses")
@app.get("/w2")
@app.get("/budget")
@app.get("/export")
async def dashboard(request: Request):
    if not request.session.get("user_id"):
        return RedirectResponse(url="/login", status_code=303)
    return templates.TemplateResponse("index.html", {"request": request})


@app.get("/health")
async def health():
    return {"status": "ok"}
