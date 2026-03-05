#!/usr/bin/env python3
"""
Seed script — February 2026 pay stub (full: employee + employer)
Run AFTER the server is up: docker compose up --build
Then: python3 seed_feb2026.py
"""

import urllib.request
import urllib.error
import json
import sys

BASE_URL = "http://localhost:8000"

# ── February 2026 Pay Stub ────────────────────────────────────────────────────
#
#  Pay period: 02/01/2026 – 02/28/2026
#
#  EARNINGS
#    Salary Pay                                 9,090.00
#    Imputed Income – Basic Life Insurance          1.80
#    Total gross                                9,091.80
#
#  PRE-TAX DEDUCTIONS
#    401(a) Fidelity – Pre-Tax                    727.20
#
#  TAXES
#    Federal Withholding                          645.81
#    Medicare                                     132.48
#    Social Security                                0.00  (gov/401a plan)
#    State Tax – CO                               330.00
#    CO FML(P) – FAMLI/PFML                        40.20
#    Total taxes                                1,148.49
#
#  POST-TAX DEDUCTIONS
#    Voluntary AD&D – SunLife Family                0.95
#
#  EMPLOYER PAID BENEFITS
#    401(a) Fidelity – Employer Paid            1,090.80
#    Basic Life / AD&D                              5.88
#    Dental – Delta – Employer                     25.00
#    EAP – ComPsych                                 1.53
#    HSA – Fidelity – Employer Paid                41.67
#    Long-Term Disability – SunLife                40.91
#    Medical – Anthem – Employer Paid             745.00
#    Short-Term Disability – Employer               4.00
#    Total employer                             1,954.79
#
#  NET PAY (employee):  9,091.80 - 727.20 - 1,148.49 - 0.95 = $7,215.16
#  TOTAL COMPENSATION:  7,215.16 + 1,954.79 = $9,169.95
# ─────────────────────────────────────────────────────────────────────────────

payload = {
    "pay_date":           "2026-02-28",
    "person_id":          None,          # filled in at runtime after person is created
    "pay_period_start":   "2026-02-01",
    "pay_period_end":     "2026-02-28",
    "notes":              "Feb 2026 — Salary Pay + Imputed Life Insurance",

    # Income
    "gross":                      9091.80,

    # Pre-Tax Deductions
    "dental_pre":                    0.00,   # Dental under Employer Paid (not employee pre-tax)
    "medical_pre":                   0.00,   # Medical under Employer Paid (not employee pre-tax)
    "retirement_plan":             727.20,   # 401(a) Fidelity - Pre-Tax
    "park_permit":                   0.00,

    # Taxes
    "federal_taxes":               645.81,   # Federal Withholding
    "medicare":                    132.48,
    "social_security":               0.00,   # Not deducted (gov/401a plan)
    "state_tax":                   330.00,   # State Tax - CO
    "state_misc2":                  40.20,   # CO FML(P) - FAMLI/PFML

    # Post-Tax Deductions
    "ltd_post":                      0.00,   # LTD is Employer Paid here
    "vol_add_post":                  0.95,   # Voluntary AD&D - SunLife Family
    "basic_life_imputed_income":     1.80,   # Imputed Income - Basic Life Insurance
    "imputed_famli_ee":              0.00,
    "std_post":                      0.00,   # STD is Employer Paid here

    # Miscellaneous
    "tuition":                       0.00,

    # Employer Paid Benefits
    "er_retirement_401a":         1090.80,   # 401(a) Fidelity - Employer Paid
    "er_basic_life_add":             5.88,   # Basic Life/AD&D
    "er_dental":                    25.00,   # Dental - Delta - Employer
    "er_eap":                        1.53,   # EAP - ComPsych
    "er_hsa":                       41.67,   # HSA - Fidelity - Employer Paid
    "er_ltd":                       40.91,   # Long-Term Disability - SunLife
    "er_medical":                  745.00,   # Medical - Anthem - Employer Paid
    "er_std":                        4.00,   # Short-Term Disability - Employer
    "er_other":                      0.00,
}


def post(endpoint, data):
    body = json.dumps(data).encode("utf-8")
    req = urllib.request.Request(
        BASE_URL + endpoint,
        data=body,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=10) as resp:
        return json.loads(resp.read())


def main():
    print("Connecting to", BASE_URL, "...")
    try:
        with urllib.request.urlopen(BASE_URL + "/health", timeout=5) as r:
            status = json.loads(r.read())
        print("Server is up:", status)
    except Exception as e:
        print(f"Cannot reach server at {BASE_URL}")
        print(f"Make sure you ran: docker compose up --build")
        print(f"Error: {e}")
        sys.exit(1)

    # ── Step 1: create or retrieve person ────────────────────────────────────
    PERSON_NAME = "Vanderlei"
    print(f"\nEnsuring person '{PERSON_NAME}' exists...")
    try:
        person = post("/api/persons/", {"name": PERSON_NAME, "notes": "Primary earner"})
        print(f"  Person created (ID: {person['id']})")
    except urllib.error.HTTPError as e:
        if e.code == 400:
            # Already exists — fetch list and find by name
            with urllib.request.urlopen(BASE_URL + "/api/persons/", timeout=5) as r:
                persons = json.loads(r.read())
            person = next((p for p in persons if p['name'] == PERSON_NAME), None)
            if not person:
                print(f"Person '{PERSON_NAME}' exists but could not be found.")
                sys.exit(1)
            print(f"  Person already exists (ID: {person['id']})")
        else:
            raise

    payload["person_id"] = person["id"]

    # ── Step 2: insert pay stub ───────────────────────────────────────────────
    print("\nInserting February 2026 pay stub (employee + employer)...")
    try:
        result = post("/api/pay-advices/", payload)
        er   = float(result['total_employer_contributions'])
        net  = float(result['net_pay'])
        comp = float(result['total_compensation'])

        print(f"\nPay stub created (ID: {result['id']})")
        print(f"  Pay Date              : {result['pay_date']}")
        print(f"  Gross Pay             : ${float(result['gross']):>10,.2f}")
        print(f"  -----------------------------------")
        print(f"  Pre-Tax Deductions    : ${float(result['total_pre_tax_deductions']):>10,.2f}")
        print(f"  Taxes                 : ${float(result['total_taxes']):>10,.2f}")
        print(f"  Post-Tax Deductions   : ${float(result['total_post_tax_deductions']):>10,.2f}")
        print(f"  -----------------------------------")
        print(f"  Net Pay               : ${net:>10,.2f}")
        print(f"  -----------------------------------")
        print(f"  + Employer Benefits   : ${er:>10,.2f}")
        print(f"  ===================================")
        print(f"  Total Compensation    : ${comp:>10,.2f}")
        print(f"\nOpen your dashboard: http://localhost:8000")
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"API error {e.code}: {body}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)
    # ── end pay stub insert ───────────────────────────────────────────────────


if __name__ == "__main__":
    main()
