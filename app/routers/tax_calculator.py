from fastapi import APIRouter, Depends
from sqlalchemy import inspect, text
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import TaxCalculatorInput
from ..schemas import TaxCalculatorInputResponse, TaxCalculatorInputUpdate

router = APIRouter(prefix="/api/tax-calculator", tags=["Tax Calculator"])
_schema_checked = False


def _ensure_schema(db: Session):
    global _schema_checked
    if _schema_checked:
        return
    cols = {c["name"] for c in inspect(db.bind).get_columns("tax_calculator_inputs")}
    if "investment_withheld" not in cols:
        db.execute(text("ALTER TABLE tax_calculator_inputs ADD COLUMN investment_withheld NUMERIC(12,2) NOT NULL DEFAULT 0"))
        db.commit()
    _schema_checked = True


def _default_row(year: int) -> TaxCalculatorInputResponse:
    return TaxCalculatorInputResponse(
        id=None,
        year=year,
        standard_deduction=0,
        hsa_contributions=0,
        investment_earnings=0,
        investment_withheld=0,
        additional_credits=0,
        federal_tax_before_credits=0,
        created_at=None,
        updated_at=None,
    )


@router.get("/{year}", response_model=TaxCalculatorInputResponse)
def get_tax_calculator_inputs(year: int, db: Session = Depends(get_db)):
    _ensure_schema(db)
    obj = db.query(TaxCalculatorInput).filter(TaxCalculatorInput.year == year).first()
    if not obj:
        return _default_row(year)
    return TaxCalculatorInputResponse.model_validate(obj)


@router.put("/{year}", response_model=TaxCalculatorInputResponse)
def upsert_tax_calculator_inputs(year: int, payload: TaxCalculatorInputUpdate, db: Session = Depends(get_db)):
    _ensure_schema(db)
    obj = db.query(TaxCalculatorInput).filter(TaxCalculatorInput.year == year).first()
    if not obj:
        obj = TaxCalculatorInput(year=year)
        db.add(obj)
    for k, v in payload.model_dump().items():
        setattr(obj, k, v)
    db.commit()
    db.refresh(obj)
    return TaxCalculatorInputResponse.model_validate(obj)
