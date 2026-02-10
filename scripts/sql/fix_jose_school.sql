-- FIND CORRECT SCHOOL ID
-- Searching for student 'Adão' to see which school_id he is linked to.
DO $$
DECLARE
  v_real_school_id uuid;
  v_student_name text := 'Adão';
BEGIN
  -- Try to find Adão in school_students
  SELECT school_id INTO v_real_school_id 
  FROM school_students 
  WHERE name ILIKE v_student_name || '%' 
  LIMIT 1;

  IF v_real_school_id IS NOT NULL THEN
    RAISE NOTICE 'Found School ID: %', v_real_school_id;
    
    -- UPDATE José Silva to this ID
    UPDATE school_students 
    SET school_id = v_real_school_id 
    WHERE name = 'José Silva';
    
    -- UPDATE PDI Document as well
    UPDATE pdi_documents 
    SET school_id = v_real_school_id 
    WHERE student_id = (SELECT id FROM school_students WHERE name = 'José Silva' LIMIT 1);
    
  ELSE
    RAISE NOTICE 'Student Adão not found. Trying another way...';
  END IF;
END $$;
