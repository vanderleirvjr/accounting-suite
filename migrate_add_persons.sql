-- Migration: Add persons table and person_id FK to pay_advices
-- Run ONLY if you already had a running database before this feature was added.
-- Fresh installs: skip this — the app creates everything on startup.
--
-- How to run:
--   docker exec -i paytracker-db psql -U payuser paydb < migrate_add_persons.sql

-- 1. Create persons table
CREATE TABLE IF NOT EXISTS persons (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    notes      TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Add person_id column to pay_advices (nullable so existing rows aren't broken)
ALTER TABLE pay_advices
    ADD COLUMN IF NOT EXISTS person_id INTEGER REFERENCES persons(id);

CREATE INDEX IF NOT EXISTS ix_pay_advices_person_id ON pay_advices(person_id);

-- Verify
SELECT 'persons table' AS check, count(*) FROM persons
UNION ALL
SELECT 'pay_advices with person_id', count(*) FROM pay_advices WHERE person_id IS NOT NULL;
