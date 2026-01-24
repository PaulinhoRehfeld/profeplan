-- ==============================================================================
-- MASTER SCHEMA FOR PROFEPLAN-DEV (CORRIGIDO)
-- Data: 2026-01-22
-- Ordem: Extensões -> Tabelas -> Seeds -> Policies (para evitar erro de dependência)
-- ==============================================================================

-- 1. ENABLE EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 2. CREATE TABLES (Structure First)

-- 2.1 Schools
CREATE TABLE IF NOT EXISTS schools (
    id TEXT PRIMARY KEY, -- INEP Code
    name TEXT NOT NULL,
    city TEXT,
    sre TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.2 Profiles (Dep: Schools)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) NOT NULL PRIMARY KEY,
    school_id TEXT REFERENCES schools(id), -- Nullable initially
    full_name TEXT,
    email TEXT,
    avatar_url TEXT,
    role TEXT DEFAULT 'teacher' CHECK (role IN ('teacher', 'school_manager', 'school_admin', 'admin')),
    tier TEXT DEFAULT 'FREE',
    credits INTEGER DEFAULT 10,
    is_unlimited BOOLEAN DEFAULT false,
    is_admin BOOLEAN DEFAULT false,
    allowed_features TEXT[],
    phone TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE
);

-- 2.3 Classes
CREATE TABLE IF NOT EXISTS classes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    name TEXT NOT NULL,
    subject TEXT,
    grade_level TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.4 Students (Teacher Personal)
CREATE TABLE IF NOT EXISTS students (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    class_id UUID REFERENCES classes(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.5 School Students (Official)
CREATE TABLE IF NOT EXISTS school_students (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    school_id TEXT REFERENCES schools(id) NOT NULL,
    name TEXT NOT NULL,
    student_code TEXT,
    birth_date DATE,
    pdi_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- 2.6 PDI Records
CREATE TABLE IF NOT EXISTS pdi_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    student_id UUID REFERENCES school_students(id),
    school_id TEXT REFERENCES schools(id),
    teacher_id UUID REFERENCES auth.users(id),
    type TEXT,
    pdi_block TEXT,
    title TEXT,
    content JSONB DEFAULT '{}'::jsonb,
    date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.7 Term Plans
CREATE TABLE IF NOT EXISTS term_plans (
    id TEXT PRIMARY KEY, 
    user_id UUID REFERENCES auth.users(id),
    period INTEGER,
    regime TEXT,
    subject TEXT,
    grade TEXT,
    level TEXT,
    workload_weekly INTEGER,
    reserves JSONB,
    total_classes INTEGER,
    grading_grid JSONB,
    state_base TEXT,
    education_sphere TEXT,
    generated_text TEXT,
    lessons JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.8 Generated Contents
CREATE TABLE IF NOT EXISTS generated_contents (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    type TEXT,
    title TEXT,
    content TEXT,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.9 Referrals
CREATE TABLE IF NOT EXISTS referrals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    referrer_id UUID REFERENCES auth.users(id),
    referee_email TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- 3. SEED INITIAL DATA
INSERT INTO schools (id, name, city, sre) VALUES 
('31023299', 'Escola Estadual Professor Antônio Lago', 'Capelinha', 'Diamantina'),
('11111111', 'Escola Estadual Tancredo Neves', 'Capelinha', 'Diamantina')
ON CONFLICT (id) DO NOTHING;


-- 4. ENABLE RLS & CREATE POLICIES (Now safe because tables exist)

-- 4.1 Schools RLS
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public view for everyone" ON schools;
CREATE POLICY "Public view for everyone" ON schools FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Admins can manage schools" ON schools;
CREATE POLICY "Admins can manage schools" ON schools FOR ALL TO authenticated USING (
    exists (select 1 from profiles where id = auth.uid() and (role = 'admin' OR is_admin = true))
);

-- 4.2 Profiles RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT TO authenticated USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id);
CREATE POLICY "School Members can view colleagues" ON profiles FOR SELECT TO authenticated USING (
    school_id IS NOT NULL AND school_id = (select school_id from profiles where id = auth.uid())
);
-- Allow INSERT for trigger/auth (or self if manual)
CREATE POLICY "Users insert own profile" ON profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);


-- 4.3 Classes RLS
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own classes" ON classes FOR ALL TO authenticated USING (auth.uid() = user_id);

-- 4.4 Students RLS
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own students" ON students FOR ALL TO authenticated USING (
    exists (select 1 from classes where id = class_id and user_id = auth.uid())
);

-- 4.5 School Students RLS
ALTER TABLE school_students ENABLE ROW LEVEL SECURITY;
CREATE POLICY "School Members View Students" ON school_students FOR SELECT TO authenticated USING (
    exists (select 1 from profiles where id = auth.uid() and school_id = school_students.school_id)
);
CREATE POLICY "Managers Manage Students" ON school_students FOR ALL TO authenticated USING (
    exists (select 1 from profiles where id = auth.uid() and role IN ('school_manager', 'school_admin') and school_id = school_students.school_id)
);
CREATE POLICY "Teachers Insert Students" ON school_students FOR INSERT TO authenticated WITH CHECK (
    exists (select 1 from profiles where id = auth.uid() and school_id = school_students.school_id)
);

-- 4.6 PDI Records RLS
ALTER TABLE pdi_records ENABLE ROW LEVEL SECURITY;
CREATE POLICY "School Members View PDI" ON pdi_records FOR SELECT TO authenticated USING (
    exists (select 1 from profiles where id = auth.uid() and school_id = pdi_records.school_id)
);
CREATE POLICY "Teachers Insert PDI" ON pdi_records FOR INSERT TO authenticated WITH CHECK (
    exists (select 1 from profiles where id = auth.uid() and school_id = pdi_records.school_id)
);

-- 4.7 Term Plans RLS
ALTER TABLE term_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own term plans" ON term_plans FOR ALL TO authenticated USING (auth.uid() = user_id);

-- 4.8 Generated Contents RLS
ALTER TABLE generated_contents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own content" ON generated_contents FOR ALL TO authenticated USING (auth.uid() = user_id);

-- 4.9 Referrals RLS
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view referrals" ON referrals FOR ALL TO authenticated USING (auth.uid() = referrer_id);


-- 5. FUNCTION for New User (Optional but good practice)
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', 'teacher')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- Nota: Você precisa criar o Trigger manualmente no Auth do Supabase ou rodar via API, mas o SQL acima prepara a função.
