-- CHECK SCHEMAS
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'pre_registered_teachers';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'pending_teachers';
