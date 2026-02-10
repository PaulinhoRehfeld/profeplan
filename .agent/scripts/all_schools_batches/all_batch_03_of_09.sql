-- Lote 3 de 9
-- Escolas 1001 a 1500

-- EE DE ENSINO MÉDIO (POUSO ALEGRE) - INEP: 372102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372102' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MENDONÇA (SENADOR JOSÉ BENTO) - INEP: 124982
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124982' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MENDONÇA' 
      AND UPPER(TRIM(city)) = 'SENADOR JOSÉ BENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124982');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO CARLOS DE CARVALHO (BOM SUCESSO) - INEP: 133728
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133728' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO CARLOS DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'BOM SUCESSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133728');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENJAMIM GUIMARÃES (BOM SUCESSO) - INEP: 133744
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133744' 
    WHERE UPPER(TRIM(name)) = 'EE BENJAMIM GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'BOM SUCESSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133744');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SARA KUBITSCHEK (CARRANCAS) - INEP: 133922
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133922' 
    WHERE UPPER(TRIM(name)) = 'EE SARA KUBITSCHEK' 
      AND UPPER(TRIM(city)) = 'CARRANCAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133922');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ADÍLIO JOSÉ BORGES (CONCEIÇÃO DA BARRA DE MINAS) - INEP: 133931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133931' 
    WHERE UPPER(TRIM(name)) = 'EE ADÍLIO JOSÉ BORGES' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DA BARRA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL XAVIER CHAVES (CORONEL XAVIER CHAVES) - INEP: 133949
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133949' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL XAVIER CHAVES' 
      AND UPPER(TRIM(city)) = 'CORONEL XAVIER CHAVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133949');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DUQUE DE CAXIAS (DORES DE CAMPOS) - INEP: 133973
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133973' 
    WHERE UPPER(TRIM(name)) = 'EE DUQUE DE CAXIAS' 
      AND UPPER(TRIM(city)) = 'DORES DE CAMPOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133973');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JÚLIO BUENO (IBITURUNA) - INEP: 134007
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134007' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JÚLIO BUENO' 
      AND UPPER(TRIM(city)) = 'IBITURUNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134007');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAURÍCIO ZAKHIA (IJACI) - INEP: 134040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134040' 
    WHERE UPPER(TRIM(name)) = 'EE MAURÍCIO ZAKHIA' 
      AND UPPER(TRIM(city)) = 'IJACI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAMIRO DE SOUZA ANDRADE (INGAÍ) - INEP: 134104
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134104' 
    WHERE UPPER(TRIM(name)) = 'EE RAMIRO DE SOUZA ANDRADE' 
      AND UPPER(TRIM(city)) = 'INGAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134104');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CERRADO DO ROSÁRIO (ITUMIRIM) - INEP: 134139
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134139' 
    WHERE UPPER(TRIM(name)) = 'EE CERRADO DO ROSÁRIO' 
      AND UPPER(TRIM(city)) = 'ITUMIRIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134139');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MACUCO DE MINAS (ITUMIRIM) - INEP: 134147
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134147' 
    WHERE UPPER(TRIM(name)) = 'EE DE MACUCO DE MINAS' 
      AND UPPER(TRIM(city)) = 'ITUMIRIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134147');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM DELFIM (ITUMIRIM) - INEP: 134121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134121' 
    WHERE UPPER(TRIM(name)) = 'EE DOM DELFIM' 
      AND UPPER(TRIM(city)) = 'ITUMIRIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JAIME FERREIRA LEITE (ITUTINGA) - INEP: 134163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134163' 
    WHERE UPPER(TRIM(name)) = 'EE JAIME FERREIRA LEITE' 
      AND UPPER(TRIM(city)) = 'ITUTINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABEILARD PEREIRA (LAGOA DOURADA) - INEP: 305600
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305600' 
    WHERE UPPER(TRIM(name)) = 'EE ABEILARD PEREIRA' 
      AND UPPER(TRIM(city)) = 'LAGOA DOURADA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305600');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR BASÍLIO DE MAGALHÃES (NAZARENO) - INEP: 134295
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134295' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR BASÍLIO DE MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'NAZARENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134295');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR VIVIANO CALDAS (PRADOS) - INEP: 134333
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134333' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR VIVIANO CALDAS' 
      AND UPPER(TRIM(city)) = 'PRADOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134333');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ASSIS RESENDE (RESENDE COSTA) - INEP: 134368
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134368' 
    WHERE UPPER(TRIM(name)) = 'EE ASSIS RESENDE' 
      AND UPPER(TRIM(city)) = 'RESENDE COSTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134368');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE CRISPINIANO (RITÁPOLIS) - INEP: 134414
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134414' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE CRISPINIANO' 
      AND UPPER(TRIM(city)) = 'RITÁPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134414');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉLIA PASSOS (SANTA CRUZ DE MINAS) - INEP: 134911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134911' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉLIA PASSOS' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSOR JOSÉ AMÉRICO DA COSTA (SÃO JOÃO DEL REI) - INEP: 134759
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134759' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR JOSÉ AMÉRICO DA COSTA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134759');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG - UNIDADE SÃO JOÃO DEL REI (SÃO JOÃO DEL REI) - INEP: 368148
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368148' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG - UNIDADE SÃO JOÃO DEL REI' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368148');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BRIGHENTI CESARE (SÃO JOÃO DEL REI) - INEP: 134546
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134546' 
    WHERE UPPER(TRIM(name)) = 'EE BRIGHENTI CESARE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134546');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO OSVALDO LUSTOSA (SÃO JOÃO DEL REI) - INEP: 134562
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134562' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO OSVALDO LUSTOSA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134562');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR GARCIA DE LIMA (SÃO JOÃO DEL REI) - INEP: 134619
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134619' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR GARCIA DE LIMA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134619');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EVANDRO ÁVILA (SÃO JOÃO DEL REI) - INEP: 134791
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134791' 
    WHERE UPPER(TRIM(name)) = 'EE EVANDRO ÁVILA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134791');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR MILTON CAMPOS (SÃO JOÃO DEL REI) - INEP: 134635
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134635' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR MILTON CAMPOS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134635');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IDALINA HORTA GALVÃO (SÃO JOÃO DEL REI) - INEP: 134643
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134643' 
    WHERE UPPER(TRIM(name)) = 'EE IDALINA HORTA GALVÃO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134643');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INÁCIO PASSOS (SÃO JOÃO DEL REI) - INEP: 134651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134651' 
    WHERE UPPER(TRIM(name)) = 'EE INÁCIO PASSOS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DOS SANTOS (SÃO JOÃO DEL REI) - INEP: 134660
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134660' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134660');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINISTRO GABRIEL PASSOS (SÃO JOÃO DEL REI) - INEP: 134694
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134694' 
    WHERE UPPER(TRIM(name)) = 'EE MINISTRO GABRIEL PASSOS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134694');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE LOPES (SÃO JOÃO DEL REI) - INEP: 134805
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134805' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE LOPES' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134805');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR IAGO PIMENTEL (SÃO JOÃO DEL REI) - INEP: 134716
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134716' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR IAGO PIMENTEL' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134716');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TOMÉ PORTES DEL REI (SÃO JOÃO DEL REI) - INEP: 134724
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134724' 
    WHERE UPPER(TRIM(name)) = 'EE TOMÉ PORTES DEL REI' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134724');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFONSO PENA JÚNIOR (SÃO TIAGO) - INEP: 134813
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134813' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO PENA JÚNIOR' 
      AND UPPER(TRIM(city)) = 'SÃO TIAGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134813');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MERCÊS DE ÁGUA LIMPA (SÃO TIAGO) - INEP: 134872
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134872' 
    WHERE UPPER(TRIM(name)) = 'EE DE MERCÊS DE ÁGUA LIMPA' 
      AND UPPER(TRIM(city)) = 'SÃO TIAGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134872');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BASÍLIO DA GAMA (TIRADENTES) - INEP: 134881
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134881' 
    WHERE UPPER(TRIM(name)) = 'EE BASÍLIO DA GAMA' 
      AND UPPER(TRIM(city)) = 'TIRADENTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134881');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL LUCAS MAGALHÃES (ARCEBURGO) - INEP: 136875
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136875' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL LUCAS MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'ARCEBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136875');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ TEODORO DE SOUZA (CAPETINGA) - INEP: 136891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136891' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ TEODORO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'CAPETINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MELO VIANA (CÁSSIA) - INEP: 137006
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137006' 
    WHERE UPPER(TRIM(name)) = 'EE MELO VIANA' 
      AND UPPER(TRIM(city)) = 'CÁSSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137006');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO GABRIEL (CÁSSIA) - INEP: 136948
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136948' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO GABRIEL' 
      AND UPPER(TRIM(city)) = 'CÁSSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136948');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IARBAS RODRIGUES (CLARAVAL) - INEP: 137065
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137065' 
    WHERE UPPER(TRIM(name)) = 'EE IARBAS RODRIGUES' 
      AND UPPER(TRIM(city)) = 'CLARAVAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137065');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALICE AUTRAN DOURADO (GUARANÉSIA) - INEP: 137073
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137073' 
    WHERE UPPER(TRIM(name)) = 'EE ALICE AUTRAN DOURADO' 
      AND UPPER(TRIM(city)) = 'GUARANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137073');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO RIBEIRO DIAS (GUARANÉSIA) - INEP: 137146
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137146' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO RIBEIRO DIAS' 
      AND UPPER(TRIM(city)) = 'GUARANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137146');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA QUERIDINHA BIAS FORTES (GUAXUPÉ) - INEP: 137227
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137227' 
    WHERE UPPER(TRIM(name)) = 'EE DONA QUERIDINHA BIAS FORTES' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137227');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ANDRÉ CORTEZ GRANERO (GUAXUPÉ) - INEP: 137324
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137324' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANDRÉ CORTEZ GRANERO' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137324');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR BENEDITO LEITE RIBEIRO (GUAXUPÉ) - INEP: 137235
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137235' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR BENEDITO LEITE RIBEIRO' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137235');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAJOR LUIZ ZERBINI (GUAXUPÉ) - INEP: 137251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137251' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR LUIZ ZERBINI' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA APARECIDA (GUAXUPÉ) - INEP: 137278
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137278' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA APARECIDA' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137278');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE IBIRACI (IBIRACI) - INEP: 137341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137341' 
    WHERE UPPER(TRIM(name)) = 'EE DE IBIRACI' 
      AND UPPER(TRIM(city)) = 'IBIRACI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ITAMOGI (ITAMOGI) - INEP: 137413
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137413' 
    WHERE UPPER(TRIM(name)) = 'EE DE ITAMOGI' 
      AND UPPER(TRIM(city)) = 'ITAMOGI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137413');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ SOARES DE ARAÚJO (ITAMOGI) - INEP: 137456
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137456' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ SOARES DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'ITAMOGI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137456');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARY PIMENTA BUGELLI (ITAÚ DE MINAS) - INEP: 240800
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240800' 
    WHERE UPPER(TRIM(name)) = 'EE ARY PIMENTA BUGELLI' 
      AND UPPER(TRIM(city)) = 'ITAÚ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240800');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA LEONOR NASSER (JACUÍ) - INEP: 137502
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137502' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA LEONOR NASSER' 
      AND UPPER(TRIM(city)) = 'JACUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137502');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EDUARDO SENEDESE (JURUAIA) - INEP: 137529
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137529' 
    WHERE UPPER(TRIM(name)) = 'EE EDUARDO SENEDESE' 
      AND UPPER(TRIM(city)) = 'JURUAIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137529');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉRICO DE PAIVA (MONTE SANTO DE MINAS) - INEP: 137545
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137545' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉRICO DE PAIVA' 
      AND UPPER(TRIM(city)) = 'MONTE SANTO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137545');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MILAGRE (MONTE SANTO DE MINAS) - INEP: 137669
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137669' 
    WHERE UPPER(TRIM(name)) = 'EE DE MILAGRE' 
      AND UPPER(TRIM(city)) = 'MONTE SANTO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137669');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR WENCESLAU BRAZ (MONTE SANTO DE MINAS) - INEP: 137618
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137618' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR WENCESLAU BRAZ' 
      AND UPPER(TRIM(city)) = 'MONTE SANTO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137618');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR FARID SILVA (PRATÁPOLIS) - INEP: 137707
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137707' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR FARID SILVA' 
      AND UPPER(TRIM(city)) = 'PRATÁPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137707');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOÃO FERREIRA BARBOSA (SÃO PEDRO DA UNIÃO) - INEP: 137847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137847' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOÃO FERREIRA BARBOSA' 
      AND UPPER(TRIM(city)) = 'SÃO PEDRO DA UNIÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC ALDA POLASTRE (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 138011
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '138011' 
    WHERE UPPER(TRIM(name)) = 'CESEC ALDA POLASTRE' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '138011');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENEDITO FERREIRA CALAFIORI (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137987
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137987' 
    WHERE UPPER(TRIM(name)) = 'EE BENEDITO FERREIRA CALAFIORI' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137987');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLÓVIS SALGADO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137880
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137880' 
    WHERE UPPER(TRIM(name)) = 'EE CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137880');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE COMENDADOR JOÃO ALVES DE FIGUEIREDO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137936
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137936' 
    WHERE UPPER(TRIM(name)) = 'EE COMENDADOR JOÃO ALVES DE FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137936');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE COMENDADORA ANA CÂNDIDA DE FIGUEIREDO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137910
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137910' 
    WHERE UPPER(TRIM(name)) = 'EE COMENDADORA ANA CÂNDIDA DE FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137910');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOSÉ CÂNDIDO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137898
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137898' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ CÂNDIDO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137898');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PARAISENSE (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137944
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137944' 
    WHERE UPPER(TRIM(name)) = 'EE PARAISENSE' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137944');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PAULA FRASSINETTI (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137928
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137928' 
    WHERE UPPER(TRIM(name)) = 'EE PAULA FRASSINETTI' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137928');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA INÊS MIRANDA ALMEIDA (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 212431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212431' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA INÊS MIRANDA ALMEIDA' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOÃO DA ESCÓCIA (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137961' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOÃO DA ESCÓCIA' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR TANCREDO DE ALMEIDA NEVES (SÃO TOMÁS DE AQUINO) - INEP: 138053
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '138053' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'SÃO TOMÁS DE AQUINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '138053');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA DA CONCEIÇÃO SILVA (ARAÇAÍ) - INEP: 311189
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311189' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA DA CONCEIÇÃO SILVA' 
      AND UPPER(TRIM(city)) = 'ARAÇAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311189');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ RIBEIRO DA SILVA (BALDIM) - INEP: 140325
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140325' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ RIBEIRO DA SILVA' 
      AND UPPER(TRIM(city)) = 'BALDIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140325');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OSCAR ARTUR GUIMARÃES (BALDIM) - INEP: 140376
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140376' 
    WHERE UPPER(TRIM(name)) = 'EE OSCAR ARTUR GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'BALDIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140376');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA ANÁLIA MENDES FERREIRA (CACHOEIRA DA PRATA) - INEP: 267805
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267805' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ANÁLIA MENDES FERREIRA' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267805');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA DORA SILVA (CAETANÓPOLIS) - INEP: 140465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140465' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DORA SILVA' 
      AND UPPER(TRIM(city)) = 'CAETANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO SALES (CAPIM BRANCO) - INEP: 140481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140481' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO SALES' 
      AND UPPER(TRIM(city)) = 'CAPIM BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESTRE CORNÉLIO (CAPIM BRANCO) - INEP: 310611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310611' 
    WHERE UPPER(TRIM(name)) = 'EE MESTRE CORNÉLIO' 
      AND UPPER(TRIM(city)) = 'CAPIM BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLÁUDIO PINHEIRO DE LIMA (CORDISBURGO) - INEP: 140538
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140538' 
    WHERE UPPER(TRIM(name)) = 'EE CLÁUDIO PINHEIRO DE LIMA' 
      AND UPPER(TRIM(city)) = 'CORDISBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140538');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESTRE CANDINHO (CORDISBURGO) - INEP: 140554
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140554' 
    WHERE UPPER(TRIM(name)) = 'EE MESTRE CANDINHO' 
      AND UPPER(TRIM(city)) = 'CORDISBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140554');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANÍSIO TEIXEIRA (CORDISBURGO) - INEP: 140589
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140589' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANÍSIO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'CORDISBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140589');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL AMÉRICO TEIXEIRA GUIMARÃES (FORTUNA DE MINAS) - INEP: 141003
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141003' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL AMÉRICO TEIXEIRA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'FORTUNA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141003');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALUÍSIO FERREIRA DE SOUZA (FUNILÂNDIA) - INEP: 141038
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141038' 
    WHERE UPPER(TRIM(name)) = 'EE ALUÍSIO FERREIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'FUNILÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141038');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DIOLINO MOREIRA (FUNILÂNDIA) - INEP: 141054
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141054' 
    WHERE UPPER(TRIM(name)) = 'EE DIOLINO MOREIRA' 
      AND UPPER(TRIM(city)) = 'FUNILÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141054');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESSIAS ANTÔNIO GUIMARÃES (INHAÚMA) - INEP: 141101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141101' 
    WHERE UPPER(TRIM(name)) = 'EE MESSIAS ANTÔNIO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'INHAÚMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR VÍTOR PINTO (JEQUITIBÁ) - INEP: 141135
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141135' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR VÍTOR PINTO' 
      AND UPPER(TRIM(city)) = 'JEQUITIBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141135');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENTO GONÇALVES (MATOZINHOS) - INEP: 141194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141194' 
    WHERE UPPER(TRIM(name)) = 'EE BENTO GONÇALVES' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELÍCIA FERNANDES CAMPOS (MATOZINHOS) - INEP: 141275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141275' 
    WHERE UPPER(TRIM(name)) = 'EE FELÍCIA FERNANDES CAMPOS' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HERMELITA SOARES HORTA (MATOZINHOS) - INEP: 141259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141259' 
    WHERE UPPER(TRIM(name)) = 'EE HERMELITA SOARES HORTA' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA VITIZA OCTAVIANO VIANA (MATOZINHOS) - INEP: 141186
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141186' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA VITIZA OCTAVIANO VIANA' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141186');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VISCONDE DO RIO DAS VELHAS (MATOZINHOS) - INEP: 141216
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141216' 
    WHERE UPPER(TRIM(name)) = 'EE VISCONDE DO RIO DAS VELHAS' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141216');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AGNALDO EDMUNDO SILVA (PARAOPEBA) - INEP: 230995
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230995' 
    WHERE UPPER(TRIM(name)) = 'EE AGNALDO EDMUNDO SILVA' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230995');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CONSELHEIRO AFONSO PENA (PARAOPEBA) - INEP: 141321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141321' 
    WHERE UPPER(TRIM(name)) = 'EE CONSELHEIRO AFONSO PENA' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE AUGUSTO HORTA (PARAOPEBA) - INEP: 141356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141356' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE AUGUSTO HORTA' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA FRANCISCA DE OLIVEIRA (POMPÉU) - INEP: 141437
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141437' 
    WHERE UPPER(TRIM(name)) = 'EE DONA FRANCISCA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141437');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR JACINTO CAMPOS (POMPÉU) - INEP: 141445
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141445' 
    WHERE UPPER(TRIM(name)) = 'EE DR JACINTO CAMPOS' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141445');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINISTRO FRANCISCO CAMPOS (POMPÉU) - INEP: 141399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141399' 
    WHERE UPPER(TRIM(name)) = 'EE MINISTRO FRANCISCO CAMPOS' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PAULO CAMPOS GUIMARÃES (POMPÉU) - INEP: 231762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231762' 
    WHERE UPPER(TRIM(name)) = 'EE PAULO CAMPOS GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO ROBERTO DE MENEZES (POMPÉU) - INEP: 141470
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141470' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO ROBERTO DE MENEZES' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141470');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO DELPHINO DOS SANTOS (PRUDENTE DE MORAIS) - INEP: 231550
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231550' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO DELPHINO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'PRUDENTE DE MORAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231550');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO RODRIGUES DA SILVA (PRUDENTE DE MORAIS) - INEP: 141488
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141488' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO RODRIGUES DA SILVA' 
      AND UPPER(TRIM(city)) = 'PRUDENTE DE MORAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141488');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VIRGÍLIO DE MELO FRANCO (PRUDENTE DE MORAIS) - INEP: 310662
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310662' 
    WHERE UPPER(TRIM(name)) = 'EE VIRGÍLIO DE MELO FRANCO' 
      AND UPPER(TRIM(city)) = 'PRUDENTE DE MORAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310662');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL DOMINGOS DINIZ COUTO (SANTANA DE PIRAPAMA) - INEP: 141526
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141526' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL DOMINGOS DINIZ COUTO' 
      AND UPPER(TRIM(city)) = 'SANTANA DE PIRAPAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141526');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO MARTINS GUIMARÃES (SANTANA DE PIRAPAMA) - INEP: 141585
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141585' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO MARTINS GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'SANTANA DE PIRAPAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141585');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUVELINO VIEIRA DE ÁVILA (SANTANA DE PIRAPAMA) - INEP: 141542
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141542' 
    WHERE UPPER(TRIM(name)) = 'EE JUVELINO VIEIRA DE ÁVILA' 
      AND UPPER(TRIM(city)) = 'SANTANA DE PIRAPAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141542');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (SETE LAGOAS) - INEP: 368237
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368237' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368237');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ÁPIO SÓLON CARDOSO (SETE LAGOAS) - INEP: 229288
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229288' 
    WHERE UPPER(TRIM(name)) = 'EE ÁPIO SÓLON CARDOSO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229288');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BERNARDO VALADARES DE VASCONCELLOS (SETE LAGOAS) - INEP: 141925
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141925' 
    WHERE UPPER(TRIM(name)) = 'EE BERNARDO VALADARES DE VASCONCELLOS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141925');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO  MÉDIO (SETE LAGOAS) - INEP: 372110
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372110' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372110');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO RENATO AZEREDO (SETE LAGOAS) - INEP: 141801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141801' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO RENATO AZEREDO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141801');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR AFONSO VIANA (SETE LAGOAS) - INEP: 141593
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141593' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR AFONSO VIANA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141593');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ALONSO MARQUES FERREIRA (SETE LAGOAS) - INEP: 141887
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141887' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ALONSO MARQUES FERREIRA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141887');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ARTHUR BERNARDES (SETE LAGOAS) - INEP: 141631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141631' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ARTHUR BERNARDES' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR AVELAR (SETE LAGOAS) - INEP: 141674
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141674' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR AVELAR' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141674');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR OLINTO SÁTYRO ALVIM (SETE LAGOAS) - INEP: 141704
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141704' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR OLINTO SÁTYRO ALVIM' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141704');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EDITE FURST (SETE LAGOAS) - INEP: 141640
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141640' 
    WHERE UPPER(TRIM(name)) = 'EE EDITE FURST' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141640');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EMÍLIO DE VASCONCELOS COSTA (SETE LAGOAS) - INEP: 141682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141682' 
    WHERE UPPER(TRIM(name)) = 'EE EMÍLIO DE VASCONCELOS COSTA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EPONINA SOARES DOS SANTOS (SETE LAGOAS) - INEP: 141658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141658' 
    WHERE UPPER(TRIM(name)) = 'EE EPONINA SOARES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR JUSCELINO (SETE LAGOAS) - INEP: 310689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310689' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR JUSCELINO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ EVANGELISTA FRANÇA (SETE LAGOAS) - INEP: 141763
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141763' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ EVANGELISTA FRANÇA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141763');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JÚLIO CÉSAR REIS OLIVEIRA (SETE LAGOAS) - INEP: 213675
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213675' 
    WHERE UPPER(TRIM(name)) = 'EE JÚLIO CÉSAR REIS OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213675');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAURILO DE JESUS PEIXOTO (SETE LAGOAS) - INEP: 141798
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141798' 
    WHERE UPPER(TRIM(name)) = 'EE MAURILO DE JESUS PEIXOTO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141798');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAURO FACCIO GONÇALVES (SETE LAGOAS) - INEP: 353469
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353469' 
    WHERE UPPER(TRIM(name)) = 'EE MAURO FACCIO GONÇALVES' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353469');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MODESTINO ANDRADE SOBRINHO (SETE LAGOAS) - INEP: 141810
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141810' 
    WHERE UPPER(TRIM(name)) = 'EE MODESTINO ANDRADE SOBRINHO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141810');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO ZICO PAIVA (SETE LAGOAS) - INEP: 218944
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218944' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO ZICO PAIVA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218944');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR CÂNDIDO AZEREDO (SETE LAGOAS) - INEP: 141844
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141844' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CÂNDIDO AZEREDO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141844');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOÃO FERNANDINO JÚNIOR (SETE LAGOAS) - INEP: 141852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141852' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOÃO FERNANDINO JÚNIOR' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141852');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ROUSSET (SETE LAGOAS) - INEP: 141861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141861' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ROUSSET' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ELZA MOREIRA LOPES (SETE LAGOAS) - INEP: 141933
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141933' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ELZA MOREIRA LOPES' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141933');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RUTH BRANDÃO DE AZEREDO (SETE LAGOAS) - INEP: 349305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349305' 
    WHERE UPPER(TRIM(name)) = 'EE RUTH BRANDÃO DE AZEREDO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349305');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SINHÁ ANDRADE (SETE LAGOAS) - INEP: 141895
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141895' 
    WHERE UPPER(TRIM(name)) = 'EE SINHÁ ANDRADE' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141895');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VENCESLAU BRÁS (SETE LAGOAS) - INEP: 342572
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342572' 
    WHERE UPPER(TRIM(name)) = 'EE VENCESLAU BRÁS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342572');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAPITÃO INÁCIO SOARES (ÁGUAS FORMOSAS) - INEP: 145912
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145912' 
    WHERE UPPER(TRIM(name)) = 'EE CAPITÃO INÁCIO SOARES' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145912');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ÁGUA QUENTE (ÁGUAS FORMOSAS) - INEP: 145947
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145947' 
    WHERE UPPER(TRIM(name)) = 'EE DE ÁGUA QUENTE' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145947');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ QUARESMA DA COSTA (ÁGUAS FORMOSAS) - INEP: 145955
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145955' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ QUARESMA DA COSTA' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145955');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DANIEL PEREIRA OTTONI (ATALÉIA) - INEP: 338818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338818' 
    WHERE UPPER(TRIM(name)) = 'EE DANIEL PEREIRA OTTONI' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE NOVO HORIZONTE (ATALÉIA) - INEP: 146412
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146412' 
    WHERE UPPER(TRIM(name)) = 'EE DE NOVO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146412');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE SÃO MIGUEL (ATALÉIA) - INEP: 146391
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146391' 
    WHERE UPPER(TRIM(name)) = 'EE DE SÃO MIGUEL' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146391');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO CLEMENTE ESTEVES FERRAZ (ATALÉIA) - INEP: 146285
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146285' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO CLEMENTE ESTEVES FERRAZ' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146285');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ALNEDA DE MATOS MACHADO (ATALÉIA) - INEP: 146331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146331' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ALNEDA DE MATOS MACHADO' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA HERMÍNIA P DE ALMEIDA (ATALÉIA) - INEP: 146323
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146323' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA HERMÍNIA P DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146323');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE BERTÓPOLIS (BERTÓPOLIS) - INEP: 146421
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146421' 
    WHERE UPPER(TRIM(name)) = 'EE DE BERTÓPOLIS' 
      AND UPPER(TRIM(city)) = 'BERTÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146421');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE UMBURANINHA (BERTÓPOLIS) - INEP: 146439
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146439' 
    WHERE UPPER(TRIM(name)) = 'EE DE UMBURANINHA' 
      AND UPPER(TRIM(city)) = 'BERTÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146439');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA CAPITÃOZINHO MAXAKALI (BERTÓPOLIS) - INEP: 269867
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269867' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA CAPITÃOZINHO MAXAKALI' 
      AND UPPER(TRIM(city)) = 'BERTÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269867');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO DUARTE SOBRINHO (CAMPANÁRIO) - INEP: 146471
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146471' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO DUARTE SOBRINHO' 
      AND UPPER(TRIM(city)) = 'CAMPANÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146471');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE CARAÍ (CARAÍ) - INEP: 146510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146510' 
    WHERE UPPER(TRIM(name)) = 'EE DE CARAÍ' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (CARAÍ) - INEP: 372072
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372072' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372072');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM JOSÉ DE HAAS (CARAÍ) - INEP: 146536
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146536' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOSÉ DE HAAS' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146536');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ORLANDO TAVARES (CARAÍ) - INEP: 146544
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146544' 
    WHERE UPPER(TRIM(name)) = 'EE ORLANDO TAVARES' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146544');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOÃO BERALDO (CARLOS CHAGAS) - INEP: 146579
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146579' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOÃO BERALDO' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146579');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EPAMINONDAS OTONI (CARLOS CHAGAS) - INEP: 146625
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146625' 
    WHERE UPPER(TRIM(name)) = 'EE EPAMINONDAS OTONI' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146625');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO DE SOUZA NORTE (CARLOS CHAGAS) - INEP: 146561
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146561' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO DE SOUZA NORTE' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146561');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OLGA PRATES (CARLOS CHAGAS) - INEP: 146633
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146633' 
    WHERE UPPER(TRIM(name)) = 'EE OLGA PRATES' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146633');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ANTÔNIA BERNARDO RODRIGUES (CARLOS CHAGAS) - INEP: 346179
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346179' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ANTÔNIA BERNARDO RODRIGUES' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346179');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR CIRO MACIEL (CATUJI) - INEP: 146749
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146749' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR CIRO MACIEL' 
      AND UPPER(TRIM(city)) = 'CATUJI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146749');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GEORGINA FERREIRA BATISTA (CATUJI) - INEP: 330591
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330591' 
    WHERE UPPER(TRIM(name)) = 'EE GEORGINA FERREIRA BATISTA' 
      AND UPPER(TRIM(city)) = 'CATUJI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330591');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAUL FERREIRA SOUTO (CRISÓLITA) - INEP: 145980
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145980' 
    WHERE UPPER(TRIM(name)) = 'EE RAUL FERREIRA SOUTO' 
      AND UPPER(TRIM(city)) = 'CRISÓLITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145980');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ANTÔNIO FERREIRA (FRANCISCÓPOLIS) - INEP: 147222
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147222' 
    WHERE UPPER(TRIM(name)) = 'EE DE ANTÔNIO FERREIRA' 
      AND UPPER(TRIM(city)) = 'FRANCISCÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147222');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DA SILVA ROCHA (FRANCISCÓPOLIS) - INEP: 147249
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147249' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DA SILVA ROCHA' 
      AND UPPER(TRIM(city)) = 'FRANCISCÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147249');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SALMEN BUKZEM (FREI GASPAR) - INEP: 146706
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146706' 
    WHERE UPPER(TRIM(name)) = 'EE SALMEN BUKZEM' 
      AND UPPER(TRIM(city)) = 'FREI GASPAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146706');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE PAMPÃ (FRONTEIRA DOS VALES) - INEP: 146714
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146714' 
    WHERE UPPER(TRIM(name)) = 'EE DE PAMPÃ' 
      AND UPPER(TRIM(city)) = 'FRONTEIRA DOS VALES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146714');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL CLEMENTE LUIZ (ITAIPÉ) - INEP: 146731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146731' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL CLEMENTE LUIZ' 
      AND UPPER(TRIM(city)) = 'ITAIPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA FRANCISCA MATOS (ITAIPÉ) - INEP: 319082
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319082' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA FRANCISCA MATOS' 
      AND UPPER(TRIM(city)) = 'ITAIPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319082');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR TRISTÃO DA CUNHA (ITAMBACURI) - INEP: 146757
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146757' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR TRISTÃO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146757');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MADRE SERAFINA DE JESUS (ITAMBACURI) - INEP: 146820
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146820' 
    WHERE UPPER(TRIM(name)) = 'EE MADRE SERAFINA DE JESUS' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146820');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAMIRO SOUZA E SILVA (ITAMBACURI) - INEP: 146871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146871' 
    WHERE UPPER(TRIM(name)) = 'EE RAMIRO SOUZA E SILVA' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146871');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VEREADOR JÚLIO LAGES (ITAMBACURI) - INEP: 146862
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146862' 
    WHERE UPPER(TRIM(name)) = 'EE VEREADOR JÚLIO LAGES' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146862');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CASSIMIRO DE ABREU (JAMPRUCA) - INEP: 146501
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146501' 
    WHERE UPPER(TRIM(name)) = 'EE CASSIMIRO DE ABREU' 
      AND UPPER(TRIM(city)) = 'JAMPRUCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146501');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL ANTÔNIO LOPES (JAMPRUCA) - INEP: 146480
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146480' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ANTÔNIO LOPES' 
      AND UPPER(TRIM(city)) = 'JAMPRUCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146480');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL (JAMPRUCA) - INEP: 369870
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369870' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL' 
      AND UPPER(TRIM(city)) = 'JAMPRUCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369870');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE CONCÓRDIA DO MUCURI (LADAINHA) - INEP: 147109
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147109' 
    WHERE UPPER(TRIM(name)) = 'EE DE CONCÓRDIA DO MUCURI' 
      AND UPPER(TRIM(city)) = 'LADAINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147109');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE LADAINHA (LADAINHA) - INEP: 147052
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147052' 
    WHERE UPPER(TRIM(name)) = 'EE DE LADAINHA' 
      AND UPPER(TRIM(city)) = 'LADAINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147052');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA IZABEL DA SILVA MAXAKALI (LADAINHA) - INEP: 338826
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338826' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA IZABEL DA SILVA MAXAKALI' 
      AND UPPER(TRIM(city)) = 'LADAINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338826');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DO ROSÁRIO (LADAINHA) - INEP: 147095
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147095' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DO ROSÁRIO' 
      AND UPPER(TRIM(city)) = 'LADAINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147095');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO DIAS DOS SANTOS (MACHACALIS) - INEP: 253839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253839' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO DIAS DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'MACHACALIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ DE ALENCAR (MACHACALIS) - INEP: 147133
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147133' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ DE ALENCAR' 
      AND UPPER(TRIM(city)) = 'MACHACALIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147133');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE JAGUARITIRA (MALACACHETA) - INEP: 147281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147281' 
    WHERE UPPER(TRIM(name)) = 'EE DE JAGUARITIRA' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE SANTO ANTÔNIO DO MUCURI (MALACACHETA) - INEP: 147311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147311' 
    WHERE UPPER(TRIM(name)) = 'EE DE SANTO ANTÔNIO DO MUCURI' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO DOS SANTOS COIMBRA (MALACACHETA) - INEP: 147290
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147290' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO DOS SANTOS COIMBRA' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147290');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESTRA ZULMIRA (MALACACHETA) - INEP: 147206
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147206' 
    WHERE UPPER(TRIM(name)) = 'EE MESTRA ZULMIRA' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147206');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR CLÓVIS VIEIRA DA FONSECA (MALACACHETA) - INEP: 147141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147141' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR CLÓVIS VIEIRA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE STELLA ABRANTES (MALACACHETA) - INEP: 147192
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147192' 
    WHERE UPPER(TRIM(name)) = 'EE STELLA ABRANTES' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147192');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ÁLVARO ROMANO (NANUQUE) - INEP: 147419
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147419' 
    WHERE UPPER(TRIM(name)) = 'EE ÁLVARO ROMANO' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147419');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO BATISTA DA MOTA (NANUQUE) - INEP: 147451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147451' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO BATISTA DA MOTA' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSEPH STALIM ROMANO (NANUQUE) - INEP: 147486
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147486' 
    WHERE UPPER(TRIM(name)) = 'EE JOSEPH STALIM ROMANO' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147486');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PASTOR PAULO NOBRE NASCIMENTO (NANUQUE) - INEP: 147494
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147494' 
    WHERE UPPER(TRIM(name)) = 'EE PASTOR PAULO NOBRE NASCIMENTO' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147494');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PÉRICLES COELHO (NANUQUE) - INEP: 147508
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147508' 
    WHERE UPPER(TRIM(name)) = 'EE PÉRICLES COELHO' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147508');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE STELLA MATUTINA (NANUQUE) - INEP: 147460
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147460' 
    WHERE UPPER(TRIM(name)) = 'EE STELLA MATUTINA' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147460');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VALE DO MUCURI (NANUQUE) - INEP: 147389
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147389' 
    WHERE UPPER(TRIM(name)) = 'EE VALE DO MUCURI' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147389');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO RAMOS DE SOUZA (NOVO CRUZEIRO) - INEP: 147575
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147575' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO RAMOS DE SOUZA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147575');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AUGUSTO SOARES (NOVO CRUZEIRO) - INEP: 326119
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326119' 
    WHERE UPPER(TRIM(name)) = 'EE AUGUSTO SOARES' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326119');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA ARUEGA (NOVO CRUZEIRO) - INEP: 218430
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218430' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA ARUEGA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218430');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE LAMBARI (NOVO CRUZEIRO) - INEP: 147583
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147583' 
    WHERE UPPER(TRIM(name)) = 'EE DE LAMBARI' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147583');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE SANTA BÁRBARA (NOVO CRUZEIRO) - INEP: 147648
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147648' 
    WHERE UPPER(TRIM(name)) = 'EE DE SANTA BÁRBARA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147648');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO LUFA (NOVO CRUZEIRO) - INEP: 147621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147621' 
    WHERE UPPER(TRIM(name)) = 'EE DO LUFA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EDUARDO MILTON DA SILVA (NOVO CRUZEIRO) - INEP: 147541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147541' 
    WHERE UPPER(TRIM(name)) = 'EE EDUARDO MILTON DA SILVA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INÁCIO MURTA (NOVO CRUZEIRO) - INEP: 147567
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147567' 
    WHERE UPPER(TRIM(name)) = 'EE INÁCIO MURTA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147567');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ MENDES BARBOSA (NOVO CRUZEIRO) - INEP: 147656
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147656' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MENDES BARBOSA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147656');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA CÂNDIDA REIS (NOVO CRUZEIRO) - INEP: 147664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147664' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA CÂNDIDA REIS' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SUL AMÉRICA (NOVO CRUZEIRO) - INEP: 147613
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147613' 
    WHERE UPPER(TRIM(name)) = 'EE SUL AMÉRICA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147613');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ADOLFO TEIXEIRA DE SOUZA (NOVO ORIENTE DE MINAS) - INEP: 346144
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346144' 
    WHERE UPPER(TRIM(name)) = 'EE ADOLFO TEIXEIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'NOVO ORIENTE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346144');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE FREI GONZAGA (NOVO ORIENTE DE MINAS) - INEP: 148393
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148393' 
    WHERE UPPER(TRIM(name)) = 'EE DE FREI GONZAGA' 
      AND UPPER(TRIM(city)) = 'NOVO ORIENTE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148393');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PAULO PINHEIRO CHAGAS (NOVO ORIENTE DE MINAS) - INEP: 148385
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148385' 
    WHERE UPPER(TRIM(name)) = 'EE PAULO PINHEIRO CHAGAS' 
      AND UPPER(TRIM(city)) = 'NOVO ORIENTE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148385');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ELISA LEAL (OURO VERDE DE MINAS) - INEP: 254487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254487' 
    WHERE UPPER(TRIM(name)) = 'EE ELISA LEAL' 
      AND UPPER(TRIM(city)) = 'OURO VERDE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VEREADOR LUZO FREITAS DE ARAÚJO (OURO VERDE DE MINAS) - INEP: 147672
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147672' 
    WHERE UPPER(TRIM(name)) = 'EE VEREADOR LUZO FREITAS DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'OURO VERDE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147672');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (PADRE PARAÍSO) - INEP: 330574
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330574' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330574');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR CÂNDIDO ULHOA (PADRE PARAÍSO) - INEP: 147699
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147699' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR CÂNDIDO ULHOA' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147699');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE JOÃO PINHEIRO (PADRE PARAÍSO) - INEP: 147702
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147702' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE JOÃO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147702');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ MONTEIRO FONSECA (PADRE PARAÍSO) - INEP: 147711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147711' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ MONTEIRO FONSECA' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAIO NÉLSON DE SENA (PAVÃO) - INEP: 147737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147737' 
    WHERE UPPER(TRIM(name)) = 'EE CAIO NÉLSON DE SENA' 
      AND UPPER(TRIM(city)) = 'PAVÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO POVOADO DE LIMEIRA (PAVÃO) - INEP: 147753
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147753' 
    WHERE UPPER(TRIM(name)) = 'EE DO POVOADO DE LIMEIRA' 
      AND UPPER(TRIM(city)) = 'PAVÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147753');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR TRISTÃO DA CUNHA (PESCADOR) - INEP: 147788
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147788' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR TRISTÃO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'PESCADOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147788');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALONZO BARBUDA (PONTO DOS VOLANTES) - INEP: 147010
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147010' 
    WHERE UPPER(TRIM(name)) = 'EE ALONZO BARBUDA' 
      AND UPPER(TRIM(city)) = 'PONTO DOS VOLANTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147010');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (PONTO DOS VOLANTES) - INEP: 372080
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372080' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'PONTO DOS VOLANTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372080');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTANA DO ARAÇUAÍ (PONTO DOS VOLANTES) - INEP: 147028
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147028' 
    WHERE UPPER(TRIM(name)) = 'EE SANTANA DO ARAÇUAÍ' 
      AND UPPER(TRIM(city)) = 'PONTO DOS VOLANTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147028');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLÁUDIO MANOEL (POTÉ) - INEP: 147796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147796' 
    WHERE UPPER(TRIM(name)) = 'EE CLÁUDIO MANOEL' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO FERREIRA DE OLIVEIRA (POTÉ) - INEP: 147818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147818' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO FERREIRA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ARAUJO FONSECA (POTÉ) - INEP: 147834
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147834' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ARAUJO FONSECA' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147834');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RIBEIRÃO DE SANTA CRUZ (POTÉ) - INEP: 147826
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147826' 
    WHERE UPPER(TRIM(name)) = 'EE RIBEIRÃO DE SANTA CRUZ' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147826');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VEREADOR SEBASTIÃO MAGALHÃES (POTÉ) - INEP: 147869
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147869' 
    WHERE UPPER(TRIM(name)) = 'EE VEREADOR SEBASTIÃO MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147869');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA MAXAKALI (SANTA HELENA DE MINAS) - INEP: 269859
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269859' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA MAXAKALI' 
      AND UPPER(TRIM(city)) = 'SANTA HELENA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269859');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAUL RODRIGUES SALOMÃO (SANTA HELENA DE MINAS) - INEP: 146447
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146447' 
    WHERE UPPER(TRIM(name)) = 'EE RAUL RODRIGUES SALOMÃO' 
      AND UPPER(TRIM(city)) = 'SANTA HELENA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146447');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO GONZAGA (SERRA DOS AIMORÉS) - INEP: 147923
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147923' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO GONZAGA' 
      AND UPPER(TRIM(city)) = 'SERRA DOS AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147923');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VANDA REUTER (SERRA DOS AIMORÉS) - INEP: 147931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147931' 
    WHERE UPPER(TRIM(name)) = 'EE VANDA REUTER' 
      AND UPPER(TRIM(city)) = 'SERRA DOS AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE SETÚBAL (SETUBINHA) - INEP: 147354
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147354' 
    WHERE UPPER(TRIM(name)) = 'EE DE SETÚBAL' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147354');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GENTIL BARBOSA SENA (SETUBINHA) - INEP: 147320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147320' 
    WHERE UPPER(TRIM(name)) = 'EE GENTIL BARBOSA SENA' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147320');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MADALENA PEREIRA JORGE (SETUBINHA) - INEP: 326101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326101' 
    WHERE UPPER(TRIM(name)) = 'EE MADALENA PEREIRA JORGE' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NAGIB MAHMUD NÉDIR (SETUBINHA) - INEP: 147362
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147362' 
    WHERE UPPER(TRIM(name)) = 'EE NAGIB MAHMUD NÉDIR' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147362');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA LEONOR ESTEVES LIMA (SETUBINHA) - INEP: 147338
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147338' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA LEONOR ESTEVES LIMA' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147338');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SOTURNO DA MATA (SETUBINHA) - INEP: 240818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240818' 
    WHERE UPPER(TRIM(name)) = 'EE SOTURNO DA MATA' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEP - CENTRO DE EDUCAÇÃO PROFISSIONAL PAULO VIANA (TEÓFILO OTONI) - INEP: 298913
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298913' 
    WHERE UPPER(TRIM(name)) = 'CEP - CENTRO DE EDUCAÇÃO PROFISSIONAL PAULO VIANA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298913');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC  DE TEÓFILO OTONI (TEÓFILO OTONI) - INEP: 148199
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148199' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE TEÓFILO OTONI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148199');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (TEÓFILO OTONI) - INEP: 281204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281204' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBERTO BARREIROS (TEÓFILO OTONI) - INEP: 147940
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147940' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERTO BARREIROS' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147940');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALFREDO SÁ (TEÓFILO OTONI) - INEP: 147966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147966' 
    WHERE UPPER(TRIM(name)) = 'EE ALFREDO SÁ' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147966');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALTINO BARBOSA (TEÓFILO OTONI) - INEP: 147982
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147982' 
    WHERE UPPER(TRIM(name)) = 'EE ALTINO BARBOSA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147982');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLOTILDE ONOFRI DE CAMPOS (TEÓFILO OTONI) - INEP: 148059
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148059' 
    WHERE UPPER(TRIM(name)) = 'EE CLOTILDE ONOFRI DE CAMPOS' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148059');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA CABECEIRA DE SÃO PEDRO (TEÓFILO OTONI) - INEP: 148164
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148164' 
    WHERE UPPER(TRIM(name)) = 'EE DA CABECEIRA DE SÃO PEDRO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148164');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE BARRA DO CEDRO (TEÓFILO OTONI) - INEP: 148121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148121' 
    WHERE UPPER(TRIM(name)) = 'EE DE BARRA DO CEDRO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (TEÓFILO OTONI) - INEP: 326828
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326828' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326828');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE LIBERDADE (TEÓFILO OTONI) - INEP: 148229
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148229' 
    WHERE UPPER(TRIM(name)) = 'EE DE LIBERDADE' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148229');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MUCURI (TEÓFILO OTONI) - INEP: 148431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148431' 
    WHERE UPPER(TRIM(name)) = 'EE DE MUCURI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE PEDRO VERSIANI (TEÓFILO OTONI) - INEP: 148407
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148407' 
    WHERE UPPER(TRIM(name)) = 'EE DE PEDRO VERSIANI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148407');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO GERALDO LANDI (TEÓFILO OTONI) - INEP: 148288
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148288' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO GERALDO LANDI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148288');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR MANOEL ESTEVES OTONI (TEÓFILO OTONI) - INEP: 148334
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148334' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR MANOEL ESTEVES OTONI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148334');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR WALDEMAR NEVES DA ROCHA (TEÓFILO OTONI) - INEP: 148113
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148113' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR WALDEMAR NEVES DA ROCHA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148113');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GLÓRIA PENCHEL (TEÓFILO OTONI) - INEP: 148041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148041' 
    WHERE UPPER(TRIM(name)) = 'EE GLÓRIA PENCHEL' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IONE LEWICK CUNHA MELO (TEÓFILO OTONI) - INEP: 148075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148075' 
    WHERE UPPER(TRIM(name)) = 'EE IONE LEWICK CUNHA MELO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148075');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃ ARCÂNGELA (TEÓFILO OTONI) - INEP: 148130
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148130' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃ ARCÂNGELA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148130');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ EXPEDITO SOUZA CAMPOS (TEÓFILO OTONI) - INEP: 148440
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148440' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ EXPEDITO SOUZA CAMPOS' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148440');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAGID LAUAR (TEÓFILO OTONI) - INEP: 148261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148261' 
    WHERE UPPER(TRIM(name)) = 'EE MAGID LAUAR' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DE FÁTIMA (TEÓFILO OTONI) - INEP: 148342
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148342' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DE FÁTIMA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148342');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PASTOR HOLLERBACH (TEÓFILO OTONI) - INEP: 148024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148024' 
    WHERE UPPER(TRIM(name)) = 'EE PASTOR HOLLERBACH' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO NEVES (TEÓFILO OTONI) - INEP: 148351
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148351' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148351');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR PATRÍCIO FERREIRA GOMES (TEÓFILO OTONI) - INEP: 147958
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147958' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PATRÍCIO FERREIRA GOMES' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147958');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA LÚCIA GOMES RIBEIRO (TEÓFILO OTONI) - INEP: 338834
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338834' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA LÚCIA GOMES RIBEIRO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338834');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO SEBASTIÃO (TEÓFILO OTONI) - INEP: 148016
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148016' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148016');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO ALVES DA CRUZ (TEÓFILO OTONI) - INEP: 349330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349330' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO ALVES DA CRUZ' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO RAMOS (TEÓFILO OTONI) - INEP: 148032
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148032' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO RAMOS' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148032');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TRISTÃO DA CUNHA (TEÓFILO OTONI) - INEP: 148091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148091' 
    WHERE UPPER(TRIM(name)) = 'EE TRISTÃO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE APARÍCIO ALVES MURTA (UMBURATIBA) - INEP: 148458
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148458' 
    WHERE UPPER(TRIM(name)) = 'EE APARÍCIO ALVES MURTA' 
      AND UPPER(TRIM(city)) = 'UMBURATIBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148458');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO EDSON RESENDE (ASTOLFO DUTRA) - INEP: 180769
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180769' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO EDSON RESENDE' 
      AND UPPER(TRIM(city)) = 'ASTOLFO DUTRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180769');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OLINTO ALMADA (ASTOLFO DUTRA) - INEP: 180751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180751' 
    WHERE UPPER(TRIM(name)) = 'EE OLINTO ALMADA' 
      AND UPPER(TRIM(city)) = 'ASTOLFO DUTRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR SOUZA PRIMO (ASTOLFO DUTRA) - INEP: 180742
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180742' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR SOUZA PRIMO' 
      AND UPPER(TRIM(city)) = 'ASTOLFO DUTRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180742');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ALVES DE MAGALHÃES (BRÁS PIRES) - INEP: 180785
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180785' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ALVES DE MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'BRÁS PIRES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180785');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO LUÍS (BRÁS PIRES) - INEP: 180793
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180793' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO LUÍS' 
      AND UPPER(TRIM(city)) = 'BRÁS PIRES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180793');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EMÍLIO JARDIM (COIMBRA) - INEP: 128635
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128635' 
    WHERE UPPER(TRIM(name)) = 'EE EMÍLIO JARDIM' 
      AND UPPER(TRIM(city)) = 'COIMBRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128635');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR BIOLKINO DE ANDRADE (DIVINÉSIA) - INEP: 180807
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180807' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR BIOLKINO DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'DIVINÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180807');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORINA VIEIRA HENRIQUES (DONA EUSÉBIA) - INEP: 180831
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180831' 
    WHERE UPPER(TRIM(name)) = 'EE CORINA VIEIRA HENRIQUES' 
      AND UPPER(TRIM(city)) = 'DONA EUSÉBIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180831');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOMICIANO ESTEVES (DONA EUSÉBIA) - INEP: 180815
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180815' 
    WHERE UPPER(TRIM(name)) = 'EE DOMICIANO ESTEVES' 
      AND UPPER(TRIM(city)) = 'DONA EUSÉBIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180815');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEREZINHA PEREIRA (DORES DO TURVO) - INEP: 180858
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180858' 
    WHERE UPPER(TRIM(name)) = 'EE TEREZINHA PEREIRA' 
      AND UPPER(TRIM(city)) = 'DORES DO TURVO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180858');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM FRANCISCO DAS CHAGAS (ERVÁLIA) - INEP: 180904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180904' 
    WHERE UPPER(TRIM(name)) = 'EE DOM FRANCISCO DAS CHAGAS' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180904');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR RODOLFO (ERVÁLIA) - INEP: 180912
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180912' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR RODOLFO' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180912');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR DAVID PROCÓPIO (ERVÁLIA) - INEP: 180891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180891' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR DAVID PROCÓPIO' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ALVAREZ FILHO (GUARANI) - INEP: 215384
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215384' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ALVAREZ FILHO' 
      AND UPPER(TRIM(city)) = 'GUARANI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215384');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ALBERTO PACHECO (GUARANI) - INEP: 181030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181030' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ALBERTO PACHECO' 
      AND UPPER(TRIM(city)) = 'GUARANI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOAQUIM MARTINS (GUIDOVAL) - INEP: 181102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181102' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOAQUIM MARTINS' 
      AND UPPER(TRIM(city)) = 'GUIDOVAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIANA DE PAIVA (GUIDOVAL) - INEP: 181137
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181137' 
    WHERE UPPER(TRIM(name)) = 'EE MARIANA DE PAIVA' 
      AND UPPER(TRIM(city)) = 'GUIDOVAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181137');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CASTORINA GOMES SOARES (GUIRICEMA) - INEP: 181200
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181200' 
    WHERE UPPER(TRIM(name)) = 'EE CASTORINA GOMES SOARES' 
      AND UPPER(TRIM(city)) = 'GUIRICEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181200');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GALDINO LEOCÁDIO (GUIRICEMA) - INEP: 181234
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181234' 
    WHERE UPPER(TRIM(name)) = 'EE GALDINO LEOCÁDIO' 
      AND UPPER(TRIM(city)) = 'GUIRICEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181234');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO ANTÔNIO ARRUDA (GUIRICEMA) - INEP: 181188
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181188' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO ANTÔNIO ARRUDA' 
      AND UPPER(TRIM(city)) = 'GUIRICEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181188');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ MAURÍLIO VALENTE (PAULA CÂNDIDO) - INEP: 181251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181251' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MAURÍLIO VALENTE' 
      AND UPPER(TRIM(city)) = 'PAULA CÂNDIDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR SAMUEL JOÃO DE DEUS (PAULA CÂNDIDO) - INEP: 181277
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181277' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR SAMUEL JOÃO DE DEUS' 
      AND UPPER(TRIM(city)) = 'PAULA CÂNDIDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181277');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AURÉLIO BENTO SALGADO (PIRAÚBA) - INEP: 181307
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181307' 
    WHERE UPPER(TRIM(name)) = 'EE AURÉLIO BENTO SALGADO' 
      AND UPPER(TRIM(city)) = 'PIRAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181307');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAFAYETE MAURÍCIO LOPES (PIRAÚBA) - INEP: 181366
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181366' 
    WHERE UPPER(TRIM(name)) = 'EE LAFAYETE MAURÍCIO LOPES' 
      AND UPPER(TRIM(city)) = 'PIRAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181366');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA FRANCISCA PEREIRA RODRIGUES (PIRAÚBA) - INEP: 181382
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181382' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA FRANCISCA PEREIRA RODRIGUES' 
      AND UPPER(TRIM(city)) = 'PIRAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181382');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO LUCAS MARTINS (PRESIDENTE BERNARDES) - INEP: 181404
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181404' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO LUCAS MARTINS' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE BERNARDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181404');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE VICENTE CARVALHO (PRESIDENTE BERNARDES) - INEP: 181412
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181412' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE VICENTE CARVALHO' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE BERNARDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181412');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ BORGES DE MORAIS (RIO POMBA) - INEP: 181498
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181498' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ BORGES DE MORAIS' 
      AND UPPER(TRIM(city)) = 'RIO POMBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181498');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MÁRCIO NICOLATO (RODEIRO) - INEP: 181528
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181528' 
    WHERE UPPER(TRIM(name)) = 'EE MÁRCIO NICOLATO' 
      AND UPPER(TRIM(city)) = 'RODEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181528');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ÁLVARO GIESTA (SÃO GERALDO) - INEP: 181536
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181536' 
    WHERE UPPER(TRIM(name)) = 'EE ÁLVARO GIESTA' 
      AND UPPER(TRIM(city)) = 'SÃO GERALDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181536');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINISTRO ALOÍSIO COSTA (SÃO GERALDO) - INEP: 181579
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181579' 
    WHERE UPPER(TRIM(name)) = 'EE MINISTRO ALOÍSIO COSTA' 
      AND UPPER(TRIM(city)) = 'SÃO GERALDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181579');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR CÍCERO TORRES GALINDO (SENADOR FIRMINO) - INEP: 181609
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181609' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CÍCERO TORRES GALINDO' 
      AND UPPER(TRIM(city)) = 'SENADOR FIRMINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181609');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTO ANTÔNIO (SILVEIRÂNIA) - INEP: 181641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181641' 
    WHERE UPPER(TRIM(name)) = 'EE SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'SILVEIRÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MENELICK DE CARVALHO (TABULEIRO) - INEP: 181692
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181692' 
    WHERE UPPER(TRIM(name)) = 'EE MENELICK DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'TABULEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181692');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR JOÃO PINTO (TOCANTINS) - INEP: 181854
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181854' 
    WHERE UPPER(TRIM(name)) = 'EE DR JOÃO PINTO' 
      AND UPPER(TRIM(city)) = 'TOCANTINS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181854');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOÃO LOYOLA (TOCANTINS) - INEP: 181757
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181757' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOÃO LOYOLA' 
      AND UPPER(TRIM(city)) = 'TOCANTINS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181757');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSOR JOSÉ CARNEIRO DE CASTRO (UBÁ) - INEP: 182028
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182028' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR JOSÉ CARNEIRO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182028');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES DA PMMG - CTPM - UNIDADE CÂNDIDO MARTINS DE OLIVEIRA (UBÁ) - INEP: 369985
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369985' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES DA PMMG - CTPM - UNIDADE CÂNDIDO MARTINS DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369985');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BARÃO DO RIO BRANCO (UBÁ) - INEP: 182109
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182109' 
    WHERE UPPER(TRIM(name)) = 'EE BARÃO DO RIO BRANCO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182109');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CESÁRIO ALVIM (UBÁ) - INEP: 181919
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181919' 
    WHERE UPPER(TRIM(name)) = 'EE CESÁRIO ALVIM' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181919');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL CAMILO SOARES (UBÁ) - INEP: 181935
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181935' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL CAMILO SOARES' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181935');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOÃO FERREIRA DE ANDRADE (UBÁ) - INEP: 182095
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182095' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOÃO FERREIRA DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182095');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL TEIXEIRA ERVILHA (UBÁ) - INEP: 182087
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182087' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL TEIXEIRA ERVILHA' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182087');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO CARLOS PEIXOTO FILHO (UBÁ) - INEP: 181951
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181951' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO CARLOS PEIXOTO FILHO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181951');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ JANUÁRIO CARNEIRO (UBÁ) - INEP: 181978
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181978' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ JANUÁRIO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181978');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR LEVINDO COELHO (UBÁ) - INEP: 181994
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181994' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR LEVINDO COELHO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181994');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EUNICE WEAVER (UBÁ) - INEP: 181820
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181820' 
    WHERE UPPER(TRIM(name)) = 'EE EUNICE WEAVER' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181820');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR VALADARES (UBÁ) - INEP: 182036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182036' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR VALADARES' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOÃOZINHO (UBÁ) - INEP: 182001
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182001' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOÃOZINHO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182001');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LÍVIO DE CASTRO CARNEIRO (UBÁ) - INEP: 181943
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181943' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LÍVIO DE CASTRO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181943');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAUL SOARES (UBÁ) - INEP: 182052
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182052' 
    WHERE UPPER(TRIM(name)) = 'EE RAUL SOARES' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182052');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ (UBÁ) - INEP: 182079
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182079' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182079');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SENADOR LEVINDO COELHO (UBÁ) - INEP: 181862
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181862' 
    WHERE UPPER(TRIM(name)) = 'EE SENADOR LEVINDO COELHO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181862');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSOR PAULO ROBERTO REIS DE ALMEIDA (VISCONDE DO RIO BRANCO) - INEP: 182214
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182214' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR PAULO ROBERTO REIS DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182214');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL AVELINO CARDOSO (VISCONDE DO RIO BRANCO) - INEP: 182184
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182184' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL AVELINO CARDOSO' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182184');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR CELSO MACHADO (VISCONDE DO RIO BRANCO) - INEP: 182222
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182222' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR CELSO MACHADO' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182222');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TENENTE ROBERTO SOARES DE SOUZA LIMA (VISCONDE DO RIO BRANCO) - INEP: 182150
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182150' 
    WHERE UPPER(TRIM(name)) = 'EE TENENTE ROBERTO SOARES DE SOUZA LIMA' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182150');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ACÁCIO DA SILVA (ÁGUA COMPRIDA) - INEP: 311863
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311863' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ACÁCIO DA SILVA' 
      AND UPPER(TRIM(city)) = 'ÁGUA COMPRIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311863');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARMANDO SANTOS (ARAXÁ) - INEP: 158178
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158178' 
    WHERE UPPER(TRIM(name)) = 'EE ARMANDO SANTOS' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158178');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOSÉ ADOLFO AGUIAR (ARAXÁ) - INEP: 158186
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158186' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ ADOLFO AGUIAR' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158186');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM JOSÉ GASPAR (ARAXÁ) - INEP: 158224
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158224' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOSÉ GASPAR' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158224');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LOREN RIOS FERES (ARAXÁ) - INEP: 158330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158330' 
    WHERE UPPER(TRIM(name)) = 'EE LOREN RIOS FERES' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZA DE OLIVEIRA FARIA (ARAXÁ) - INEP: 158267
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158267' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZA DE OLIVEIRA FARIA' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158267');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DE MAGALHÃES (ARAXÁ) - INEP: 158275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158275' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DE MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ANACLETO GIRALDI (ARAXÁ) - INEP: 158216
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158216' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ANACLETO GIRALDI' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158216');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LUIZ ANTÔNIO CORRÊA OLIVEIRA (ARAXÁ) - INEP: 158194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158194' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LUIZ ANTÔNIO CORRÊA OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROTARY (ARAXÁ) - INEP: 218502
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218502' 
    WHERE UPPER(TRIM(name)) = 'EE ROTARY' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218502');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VASCO SANTOS (ARAXÁ) - INEP: 158313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158313' 
    WHERE UPPER(TRIM(name)) = 'EE VASCO SANTOS' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE HENRIQUE PEETERS (CAMPO FLORIDO) - INEP: 278904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278904' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE HENRIQUE PEETERS' 
      AND UPPER(TRIM(city)) = 'CAMPO FLORIDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278904');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ CORDEIRO DE CAMPOS (CAMPOS ALTOS) - INEP: 158534
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158534' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ CORDEIRO DE CAMPOS' 
      AND UPPER(TRIM(city)) = 'CAMPOS ALTOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158534');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE CLEMENTE DE MALETO (CAMPOS ALTOS) - INEP: 158569
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158569' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE CLEMENTE DE MALETO' 
      AND UPPER(TRIM(city)) = 'CAMPOS ALTOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158569');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BOM SUCESSO (CARNEIRINHO) - INEP: 159255
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159255' 
    WHERE UPPER(TRIM(name)) = 'EE BOM SUCESSO' 
      AND UPPER(TRIM(city)) = 'CARNEIRINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159255');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARECHAL HERMES (CARNEIRINHO) - INEP: 159271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159271' 
    WHERE UPPER(TRIM(name)) = 'EE MARECHAL HERMES' 
      AND UPPER(TRIM(city)) = 'CARNEIRINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159271');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO DA SILVA (CARNEIRINHO) - INEP: 159301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159301' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO DA SILVA' 
      AND UPPER(TRIM(city)) = 'CARNEIRINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE COMENDADOR GOMES (COMENDADOR GOMES) - INEP: 330671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330671' 
    WHERE UPPER(TRIM(name)) = 'EE COMENDADOR GOMES' 
      AND UPPER(TRIM(city)) = 'COMENDADOR GOMES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HERCULÉGIO ANTÔNIO BORGES (CONCEIÇÃO DAS ALAGOAS) - INEP: 316041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316041' 
    WHERE UPPER(TRIM(name)) = 'EE HERCULÉGIO ANTÔNIO BORGES' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DAS ALAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ALEXANDRE MIZIARA (CONCEIÇÃO DAS ALAGOAS) - INEP: 158674
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158674' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ALEXANDRE MIZIARA' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DAS ALAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158674');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR LINDOLFO BERNARDES (CONQUISTA) - INEP: 310883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310883' 
    WHERE UPPER(TRIM(name)) = 'EE DR LINDOLFO BERNARDES' 
      AND UPPER(TRIM(city)) = 'CONQUISTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IVAN MATTAR SOUKEF (DELTA) - INEP: 322644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322644' 
    WHERE UPPER(TRIM(name)) = 'EE IVAN MATTAR SOUKEF' 
      AND UPPER(TRIM(city)) = 'DELTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO KOPKE (FRONTEIRA) - INEP: 158801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158801' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO KOPKE' 
      AND UPPER(TRIM(city)) = 'FRONTEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158801');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA DO CARMO PIRES ROSA (FRONTEIRA) - INEP: 361356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361356' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA DO CARMO PIRES ROSA' 
      AND UPPER(TRIM(city)) = 'FRONTEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAURISTON SOUZA (FRUTAL) - INEP: 158909
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158909' 
    WHERE UPPER(TRIM(name)) = 'EE LAURISTON SOUZA' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158909');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAESTRO JOSINO DE OLIVEIRA (FRUTAL) - INEP: 158879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158879' 
    WHERE UPPER(TRIM(name)) = 'EE MAESTRO JOSINO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO NEVES (FRUTAL) - INEP: 319201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319201' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319201');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR BANDEIRA (FRUTAL) - INEP: 319104
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319104' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR BANDEIRA' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319104');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VICENTE MACEDO (FRUTAL) - INEP: 158941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158941' 
    WHERE UPPER(TRIM(name)) = 'EE VICENTE MACEDO' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALONSO DE MORAIS ANDRADE (ITAPAGIPE) - INEP: 159131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159131' 
    WHERE UPPER(TRIM(name)) = 'EE ALONSO DE MORAIS ANDRADE' 
      AND UPPER(TRIM(city)) = 'ITAPAGIPE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159131');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTO ANTÔNIO (ITAPAGIPE) - INEP: 159158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159158' 
    WHERE UPPER(TRIM(name)) = 'EE SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'ITAPAGIPE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SERRA DA MOEDA (ITAPAGIPE) - INEP: 159140
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159140' 
    WHERE UPPER(TRIM(name)) = 'EE SERRA DA MOEDA' 
      AND UPPER(TRIM(city)) = 'ITAPAGIPE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159140');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO FERREIRA BARBOSA (ITURAMA) - INEP: 159166
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159166' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO FERREIRA BARBOSA' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159166');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM ALEXANDRE (ITURAMA) - INEP: 159247
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159247' 
    WHERE UPPER(TRIM(name)) = 'EE DOM ALEXANDRE' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159247');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM TIAGO DE QUEIROZ (ITURAMA) - INEP: 205605
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205605' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM TIAGO DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205605');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DE LOURDES (ITURAMA) - INEP: 159182
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159182' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DE LOURDES' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159182');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TIRADENTES (ITURAMA) - INEP: 159212
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159212' 
    WHERE UPPER(TRIM(name)) = 'EE TIRADENTES' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159212');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IZOLDINO SOARES DE FREITAS (LIMEIRA DO OESTE) - INEP: 159280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159280' 
    WHERE UPPER(TRIM(name)) = 'EE IZOLDINO SOARES DE FREITAS' 
      AND UPPER(TRIM(city)) = 'LIMEIRA DO OESTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LEÃO COELHO DE ALMEIDA (PEDRINÓPOLIS) - INEP: 159328
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159328' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LEÃO COELHO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'PEDRINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159328');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL OSCAR DE CASTRO (PIRAJUBA) - INEP: 311855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311855' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL OSCAR DE CASTRO' 
      AND UPPER(TRIM(city)) = 'PIRAJUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALYSSON ROBERTO BRUNO (PLANURA) - INEP: 159417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159417' 
    WHERE UPPER(TRIM(name)) = 'EE ALYSSON ROBERTO BRUNO' 
      AND UPPER(TRIM(city)) = 'PLANURA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARLENE MARTINS REIS (PRATINHA) - INEP: 319112
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319112' 
    WHERE UPPER(TRIM(name)) = 'EE MARLENE MARTINS REIS' 
      AND UPPER(TRIM(city)) = 'PRATINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319112');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BARÃO DA RIFAINA (SACRAMENTO) - INEP: 159484
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159484' 
    WHERE UPPER(TRIM(name)) = 'EE BARÃO DA RIFAINA' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159484');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOSÉ AFONSO DE ALMEIDA (SACRAMENTO) - INEP: 159506
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159506' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ AFONSO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159506');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ESCRITORA CAROLINA MARIA DE JESUS (SACRAMENTO) - INEP: 361224
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361224' 
    WHERE UPPER(TRIM(name)) = 'EE ESCRITORA CAROLINA MARIA DE JESUS' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361224');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SINHANA BORGES (SACRAMENTO) - INEP: 159565
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159565' 
    WHERE UPPER(TRIM(name)) = 'EE SINHANA BORGES' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159565');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA JULIANA (SANTA JULIANA) - INEP: 159611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159611' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA JULIANA' 
      AND UPPER(TRIM(city)) = 'SANTA JULIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO FRANCISCO DE SALES (SÃO FRANCISCO DE SALES) - INEP: 159646
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159646' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO FRANCISCO DE SALES' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO DE SALES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159646');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA CECÍLIA MARIA DE REZENDE NEVES (TAPIRA) - INEP: 310166
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310166' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CECÍLIA MARIA DE REZENDE NEVES' 
      AND UPPER(TRIM(city)) = 'TAPIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310166');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ORIENTAÇÃO E PESQUISA EM EDUCAÇÃO ESPECIAL (UBERABA) - INEP: 218588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218588' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ORIENTAÇÃO E PESQUISA EM EDUCAÇÃO ESPECIAL' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA MARIA EMÍLIA DA ROCHA (UBERABA) - INEP: 313751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313751' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA MARIA EMÍLIA DA ROCHA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (UBERABA) - INEP: 160253
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160253' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160253');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALOÍZIO CASTANHEIRA (UBERABA) - INEP: 342556
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342556' 
    WHERE UPPER(TRIM(name)) = 'EE ALOÍZIO CASTANHEIRA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342556');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉRICA (UBERABA) - INEP: 159735
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159735' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉRICA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159735');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AURÉLIO LUIZ DA COSTA (UBERABA) - INEP: 159662
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159662' 
    WHERE UPPER(TRIM(name)) = 'EE AURÉLIO LUIZ DA COSTA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159662');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BERNARDO VASCONCELOS (UBERABA) - INEP: 159786
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159786' 
    WHERE UPPER(TRIM(name)) = 'EE BERNARDO VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159786');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BOULANGER PUCCI (UBERABA) - INEP: 159841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159841' 
    WHERE UPPER(TRIM(name)) = 'EE BOULANGER PUCCI' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARMELITA CARVALHO GARCIA (UBERABA) - INEP: 160261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160261' 
    WHERE UPPER(TRIM(name)) = 'EE CARMELITA CARVALHO GARCIA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ MENDONÇA (UBERABA) - INEP: 160024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160024' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ MENDONÇA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELÍCIO DE PAIVA (UBERABA) - INEP: 160067
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160067' 
    WHERE UPPER(TRIM(name)) = 'EE FELÍCIO DE PAIVA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160067');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO CÂNDIDO XAVIER (UBERABA) - INEP: 349321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349321' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO CÂNDIDO XAVIER' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FREI LEOPOLDO DE CASTELNUOVO (UBERABA) - INEP: 160083
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160083' 
    WHERE UPPER(TRIM(name)) = 'EE FREI LEOPOLDO DE CASTELNUOVO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160083');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GABRIEL TOTI (UBERABA) - INEP: 160105
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160105' 
    WHERE UPPER(TRIM(name)) = 'EE GABRIEL TOTI' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160105');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDINO RODRIGUES CUNHA (UBERABA) - INEP: 160237
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160237' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDINO RODRIGUES CUNHA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160237');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HENRIQUE KRUGER (UBERABA) - INEP: 160121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160121' 
    WHERE UPPER(TRIM(name)) = 'EE HENRIQUE KRUGER' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HORIZONTA LEMOS (UBERABA) - INEP: 160148
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160148' 
    WHERE UPPER(TRIM(name)) = 'EE HORIZONTA LEMOS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160148');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃO AFONSO (UBERABA) - INEP: 160164
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160164' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃO AFONSO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160164');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAURO FONTOURA (UBERABA) - INEP: 160172
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160172' 
    WHERE UPPER(TRIM(name)) = 'EE LAURO FONTOURA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160172');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LEANDRO ANTÔNIO DE VITO (UBERABA) - INEP: 160245
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160245' 
    WHERE UPPER(TRIM(name)) = 'EE LEANDRO ANTÔNIO DE VITO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160245');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARECHAL HUMBERTO ALENCAR CASTELO BRANCO (UBERABA) - INEP: 159671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159671' 
    WHERE UPPER(TRIM(name)) = 'EE MARECHAL HUMBERTO ALENCAR CASTELO BRANCO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINAS GERAIS (UBERABA) - INEP: 159751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159751' 
    WHERE UPPER(TRIM(name)) = 'EE MINAS GERAIS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DA ABADIA (UBERABA) - INEP: 159794
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159794' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DA ABADIA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159794');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PAULO JOSÉ DERENUSSON (UBERABA) - INEP: 159891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159891' 
    WHERE UPPER(TRIM(name)) = 'EE PAULO JOSÉ DERENUSSON' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE JOÃO PINHEIRO (UBERABA) - INEP: 159956
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159956' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE JOÃO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159956');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ALCEU NOVAES (UBERABA) - INEP: 159999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159999' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ALCEU NOVAES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR CHAVES (UBERABA) - INEP: 160016
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160016' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CHAVES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160016');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR HILDEBRANDO PONTES (UBERABA) - INEP: 160059
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160059' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR HILDEBRANDO PONTES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160059');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA CORINA DE OLIVEIRA (UBERABA) - INEP: 159972
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159972' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CORINA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159972');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA NEIDE OLIVEIRA GOMES (UBERABA) - INEP: 349313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349313' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA NEIDE OLIVEIRA GOMES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE QUINTILIANO JARDIM (UBERABA) - INEP: 160075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160075' 
    WHERE UPPER(TRIM(name)) = 'EE QUINTILIANO JARDIM' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160075');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROTARY (UBERABA) - INEP: 160091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160091' 
    WHERE UPPER(TRIM(name)) = 'EE ROTARY' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA TEREZINHA (UBERABA) - INEP: 160130
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160130' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160130');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO BENEDITO (UBERABA) - INEP: 160156
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160156' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO BENEDITO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160156');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM PEDRO II (UNIÃO DE MINAS) - INEP: 159310
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159310' 
    WHERE UPPER(TRIM(name)) = 'EE DOM PEDRO II' 
      AND UPPER(TRIM(city)) = 'UNIÃO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159310');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDINO RODRIGUES DA CUNHA (VERÍSSIMO) - INEP: 160326
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160326' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDINO RODRIGUES DA CUNHA' 
      AND UPPER(TRIM(city)) = 'VERÍSSIMO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160326');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC JK (ARAGUARI) - INEP: 166821
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166821' 
    WHERE UPPER(TRIM(name)) = 'CESEC JK' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166821');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES DA PMMG - CTPM - UNIDADE ARAGUARI (ARAGUARI) - INEP: 369993
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369993' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES DA PMMG - CTPM - UNIDADE ARAGUARI' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369993');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONSERVATÓRIO ESTADUAL MÚSICA E CENTRO INTERESCOLAR ARTES RAUL BELÉM (ARAGUARI) - INEP: 166642
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166642' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO ESTADUAL MÚSICA E CENTRO INTERESCOLAR ARTES RAUL BELÉM' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166642');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO NUNES CARVALHO FILHO (ARAGUARI) - INEP: 166618
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166618' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO NUNES CARVALHO FILHO' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166618');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARTUR BERNARDES (ARAGUARI) - INEP: 166839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166839' 
    WHERE UPPER(TRIM(name)) = 'EE ARTUR BERNARDES' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL LINDOLFO RODRIGUES CUNHA (ARAGUARI) - INEP: 166855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166855' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL LINDOLFO RODRIGUES CUNHA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE COSTA SENA (ARAGUARI) - INEP: 166626
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166626' 
    WHERE UPPER(TRIM(name)) = 'EE COSTA SENA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166626');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA ELEONORA PIERUCCETTI (ARAGUARI) - INEP: 166634
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166634' 
    WHERE UPPER(TRIM(name)) = 'EE DONA ELEONORA PIERUCCETTI' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166634');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ISOLINA FRANÇA SOARES TORRES (ARAGUARI) - INEP: 166651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166651' 
    WHERE UPPER(TRIM(name)) = 'EE ISOLINA FRANÇA SOARES TORRES' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ CARNEIRO DA CUNHA (ARAGUARI) - INEP: 166812
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166812' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ CARNEIRO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166812');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MADRE MARIA BLANDINA (ARAGUARI) - INEP: 166685
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166685' 
    WHERE UPPER(TRIM(name)) = 'EE MADRE MARIA BLANDINA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166685');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE DAMIÃO (ARAGUARI) - INEP: 166693
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166693' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE DAMIÃO' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166693');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PAES DE ALMEIDA (ARAGUARI) - INEP: 166715
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166715' 
    WHERE UPPER(TRIM(name)) = 'EE PAES DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166715');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO MARQUES (ARAGUARI) - INEP: 166731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166731' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO MARQUES' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA KATY BELEM (ARAGUARI) - INEP: 166782
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166782' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA KATY BELEM' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166782');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAUL SOARES (ARAGUARI) - INEP: 166740
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166740' 
    WHERE UPPER(TRIM(name)) = 'EE RAUL SOARES' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166740');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JUDAS TADEU (ARAGUARI) - INEP: 166766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166766' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MÁRIO SIDNEY FRANCESCHI (ARAPORÃ) - INEP: 167207
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167207' 
    WHERE UPPER(TRIM(name)) = 'EE MÁRIO SIDNEY FRANCESCHI' 
      AND UPPER(TRIM(city)) = 'ARAPORÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167207');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA ROMILDA DINIZ (CAMPINA VERDE) - INEP: 158429
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158429' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA ROMILDA DINIZ' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158429');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANA CHAVES (CAMPINA VERDE) - INEP: 158356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158356' 
    WHERE UPPER(TRIM(name)) = 'EE ANA CHAVES' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR NICODEMUS DE MACEDO (CAMPINA VERDE) - INEP: 319147
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319147' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR NICODEMUS DE MACEDO' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319147');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DAS GRAÇAS (CAMPINA VERDE) - INEP: 158399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158399' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OLINDA CORREA BORGES (CAMPINA VERDE) - INEP: 158437
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158437' 
    WHERE UPPER(TRIM(name)) = 'EE OLINDA CORREA BORGES' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158437');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NÉLSON SOARES DE OLIVEIRA (INDIANÓPOLIS) - INEP: 166871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166871' 
    WHERE UPPER(TRIM(name)) = 'EE NÉLSON SOARES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'INDIANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166871');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EUFRAUSINA DA COSTA ARAÚJO (MONTE ALEGRE DE MINAS) - INEP: 166961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166961' 
    WHERE UPPER(TRIM(name)) = 'EE EUFRAUSINA DA COSTA ARAÚJO' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONTE ALEGRE DE MINAS (MONTE ALEGRE DE MINAS) - INEP: 166936
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166936' 
    WHERE UPPER(TRIM(name)) = 'EE MONTE ALEGRE DE MINAS' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166936');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TANCREDO MARTINS (MONTE ALEGRE DE MINAS) - INEP: 166952
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166952' 
    WHERE UPPER(TRIM(name)) = 'EE TANCREDO MARTINS' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166952');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSIAS PINTO (NOVA PONTE) - INEP: 166979
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166979' 
    WHERE UPPER(TRIM(name)) = 'EE JOSIAS PINTO' 
      AND UPPER(TRIM(city)) = 'NOVA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166979');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL PEDRO NERY (PRATA) - INEP: 319163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319163' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL PEDRO NERY' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO PRATA (PRATA) - INEP: 167045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167045' 
    WHERE UPPER(TRIM(name)) = 'EE DO PRATA' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NORALDINO LIMA (PRATA) - INEP: 319171
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319171' 
    WHERE UPPER(TRIM(name)) = 'EE NORALDINO LIMA' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319171');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR VALENTIN (PRATA) - INEP: 167053
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167053' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR VALENTIN' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167053');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANA ESTERLITA ALVES (TUPACIGUARA) - INEP: 167118
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167118' 
    WHERE UPPER(TRIM(name)) = 'EE ANA ESTERLITA ALVES' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167118');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLERTAN MOREIRA DO VALE (TUPACIGUARA) - INEP: 167169
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167169' 
    WHERE UPPER(TRIM(name)) = 'EE CLERTAN MOREIRA DO VALE' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167169');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (TUPACIGUARA) - INEP: 361305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361305' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361305');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO DIAS FERRAZ (TUPACIGUARA) - INEP: 167193
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167193' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO DIAS FERRAZ' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167193');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (UBERLÂNDIA) - INEP: 362298
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362298' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362298');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE 13 DE MAIO (UBERLÂNDIA) - INEP: 167657
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167657' 
    WHERE UPPER(TRIM(name)) = 'EE 13 DE MAIO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167657');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFONSO ARINOS (UBERLÂNDIA) - INEP: 167240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167240' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO ARINOS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALDA MOTA BATISTA (UBERLÂNDIA) - INEP: 167282
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167282' 
    WHERE UPPER(TRIM(name)) = 'EE ALDA MOTA BATISTA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167282');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMADOR NAVES (UBERLÂNDIA) - INEP: 167363
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167363' 
    WHERE UPPER(TRIM(name)) = 'EE AMADOR NAVES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167363');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉRICO RENÉ GIANNETTI (UBERLÂNDIA) - INEP: 167321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167321' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉRICO RENÉ GIANNETTI' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ÂNGELA TEIXEIRA DA SILVA (UBERLÂNDIA) - INEP: 167401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167401' 
    WHERE UPPER(TRIM(name)) = 'EE ÂNGELA TEIXEIRA DA SILVA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANGELINO PAVAN (UBERLÂNDIA) - INEP: 167461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167461' 
    WHERE UPPER(TRIM(name)) = 'EE ANGELINO PAVAN' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO LUIS BASTOS (UBERLÂNDIA) - INEP: 167487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167487' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO LUIS BASTOS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO THOMAZ FERREIRA DE REZENDE (UBERLÂNDIA) - INEP: 167771
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167771' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO THOMAZ FERREIRA DE REZENDE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167771');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BUENO BRANDÃO (UBERLÂNDIA) - INEP: 167568
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167568' 
    WHERE UPPER(TRIM(name)) = 'EE BUENO BRANDÃO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167568');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLARIMUNDO CARNEIRO (UBERLÂNDIA) - INEP: 167681
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167681' 
    WHERE UPPER(TRIM(name)) = 'EE CLARIMUNDO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167681');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CUSTÓDIO DA COSTA PEREIRA (UBERLÂNDIA) - INEP: 167223
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167223' 
    WHERE UPPER(TRIM(name)) = 'EE CUSTÓDIO DA COSTA PEREIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167223');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA CIDADE INDUSTRIAL (UBERLÂNDIA) - INEP: 167649
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167649' 
    WHERE UPPER(TRIM(name)) = 'EE DA CIDADE INDUSTRIAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167649');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (UBERLÂNDIA) - INEP: 338893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338893' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338893');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE UBERLÂNDIA (UBERLÂNDIA) - INEP: 167690
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167690' 
    WHERE UPPER(TRIM(name)) = 'EE DE UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167690');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO BAIRRO JARDIM DAS PALMEIRAS (UBERLÂNDIA) - INEP: 167665
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167665' 
    WHERE UPPER(TRIM(name)) = 'EE DO BAIRRO JARDIM DAS PALMEIRAS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167665');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO PARQUE SÃO JORGE (UBERLÂNDIA) - INEP: 167797
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167797' 
    WHERE UPPER(TRIM(name)) = 'EE DO PARQUE SÃO JORGE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167797');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR DUARTE PIMENTEL DE ULHOA (UBERLÂNDIA) - INEP: 167827
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167827' 
    WHERE UPPER(TRIM(name)) = 'EE DR DUARTE PIMENTEL DE ULHOA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167827');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ENÉIAS VASCONCELOS (UBERLÂNDIA) - INEP: 167215
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167215' 
    WHERE UPPER(TRIM(name)) = 'EE ENÉIAS VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167215');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELISBERTO ALVES CARREJO (UBERLÂNDIA) - INEP: 167231
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167231' 
    WHERE UPPER(TRIM(name)) = 'EE FELISBERTO ALVES CARREJO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167231');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FREI EGÍDIO PARISI (UBERLÂNDIA) - INEP: 167584
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167584' 
    WHERE UPPER(TRIM(name)) = 'EE FREI EGÍDIO PARISI' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167584');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GUIOMAR DE FREITAS COSTA (UBERLÂNDIA) - INEP: 167258
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167258' 
    WHERE UPPER(TRIM(name)) = 'EE GUIOMAR DE FREITAS COSTA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167258');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HERCÍLIA MARTINS REZENDE (UBERLÂNDIA) - INEP: 167703
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167703' 
    WHERE UPPER(TRIM(name)) = 'EE HERCÍLIA MARTINS REZENDE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167703');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HONÓRIO GUIMARÃES (UBERLÂNDIA) - INEP: 167274
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167274' 
    WHERE UPPER(TRIM(name)) = 'EE HONÓRIO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167274');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HORTÊNCIO DINIZ (UBERLÂNDIA) - INEP: 167266
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167266' 
    WHERE UPPER(TRIM(name)) = 'EE HORTÊNCIO DINIZ' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167266');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IGNÁCIO PAES LEME (UBERLÂNDIA) - INEP: 167291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167291' 
    WHERE UPPER(TRIM(name)) = 'EE IGNÁCIO PAES LEME' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JARDIM IPANEMA (UBERLÂNDIA) - INEP: 167878
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167878' 
    WHERE UPPER(TRIM(name)) = 'EE JARDIM IPANEMA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167878');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JERÔNIMO ARANTES (UBERLÂNDIA) - INEP: 167606
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167606' 
    WHERE UPPER(TRIM(name)) = 'EE JERÔNIMO ARANTES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167606');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO REZENDE (UBERLÂNDIA) - INEP: 167622
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167622' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO REZENDE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167622');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM SARAIVA (UBERLÂNDIA) - INEP: 167312
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167312' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM SARAIVA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167312');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ GOMES JUNQUEIRA (UBERLÂNDIA) - INEP: 207403
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '207403' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ GOMES JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '207403');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LOURDES DE CARVALHO (UBERLÂNDIA) - INEP: 167509
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167509' 
    WHERE UPPER(TRIM(name)) = 'EE LOURDES DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167509');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARECHAL CASTELO BRANCO (UBERLÂNDIA) - INEP: 167371
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167371' 
    WHERE UPPER(TRIM(name)) = 'EE MARECHAL CASTELO BRANCO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167371');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DA CONCEIÇÃO BARBOSA DE SOUZA (UBERLÂNDIA) - INEP: 167410
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167410' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DA CONCEIÇÃO BARBOSA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167410');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MÁRIO PORTO (UBERLÂNDIA) - INEP: 167398
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167398' 
    WHERE UPPER(TRIM(name)) = 'EE MÁRIO PORTO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167398');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESSIAS PEDREIRO (UBERLÂNDIA) - INEP: 167436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167436' 
    WHERE UPPER(TRIM(name)) = 'EE MESSIAS PEDREIRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167436');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NEUZA REZENDE (UBERLÂNDIA) - INEP: 167746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167746' 
    WHERE UPPER(TRIM(name)) = 'EE NEUZA REZENDE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NO CONJUNTO HABITACIONAL CRUZEIRO DO SUL (UBERLÂNDIA) - INEP: 167347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167347' 
    WHERE UPPER(TRIM(name)) = 'EE NO CONJUNTO HABITACIONAL CRUZEIRO DO SUL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE MARIO FORESTAN (UBERLÂNDIA) - INEP: 167495
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167495' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE MARIO FORESTAN' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167495');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE JUSCELINO KUBITSCHEK (UBERLÂNDIA) - INEP: 167754
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167754' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE JUSCELINO KUBITSCHEK' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167754');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO NEVES (UBERLÂNDIA) - INEP: 167711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167711' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR EDERLINDO LANNES BERNARDES (UBERLÂNDIA) - INEP: 167843
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167843' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR EDERLINDO LANNES BERNARDES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167843');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR INÁCIO CASTILHO (UBERLÂNDIA) - INEP: 167541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167541' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR INÁCIO CASTILHO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ IGNÁCIO DE SOUSA (UBERLÂNDIA) - INEP: 167339
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167339' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ IGNÁCIO DE SOUSA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167339');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LEÔNIDAS DE CASTRO SERRA (UBERLÂNDIA) - INEP: 167380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167380' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LEÔNIDAS DE CASTRO SERRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR NELSON CUPERTINO (UBERLÂNDIA) - INEP: 167428
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167428' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR NELSON CUPERTINO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167428');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ALICE PAES (UBERLÂNDIA) - INEP: 167517
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167517' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ALICE PAES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167517');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA JUVENÍLIA  FERREIRA DOS SANTOS (UBERLÂNDIA) - INEP: 167304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167304' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA JUVENÍLIA FERREIRA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROTARY (UBERLÂNDIA) - INEP: 167550
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167550' 
    WHERE UPPER(TRIM(name)) = 'EE ROTARY' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167550');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEGISMUNDO PEREIRA (UBERLÂNDIA) - INEP: 167614
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167614' 
    WHERE UPPER(TRIM(name)) = 'EE SEGISMUNDO PEREIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167614');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEIS DE JUNHO (UBERLÂNDIA) - INEP: 167576
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167576' 
    WHERE UPPER(TRIM(name)) = 'EE SEIS DE JUNHO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167576');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÉRGIO DE FREITAS PACHECO (UBERLÂNDIA) - INEP: 167592
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167592' 
    WHERE UPPER(TRIM(name)) = 'EE SÉRGIO DE FREITAS PACHECO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167592');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SETE DE SETEMBRO (UBERLÂNDIA) - INEP: 167631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167631' 
    WHERE UPPER(TRIM(name)) = 'EE SETE DE SETEMBRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEOTÔNIO VILELA (UBERLÂNDIA) - INEP: 167738
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167738' 
    WHERE UPPER(TRIM(name)) = 'EE TEOTÔNIO VILELA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167738');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TUBAL VILELA DA SILVA (UBERLÂNDIA) - INEP: 167673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167673' 
    WHERE UPPER(TRIM(name)) = 'EE TUBAL VILELA DA SILVA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167673');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC AFONSO ARINOS (ARINOS) - INEP: 346268
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346268' 
    WHERE UPPER(TRIM(name)) = 'CESEC AFONSO ARINOS' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346268');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARMOSINA DURÃES MARTINS (ARINOS) - INEP: 108227
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108227' 
    WHERE UPPER(TRIM(name)) = 'EE CARMOSINA DURÃES MARTINS' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108227');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CHICO MENDES (ARINOS) - INEP: 349291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349291' 
    WHERE UPPER(TRIM(name)) = 'EE CHICO MENDES' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GARIBALDINA FERNANDES VALADARES (ARINOS) - INEP: 108219
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108219' 
    WHERE UPPER(TRIM(name)) = 'EE GARIBALDINA FERNANDES VALADARES' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108219');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


