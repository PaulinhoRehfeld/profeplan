-- Add 'content' column to curriculos_mg to support Langchain VectorStore
alter table curriculos_mg 
add column if not exists content text;

-- Ensure metadata is jsonb
alter table curriculos_mg 
alter column metadata type jsonb using metadata::jsonb;

-- Ensure embedding is vector(768)
-- This might fail if dimensions differ, but usually we want 768 for Gemini
-- alter table curriculos_mg alter column embedding type vector(768);
