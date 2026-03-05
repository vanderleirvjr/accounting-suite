#!/usr/bin/env python3
"""
Seed pay advices for Vanderlei from screenshots.

Run AFTER the server is up:
    docker compose up --build -d
    python3 seed_screenshots_vanderlei.py
"""

import json
import sys
import urllib.error
import urllib.request

BASE_URL = "http://localhost:8000"
PERSON_NAME = "Vanderlei"


STUBS = [
    # 2022 (from screenshots currently available)
    {"pay_date": "2022-03-04", "pay_period_start": "2022-03-01", "pay_period_end": "2022-03-31",
     "notes": "From screenshot 2022-03-04",
     "gross": 3838.08, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 304.35, "park_permit": 0.00,
     "federal_taxes": 137.54, "medicare": 55.65, "social_security": 0.00, "state_tax": 130.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.00, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-04-29", "pay_period_start": "2022-04-01", "pay_period_end": "2022-04-30",
     "notes": "From screenshot 2022-04-29",
     "gross": 17588.08, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 804.35, "park_permit": 0.00,
     "federal_taxes": 2426.81, "medicare": 251.06, "social_security": 0.00, "state_tax": 721.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-05-31", "pay_period_start": "2022-05-01", "pay_period_end": "2022-05-31",
     "notes": "From screenshot 2022-05-31",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 44.67,
     "federal_taxes": 362.56, "medicare": 86.49, "social_security": 0.00, "state_tax": 218.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-06-30", "pay_period_start": "2022-06-01", "pay_period_end": "2022-06-30",
     "notes": "From screenshot 2022-06-30",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 44.67,
     "federal_taxes": 362.56, "medicare": 86.49, "social_security": 0.00, "state_tax": 218.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-07-29", "pay_period_start": "2022-07-01", "pay_period_end": "2022-07-31",
     "notes": "From screenshot 2022-07-29",
     "gross": 2479.38, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 195.65, "park_permit": 44.66,
     "federal_taxes": 0.00, "medicare": 31.33, "social_security": 0.00, "state_tax": 59.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-08-31", "pay_period_start": "2022-08-01", "pay_period_end": "2022-08-31",
     "notes": "From screenshot 2022-08-31",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 0.00,
     "federal_taxes": 367.92, "medicare": 87.14, "social_security": 0.00, "state_tax": 220.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-09-30", "pay_period_start": "2022-09-01", "pay_period_end": "2022-09-30",
     "notes": "From screenshot 2022-09-30",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 0.00,
     "federal_taxes": 367.92, "medicare": 87.15, "social_security": 0.00, "state_tax": 220.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-10-31", "pay_period_start": "2022-10-01", "pay_period_end": "2022-10-31",
     "notes": "From screenshot 2022-10-31",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 0.00,
     "federal_taxes": 367.92, "medicare": 87.14, "social_security": 0.00, "state_tax": 220.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-11-30", "pay_period_start": "2022-11-01", "pay_period_end": "2022-11-30",
     "notes": "From screenshot 2022-11-30",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 0.00,
     "federal_taxes": 367.92, "medicare": 87.14, "social_security": 0.00, "state_tax": 220.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2022-12-30", "pay_period_start": "2022-12-01", "pay_period_end": "2022-12-31",
     "notes": "From screenshot 2022-12-30",
     "gross": 6283.73, "dental_pre": 10.00, "medical_pre": 264.00, "retirement_plan": 500.00, "park_permit": 63.00,
     "federal_taxes": 360.36, "medicare": 86.23, "social_security": 0.00, "state_tax": 217.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},

    # 2023
    {"pay_date": "2023-01-31", "pay_period_start": "2023-01-01", "pay_period_end": "2023-01-31",
     "notes": "From screenshot 2023-01-31",
     "gross": 6308.40, "dental_pre": 10.00, "medical_pre": 277.00, "retirement_plan": 500.00, "park_permit": 38.29,
     "federal_taxes": 364.72, "medicare": 86.76, "social_security": 0.00, "state_tax": 219.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 24.67, "tuition": 0.00},
    {"pay_date": "2023-02-28", "pay_period_start": "2023-02-01", "pay_period_end": "2023-02-28",
     "notes": "From screenshot 2023-02-28",
     "gross": 6308.40, "dental_pre": 10.00, "medical_pre": 277.00, "retirement_plan": 500.00, "park_permit": 38.29,
     "federal_taxes": 344.31, "medicare": 86.75, "social_security": 0.00, "state_tax": 208.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 24.67, "tuition": 0.00},
    {"pay_date": "2023-03-31", "pay_period_start": "2023-03-01", "pay_period_end": "2023-03-31",
     "notes": "From screenshot 2023-03-31",
     "gross": 6308.45, "dental_pre": 10.00, "medical_pre": 277.00, "retirement_plan": 500.00, "park_permit": 25.42,
     "federal_taxes": 345.86, "medicare": 86.94, "social_security": 0.00, "state_tax": 209.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 24.72, "tuition": 0.00},
    {"pay_date": "2023-04-28", "pay_period_start": "2023-04-01", "pay_period_end": "2023-04-30",
     "notes": "From screenshot 2023-04-28",
     "gross": 6308.57, "dental_pre": 10.00, "medical_pre": 277.00, "retirement_plan": 500.00, "park_permit": 0.00,
     "federal_taxes": 348.92, "medicare": 87.32, "social_security": 0.00, "state_tax": 210.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 24.84, "tuition": 0.00},
    {"pay_date": "2023-05-31", "pay_period_start": "2023-05-01", "pay_period_end": "2023-05-31",
     "notes": "From screenshot 2023-05-31",
     "gross": 6309.87, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 500.00, "park_permit": 0.00,
     "federal_taxes": 383.52, "medicare": 91.49, "social_security": 0.00, "state_tax": 223.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 26.14, "tuition": 0.00},
    {"pay_date": "2023-06-30", "pay_period_start": "2023-06-01", "pay_period_end": "2023-06-30",
     "notes": "From screenshot 2023-06-30 (regular + retro rows combined)",
     "gross": 8192.67, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 650.00, "park_permit": 0.00,
     "federal_taxes": 383.52, "medicare": 118.79, "social_security": 0.00, "state_tax": 266.00, "state_misc2": 0.00,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 33.94, "tuition": 0.00},
    {"pay_date": "2023-07-31", "pay_period_start": "2023-07-01", "pay_period_end": "2023-07-31",
     "notes": "From screenshot 2023-07-31",
     "gross": 10908.73, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 870.00, "park_permit": 0.00,
     "federal_taxes": 918.60, "medicare": 158.18, "social_security": 0.00, "state_tax": 409.00, "state_misc2": 45.17,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2023-08-31", "pay_period_start": "2023-08-01", "pay_period_end": "2023-08-31",
     "notes": "From screenshot 2023-08-31",
     "gross": 9033.73, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 720.00, "park_permit": 0.00,
     "federal_taxes": 683.98, "medicare": 130.99, "social_security": 0.00, "state_tax": 333.00, "state_misc2": 37.40,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2023-09-29", "pay_period_start": "2023-09-01", "pay_period_end": "2023-09-30",
     "notes": "Inferred from 2023-08 and 2023-10 YTD values (September screenshot duplicated August)",
     "gross": 9033.73, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 720.00, "park_permit": 0.00,
     "federal_taxes": 683.98, "medicare": 130.99, "social_security": 0.00, "state_tax": 333.00, "state_misc2": 37.40,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2023-10-31", "pay_period_start": "2023-10-01", "pay_period_end": "2023-10-31",
     "notes": "From screenshot 2023-10-31",
     "gross": 9033.73, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 720.00, "park_permit": 0.00,
     "federal_taxes": 683.98, "medicare": 130.99, "social_security": 0.00, "state_tax": 333.00, "state_misc2": 37.40,
     "ltd_post": 28.13, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 0.00},
    {"pay_date": "2023-11-30", "pay_period_start": "2023-11-01", "pay_period_end": "2023-11-30",
     "notes": "From screenshot 2023-11-30",
     "gross": 9897.10, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 720.00, "park_permit": 0.00,
     "federal_taxes": 787.59, "medicare": 143.50, "social_security": 0.00, "state_tax": 371.00, "state_misc2": 41.29,
     "ltd_post": 40.50, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 851.00},
    {"pay_date": "2023-12-29", "pay_period_start": "2023-12-01", "pay_period_end": "2023-12-31",
     "notes": "From screenshot 2023-12-29",
     "gross": 9897.10, "dental_pre": 0.00, "medical_pre": 0.00, "retirement_plan": 720.00, "park_permit": 0.00,
     "federal_taxes": 787.59, "medicare": 143.51, "social_security": 0.00, "state_tax": 371.00, "state_misc2": 41.29,
     "ltd_post": 40.50, "vol_add_post": 0.95, "std_post": 4.00,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "tuition": 851.00},

    # 2024
    {"pay_date": "2024-01-31", "pay_period_start": "2024-01-01", "pay_period_end": "2024-01-31",
     "notes": "From screenshot 2024-01-31",
     "gross": 9897.10, "retirement_plan": 720.00, "federal_taxes": 787.59, "medicare": 143.51, "social_security": 0.00,
     "state_tax": 371.00, "state_misc2": 44.53, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 851.00, "std_post": 4.00},
    {"pay_date": "2024-02-29", "pay_period_start": "2024-02-01", "pay_period_end": "2024-02-29",
     "notes": "From screenshot 2024-02-29",
     "gross": 9090.00, "retirement_plan": 720.00, "federal_taxes": 673.73, "medicare": 131.80, "social_security": 0.00,
     "state_tax": 332.00, "state_misc2": 40.91, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 43.90, "std_post": 4.00},
    {"pay_date": "2024-03-29", "pay_period_start": "2024-03-01", "pay_period_end": "2024-03-31",
     "notes": "From screenshot 2024-03-29",
     "gross": 9046.10, "retirement_plan": 720.00, "federal_taxes": 668.47, "medicare": 131.17, "social_security": 0.00,
     "state_tax": 330.00, "state_misc2": 40.71, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-04-30", "pay_period_start": "2024-04-01", "pay_period_end": "2024-04-30",
     "notes": "From screenshot 2024-04-30",
     "gross": 9046.10, "retirement_plan": 720.00, "federal_taxes": 668.47, "medicare": 131.17, "social_security": 0.00,
     "state_tax": 330.00, "state_misc2": 40.71, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-05-31", "pay_period_start": "2024-05-01", "pay_period_end": "2024-05-31",
     "notes": "From screenshot 2024-05-31",
     "gross": 9046.10, "retirement_plan": 720.00, "federal_taxes": 668.47, "medicare": 131.17, "social_security": 0.00,
     "state_tax": 330.00, "state_misc2": 40.71, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-06-28", "pay_period_start": "2024-06-01", "pay_period_end": "2024-06-30",
     "notes": "From screenshot 2024-06-28",
     "gross": 9046.10, "retirement_plan": 720.00, "federal_taxes": 668.47, "medicare": 131.17, "social_security": 0.00,
     "state_tax": 330.00, "state_misc2": 40.71, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-07-31", "pay_period_start": "2024-07-01", "pay_period_end": "2024-07-31",
     "notes": "From screenshot 2024-07-31",
     "gross": 9136.10, "retirement_plan": 727.20, "federal_taxes": 678.40, "medicare": 132.47, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-08-30", "pay_period_start": "2024-08-01", "pay_period_end": "2024-08-31",
     "notes": "From screenshot 2024-08-30",
     "gross": 9136.10, "retirement_plan": 727.20, "federal_taxes": 678.40, "medicare": 132.47, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-09-30", "pay_period_start": "2024-09-01", "pay_period_end": "2024-09-30",
     "notes": "From screenshot 2024-09-30",
     "gross": 9136.10, "retirement_plan": 727.20, "federal_taxes": 678.40, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2024-10-31", "pay_period_start": "2024-10-01", "pay_period_end": "2024-10-31",
     "notes": "From screenshot 2024-10-31",
     "gross": 10854.10, "retirement_plan": 727.20, "federal_taxes": 884.56, "medicare": 157.38, "social_security": 0.00,
     "state_tax": 409.00, "state_misc2": 48.84, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 1718.00, "std_post": 4.00},
    {"pay_date": "2024-11-29", "pay_period_start": "2024-11-01", "pay_period_end": "2024-11-30",
     "notes": "From screenshot 2024-11-29",
     "gross": 10854.10, "retirement_plan": 727.20, "federal_taxes": 884.56, "medicare": 157.39, "social_security": 0.00,
     "state_tax": 409.00, "state_misc2": 48.84, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 1718.00, "std_post": 4.00},
    {"pay_date": "2024-12-31", "pay_period_start": "2024-12-01", "pay_period_end": "2024-12-31",
     "notes": "From screenshot 2024-12-31",
     "gross": 10854.10, "retirement_plan": 727.20, "federal_taxes": 884.56, "medicare": 157.38, "social_security": 0.00,
     "state_tax": 409.00, "state_misc2": 48.84, "ltd_post": 40.50, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 1718.00, "std_post": 4.00},

    # 2025 (from screenshots: Mar-Aug)
    {"pay_date": "2025-03-31", "pay_period_start": "2025-03-01", "pay_period_end": "2025-03-31",
     "notes": "From screenshot 2025-03-31",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2025-04-30", "pay_period_start": "2025-04-01", "pay_period_end": "2025-04-30",
     "notes": "From screenshot 2025-04-30",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2025-05-30", "pay_period_start": "2025-05-01", "pay_period_end": "2025-05-31",
     "notes": "From screenshot 2025-05-30",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2025-06-30", "pay_period_start": "2025-06-01", "pay_period_end": "2025-06-30",
     "notes": "From screenshot 2025-06-30",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2025-07-31", "pay_period_start": "2025-07-01", "pay_period_end": "2025-07-31",
     "notes": "From screenshot 2025-07-31",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2025-08-29", "pay_period_start": "2025-08-01", "pay_period_end": "2025-08-31",
     "notes": "From screenshot 2025-08-29",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.48, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00},
    {"pay_date": "2025-09-30", "pay_period_start": "2025-09-01", "pay_period_end": "2025-09-30",
     "notes": "From screenshot 2025-09-30",
     "gross": 9136.51, "retirement_plan": 727.20, "federal_taxes": 669.37, "medicare": 132.47, "social_security": 0.00,
     "state_tax": 333.00, "state_misc2": 41.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00, "tuition": 0.00},
    {"pay_date": "2025-10-15", "pay_period_start": "2025-10-01", "pay_period_end": "2025-10-31",
     "notes": "From screenshot 2025-10-15 (FAMLI-only slip)",
     "gross": 2648.42, "retirement_plan": 0.00, "federal_taxes": 14.84, "medicare": 38.41, "social_security": 0.00,
     "state_tax": 0.00, "state_misc2": 0.00, "ltd_post": 0.00, "vol_add_post": 0.00,
     "basic_life_imputed_income": 0.00, "imputed_famli_ee": 0.00, "std_post": 0.00, "tuition": 0.00},
    {"pay_date": "2025-10-31", "pay_period_start": "2025-10-01", "pay_period_end": "2025-10-31",
     "notes": "From screenshot 2025-10-31",
     "gross": 7339.09, "retirement_plan": 515.33, "federal_taxes": 479.10, "medicare": 106.41, "social_security": 0.00,
     "state_tax": 264.00, "state_misc2": 33.03, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00, "tuition": 851.00},
    {"pay_date": "2025-11-03", "pay_period_start": "2025-10-01", "pay_period_end": "2025-10-31",
     "notes": "From screenshot 2025-11-03 (FAMLI-only slip)",
     "gross": 2648.42, "retirement_plan": 0.00, "federal_taxes": 14.84, "medicare": 38.41, "social_security": 0.00,
     "state_tax": 0.00, "state_misc2": 0.00, "ltd_post": 0.00, "vol_add_post": 0.00,
     "basic_life_imputed_income": 0.00, "imputed_famli_ee": 0.00, "std_post": 0.00, "tuition": 0.00},
    {"pay_date": "2025-11-13", "pay_period_start": "2025-11-01", "pay_period_end": "2025-11-30",
     "notes": "From screenshot 2025-11-13 (FAMLI-only slip)",
     "gross": 2648.42, "retirement_plan": 0.00, "federal_taxes": 14.84, "medicare": 38.40, "social_security": 0.00,
     "state_tax": 0.00, "state_misc2": 0.00, "ltd_post": 0.00, "vol_add_post": 0.00,
     "basic_life_imputed_income": 0.00, "imputed_famli_ee": 0.00, "std_post": 0.00, "tuition": 0.00},
    {"pay_date": "2025-11-28", "pay_period_start": "2025-11-01", "pay_period_end": "2025-11-30",
     "notes": "From screenshot 2025-11-28",
     "gross": 4690.67, "retirement_plan": 303.45, "federal_taxes": 188.72, "medicare": 68.01, "social_security": 0.00,
     "state_tax": 156.00, "state_misc2": 21.11, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00, "tuition": 851.00},
    {"pay_date": "2025-12-01", "pay_period_start": "2025-11-01", "pay_period_end": "2025-11-30",
     "notes": "From screenshot 2025-12-01 (FAMLI-only slip)",
     "gross": 2648.42, "retirement_plan": 0.00, "federal_taxes": 14.84, "medicare": 38.40, "social_security": 0.00,
     "state_tax": 0.00, "state_misc2": 0.00, "ltd_post": 0.00, "vol_add_post": 0.00,
     "basic_life_imputed_income": 0.00, "imputed_famli_ee": 0.00, "std_post": 0.00, "tuition": 0.00},
    {"pay_date": "2025-12-15", "pay_period_start": "2025-12-01", "pay_period_end": "2025-12-31",
     "notes": "From screenshot with cropped header/date not visible; date inferred from YTD continuity",
     "gross": 5296.84, "retirement_plan": 0.00, "federal_taxes": 29.68, "medicare": 76.81, "social_security": 0.00,
     "state_tax": 0.00, "state_misc2": 0.00, "ltd_post": 0.00, "vol_add_post": 0.00,
     "basic_life_imputed_income": 0.00, "imputed_famli_ee": 0.00, "std_post": 0.00, "tuition": 0.00},
    {"pay_date": "2025-12-31", "pay_period_start": "2025-12-01", "pay_period_end": "2025-12-31",
     "notes": "From screenshot 2025-12-31",
     "gross": 2042.25, "retirement_plan": 91.58, "federal_taxes": 0.00, "medicare": 29.61, "social_security": 0.00,
     "state_tax": 49.00, "state_misc2": 9.19, "ltd_post": 40.91, "vol_add_post": 0.95,
     "basic_life_imputed_income": 1.60, "imputed_famli_ee": 0.00, "std_post": 4.00, "tuition": 851.00},
]


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


def get_json(url):
    with urllib.request.urlopen(url, timeout=10) as resp:
        return json.loads(resp.read())


def get_or_create_person(name):
    try:
        return http_post("/api/persons/", {"name": name, "notes": "Primary earner"})
    except urllib.error.HTTPError as e:
        if e.code != 400:
            raise
        persons = get_json(BASE_URL + "/api/persons/")
        person = next((p for p in persons if p["name"] == name), None)
        if not person:
            raise RuntimeError(f"Could not find person '{name}' after conflict.")
        return person


def exists_stub(person_id, pay_date):
    stubs = get_json(f"{BASE_URL}/api/pay-advices/?person_id={person_id}&limit=500")
    return any(s["pay_date"] == pay_date for s in stubs)


def build_payload(stub, person_id):
    payload = {
        "person_id": person_id,
        "pay_date": stub["pay_date"],
        "pay_period_start": stub["pay_period_start"],
        "pay_period_end": stub["pay_period_end"],
        "notes": stub["notes"],
        "gross": stub["gross"],

        # Pre-tax deductions
        "dental_pre": stub.get("dental_pre", 0.00),
        "medical_pre": stub.get("medical_pre", 0.00),
        "retirement_plan": stub["retirement_plan"],
        "park_permit": stub.get("park_permit", 0.00),

        # Taxes
        "federal_taxes": stub["federal_taxes"],
        "medicare": stub["medicare"],
        "social_security": stub["social_security"],
        "state_tax": stub["state_tax"],
        "state_misc2": stub["state_misc2"],

        # Post-tax deductions
        "ltd_post": stub["ltd_post"],
        "vol_add_post": stub["vol_add_post"],
        "basic_life_imputed_income": stub["basic_life_imputed_income"],
        "imputed_famli_ee": stub["imputed_famli_ee"],
        "std_post": stub["std_post"],

        # Misc
        "tuition": stub.get("tuition", 0.00),

        # Employer-paid (not shown in screenshots)
        "er_retirement_401a": 0.00,
        "er_basic_life_add": 0.00,
        "er_dental": 0.00,
        "er_eap": 0.00,
        "er_hsa": 0.00,
        "er_ltd": 0.00,
        "er_medical": 0.00,
        "er_std": 0.00,
        "er_other": 0.00,
    }
    return payload


def main():
    try:
        get_json(BASE_URL + "/health")
    except Exception as e:
        print(f"Cannot reach API at {BASE_URL}: {e}")
        print("Start it first with: docker compose up --build -d")
        sys.exit(1)

    person = get_or_create_person(PERSON_NAME)
    person_id = person["id"]
    inserted = 0
    skipped = 0

    for stub in STUBS:
        if exists_stub(person_id, stub["pay_date"]):
            print(f"SKIP  {stub['pay_date']} (already exists)")
            skipped += 1
            continue

        payload = build_payload(stub, person_id)
        result = http_post("/api/pay-advices/", payload)
        print(f"ADD   {result['pay_date']} id={result['id']} net={result['net_pay']}")
        inserted += 1

    print(f"Done: inserted={inserted}, skipped={skipped}")


if __name__ == "__main__":
    main()
