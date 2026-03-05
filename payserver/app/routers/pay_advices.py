from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import extract
from typing import List, Optional
import io
import pandas as pd
from fastapi.responses import StreamingResponse

from ..database import get_db
from ..models import PayAdvice, Person
from ..schemas import PayAdviceCreate, PayAdviceUpdate, PayAdviceResponse, YearSummary

router = APIRouter(prefix="/api/pay-advices", tags=["Pay Advices"])


def _q(db: Session, year: Optional[int] = None, person_id: Optional[int] = None):
    """Base query with eager-loaded person, optional filters."""
    q = db.query(PayAdvice).options(joinedload(PayAdvice.person))
    if year:
        q = q.filter(extract("year", PayAdvice.pay_date) == year)
    if person_id:
        q = q.filter(PayAdvice.person_id == person_id)
    return q


@router.get("/", response_model=List[PayAdviceResponse])
def list_pay_advices(
    year: Optional[int] = None,
    person_id: Optional[int] = None,
    skip: int = 0,
    limit: int = 200,
    db: Session = Depends(get_db)
):
    items = _q(db, year, person_id).order_by(PayAdvice.pay_date.desc()).offset(skip).limit(limit).all()
    return [PayAdviceResponse.from_orm_computed(i) for i in items]


@router.post("/", response_model=PayAdviceResponse, status_code=201)
def create_pay_advice(payload: PayAdviceCreate, db: Session = Depends(get_db)):
    obj = PayAdvice(**payload.model_dump())
    db.add(obj)
    db.commit()
    db.refresh(obj)
    # Reload with person relationship
    obj = db.query(PayAdvice).options(joinedload(PayAdvice.person)).filter(PayAdvice.id == obj.id).first()
    return PayAdviceResponse.from_orm_computed(obj)


@router.get("/years", response_model=List[int])
def list_years(person_id: Optional[int] = None, db: Session = Depends(get_db)):
    q = db.query(extract("year", PayAdvice.pay_date).label("yr"))
    if person_id:
        q = q.filter(PayAdvice.person_id == person_id)
    rows = q.distinct().order_by("yr").all()
    return [int(r.yr) for r in rows]


@router.get("/summary/{year}", response_model=YearSummary)
def year_summary(year: int, person_id: Optional[int] = None, db: Session = Depends(get_db)):
    q = db.query(PayAdvice).options(joinedload(PayAdvice.person))\
          .filter(extract("year", PayAdvice.pay_date) == year)
    if person_id:
        q = q.filter(PayAdvice.person_id == person_id)
    items = q.all()
    if not items:
        raise HTTPException(404, f"No pay advices found for year {year}")

    def s(field):
        return sum(float(getattr(i, field) or 0) for i in items)

    pre   = s("dental_pre") + s("medical_pre") + s("retirement_plan") + s("park_permit")
    taxes = s("federal_taxes") + s("medicare") + s("social_security") + s("state_tax") + s("state_misc2")
    post  = s("ltd_post") + s("vol_add_post") + s("std_post")
    net   = s("gross") - pre - taxes - post - s("imputed_famli_ee") - s("basic_life_imputed_income") - s("tuition")
    er    = (s("er_retirement_401a") + s("er_basic_life_add") + s("er_dental") + s("er_eap") +
             s("er_hsa") + s("er_ltd") + s("er_medical") + s("er_std") + s("er_other"))

    person_name = None
    if person_id:
        p = db.query(Person).filter(Person.id == person_id).first()
        person_name = p.name if p else None

    return YearSummary(
        year=year,
        person_id=person_id,
        person_name=person_name,
        total_gross=s("gross"),
        total_federal_taxes=s("federal_taxes"),
        total_medicare=s("medicare"),
        total_social_security=s("social_security"),
        total_state_tax=s("state_tax"),
        total_state_misc2=s("state_misc2"),
        total_retirement_plan=s("retirement_plan"),
        total_dental_pre=s("dental_pre"),
        total_medical_pre=s("medical_pre"),
        total_park_permit=s("park_permit"),
        total_ltd_post=s("ltd_post"),
        total_vol_add_post=s("vol_add_post"),
        total_basic_life_imputed_income=s("basic_life_imputed_income"),
        total_imputed_famli_ee=s("imputed_famli_ee"),
        total_std_post=s("std_post"),
        total_tuition=s("tuition"),
        total_pre_tax_deductions=pre,
        total_taxes=taxes,
        total_post_tax_deductions=post,
        total_net_pay=net,
        pay_count=len(items),
        total_er_retirement_401a=s("er_retirement_401a"),
        total_er_basic_life_add=s("er_basic_life_add"),
        total_er_dental=s("er_dental"),
        total_er_eap=s("er_eap"),
        total_er_hsa=s("er_hsa"),
        total_er_ltd=s("er_ltd"),
        total_er_medical=s("er_medical"),
        total_er_std=s("er_std"),
        total_er_other=s("er_other"),
        total_employer_contributions=er,
        total_compensation=net + er,
    )


@router.get("/export/csv")
def export_csv(year: Optional[int] = None, person_id: Optional[int] = None, db: Session = Depends(get_db)):
    items = _q(db, year, person_id).order_by(PayAdvice.pay_date).all()
    rows = [PayAdviceResponse.from_orm_computed(i).model_dump() for i in items]
    df = pd.DataFrame(rows)
    output = io.StringIO()
    df.to_csv(output, index=False)
    output.seek(0)
    filename = f"pay_advices_{year or 'all'}.csv"
    return StreamingResponse(iter([output.getvalue()]), media_type="text/csv",
                             headers={"Content-Disposition": f"attachment; filename={filename}"})


@router.get("/export/excel")
def export_excel(year: Optional[int] = None, person_id: Optional[int] = None, db: Session = Depends(get_db)):
    items = _q(db, year, person_id).order_by(PayAdvice.pay_date).all()
    rows = [PayAdviceResponse.from_orm_computed(i).model_dump() for i in items]
    df = pd.DataFrame(rows)
    output = io.BytesIO()
    with pd.ExcelWriter(output, engine="openpyxl") as writer:
        df.to_excel(writer, index=False, sheet_name="Pay Advices")
    output.seek(0)
    filename = f"pay_advices_{year or 'all'}.xlsx"
    return StreamingResponse(output,
                             media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                             headers={"Content-Disposition": f"attachment; filename={filename}"})


@router.get("/{pay_id}", response_model=PayAdviceResponse)
def get_pay_advice(pay_id: int, db: Session = Depends(get_db)):
    obj = db.query(PayAdvice).options(joinedload(PayAdvice.person)).filter(PayAdvice.id == pay_id).first()
    if not obj:
        raise HTTPException(404, "Pay advice not found")
    return PayAdviceResponse.from_orm_computed(obj)


@router.put("/{pay_id}", response_model=PayAdviceResponse)
def update_pay_advice(pay_id: int, payload: PayAdviceUpdate, db: Session = Depends(get_db)):
    obj = db.query(PayAdvice).filter(PayAdvice.id == pay_id).first()
    if not obj:
        raise HTTPException(404, "Pay advice not found")
    for k, v in payload.model_dump().items():
        setattr(obj, k, v)
    db.commit()
    obj = db.query(PayAdvice).options(joinedload(PayAdvice.person)).filter(PayAdvice.id == pay_id).first()
    return PayAdviceResponse.from_orm_computed(obj)


@router.delete("/{pay_id}", status_code=204)
def delete_pay_advice(pay_id: int, db: Session = Depends(get_db)):
    obj = db.query(PayAdvice).filter(PayAdvice.id == pay_id).first()
    if not obj:
        raise HTTPException(404, "Pay advice not found")
    db.delete(obj)
    db.commit()
