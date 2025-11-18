-- PostgreSQL initialization script for SpendShare
-- This script runs on first container startup

-- Create database extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Set timezone
SET timezone = 'UTC';

-- Create basic schema (tables will be created by service migrations)
-- This is just to ensure the database is ready
SELECT 'SpendShare database initialized successfully' AS status;
