DO $$
DECLARE
  new_uid uuid := gen_random_uuid();
BEGIN
  -- 1. Create in authorized_users (This allows Login via the new RPC)
  -- The 'role' HERE is correct, as authorized_users likely has it for the RPC check
  INSERT INTO authorized_users (id, email, access_key, role)
  VALUES (new_uid, 'suporte@profeplan.com.br', '12348765', 'ADMIN')
  ON CONFLICT (email) DO NOTHING;

  -- 2. Create in profiles (This allows App Access)
  -- REMOVED 'role' column from profiles insert, added 'is_admin'
  SELECT id INTO new_uid FROM authorized_users WHERE email = 'suporte@profeplan.com.br';

  INSERT INTO profiles (id, email, tier, credits, is_unlimited, is_admin)
  VALUES (new_uid, 'suporte@profeplan.com.br', 'GOLD', 9999, true, true)
  ON CONFLICT (id) DO UPDATE
  SET tier = 'GOLD', is_unlimited = true, is_admin = true; 
END $$;
