import os

from fastapi import APIRouter, Depends, Form, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from ..auth import verify_password
from ..database import get_db
from ..models import User

router = APIRouter(tags=["Auth"])

templates_dir = os.path.join(os.path.dirname(__file__), "..", "..", "templates")
templates = Jinja2Templates(directory=templates_dir)


@router.get("/login")
def login_page(request: Request):
    if request.session.get("user_id"):
        return RedirectResponse(url="/dashboard", status_code=303)
    return templates.TemplateResponse("auth.html", {"request": request, "mode": "login", "error": None})


@router.post("/login")
def login(request: Request, username: str = Form(...), password: str = Form(...), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username.strip()).first()
    if not user or not verify_password(password, user.password_hash):
        return templates.TemplateResponse(
            "auth.html",
            {"request": request, "mode": "login", "error": "Invalid username or password."},
            status_code=401,
        )
    request.session["user_id"] = user.id
    request.session["username"] = user.username
    return RedirectResponse(url="/dashboard", status_code=303)


@router.get("/register")
def register_page(request: Request):
    return RedirectResponse(url="/login", status_code=303)


@router.post("/register")
def register(request: Request):
    return templates.TemplateResponse(
        "auth.html",
        {"request": request, "mode": "login", "error": "User registration is disabled."},
        status_code=403,
    )


@router.post("/logout")
def logout(request: Request):
    request.session.clear()
    return RedirectResponse(url="/login", status_code=303)


@router.get("/logout")
def logout_get(request: Request):
    request.session.clear()
    return RedirectResponse(url="/login", status_code=303)
