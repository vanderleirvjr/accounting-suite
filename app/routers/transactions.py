from datetime import date
from decimal import Decimal
import json
import re
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import extract, inspect, text
from typing import List, Optional

from ..database import get_db
from ..models import BankTransaction, Person
from ..schemas import (
    BankTransactionCreate,
    BankTransactionUpdate,
    BankTransactionResponse,
    BankTransactionBulkLabelRequest,
)

router = APIRouter(prefix="/api/transactions", tags=["Transactions"])
_labels_column_checked = False


def _ensure_labels_column(db: Session):
    global _labels_column_checked
    if _labels_column_checked:
        return
    cols = {c["name"] for c in inspect(db.bind).get_columns("bank_transactions")}
    if "labels" not in cols:
        db.execute(text("ALTER TABLE bank_transactions ADD COLUMN labels TEXT NOT NULL DEFAULT '[]'"))
        db.commit()
    _labels_column_checked = True


def _normalize_labels(labels: Optional[List[str]]) -> List[str]:
    if not labels:
        return []
    out: List[str] = []
    seen = set()
    for raw in labels:
        if raw is None:
            continue
        item = str(raw).strip()
        if not item:
            continue
        key = item.lower()
        if key == "credit":
            continue
        if key in seen:
            continue
        seen.add(key)
        out.append(item[:40])
    return out[:20]


def _serialize_labels(labels: Optional[List[str]]) -> str:
    return json.dumps(_normalize_labels(labels))


def _deserialize_labels(raw) -> List[str]:
    if isinstance(raw, list):
        return _normalize_labels(raw)
    if not raw:
        return []
    try:
        parsed = json.loads(raw)
        if isinstance(parsed, list):
            return _normalize_labels(parsed)
    except Exception:
        pass
    return []


def _is_credit_card_payment(description: str, account_type: str) -> bool:
    if (account_type or "").strip().lower() != "credit":
        return False
    desc = (description or "").strip().lower()
    if not desc:
        return False
    return any(
        token in desc
        for token in [
            "online ach payment",
            "payment thank you",
            "payment received",
            "autopay",
            "ach payment",
            "card payment",
        ]
    )


def _infer_labels(description: str, amount: Decimal, account_type: str) -> List[str]:
    if _is_credit_card_payment(description, account_type):
        return []

    desc = (description or "").strip().lower()
    labels: List[str] = []

    def add(*items: str):
        for item in items:
            if item not in labels:
                labels.append(item)

    if not desc:
        return []

    rules = [
        (r"\bxcel\b", ["Household", "Utilities", "Xcel"]),
        (r"\bwalmart\b", ["Household", "Groceries", "Walmart"]),
        (r"\btarget\b", ["Household", "Groceries", "Target"]),
        (r"\bcostco\b", ["Household", "Groceries", "Costco"]),
        (r"\bking[\s-]?soopers\b", ["Household", "Groceries", "King Soopers"]),
        (r"\bstarbucks\b", ["Dining", "Coffee", "Starbucks"]),
        (r"\bmcdonald'?s\b", ["Dining", "Fast Food", "McDonalds"]),
        (r"\bhome depot\b", ["Household", "Home Improvement", "Home Depot"]),
        (r"\blowe'?s\b", ["Household", "Home Improvement", "Lowes"]),
        (r"\bamazon\b", ["Shopping", "Household", "Amazon"]),
        (r"\bchevron\b|\bconoco\b|\bshell\b|\bcostco gas\b|\b7-eleven\b", ["Transportation", "Fuel"]),
        (r"\buber\b|\blyft\b", ["Transportation", "Rideshare"]),
        (r"\bparking\b|\bpark dia\b|\bsp\d{3,}\b", ["Transportation", "Parking"]),
        (r"\bunited\b|\bdelta\b|\bamerican airlines\b|\bsouthwest\b|\bcopa air\b", ["Travel", "Airfare"]),
        (r"\bairbnb\b", ["Travel", "Lodging", "Airbnb"]),
        (r"\bhilton\b|\bmarriott\b|\bfairfield\b|\bhyatt\b|\bholiday inn\b|\bmotel\b|\bhotel\b|\bresort\b|\bbooking\.com\b|\bbkgbooking\.com\b|\bbkghotel\b", ["Travel", "Lodging"]),
        (r"\bhertz\b|\benterprise\b|\bavis\b|\bbudget rent\b|\balamo\b", ["Travel", "Transportation", "Car Rental"]),
        (r"\bstate farm\b", ["Insurance", "Auto", "Car Expense", "State Farm"]),
        (r"\bgeico\b|\bprogressive\b|\ballstate\b|\bliberty mutual\b|\binsurance\b", ["Insurance", "Auto", "Car Expense"]),
        (r"\bnetflix\b|\bspotify\b|\bhulu\b|\bdisney\b|\bchess\.? ?com\b", ["Subscription"]),
        (r"\bcash back redemption\b|\breward\b", ["Reward"]),
        (r"\bapple\.com/bill\b|\bgoogle\b", ["Subscription", "Digital"]),
    ]
    for pattern, tags in rules:
        if re.search(pattern, desc):
            add(*tags)

    if "transfer" in desc:
        add("Transfer")
    if "withdraw" in desc or "atm" in desc:
        add("Cash Withdrawal")
    if "deposit" in desc or "payroll" in desc:
        add("Income")
    if "tuition" in desc or "school" in desc:
        add("Education")
    if "pharmacy" in desc or "walgreens" in desc or "cvs" in desc:
        add("Healthcare", "Pharmacy")
    if "insurance" in desc:
        add("Insurance")
    if "tax" in desc or "dmv" in desc or "motor veh" in desc:
        add("Taxes")

    amt = Decimal(str(amount or 0))
    if amt < 0 and not labels:
        add("Uncategorized")
    return _normalize_labels(labels)


def _q(db: Session, year: Optional[int] = None, person_id: Optional[int] = None):
    _ensure_labels_column(db)
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
    _ensure_labels_column(db)
    _recalculate_for_filtered_query(db, year, person_id)
    items = _q(db, year, person_id).order_by(BankTransaction.tx_date.desc(), BankTransaction.id.desc()).offset(skip).limit(limit).all()
    return [BankTransactionResponse.from_orm_with_person(i) for i in items]


@router.get("/years", response_model=List[int])
def list_years(person_id: Optional[int] = None, db: Session = Depends(get_db)):
    _ensure_labels_column(db)
    q = db.query(extract("year", BankTransaction.tx_date).label("yr"))
    if person_id:
        q = q.filter(BankTransaction.person_id == person_id)
    rows = q.distinct().order_by("yr").all()
    return [int(r.yr) for r in rows]


@router.post("/", response_model=BankTransactionResponse, status_code=201)
def create_transaction(payload: BankTransactionCreate, db: Session = Depends(get_db)):
    _ensure_labels_column(db)
    data = payload.model_dump(exclude={"balance"})
    if _is_credit_card_payment(data.get("description", ""), data.get("account_type", "")):
        data["labels"] = _serialize_labels([])
    else:
        data["labels"] = _serialize_labels(data.get("labels"))
    obj = BankTransaction(**data)
    db.add(obj)
    db.commit()
    _recalculate_group_balances(db, obj.person_id, obj.bank or "", obj.account_type or "")
    db.commit()
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == obj.id).first()
    return BankTransactionResponse.from_orm_with_person(obj)


@router.get("/{tx_id}", response_model=BankTransactionResponse)
def get_transaction(tx_id: int, db: Session = Depends(get_db)):
    _ensure_labels_column(db)
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == tx_id).first()
    if not obj:
        raise HTTPException(404, "Transaction not found")
    _recalculate_group_balances(db, obj.person_id, obj.bank or "", obj.account_type or "")
    db.commit()
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == tx_id).first()
    return BankTransactionResponse.from_orm_with_person(obj)


@router.post("/labels/bulk")
def bulk_label_transactions(
    payload: BankTransactionBulkLabelRequest,
    db: Session = Depends(get_db),
):
    _ensure_labels_column(db)
    ids = [int(i) for i in payload.tx_ids if int(i) > 0]
    if not ids:
        raise HTTPException(400, "No transactions selected")
    norm_labels = _normalize_labels(payload.labels)
    if not norm_labels:
        raise HTTPException(400, "No valid labels provided")
    mode = (payload.mode or "add").strip().lower()
    if mode not in {"add", "remove"}:
        raise HTTPException(400, "Invalid mode")

    rows = db.query(BankTransaction).filter(BankTransaction.id.in_(ids)).all()
    updated = 0
    for row in rows:
        if _is_credit_card_payment(row.description or "", row.account_type or ""):
            # Keep payments unlabelled.
            if _deserialize_labels(row.labels):
                row.labels = "[]"
                updated += 1
            continue
        existing = _deserialize_labels(row.labels)
        if mode == "add":
            merged = _normalize_labels(existing + norm_labels)
        else:
            remove_keys = {l.lower() for l in norm_labels}
            merged = [l for l in existing if l.lower() not in remove_keys]
        if merged != existing:
            row.labels = _serialize_labels(merged)
            updated += 1
    db.commit()
    return {"selected": len(ids), "updated": updated}


@router.put("/{tx_id}", response_model=BankTransactionResponse)
def update_transaction(tx_id: int, payload: BankTransactionUpdate, db: Session = Depends(get_db)):
    _ensure_labels_column(db)
    obj = db.query(BankTransaction).filter(BankTransaction.id == tx_id).first()
    if not obj:
        raise HTTPException(404, "Transaction not found")
    old_key = (obj.person_id, obj.bank or "", obj.account_type or "")
    data = payload.model_dump(exclude={"balance"})
    if _is_credit_card_payment(data.get("description", ""), data.get("account_type", "")):
        data["labels"] = _serialize_labels([])
    else:
        data["labels"] = _serialize_labels(data.get("labels"))
    for k, v in data.items():
        setattr(obj, k, v)
    db.commit()
    _recalculate_group_balances(db, old_key[0], old_key[1], old_key[2])
    _recalculate_group_balances(db, obj.person_id, obj.bank or "", obj.account_type or "")
    db.commit()
    obj = db.query(BankTransaction).options(joinedload(BankTransaction.person)).filter(BankTransaction.id == tx_id).first()
    return BankTransactionResponse.from_orm_with_person(obj)


@router.delete("/{tx_id}", status_code=204)
def delete_transaction(tx_id: int, db: Session = Depends(get_db)):
    _ensure_labels_column(db)
    obj = db.query(BankTransaction).filter(BankTransaction.id == tx_id).first()
    if not obj:
        raise HTTPException(404, "Transaction not found")
    old_key = (obj.person_id, obj.bank or "", obj.account_type or "")
    db.delete(obj)
    db.commit()
    _recalculate_group_balances(db, old_key[0], old_key[1], old_key[2])
    db.commit()
