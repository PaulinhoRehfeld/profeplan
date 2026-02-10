-- SEED DATA: JOSÉ SILVA (Autismo Nível 2)
-- Purpose: Enable End-to-End Testing of PDI Adaptation Flow
-- Schema Logic: school_students (Registry) vs students (Enrollment)

DO $$
DECLARE
  v_school_id uuid;
  v_user_id uuid;
  v_class_id uuid := '00000000-0000-0000-0000-000000000101';
  v_student_id uuid := '00000000-0000-0000-0000-000000000001'; -- Linked to PDI
BEGIN

  -- 1. Get/Create Mock School
  -- We use a fixed UUID to avoid compatibility issues with legacy integer IDs
  v_school_id := '00000000-0000-0000-0000-000000009999';
  
  INSERT INTO schools (id, name, city)
  VALUES (v_school_id, 'Escola Teste Antônio Lago (Simulação)', 'Belo Horizonte')
  ON CONFLICT (id) DO NOTHING;
  
  -- 2. Find a User (Owner of the class)
  SELECT id INTO v_user_id FROM profiles LIMIT 1;

  -- 3. Insert Class linked to Mock School
  INSERT INTO classes (id, name, grade, school_id, user_id)
  VALUES (
    v_class_id, 
    'Turma 101', 
    '1º Ano EM', 
    v_school_id,
    v_user_id
  ) ON CONFLICT (id) DO NOTHING;

  -- 4. Insert into School Registry (Matches PDI FK, has NO class_id)
  INSERT INTO school_students (id, name, school_id)
  VALUES (
    v_student_id, 
    'José Silva',
    v_school_id
  ) ON CONFLICT (id) DO NOTHING;

  -- 5. Insert into Class Enrollment (Matches Teacher View, has class_id)
  -- Uses a new ID because 'students' and 'school_students' are likely separate tables
  INSERT INTO students (id, class_id, name)
  VALUES (
    uuid_generate_v4(), -- New ID for enrollment
    v_class_id,
    'José Silva'
  ) ON CONFLICT DO NOTHING;
  -- Note: If conflict implies unique name constraint fails, we assume he is enrolled.

  -- 6. Insert PDI (Linked to School Registry ID)
  INSERT INTO pdi_documents (id, student_id, school_id, status, content_data)
  VALUES (
    '00000000-0000-0000-0000-000000000999',
    v_student_id, -- Link to SCHOOL_STUDENTS id
    v_school_id,
    'active',
    '{
    "institutional": {
      "school_name": "Escola Teste Antônio Lago",
      "sre": "Metropolitana A",
      "city": "Belo Horizonte"
    },
    "student_data": {
      "name": "José Silva",
      "dob": "2010-05-12",
      "age": 15,
      "school_year": "1º Ano EM",
      "class_name": "Turma 101",
      "shift": "Manhã"
    },
    "clinical_health": {
      "diagnosis_cid": "F84.0 - Autismo Infantil (Nível 2 de Suporte)",
      "medication": "Risperidona 1mg",
      "therapies": "Terapia Ocupacional e Fono.",
      "functional_limitations": "Hipersensibilidade auditiva."
    },
    "psychomotor": {
      "body_awareness": "APRESENTA",
      "fine_motor_coordination": "COM_AJUDA",
      "gross_motor_coordination": "APRESENTA",
      "visual_perception": "APRESENTA",
      "auditory_perception": "COM_AJUDA"
    },
    "cognitive": {
      "attention_sustained": "POUCA_COMPREENSAO",
      "attention_selective": "COM_AJUDA",
      "memory_visual": "APRESENTA",
      "memory_auditory": "NAO_APRESENTA",
      "thought_analytical": "COM_AJUDA",
      "orders_simple": "APRESENTA",
      "orders_complex": "COM_AJUDA"
    },
    "communication": {
      "verbal_expression": "COM_AJUDA",
      "understanding_verbal": "APRESENTA",
      "interaction_intent": "POUCA_COMPREENSAO"
    }
  }'::jsonb
  ) ON CONFLICT (id) DO UPDATE 
  SET content_data = EXCLUDED.content_data;

END $$;
