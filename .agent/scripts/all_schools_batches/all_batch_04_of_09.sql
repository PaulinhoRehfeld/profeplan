-- Lote 4 de 9
-- Escolas 1501 a 2000

-- EE MAJOR SAINT CLAIR FERNANDES VALADARES (ARINOS) - INEP: 108197
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108197' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR SAINT CLAIR FERNANDES VALADARES' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108197');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR BENEVIDES (ARINOS) - INEP: 231860
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231860' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR BENEVIDES' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231860');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC ESMÉRIA MARIA DO CARMO (BONFINÓPOLIS DE MINAS) - INEP: 108367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108367' 
    WHERE UPPER(TRIM(name)) = 'CESEC ESMÉRIA MARIA DO CARMO' 
      AND UPPER(TRIM(city)) = 'BONFINÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÂNDIDO ULHÔA (BONFINÓPOLIS DE MINAS) - INEP: 108243
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108243' 
    WHERE UPPER(TRIM(name)) = 'EE CÂNDIDO ULHÔA' 
      AND UPPER(TRIM(city)) = 'BONFINÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108243');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANÁLIA CARNEIRO DOS SANTOS (BURITIS) - INEP: 246204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246204' 
    WHERE UPPER(TRIM(name)) = 'EE ANÁLIA CARNEIRO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARGEMIRO ANTÔNIO PRADO (BURITIS) - INEP: 108413
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108413' 
    WHERE UPPER(TRIM(name)) = 'EE ARGEMIRO ANTÔNIO PRADO' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108413');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ GOMES PIMENTEL (BURITIS) - INEP: 108430
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108430' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ GOMES PIMENTEL' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108430');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO DOMINGOS (BURITIS) - INEP: 108421
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108421' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO DOMINGOS' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108421');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO EDUARDO LUCAS (CABECEIRA GRANDE) - INEP: 109100
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109100' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO EDUARDO LUCAS' 
      AND UPPER(TRIM(city)) = 'CABECEIRA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109100');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUVENAL DIOGO PIRES (CABECEIRA GRANDE) - INEP: 322598
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322598' 
    WHERE UPPER(TRIM(name)) = 'EE JUVENAL DIOGO PIRES' 
      AND UPPER(TRIM(city)) = 'CABECEIRA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322598');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM BOSCO (DOM BOSCO) - INEP: 108375
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108375' 
    WHERE UPPER(TRIM(name)) = 'EE DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'DOM BOSCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108375');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARTINHO ANTÔNIO ORNELAS (FORMOSO) - INEP: 108456
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108456' 
    WHERE UPPER(TRIM(name)) = 'EE MARTINHO ANTÔNIO ORNELAS' 
      AND UPPER(TRIM(city)) = 'FORMOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108456');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DE ABADIA (FORMOSO) - INEP: 205559
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205559' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DE ABADIA' 
      AND UPPER(TRIM(city)) = 'FORMOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205559');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALVARENGA PEIXOTO (NATALÂNDIA) - INEP: 108383
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108383' 
    WHERE UPPER(TRIM(name)) = 'EE ALVARENGA PEIXOTO' 
      AND UPPER(TRIM(city)) = 'NATALÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108383');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DELVITO ALVES DA SILVA (UNAÍ) - INEP: 213292
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213292' 
    WHERE UPPER(TRIM(name)) = 'EE DELVITO ALVES DA SILVA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213292');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM ELISEU (UNAÍ) - INEP: 108987
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108987' 
    WHERE UPPER(TRIM(name)) = 'EE DOM ELISEU' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108987');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOMINGOS PINTO BROCHADO (UNAÍ) - INEP: 108995
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108995' 
    WHERE UPPER(TRIM(name)) = 'EE DOMINGOS PINTO BROCHADO' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108995');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ELISA DE OLIVEIRA CAMPOS (UNAÍ) - INEP: 342475
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342475' 
    WHERE UPPER(TRIM(name)) = 'EE ELISA DE OLIVEIRA CAMPOS' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342475');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUVÊNCIO MARTINS FERREIRA (UNAÍ) - INEP: 239399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239399' 
    WHERE UPPER(TRIM(name)) = 'EE JUVÊNCIO MARTINS FERREIRA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOELA FARIA SOARES (UNAÍ) - INEP: 109037
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109037' 
    WHERE UPPER(TRIM(name)) = 'EE MANOELA FARIA SOARES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109037');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA ASSUNES GONÇALVES (UNAÍ) - INEP: 109045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109045' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ASSUNES GONÇALVES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TANCREDO DE ALMEIDA NEVES (UNAÍ) - INEP: 109053
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109053' 
    WHERE UPPER(TRIM(name)) = 'EE TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109053');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEÓFILO MARTINS FERREIRA (UNAÍ) - INEP: 109002
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109002' 
    WHERE UPPER(TRIM(name)) = 'EE TEÓFILO MARTINS FERREIRA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109002');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VIGÁRIO TORRES (UNAÍ) - INEP: 109011
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109011' 
    WHERE UPPER(TRIM(name)) = 'EE VIGÁRIO TORRES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109011');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VIRGÍLIO DE MELO FRANCO (UNAÍ) - INEP: 109029
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109029' 
    WHERE UPPER(TRIM(name)) = 'EE VIRGÍLIO DE MELO FRANCO' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109029');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DARCI RIBEIRO (URUANA DE MINAS) - INEP: 322601
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322601' 
    WHERE UPPER(TRIM(name)) = 'EE DARCI RIBEIRO' 
      AND UPPER(TRIM(city)) = 'URUANA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322601');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DIRCE MOURA LEITE (ALFENAS) - INEP: 170828
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170828' 
    WHERE UPPER(TRIM(name)) = 'EE DIRCE MOURA LEITE' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170828');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR EMÍLIO SILVEIRA (ALFENAS) - INEP: 170798
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170798' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR EMÍLIO SILVEIRA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170798');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR NAPOLEÃO SALLES (ALFENAS) - INEP: 170887
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170887' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR NAPOLEÃO SALLES' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170887');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUDITH VIANNA (ALFENAS) - INEP: 170810
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170810' 
    WHERE UPPER(TRIM(name)) = 'EE JUDITH VIANNA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170810');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ GRIMMINCK (ALFENAS) - INEP: 170895
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170895' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ GRIMMINCK' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170895');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO ISMAEL BRASIL CORRÊA (ALFENAS) - INEP: 170844
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170844' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO ISMAEL BRASIL CORRÊA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170844');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LEVINDO LAMBERT (ALFENAS) - INEP: 170852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170852' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LEVINDO LAMBERT' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170852');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR VIANA (ALFENAS) - INEP: 170861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170861' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR VIANA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SAMUEL ENGEL (ALFENAS) - INEP: 170879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170879' 
    WHERE UPPER(TRIM(name)) = 'EE SAMUEL ENGEL' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA SINHÁ LEITE (BOA ESPERANÇA) - INEP: 171280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171280' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA SINHÁ LEITE' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CASIMIRO SILVA (BOA ESPERANÇA) - INEP: 171123
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171123' 
    WHERE UPPER(TRIM(name)) = 'EE CASIMIRO SILVA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171123');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOAQUIM VILELA (BOA ESPERANÇA) - INEP: 171174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171174' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOAQUIM VILELA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR SÁ BRITO (BOA ESPERANÇA) - INEP: 171191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171191' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR SÁ BRITO' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOÃO VIEIRA DA FONSECA (BOA ESPERANÇA) - INEP: 171212
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171212' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOÃO VIEIRA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171212');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA SÍLVIA MESQUITA (BOA ESPERANÇA) - INEP: 171255
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171255' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA SÍLVIA MESQUITA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171255');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLÓVIS SALGADO (CAMBUQUIRA) - INEP: 171301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171301' 
    WHERE UPPER(TRIM(name)) = 'EE CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'CAMBUQUIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA UMBELINA DE ANDRADE GOMES (CAMBUQUIRA) - INEP: 171361
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171361' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA UMBELINA DE ANDRADE GOMES' 
      AND UPPER(TRIM(city)) = 'CAMBUQUIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171361');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM INOCÊNCIO (CAMPANHA) - INEP: 171468
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171468' 
    WHERE UPPER(TRIM(name)) = 'EE DOM INOCÊNCIO' 
      AND UPPER(TRIM(city)) = 'CAMPANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171468');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VITAL BRASIL (CAMPANHA) - INEP: 171484
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171484' 
    WHERE UPPER(TRIM(name)) = 'EE VITAL BRASIL' 
      AND UPPER(TRIM(city)) = 'CAMPANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171484');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ZOROASTRO DE OLIVEIRA (CAMPANHA) - INEP: 171492
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171492' 
    WHERE UPPER(TRIM(name)) = 'EE ZOROASTRO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CAMPANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171492');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR JOSÉ MESQUITA NETTO (CAMPO DO MEIO) - INEP: 171581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171581' 
    WHERE UPPER(TRIM(name)) = 'EE DR JOSÉ MESQUITA NETTO' 
      AND UPPER(TRIM(city)) = 'CAMPO DO MEIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE CHICO (CAMPO DO MEIO) - INEP: 171549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171549' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE CHICO' 
      AND UPPER(TRIM(city)) = 'CAMPO DO MEIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR TEÓFILO SAEZ (CAMPOS GERAIS) - INEP: 239143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239143' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR TEÓFILO SAEZ' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ANTÔNIO VIEIRA (CAMPOS GERAIS) - INEP: 171701
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171701' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ANTÔNIO VIEIRA' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171701');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR EDUARDO DANIEL FERREIRA DIAS (CAMPOS GERAIS) - INEP: 171646
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171646' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR EDUARDO DANIEL FERREIRA DIAS' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171646');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOAQUIM JOSÉ DE OLIVEIRA (CAMPOS GERAIS) - INEP: 171689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171689' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOAQUIM JOSÉ DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO MESTRE (CARMO DA CACHOEIRA) - INEP: 171824
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171824' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO MESTRE' 
      AND UPPER(TRIM(city)) = 'CARMO DA CACHOEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171824');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR WANDERLEY FERREIRA DE REZENDE (CARMO DA CACHOEIRA) - INEP: 171786
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171786' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR WANDERLEY FERREIRA DE REZENDE' 
      AND UPPER(TRIM(city)) = 'CARMO DA CACHOEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171786');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DE PAULA CAPRONI (CARVALHÓPOLIS) - INEP: 171999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171999' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DE PAULA CAPRONI' 
      AND UPPER(TRIM(city)) = 'CARVALHÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ANCHIETA (COQUEIRAL) - INEP: 172316
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172316' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ANCHIETA' 
      AND UPPER(TRIM(city)) = 'COQUEIRAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172316');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA CELINA DE REZENDE VILELA (CORDISLÂNDIA) - INEP: 172375
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172375' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CELINA DE REZENDE VILELA' 
      AND UPPER(TRIM(city)) = 'CORDISLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172375');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BRASILINO ALVES PEREIRA (ELÓI MENDES) - INEP: 172499
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172499' 
    WHERE UPPER(TRIM(name)) = 'EE BRASILINO ALVES PEREIRA' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172499');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA NORMA DE BRITO PIEDADE MARTINS (ELÓI MENDES) - INEP: 172618
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172618' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA NORMA DE BRITO PIEDADE MARTINS' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172618');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO LUIZ GONZAGA (ELÓI MENDES) - INEP: 319198
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319198' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO LUIZ GONZAGA' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319198');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TARGINO NOGUEIRA (ELÓI MENDES) - INEP: 172600
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172600' 
    WHERE UPPER(TRIM(name)) = 'EE TARGINO NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172600');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA OLÍMPIA OLIVEIRA (FAMA) - INEP: 305006
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305006' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA OLÍMPIA OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'FAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305006');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR LAURO CORREA DO AMARAL (GUAPÉ) - INEP: 172693
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172693' 
    WHERE UPPER(TRIM(name)) = 'EE DR LAURO CORREA DO AMARAL' 
      AND UPPER(TRIM(city)) = 'GUAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172693');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO PASSOS SILVA (GUAPÉ) - INEP: 229326
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229326' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO PASSOS SILVA' 
      AND UPPER(TRIM(city)) = 'GUAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229326');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA APARECIDA (ILICÍNEA) - INEP: 172804
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172804' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA APARECIDA' 
      AND UPPER(TRIM(city)) = 'ILICÍNEA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172804');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DE ALMEIDA LISBOA (LAMBARI) - INEP: 173011
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173011' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DE ALMEIDA LISBOA' 
      AND UPPER(TRIM(city)) = 'LAMBARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173011');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO NUNES FERREIRA (LAMBARI) - INEP: 173029
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173029' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO NUNES FERREIRA' 
      AND UPPER(TRIM(city)) = 'LAMBARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173029');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA RITA LISBOA PEREIRA SANTORO (LAMBARI) - INEP: 172987
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172987' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA RITA LISBOA PEREIRA SANTORO' 
      AND UPPER(TRIM(city)) = 'LAMBARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172987');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR FABREGAS (LUMINÁRIAS) - INEP: 134287
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134287' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR FABREGAS' 
      AND UPPER(TRIM(city)) = 'LUMINÁRIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134287');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DOUTOR TANCREDO DE ALMEIDA NEVES (MACHADO) - INEP: 173100
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173100' 
    WHERE UPPER(TRIM(name)) = 'CESEC DOUTOR TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173100');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE DOURADINHO (MACHADO) - INEP: 173223
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173223' 
    WHERE UPPER(TRIM(name)) = 'EE DE DOURADINHO' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173223');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GABRIEL ODORICO (MACHADO) - INEP: 173045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173045' 
    WHERE UPPER(TRIM(name)) = 'EE GABRIEL ODORICO' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRACEMA RODRIGUES (MACHADO) - INEP: 173061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173061' 
    WHERE UPPER(TRIM(name)) = 'EE IRACEMA RODRIGUES' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PAULINA RIGOTTI DE CASTRO (MACHADO) - INEP: 173088
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173088' 
    WHERE UPPER(TRIM(name)) = 'EE PAULINA RIGOTTI DE CASTRO' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173088');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RUBENS GARCIA (MACHADO) - INEP: 173169
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173169' 
    WHERE UPPER(TRIM(name)) = 'EE RUBENS GARCIA' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173169');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ROGÉRIO ABDALA (MONSENHOR PAULO) - INEP: 173266
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173266' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ROGÉRIO ABDALA' 
      AND UPPER(TRIM(city)) = 'MONSENHOR PAULO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173266');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOAQUIM RIBEIRO (NEPOMUCENO) - INEP: 173282
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173282' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOAQUIM RIBEIRO' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173282');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA BELA VISTA (NEPOMUCENO) - INEP: 173291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173291' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA BELA VISTA' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE NAZARÉ DE MINAS (NEPOMUCENO) - INEP: 173428
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173428' 
    WHERE UPPER(TRIM(name)) = 'EE DE NAZARÉ DE MINAS' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173428');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE SANTO ANTÔNIO DO CRUZEIRO (NEPOMUCENO) - INEP: 173436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173436' 
    WHERE UPPER(TRIM(name)) = 'EE DE SANTO ANTÔNIO DO CRUZEIRO' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173436');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ERNANE VILELA LIMA (NEPOMUCENO) - INEP: 173371
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173371' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ERNANE VILELA LIMA' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173371');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LICAS DE LIMA (NEPOMUCENO) - INEP: 173380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173380' 
    WHERE UPPER(TRIM(name)) = 'EE LICAS DE LIMA' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE PICCININI (PARAGUAÇU) - INEP: 173533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173533' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE PICCININI' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO LEITE (PARAGUAÇU) - INEP: 173622
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173622' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO LEITE' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173622');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ALFREDO GALDINO (PARAGUAÇU) - INEP: 173631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173631' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ALFREDO GALDINO' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ BONIFÁCIO (POÇO FUNDO) - INEP: 173860
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173860' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ BONIFÁCIO' 
      AND UPPER(TRIM(city)) = 'POÇO FUNDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173860');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO MARCOS (POÇO FUNDO) - INEP: 173878
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173878' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO MARCOS' 
      AND UPPER(TRIM(city)) = 'POÇO FUNDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173878');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA AUGUSTA (SANTANA DA VARGEM) - INEP: 174009
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174009' 
    WHERE UPPER(TRIM(name)) = 'EE DONA AUGUSTA' 
      AND UPPER(TRIM(city)) = 'SANTANA DA VARGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174009');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOÃO NEIVA (SANTANA DA VARGEM) - INEP: 173975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173975' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOÃO NEIVA' 
      AND UPPER(TRIM(city)) = 'SANTANA DA VARGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ALDA DE MOURA CARVALHO (SÃO BENTO ABADE) - INEP: 174017
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174017' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ALDA DE MOURA CARVALHO' 
      AND UPPER(TRIM(city)) = 'SÃO BENTO ABADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174017');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BÁRBARA HELIODORA (SÃO GONÇALO DO SAPUCAÍ) - INEP: 174033
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174033' 
    WHERE UPPER(TRIM(name)) = 'EE BÁRBARA HELIODORA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174033');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOÃO PINHEIRO (SÃO GONÇALO DO SAPUCAÍ) - INEP: 174025
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174025' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOÃO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174025');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINISTRO LUCIO DE MENDONÇA (SÃO GONÇALO DO SAPUCAÍ) - INEP: 174084
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174084' 
    WHERE UPPER(TRIM(name)) = 'EE MINISTRO LUCIO DE MENDONÇA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174084');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉRICO DIAS PEREIRA (TRÊS CORAÇÕES) - INEP: 174416
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174416' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉRICO DIAS PEREIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174416');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BUENO BRANDÃO (TRÊS CORAÇÕES) - INEP: 174386
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174386' 
    WHERE UPPER(TRIM(name)) = 'EE BUENO BRANDÃO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174386');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GODOFREDO RANGEL (TRÊS CORAÇÕES) - INEP: 174475
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174475' 
    WHERE UPPER(TRIM(name)) = 'EE GODOFREDO RANGEL' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174475');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZA GOMES LEMOS (TRÊS CORAÇÕES) - INEP: 174432
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174432' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZA GOMES LEMOS' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174432');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OLÍMPIA DE BRITO (TRÊS CORAÇÕES) - INEP: 174467
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174467' 
    WHERE UPPER(TRIM(name)) = 'EE OLÍMPIA DE BRITO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174467');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR  CLÓVIS SALGADO (TRÊS CORAÇÕES) - INEP: 174394
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174394' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174394');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR FRANCO DA ROSA (TRÊS CORAÇÕES) - INEP: 174483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174483' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR FRANCO DA ROSA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO JOSÉ MARIA (TRÊS PONTAS) - INEP: 174530
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174530' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO JOSÉ MARIA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174530');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO TEODÓSIO BANDEIRA (TRÊS PONTAS) - INEP: 174688
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174688' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO TEODÓSIO BANDEIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174688');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR JOÃO BATISTA DA SILVEIRA (TRÊS PONTAS) - INEP: 174785
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174785' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR JOÃO BATISTA DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174785');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO JACY JUNQUEIRA GAZOLA (TRÊS PONTAS) - INEP: 174700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174700' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO JACY JUNQUEIRA GAZOLA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO NEVES (TRÊS PONTAS) - INEP: 174831
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174831' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174831');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA AUGUSTA VIEIRA CORREA (TRÊS PONTAS) - INEP: 174769
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174769' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA AUGUSTA VIEIRA CORREA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174769');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIETA CASTRO (TRÊS PONTAS) - INEP: 174718
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174718' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIETA CASTRO' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174718');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DA PIEDADE (TURVOLÂNDIA) - INEP: 174858
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174858' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DA PIEDADE' 
      AND UPPER(TRIM(city)) = 'TURVOLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174858');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONSERVATÓRIO ESTADUAL DE MÚSICA MAESTRO MARCILIANO BRAGA (VARGINHA) - INEP: 175111
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175111' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO ESTADUAL DE MÚSICA MAESTRO MARCILIANO BRAGA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175111');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFONSO PENA (VARGINHA) - INEP: 174882
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174882' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO PENA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174882');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BRASIL (VARGINHA) - INEP: 174921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174921' 
    WHERE UPPER(TRIM(name)) = 'EE BRASIL' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174921');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORAÇÃO DE JESUS (VARGINHA) - INEP: 175099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175099' 
    WHERE UPPER(TRIM(name)) = 'EE CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL GABRIEL PENHA DE PAIVA (VARGINHA) - INEP: 174912
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174912' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL GABRIEL PENHA DE PAIVA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174912');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO DOMINGOS DE FIGUEIREDO (VARGINHA) - INEP: 175013
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175013' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO DOMINGOS DE FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175013');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR WLADIMIR DE REZENDE PINTO (VARGINHA) - INEP: 175030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175030' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR WLADIMIR DE REZENDE PINTO' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃO MÁRIO ESDRAS (VARGINHA) - INEP: 175048
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175048' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃO MÁRIO ESDRAS' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175048');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO DE ALCÂNTARA (VARGINHA) - INEP: 175064
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175064' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO DE ALCÂNTARA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175064');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO CORREA CARVALHO (VARGINHA) - INEP: 217719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217719' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO CORREA CARVALHO' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217719');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO DOMINGUES CHAVES (VARGINHA) - INEP: 175072
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175072' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO DOMINGUES CHAVES' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175072');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR FÁBIO SALLES (VARGINHA) - INEP: 174904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174904' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR FÁBIO SALLES' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174904');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ARACY MIRANDA (VARGINHA) - INEP: 175102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175102' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ARACY MIRANDA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA SELMA BASTOS (VARGINHA) - INEP: 356719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356719' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA SELMA BASTOS' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356719');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO SEBASTIÃO (VARGINHA) - INEP: 175081
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175081' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175081');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO DO NORTE DE MINAS - CAMPUS ALMENARA (ALMENARA) - INEP: 349658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349658' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO DO NORTE DE MINAS - CAMPUS ALMENARA' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERA DE EDUCAÇÃO, CIÊNCIA E  TECNOLOGIA DO NORTE DE MINAS GERIAS- CAMPUS ARAÇUAÍ (ARAÇUAÍ) - INEP: 347272
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347272' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERA DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS GERIAS- CAMPUS ARAÇUAÍ' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347272');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO TENCOLOGICA DO NORTE DE MINAS-CAMPUS SALINAS (SALINAS) - INEP: 233269
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233269' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO TENCOLOGICA DO NORTE DE MINAS-CAMPUS SALINAS' 
      AND UPPER(TRIM(city)) = 'SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233269');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS-CAMPUS CONGONHAS (CONGONHAS) - INEP: 345385
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345385' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS-CAMPUS CONGONHAS' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345385');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE MINAS GERIAS-CAMPUS AVANÇADO  DE CONSELHEIRO LAFAIETE (CONSELHEIRO LAFAIETE) - INEP: 365890
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365890' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE MINAS GERIAS-CAMPUS AVANÇADO DE CONSELHEIRO LAFAIETE' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365890');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO - CAMPUS AVANÇADO DE IPATINGA (IPATINGA) - INEP: 359017
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359017' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO - CAMPUS AVANÇADO DE IPATINGA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359017');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS - CAMPUS TIMÓTEO (TIMÓTEO) - INEP: 333361
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333361' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS - CAMPUS TIMÓTEO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333361');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS - CAMPUS CURVELO (CURVELO) - INEP: 347787
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347787' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS - CAMPUS CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347787');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS GERAIS - CAMPUS DIAMANTINA (DIAMANTINA) - INEP: 366765
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366765' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS GERAIS - CAMPUS DIAMANTINA' 
      AND UPPER(TRIM(city)) = 'DIAMANTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366765');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS- CAMPUS DIVINÓPOLIS (DIVINÓPOLIS) - INEP: 268631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268631' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS- CAMPUS DIVINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS GOVERNADOR VALADARES (GOVERNADOR VALADARES) - INEP: 347701
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347701' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS GOVERNADOR VALADARES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347701');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DO TRIANGULO MINEIRO - CAMPUS ITUIUTABA (ITUIUTABA) - INEP: 345407
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345407' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DO TRIANGULO MINEIRO - CAMPUS ITUIUTABA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345407');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MILITAR DE JUIZ DE FORA (JUIZ DE FORA) - INEP: 294471
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294471' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MILITAR DE JUIZ DE FORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294471');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFET DE LEOPOLDINA (LEOPOLDINA) - INEP: 224278
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224278' 
    WHERE UPPER(TRIM(name)) = 'CEFET DE LEOPOLDINA' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224278');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE MINAS GERAIS - CAMPUS SABARÁ (SABARÁ) - INEP: 355402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355402' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE MINAS GERAIS - CAMPUS SABARÁ' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS CAMPUS I BH (BELO HORIZONTE) - INEP: 245488
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245488' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS CAMPUS I BH' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245488');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MILITAR DE BELO HORIZONTE (BELO HORIZONTE) - INEP: 291030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '291030' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MILITAR DE BELO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '291030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE EDUCAÇÃO BASICA E PROFISSIONAL DA UFMG - CENTRO PEDAGOGICO (BELO HORIZONTE) - INEP: 258377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258377' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE EDUCAÇÃO BASICA E PROFISSIONAL DA UFMG - CENTRO PEDAGOGICO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS- CAMPUS SANTA LUZIA (SANTA LUZIA) - INEP: 358150
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358150' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS- CAMPUS SANTA LUZIA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358150');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DO NORTE DE MINAS - CAMPUS MONTES CLAROS (MONTES CLAROS) - INEP: 349607
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349607' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DO NORTE DE MINAS - CAMPUS MONTES CLAROS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349607');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE  DE MINAS GERAIS-CAMPUS MURIAÉ (MURIAÉ) - INEP: 347914
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347914' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS-CAMPUS MURIAÉ' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347914');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS OURO PRETO (OURO PRETO) - INEP: 253227
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253227' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS OURO PRETO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253227');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS FORMIGA (FORMIGA) - INEP: 344664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344664' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS FORMIGA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS- CAMPUS PIRAPORA (PIRAPORA) - INEP: 349410
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349410' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS- CAMPUS PIRAPORA' 
      AND UPPER(TRIM(city)) = 'PIRAPORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349410');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA SUL DE MINAS- CAMPUS MUZAMBINHO (MUZAMBINHO) - INEP: 242624
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242624' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA SUL DE MINAS- CAMPUS MUZAMBINHO' 
      AND UPPER(TRIM(city)) = 'MUZAMBINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242624');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DE APLICAÇÃO DA UFV COLUNI (VIÇOSA) - INEP: 128074
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128074' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DE APLICAÇÃO DA UFV COLUNI' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128074');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DO SUL DE MINAS GERAIS-CAMPUS POUSO ALEGRE (POUSO ALEGRE) - INEP: 355291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355291' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DO SUL DE MINAS GERAIS-CAMPUS POUSO ALEGRE' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS CAMPUS SÃO JOÃO DEL RE (SÃO JOÃO DEL REI) - INEP: 348031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348031' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS CAMPUS SÃO JOÃO DEL RE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS - CAMPUS RIO POMBA (RIO POMBA) - INEP: 180696
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180696' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS - CAMPUS RIO POMBA' 
      AND UPPER(TRIM(city)) = 'RIO POMBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180696');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFET DE ARAXÁ (ARAXÁ) - INEP: 237736
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237736' 
    WHERE UPPER(TRIM(name)) = 'CEFET DE ARAXÁ' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237736');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFORES CENTRO FORMAÇÃO ESPECIAL EM SAÚDE (UBERABA) - INEP: 308251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '308251' 
    WHERE UPPER(TRIM(name)) = 'CEFORES CENTRO FORMAÇÃO ESPECIAL EM SAÚDE' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '308251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DO TRIANGULO MINEIRO - CAMPUS UBERABA (UBERABA) - INEP: 158151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158151' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DO TRIANGULO MINEIRO - CAMPUS UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE EDUCAÇÃO BÁSICA DA UFU (UBERLÂNDIA) - INEP: 166545
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166545' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE EDUCAÇÃO BÁSICA DA UFU' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166545');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE SAÚDE DA UNIVERSIDADE FEDERAL UBERLÂNDIA (UBERLÂNDIA) - INEP: 166561
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166561' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE SAÚDE DA UNIVERSIDADE FEDERAL UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166561');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO TECNOLOGICA DO TRIANGULO MINEIRO CAMPUS UBERLANDIA (UBERLÂNDIA) - INEP: 166553
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166553' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO TECNOLOGICA DO TRIANGULO MINEIRO CAMPUS UBERLANDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166553');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUC CIÊNCIAS E TEC DO NORTE DE MINAS GERAIS - CAMPUS ARINOS (ARINOS) - INEP: 345440
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345440' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUC CIÊNCIAS E TEC DO NORTE DE MINAS GERAIS - CAMPUS ARINOS' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345440');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUL DE MINAS GERAIS - CAMPUS MACHADO (MACHADO) - INEP: 170674
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170674' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUL DE MINAS GERAIS - CAMPUS MACHADO' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170674');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFET DE NEPOMUCENO (NEPOMUCENO) - INEP: 334260
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334260' 
    WHERE UPPER(TRIM(name)) = 'CEFET DE NEPOMUCENO' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334260');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS-CAMPUS VARGINHA (VARGINHA) - INEP: 334073
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334073' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DE MINAS GERAIS-CAMPUS VARGINHA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334073');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BOA SORTE (ALMENARA) - INEP: 185833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185833' 
    WHERE UPPER(TRIM(name)) = 'EM BOA SORTE' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORINA FERRAZ DE BRITO (ALMENARA) - INEP: 274330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274330' 
    WHERE UPPER(TRIM(name)) = 'EM CORINA FERRAZ DE BRITO' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MANOEL DA SILVA (ALMENARA) - INEP: 209651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '209651' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MANOEL DA SILVA' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '209651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA MORAES (ALMENARA) - INEP: 185841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185841' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA MORAES' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOSÉ DO PRATA (ALMENARA) - INEP: 272752
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272752' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOSÉ DO PRATA' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272752');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAQUEL ALVES PORTO (BANDEIRA) - INEP: 186872
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '186872' 
    WHERE UPPER(TRIM(name)) = 'EM RAQUEL ALVES PORTO' 
      AND UPPER(TRIM(city)) = 'BANDEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '186872');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CASTELO BRANCO (CACHOEIRA DE PAJEÚ) - INEP: 186473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '186473' 
    WHERE UPPER(TRIM(name)) = 'EM CASTELO BRANCO' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DE PAJEÚ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '186473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSIAS SANTOS (DIVISA ALEGRE) - INEP: 340340
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340340' 
    WHERE UPPER(TRIM(name)) = 'EM JOSIAS SANTOS' 
      AND UPPER(TRIM(city)) = 'DIVISA ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340340');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LEOLINO CHAPADEIRO (FELISBURGO) - INEP: 187496
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '187496' 
    WHERE UPPER(TRIM(name)) = 'EM LEOLINO CHAPADEIRO' 
      AND UPPER(TRIM(city)) = 'FELISBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '187496');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EMANUEL SOARES DE O CAMPOS (JACINTO) - INEP: 184781
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184781' 
    WHERE UPPER(TRIM(name)) = 'EM EMANUEL SOARES DE O CAMPOS' 
      AND UPPER(TRIM(city)) = 'JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184781');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA DA CONCEIÇÃO (JACINTO) - INEP: 187640
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '187640' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA DA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '187640');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MINISTRO CLÓVIS SALGADO (JEQUITINHONHA) - INEP: 187895
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '187895' 
    WHERE UPPER(TRIM(name)) = 'EM MINISTRO CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '187895');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MUNICIPAL CRAÚNO (JEQUITINHONHA) - INEP: 370304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370304' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MUNICIPAL CRAÚNO' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR ANTÔNIO GERÔNIMO OLIVEIRA (JOAÍMA) - INEP: 246298
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246298' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR ANTÔNIO GERÔNIMO OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246298');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIANOS (JOAÍMA) - INEP: 188174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '188174' 
    WHERE UPPER(TRIM(name)) = 'EM MARIANOS' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '188174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOSÉ (JOAÍMA) - INEP: 325040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325040' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RIBEIRA DO CAPIM ASSÚ (JORDÂNIA) - INEP: 246841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246841' 
    WHERE UPPER(TRIM(name)) = 'EM RIBEIRA DO CAPIM ASSÚ' 
      AND UPPER(TRIM(city)) = 'JORDÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROBERTO MARTINS MAGNO (MATA VERDE) - INEP: 270521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270521' 
    WHERE UPPER(TRIM(name)) = 'EM ROBERTO MARTINS MAGNO' 
      AND UPPER(TRIM(city)) = 'MATA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OURO VERDE (PALMÓPOLIS) - INEP: 337730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '337730' 
    WHERE UPPER(TRIM(name)) = 'EM OURO VERDE' 
      AND UPPER(TRIM(city)) = 'PALMÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '337730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TERTULIANA PARAGUASSU (PEDRA AZUL) - INEP: 189243
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '189243' 
    WHERE UPPER(TRIM(name)) = 'EM TERTULIANA PARAGUASSU' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '189243');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VIRGOLINO LENCY (RIO DO PRADO) - INEP: 185299
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185299' 
    WHERE UPPER(TRIM(name)) = 'EM VIRGOLINO LENCY' 
      AND UPPER(TRIM(city)) = 'RIO DO PRADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185299');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL MELVINO FERRAZ (RUBIM) - INEP: 185370
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185370' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL MELVINO FERRAZ' 
      AND UPPER(TRIM(city)) = 'RUBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185370');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARECHAL CASTELO BRANCO (SANTA MARIA DO SALTO) - INEP: 190209
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190209' 
    WHERE UPPER(TRIM(name)) = 'EM MARECHAL CASTELO BRANCO' 
      AND UPPER(TRIM(city)) = 'SANTA MARIA DO SALTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190209');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IRMÃ MARIA GEMA (ARAÇUAÍ) - INEP: 149217
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '149217' 
    WHERE UPPER(TRIM(name)) = 'EM IRMÃ MARIA GEMA' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '149217');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM VIANA GONÇALVES (ARAÇUAÍ) - INEP: 149349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '149349' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM VIANA GONÇALVES' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '149349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ GONÇALVES SOARES (ARAÇUAÍ) - INEP: 149501
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '149501' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ GONÇALVES SOARES' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '149501');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLINTO RAMALHO (ARAÇUAÍ) - INEP: 149403
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '149403' 
    WHERE UPPER(TRIM(name)) = 'EM OLINTO RAMALHO' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '149403');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO VICENTE (ARAÇUAÍ) - INEP: 149187
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '149187' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO VICENTE' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '149187');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANFRÍSIO JOSÉ DA ROCHA (COMERCINHO) - INEP: 344010
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344010' 
    WHERE UPPER(TRIM(name)) = 'EM ANFRÍSIO JOSÉ DA ROCHA' 
      AND UPPER(TRIM(city)) = 'COMERCINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344010');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL COSTA BARRETO (CORONEL MURTA) - INEP: 151289
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '151289' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL COSTA BARRETO' 
      AND UPPER(TRIM(city)) = 'CORONEL MURTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '151289');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA CECÍLIA DOS SANTOS (CORONEL MURTA) - INEP: 151301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '151301' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA CECÍLIA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'CORONEL MURTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '151301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROSSANA FERREIRA MURTA (CORONEL MURTA) - INEP: 314421
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314421' 
    WHERE UPPER(TRIM(name)) = 'EM ROSSANA FERREIRA MURTA' 
      AND UPPER(TRIM(city)) = 'CORONEL MURTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314421');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO SÃO JOÃO (ITAOBIM) - INEP: 146943
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146943' 
    WHERE UPPER(TRIM(name)) = 'EM DO SÃO JOÃO' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146943');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLYNTHO RODRIGUES CARDOSO (ITAOBIM) - INEP: 146935
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146935' 
    WHERE UPPER(TRIM(name)) = 'EM OLYNTHO RODRIGUES CARDOSO' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146935');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARCEMIRO OLIVEIRA CHAVES (ITINGA) - INEP: 153184
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '153184' 
    WHERE UPPER(TRIM(name)) = 'EM ARCEMIRO OLIVEIRA CHAVES' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '153184');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARMÍNIO INÁCIO (ITINGA) - INEP: 153222
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '153222' 
    WHERE UPPER(TRIM(name)) = 'EM ARMÍNIO INÁCIO' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '153222');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DA FAZENDA SANTA MARIA (ITINGA) - INEP: 146960
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146960' 
    WHERE UPPER(TRIM(name)) = 'EM DA FAZENDA SANTA MARIA' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146960');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE JOSÉ DE ANCHIETA (ITINGA) - INEP: 146994
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146994' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE JOSÉ DE ANCHIETA' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146994');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TOMÉ DE SOUZA (ITINGA) - INEP: 153338
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '153338' 
    WHERE UPPER(TRIM(name)) = 'EM TOMÉ DE SOUZA' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '153338');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO NARCISO DE OLIVEIRA (ANDRELÂNDIA) - INEP: 258717
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258717' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO NARCISO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'ANDRELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258717');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALBERTO CÔRREA (BARBACENA) - INEP: 212474
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212474' 
    WHERE UPPER(TRIM(name)) = 'EM ALBERTO CÔRREA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212474');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM INÊS PIACESI (BARBACENA) - INEP: 212482
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212482' 
    WHERE UPPER(TRIM(name)) = 'EM INÊS PIACESI' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212482');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ BENEDITO CAMPARA (BARBACENA) - INEP: 236560
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236560' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ BENEDITO CAMPARA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236560');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA YAYÁ MOREIRA (BARBACENA) - INEP: 299073
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299073' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA YAYÁ MOREIRA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299073');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO FRANCISCO DO VALLE (BARBACENA) - INEP: 212491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212491' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO FRANCISCO DO VALLE' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TONY MARCOS DE ANDRADE (BARBACENA) - INEP: 306134
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306134' 
    WHERE UPPER(TRIM(name)) = 'EM TONY MARCOS DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306134');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA TITA TAFURI (DESTERRO DO MELO) - INEP: 268895
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268895' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA TITA TAFURI' 
      AND UPPER(TRIM(city)) = 'DESTERRO DO MELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268895');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TEÓFILO FERREIRA DE PAIVA (PAIVA) - INEP: 271586
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271586' 
    WHERE UPPER(TRIM(name)) = 'EM TEÓFILO FERREIRA DE PAIVA' 
      AND UPPER(TRIM(city)) = 'PAIVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271586');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO FRANCISCO DA SILVA (SANTA BÁRBARA DO TUGÚRIO) - INEP: 269034
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269034' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO FRANCISCO DA SILVA' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA DO TUGÚRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269034');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EUNICE SILVA MOREIRA (SANTANA DO GARAMBÉU) - INEP: 270938
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270938' 
    WHERE UPPER(TRIM(name)) = 'EM EUNICE SILVA MOREIRA' 
      AND UPPER(TRIM(city)) = 'SANTANA DO GARAMBÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270938');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE JUSTINO OBERS (AGUANIL) - INEP: 271306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271306' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE JUSTINO OBERS' 
      AND UPPER(TRIM(city)) = 'AGUANIL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO DE ASSIS CAMPOS (CRISTAIS) - INEP: 202533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202533' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO DE ASSIS CAMPOS' 
      AND UPPER(TRIM(city)) = 'CRISTAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO ARISTEU MAIA (CRISTAIS) - INEP: 204196
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '204196' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO ARISTEU MAIA' 
      AND UPPER(TRIM(city)) = 'CRISTAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '204196');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  EM ITÁLIA CAUTIERO FRANCO - CAIC (LAVRAS) - INEP: 244279
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244279' 
    WHERE UPPER(TRIM(name)) = 'EM ITÁLIA CAUTIERO FRANCO - CAIC' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244279');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ÁLVARO BOTELHO (LAVRAS) - INEP: 202878
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202878' 
    WHERE UPPER(TRIM(name)) = 'EM ÁLVARO BOTELHO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202878');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTORA DAMINA (LAVRAS) - INEP: 202983
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202983' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTORA DAMINA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202983');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ÉDIO DO NASCIMENTO BIRINDIBA (LAVRAS) - INEP: 202932
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202932' 
    WHERE UPPER(TRIM(name)) = 'EM ÉDIO DO NASCIMENTO BIRINDIBA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202932');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO SALES (LAVRAS) - INEP: 203017
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203017' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO SALES' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203017');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ SERAFIM (LAVRAS) - INEP: 251933
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251933' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ SERAFIM' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251933');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LAFAIETE PEREIRA (LAVRAS) - INEP: 204536
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '204536' 
    WHERE UPPER(TRIM(name)) = 'EM LAFAIETE PEREIRA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '204536');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO MENICUCCI (LAVRAS) - INEP: 203092
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203092' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO MENICUCCI' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203092');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR JOSÉ LUIZ DE MESQUITA (LAVRAS) - INEP: 217751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217751' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR JOSÉ LUIZ DE MESQUITA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR PAULO DE SOUZA (LAVRAS) - INEP: 204552
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '204552' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR PAULO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '204552');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO VICENTE FERREIRA (LAVRAS) - INEP: 274119
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274119' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO VICENTE FERREIRA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274119');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM UMBELINA AZEVEDO AVELLAR (LAVRAS) - INEP: 316245
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316245' 
    WHERE UPPER(TRIM(name)) = 'EM UMBELINA AZEVEDO AVELLAR' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316245');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VICENTINA DE ABREU SILVA (LAVRAS) - INEP: 202916
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202916' 
    WHERE UPPER(TRIM(name)) = 'EM VICENTINA DE ABREU SILVA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202916');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OTAVIANO ALVARENGA (PERDÕES) - INEP: 203459
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203459' 
    WHERE UPPER(TRIM(name)) = 'EM OTAVIANO ALVARENGA' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203459');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ CÂNDIDO FERREIRA (SANTO ANTÔNIO DO AMPARO) - INEP: 136158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136158' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ CÂNDIDO FERREIRA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIQUITA BEZE (SÃO FRANCISCO DE PAULA) - INEP: 209996
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '209996' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIQUITA BEZE' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO DE PAULA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '209996');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ NORONHA MACHADO (ESPERA FELIZ) - INEP: 100480
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '100480' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ NORONHA MACHADO' 
      AND UPPER(TRIM(city)) = 'ESPERA FELIZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '100480');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR XENOFONTE MERCADANTE (ORIZÂNIA) - INEP: 100382
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '100382' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR XENOFONTE MERCADANTE' 
      AND UPPER(TRIM(city)) = 'ORIZÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '100382');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA SEBASTIANA RITA THEODORO (CARATINGA) - INEP: 347566
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347566' 
    WHERE UPPER(TRIM(name)) = 'EM DONA SEBASTIANA RITA THEODORO' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347566');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDO MARQUES CEVIDANES (CARATINGA) - INEP: 219665
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219665' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDO MARQUES CEVIDANES' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219665');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ILHA DA FANTASIA (CARATINGA) - INEP: 370142
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370142' 
    WHERE UPPER(TRIM(name)) = 'EM ILHA DA FANTASIA' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370142');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA APARECIDA DE OLIVEIRA (CARATINGA) - INEP: 347540
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347540' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA APARECIDA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347540');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NAYTIARA FRANCO CASSIANO DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (CARATINGA) - INEP: 233625
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233625' 
    WHERE UPPER(TRIM(name)) = 'EM NAYTIARA FRANCO CASSIANO DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233625');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRINA ALEXANDRE DO NASCIMENTO (CARATINGA) - INEP: 347558
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347558' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRINA ALEXANDRE DO NASCIMENTO' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347558');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IMACULADA CONCEIÇÃO (IPANEMA) - INEP: 374504
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374504' 
    WHERE UPPER(TRIM(name)) = 'EM IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'IPANEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374504');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA SIQUEIRA FONSECA (IPANEMA) - INEP: 272124
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272124' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA SIQUEIRA FONSECA' 
      AND UPPER(TRIM(city)) = 'IPANEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272124');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARLON DOS REIS LOPES (SANTA BÁRBARA DO LESTE) - INEP: 261408
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261408' 
    WHERE UPPER(TRIM(name)) = 'EM MARLON DOS REIS LOPES' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA DO LESTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261408');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MAURO JACINTO DE FREITAS (SÃO SEBASTIÃO DO ANTA) - INEP: 274607
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274607' 
    WHERE UPPER(TRIM(name)) = 'EM MAURO JACINTO DE FREITAS' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO ANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274607');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM DE ABREU (TAPARUBA) - INEP: 270156
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270156' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM DE ABREU' 
      AND UPPER(TRIM(city)) = 'TAPARUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270156');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA DO SAGRADO CORAÇÃO (AIURUOCA) - INEP: 175251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175251' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA DO SAGRADO CORAÇÃO' 
      AND UPPER(TRIM(city)) = 'AIURUOCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL PORFÍRIO MENDES PINTO (ALAGOA) - INEP: 170721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170721' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL PORFÍRIO MENDES PINTO' 
      AND UPPER(TRIM(city)) = 'ALAGOA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170721');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SENADOR ALFREDO CATÃO (BAEPENDI) - INEP: 171034
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171034' 
    WHERE UPPER(TRIM(name)) = 'EM SENADOR ALFREDO CATÃO' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171034');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA BENVINDA IMACULADA CONCEIÇÃO (CRUZÍLIA) - INEP: 172430
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172430' 
    WHERE UPPER(TRIM(name)) = 'EM DONA BENVINDA IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'CRUZÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172430');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE DOUTOR JOÃO SCOTTI (ITAMONTE) - INEP: 172855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172855' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE DOUTOR JOÃO SCOTTI' 
      AND UPPER(TRIM(city)) = 'ITAMONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VIRGÍLIO ALVES PEREIRA (OLÍMPIO NORONHA) - INEP: 268828
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268828' 
    WHERE UPPER(TRIM(name)) = 'EM VIRGÍLIO ALVES PEREIRA' 
      AND UPPER(TRIM(city)) = 'OLÍMPIO NORONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268828');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ DE ANCHIETA (PASSA-VINTE) - INEP: 269123
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269123' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ DE ANCHIETA' 
      AND UPPER(TRIM(city)) = 'PASSA-VINTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269123');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR EMÍLIO ABDON PÓVOA (SÃO LOURENÇO) - INEP: 242144
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242144' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR EMÍLIO ABDON PÓVOA' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242144');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL MONTEIRO (SÃO LOURENÇO) - INEP: 179078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179078' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL MONTEIRO' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE FRANCISCO FREITAS CARVALHO (SÃO SEBASTIÃO DO RIO VERDE) - INEP: 174211
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174211' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE FRANCISCO FREITAS CARVALHO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO RIO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174211');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARY VIEIRA RIBEIRO SOUZA (SERITINGA) - INEP: 271934
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271934' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARY VIEIRA RIBEIRO SOUZA' 
      AND UPPER(TRIM(city)) = 'SERITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271934');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RIBEIRO PENA (SERRANOS) - INEP: 174301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174301' 
    WHERE UPPER(TRIM(name)) = 'EM RIBEIRO PENA' 
      AND UPPER(TRIM(city)) = 'SERRANOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÍLVIA NUNES (CASA GRANDE) - INEP: 272043
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272043' 
    WHERE UPPER(TRIM(name)) = 'EM SÍLVIA NUNES' 
      AND UPPER(TRIM(city)) = 'CASA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272043');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM JOÃO MUNIZ (CONGONHAS) - INEP: 217107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217107' 
    WHERE UPPER(TRIM(name)) = 'EM DOM JOÃO MUNIZ' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217107');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA CAETANA PEREIRA TRINDADE (CONGONHAS) - INEP: 321036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321036' 
    WHERE UPPER(TRIM(name)) = 'EM DONA CAETANA PEREIRA TRINDADE' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FORTUNATA DE FREITAS JUNQUEIRA (CONGONHAS) - INEP: 244261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244261' 
    WHERE UPPER(TRIM(name)) = 'EM FORTUNATA DE FREITAS JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JAIR ELIAS (CONGONHAS) - INEP: 327760
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327760' 
    WHERE UPPER(TRIM(name)) = 'EM JAIR ELIAS' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327760');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO NARCISO (CONGONHAS) - INEP: 193402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193402' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO NARCISO' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MONTEIRO DE CASTRO (CONGONHAS) - INEP: 249360
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249360' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MONTEIRO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249360');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JUDITH AUGUSTA FERREIRA (CONGONHAS) - INEP: 193445
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193445' 
    WHERE UPPER(TRIM(name)) = 'EM JUDITH AUGUSTA FERREIRA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193445');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MICHAEL PEREIRA DE SOUZA (CONGONHAS) - INEP: 320994
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320994' 
    WHERE UPPER(TRIM(name)) = 'EM MICHAEL PEREIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320994');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROSÁLIA ANDRADE DA GLÓRIA (CONGONHAS) - INEP: 216879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '216879' 
    WHERE UPPER(TRIM(name)) = 'EM ROSÁLIA ANDRADE DA GLÓRIA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '216879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SENHOR ODORICO MARTINHO DA SILVA (CONGONHAS) - INEP: 194590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194590' 
    WHERE UPPER(TRIM(name)) = 'EM SENHOR ODORICO MARTINHO DA SILVA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194590');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM DR RUI PENA (CONSELHEIRO LAFAIETE) - INEP: 266493
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266493' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM DR RUI PENA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266493');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARNALDO RODRIGUES PEREIRA (CONSELHEIRO LAFAIETE) - INEP: 194689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194689' 
    WHERE UPPER(TRIM(name)) = 'EM ARNALDO RODRIGUES PEREIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JAIR NORONHA (CONSELHEIRO LAFAIETE) - INEP: 194727
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194727' 
    WHERE UPPER(TRIM(name)) = 'EM JAIR NORONHA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194727');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARINHO FERNANDES (CONSELHEIRO LAFAIETE) - INEP: 312762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312762' 
    WHERE UPPER(TRIM(name)) = 'EM MARINHO FERNANDES' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MERIDIONAL (CONSELHEIRO LAFAIETE) - INEP: 196207
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196207' 
    WHERE UPPER(TRIM(name)) = 'EM MERIDIONAL' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196207');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NAPOLEÃO REIS (CONSELHEIRO LAFAIETE) - INEP: 196215
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196215' 
    WHERE UPPER(TRIM(name)) = 'EM NAPOLEÃO REIS' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196215');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR DORIOL BEATO (CONSELHEIRO LAFAIETE) - INEP: 221562
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '221562' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR DORIOL BEATO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '221562');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR LUÍS CARLOS GOMES BEATO (CONSELHEIRO LAFAIETE) - INEP: 266485
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266485' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR LUÍS CARLOS GOMES BEATO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266485');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA NILCE RAMOS MOREIRA (CONSELHEIRO LAFAIETE) - INEP: 245682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245682' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA NILCE RAMOS MOREIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR JOSÉ ALEIXO DE MATOS (CONSELHEIRO LAFAIETE) - INEP: 319457
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319457' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR JOSÉ ALEIXO DE MATOS' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319457');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONSENHOR RAUL COUTINHO (CRISTIANO OTONI) - INEP: 193810
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193810' 
    WHERE UPPER(TRIM(name)) = 'EM MONSENHOR RAUL COUTINHO' 
      AND UPPER(TRIM(city)) = 'CRISTIANO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193810');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZULEIKA HALFED DE ALBUQUERQUE (JECEABA) - INEP: 268933
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268933' 
    WHERE UPPER(TRIM(name)) = 'EM ZULEIKA HALFED DE ALBUQUERQUE' 
      AND UPPER(TRIM(city)) = 'JECEABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268933');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL JOÃO XXIII (OURO BRANCO) - INEP: 194140
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194140' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL JOÃO XXIII' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194140');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL PIO XII (OURO BRANCO) - INEP: 196321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196321' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL PIO XII' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LIVREMENTE (OURO BRANCO) - INEP: 216925
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '216925' 
    WHERE UPPER(TRIM(name)) = 'EM LIVREMENTE' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '216925');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA DO CARMO (OURO BRANCO) - INEP: 195529
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '195529' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '195529');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSWALDO CRUZ (OURO BRANCO) - INEP: 195545
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '195545' 
    WHERE UPPER(TRIM(name)) = 'EM OSWALDO CRUZ' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '195545');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAIMUNDO CAMPOS (OURO BRANCO) - INEP: 195570
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '195570' 
    WHERE UPPER(TRIM(name)) = 'EM RAIMUNDO CAMPOS' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '195570');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANÍSIO PINTO (SANTANA DOS MONTES) - INEP: 194417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194417' 
    WHERE UPPER(TRIM(name)) = 'EM ANÍSIO PINTO' 
      AND UPPER(TRIM(city)) = 'SANTANA DOS MONTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE ARMANDO CESÁRIO (SANTANA DOS MONTES) - INEP: 331333
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331333' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE ARMANDO CESÁRIO' 
      AND UPPER(TRIM(city)) = 'SANTANA DOS MONTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331333');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AMÉLIA D'ANUNCIAÇÃO PYRAMO (SÃO BRÁS DO SUAÇUÍ) - INEP: 216950
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '216950' 
    WHERE UPPER(TRIM(name)) = 'EM AMÉLIA D''ANUNCIAÇÃO PYRAMO' 
      AND UPPER(TRIM(city)) = 'SÃO BRÁS DO SUAÇUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '216950');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO FIRMINO (BELO ORIENTE) - INEP: 191868
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191868' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO FIRMINO' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191868');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BOM JESUS DO BAGRE (BELO ORIENTE) - INEP: 190730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190730' 
    WHERE UPPER(TRIM(name)) = 'EM BOM JESUS DO BAGRE' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE ESPERANÇA (BELO ORIENTE) - INEP: 191892
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191892' 
    WHERE UPPER(TRIM(name)) = 'EM DE ESPERANÇA' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191892');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO GONÇALVES BRITTO (BELO ORIENTE) - INEP: 191922
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191922' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO GONÇALVES BRITTO' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191922');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HILDA MORAIS (BELO ORIENTE) - INEP: 271187
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271187' 
    WHERE UPPER(TRIM(name)) = 'EM HILDA MORAIS' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271187');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARTUR DA COSTA E SILVA (BRAÚNAS) - INEP: 192007
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192007' 
    WHERE UPPER(TRIM(name)) = 'EM ARTUR DA COSTA E SILVA' 
      AND UPPER(TRIM(city)) = 'BRAÚNAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192007');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARGEU BRANDÃO (CORONEL FABRICIANO) - INEP: 192139
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192139' 
    WHERE UPPER(TRIM(name)) = 'EM ARGEU BRANDÃO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192139');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BOA VISTA (CORONEL FABRICIANO) - INEP: 358975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358975' 
    WHERE UPPER(TRIM(name)) = 'EM BOA VISTA' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DA CONCEIÇÃO ATAÍDE (CORONEL FABRICIANO) - INEP: 192147
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192147' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DA CONCEIÇÃO ATAÍDE' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192147');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DAS GRAÇAS FERREIRA (CORONEL FABRICIANO) - INEP: 249319
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249319' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DAS GRAÇAS FERREIRA' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249319');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VER  PAULO FRANKLIN (CORONEL FABRICIANO) - INEP: 192180
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192180' 
    WHERE UPPER(TRIM(name)) = 'EM VER PAULO FRANKLIN' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192180');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR NICANOR ATAÍDE (CORONEL FABRICIANO) - INEP: 192171
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192171' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR NICANOR ATAÍDE' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192171');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALTINA OLÍVIA GONÇALVES (IPATINGA) - INEP: 192252
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192252' 
    WHERE UPPER(TRIM(name)) = 'EM ALTINA OLÍVIA GONÇALVES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192252');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARTUR BERNARDES (IPATINGA) - INEP: 192317
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192317' 
    WHERE UPPER(TRIM(name)) = 'EM ARTUR BERNARDES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192317');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS DRUMOND DE ANDRADE (IPATINGA) - INEP: 250805
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250805' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS DRUMOND DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250805');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CHIRLENE CRISTINA PEREIRA (IPATINGA) - INEP: 229636
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229636' 
    WHERE UPPER(TRIM(name)) = 'EM CHIRLENE CRISTINA PEREIRA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229636');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DEOLINDA TAVARES LAMEGO (IPATINGA) - INEP: 192392
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192392' 
    WHERE UPPER(TRIM(name)) = 'EM DEOLINDA TAVARES LAMEGO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192392');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EVERSON MAGALHÃES LAGE (IPATINGA) - INEP: 231355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231355' 
    WHERE UPPER(TRIM(name)) = 'EM EVERSON MAGALHÃES LAGE' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HENRIQUE FREITAS BADARÓ (IPATINGA) - INEP: 229644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229644' 
    WHERE UPPER(TRIM(name)) = 'EM HENRIQUE FREITAS BADARÓ' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO REIS DE SOUZA (IPATINGA) - INEP: 231401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231401' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO REIS DE SOUZA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LEVINDO MARIANO (IPATINGA) - INEP: 192295
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192295' 
    WHERE UPPER(TRIM(name)) = 'EM LEVINDO MARIANO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192295');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MÁRCIO ANDRADE GUERRA (IPATINGA) - INEP: 192325
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192325' 
    WHERE UPPER(TRIM(name)) = 'EM MÁRCIO ANDRADE GUERRA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192325');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NELCINA ROSA DE JESUS (IPATINGA) - INEP: 192384
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192384' 
    WHERE UPPER(TRIM(name)) = 'EM NELCINA ROSA DE JESUS' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192384');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE BERTOLLO (IPATINGA) - INEP: 191230
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191230' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE BERTOLLO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191230');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE CÍCERO DE CASTRO (IPATINGA) - INEP: 192406
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192406' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE CÍCERO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192406');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO FREIRE (IPATINGA) - INEP: 295299
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295299' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295299');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR EVALDO FONTES (IPATINGA) - INEP: 192457
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192457' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR EVALDO FONTES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192457');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA CONCEIÇÃO PENA ROCHA (IPATINGA) - INEP: 192333
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192333' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA CONCEIÇÃO PENA ROCHA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192333');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TEREZINHA NIVIA DE OLIVEIRA LOPES (IPATINGA) - INEP: 332445
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332445' 
    WHERE UPPER(TRIM(name)) = 'EM TEREZINHA NIVIA DE OLIVEIRA LOPES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332445');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VILMA DE FARIA SILVA (IPATINGA) - INEP: 249301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249301' 
    WHERE UPPER(TRIM(name)) = 'EM VILMA DE FARIA SILVA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZÉLIA DUARTE PASSOS (IPATINGA) - INEP: 192465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192465' 
    WHERE UPPER(TRIM(name)) = 'EM ZÉLIA DUARTE PASSOS' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL FELÍCIO MIRANDA (JAGUARAÇU) - INEP: 191311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191311' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL FELÍCIO MIRANDA' 
      AND UPPER(TRIM(city)) = 'JAGUARAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO CAMILO DA SILVA (MESQUITA) - INEP: 192848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192848' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO CAMILO DA SILVA' 
      AND UPPER(TRIM(city)) = 'MESQUITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE TIMÓTEO (TIMÓTEO) - INEP: 192911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192911' 
    WHERE UPPER(TRIM(name)) = 'EM DE TIMÓTEO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LIMOEIRO (TIMÓTEO) - INEP: 192902
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192902' 
    WHERE UPPER(TRIM(name)) = 'EM LIMOEIRO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192902');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOVO TEMPO (TIMÓTEO) - INEP: 296350
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296350' 
    WHERE UPPER(TRIM(name)) = 'EM NOVO TEMPO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296350');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA APARECIDA MARTINS PRADO (TIMÓTEO) - INEP: 254100
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254100' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA APARECIDA MARTINS PRADO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254100');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO MUNICIPAL DE EDUCAÇÃO TÉCNICA DE TIMÓTEO (TIMÓTEO) - INEP: 215376
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215376' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO MUNICIPAL DE EDUCAÇÃO TÉCNICA DE TIMÓTEO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215376');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA LAURA MARTINS (AUGUSTO DE LIMA) - INEP: 251241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251241' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA LAURA MARTINS' 
      AND UPPER(TRIM(city)) = 'AUGUSTO DE LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTONIO MALDINE (CORINTO) - INEP: 143057
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '143057' 
    WHERE UPPER(TRIM(name)) = 'EM ANTONIO MALDINE' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '143057');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CRISTO REI (CORINTO) - INEP: 145556
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145556' 
    WHERE UPPER(TRIM(name)) = 'EM CRISTO REI' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145556');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIA SOFIA (FELIXLÂNDIA) - INEP: 140929
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140929' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIA SOFIA' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140929');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRO EPIFÂNIO (FELIXLÂNDIA) - INEP: 143642
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '143642' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRO EPIFÂNIO' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '143642');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TERESA COSTA BRAVO (FELIXLÂNDIA) - INEP: 143588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '143588' 
    WHERE UPPER(TRIM(name)) = 'EM TERESA COSTA BRAVO' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '143588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA ODÍLIA COSTA (JOAQUIM FELÍCIO) - INEP: 271071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271071' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA ODÍLIA COSTA' 
      AND UPPER(TRIM(city)) = 'JOAQUIM FELÍCIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS PEREIRA MARIZ (MORRO DA GARÇA) - INEP: 144347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '144347' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS PEREIRA MARIZ' 
      AND UPPER(TRIM(city)) = 'MORRO DA GARÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '144347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PE JOAQUIM DA SILVEIRA (MORRO DA GARÇA) - INEP: 141283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141283' 
    WHERE UPPER(TRIM(name)) = 'EM PE JOAQUIM DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'MORRO DA GARÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141283');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO FONSECA LEAL (TRÊS MARIAS) - INEP: 273295
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273295' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO FONSECA LEAL' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273295');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDA MÁRCIA PEREIRA GONÇALVES (TRÊS MARIAS) - INEP: 142018
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '142018' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDA MÁRCIA PEREIRA GONÇALVES' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '142018');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MEMORIAL ZUMBI (TRÊS MARIAS) - INEP: 318400
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318400' 
    WHERE UPPER(TRIM(name)) = 'EM MEMORIAL ZUMBI' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318400');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM POLICENA ALVES DE AMORIM (TRÊS MARIAS) - INEP: 145360
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145360' 
    WHERE UPPER(TRIM(name)) = 'EM POLICENA ALVES DE AMORIM' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145360');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROSA PEDROSO DE ALMEIDA (TRÊS MARIAS) - INEP: 142000
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '142000' 
    WHERE UPPER(TRIM(name)) = 'EM ROSA PEDROSO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '142000');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR CARLINDO NASCIMENTO GAIA (TRÊS MARIAS) - INEP: 271276
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271276' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR CARLINDO NASCIMENTO GAIA' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271276');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NÚCLEO DA ESTIVA (CARBONITA) - INEP: 305405
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305405' 
    WHERE UPPER(TRIM(name)) = 'EM NÚCLEO DA ESTIVA' 
      AND UPPER(TRIM(city)) = 'CARBONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305405');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AMADOR AGUIAR (CONCEIÇÃO DO MATO DENTRO) - INEP: 356689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356689' 
    WHERE UPPER(TRIM(name)) = 'EM AMADOR AGUIAR' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO MATO DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR JOÃO ANTUNES DE OLIVEIRA (DIAMANTINA) - INEP: 236217
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236217' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR JOÃO ANTUNES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'DIAMANTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236217');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CRIANÇA FELIZ (ITAMARANDIBA) - INEP: 265837
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265837' 
    WHERE UPPER(TRIM(name)) = 'EM CRIANÇA FELIZ' 
      AND UPPER(TRIM(city)) = 'ITAMARANDIBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265837');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA GERALDA FIGUEIREDO (LEME DO PRADO) - INEP: 312681
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312681' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA GERALDA FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'LEME DO PRADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312681');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GABRIELA LEITE ARAÚJO (MINAS NOVAS) - INEP: 278157
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278157' 
    WHERE UPPER(TRIM(name)) = 'EM GABRIELA LEITE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'MINAS NOVAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278157');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO GERALDO MOREIRA DA COSTA (MONJOLOS) - INEP: 271021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271021' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO GERALDO MOREIRA DA COSTA' 
      AND UPPER(TRIM(city)) = 'MONJOLOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTO ANTÔNIO (ARCOS) - INEP: 253375
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253375' 
    WHERE UPPER(TRIM(name)) = 'EM SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253375');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VERA LÚCIA PARAÍSO (ARCOS) - INEP: 244775
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244775' 
    WHERE UPPER(TRIM(name)) = 'EM VERA LÚCIA PARAÍSO' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244775');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM YOLANDA AMORIM DE CARVALHO (ARCOS) - INEP: 226971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226971' 
    WHERE UPPER(TRIM(name)) = 'EM YOLANDA AMORIM DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'ARCOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA LYGIA VAZ DE OLIVEIRA (CARMÓPOLIS DE MINAS) - INEP: 227013
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227013' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA LYGIA VAZ DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CARMÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227013');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR WILSON VEADO (CLÁUDIO) - INEP: 256200
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256200' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR WILSON VEADO' 
      AND UPPER(TRIM(city)) = 'CLÁUDIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256200');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM PADRE JOÃO BRUNO (DIVINÓPOLIS) - INEP: 223930
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223930' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM PADRE JOÃO BRUNO' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223930');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTONIETA FONSECA (DIVINÓPOLIS) - INEP: 313653
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313653' 
    WHERE UPPER(TRIM(name)) = 'EM ANTONIETA FONSECA' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313653');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DIONÍSIO JOAQUIM RODRIGUES (DIVINÓPOLIS) - INEP: 370347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370347' 
    WHERE UPPER(TRIM(name)) = 'EM DIONÍSIO JOAQUIM RODRIGUES' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR SEBASTIÃO GOMES GUIMARÃES (DIVINÓPOLIS) - INEP: 220060
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220060' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR SEBASTIÃO GOMES GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220060');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO GONTIJO DA FONSECA (DIVINÓPOLIS) - INEP: 227102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227102' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO GONTIJO DA FONSECA' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO SEVERINO DE AZEVEDO (DIVINÓPOLIS) - INEP: 223891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223891' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO SEVERINO DE AZEVEDO' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA FONSECA PEÇANHA (DIVINÓPOLIS) - INEP: 223913
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223913' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA FONSECA PEÇANHA' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223913');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE GUARITA (DIVINÓPOLIS) - INEP: 212733
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212733' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE GUARITA' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212733');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR BAHIA (DIVINÓPOLIS) - INEP: 223921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223921' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR BAHIA' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223921');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR ODILON SANTIAGO (DIVINÓPOLIS) - INEP: 220051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220051' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR ODILON SANTIAGO' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SIDNEY JOSÉ DE OLIVEIRA (DIVINÓPOLIS) - INEP: 223905
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223905' 
    WHERE UPPER(TRIM(name)) = 'EM SIDNEY JOSÉ DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223905');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA DORICA (ITAÚNA) - INEP: 227048
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227048' 
    WHERE UPPER(TRIM(name)) = 'EM DONA DORICA' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227048');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO LEMOS TORRES (MEDEIROS) - INEP: 270377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270377' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO LEMOS TORRES' 
      AND UPPER(TRIM(city)) = 'MEDEIROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO AMARAL DE LACERDA - TÕEZINHO BENTO (NOVA SERRANA) - INEP: 378208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378208' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO AMARAL DE LACERDA - TÕEZINHO BENTO' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378208');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DIRETORA MARIA DO CARMO FONSECA (NOVA SERRANA) - INEP: 330361
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330361' 
    WHERE UPPER(TRIM(name)) = 'EM DIRETORA MARIA DO CARMO FONSECA' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330361');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIA ROSA SOARES (NOVA SERRANA) - INEP: 234737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234737' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIA ROSA SOARES' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FREI AMBRÓSIO (NOVA SERRANA) - INEP: 310921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310921' 
    WHERE UPPER(TRIM(name)) = 'EM FREI AMBRÓSIO' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310921');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDA DE ASSIS FREITAS (NOVA SERRANA) - INEP: 320021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320021' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDA DE ASSIS FREITAS' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ AMÉRICO DE LACERDA (NOVA SERRANA) - INEP: 249564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249564' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ AMÉRICO DE LACERDA' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA ALVES DE BRITO LEITE (NOVA SERRANA) - INEP: 339474
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339474' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA ALVES DE BRITO LEITE' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339474');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ELIANA FRANCISCA DE FREITAS (NOVA SERRANA) - INEP: 343765
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343765' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ELIANA FRANCISCA DE FREITAS' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343765');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM WALFRIDO SILVINO DOS MARES GUIA (OLIVEIRA) - INEP: 327174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327174' 
    WHERE UPPER(TRIM(name)) = 'EM WALFRIDO SILVINO DOS MARES GUIA' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SILAS SILVA (PEDRA DO INDAIÁ) - INEP: 271691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271691' 
    WHERE UPPER(TRIM(name)) = 'EM SILAS SILVA' 
      AND UPPER(TRIM(city)) = 'PEDRA DO INDAIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DEPUTADO JAIME MARTINS (SÃO SEBASTIÃO DO OESTE) - INEP: 271675
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271675' 
    WHERE UPPER(TRIM(name)) = 'EM DEPUTADO JAIME MARTINS' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO OESTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271675');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HENRIQUE RODRIGUES DE BARROS (AIMORÉS) - INEP: 273449
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273449' 
    WHERE UPPER(TRIM(name)) = 'EM HENRIQUE RODRIGUES DE BARROS' 
      AND UPPER(TRIM(city)) = 'AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273449');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HONÓRIO VICENTE DE OLIVEIRA (AIMORÉS) - INEP: 273431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273431' 
    WHERE UPPER(TRIM(name)) = 'EM HONÓRIO VICENTE DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALIETE RODRIGUES DO CARMO (CONSELHEIRO PENA) - INEP: 256251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256251' 
    WHERE UPPER(TRIM(name)) = 'EM ALIETE RODRIGUES DO CARMO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO PENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CHICO MENDES (GOVERNADOR VALADARES) - INEP: 319287
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319287' 
    WHERE UPPER(TRIM(name)) = 'EM CHICO MENDES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319287');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IVO TASSIS (GOVERNADOR VALADARES) - INEP: 302813
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302813' 
    WHERE UPPER(TRIM(name)) = 'EM IVO TASSIS' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302813');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OTÁCVIO SOARES FERREIRA (GOVERNADOR VALADARES) - INEP: 360082
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '360082' 
    WHERE UPPER(TRIM(name)) = 'EM OTÁCVIO SOARES FERREIRA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '360082');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM REALINA ADELINA COSTA (GOVERNADOR VALADARES) - INEP: 323616
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323616' 
    WHERE UPPER(TRIM(name)) = 'EM REALINA ADELINA COSTA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323616');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR HAMÍLTON TEODORO (GOVERNADOR VALADARES) - INEP: 227153
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227153' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR HAMÍLTON TEODORO' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227153');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR JOÃO DORNELLAS (GOVERNADOR VALADARES) - INEP: 235075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235075' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR JOÃO DORNELLAS' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235075');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF DONA LINA MARTELLI (GOVERNADOR VALADARES) - INEP: 363669
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363669' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF DONA LINA MARTELLI' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363669');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF PADRE PEDRO CRISÓLOGO ROSA (GOVERNADOR VALADARES) - INEP: 363545
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363545' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF PADRE PEDRO CRISÓLOGO ROSA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363545');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF PASTOR FABIANO ALVES (GOVERNADOR VALADARES) - INEP: 363588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363588' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF PASTOR FABIANO ALVES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF PASTOR MARTIN LUTHER KING JR (GOVERNADOR VALADARES) - INEP: 363596
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363596' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF PASTOR MARTIN LUTHER KING JR' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363596');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF PROFESSOR DAMON DE LIMA (GOVERNADOR VALADARES) - INEP: 363600
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363600' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF PROFESSOR DAMON DE LIMA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363600');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF PROFESSOR DANIEL ALVES AJUDARTE (GOVERNADOR VALADARES) - INEP: 363618
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363618' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF PROFESSOR DANIEL ALVES AJUDARTE' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363618');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF PROFESSORA VIOLETA DIAS ANDRADE (GOVERNADOR VALADARES) - INEP: 363626
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363626' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF PROFESSORA VIOLETA DIAS ANDRADE' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363626');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF WALDEMAR NADIL KRENAK (GOVERNADOR VALADARES) - INEP: 363642
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363642' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF WALDEMAR NADIL KRENAK' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363642');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EMEIEF ZUMBI DE PALMARES (GOVERNADOR VALADARES) - INEP: 363634
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363634' 
    WHERE UPPER(TRIM(name)) = 'EMEIEF ZUMBI DE PALMARES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363634');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MUNICIPAL DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL PROFESSOR VICTOR VARGAS GLÓRIA (GOVERNADOR VALADARES) - INEP: 363650
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363650' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MUNICIPAL DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL PROFESSOR VICTOR VARGAS GLÓRIA' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363650');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM WALDEMIRO BARREL (PERIQUITO) - INEP: 294063
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294063' 
    WHERE UPPER(TRIM(name)) = 'EM WALDEMIRO BARREL' 
      AND UPPER(TRIM(city)) = 'PERIQUITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294063');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLÍMPIO ALVES MACHADO (RESPLENDOR) - INEP: 273414
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273414' 
    WHERE UPPER(TRIM(name)) = 'EM OLÍMPIO ALVES MACHADO' 
      AND UPPER(TRIM(city)) = 'RESPLENDOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273414');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO ANTÔNIO RABELO LEITE (SÃO GERALDO DA PIEDADE) - INEP: 349674
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349674' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO ANTÔNIO RABELO LEITE' 
      AND UPPER(TRIM(city)) = 'SÃO GERALDO DA PIEDADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349674');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO INÁCIO DA SILVA (SÃO JOSÉ DA SAFIRA) - INEP: 316563
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316563' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO INÁCIO DA SILVA' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DA SAFIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316563');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MUNICIPAL ITELVINA FERREIRA DE SOUZA (FREI LAGONEGRO) - INEP: 269557
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269557' 
    WHERE UPPER(TRIM(name)) = 'EM MUNICIPAL ITELVINA FERREIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'FREI LAGONEGRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269557');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA OTÍLIA VITALINA DE QUEIROZ (PAULISTAS) - INEP: 263931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '263931' 
    WHERE UPPER(TRIM(name)) = 'EM DONA OTÍLIA VITALINA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'PAULISTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '263931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ PIMENTA DA SILVA (PAULISTAS) - INEP: 205389
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205389' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ PIMENTA DA SILVA' 
      AND UPPER(TRIM(city)) = 'PAULISTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205389');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÔNEGO JOSÉ COELHO (SENHORA DO PORTO) - INEP: 265977
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265977' 
    WHERE UPPER(TRIM(name)) = 'EM CÔNEGO JOSÉ COELHO' 
      AND UPPER(TRIM(city)) = 'SENHORA DO PORTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265977');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONSENHOR JOSÉ CARLOS DE FARIA (MARIA DA FÉ) - INEP: 269930
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269930' 
    WHERE UPPER(TRIM(name)) = 'EM MONSENHOR JOSÉ CARLOS DE FARIA' 
      AND UPPER(TRIM(city)) = 'MARIA DA FÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269930');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA LAÍS PERALTA CARNEIRO (MARIA DA FÉ) - INEP: 369535
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369535' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA LAÍS PERALTA CARNEIRO' 
      AND UPPER(TRIM(city)) = 'MARIA DA FÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369535');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARECHAL RONDON (CACHOEIRA DOURADA) - INEP: 196355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196355' 
    WHERE UPPER(TRIM(name)) = 'EM MARECHAL RONDON' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DOURADA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS PRATES (CENTRALINA) - INEP: 269409
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269409' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS PRATES' 
      AND UPPER(TRIM(city)) = 'CENTRALINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269409');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ OLYNTHO FERREIRA (IPIAÇU) - INEP: 197661
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '197661' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ OLYNTHO FERREIRA' 
      AND UPPER(TRIM(city)) = 'IPIAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '197661');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CIME MUNICIPAL TANCREDO PAULA ALMEIDA (ITUIUTABA) - INEP: 198269
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198269' 
    WHERE UPPER(TRIM(name)) = 'CIME MUNICIPAL TANCREDO PAULA ALMEIDA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198269');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARCHIDAMIRO PARREIRA DE SOUZA (ITUIUTABA) - INEP: 197742
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '197742' 
    WHERE UPPER(TRIM(name)) = 'EM ARCHIDAMIRO PARREIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '197742');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AURELIANO JOAQUIM DA SILVA (ITUIUTABA) - INEP: 260011
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260011' 
    WHERE UPPER(TRIM(name)) = 'EM AURELIANO JOAQUIM DA SILVA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260011');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BERNARDO JOSÉ FRANCO (ITUIUTABA) - INEP: 197971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '197971' 
    WHERE UPPER(TRIM(name)) = 'EM BERNARDO JOSÉ FRANCO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '197971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MACHADO DE ASSIS (ITUIUTABA) - INEP: 197980
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '197980' 
    WHERE UPPER(TRIM(name)) = 'EM MACHADO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '197980');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL ALVES VILELA (ITUIUTABA) - INEP: 198021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198021' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL ALVES VILELA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUIRINO DE MORAIS (ITUIUTABA) - INEP: 198161
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198161' 
    WHERE UPPER(TRIM(name)) = 'EM QUIRINO DE MORAIS' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198161');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA DAS GRAÇAS (SANTA VITÓRIA) - INEP: 198714
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198714' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198714');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOSÉ (SANTA VITÓRIA) - INEP: 196746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196746' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TANCREDO NEVES (SANTA VITÓRIA) - INEP: 198633
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198633' 
    WHERE UPPER(TRIM(name)) = 'EM TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198633');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ BARBOSA DE OLIVEIRA (CATUTI) - INEP: 315141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315141' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ BARBOSA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CATUTI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TACIANO ANTUNES DE SOUZA (GAMELEIRAS) - INEP: 316601
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316601' 
    WHERE UPPER(TRIM(name)) = 'EM TACIANO ANTUNES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'GAMELEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316601');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOVA ESPERANÇA (JAÍBA) - INEP: 248517
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248517' 
    WHERE UPPER(TRIM(name)) = 'EM NOVA ESPERANÇA' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248517');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MADRE CÂNDIDA MARIA DE JESUS (JANAÚBA) - INEP: 347418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347418' 
    WHERE UPPER(TRIM(name)) = 'EM MADRE CÂNDIDA MARIA DE JESUS' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CLEMENTE MENDES DE SOUZA (PORTEIRINHA) - INEP: 313491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313491' 
    WHERE UPPER(TRIM(name)) = 'EM CLEMENTE MENDES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'PORTEIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDMUNDO DE ALMEIDA ROCHA (RIO PARDO DE MINAS) - INEP: 218201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218201' 
    WHERE UPPER(TRIM(name)) = 'EM EDMUNDO DE ALMEIDA ROCHA' 
      AND UPPER(TRIM(city)) = 'RIO PARDO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218201');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR GUMERCINDO COSTA (RIO PARDO DE MINAS) - INEP: 218197
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218197' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR GUMERCINDO COSTA' 
      AND UPPER(TRIM(city)) = 'RIO PARDO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218197');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOAQUIM (SANTO ANTÔNIO DO RETIRO) - INEP: 259080
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259080' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOAQUIM' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO RETIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259080');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MOACIR FERNANDES CANGUSSU (SERRANÓPOLIS DE MINAS) - INEP: 317616
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317616' 
    WHERE UPPER(TRIM(name)) = 'EM MOACIR FERNANDES CANGUSSU' 
      AND UPPER(TRIM(city)) = 'SERRANÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317616');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO LUIZ DE MORAIS (VERDELÂNDIA) - INEP: 251291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251291' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO LUIZ DE MORAIS' 
      AND UPPER(TRIM(city)) = 'VERDELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ONOFRE DE OLIVEIRA NETO (VERDELÂNDIA) - INEP: 312703
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312703' 
    WHERE UPPER(TRIM(name)) = 'EM ONOFRE DE OLIVEIRA NETO' 
      AND UPPER(TRIM(city)) = 'VERDELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312703');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE SUMIDOURO (BONITO DE MINAS) - INEP: 307793
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307793' 
    WHERE UPPER(TRIM(name)) = 'EM DE SUMIDOURO' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307793');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO BORGES MONTEIRO (BONITO DE MINAS) - INEP: 207179
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '207179' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO BORGES MONTEIRO' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '207179');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DARIO CARNEIRO (CHAPADA GAÚCHA) - INEP: 248584
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248584' 
    WHERE UPPER(TRIM(name)) = 'EM DARIO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'CHAPADA GAÚCHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248584');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GETÚLIO INÁCIO DE FARIA (CHAPADA GAÚCHA) - INEP: 272841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272841' 
    WHERE UPPER(TRIM(name)) = 'EM GETÚLIO INÁCIO DE FARIA' 
      AND UPPER(TRIM(city)) = 'CHAPADA GAÚCHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTO AGOSTINHO (CHAPADA GAÚCHA) - INEP: 263206
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '263206' 
    WHERE UPPER(TRIM(name)) = 'EM SANTO AGOSTINHO' 
      AND UPPER(TRIM(city)) = 'CHAPADA GAÚCHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '263206');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BARREIRO DO BORRACHUDO (CÔNEGO MARINHO) - INEP: 294829
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294829' 
    WHERE UPPER(TRIM(name)) = 'EM BARREIRO DO BORRACHUDO' 
      AND UPPER(TRIM(city)) = 'CÔNEGO MARINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294829');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO LOPES CORREA (CÔNEGO MARINHO) - INEP: 273741
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273741' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO LOPES CORREA' 
      AND UPPER(TRIM(city)) = 'CÔNEGO MARINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273741');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOSÉ DE MACAÚBAS (CÔNEGO MARINHO) - INEP: 279447
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279447' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOSÉ DE MACAÚBAS' 
      AND UPPER(TRIM(city)) = 'CÔNEGO MARINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279447');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VACA PRETA (CÔNEGO MARINHO) - INEP: 217433
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217433' 
    WHERE UPPER(TRIM(name)) = 'EM VACA PRETA' 
      AND UPPER(TRIM(city)) = 'CÔNEGO MARINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217433');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MUNICIPAL JOSEFINA FRANCISCA DA MOTA (CÔNEGO MARINHO) - INEP: 370410
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370410' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MUNICIPAL JOSEFINA FRANCISCA DA MOTA' 
      AND UPPER(TRIM(city)) = 'CÔNEGO MARINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370410');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADÉLIA ANTÔNIA ALMEIDA SEIXAS (ITACARAMBI) - INEP: 295311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295311' 
    WHERE UPPER(TRIM(name)) = 'EM ADÉLIA ANTÔNIA ALMEIDA SEIXAS' 
      AND UPPER(TRIM(city)) = 'ITACARAMBI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARMEM MARIA ANDRADE NOGUEIRA (ITACARAMBI) - INEP: 274585
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274585' 
    WHERE UPPER(TRIM(name)) = 'EM CARMEM MARIA ANDRADE NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'ITACARAMBI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274585');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSÓRIO EVANGELISTA DOS SANTOS (ITACARAMBI) - INEP: 253723
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253723' 
    WHERE UPPER(TRIM(name)) = 'EM OSÓRIO EVANGELISTA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'ITACARAMBI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253723');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM JOANA PORTO (JANUÁRIA) - INEP: 239356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239356' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM JOANA PORTO' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE ARAÇÁ (JANUÁRIA) - INEP: 293016
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293016' 
    WHERE UPPER(TRIM(name)) = 'EM DE ARAÇÁ' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293016');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE BARREIRAS (JANUÁRIA) - INEP: 298646
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298646' 
    WHERE UPPER(TRIM(name)) = 'EM DE BARREIRAS' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298646');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE QUILOMBO (JANUÁRIA) - INEP: 298662
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298662' 
    WHERE UPPER(TRIM(name)) = 'EM DE QUILOMBO' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298662');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE SÍTIO NOVO (JANUÁRIA) - INEP: 297917
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297917' 
    WHERE UPPER(TRIM(name)) = 'EM DE SÍTIO NOVO' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297917');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUILOMBOLA GERÔNIMO BORGES DOS SANTOS (JANUÁRIA) - INEP: 355623
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355623' 
    WHERE UPPER(TRIM(name)) = 'EM QUILOMBOLA GERÔNIMO BORGES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355623');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA RITA (JANUÁRIA) - INEP: 268615
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268615' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA RITA' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268615');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VERÍSSIMO FERNANDES (JANUÁRIA) - INEP: 217409
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217409' 
    WHERE UPPER(TRIM(name)) = 'EM VERÍSSIMO FERNANDES' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217409');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PE RICARDO TRITSCHIER (MANGA) - INEP: 272370
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272370' 
    WHERE UPPER(TRIM(name)) = 'EM PE RICARDO TRITSCHIER' 
      AND UPPER(TRIM(city)) = 'MANGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272370');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE PITARANA (MONTALVÂNIA) - INEP: 371947
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371947' 
    WHERE UPPER(TRIM(name)) = 'EM DE PITARANA' 
      AND UPPER(TRIM(city)) = 'MONTALVÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371947');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ OLÍMPIO DE SOUZA (MONTALVÂNIA) - INEP: 234320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234320' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ OLÍMPIO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'MONTALVÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234320');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL FERREIRA DE FARIAS (MONTALVÂNIA) - INEP: 278840
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278840' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL FERREIRA DE FARIAS' 
      AND UPPER(TRIM(city)) = 'MONTALVÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278840');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BOM MENINO (SÃO FRANCISCO) - INEP: 207161
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '207161' 
    WHERE UPPER(TRIM(name)) = 'EM DO BOM MENINO' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '207161');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ D'ÁVILA PINTO (SÃO FRANCISCO) - INEP: 234508
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234508' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ D''ÁVILA PINTO' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234508');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO FREIRE (SÃO FRANCISCO) - INEP: 293113
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293113' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293113');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA MARTA (SÃO FRANCISCO) - INEP: 248789
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248789' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA MARTA' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248789');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JUDAS TADEU (SÃO FRANCISCO) - INEP: 318396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318396' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ELÓI FERREIRA DA SILVA (URUCUIA) - INEP: 351156
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351156' 
    WHERE UPPER(TRIM(name)) = 'EM ELÓI FERREIRA DA SILVA' 
      AND UPPER(TRIM(city)) = 'URUCUIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351156');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IRACY LOPO LISBOA (URUCUIA) - INEP: 351121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351121' 
    WHERE UPPER(TRIM(name)) = 'EM IRACY LOPO LISBOA' 
      AND UPPER(TRIM(city)) = 'URUCUIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUIZ RIBEIRO MENDES (URUCUIA) - INEP: 261611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261611' 
    WHERE UPPER(TRIM(name)) = 'EM LUIZ RIBEIRO MENDES' 
      AND UPPER(TRIM(city)) = 'URUCUIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CÍVICO MILITAR MUNICIPAL PROFESSORA ANA AMÉLIA MACEDO MONTE ALTO (URUCUIA) - INEP: 377848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377848' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CÍVICO MILITAR MUNICIPAL PROFESSORA ANA AMÉLIA MACEDO MONTE ALTO' 
      AND UPPER(TRIM(city)) = 'URUCUIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BERTOLINO FERREIRA DE QUEIROZ (VARZELÂNDIA) - INEP: 322938
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322938' 
    WHERE UPPER(TRIM(name)) = 'EM BERTOLINO FERREIRA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322938');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR DILSON DE QUADROS GODINHO (VARZELÂNDIA) - INEP: 278203
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278203' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR DILSON DE QUADROS GODINHO' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278203');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZARA DE PAULA (ARANTINA) - INEP: 273082
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273082' 
    WHERE UPPER(TRIM(name)) = 'EM ZARA DE PAULA' 
      AND UPPER(TRIM(city)) = 'ARANTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273082');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL JOAQUIM JOSÉ DE SOUZA (BICAS) - INEP: 269883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269883' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL JOAQUIM JOSÉ DE SOUZA' 
      AND UPPER(TRIM(city)) = 'BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO SEBASTIÃO (BOM JARDIM DE MINAS) - INEP: 223948
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223948' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'BOM JARDIM DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223948');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO NILTON BRETAS (CHÁCARA) - INEP: 270628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270628' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO NILTON BRETAS' 
      AND UPPER(TRIM(city)) = 'CHÁCARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO FAUSTINO DA SILVA (JUIZ DE FORA) - INEP: 235261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235261' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO FAUSTINO DA SILVA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARLETE BASTOS MAGALHÃES (JUIZ DE FORA) - INEP: 235270
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235270' 
    WHERE UPPER(TRIM(name)) = 'EM ARLETE BASTOS MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235270');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BELA AURORA (JUIZ DE FORA) - INEP: 227498
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227498' 
    WHERE UPPER(TRIM(name)) = 'EM BELA AURORA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227498');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BELMIRA DUARTE DIAS (JUIZ DE FORA) - INEP: 235288
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235288' 
    WHERE UPPER(TRIM(name)) = 'EM BELMIRA DUARTE DIAS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235288');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS DRUMOND DE ANDRADE (JUIZ DE FORA) - INEP: 218006
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218006' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS DRUMOND DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218006');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL EMÍLIO ESTEVES DOS REIS (JUIZ DE FORA) - INEP: 352110
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352110' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL EMÍLIO ESTEVES DOS REIS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352110');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE SANTA CÂNDIDA (JUIZ DE FORA) - INEP: 218014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218014' 
    WHERE UPPER(TRIM(name)) = 'EM DE SANTA CÂNDIDA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR CÁSSIO VIEIRA MARQUES (JUIZ DE FORA) - INEP: 235253
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235253' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR CÁSSIO VIEIRA MARQUES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235253');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ENGENHEIRO DOUTOR ANDRÉ REBOUÇAS (JUIZ DE FORA) - INEP: 217981
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217981' 
    WHERE UPPER(TRIM(name)) = 'EM ENGENHEIRO DOUTOR ANDRÉ REBOUÇAS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217981');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GABRIEL GONÇALVES DA SILVA (JUIZ DE FORA) - INEP: 227480
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227480' 
    WHERE UPPER(TRIM(name)) = 'EM GABRIEL GONÇALVES DA SILVA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227480');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GEORGE RODENBACH (JUIZ DE FORA) - INEP: 233099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233099' 
    WHERE UPPER(TRIM(name)) = 'EM GEORGE RODENBACH' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HENRIQUE JOSÉ DE SOUZA (JUIZ DE FORA) - INEP: 217999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217999' 
    WHERE UPPER(TRIM(name)) = 'EM HENRIQUE JOSÉ DE SOUZA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JARDIM DE ALÁ (JUIZ DE FORA) - INEP: 275204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '275204' 
    WHERE UPPER(TRIM(name)) = 'EM JARDIM DE ALÁ' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '275204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO EVANGELISTA DE ASSIS (JUIZ DE FORA) - INEP: 227501
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227501' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO EVANGELISTA DE ASSIS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227501');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOVITA MONTREUIL BRANDÃO (JUIZ DE FORA) - INEP: 362387
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362387' 
    WHERE UPPER(TRIM(name)) = 'EM JOVITA MONTREUIL BRANDÃO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362387');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA CATARINA BARBOSA (JUIZ DE FORA) - INEP: 220698
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220698' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA CATARINA BARBOSA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220698');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESORA EUNICE ALVES VIEIRA (JUIZ DE FORA) - INEP: 296406
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296406' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESORA EUNICE ALVES VIEIRA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296406');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR AUGUSTO GOTARDELO (JUIZ DE FORA) - INEP: 327352
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327352' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR AUGUSTO GOTARDELO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327352');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR HELYON DE OLIVEIRA (JUIZ DE FORA) - INEP: 260134
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260134' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR HELYON DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260134');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR OSWALDO VELLOSO (JUIZ DE FORA) - INEP: 295442
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295442' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR OSWALDO VELLOSO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295442');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ÁUREA NARDELLI (JUIZ DE FORA) - INEP: 307564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307564' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ÁUREA NARDELLI' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARLENE BARROS (JUIZ DE FORA) - INEP: 235296
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235296' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARLENE BARROS' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235296');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA NÚBIA PEREIRA DE MAGALHÃES GOMES - CAIC (JUIZ DE FORA) - INEP: 260126
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260126' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA NÚBIA PEREIRA DE MAGALHÃES GOMES - CAIC' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260126');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA THEREZA FALCI (JUIZ DE FORA) - INEP: 307556
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307556' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA THEREZA FALCI' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307556');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUILOMBO DOS PALMARES (JUIZ DE FORA) - INEP: 218031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218031' 
    WHERE UPPER(TRIM(name)) = 'EM QUILOMBO DOS PALMARES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROCHA POMBO (JUIZ DE FORA) - INEP: 267317
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267317' 
    WHERE UPPER(TRIM(name)) = 'EM ROCHA POMBO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267317');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA CECÍLIA (JUIZ DE FORA) - INEP: 227510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227510' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA CECÍLIA' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTOS DUMONT (JUIZ DE FORA) - INEP: 223972
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223972' 
    WHERE UPPER(TRIM(name)) = 'EM SANTOS DUMONT' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223972');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO GERALDO (JUIZ DE FORA) - INEP: 266434
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266434' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO GERALDO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266434');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR RAYMUNDO HARGREAVES (JUIZ DE FORA) - INEP: 218022
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218022' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR RAYMUNDO HARGREAVES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218022');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


