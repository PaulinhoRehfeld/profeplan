-- ==============================================================================
-- PROFILE SCHEMA
-- ==============================================================================

-- 1. Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  school_id TEXT REFERENCES schools(id), -- Assuming school.id is text (INEP code)
  full_name TEXT,
  avatar_url TEXT,
  updated_at TIMESTAMP WITH TIME ZONE,
  
  CONSTRAINT username_length CHECK (char_length(full_name) >= 3)
);

-- 2. Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 3. Create Policies
CREATE POLICY "Public profiles are viewable by everyone." 
    ON profiles FOR SELECT 
    USING ( true );

CREATE POLICY "Users can insert their own profile." 
    ON profiles FOR INSERT 
    WITH CHECK ( auth.uid() = id );

CREATE POLICY "Users can update own profile." 
    ON profiles FOR UPDATE 
    USING ( auth.uid() = id );
    
-- 4. Function to handle new user signup (Optional but recommended)
-- This automatically creates a profile entry when a new user signs up via Supabase Auth
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$ language plpgsql security definer;

-- Trigger the function every time a user is created
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
