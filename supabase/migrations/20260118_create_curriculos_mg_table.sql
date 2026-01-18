-- Enable the pgvector extension to work with embedding vectors
create extension if not exists vector;

-- Create the table to store curriculum chunks
create table if not exists curriculos_mg (
  id uuid primary key default gen_random_uuid(),
  content text,
  metadata jsonb,
  embedding vector(768) -- Gemini text-embedding-004 uses 768 dimensions
);

-- Index for faster similarity search (IVFFlat)
-- Note: It is recommended to create the index after inserting data for better performance, 
-- but creating it here ensures it exists. The 'lists' parameter can be adjusted based on data size.
create index if not exists curriculos_mg_embedding_idx 
on curriculos_mg 
using ivfflat (embedding vector_cosine_ops)
with (lists = 100);

-- Enable RLS (Row Level Security) if needed, but for now we keep it open for service role access
alter table curriculos_mg enable row level security;

-- Policy to allow read access to authenticated users and service role
create policy "Enable read access for all users"
on curriculos_mg
for select
using (true);

-- Policy to allow insert/update/delete for service role only
create policy "Enable write access for service role"
on curriculos_mg
for all
using (auth.role() = 'service_role');
