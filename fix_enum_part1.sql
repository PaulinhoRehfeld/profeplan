-- ==============================================================================
-- PART 1: FIX ENUM (RUN THIS FIRST)
-- ==============================================================================
-- This adds the value 'admin' to the user_role type.
-- Postgres requires this to be committed before it can be used in data.

ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'admin';
