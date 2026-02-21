create or replace function check_admin_credentials(
  check_email text,
  check_key text
)
returns table (
  user_id uuid,
  user_role text
)
language plpgsql
security definer -- Vital: runs with elevated privileges to read table
as $$
begin
  return query
  select id, role
  from authorized_users
  where email = check_email
  and access_key = check_key;
end;
$$;
