-- Lote 7 de 9
-- Escolas 3001 a 3500

-- INSTITUTO DE EDUCAÇÃO PAULO ANTÔNIO SILVA - IEPAS (TIMÓTEO) - INEP: 316008
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316008' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO PAULO ANTÔNIO SILVA - IEPAS' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316008');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI TIMÓTEO CFP LUCIANO JOSÉ DE ARAÚJO (TIMÓTEO) - INEP: 359440
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359440' 
    WHERE UPPER(TRIM(name)) = 'SENAI TIMÓTEO CFP LUCIANO JOSÉ DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359440');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL RAIO DE SOL (BUENÓPOLIS) - INEP: 325520
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325520' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL RAIO DE SOL' 
      AND UPPER(TRIM(city)) = 'BUENÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325520');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL DOM SERAFIM COOPENCOR (CORINTO) - INEP: 145564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145564' 
    WHERE UPPER(TRIM(name)) = 'COL DOM SERAFIM COOPENCOR' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BOM COMEÇO E LEME (CURVELO) - INEP: 377040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377040' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BOM COMEÇO E LEME' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DARWIN DE CURVELO (CURVELO) - INEP: 306169
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306169' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DARWIN DE CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306169');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FRANCISCANO SANTO ANTÔNIO (CURVELO) - INEP: 145602
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145602' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FRANCISCANO SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145602');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PADRE CURVELO (CURVELO) - INEP: 145581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145581' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PADRE CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO DA FACIC - COTEC (CURVELO) - INEP: 327506
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327506' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO DA FACIC - COTEC' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327506');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PEQUENO PRÍNCIPE EXPANSÃO (CURVELO) - INEP: 210498
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210498' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PEQUENO PRÍNCIPE EXPANSÃO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210498');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- REDE M2 - CURVELO (CURVELO) - INEP: 374830
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374830' 
    WHERE UPPER(TRIM(name)) = 'REDE M2 - CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374830');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE TÉCNICA DO CEP DE CURVELO (CURVELO) - INEP: 359092
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359092' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE TÉCNICA DO CEP DE CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359092');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DARWIN DE FELIXLÂNDIA (FELIXLÂNDIA) - INEP: 354368
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354368' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DARWIN DE FELIXLÂNDIA' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354368');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE TREINAMENTO ADEMAR MARRA (TRÊS MARIAS) - INEP: 339725
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339725' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE TREINAMENTO ADEMAR MARRA' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339725');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL BARREIRO GRANDE (TRÊS MARIAS) - INEP: 145891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145891' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL BARREIRO GRANDE' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO EDUCACIONAL DOCE MUNDO (TRÊS MARIAS) - INEP: 263966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '263966' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO EDUCACIONAL DOCE MUNDO' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '263966');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CRESCER (CAPELINHA) - INEP: 325503
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325503' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CRESCER' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325503');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VENCER (CAPELINHA) - INEP: 365106
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365106' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VENCER' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365106');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTEGRA (CONCEIÇÃO DO MATO DENTRO) - INEP: 374709
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374709' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTEGRA' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO MATO DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374709');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE CONCEIÇÃO DO MATO DENTRO (CONCEIÇÃO DO MATO DENTRO) - INEP: 359610
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359610' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE CONCEIÇÃO DO MATO DENTRO' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO MATO DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359610');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI DE CONCEIÇÃO DE MATO DENTRO CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ APARECIDO DE OLIVEIRA (CONCEIÇÃO DO MATO DENTRO) - INEP: 358932
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358932' 
    WHERE UPPER(TRIM(name)) = 'SENAI DE CONCEIÇÃO DE MATO DENTRO CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ APARECIDO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO MATO DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358932');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DE EDUCAÇÃO INTEGRADA - CEI (DIAMANTINA) - INEP: 350320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350320' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DE EDUCAÇÃO INTEGRADA - CEI' 
      AND UPPER(TRIM(city)) = 'DIAMANTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350320');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MESTRA - CENTRO EDUCACIONAL MESTRA JOANA LOPES (DIAMANTINA) - INEP: 346357
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346357' 
    WHERE UPPER(TRIM(name)) = 'MESTRA - CENTRO EDUCACIONAL MESTRA JOANA LOPES' 
      AND UPPER(TRIM(city)) = 'DIAMANTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346357');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO DO CEP DE DIAMANTINA (DIAMANTINA) - INEP: 359106
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359106' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO DO CEP DE DIAMANTINA' 
      AND UPPER(TRIM(city)) = 'DIAMANTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359106');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CONEXÃO (ITAMARANDIBA) - INEP: 356301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356301' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CONEXÃO' 
      AND UPPER(TRIM(city)) = 'ITAMARANDIBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO POLITÉCNICO JOÃO PAULO II (ITAMARANDIBA) - INEP: 344842
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344842' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO POLITÉCNICO JOÃO PAULO II' 
      AND UPPER(TRIM(city)) = 'ITAMARANDIBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344842');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA YMBALO (SERRO) - INEP: 375187
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375187' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA YMBALO' 
      AND UPPER(TRIM(city)) = 'SERRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375187');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL NOSSA SENHORA DA CONCEIÇÃO (SERRO) - INEP: 342076
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342076' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL NOSSA SENHORA DA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'SERRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342076');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI TURMALINA CENTRO DE FORMAÇÃO PROFISSIONAL (TURMALINA) - INEP: 358762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358762' 
    WHERE UPPER(TRIM(name)) = 'SENAI TURMALINA CENTRO DE FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'TURMALINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMILIA AGRÍCOLA DE VEREDINHA (VEREDINHA) - INEP: 350133
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350133' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMILIA AGRÍCOLA DE VEREDINHA' 
      AND UPPER(TRIM(city)) = 'VEREDINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350133');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CECON CENTRO EDUCACIONAL CONCEIÇÃO FERREIRA NUNES (ARCOS) - INEP: 304441
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '304441' 
    WHERE UPPER(TRIM(name)) = 'CECON CENTRO EDUCACIONAL CONCEIÇÃO FERREIRA NUNES' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '304441');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL ELIEZER VITORINO COSTA (ARCOS) - INEP: 349666
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349666' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL ELIEZER VITORINO COSTA' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349666');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO DE ARCOS (ARCOS) - INEP: 321257
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321257' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO DE ARCOS' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321257');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- DOMINUS EDUCAÇÃO (ARCOS) - INEP: 350842
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350842' 
    WHERE UPPER(TRIM(name)) = 'DOMINUS EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350842');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOSSA SENHORA DO CARMO (ARCOS) - INEP: 213721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213721' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213721');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INPA - INSTITUTO PEDAGÓGICO ARCOENSE (ARCOS) - INEP: 260797
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260797' 
    WHERE UPPER(TRIM(name)) = 'INPA - INSTITUTO PEDAGÓGICO ARCOENSE' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260797');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MARIA APARECIDA RIBEIRO (ARCOS) - INEP: 312835
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312835' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MARIA APARECIDA RIBEIRO' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312835');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL EVOLUÇÃO (BAMBUÍ) - INEP: 306576
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306576' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL EVOLUÇÃO' 
      AND UPPER(TRIM(city)) = 'BAMBUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306576');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA COOPERATIVA DE ENSINO DE BAMBUÍ (BAMBUÍ) - INEP: 266582
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266582' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA COOPERATIVA DE ENSINO DE BAMBUÍ' 
      AND UPPER(TRIM(city)) = 'BAMBUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266582');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- VS2 EDUCAÇÃO (BAMBUÍ) - INEP: 371718
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371718' 
    WHERE UPPER(TRIM(name)) = 'VS2 EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'BAMBUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371718');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DIAMANTE - UNIDADE IV (CARMO DA MATA) - INEP: 356999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356999' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DIAMANTE - UNIDADE IV' 
      AND UPPER(TRIM(city)) = 'CARMO DA MATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MONTEIRO LOBATO (CARMO DO CAJURU) - INEP: 293784
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293784' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'CARMO DO CAJURU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293784');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PENTÁGONO (CARMÓPOLIS DE MINAS) - INEP: 368091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368091' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PENTÁGONO' 
      AND UPPER(TRIM(city)) = 'CARMÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO PEDAGÓGICO APRENDIZ (CARMÓPOLIS DE MINAS) - INEP: 254541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254541' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO PEDAGÓGICO APRENDIZ' 
      AND UPPER(TRIM(city)) = 'CARMÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO SAGRADO CORAÇÃO DE JESUS (CLÁUDIO) - INEP: 325864
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325864' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO SAGRADO CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'CLÁUDIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325864');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL RISOLETA TOLENTINO NEVES (CLÁUDIO) - INEP: 346241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346241' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL RISOLETA TOLENTINO NEVES' 
      AND UPPER(TRIM(city)) = 'CLÁUDIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CONCEIÇÃO FERREIRA NUNES - CECON (DIVINÓPOLIS) - INEP: 296279
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296279' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CONCEIÇÃO FERREIRA NUNES - CECON' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296279');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CRIATIVO - CRECI (DIVINÓPOLIS) - INEP: 281921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281921' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CRIATIVO - CRECI' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281921');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DIVINÓPOLIS (DIVINÓPOLIS) - INEP: 291986
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '291986' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DIVINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '291986');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL JEAN PIAGET (DIVINÓPOLIS) - INEP: 252832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '252832' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL JEAN PIAGET' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '252832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU (DIVINÓPOLIS) - INEP: 340014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340014' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAGNIFICAT (DIVINÓPOLIS) - INEP: 376051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376051' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAGNIFICAT' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRESBITERIANO (DIVINÓPOLIS) - INEP: 327824
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327824' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRESBITERIANO' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327824');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÍNTESE (DIVINÓPOLIS) - INEP: 321303
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321303' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÍNTESE' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321303');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE DIVINÓPOLIS (DIVINÓPOLIS) - INEP: 374644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374644' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE DIVINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRESCER PODIUM (DIVINÓPOLIS) - INEP: 236306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236306' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRESCER PODIUM' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM SÃO JOÃO DE DEUS (DIVINÓPOLIS) - INEP: 258521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258521' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM SÃO JOÃO DE DEUS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- OPÇÃO ENGETEC CURSOS TÉCNICOS (DIVINÓPOLIS) - INEP: 381454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381454' 
    WHERE UPPER(TRIM(name)) = 'OPÇÃO ENGETEC CURSOS TÉCNICOS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PEREIRA E AMABILI CENTRO DE EDUCAÇÃO (DIVINÓPOLIS) - INEP: 338036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338036' 
    WHERE UPPER(TRIM(name)) = 'PEREIRA E AMABILI CENTRO DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PROZ - UNIDADE DIVINÓPOLIS (DIVINÓPOLIS) - INEP: 379883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379883' 
    WHERE UPPER(TRIM(name)) = 'PROZ - UNIDADE DIVINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP DE DIVINÓPOLIS (DIVINÓPOLIS) - INEP: 359050
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359050' 
    WHERE UPPER(TRIM(name)) = 'SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP DE DIVINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359050');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SOPHIS EDUCACIONAL (DIVINÓPOLIS) - INEP: 371726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371726' 
    WHERE UPPER(TRIM(name)) = 'SOPHIS EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL DE IGUATAMA (IGUATAMA) - INEP: 293792
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293792' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL DE IGUATAMA' 
      AND UPPER(TRIM(city)) = 'IGUATAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293792');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE ITAGUARA (ITAGUARA) - INEP: 379867
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379867' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE ITAGUARA' 
      AND UPPER(TRIM(city)) = 'ITAGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379867');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEC CENTRO EDUCACIONAL CONSTRUIR (ITAPECERICA) - INEP: 274216
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274216' 
    WHERE UPPER(TRIM(name)) = 'CEC CENTRO EDUCACIONAL CONSTRUIR' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274216');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TECNOLÓGICO DE FUNDIÇÃO MARCELINO CORRADI - SENAI (ITAÚNA) - INEP: 259250
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259250' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TECNOLÓGICO DE FUNDIÇÃO MARCELINO CORRADI - SENAI' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259250');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CENECISTA EDUCARE DE ITAÚNA (ITAÚNA) - INEP: 230014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230014' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CENECISTA EDUCARE DE ITAÚNA' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE ITAÚNA (ITAÚNA) - INEP: 312177
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312177' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE ITAÚNA' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312177');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RECANTO DO ESPÍRITO SANTO (ITAÚNA) - INEP: 376060
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376060' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RECANTO DO ESPÍRITO SANTO' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376060');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI DARIO GONÇALVES DE SOUZA (ITAÚNA) - INEP: 313068
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313068' 
    WHERE UPPER(TRIM(name)) = 'SESI DARIO GONÇALVES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313068');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- TEOREMA CENTRO DE ESTUDOS EDUCACIONAIS (ITAÚNA) - INEP: 315761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315761' 
    WHERE UPPER(TRIM(name)) = 'TEOREMA CENTRO DE ESTUDOS EDUCACIONAIS' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÁGUIA DE PRATA (LAGOA DA PRATA) - INEP: 222232
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222232' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÁGUIA DE PRATA' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222232');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO (LAGOA DA PRATA) - INEP: 376272
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376272' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376272');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM SANTA CLARA (LAGOA DA PRATA) - INEP: 294918
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294918' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM SANTA CLARA' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294918');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMAM- INSTITUTO MARIA AUGUSTA MACHADO (LAGOA DA PRATA) - INEP: 246166
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246166' 
    WHERE UPPER(TRIM(name)) = 'IMAM- INSTITUTO MARIA AUGUSTA MACHADO' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246166');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO TUTORES DA EDUCAÇÃO (LAGOA DA PRATA) - INEP: 376507
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376507' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO TUTORES DA EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376507');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAIS (LUZ) - INEP: 367966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367966' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAIS' 
      AND UPPER(TRIM(city)) = 'LUZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367966');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO RAFAEL (LUZ) - INEP: 318523
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318523' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO RAFAEL' 
      AND UPPER(TRIM(city)) = 'LUZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318523');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ESTRELA VERDE (NOVA SERRANA) - INEP: 325970
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325970' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ESTRELA VERDE' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325970');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE NOVA SERRANA (NOVA SERRANA) - INEP: 320153
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320153' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE NOVA SERRANA' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320153');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MODELO (NOVA SERRANA) - INEP: 296261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296261' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MODELO' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SABER (NOVA SERRANA) - INEP: 342122
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342122' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SABER' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342122');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL GENY JOSÉ FERREIRA (NOVA SERRANA) - INEP: 331236
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331236' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL GENY JOSÉ FERREIRA' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331236');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DIAMANTE (OLIVEIRA) - INEP: 351598
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351598' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DIAMANTE' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351598');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PENTÁGONO (OLIVEIRA) - INEP: 349348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349348' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PENTÁGONO' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL APOGEU (OLIVEIRA) - INEP: 253391
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253391' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL APOGEU' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253391');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL TUTORES (SANTO ANTÔNIO DO MONTE) - INEP: 377147
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377147' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL TUTORES' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO MONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377147');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CHAVE DO SABER (SANTO ANTÔNIO DO MONTE) - INEP: 339172
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339172' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CHAVE DO SABER' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO MONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339172');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMAC- INSTITUTO MARIA ANGÉLICA DE CASTRO (SANTO ANTÔNIO DO MONTE) - INEP: 292770
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292770' 
    WHERE UPPER(TRIM(name)) = 'IMAC- INSTITUTO MARIA ANGÉLICA DE CASTRO' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO MONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292770');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CRESCER (AIMORÉS) - INEP: 246174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246174' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CRESCER' 
      AND UPPER(TRIM(city)) = 'AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA JOSÉ RODRIGUES DA SILVA (AIMORÉS) - INEP: 335070
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '335070' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA JOSÉ RODRIGUES DA SILVA' 
      AND UPPER(TRIM(city)) = 'AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '335070');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TIRADENTES (CONSELHEIRO PENA) - INEP: 351512
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351512' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TIRADENTES' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO PENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351512');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BARROS OLIVEIRA (GOVERNADOR VALADARES) - INEP: 280135
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280135' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BARROS OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280135');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CASTELO NEVES BARROS (GOVERNADOR VALADARES) - INEP: 314226
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314226' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CASTELO NEVES BARROS' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314226');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO E PRÉ VESTIBULAR UNIVALE - FIBONACCI (GOVERNADOR VALADARES) - INEP: 369900
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369900' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO E PRÉ VESTIBULAR UNIVALE - FIBONACCI' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369900');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GENOMA (GOVERNADOR VALADARES) - INEP: 329762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329762' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GENOMA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO HERINGER (GOVERNADOR VALADARES) - INEP: 303241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303241' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO HERINGER' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RÚBIA COELHO (GOVERNADOR VALADARES) - INEP: 280283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280283' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RÚBIA COELHO' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280283');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VITORINO (GOVERNADOR VALADARES) - INEP: 303186
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303186' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VITORINO' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303186');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DO FUTURO (GOVERNADOR VALADARES) - INEP: 346454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346454' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DO FUTURO' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOVO SABER (GOVERNADOR VALADARES) - INEP: 303127
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303127' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOVO SABER' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303127');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PROFISSIONALIZANTE EDUCAR E SAÚDE - PROES (GOVERNADOR VALADARES) - INEP: 318574
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318574' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PROFISSIONALIZANTE EDUCAR E SAÚDE - PROES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318574');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SÃO CAMILO DE LELIS (GOVERNADOR VALADARES) - INEP: 369454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369454' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SÃO CAMILO DE LELIS' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA JOSÉ RODRIGUES DA SILVA (GOVERNADOR VALADARES) - INEP: 313548
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313548' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA JOSÉ RODRIGUES DA SILVA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313548');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MILLENIUM (GOVERNADOR VALADARES) - INEP: 302961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302961' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MILLENIUM' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC- UNIDIDADE DE ENSINO TÉCNICO - CFP GOVERNADOR VALADARES (GOVERNADOR VALADARES) - INEP: 323934
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323934' 
    WHERE UPPER(TRIM(name)) = 'SENAC- UNIDIDADE DE ENSINO TÉCNICO - CFP GOVERNADOR VALADARES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323934');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL LUÍS CHAVES (GOVERNADOR VALADARES) - INEP: 276693
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276693' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL LUÍS CHAVES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276693');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI ABÍLIO RODRIGUES PATTO (GOVERNADOR VALADARES) - INEP: 244163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244163' 
    WHERE UPPER(TRIM(name)) = 'SESI ABÍLIO RODRIGUES PATTO' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEB - CENTRO EDUCACIONAL BATISTA (MANTENA) - INEP: 319236
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319236' 
    WHERE UPPER(TRIM(name)) = 'CEB - CENTRO EDUCACIONAL BATISTA' 
      AND UPPER(TRIM(city)) = 'MANTENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319236');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO EDUCACIONAL DE SAÚDE (MANTENA) - INEP: 339377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339377' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO EDUCACIONAL DE SAÚDE' 
      AND UPPER(TRIM(city)) = 'MANTENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA DE MANTENA (MANTENA) - INEP: 350567
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350567' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA DE MANTENA' 
      AND UPPER(TRIM(city)) = 'MANTENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350567');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DIRCE PELEGRINI (RESPLENDOR) - INEP: 295302
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295302' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DIRCE PELEGRINI' 
      AND UPPER(TRIM(city)) = 'RESPLENDOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295302');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTEGRAL DE RESPLENDOR (RESPLENDOR) - INEP: 366218
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366218' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTEGRAL DE RESPLENDOR' 
      AND UPPER(TRIM(city)) = 'RESPLENDOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366218');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SOUZA SIMAN (GUANHÃES) - INEP: 377619
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377619' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SOUZA SIMAN' 
      AND UPPER(TRIM(city)) = 'GUANHÃES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377619');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESPAÇO EDUCACIONAL NOVO SER (GUANHÃES) - INEP: 374385
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374385' 
    WHERE UPPER(TRIM(name)) = 'ESPAÇO EDUCACIONAL NOVO SER' 
      AND UPPER(TRIM(city)) = 'GUANHÃES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374385');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IESGE - INSTITUTO DE ENSINO E GESTÃO EDUCACIONAL (GUANHÃES) - INEP: 354872
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354872' 
    WHERE UPPER(TRIM(name)) = 'IESGE - INSTITUTO DE ENSINO E GESTÃO EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'GUANHÃES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354872');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PRESBITERIANO GAMMON (GUANHÃES) - INEP: 254673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254673' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PRESBITERIANO GAMMON' 
      AND UPPER(TRIM(city)) = 'GUANHÃES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254673');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL BRAVIEIRA (PEÇANHA) - INEP: 295256
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295256' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL BRAVIEIRA' 
      AND UPPER(TRIM(city)) = 'PEÇANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295256');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ATUAL SISTEMA DE ENSINO (SABINÓPOLIS) - INEP: 331619
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331619' 
    WHERE UPPER(TRIM(name)) = 'ATUAL SISTEMA DE ENSINO' 
      AND UPPER(TRIM(city)) = 'SABINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331619');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO PEDAGÓGICO MOTIVAR (SABINÓPOLIS) - INEP: 253944
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253944' 
    WHERE UPPER(TRIM(name)) = 'CENTRO PEDAGÓGICO MOTIVAR' 
      AND UPPER(TRIM(city)) = 'SABINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253944');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CURSOS PROFISSIONALIZANTES EDUCAR E SAÚDE (SÃO JOÃO EVANGELISTA) - INEP: 312312
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312312' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CURSOS PROFISSIONALIZANTES EDUCAR E SAÚDE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO EVANGELISTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312312');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO CONEXÃO DE VIRGINÓPOLIS (VIRGINÓPOLIS) - INEP: 376604
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376604' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO CONEXÃO DE VIRGINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'VIRGINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376604');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMACULADA CONCEIÇÃO (BRAZÓPOLIS) - INEP: 302848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302848' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'BRAZÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FÊNIX (CRISTINA) - INEP: 325538
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325538' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FÊNIX' 
      AND UPPER(TRIM(city)) = 'CRISTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325538');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL LIMASSIS (DELFIM MOREIRA) - INEP: 316016
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316016' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL LIMASSIS' 
      AND UPPER(TRIM(city)) = 'DELFIM MOREIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316016');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÂNGULO (ITAJUBÁ) - INEP: 325848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325848' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÂNGULO' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CASTELO DO SABER (ITAJUBÁ) - INEP: 302911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302911' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CASTELO DO SABER' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DA FEPI  - UNIDADE II (ITAJUBÁ) - INEP: 376361
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376361' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DA FEPI - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376361');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EMPREENDER (ITAJUBÁ) - INEP: 364886
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364886' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EMPREENDER' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364886');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GÊNESIS (ITAJUBÁ) - INEP: 257150
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257150' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GÊNESIS' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257150');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SUCESSO (ITAJUBÁ) - INEP: 324434
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324434' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SUCESSO' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324434');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CURSO G9 (ITAJUBÁ) - INEP: 239682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239682' 
    WHERE UPPER(TRIM(name)) = 'CURSO G9' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI VITOR VIEIRA DOS SANTOS (ITAJUBÁ) - INEP: 348503
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348503' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI VITOR VIEIRA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348503');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO MÁRIO BRAGANÇA (ITAJUBÁ) - INEP: 377627
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377627' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO MÁRIO BRAGANÇA' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377627');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CFP ITAJUBÁ (ITAJUBÁ) - INEP: 320099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320099' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CFP ITAJUBÁ' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL AURELIANO CHAVES (ITAJUBÁ) - INEP: 250848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250848' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL AURELIANO CHAVES' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI AURELIANO CHAVES (ITAJUBÁ) - INEP: 365289
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365289' 
    WHERE UPPER(TRIM(name)) = 'SESI AURELIANO CHAVES' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365289');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRIMEIRO DE JUNHO (MARIA DA FÉ) - INEP: 279064
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279064' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRIMEIRO DE JUNHO' 
      AND UPPER(TRIM(city)) = 'MARIA DA FÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279064');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE EDUCAÇÃO PRIMEIRO MUNDO (PARAISÓPOLIS) - INEP: 302864
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302864' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE EDUCAÇÃO PRIMEIRO MUNDO' 
      AND UPPER(TRIM(city)) = 'PARAISÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302864');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA POLITÉCNICA DE PARAISÓPOLIS (PARAISÓPOLIS) - INEP: 294390
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294390' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA POLITÉCNICA DE PARAISÓPOLIS' 
      AND UPPER(TRIM(city)) = 'PARAISÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294390');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RH+ (PEDRALVA) - INEP: 277843
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277843' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RH+' 
      AND UPPER(TRIM(city)) = 'PEDRALVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277843');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESC CULTURAL (PIRANGUINHO) - INEP: 280623
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280623' 
    WHERE UPPER(TRIM(name)) = 'ESC CULTURAL' 
      AND UPPER(TRIM(city)) = 'PIRANGUINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280623');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO AXIOMA - UNIDADE II (CAPINÓPOLIS) - INEP: 374857
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374857' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO AXIOMA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'CAPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374857');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ÁPICE CENTRO EDUCACIONAL (ITUIUTABA) - INEP: 198862
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198862' 
    WHERE UPPER(TRIM(name)) = 'ÁPICE CENTRO EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198862');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL BEBÉ MARTINS (ITUIUTABA) - INEP: 313475
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313475' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL BEBÉ MARTINS' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313475');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL DOM BOSCO (ITUIUTABA) - INEP: 243051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '243051' 
    WHERE UPPER(TRIM(name)) = 'COL DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '243051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL GILDO VILELLA CANCELLA UNID II (ITUIUTABA) - INEP: 215686
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215686' 
    WHERE UPPER(TRIM(name)) = 'COL GILDO VILELLA CANCELLA UNID II' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215686');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO  MENEZES (ITUIUTABA) - INEP: 233048
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233048' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO MENEZES' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233048');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCAÇÃO (ITUIUTABA) - INEP: 198871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198871' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198871');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GILDO VILELLA CANCELLA UNID II (ITUIUTABA) - INEP: 332721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332721' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GILDO VILELLA CANCELLA UNID II' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332721');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA TERESA (ITUIUTABA) - INEP: 198846
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198846' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA TERESA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198846');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO AXIOMA (ITUIUTABA) - INEP: 370649
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370649' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO AXIOMA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370649');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNID ENS TEC - CFP ITUIUTABA (ITUIUTABA) - INEP: 327182
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327182' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNID ENS TEC - CFP ITUIUTABA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327182');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI  DOLORES PERES GOMES DA SILVA (ITUIUTABA) - INEP: 316628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316628' 
    WHERE UPPER(TRIM(name)) = 'SESI DOLORES PERES GOMES DA SILVA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DE SANTA VITÓRIA (SANTA VITÓRIA) - INEP: 243078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '243078' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DE SANTA VITÓRIA' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '243078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO AXIOMA - UNIDADE III (SANTA VITÓRIA) - INEP: 376795
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376795' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO AXIOMA - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376795');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL FLORISVALDO LOPES CRUZ (ESPINOSA) - INEP: 312339
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312339' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL FLORISVALDO LOPES CRUZ' 
      AND UPPER(TRIM(city)) = 'ESPINOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312339');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LÍDER (JAÍBA) - INEP: 369667
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369667' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LÍDER' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369667');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PILARES (JAÍBA) - INEP: 347841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347841' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PILARES' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI JAÍBA (JAÍBA) - INEP: 349488
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349488' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI JAÍBA' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349488');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PILARES (JANAÚBA) - INEP: 238155
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '238155' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PILARES' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '238155');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRÊMIO (JANAÚBA) - INEP: 262153
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262153' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRÊMIO' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262153');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA JANAUBENSE (JANAÚBA) - INEP: 210358
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210358' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA JANAUBENSE' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210358');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL NOVA CIDADANIA (JANAÚBA) - INEP: 363740
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363740' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL NOVA CIDADANIA' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363740');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BASE (MATO VERDE) - INEP: 364673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364673' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BASE' 
      AND UPPER(TRIM(city)) = 'MATO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364673');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PODIUM (MATO VERDE) - INEP: 307815
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307815' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PODIUM' 
      AND UPPER(TRIM(city)) = 'MATO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307815');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADIÇÃO (MONTE AZUL) - INEP: 344869
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344869' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADIÇÃO' 
      AND UPPER(TRIM(city)) = 'MONTE AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344869');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FAVENORTE (MONTE AZUL) - INEP: 381020
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381020' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FAVENORTE' 
      AND UPPER(TRIM(city)) = 'MONTE AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381020');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA PODIUM DE EDUCAÇÃO (MONTE AZUL) - INEP: 316849
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316849' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA PODIUM DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'MONTE AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316849');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  FAVEPORT (PORTEIRINHA) - INEP: 361488
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361488' 
    WHERE UPPER(TRIM(name)) = 'FAVEPORT' 
      AND UPPER(TRIM(city)) = 'PORTEIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361488');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PEDAGÓGICO CRESCER (PORTEIRINHA) - INEP: 322474
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322474' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PEDAGÓGICO CRESCER' 
      AND UPPER(TRIM(city)) = 'PORTEIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322474');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO EDUCACIONAL DE PORTEIRINHA (PORTEIRINHA) - INEP: 230502
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230502' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO EDUCACIONAL DE PORTEIRINHA' 
      AND UPPER(TRIM(city)) = 'PORTEIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230502');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CEIVA (JANUÁRIA) - INEP: 311821
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311821' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CEIVA' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311821');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO POLITÉCNICO DOM LUCIANO (JANUÁRIA) - INEP: 339245
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339245' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO POLITÉCNICO DOM LUCIANO' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339245');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE JANUÁRIA - ETEJ (JANUÁRIA) - INEP: 373532
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373532' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE JANUÁRIA - ETEJ' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373532');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO POLIVALENTE DE FORMAÇÃO TÉCNICA (JUVENÍLIA) - INEP: 366110
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366110' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO POLIVALENTE DE FORMAÇÃO TÉCNICA' 
      AND UPPER(TRIM(city)) = 'JUVENÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366110');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PENTÁGONO (SÃO FRANCISCO) - INEP: 291862
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '291862' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PENTÁGONO' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '291862');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PLANO (SÃO FRANCISCO) - INEP: 378143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378143' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PLANO' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA TABOCAL (SÃO FRANCISCO) - INEP: 338559
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338559' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA TABOCAL' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338559');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL UBAÍ (UBAÍ) - INEP: 342890
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342890' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL UBAÍ' 
      AND UPPER(TRIM(city)) = 'UBAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342890');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ELITTE (BICAS) - INEP: 343072
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343072' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ELITTE' 
      AND UPPER(TRIM(city)) = 'BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343072');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FUTURO (BICAS) - INEP: 311481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311481' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FUTURO' 
      AND UPPER(TRIM(city)) = 'BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFORTEC - SAÚDE CENTRO EDUCACIONAL DE FORMAÇÃO (JUIZ DE FORA) - INEP: 310867
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310867' 
    WHERE UPPER(TRIM(name)) = 'CEFORTEC - SAÚDE CENTRO EDUCACIONAL DE FORMAÇÃO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310867');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO INTERATIVA (JUIZ DE FORA) - INEP: 296473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296473' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO INTERATIVA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL AGUIAR CELEGHINI (JUIZ DE FORA) - INEP: 306240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306240' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL AGUIAR CELEGHINI' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CAVE (JUIZ DE FORA) - INEP: 354910
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354910' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CAVE' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354910');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PROFESSOR SANT'ANNA (JUIZ DE FORA) - INEP: 220001
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220001' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PROFESSOR SANT''ANNA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220001');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL RAS (JUIZ DE FORA) - INEP: 311103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311103' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL RAS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL SABER É VIVER (JUIZ DE FORA) - INEP: 306207
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306207' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL SABER É VIVER' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306207');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO INTEGRADO DE DESENVOLVIMENTO DO TRABALHADOR LUIZ ADELAR  SCHEUER-SENAI (JUIZ DE FORA) - INEP: 316733
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316733' 
    WHERE UPPER(TRIM(name)) = 'CENTRO INTEGRADO DE DESENVOLVIMENTO DO TRABALHADOR LUIZ ADELAR SCHEUER-SENAI' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316733');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU - UNIDADE II (JUIZ DE FORA) - INEP: 356816
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356816' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356816');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU - UNIDADE III (JUIZ DE FORA) - INEP: 256285
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256285' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256285');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU - UNIDADE VI (JUIZ DE FORA) - INEP: 230278
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230278' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU - UNIDADE VI' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230278');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU DE EDUCAÇÃO INFANTIL - UNIDADE NOVA ERA (JUIZ DE FORA) - INEP: 363383
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363383' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU DE EDUCAÇÃO INFANTIL - UNIDADE NOVA ERA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363383');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU- UNIDADE I (JUIZ DE FORA) - INEP: 317101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317101' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU- UNIDADE I' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ARAUTOS DO EVANGELHO - JUIZ DE FORA (JUIZ DE FORA) - INEP: 357227
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357227' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ARAUTOS DO EVANGELHO - JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357227');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CASCATINHA (JUIZ DE FORA) - INEP: 348279
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348279' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CASCATINHA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348279');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CATÓLICO COMUNIDADE RESGATE (JUIZ DE FORA) - INEP: 369640
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369640' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CATÓLICO COMUNIDADE RESGATE' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369640');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CERQUEIRA (JUIZ DE FORA) - INEP: 316571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316571' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CERQUEIRA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CONEXÃO (JUIZ DE FORA) - INEP: 310735
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310735' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CONEXÃO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310735');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CONEXÃO - UNIDADE II (JUIZ DE FORA) - INEP: 233102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233102' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CONEXÃO - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CONEXÃO KIDS (JUIZ DE FORA) - INEP: 306266
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306266' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CONEXÃO KIDS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306266');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DINÂMICO (JUIZ DE FORA) - INEP: 252018
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '252018' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DINÂMICO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '252018');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO E CURSO CATEDRAL VESTIBULARES (JUIZ DE FORA) - INEP: 312924
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312924' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO E CURSO CATEDRAL VESTIBULARES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312924');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO E CURSO NOTA 10 (JUIZ DE FORA) - INEP: 367036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367036' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO E CURSO NOTA 10' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EQUIPE DE JUIZ DE FORA (JUIZ DE FORA) - INEP: 324515
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324515' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EQUIPE DE JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324515');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EXATO (JUIZ DE FORA) - INEP: 296554
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296554' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EXATO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296554');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAGNUS (JUIZ DE FORA) - INEP: 246883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246883' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAGNUS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOVA ERA (JUIZ DE FORA) - INEP: 341355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '341355' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOVA ERA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '341355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIRÂMIDE (JUIZ DE FORA) - INEP: 338923
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338923' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIRÂMIDE' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338923');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RENASCER (JUIZ DE FORA) - INEP: 369764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369764' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RENASCER' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ZONA NORTE (JUIZ DE FORA) - INEP: 340979
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340979' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ZONA NORTE' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340979');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ADVENTISTA DE JUIZ DE FORA (JUIZ DE FORA) - INEP: 233137
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233137' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ADVENTISTA DE JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233137');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CULTURA VIVA (JUIZ DE FORA) - INEP: 219983
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219983' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CULTURA VIVA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219983');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM SANTA CASA MISERICÓRDIA (JUIZ DE FORA) - INEP: 212300
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212300' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM SANTA CASA MISERICÓRDIA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212300');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DEGRAUS DE ENSINO (JUIZ DE FORA) - INEP: 212326
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212326' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DEGRAUS DE ENSINO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212326');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DIRETRIZES (JUIZ DE FORA) - INEP: 238244
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '238244' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DIRETRIZES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '238244');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ESTÁCIO JUIZ DE FORA (JUIZ DE FORA) - INEP: 371734
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371734' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ESTÁCIO JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371734');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA HUB (JUIZ DE FORA) - INEP: 371785
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371785' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA HUB' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371785');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA ELISABETH ROMBACH (JUIZ DE FORA) - INEP: 299031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299031' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA ELISABETH ROMBACH' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA PAULO CÉSAR DE MATTOS (JUIZ DE FORA) - INEP: 381462
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381462' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA PAULO CÉSAR DE MATTOS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381462');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA PLENARIUS (JUIZ DE FORA) - INEP: 373249
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373249' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA PLENARIUS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373249');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA UIRANDÊ (JUIZ DE FORA) - INEP: 296465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296465' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA UIRANDÊ' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO - UNIDADE JUIZ DE FORA (JUIZ DE FORA) - INEP: 380300
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380300' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO - UNIDADE JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380300');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMPACTO ESCOLA DE SAÚDE (JUIZ DE FORA) - INEP: 306258
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306258' 
    WHERE UPPER(TRIM(name)) = 'IMPACTO ESCOLA DE SAÚDE' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306258');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IRME - UNIDADE II (JUIZ DE FORA) - INEP: 332828
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332828' 
    WHERE UPPER(TRIM(name)) = 'IRME - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332828');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IRMEP INSTITUTO REGINA MATER DE EDUCAÇÃO PROFISSIONAL (JUIZ DE FORA) - INEP: 356506
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356506' 
    WHERE UPPER(TRIM(name)) = 'IRMEP INSTITUTO REGINA MATER DE EDUCAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356506');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PAINEIRA ESCOLA WALDORF (JUIZ DE FORA) - INEP: 230308
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230308' 
    WHERE UPPER(TRIM(name)) = 'PAINEIRA ESCOLA WALDORF' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230308');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE ENSINO TÉCNICO DE JUIZ DE FORA (JUIZ DE FORA) - INEP: 318671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318671' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE ENSINO TÉCNICO DE JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ FAGUNDES NETO (JUIZ DE FORA) - INEP: 268348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268348' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ FAGUNDES NETO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA DEGRAUS DE ENSINO (JUIZ DE FORA) - INEP: 353990
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353990' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA DEGRAUS DE ENSINO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353990');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- UNITEC EDUCACIONAL (JUIZ DE FORA) - INEP: 343420
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343420' 
    WHERE UPPER(TRIM(name)) = 'UNITEC EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343420');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE LIMA DUARTE (LIMA DUARTE) - INEP: 356239
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356239' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE LIMA DUARTE' 
      AND UPPER(TRIM(city)) = 'LIMA DUARTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356239');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PIAGET DE ENSINO (LIMA DUARTE) - INEP: 304981
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '304981' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PIAGET DE ENSINO' 
      AND UPPER(TRIM(city)) = 'LIMA DUARTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '304981');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA RECREAR - CASA DA EDUCAÇÃO E DA CULTURA (MATIAS BARBOSA) - INEP: 327433
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327433' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA RECREAR - CASA DA EDUCAÇÃO E DA CULTURA' 
      AND UPPER(TRIM(city)) = 'MATIAS BARBOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327433');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- BIOTÉCNICO COLÉGIO E CURSOS (SANTOS DUMONT) - INEP: 372366
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372366' 
    WHERE UPPER(TRIM(name)) = 'BIOTÉCNICO COLÉGIO E CURSOS' 
      AND UPPER(TRIM(city)) = 'SANTOS DUMONT' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372366');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PROMOVE (SANTOS DUMONT) - INEP: 352640
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352640' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PROMOVE' 
      AND UPPER(TRIM(city)) = 'SANTOS DUMONT' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352640');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO DE ENSINO ARCO-ÍRIS (SANTOS DUMONT) - INEP: 361119
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361119' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO DE ENSINO ARCO-ÍRIS' 
      AND UPPER(TRIM(city)) = 'SANTOS DUMONT' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361119');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO JOÃO NEPOMUCENO (SÃO JOÃO NEPOMUCENO) - INEP: 325872
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325872' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO JOÃO NEPOMUCENO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325872');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI  ROBSON BRAGA DE ANDRADE (SÃO JOÃO NEPOMUCENO) - INEP: 323748
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323748' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI ROBSON BRAGA DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323748');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI SÃO JOÃO NEPOMUCENO UI - ROBSON BRAGA DE ANDRADE (SÃO JOÃO NEPOMUCENO) - INEP: 368075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368075' 
    WHERE UPPER(TRIM(name)) = 'SENAI SÃO JOÃO NEPOMUCENO UI - ROBSON BRAGA DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368075');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL DE ALÉM PARAÍBA (ALÉM PARAÍBA) - INEP: 333662
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333662' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL DE ALÉM PARAÍBA' 
      AND UPPER(TRIM(city)) = 'ALÉM PARAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333662');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO DE EDUCAÇÃO PROFISSIONAL-CENTEP (ALÉM PARAÍBA) - INEP: 354058
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354058' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO DE EDUCAÇÃO PROFISSIONAL-CENTEP' 
      AND UPPER(TRIM(city)) = 'ALÉM PARAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354058');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CENECISTA PROFESSOR SÉRGIO FERREIRA (ALÉM PARAÍBA) - INEP: 102326
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102326' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CENECISTA PROFESSOR SÉRGIO FERREIRA' 
      AND UPPER(TRIM(city)) = 'ALÉM PARAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102326');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOS SANTOS ANJOS (ALÉM PARAÍBA) - INEP: 102318
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102318' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOS SANTOS ANJOS' 
      AND UPPER(TRIM(city)) = 'ALÉM PARAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102318');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMAC -ESCOLA MARIA ANTONIETA CORTES (ALÉM PARAÍBA) - INEP: 266566
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266566' 
    WHERE UPPER(TRIM(name)) = 'EMAC -ESCOLA MARIA ANTONIETA CORTES' 
      AND UPPER(TRIM(city)) = 'ALÉM PARAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266566');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CATAGUASES (CATAGUASES) - INEP: 322695
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322695' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CATAGUASES' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322695');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CECÍLIA MEIRELES (CATAGUASES) - INEP: 357030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357030' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CECÍLIA MEIRELES' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE CATAGUASES (CATAGUASES) - INEP: 240761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240761' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE CATAGUASES' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SOBERANO (CATAGUASES) - INEP: 334103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334103' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SOBERANO' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE FORMAÇÃO GERENCIAL - EFG  - CATAGUASES (CATAGUASES) - INEP: 267627
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267627' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE FORMAÇÃO GERENCIAL - EFG - CATAGUASES' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267627');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO NOSSA SENHORA DO CARMO (CATAGUASES) - INEP: 102415
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102415' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102415');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI- CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ IGNÁCIO PEIXOTO (CATAGUASES) - INEP: 248959
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248959' 
    WHERE UPPER(TRIM(name)) = 'SENAI- CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ IGNÁCIO PEIXOTO' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248959');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL NOVO HORIZONTE (LEOPOLDINA) - INEP: 254819
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254819' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NOVO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254819');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE LEOPOLDINA (LEOPOLDINA) - INEP: 381039
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381039' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE LEOPOLDINA' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381039');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE LEOPOLDINA (LEOPOLDINA) - INEP: 250449
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250449' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE LEOPOLDINA' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250449');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMACULADA CONCEIÇÃO (LEOPOLDINA) - INEP: 102482
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102482' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102482');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EPEL ESCOLA POLITÉCNICA EQUIPE DE LEOPOLDINA (LEOPOLDINA) - INEP: 354627
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354627' 
    WHERE UPPER(TRIM(name)) = 'EPEL ESCOLA POLITÉCNICA EQUIPE DE LEOPOLDINA' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354627');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MARTINS E COSTA - CEMEC (PIRAPETINGA) - INEP: 352462
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352462' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MARTINS E COSTA - CEMEC' 
      AND UPPER(TRIM(city)) = 'PIRAPETINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352462');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL NORMA AMÉLIA PIRES-CENAP (PIRAPETINGA) - INEP: 279463
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279463' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NORMA AMÉLIA PIRES-CENAP' 
      AND UPPER(TRIM(city)) = 'PIRAPETINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279463');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA EVOLUÇÃO (CHALÉ) - INEP: 369144
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369144' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA EVOLUÇÃO' 
      AND UPPER(TRIM(city)) = 'CHALÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369144');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA MARGARIDA ALVES - EFAMA (CONCEIÇÃO DE IPANEMA) - INEP: 344397
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344397' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA MARGARIDA ALVES - EFAMA' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DE IPANEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344397');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL COOPCEL (LAJINHA) - INEP: 279056
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279056' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL COOPCEL' 
      AND UPPER(TRIM(city)) = 'LAJINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279056');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA VÉRTIX - UNIDADE DE LAJINHA (LAJINHA) - INEP: 381098
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381098' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA VÉRTIX - UNIDADE DE LAJINHA' 
      AND UPPER(TRIM(city)) = 'LAJINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381098');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEM- CENTRO EDUCACIONAL DE MANHUAÇU (MANHUAÇU) - INEP: 293971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293971' 
    WHERE UPPER(TRIM(name)) = 'CEM- CENTRO EDUCACIONAL DE MANHUAÇU' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AMÉRICA DO NORTE (MANHUAÇU) - INEP: 321770
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321770' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AMÉRICA DO NORTE' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321770');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AMÉRICA DO SUL (MANHUAÇU) - INEP: 321761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321761' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AMÉRICA DO SUL' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE MANHUAÇU (MANHUAÇU) - INEP: 325163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325163' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE MANHUAÇU' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DE ESTUDOS INTEGRADOS - CESI (MANHUAÇU) - INEP: 299367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299367' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DE ESTUDOS INTEGRADOS - CESI' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DO FUTURO (MANHUAÇU) - INEP: 294357
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294357' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DO FUTURO' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294357');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ORBIS EDUCAÇÃO (MANHUAÇU) - INEP: 342874
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342874' 
    WHERE UPPER(TRIM(name)) = 'ORBIS EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342874');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC- UNIDADE ENSINO TÉCNICO- CFP DE MANHUAÇU (MANHUAÇU) - INEP: 339903
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339903' 
    WHERE UPPER(TRIM(name)) = 'SENAC- UNIDADE ENSINO TÉCNICO- CFP DE MANHUAÇU' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339903');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIO XI DE MANHUMIRIM (MANHUMIRIM) - INEP: 369527
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369527' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIO XI DE MANHUMIRIM' 
      AND UPPER(TRIM(city)) = 'MANHUMIRIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369527');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA VERTENTE DO CAPARAÓ DE MANHUMIRIM - EVEC MANHUMIRIM (MANHUMIRIM) - INEP: 338605
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338605' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA VERTENTE DO CAPARAÓ DE MANHUMIRIM - EVEC MANHUMIRIM' 
      AND UPPER(TRIM(city)) = 'MANHUMIRIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338605');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DE MATIPÓ (MATIPÓ) - INEP: 313483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313483' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DE MATIPÓ' 
      AND UPPER(TRIM(city)) = 'MATIPÓ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA VÉRTIX (MATIPÓ) - INEP: 352578
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352578' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA VÉRTIX' 
      AND UPPER(TRIM(city)) = 'MATIPÓ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352578');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUTUM (MUTUM) - INEP: 316377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316377' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUTUM' 
      AND UPPER(TRIM(city)) = 'MUTUM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DE SIMONÉSIA (SIMONÉSIA) - INEP: 313408
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313408' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DE SIMONÉSIA' 
      AND UPPER(TRIM(city)) = 'SIMONÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313408');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL BELDANI (BARÃO DE COCAIS) - INEP: 253065
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253065' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL BELDANI' 
      AND UPPER(TRIM(city)) = 'BARÃO DE COCAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253065');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO PROFISSIONAL GUILHERME CALDAS EMRICH-SENAI (BARÃO DE COCAIS) - INEP: 327816
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327816' 
    WHERE UPPER(TRIM(name)) = 'CENTRO PROFISSIONAL GUILHERME CALDAS EMRICH-SENAI' 
      AND UPPER(TRIM(city)) = 'BARÃO DE COCAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327816');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCARE (BARÃO DE COCAIS) - INEP: 229946
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229946' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCARE' 
      AND UPPER(TRIM(city)) = 'BARÃO DE COCAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229946');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- VEREDAS EDUCAÇÃO (BARÃO DE COCAIS) - INEP: 376809
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376809' 
    WHERE UPPER(TRIM(name)) = 'VEREDAS EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'BARÃO DE COCAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376809');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ABV ETEC MG - ESCOLA TÉCNICA DE MINAS GERAIS (BELO HORIZONTE) - INEP: 381470
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381470' 
    WHERE UPPER(TRIM(name)) = 'ABV ETEC MG - ESCOLA TÉCNICA DE MINAS GERAIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381470');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CASA DOS QUADRINHOS ESCOLA DE ARTES (BELO HORIZONTE) - INEP: 340740
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340740' 
    WHERE UPPER(TRIM(name)) = 'CASA DOS QUADRINHOS ESCOLA DE ARTES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340740');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CASA VIVA EDUCAÇÃO E CULTURA (BELO HORIZONTE) - INEP: 365424
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365424' 
    WHERE UPPER(TRIM(name)) = 'CASA VIVA EDUCAÇÃO E CULTURA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365424');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFEMG- CENTRO DE FORMAÇÃO EM ENFERMAGEM DE MINAS GERAIS (BELO HORIZONTE) - INEP: 306690
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306690' 
    WHERE UPPER(TRIM(name)) = 'CEFEMG- CENTRO DE FORMAÇÃO EM ENFERMAGEM DE MINAS GERAIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306690');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO PROFISSIONAL SENAC - PLUGMINAS (BELO HORIZONTE) - INEP: 364282
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364282' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO PROFISSIONAL SENAC - PLUGMINAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364282');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO TECNOLÓGICA NOVO RUMO (BELO HORIZONTE) - INEP: 292567
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292567' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO TECNOLÓGICA NOVO RUMO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292567');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO GRAU TÉCNICO - UNIDADE BELO HORIZONTE (BELO HORIZONTE) - INEP: 363790
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363790' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO GRAU TÉCNICO - UNIDADE BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363790');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO GRAU TÉCNICO BH - UNIDADE III (BELO HORIZONTE) - INEP: 371041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371041' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO GRAU TÉCNICO BH - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO ARTÍSTICA E TECNOLÓGICA - CEFART- FUNDAÇÃO CLÓVIS SALGADO (BELO HORIZONTE) - INEP: 280526
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280526' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO ARTÍSTICA E TECNOLÓGICA - CEFART- FUNDAÇÃO CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280526');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL PAULO CÉSAR DIAS DE SOUZA (BELO HORIZONTE) - INEP: 342769
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342769' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL PAULO CÉSAR DIAS DE SOUZA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342769');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO TECNOLÓGICA DE MINAS GERAIS - CENTROMIG (BELO HORIZONTE) - INEP: 353132
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353132' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO TECNOLÓGICA DE MINAS GERAIS - CENTROMIG' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353132');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ARCA DE NOÉ (BELO HORIZONTE) - INEP: 331864
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331864' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ARCA DE NOÉ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331864');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL SANGI (BELO HORIZONTE) - INEP: 315389
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315389' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL SANGI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315389');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALUMNUS (BELO HORIZONTE) - INEP: 314749
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314749' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALUMNUS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314749');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BERNOULLI - UNIDADE GONÇALVES DIAS (BELO HORIZONTE) - INEP: 311723
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311723' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BERNOULLI - UNIDADE GONÇALVES DIAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311723');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BERNOULLI - UNIDADE LOURDES (BELO HORIZONTE) - INEP: 350664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350664' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BERNOULLI - UNIDADE LOURDES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CHROMOS CENTRO (BELO HORIZONTE) - INEP: 363294
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363294' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CHROMOS CENTRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363294');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CONVIVER (BELO HORIZONTE) - INEP: 344621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344621' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CONVIVER' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COTEMIG- FLORESTA (BELO HORIZONTE) - INEP: 210048
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210048' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COTEMIG- FLORESTA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210048');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRESCER (BELO HORIZONTE) - INEP: 305456
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305456' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRESCER' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305456');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRISTÃO VER (BELO HORIZONTE) - INEP: 315567
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315567' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRISTÃO VER' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315567');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ECCELLENTE - UNIDADE PALMARES (BELO HORIZONTE) - INEP: 365904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365904' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ECCELLENTE - UNIDADE PALMARES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365904');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDNA RORIZ (BELO HORIZONTE) - INEP: 260631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260631' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDNA RORIZ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ILÚMINA (BELO HORIZONTE) - INEP: 300454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '300454' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ILÚMINA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '300454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOGOSÓFICO GONZÁLEZ PECOTCHE CIDADE NOVA (BELO HORIZONTE) - INEP: 244058
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244058' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOGOSÓFICO GONZÁLEZ PECOTCHE CIDADE NOVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244058');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MANGABEIRAS (BELO HORIZONTE) - INEP: 347329
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347329' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MANGABEIRAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347329');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAXIMUS UNIDADE PALMARES (BELO HORIZONTE) - INEP: 258644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258644' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAXIMUS UNIDADE PALMARES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MÉTODO (BELO HORIZONTE) - INEP: 210251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210251' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MÉTODO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OLIMPO BH (BELO HORIZONTE) - INEP: 369772
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369772' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OLIMPO BH' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369772');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ORLEANS E BRAGANÇA (BELO HORIZONTE) - INEP: 370258
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370258' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ORLEANS E BRAGANÇA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370258');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OURO MINAS (BELO HORIZONTE) - INEP: 344001
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344001' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OURO MINAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344001');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO REDE DECISÃO - UNIDADE LOURDES (BELO HORIZONTE) - INEP: 378313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378313' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO REDE DECISÃO - UNIDADE LOURDES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA MARIA MINAS - UNIDADE SÃO GABRIEL (BELO HORIZONTE) - INEP: 381144
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381144' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA MARIA MINAS - UNIDADE SÃO GABRIEL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381144');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SAVASSI (BELO HORIZONTE) - INEP: 307742
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307742' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SAVASSI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307742');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SISTEMA (BELO HORIZONTE) - INEP: 257583
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257583' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SISTEMA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257583');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM INTERNACIONAL - CIDADE NOVA (BELO HORIZONTE) - INEP: 374555
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374555' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM INTERNACIONAL - CIDADE NOVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374555');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONHECER ESCOLA TÉCNICA - UNIDADE II (BELO HORIZONTE) - INEP: 303461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303461' 
    WHERE UPPER(TRIM(name)) = 'CONHECER ESCOLA TÉCNICA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ELITE FLORESTA - BH (BELO HORIZONTE) - INEP: 374180
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374180' 
    WHERE UPPER(TRIM(name)) = 'ELITE FLORESTA - BH' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374180');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ENFERMIG- ESCOLA DE ENFERMAGEM DE MINAS GERAIS (BELO HORIZONTE) - INEP: 279391
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279391' 
    WHERE UPPER(TRIM(name)) = 'ENFERMIG- ESCOLA DE ENFERMAGEM DE MINAS GERAIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279391');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRISTÃ IBF (BELO HORIZONTE) - INEP: 244481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244481' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRISTÃ IBF' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DA SERRA (BELO HORIZONTE) - INEP: 320404
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320404' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DA SERRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320404');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE PRÓTESE ODONTOLÓGICA EXPERT M MARTINS (BELO HORIZONTE) - INEP: 283274
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '283274' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE PRÓTESE ODONTOLÓGICA EXPERT M MARTINS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '283274');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DO SEBRAE DE FORMAÇÃO GERENCIAL BH - NÚCLEO DE EMPREENDEDORISMO JUVENIL - EFG SEBRAE BH - NEJ (BELO HORIZONTE) - INEP: 348953
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348953' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DO SEBRAE DE FORMAÇÃO GERENCIAL BH - NÚCLEO DE EMPREENDEDORISMO JUVENIL - EFG SEBRAE BH - NEJ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348953');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI NEWTON ANTÔNIO DA SILVA PEREIRA - UNIDADE II (BELO HORIZONTE) - INEP: 379816
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379816' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI NEWTON ANTÔNIO DA SILVA PEREIRA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379816');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DA FUNDAÇÃO UNIMED (BELO HORIZONTE) - INEP: 376833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376833' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DA FUNDAÇÃO UNIMED' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DA SANTA CASA (BELO HORIZONTE) - INEP: 267082
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267082' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DA SANTA CASA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267082');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA PRÓ INFORMÁTICA (BELO HORIZONTE) - INEP: 342947
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342947' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA PRÓ INFORMÁTICA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342947');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA SAÚDE E VIDA (BELO HORIZONTE) - INEP: 260649
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260649' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA SAÚDE E VIDA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260649');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESTAÇÃO ENSINO (BELO HORIZONTE) - INEP: 354139
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354139' 
    WHERE UPPER(TRIM(name)) = 'ESTAÇÃO ENSINO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354139');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FACULDADE DE TECNOLOGIA SENAI (BELO HORIZONTE) - INEP: 367222
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367222' 
    WHERE UPPER(TRIM(name)) = 'FACULDADE DE TECNOLOGIA SENAI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367222');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMAM INSTITUTO MINEIRO DE ACUPUNTURA E MASSAGENS (BELO HORIZONTE) - INEP: 306703
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306703' 
    WHERE UPPER(TRIM(name)) = 'IMAM INSTITUTO MINEIRO DE ACUPUNTURA E MASSAGENS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306703');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INAP- INSTITUTO DE ARTE E PROJETO (BELO HORIZONTE) - INEP: 274666
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274666' 
    WHERE UPPER(TRIM(name)) = 'INAP- INSTITUTO DE ARTE E PROJETO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274666');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO ARCANJO GABRIEL (BELO HORIZONTE) - INEP: 345814
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345814' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO ARCANJO GABRIEL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345814');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SÃO CAMILO (BELO HORIZONTE) - INEP: 354511
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354511' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SÃO CAMILO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354511');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MAPLE BEAR CANADIAN SCHOOL BELO HORIZONTE (BELO HORIZONTE) - INEP: 345644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345644' 
    WHERE UPPER(TRIM(name)) = 'MAPLE BEAR CANADIAN SCHOOL BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- POLITEC MG - ESCOLA POLITÉCNICA MG (BELO HORIZONTE) - INEP: 312371
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312371' 
    WHERE UPPER(TRIM(name)) = 'POLITEC MG - ESCOLA POLITÉCNICA MG' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312371');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PROZ - UNIDADE BELO HORIZONTE (BELO HORIZONTE) - INEP: 353329
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353329' 
    WHERE UPPER(TRIM(name)) = 'PROZ - UNIDADE BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353329');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- REDE M2 - JOÃO PINHEIRO (BELO HORIZONTE) - INEP: 377686
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377686' 
    WHERE UPPER(TRIM(name)) = 'REDE M2 - JOÃO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377686');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TECNICO - CFP BELO HORIZONTE (BELO HORIZONTE) - INEP: 262641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262641' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TECNICO - CFP BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI BELO HORIZONTE CFP NANSEN ARAÚJO (BELO HORIZONTE) - INEP: 380644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380644' 
    WHERE UPPER(TRIM(name)) = 'SENAI BELO HORIZONTE CFP NANSEN ARAÚJO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI C AUTOMOT FORM PROFISSIONAL (BELO HORIZONTE) - INEP: 267678
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267678' 
    WHERE UPPER(TRIM(name)) = 'SENAI C AUTOMOT FORM PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267678');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI C DE DESEN TECNOLÓGICO PARA O VESTUÁRIO (BELO HORIZONTE) - INEP: 329614
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329614' 
    WHERE UPPER(TRIM(name)) = 'SENAI C DE DESEN TECNOLÓGICO PARA O VESTUÁRIO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329614');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL SÉRGIO FREITAS PACHECO CECOTEG (BELO HORIZONTE) - INEP: 274682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274682' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL SÉRGIO FREITAS PACHECO CECOTEG' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI- CENTRO TECNOLÓGICO CÉSAR RODRIGUES (BELO HORIZONTE) - INEP: 267589
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267589' 
    WHERE UPPER(TRIM(name)) = 'SENAI- CENTRO TECNOLÓGICO CÉSAR RODRIGUES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267589');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MARIA SENHORINHA DE LIMA (BELO VALE) - INEP: 365475
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365475' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MARIA SENHORINHA DE LIMA' 
      AND UPPER(TRIM(city)) = 'BELO VALE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365475');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CECÍLIA MARIA DE MELO BARCELOS (BRUMADINHO) - INEP: 329606
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329606' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CECÍLIA MARIA DE MELO BARCELOS' 
      AND UPPER(TRIM(city)) = 'BRUMADINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329606');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MARIA MADALENA FRICHE PASSOS - CEMMA (BRUMADINHO) - INEP: 223131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223131' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MARIA MADALENA FRICHE PASSOS - CEMMA' 
      AND UPPER(TRIM(city)) = 'BRUMADINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223131');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SISTEMA PEDAGÓGICO SEMEAR (BRUMADINHO) - INEP: 279277
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279277' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SISTEMA PEDAGÓGICO SEMEAR' 
      AND UPPER(TRIM(city)) = 'BRUMADINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279277');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL DA FEC (CAETÉ) - INEP: 319996
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319996' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL DA FEC' 
      AND UPPER(TRIM(city)) = 'CAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319996');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM FLORENCE NIGHTINGALE (CAETÉ) - INEP: 293954
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293954' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM FLORENCE NIGHTINGALE' 
      AND UPPER(TRIM(city)) = 'CAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293954');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL E PSICOPEDAGÓGICO SENA FIGUEIREDO (CAETÉ) - INEP: 278530
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278530' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL E PSICOPEDAGÓGICO SENA FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'CAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278530');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO COMUNITÁRIO EDUCACIONAL DE CAETÉ (CAETÉ) - INEP: 279552
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279552' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO COMUNITÁRIO EDUCACIONAL DE CAETÉ' 
      AND UPPER(TRIM(city)) = 'CAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279552');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ARACÊ ESCOLA (NOVA LIMA) - INEP: 369357
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369357' 
    WHERE UPPER(TRIM(name)) = 'ARACÊ ESCOLA' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369357');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL AFONSO GRECO-SENAI (NOVA LIMA) - INEP: 315931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315931' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL AFONSO GRECO-SENAI' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL SÃO TOMÁS DE AQUINO (NOVA LIMA) - INEP: 229865
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229865' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL SÃO TOMÁS DE AQUINO' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229865');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO - UNIDADE ALPHAVILLE NOVA LIMA (NOVA LIMA) - INEP: 354600
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354600' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO - UNIDADE ALPHAVILLE NOVA LIMA' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354600');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTO AGOSTINHO - UNIDADE NOVA LIMA (NOVA LIMA) - INEP: 333921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333921' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTO AGOSTINHO - UNIDADE NOVA LIMA' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333921');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE JARDIM CANADÁ (NOVA LIMA) - INEP: 341550
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '341550' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE JARDIM CANADÁ' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '341550');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE FORMAÇÃO GERENCIAL NOVA LIMA - METODOLOGIA SEBRAE (NOVA LIMA) - INEP: 276413
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276413' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE FORMAÇÃO GERENCIAL NOVA LIMA - METODOLOGIA SEBRAE' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276413');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA INTERNACIONAL DE FORMAÇÃO GERENCIAL (NOVA LIMA) - INEP: 249548
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249548' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA INTERNACIONAL DE FORMAÇÃO GERENCIAL' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249548');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MAPLE BEAR ALPHAVILLE LAGOA DOS INGLESES (NOVA LIMA) - INEP: 354473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354473' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MAPLE BEAR ALPHAVILLE LAGOA DOS INGLESES' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FUNDAÇÃO DE EDUCAÇÃO PARA O TRABALHO DE MINAS GERAIS-UTRAMIG (NOVA LIMA) - INEP: 345024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345024' 
    WHERE UPPER(TRIM(name)) = 'FUNDAÇÃO DE EDUCAÇÃO PARA O TRABALHO DE MINAS GERAIS-UTRAMIG' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO CÁSSIO MAGNANI (NOVA LIMA) - INEP: 266655
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266655' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO CÁSSIO MAGNANI' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266655');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO CÁSSIO MAGNANI - UNIDADE II (NOVA LIMA) - INEP: 378453
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378453' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO CÁSSIO MAGNANI - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378453');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO ÍTALO BRASILEIRO BICULTURAL (NOVA LIMA) - INEP: 249483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249483' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO ÍTALO BRASILEIRO BICULTURAL' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO OURO VERDE (NOVA LIMA) - INEP: 356700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356700' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO OURO VERDE' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PÓLEN ESCOLA WALDORF (NOVA LIMA) - INEP: 255190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '255190' 
    WHERE UPPER(TRIM(name)) = 'PÓLEN ESCOLA WALDORF' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '255190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VILLA REAL (SABARÁ) - INEP: 293423
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293423' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VILLA REAL' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293423');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI HANS SCHLACHER (SABARÁ) - INEP: 259730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259730' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI HANS SCHLACHER' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO CLUBE DO MICKEY (SABARÁ) - INEP: 229784
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229784' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO CLUBE DO MICKEY' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229784');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI -  CENTRO DE FORMAÇÃO PROFISSIONAL MICHEL MICHELS (SABARÁ) - INEP: 298999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298999' 
    WHERE UPPER(TRIM(name)) = 'SENAI - CENTRO DE FORMAÇÃO PROFISSIONAL MICHEL MICHELS' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO PEDAGÓGICO CECÍLIA MEIRELES (SANTA BÁRBARA) - INEP: 261394
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261394' 
    WHERE UPPER(TRIM(name)) = 'CENTRO PEDAGÓGICO CECÍLIA MEIRELES' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261394');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SEPRO- SISTEMA DE EDUCAÇÃO PROFISSIONAL DE ITABIRA (SANTA BÁRBARA) - INEP: 348970
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348970' 
    WHERE UPPER(TRIM(name)) = 'SEPRO- SISTEMA DE EDUCAÇÃO PROFISSIONAL DE ITABIRA' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348970');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ATOS SCHOOL EDUCACIONAL (BELO HORIZONTE) - INEP: 368105
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368105' 
    WHERE UPPER(TRIM(name)) = 'ATOS SCHOOL EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368105');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CECON-TI-CENTRO EDUCACIONAL DE TECNOLOGIA DA INFORMAÇÃO (BELO HORIZONTE) - INEP: 348732
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348732' 
    WHERE UPPER(TRIM(name)) = 'CECON-TI-CENTRO EDUCACIONAL DE TECNOLOGIA DA INFORMAÇÃO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348732');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEMA - CENTRO EDUCACIONAL MARIA APARECIDA (BELO HORIZONTE) - INEP: 332429
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332429' 
    WHERE UPPER(TRIM(name)) = 'CEMA - CENTRO EDUCACIONAL MARIA APARECIDA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332429');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEMAR -CENTRO EDUCACIONAL MÁRIO RABELO - UNIDADE I (BELO HORIZONTE) - INEP: 257427
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257427' 
    WHERE UPPER(TRIM(name)) = 'CEMAR -CENTRO EDUCACIONAL MÁRIO RABELO - UNIDADE I' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257427');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO TÉCNICO DE MINAS GERAIS - TECMIG (BELO HORIZONTE) - INEP: 373567
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373567' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO TÉCNICO DE MINAS GERAIS - TECMIG' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373567');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL EM SECRETARIADO DE MINAS GERAIS - CEFPROSEMG (BELO HORIZONTE) - INEP: 350893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350893' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL EM SECRETARIADO DE MINAS GERAIS - CEFPROSEMG' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350893');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PIAGET I (BELO HORIZONTE) - INEP: 297453
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297453' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PIAGET I' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297453');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CHROMOS BURITIS (BELO HORIZONTE) - INEP: 373990
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373990' 
    WHERE UPPER(TRIM(name)) = 'COL CHROMOS BURITIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373990');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CHROMOS SERRANO (BELO HORIZONTE) - INEP: 257397
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257397' 
    WHERE UPPER(TRIM(name)) = 'COL CHROMOS SERRANO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257397');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ABGAR RENAULT - UNIDADE GLÓRIA (BELO HORIZONTE) - INEP: 253995
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253995' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ABGAR RENAULT - UNIDADE GLÓRIA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253995');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADVENTISTA DO BURITIS (BELO HORIZONTE) - INEP: 377503
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377503' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADVENTISTA DO BURITIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377503');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO -  UNIDADE BURITIS II (BELO HORIZONTE) - INEP: 329282
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329282' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO - UNIDADE BURITIS II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329282');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO-UNIDADE BURITIS (BELO HORIZONTE) - INEP: 354007
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354007' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO-UNIDADE BURITIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354007');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BURITIS AGOSTINIANO (BELO HORIZONTE) - INEP: 294110
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294110' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BURITIS AGOSTINIANO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294110');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CAMINHAR BH (BELO HORIZONTE) - INEP: 308943
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '308943' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CAMINHAR BH' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '308943');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CEAPS (BELO HORIZONTE) - INEP: 321621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321621' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CEAPS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CHROMOS BARREIRO (BELO HORIZONTE) - INEP: 369977
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369977' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CHROMOS BARREIRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369977');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CORAÇÃO DE ESTUDANTE (BELO HORIZONTE) - INEP: 267511
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267511' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CORAÇÃO DE ESTUDANTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267511');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CORAÇÃO DE ESTUDANTE - UNIDADE SANTA CRUZ (BELO HORIZONTE) - INEP: 294047
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294047' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CORAÇÃO DE ESTUDANTE - UNIDADE SANTA CRUZ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294047');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRISTÃO ATOS (BELO HORIZONTE) - INEP: 319341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319341' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRISTÃO ATOS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRISTO REDENTOR (BELO HORIZONTE) - INEP: 329908
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329908' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRISTO REDENTOR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329908');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DIMENSÃO (BELO HORIZONTE) - INEP: 220329
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220329' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DIMENSÃO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220329');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DIVERSITAS (BELO HORIZONTE) - INEP: 292982
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292982' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DIVERSITAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292982');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EMAÚS (BELO HORIZONTE) - INEP: 354813
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354813' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EMAÚS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354813');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JEAN PIAGET (BELO HORIZONTE) - INEP: 305057
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305057' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JEAN PIAGET' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305057');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JOÃO DE BARRO (BELO HORIZONTE) - INEP: 257656
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257656' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JOÃO DE BARRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257656');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LE PETIT (BELO HORIZONTE) - INEP: 327638
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327638' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LE PETIT' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327638');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOS ANGELOS - IPLAS (BELO HORIZONTE) - INEP: 321613
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321613' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOS ANGELOS - IPLAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321613');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MASTER PIMENTINHA (BELO HORIZONTE) - INEP: 257877
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257877' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MASTER PIMENTINHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257877');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO METRÓPOLE (BELO HORIZONTE) - INEP: 320889
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320889' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO METRÓPOLE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320889');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PENTÁGONO (BELO HORIZONTE) - INEP: 297879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297879' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PENTÁGONO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SABIRACEMA (BELO HORIZONTE) - INEP: 315052
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315052' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SABIRACEMA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315052');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA MARIA MINAS - UNIDADE NOVA SUIÇA (BELO HORIZONTE) - INEP: 244457
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244457' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA MARIA MINAS - UNIDADE NOVA SUIÇA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244457');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTO AGOSTINHO - UNIDADE GUTIERREZ (BELO HORIZONTE) - INEP: 370711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370711' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTO AGOSTINHO - UNIDADE GUTIERREZ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SES (BELO HORIZONTE) - INEP: 346420
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346420' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346420');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE ALÍPIO DE MELO (BELO HORIZONTE) - INEP: 358428
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358428' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE ALÍPIO DE MELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358428');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE BURITIS (BELO HORIZONTE) - INEP: 368342
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368342' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE BURITIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368342');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE CARLOS PRATES (BELO HORIZONTE) - INEP: 358541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358541' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE CARLOS PRATES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE GUTIERREZ III (BELO HORIZONTE) - INEP: 364860
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364860' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE GUTIERREZ III' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364860');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE NOVA SUÍÇA (BELO HORIZONTE) - INEP: 377759
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377759' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE NOVA SUÍÇA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377759');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCANDÁRIO ESTRELAS DO FUTURO (BELO HORIZONTE) - INEP: 273244
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273244' 
    WHERE UPPER(TRIM(name)) = 'EDUCANDÁRIO ESTRELAS DO FUTURO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273244');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA AMERICANA DE BELO HORIZONTE (BELO HORIZONTE) - INEP: 244074
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244074' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA AMERICANA DE BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244074');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CANTO VERDE (BELO HORIZONTE) - INEP: 298069
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298069' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CANTO VERDE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298069');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM SOUZA CASTRO (BELO HORIZONTE) - INEP: 299138
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299138' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM SOUZA CASTRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299138');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DO SEBRAE (BELO HORIZONTE) - INEP: 244023
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244023' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DO SEBRAE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244023');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA GRAÇA MAIOR (BELO HORIZONTE) - INEP: 297887
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297887' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA GRAÇA MAIOR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297887');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA POLITÉCNICA DE MINAS GERAIS - POLIMIG - UNIDADE III (BELO HORIZONTE) - INEP: 245925
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245925' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA POLITÉCNICA DE MINAS GERAIS - POLIMIG - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245925');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA POLITÉCNICA DE MINAS GERIAS - POLIMIG - UNIDADE VI (BELO HORIZONTE) - INEP: 372374
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372374' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA POLITÉCNICA DE MINAS GERIAS - POLIMIG - UNIDADE VI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372374');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SEB UINIMASTER (BELO HORIZONTE) - INEP: 309711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309711' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SEB UINIMASTER' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI  GENERAL ONÉSIMO BECKER DE  ARAÚJO (BELO HORIZONTE) - INEP: 246450
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246450' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI GENERAL ONÉSIMO BECKER DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246450');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO ALÍPIO DE MELO (BELO HORIZONTE) - INEP: 377856
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377856' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO ALÍPIO DE MELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377856');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO BARREIRO (BELO HORIZONTE) - INEP: 373230
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373230' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO BARREIRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373230');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEB INSTITUTO EDUCACIONAL BELO HORIZONTE (BELO HORIZONTE) - INEP: 337765
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '337765' 
    WHERE UPPER(TRIM(name)) = 'IEB INSTITUTO EDUCACIONAL BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '337765');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO TEMPO DE DESCOBRIR (BELO HORIZONTE) - INEP: 357235
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357235' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO TEMPO DE DESCOBRIR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357235');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL BAIÃO SANTOS (BELO HORIZONTE) - INEP: 210102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210102' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL BAIÃO SANTOS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL GABRIELA LEOPOLDINA (BELO HORIZONTE) - INEP: 217166
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217166' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL GABRIELA LEOPOLDINA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217166');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MARIA MORATO (BELO HORIZONTE) - INEP: 303682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303682' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MARIA MORATO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO MODAL (BELO HORIZONTE) - INEP: 292753
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292753' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO MODAL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292753');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO SANTA PAULA (BELO HORIZONTE) - INEP: 262251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262251' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO SANTA PAULA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO TÉCNICO INOVAR (BELO HORIZONTE) - INEP: 261696
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261696' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO TÉCNICO INOVAR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261696');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- META - ESCOLA TÉCNICA DE FORMAÇÃO PROFISSIONAL (BELO HORIZONTE) - INEP: 324027
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324027' 
    WHERE UPPER(TRIM(name)) = 'META - ESCOLA TÉCNICA DE FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324027');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- REDE M2 - PRADO (BELO HORIZONTE) - INEP: 374865
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374865' 
    WHERE UPPER(TRIM(name)) = 'REDE M2 - PRADO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374865');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI- CENTRO DE FORMAÇÃO PROFISSIONAL AMÉRICO RENÉ GIANNETTI (BELO HORIZONTE) - INEP: 267571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267571' 
    WHERE UPPER(TRIM(name)) = 'SENAI- CENTRO DE FORMAÇÃO PROFISSIONAL AMÉRICO RENÉ GIANNETTI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL PAULO TARSO (BELO HORIZONTE) - INEP: 309648
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309648' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL PAULO TARSO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309648');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SIC - ESCOLA  PROFISSIONALIZANTE SANTO AGOSTINHO (BELO HORIZONTE) - INEP: 324663
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324663' 
    WHERE UPPER(TRIM(name)) = 'SIC - ESCOLA PROFISSIONALIZANTE SANTO AGOSTINHO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324663');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA ÁPICE DE ENSINO (BELO HORIZONTE) - INEP: 256889
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256889' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA ÁPICE DE ENSINO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256889');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA EDUCACIONAL ATHENA - UNIDADE MUNDO DA CRIANÇA (BELO HORIZONTE) - INEP: 309184
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309184' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA EDUCACIONAL ATHENA - UNIDADE MUNDO DA CRIANÇA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309184');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEB- CENTRO EDUCACIONAL DE BETIM (BETIM) - INEP: 334502
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334502' 
    WHERE UPPER(TRIM(name)) = 'CEB- CENTRO EDUCACIONAL DE BETIM' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334502');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TECNOLÓGICO DE MECATRÔNICA MARIA MADALENA NOGUEIRA- SENAI (BETIM) - INEP: 267775
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267775' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TECNOLÓGICO DE MECATRÔNICA MARIA MADALENA NOGUEIRA- SENAI' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267775');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCARE DE BETIM (BETIM) - INEP: 235555
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235555' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCARE DE BETIM' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235555');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NEUZA DUTRA (BETIM) - INEP: 276651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276651' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NEUZA DUTRA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA MARIA MINAS - UNIDADE BETIM (BETIM) - INEP: 353906
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353906' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA MARIA MINAS - UNIDADE BETIM' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353906');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTIAGO (BETIM) - INEP: 320510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320510' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTIAGO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SONHO MEU (BETIM) - INEP: 267465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267465' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SONHO MEU' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO GENOMA (BETIM) - INEP: 321893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321893' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO GENOMA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321893');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO IMEC (BETIM) - INEP: 354643
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354643' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO IMEC' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354643');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ECOTEC (BETIM) - INEP: 344893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344893' 
    WHERE UPPER(TRIM(name)) = 'ECOTEC' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344893');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI MARIA MADALENA NOGUEIRA (BETIM) - INEP: 365114
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365114' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI MARIA MADALENA NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365114');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO BETIM (BETIM) - INEP: 381136
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381136' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO BETIM' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381136');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMEC BETIM (BETIM) - INEP: 370215
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370215' 
    WHERE UPPER(TRIM(name)) = 'IMEC BETIM' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370215');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL DÉBORA ROCHA (BETIM) - INEP: 324761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324761' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL DÉBORA ROCHA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL GESTALD (BETIM) - INEP: 323764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323764' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL GESTALD' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MARRIAN (BETIM) - INEP: 223123
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223123' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MARRIAN' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223123');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO OLIVEIRA LARA - UNIDADE CRESCER DE ENSINO (BETIM) - INEP: 328014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '328014' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO OLIVEIRA LARA - UNIDADE CRESCER DE ENSINO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '328014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO RAIO DE SOL (BETIM) - INEP: 324396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324396' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO RAIO DE SOL' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IPAC- INSTITUTO PATRÍCIA CARVALHO (BETIM) - INEP: 294241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294241' 
    WHERE UPPER(TRIM(name)) = 'IPAC- INSTITUTO PATRÍCIA CARVALHO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP BETIM (BETIM) - INEP: 358207
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358207' 
    WHERE UPPER(TRIM(name)) = 'SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP BETIM' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358207');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CCV - COLÉGIO CRISTÃO VITÓRIA (CONTAGEM) - INEP: 321818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321818' 
    WHERE UPPER(TRIM(name)) = 'CCV - COLÉGIO CRISTÃO VITÓRIA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEMAR CENTRO EDUCACIONAL MÁRIO RABELO - UNIDADE II (CONTAGEM) - INEP: 310891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310891' 
    WHERE UPPER(TRIM(name)) = 'CEMAR CENTRO EDUCACIONAL MÁRIO RABELO - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENAD - CENTRO DE APRENDIZAGEM E DESENVOLVIMENTO PROFISSIONAL (CONTAGEM) - INEP: 375683
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375683' 
    WHERE UPPER(TRIM(name)) = 'CENAD - CENTRO DE APRENDIZAGEM E DESENVOLVIMENTO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375683');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO INFANTIL MÉRITO (CONTAGEM) - INEP: 279803
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279803' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO INFANTIL MÉRITO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279803');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EXCELÊNCIA INTEGRADO AVANÇAR - CEIAV - UNIDADE II (CONTAGEM) - INEP: 380008
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380008' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EXCELÊNCIA INTEGRADO AVANÇAR - CEIAV - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380008');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL VASCONCELOS (CONTAGEM) - INEP: 329240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329240' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EXCELÊNCIA INTEGRADO AVANÇAR - CEIAV (CONTAGEM) - INEP: 319767
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319767' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EXCELÊNCIA INTEGRADO AVANÇAR - CEIAV' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319767');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO INTEGRADO SESI/SENAI DONA NENÉM  SCARIOLLI (CONTAGEM) - INEP: 349429
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349429' 
    WHERE UPPER(TRIM(name)) = 'CENTRO INTEGRADO SESI/SENAI DONA NENÉM SCARIOLLI' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349429');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESBOC CENTRO EDUCACIONAL PROFISSIONALIZANTE (CONTAGEM) - INEP: 343897
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343897' 
    WHERE UPPER(TRIM(name)) = 'CESBOC CENTRO EDUCACIONAL PROFISSIONALIZANTE' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343897');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESIR- CENTRO EDUCACIONAL SILVEIRA ROCHA (CONTAGEM) - INEP: 313777
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313777' 
    WHERE UPPER(TRIM(name)) = 'CESIR- CENTRO EDUCACIONAL SILVEIRA ROCHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313777');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AGOSTINIANO FREI CARLOS VICUÑA (CONTAGEM) - INEP: 354090
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354090' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AGOSTINIANO FREI CARLOS VICUÑA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354090');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA REMANESCENTES (CONTAGEM) - INEP: 330205
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330205' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA REMANESCENTES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330205');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CEC (CONTAGEM) - INEP: 277673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277673' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CEC' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277673');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CEIAS (CONTAGEM) - INEP: 319741
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319741' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CEIAS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319741');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CHROMOS ELDORADO (CONTAGEM) - INEP: 357120
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357120' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CHROMOS ELDORADO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357120');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CONSTRUIR (CONTAGEM) - INEP: 329819
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329819' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CONSTRUIR' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329819');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRESCER (CONTAGEM) - INEP: 277177
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277177' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRESCER' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277177');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ESPÍRITA PROFESSOR RUBENS COSTA ROMANELLI (CONTAGEM) - INEP: 236926
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236926' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ESPÍRITA PROFESSOR RUBENS COSTA ROMANELLI' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236926');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GLÓRIA ANDRADE (CONTAGEM) - INEP: 260916
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260916' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GLÓRIA ANDRADE' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260916');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO KELLY MIRANDA (CONTAGEM) - INEP: 262676
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262676' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO KELLY MIRANDA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262676');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NIÉDE GUIDON (CONTAGEM) - INEP: 376310
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376310' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NIÉDE GUIDON' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376310');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PAULO FREIRE - UNIDADE NOVO PROGRESSO (CONTAGEM) - INEP: 279099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279099' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PAULO FREIRE - UNIDADE NOVO PROGRESSO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RAFAEL BRITO (CONTAGEM) - INEP: 261297
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261297' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RAFAEL BRITO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261297');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SAGRADO CORAÇÃO DE JESUS (CONTAGEM) - INEP: 265578
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265578' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SAGRADO CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265578');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO GERALDO (CONTAGEM) - INEP: 279102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279102' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO GERALDO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO PEDRO DO VATICANO (CONTAGEM) - INEP: 323730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323730' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO PEDRO DO VATICANO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÓCRATES (CONTAGEM) - INEP: 269395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269395' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÓCRATES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SUPREMO (CONTAGEM) - INEP: 329258
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329258' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SUPREMO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329258');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO JK (CONTAGEM) - INEP: 354066
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354066' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO JK' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354066');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PROFISSIONALIZANTE SANTA RITA DE CÁSSIA (CONTAGEM) - INEP: 276952
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276952' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PROFISSIONALIZANTE SANTA RITA DE CÁSSIA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276952');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FACULDADE SENAC MINAS CONTAGEM (CONTAGEM) - INEP: 359998
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359998' 
    WHERE UPPER(TRIM(name)) = 'FACULDADE SENAC MINAS CONTAGEM' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359998');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FOCUS ESCOLA TÉCNICA (CONTAGEM) - INEP: 323080
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323080' 
    WHERE UPPER(TRIM(name)) = 'FOCUS ESCOLA TÉCNICA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323080');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GAMA ESCOLA TÉCNICA E PROFISSIONALIZANTE (CONTAGEM) - INEP: 340570
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340570' 
    WHERE UPPER(TRIM(name)) = 'GAMA ESCOLA TÉCNICA E PROFISSIONALIZANTE' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340570');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO CONTAGEM (CONTAGEM) - INEP: 373257
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373257' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO CONTAGEM' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373257');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO CONTAGEM - UNIDADE II (CONTAGEM) - INEP: 376876
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376876' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO CONTAGEM - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376876');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIOANL UMBERTO CORRÊA (CONTAGEM) - INEP: 274208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274208' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIOANL UMBERTO CORRÊA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274208');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL EBENEZER (CONTAGEM) - INEP: 223204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223204' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL EBENEZER' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL LIBERTAS (CONTAGEM) - INEP: 327077
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327077' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL LIBERTAS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327077');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


