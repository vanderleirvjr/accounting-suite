from datetime import date
from decimal import Decimal
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import extract
from typing import List, Optional

from ..database import get_db
from ..models import BankTransaction, Person
from ..schemas import (
    BankTransactionCreate,
    BankTransactionUpdate,
    BankTransactionResponse,
)

router = APIRouter(prefix="/api/transactions", tags=["Transactions"])


def _q(db: Session, year: Optional[int] = None, person_id: Optional[int] = None):
    q = db.query(BankTransaction).options(joinedload(BankTransaction.person))
    if year:
        q = q.filter(extract("year", BankTransaction.tx_date) == year)
    if person_id:
        q = q.filter(BankTransaction.person_id == person_id)
    return q


def _opening_balance_for(db: Session, person_id: Optional[int], bank: str, account_type: str):
    person_name = ""
    if person_id:
        p = db.query(Person).filter(Person.id == person_id).first()
        person_name = (p.name or "").strip().lower() if p else ""
    b = (bank or "").strip().lower()
    a = (account_type or "").strip().lower()
    # Requested baseline: Vanderlei starts at 669.24; Sandra starts at 103.74 before any 2023 transaction.
    if person_name == "vanderlei" and b == "capital one" and a == "checking":
        return date(2023, 1, 1), Decimal("669.24")
    if person_name == "vanderlei" and b == "capital one" and a == "savings":
        return date(2023, 1, 1), Decimal("3309.13")
    if person_name == "sandra" and b == "capital one" and a == "checking":
        return date(2023, 1, 1), Decimal("103.74")
    if person_name == "sandra" and b == "capital one" and a == "savings":
        return date(2023, 1, 1), Decimal("778.47")
    if person_name == "sandra" and b == "wells fargo" and a == "checking":
        return date(2023, 1, 1), Decimal("811.09")
    if person_name == "vanderlei" and b == "wells fargo" and a == "checking":
        return date(2022, 1, 1), Decimal("10840.07")
    return date(1970, 1, 1), Decimal("0.00")


def _recalculate_group_balances(db: Session, person_id: Optional[int], bank: str, account_type: str):
    opening_date, opening_balance = _opening_balance_for(db, person_id, bank, account_type)
    txs = (
        db.query(BankTransaction)
        .filter(BankTransaction.person_id == person_id)
        .filter(BankTransaction.bank == bank)
        .filter(BankTransaction.account_type == account_type)
        .order_by(BankTransaction.tx_date.asc(), BankTransaction.id.asc())
        .all()
    )
    running = opening_balance
    for tx in txs:
        if tx.tx_date < opening_date:
            tx.balance = opening_balance.quantize(Decimal("0.01"))
            continue
        running += Decimal(str(tx.amount or 0))
        tx.balance = running.quantize(Decimal("0.01"))
    db.flush()


def _recalculate_for_filtered_query(db: Session, year: Optional[int], person_id: Optional[int]):
    groups = (
        _q(db, year, person_id)
        .with_entities(BankTransaction.person_id, BankTransaction.bank, BankTransaction.account_type)
        .distinct()
        .all()
    )
    for pid, bank, account_type in groups:
        _recalculate_group_balances(db, pid, bank or "", account_type or "")
    db.commit()


@router.get("/", response_model=List[BankTransactionResponse])
def list_transactions(
    year: Optional[int] = None,
    person_id: Optional[int] = None,
    skip: int = 0,
    limit: int = 5000,
    db: Session = Depends(get_db),
):
    _recalculate_for_filtered_query(db, year, person_id)
    items = _q(db, year, person_id).order_by(BankTransaction.tx_date.desc(), BankTransaction.id.desc()).offset(skip).limit(limit).all()
    return [BankTransactionResponse.from_orm_with_person(i) for i in items]


@router.get("/years", response_model=List[int])
def list_years(person_id: Optional[int] = None, db: Session = Depends(get_db)):
    q = db.query(extract("year", BankTransaction.tx_date).label("yr"))
    if person_id:
        q = q.filter(BankTransaction.person_id == person_id)
    rows = q.distinct().order_by("yr").all()
    return [int(r.yr) for r in rows]


@router.post("/", response_model=BankTransactionResponse, status_code=201)
def create_transaction(payload: BankTransactionCreate, db: Session = Depends(get_db)):
    obj = BankTransaction(**payload.model_dump(exclude={"balance"}))
    db.add(obj)
    db.commit()
    _recalculate_group_balances(db, obj.person_id, obj.bank or "", obj.account_type or "")
    db.commit()
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == obj.id).first()
    return BankTransactionResponse.from_orm_with_person(obj)


@router.get("/{tx_id}", response_model=BankTransactionResponse)
def get_transaction(tx_id: int, db: Session = Depends(get_db)):
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == tx_id).first()
    if not obj:
        raise HTTPException(404, "Transaction not found")
    _recalculate_group_balances(db, obj.person_id, obj.bank or "", obj.account_type or "")
    db.commit()
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == tx_id).first()
    return BankTransactionResponse.from_orm_with_person(obj)


@router.put("/{tx_id}", response_model=BankTransactionResponse)
def update_transaction(tx_id: int, payload: BankTransactionUpdate, db: Session = Depends(get_db)):
    obj = db.query(BankTransaction).filter(BankTransaction.id == tx_id).first()
    if not obj:
        raise HTTPException(404, "Transaction not found")
    old_key = (obj.person_id, obj.bank or "", obj.account_type or "")
    for k, v in payload.model_dump(exclude={"balance"}).items():
        setattr(obj, k, v)
    db.commit()
    _recalculate_group_balances(db, old_key[0], old_key[1], old_key[2])
    _recalculate_group_balances(db, obj.person_id, obj.bank or "", obj.account_type or "")
    db.commit()
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == tx_id).first()
    return BankTransactionResponse.from_orm_with_person(obj)


@router.delete("/{tx_id}", status_code=204)
def delete_transaction(tx_id: int, db: Session = Depends(get_db)):
    obj = db.query(BankTransaction).filter(BankTransaction.id == tx_id).first()
    if not obj:
        raise HTTPException(404, "Transaction not found")
    old_key = (obj.person_id, obj.bank or "", obj.account_type or "")
    db.delete(obj)
    db.commit()
    _recalculate_group_balances(db, old_key[0], old_key[1], old_key[2])
    db.commit()
