from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from ..database import get_db
from ..models import Person
from ..schemas import PersonCreate, PersonUpdate, PersonResponse

router = APIRouter(prefix="/api/persons", tags=["Persons"])


@router.get("/", response_model=List[PersonResponse])
def list_persons(db: Session = Depends(get_db)):
    return db.query(Person).order_by(Person.name).all()


@router.post("/", response_model=PersonResponse, status_code=201)
def create_person(payload: PersonCreate, db: Session = Depends(get_db)):
    existing = db.query(Person).filter(Person.name == payload.name).first()
    if existing:
        raise HTTPException(400, f"Person '{payload.name}' already exists")
    obj = Person(**payload.model_dump())
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj


@router.get("/{person_id}", response_model=PersonResponse)
def get_person(person_id: int, db: Session = Depends(get_db)):
    obj = db.query(Person).filter(Person.id == person_id).first()
    if not obj:
        raise HTTPException(404, "Person not found")
    return obj


@router.put("/{person_id}", response_model=PersonResponse)
def update_person(person_id: int, payload: PersonUpdate, db: Session = Depends(get_db)):
    obj = db.query(Person).filter(Person.id == person_id).first()
    if not obj:
        raise HTTPException(404, "Person not found")
    for k, v in payload.model_dump().items():
        setattr(obj, k, v)
    db.commit()
    db.refresh(obj)
    return obj


@router.delete("/{person_id}", status_code=204)
def delete_person(person_id: int, db: Session = Depends(get_db)):
    obj = db.query(Person).filter(Person.id == person_id).first()
    if not obj:
        raise HTTPException(404, "Person not found")
    # Check if person has pay advices
    if obj.pay_advices:
        raise HTTPException(400, f"Cannot delete '{obj.name}' — they have {len(obj.pay_advices)} pay stub(s). Reassign or delete those first.")
    db.delete(obj)
    db.commit()
