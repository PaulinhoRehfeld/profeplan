-- Function to get distinct cities efficiently
-- Avoids fetching 16k+ rows to the client just to get a list of cities
CREATE OR REPLACE FUNCTION get_cities()
RETURNS TABLE (city text)
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT DISTINCT city
  FROM schools
  WHERE city IS NOT NULL AND city != ''
  ORDER BY city;
$$;

-- Grant access to authenticated users
GRANT EXECUTE ON FUNCTION get_cities() TO authenticated;
GRANT EXECUTE ON FUNCTION get_cities() TO anon; -- If needed for public pages
