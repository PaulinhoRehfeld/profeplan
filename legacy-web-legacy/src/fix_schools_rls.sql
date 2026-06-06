-- Enable RLS on schools if not already
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;

-- Allow ANY authenticated user to SELECT from schools (needed for the search dropdown)
CREATE POLICY "Enable read access for all users"
ON schools FOR SELECT
TO authenticated
USING (true);

-- Just in case it was created restricted before, drop conflicting policies if you want (optional)
-- DROP POLICY IF EXISTS "..." ON schools;

-- Insert a test school if none exists (Double check)
INSERT INTO schools (id, name, city, sre, created_at)
VALUES 
    ('test-school-1', 'Escola Estadual Exemplo', 'Belo Horizonte', 'Metropolitana A', NOW())
ON CONFLICT DO NOTHING;
