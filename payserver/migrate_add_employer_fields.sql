-- Migration: Add employer paid benefit columns to pay_advices table
-- Run this ONLY if you already started the server before employer fields were added.
-- If this is a fresh install, skip this file — the app creates the table correctly on startup.
--
-- How to run:
--   docker exec -i paytracker-db psql -U payuser paydb < migrate_add_employer_fields.sql

ALTER TABLE pay_advices
  ADD COLUMN IF NOT EXISTS er_retirement_401a NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_basic_life_add  NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_dental          NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_eap             NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_hsa             NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_ltd             NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_medical         NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_std             NUMERIC(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS er_other           NUMERIC(12,2) NOT NULL DEFAULT 0;

-- Verify
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'pay_advices'
  AND column_name LIKE 'er_%'
ORDER BY column_name;
