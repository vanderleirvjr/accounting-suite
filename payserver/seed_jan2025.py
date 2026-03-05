#!/usr/bin/env python3
"""
Seed script — January 2025 pay stub for Vanderlei
Run AFTER the server is up: docker compose up --build
Then: python3 seed_jan2025.py
"""

import urllib.request
import urllib.error
import json
import sys

BASE_URL = "http://localhost:8000"
PERSON_NAME = "Vanderlei"

# ── January 2025 Pay Stub ─────────────────────────────────────────────────────
#
#  Pay period: 01-Jan-2025 – 31-Jan-2025  |  Payment Date: 31-Jan-2025
#  Annual Salary: $109,080.00
#
#  HOURS AND EARNINGS
#    Regular Salary (184 hrs)              9,090.00
#    LTD Allowance  (employer-paid, taxed)    40.91   ← added to gross, deducted post-tax
#    STD Allowance  (employer-paid, taxed)     4.00   ← added to gross, deducted post-tax
#    Basic Life Imputed Income                 1.60   ← imputed only, deducted post-tax
#    Total Gross                           9,136.51
#
#  PRE-TAX DEDUCTIONS
#    *Fidelity DCP                           727.20
#
#  TAXES
#    Federal Tax                             669.37
#    Medicare                                132.48
#    CO State Tax                            333.00
#    CO State Misc2 Tax (FAMLI/PFML)          41.11
#    Total Taxes                           1,175.96
#
#  AFTER-TAX DEDUCTIONS
#    LTD Post                                 40.91
#    Vol AD&D Post                             0.95
#    STD Post                                  4.00
#    Basic Life Imputed Income                 1.60
#    Total Post-Tax                           47.46
#
#  NET PAY:  9,136.51 − 727.20 − 1,175.96 − 47.46 = $7,185.89
#
#  NOTE: No Employer Paid Benefits section on this stub — all er_ fields = 0.
# ─────────────────────────────────────────────────────────────────────────────

payload = {
    "person_id":          None,           # filled at runtime
    "pay_date":           "2025-01-31",
    "pay_period_start":   "2025-01-01",
    "pay_period_end":     "2025-01-31",
    "notes":              "Jan 2025 — Regular Salary + LTD/STD Allowances + Basic Life Imputed",

    # Income (all earnings items combined)
    "gross":                      9136.51,

    # Pre-Tax Deductions
    "dental_pre":                    0.00,
    "medical_pre":                   0.00,
    "retirement_plan":             727.20,   # *Fidelity DCP
    "park_permit":                   0.00,

    # Taxes
    "federal_taxes":               669.37,   # Federal Tax
    "medicare":                    132.48,
    "social_security":               0.00,   # Not deducted (gov/401a plan)
    "state_tax":                   333.00,   # CO State Tax
    "state_misc2":                  41.11,   # CO State Misc2 Tax (FAMLI/PFML)

    # Post-Tax Deductions
    "ltd_post":                     40.91,   # LTD Post (offsetting LTD Allowance in gross)
    "vol_add_post":                  0.95,   # Vol AD&D Post
    "basic_life_imputed_income":     1.60,   # Basic Life Imputed Income
    "imputed_famli_ee":              0.00,
    "std_post":                      4.00,   # STD Post (offsetting STD Allowance in gross)

    # Miscellaneous
    "tuition":                       0.00,

    # Employer Paid Benefits (not shown on this stub)
    "er_retirement_401a":            0.00,
    "er_basic_life_add":             0.00,
    "er_dental":                     0.00,
    "er_eap":                        0.00,
    "er_hsa":                        0.00,
    "er_ltd":                        0.00,
    "er_medical":                    0.00,
    "er_std":                        0.00,
    "er_other":                      0.00,
}

# Expected net: 9,136.51 - 727.20 - 1,175.96 - 47.46 = 7,185.89
EXPECTED_NET = 7185.89


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

    # ── Step 1: find or create Vanderlei ─────────────────────────────────────
    print(f"\nLooking up person '{PERSON_NAME}'...")
    try:
        person = post("/api/persons/", {"name": PERSON_NAME, "notes": "Primary earner"})
        print(f"  Person created (ID: {person['id']})")
    except urllib.error.HTTPError as e:
        if e.code == 400:
            with urllib.request.urlopen(BASE_URL + "/api/persons/", timeout=5) as r:
                persons = json.loads(r.read())
            person = next((p for p in persons if p["name"] == PERSON_NAME), None)
            if not person:
                print(f"  '{PERSON_NAME}' not found — please create them in the dashboard first.")
                sys.exit(1)
            print(f"  Found '{PERSON_NAME}' (ID: {person['id']})")
        else:
            raise

    payload["person_id"] = person["id"]

    # ── Step 2: insert pay stub ───────────────────────────────────────────────
    print("\nInserting January 2025 pay stub...")
    try:
        result = post("/api/pay-advices/", payload)
        net  = float(result["net_pay"])
        er   = float(result["total_employer_contributions"])
        comp = float(result["total_compensation"])
        diff = abs(net - EXPECTED_NET)

        print(f"\nPay stub created (ID: {result['id']})")
        print(f"  Person                : {result.get('person_name', PERSON_NAME)}")
        print(f"  Pay Date              : {result['pay_date']}")
        print(f"  Gross                 : ${float(result['gross']):>10,.2f}")
        print(f"  -----------------------------------")
        print(f"  Pre-Tax Deductions    : ${float(result['total_pre_tax_deductions']):>10,.2f}")
        print(f"  Taxes                 : ${float(result['total_taxes']):>10,.2f}")
        print(f"  Post-Tax Deductions   : ${float(result['total_post_tax_deductions']):>10,.2f}")
        print(f"  -----------------------------------")
        print(f"  Net Pay               : ${net:>10,.2f}  (expected ${EXPECTED_NET:,.2f})")
        if diff > 0.02:
            print(f"  ⚠ Net pay differs by ${diff:.2f} from pay stub — review the data.")
        else:
            print(f"  Net pay matches pay stub ✓")
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


if __name__ == "__main__":
    main()
