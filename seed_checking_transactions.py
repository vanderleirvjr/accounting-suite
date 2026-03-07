#!/usr/bin/env python3
"""
Parse checking.pdf and seed Capital One checking transactions for Vanderlei.

Run after server is up:
    docker compose up --build -d
    python3 seed_checking_transactions.py
"""

import re
import sys
from collections import Counter
from datetime import date
from pathlib import Path

from pypdf import PdfReader
from sqlalchemy import extract

from app.database import SessionLocal
from app.models import BankTransaction, Person

PDF_PATH = Path("checking.pdf")
PERSON_NAME = "Vanderlei"
BANK = "Capital One"
ACCOUNT_TYPE = "checking"
TARGET_YEARS = {2023}

MONTHS = {m: i for i, m in enumerate(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], 1)}
YEAR_HDR_RE = re.compile(r"^(20\d{2}) Transactions$")
AMOUNT_RE = re.compile(r"([+-])\$([\d,]+\.\d{2})")
DOLLAR_RE = re.compile(r"\$([\d,]+\.\d{2})")


def get_or_create_person(db, name):
    p = db.query(Person).filter(Person.name == name).first()
    if p:
        return p
    p = Person(name=name, notes="Primary earner")
    db.add(p)
    db.commit()
    db.refresh(p)
    return p


def parse_transactions(pdf_path: Path):
    if not pdf_path.exists():
        raise FileNotFoundError(f"PDF not found: {pdf_path}")

    pages = [(p.extract_text() or "") for p in PdfReader(str(pdf_path)).pages]
    rows = []
    current_year = None

    for text in pages:
        lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
        cleaned = []
        for ln in lines:
            if "Capital One" in ln and "AM" in ln:
                continue
            if ln.startswith("https://") or "myaccounts.capitalone.com" in ln:
                continue
            if re.fullmatch(r"\d+/\d+", ln):
                continue
            if ln in {
                "Past Transactions Download Transactions",
                "DATE DESCRIPTION AMOUNT BALANCE",
                "Search amount, date, check # or transaction description  Filter",
            }:
                continue
            cleaned.append(ln)
        lines = cleaned

        i = 0
        while i < len(lines):
            m = YEAR_HDR_RE.match(lines[i])
            if m:
                current_year = int(m.group(1))
                i += 1
                continue

            if lines[i] in MONTHS and i + 1 < len(lines) and lines[i + 1].isdigit():
                month = MONTHS[lines[i]]
                day = int(lines[i + 1])
                j = i + 2
                desc = []
                amount = None
                balance = None

                while j < len(lines):
                    ln = lines[j]
                    if YEAR_HDR_RE.match(ln):
                        break
                    am = AMOUNT_RE.search(ln)
                    if am:
                        sign = -1 if am.group(1) == "-" else 1
                        amount = sign * float(am.group(2).replace(",", ""))
                        dollars = DOLLAR_RE.findall(ln)
                        if len(dollars) >= 2:
                            balance = float(dollars[-1].replace(",", ""))
                        elif len(dollars) == 1 and j + 1 < len(lines):
                            nxt = DOLLAR_RE.fullmatch(lines[j + 1])
                            if nxt:
                                balance = float(nxt.group(1).replace(",", ""))
                                j += 1
                        j += 1
                        break
                    desc.append(ln)
                    j += 1

                if amount is not None and current_year in TARGET_YEARS:
                    try:
                        d = date(current_year, month, day)
                    except ValueError:
                        i = j
                        continue
                    description = re.sub(r"\s+", " ", " ".join(desc)).strip()
                    rows.append(
                        {
                            "tx_date": d.isoformat(),
                            "description": description or "Transaction",
                            "amount": round(amount, 2),
                            "balance": round(balance, 2) if balance is not None else None,
                            "account_type": ACCOUNT_TYPE,
                            "bank": BANK,
                            "notes": f"Imported from {pdf_path.name}",
                        }
                    )
                    i = j
                    continue
            i += 1
    return rows


def existing_keys(db, person_id: int):
    keys = set()
    items = (
        db.query(BankTransaction)
        .filter(BankTransaction.person_id == person_id)
        .filter(extract("year", BankTransaction.tx_date).in_(TARGET_YEARS))
        .all()
    )
    for t in items:
            key = (
                t.tx_date.isoformat(),
                (t.description or "").strip(),
                round(float(t.amount), 2),
            )
            keys.add(key)
    return keys


def main():
    db = SessionLocal()
    person = get_or_create_person(db, PERSON_NAME)
    person_id = person.id
    parsed = parse_transactions(PDF_PATH)
    if not parsed:
        print("No transactions parsed from PDF.")
        db.close()
        sys.exit(1)

    by_year = Counter(row["tx_date"][:4] for row in parsed)
    print(f"Parsed: {len(parsed)} rows | by year: {dict(by_year)}")

    existing = existing_keys(db, person_id)
    inserted = 0
    skipped = 0

    for row in parsed:
        key = (
            row["tx_date"],
            row["description"],
            row["amount"],
        )
        if key in existing:
            skipped += 1
            continue
        tx = BankTransaction(
            person_id=person_id,
            tx_date=date.fromisoformat(row["tx_date"]),
            description=row["description"],
            amount=row["amount"],
            balance=row["balance"],
            account_type=row["account_type"],
            bank=row["bank"],
            notes=row["notes"],
        )
        db.add(tx)
        existing.add(key)
        inserted += 1

    db.commit()
    db.close()
    print(f"Done: inserted={inserted}, skipped={skipped}")


if __name__ == "__main__":
    main()
