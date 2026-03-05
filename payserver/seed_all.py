#!/usr/bin/env python3
"""
Master seed script — loads ALL pay stubs for Vanderlei in chronological order.

  Jan 2025  →  Feb 2025  →  Feb 2026

Run AFTER the server is up:
    docker compose up --build -d
    python3 seed_all.py
"""

import urllib.request
import urllib.error
import json
import sys

BASE_URL   = "http://localhost:8000"
PERSON_NAME = "Vanderlei"

# ─────────────────────────────────────────────────────────────────────────────
# Pay stub definitions  (chronological order)
# ─────────────────────────────────────────────────────────────────────────────

STUBS = [

    # ── January 2025 ─────────────────────────────────────────────────────────
    {
        "_label": "January 2025",
        "_expected_net": 7185.89,
        "pay_date":         "2025-01-31",
        "pay_period_start": "2025-01-01",
        "pay_period_end":   "2025-01-31",
        "notes": "Jan 2025 — Regular Salary (184 hrs) + LTD/STD Allowances + Basic Life Imputed",

        "gross":              9136.51,   # Regular Salary 9090 + LTD Allow 40.91 + STD Allow 4 + Basic Life 1.60

        "dental_pre":            0.00,
        "medical_pre":           0.00,
        "retirement_plan":     727.20,   # *Fidelity DCP
        "park_permit":           0.00,

        "federal_taxes":       669.37,
        "medicare":            132.48,
        "social_security":       0.00,
        "state_tax":           333.00,   # CO State Tax
        "state_misc2":          41.11,   # CO State Misc2 (FAMLI/PFML)

        "ltd_post":             40.91,
        "vol_add_post":          0.95,
        "basic_life_imputed_income": 1.60,
        "imputed_famli_ee":      0.00,
        "std_post":              4.00,

        "tuition":               0.00,

        "er_retirement_401a":    0.00,   # Employer benefits not shown on this stub
        "er_basic_life_add":     0.00,
        "er_dental":             0.00,
        "er_eap":                0.00,
        "er_hsa":                0.00,
        "er_ltd":                0.00,
        "er_medical":            0.00,
        "er_std":                0.00,
        "er_other":              0.00,
    },

    # ── February 2025 ────────────────────────────────────────────────────────
    {
        "_label": "February 2025",
        "_expected_net": 7185.89,
        "pay_date":         "2025-02-28",
        "pay_period_start": "2025-02-01",
        "pay_period_end":   "2025-02-28",
        "notes": "Feb 2025 — Regular Salary (160 hrs) + LTD/STD Allowances + Basic Life Imputed",

        "gross":              9136.51,

        "dental_pre":            0.00,
        "medical_pre":           0.00,
        "retirement_plan":     727.20,   # *Fidelity DCP
        "park_permit":           0.00,

        "federal_taxes":       669.37,
        "medicare":            132.48,
        "social_security":       0.00,
        "state_tax":           333.00,
        "state_misc2":          41.11,

        "ltd_post":             40.91,
        "vol_add_post":          0.95,
        "basic_life_imputed_income": 1.60,
        "imputed_famli_ee":      0.00,
        "std_post":              4.00,

        "tuition":               0.00,

        "er_retirement_401a":    0.00,
        "er_basic_life_add":     0.00,
        "er_dental":             0.00,
        "er_eap":                0.00,
        "er_hsa":                0.00,
        "er_ltd":                0.00,
        "er_medical":            0.00,
        "er_std":                0.00,
        "er_other":              0.00,
    },

    # ── February 2026 ────────────────────────────────────────────────────────
    {
        "_label": "February 2026",
        "_expected_net": 7215.16,
        "pay_date":         "2026-02-28",
        "pay_period_start": "2026-02-01",
        "pay_period_end":   "2026-02-28",
        "notes": "Feb 2026 — Salary Pay + Imputed Life Insurance",

        "gross":              9091.80,   # Salary 9090 + Basic Life Imputed 1.80

        "dental_pre":            0.00,
        "medical_pre":           0.00,
        "retirement_plan":     727.20,   # 401(a) Fidelity Pre-Tax
        "park_permit":           0.00,

        "federal_taxes":       645.81,   # Federal Withholding
        "medicare":            132.48,
        "social_security":       0.00,
        "state_tax":           330.00,   # State Tax CO
        "state_misc2":          40.20,   # CO FML(P) FAMLI/PFML

        "ltd_post":              0.00,
        "vol_add_post":          0.95,   # Voluntary AD&D SunLife Family
        "basic_life_imputed_income": 1.80,
        "imputed_famli_ee":      0.00,
        "std_post":              0.00,

        "tuition":               0.00,

        "er_retirement_401a": 1090.80,   # 401(a) Fidelity Employer Paid
        "er_basic_life_add":     5.88,   # Basic Life/AD&D
        "er_dental":            25.00,   # Delta Dental Employer
        "er_eap":                1.53,   # EAP ComPsych
        "er_hsa":               41.67,   # HSA Fidelity Employer
        "er_ltd":               40.91,   # Long-Term Disability SunLife
        "er_medical":          745.00,   # Medical Anthem Employer
        "er_std":                4.00,   # Short-Term Disability Employer
        "er_other":              0.00,
    },
]


# ─────────────────────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────────────────────

def http_post(endpoint, data):
    body = json.dumps(data).encode("utf-8")
    req = urllib.request.Request(
        BASE_URL + endpoint,
        data=body,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=10) as resp:
        return json.loads(resp.read())


def get_or_create_person(name):
    try:
        person = http_post("/api/persons/", {"name": name, "notes": "Primary earner"})
        print(f"  Created '{name}' (ID: {person['id']})")
        return person
    except urllib.error.HTTPError as e:
        if e.code == 400:
            with urllib.request.urlopen(BASE_URL + "/api/persons/", timeout=5) as r:
                persons = json.loads(r.read())
            person = next((p for p in persons if p["name"] == name), None)
            if not person:
                print(f"  ERROR: '{name}' not found after conflict — aborting.")
                sys.exit(1)
            print(f"  Found '{name}' (ID: {person['id']})")
            return person
        raise


def check_duplicate(pay_date, person_id):
    """Return True if a stub for this person+date already exists."""
    url = f"{BASE_URL}/api/pay-advices/?person_id={person_id}"
    with urllib.request.urlopen(url, timeout=5) as r:
        stubs = json.loads(r.read())
    return any(s["pay_date"] == pay_date for s in stubs)


# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

def main():
    print("=" * 54)
    print("  PayTracker — Master Seed (all stubs)")
    print("=" * 54)

    # Health check
    print(f"\nConnecting to {BASE_URL} ...")
    try:
        with urllib.request.urlopen(BASE_URL + "/health", timeout=5) as r:
            print("Server:", json.loads(r.read()))
    except Exception as e:
        print(f"Cannot reach server — make sure you ran: docker compose up --build\n{e}")
        sys.exit(1)

    # Ensure person exists
    print(f"\nEnsuring person '{PERSON_NAME}' ...")
    person = get_or_create_person(PERSON_NAME)
    person_id = person["id"]

    # Insert stubs
    inserted = 0
    skipped  = 0

    for stub in STUBS:
        label        = stub.pop("_label")
        expected_net = stub.pop("_expected_net")
        pay_date     = stub["pay_date"]

        print(f"\n── {label} ({pay_date}) ".ljust(54, "─"))

        if check_duplicate(pay_date, person_id):
            print(f"  SKIPPED — already exists for {PERSON_NAME} on {pay_date}")
            skipped += 1
            continue

        stub["person_id"] = person_id
        try:
            result = http_post("/api/pay-advices/", stub)
            net    = float(result["net_pay"])
            er     = float(result["total_employer_contributions"])
            comp   = float(result["total_compensation"])
            diff   = abs(net - expected_net)

            print(f"  ID {result['id']}  |  Gross: ${float(result['gross']):>9,.2f}")
            print(f"  Net Pay: ${net:>9,.2f}  (expected ${expected_net:,.2f})", end="")
            print("  ✓" if diff <= 0.02 else f"  ⚠ differs by ${diff:.2f}")
            if er > 0:
                print(f"  Employer Benefits: ${er:>8,.2f}  |  Total Comp: ${comp:,.2f}")
            inserted += 1

        except urllib.error.HTTPError as e:
            body = e.read().decode()
            print(f"  ERROR {e.code}: {body}")

    print(f"\n{'=' * 54}")
    print(f"  Done — {inserted} inserted, {skipped} skipped.")
    print(f"  Dashboard: {BASE_URL}")
    print("=" * 54)


if __name__ == "__main__":
    main()
