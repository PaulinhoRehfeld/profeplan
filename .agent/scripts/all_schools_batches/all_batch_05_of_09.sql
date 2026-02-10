-- Lote 5 de 9
-- Escolas 2001 a 2500

-- EM ELVIRA MAGDALENA MANNARINO (MAR DE ESPANHA) - INEP: 272833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272833' 
    WHERE UPPER(TRIM(name)) = 'EM ELVIRA MAGDALENA MANNARINO' 
      AND UPPER(TRIM(city)) = 'MAR DE ESPANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA AMÂNCIO (MATIAS BARBOSA) - INEP: 269042
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269042' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA AMÂNCIO' 
      AND UPPER(TRIM(city)) = 'MATIAS BARBOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269042');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUCY DE CASTRO CABRAL (MATIAS BARBOSA) - INEP: 269051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269051' 
    WHERE UPPER(TRIM(name)) = 'EM LUCY DE CASTRO CABRAL' 
      AND UPPER(TRIM(city)) = 'MATIAS BARBOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR JOSÉ ROGÉRIO MOURA ALMEIDA (RIO PRETO) - INEP: 271055
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271055' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR JOSÉ ROGÉRIO MOURA ALMEIDA' 
      AND UPPER(TRIM(city)) = 'RIO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271055');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE MACHADO (SANTA RITA DE JACUTINGA) - INEP: 269344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269344' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE MACHADO' 
      AND UPPER(TRIM(city)) = 'SANTA RITA DE JACUTINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL SANTO ANTÔNIO (SANTOS DUMONT) - INEP: 311014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311014' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'SANTOS DUMONT' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANITA SOARES DULCI (SANTOS DUMONT) - INEP: 343757
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343757' 
    WHERE UPPER(TRIM(name)) = 'EM ANITA SOARES DULCI' 
      AND UPPER(TRIM(city)) = 'SANTOS DUMONT' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343757');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR AUGUSTO GLÓRIA (SÃO JOÃO NEPOMUCENO) - INEP: 344931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344931' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR AUGUSTO GLÓRIA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TRÊS MARIAS (SÃO JOÃO NEPOMUCENO) - INEP: 267724
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267724' 
    WHERE UPPER(TRIM(name)) = 'EM TRÊS MARIAS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267724');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO IGNÁCIO PEIXOTO (CATAGUASES) - INEP: 100102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '100102' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO IGNÁCIO PEIXOTO' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '100102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LYSIS BRANDÃO DA ROCHA (CATAGUASES) - INEP: 257028
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257028' 
    WHERE UPPER(TRIM(name)) = 'EM LYSIS BRANDÃO DA ROCHA' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257028');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESC TEC MUN JOANA D'ARC (CATAGUASES) - INEP: 222003
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222003' 
    WHERE UPPER(TRIM(name)) = 'ESC TEC MUN JOANA D''ARC' 
      AND UPPER(TRIM(city)) = 'CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222003');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JUDITH LINTZ GUEDES MACHADO (LEOPOLDINA) - INEP: 268381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268381' 
    WHERE UPPER(TRIM(name)) = 'EM JUDITH LINTZ GUEDES MACHADO' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSMAR LACERDA FRANÇA (LEOPOLDINA) - INEP: 320528
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320528' 
    WHERE UPPER(TRIM(name)) = 'EM OSMAR LACERDA FRANÇA' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320528');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA DA CONCEIÇÃO MONTEIRO DE RESENDE (LEOPOLDINA) - INEP: 250821
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250821' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA DA CONCEIÇÃO MONTEIRO DE RESENDE' 
      AND UPPER(TRIM(city)) = 'LEOPOLDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250821');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNICIPAL 2000 (PIRAPETINGA) - INEP: 274780
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274780' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNICIPAL 2000' 
      AND UPPER(TRIM(city)) = 'PIRAPETINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274780');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNICIPAL DE PIRAPETINGA - CEMP COLINA DO SOL (PIRAPETINGA) - INEP: 260428
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260428' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNICIPAL DE PIRAPETINGA - CEMP COLINA DO SOL' 
      AND UPPER(TRIM(city)) = 'PIRAPETINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260428');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO DAMASCENO FERREIRA (RECREIO) - INEP: 272825
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272825' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO DAMASCENO FERREIRA' 
      AND UPPER(TRIM(city)) = 'RECREIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272825');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA NICE DAMASCENO ALMEIDA MUNIZ (RECREIO) - INEP: 275581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '275581' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA NICE DAMASCENO ALMEIDA MUNIZ' 
      AND UPPER(TRIM(city)) = 'RECREIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '275581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM N SRA DO ROSÁRIO (VOLTA GRANDE) - INEP: 315583
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315583' 
    WHERE UPPER(TRIM(name)) = 'EM N SRA DO ROSÁRIO' 
      AND UPPER(TRIM(city)) = 'VOLTA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315583');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GIDIEL CÂMARA (DURANDÉ) - INEP: 217000
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217000' 
    WHERE UPPER(TRIM(name)) = 'EM GIDIEL CÂMARA' 
      AND UPPER(TRIM(city)) = 'DURANDÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217000');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO CÉZAR HASTENREITER PORTES (LAJINHA) - INEP: 295221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295221' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO CÉZAR HASTENREITER PORTES' 
      AND UPPER(TRIM(city)) = 'LAJINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JAIR GUALBERTO DA ROCHA (MATIPÓ) - INEP: 331465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331465' 
    WHERE UPPER(TRIM(name)) = 'EM JAIR GUALBERTO DA ROCHA' 
      AND UPPER(TRIM(city)) = 'MATIPÓ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AGROPECUÁRIA MAJOLO COSTA MACHADO (SANTA MARGARIDA) - INEP: 312495
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312495' 
    WHERE UPPER(TRIM(name)) = 'EM AGROPECUÁRIA MAJOLO COSTA MACHADO' 
      AND UPPER(TRIM(city)) = 'SANTA MARGARIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312495');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA DURVALINA (SÃO JOÃO DO MANHUAÇU) - INEP: 236250
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236250' 
    WHERE UPPER(TRIM(name)) = 'EM DONA DURVALINA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DO MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236250');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROSALINA CALEGÁRIO DE SOUZA (SIMONÉSIA) - INEP: 314307
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314307' 
    WHERE UPPER(TRIM(name)) = 'EM ROSALINA CALEGÁRIO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'SIMONÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314307');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA DOS MARES GUIA (BARÃO DE COCAIS) - INEP: 267074
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267074' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA DOS MARES GUIA' 
      AND UPPER(TRIM(city)) = 'BARÃO DE COCAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267074');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANÍSIO TEIXEIRA (BELO HORIZONTE) - INEP: 250651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250651' 
    WHERE UPPER(TRIM(name)) = 'EM ANÍSIO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR JÚLIO SOARES (BELO HORIZONTE) - INEP: 346853
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346853' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR JÚLIO SOARES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346853');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FERNANDO DIAS COSTA (BELO HORIZONTE) - INEP: 217875
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217875' 
    WHERE UPPER(TRIM(name)) = 'EM FERNANDO DIAS COSTA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217875');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GOVERNADOR OZANAN COELHO (BELO HORIZONTE) - INEP: 224111
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224111' 
    WHERE UPPER(TRIM(name)) = 'EM GOVERNADOR OZANAN COELHO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224111');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HENRIQUETA LISBOA (BELO HORIZONTE) - INEP: 212768
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212768' 
    WHERE UPPER(TRIM(name)) = 'EM HENRIQUETA LISBOA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212768');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JARDIM VITÓRIA II (BELO HORIZONTE) - INEP: 362581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362581' 
    WHERE UPPER(TRIM(name)) = 'EM JARDIM VITÓRIA II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ DE CALASANZ (BELO HORIZONTE) - INEP: 305499
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305499' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ DE CALASANZ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305499');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DA ASSUNÇÃO DE MARCO (BELO HORIZONTE) - INEP: 231991
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231991' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DA ASSUNÇÃO DE MARCO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231991');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MURILO RUBIÃO (BELO HORIZONTE) - INEP: 217883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217883' 
    WHERE UPPER(TRIM(name)) = 'EM MURILO RUBIÃO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSWALDO FRANÇA JÚNIOR (BELO HORIZONTE) - INEP: 219223
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219223' 
    WHERE UPPER(TRIM(name)) = 'EM OSWALDO FRANÇA JÚNIOR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219223');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE FRANCISCO CARVALHO MOREIRA (BELO HORIZONTE) - INEP: 218618
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218618' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE FRANCISCO CARVALHO MOREIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218618');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO MENDES CAMPOS (BELO HORIZONTE) - INEP: 223689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223689' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO MENDES CAMPOS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRESIDENTE JOÃO PESSOA (BELO HORIZONTE) - INEP: 232017
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232017' 
    WHERE UPPER(TRIM(name)) = 'EM PRESIDENTE JOÃO PESSOA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232017');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR EDGAR DA MATTA MACHADO (BELO HORIZONTE) - INEP: 283002
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '283002' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR EDGAR DA MATTA MACHADO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '283002');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR EDSON PISANI (BELO HORIZONTE) - INEP: 212784
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212784' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR EDSON PISANI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212784');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR PAULO FREIRE (BELO HORIZONTE) - INEP: 305481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305481' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA MAZARELLO (BELO HORIZONTE) - INEP: 219193
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219193' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA MAZARELLO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219193');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SOBRAL PINTO (BELO HORIZONTE) - INEP: 219550
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219550' 
    WHERE UPPER(TRIM(name)) = 'EM SOBRAL PINTO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219550');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ULISSES GUIMARÃES (BELO HORIZONTE) - INEP: 231983
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231983' 
    WHERE UPPER(TRIM(name)) = 'EM ULISSES GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231983');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VILA FAZENDINHA (BELO HORIZONTE) - INEP: 330868
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330868' 
    WHERE UPPER(TRIM(name)) = 'EM VILA FAZENDINHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330868');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LIDIMANHA AUGUSTA MAIA (BRUMADINHO) - INEP: 240435
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240435' 
    WHERE UPPER(TRIM(name)) = 'EM LIDIMANHA AUGUSTA MAIA' 
      AND UPPER(TRIM(city)) = 'BRUMADINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240435');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE MACHADO (BRUMADINHO) - INEP: 361070
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361070' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE MACHADO' 
      AND UPPER(TRIM(city)) = 'BRUMADINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361070');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BENVINDA PINTO ROCHA (NOVA LIMA) - INEP: 226459
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226459' 
    WHERE UPPER(TRIM(name)) = 'EM BENVINDA PINTO ROCHA' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226459');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM ANÍBAL MACHADO (SABARÁ) - INEP: 277851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277851' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM ANÍBAL MACHADO' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277851');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADÃO DE FÁTIMA PEREIRA (SABARÁ) - INEP: 329436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329436' 
    WHERE UPPER(TRIM(name)) = 'EM ADÃO DE FÁTIMA PEREIRA' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329436');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDITH DE ASSISTÊNCIA COSTA (SABARÁ) - INEP: 294250
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294250' 
    WHERE UPPER(TRIM(name)) = 'EM EDITH DE ASSISTÊNCIA COSTA' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294250');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GABRIELA LEITE ARAÚJO (SABARÁ) - INEP: 223069
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223069' 
    WHERE UPPER(TRIM(name)) = 'EM GABRIELA LEITE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223069');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ORDÁLIA FERREIRA CAMPOS (SABARÁ) - INEP: 296635
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296635' 
    WHERE UPPER(TRIM(name)) = 'EM ORDÁLIA FERREIRA CAMPOS' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296635');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ELZA SOARES (SABARÁ) - INEP: 253154
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253154' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ELZA SOARES' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253154');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA IRENE PINTO (SABARÁ) - INEP: 226505
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226505' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA IRENE PINTO' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226505');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARITA DIAS (SABARÁ) - INEP: 323721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323721' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARITA DIAS' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323721');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR JOSÉ LOPES (SABARÁ) - INEP: 323705
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323705' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR JOSÉ LOPES' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323705');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADÉLIA HOSKEN AYRES (SANTA BÁRBARA) - INEP: 330302
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330302' 
    WHERE UPPER(TRIM(name)) = 'EM ADÉLIA HOSKEN AYRES' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330302');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IRMA AMANDINA MARIA (SANTA BÁRBARA) - INEP: 211435
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '211435' 
    WHERE UPPER(TRIM(name)) = 'EM IRMA AMANDINA MARIA' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '211435');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IVETA MOREIRA NOVAIS (SANTA BÁRBARA) - INEP: 247197
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247197' 
    WHERE UPPER(TRIM(name)) = 'EM IVETA MOREIRA NOVAIS' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247197');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARPHIZA MAGALHÃES SANTOS (SANTA BÁRBARA) - INEP: 234621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234621' 
    WHERE UPPER(TRIM(name)) = 'EM MARPHIZA MAGALHÃES SANTOS' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CIAC EM LUCAS MONTEIRO MACHADO (BELO HORIZONTE) - INEP: 244473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244473' 
    WHERE UPPER(TRIM(name)) = 'CIAC EM LUCAS MONTEIRO MACHADO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AURÉLIO BUARQUE DE HOLANDA (BELO HORIZONTE) - INEP: 217786
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217786' 
    WHERE UPPER(TRIM(name)) = 'EM AURÉLIO BUARQUE DE HOLANDA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217786');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DA VILA PINHO (BELO HORIZONTE) - INEP: 217859
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217859' 
    WHERE UPPER(TRIM(name)) = 'EM DA VILA PINHO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217859');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM BOSCO (BELO HORIZONTE) - INEP: 331589
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331589' 
    WHERE UPPER(TRIM(name)) = 'EM DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331589');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DULCE MARIA HOMEM (BELO HORIZONTE) - INEP: 212776
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212776' 
    WHERE UPPER(TRIM(name)) = 'EM DULCE MARIA HOMEM' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212776');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDITH PIMENTA DA VEIGA (BELO HORIZONTE) - INEP: 217867
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217867' 
    WHERE UPPER(TRIM(name)) = 'EM EDITH PIMENTA DA VEIGA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217867');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ELOY HERALDO LIMA (BELO HORIZONTE) - INEP: 217824
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217824' 
    WHERE UPPER(TRIM(name)) = 'EM ELOY HERALDO LIMA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217824');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IGNÁCIO DE ANDRADE MELO (BELO HORIZONTE) - INEP: 205699
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205699' 
    WHERE UPPER(TRIM(name)) = 'EM IGNÁCIO DE ANDRADE MELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205699');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUIZ GONZAGA JÚNIOR (BELO HORIZONTE) - INEP: 217832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217832' 
    WHERE UPPER(TRIM(name)) = 'EM LUIZ GONZAGA JÚNIOR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARLENE PEREIRA RANCANTE (BELO HORIZONTE) - INEP: 217794
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217794' 
    WHERE UPPER(TRIM(name)) = 'EM MARLENE PEREIRA RANCANTE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217794');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRO NAVA (BELO HORIZONTE) - INEP: 231975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231975' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRO NAVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO OSWALDO PIERUCCETTI (BELO HORIZONTE) - INEP: 219398
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219398' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO OSWALDO PIERUCCETTI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219398');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRESIDENTE ITAMAR FRANCO (BELO HORIZONTE) - INEP: 353760
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353760' 
    WHERE UPPER(TRIM(name)) = 'EM PRESIDENTE ITAMAR FRANCO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353760');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR HÍLTON ROCHA (BELO HORIZONTE) - INEP: 294659
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294659' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR HÍLTON ROCHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294659');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SOLAR RUBI (BELO HORIZONTE) - INEP: 358614
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358614' 
    WHERE UPPER(TRIM(name)) = 'EM SOLAR RUBI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358614');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM UNIÃO COMUNITÁRIA (BELO HORIZONTE) - INEP: 273252
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273252' 
    WHERE UPPER(TRIM(name)) = 'EM UNIÃO COMUNITÁRIA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273252');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VINÍCIUS DE MORAIS (BELO HORIZONTE) - INEP: 217841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217841' 
    WHERE UPPER(TRIM(name)) = 'EM VINÍCIUS DE MORAIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MUNICIPAL POLO DE EDUCAÇÃO INTEGRADA (BELO HORIZONTE) - INEP: 369446
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369446' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MUNICIPAL POLO DE EDUCAÇÃO INTEGRADA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369446');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM ISRAEL JOSÉ CARLOS (BETIM) - INEP: 251356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251356' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM ISRAEL JOSÉ CARLOS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ABÍLIO GOMES DA COSTA (BETIM) - INEP: 240702
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240702' 
    WHERE UPPER(TRIM(name)) = 'EM ABÍLIO GOMES DA COSTA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240702');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADELINA GONÇALVES CAMPOS (BETIM) - INEP: 226360
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226360' 
    WHERE UPPER(TRIM(name)) = 'EM ADELINA GONÇALVES CAMPOS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226360');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADELINA MESQUITA JANUZZI (BETIM) - INEP: 251321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251321' 
    WHERE UPPER(TRIM(name)) = 'EM ADELINA MESQUITA JANUZZI' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANA CÂNDIDA DE JESUS (BETIM) - INEP: 354244
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354244' 
    WHERE UPPER(TRIM(name)) = 'EM ANA CÂNDIDA DE JESUS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354244');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANGELA RIBEIRO BATISTA MAIA (BETIM) - INEP: 331325
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331325' 
    WHERE UPPER(TRIM(name)) = 'EM ANGELA RIBEIRO BATISTA MAIA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331325');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO TEREZA DOS SANTOS (BETIM) - INEP: 332941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332941' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO TEREZA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARISTIDES JOSÉ DA SILVA (BETIM) - INEP: 226581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226581' 
    WHERE UPPER(TRIM(name)) = 'EM ARISTIDES JOSÉ DA SILVA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARTHUR TRINDADE (BETIM) - INEP: 226351
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226351' 
    WHERE UPPER(TRIM(name)) = 'EM ARTHUR TRINDADE' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226351');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BELIZÁRIO FERREIRA CAMINHAS (BETIM) - INEP: 251313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251313' 
    WHERE UPPER(TRIM(name)) = 'EM BELIZÁRIO FERREIRA CAMINHAS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BENTO MACHADO RIBEIRO (BETIM) - INEP: 251305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251305' 
    WHERE UPPER(TRIM(name)) = 'EM BENTO MACHADO RIBEIRO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251305');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDIR TEREZINHA A FAGUNDES (BETIM) - INEP: 260991
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260991' 
    WHERE UPPER(TRIM(name)) = 'EM EDIR TEREZINHA A FAGUNDES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260991');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDMÉIA DUARTE DE OLIVEIRA BRAGA (BETIM) - INEP: 260045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260045' 
    WHERE UPPER(TRIM(name)) = 'EM EDMÉIA DUARTE DE OLIVEIRA BRAGA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDVALDO FALEIRO DE AGUIAR (BETIM) - INEP: 365262
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365262' 
    WHERE UPPER(TRIM(name)) = 'EM EDVALDO FALEIRO DE AGUIAR' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365262');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FAUSTO FIGUEIREDO OLIVEIRA (BETIM) - INEP: 240711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240711' 
    WHERE UPPER(TRIM(name)) = 'EM FAUSTO FIGUEIREDO OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FLORESTAN FERNANDES (BETIM) - INEP: 281069
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281069' 
    WHERE UPPER(TRIM(name)) = 'EM FLORESTAN FERNANDES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281069');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDO JORGE MEIRA (BETIM) - INEP: 303593
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303593' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDO JORGE MEIRA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303593');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GILBERTO ALVES DA SILVA (BETIM) - INEP: 354465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354465' 
    WHERE UPPER(TRIM(name)) = 'EM GILBERTO ALVES DA SILVA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO BATISTA MACHADO DE BRITO (BETIM) - INEP: 349585
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349585' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO BATISTA MACHADO DE BRITO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349585');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MIRANDA SOBRINHO (BETIM) - INEP: 239470
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239470' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MIRANDA SOBRINHO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239470');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ VILAÇA GUIMARÃES (BETIM) - INEP: 330914
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330914' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ VILAÇA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330914');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSEFINA MACEDO GONTIJO (BETIM) - INEP: 226602
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226602' 
    WHERE UPPER(TRIM(name)) = 'EM JOSEFINA MACEDO GONTIJO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226602');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LÚCIA FARAGE FREITAS GUMIERO (BETIM) - INEP: 250589
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250589' 
    WHERE UPPER(TRIM(name)) = 'EM LÚCIA FARAGE FREITAS GUMIERO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250589');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARGARIDA SOARES GUIMARÃES (BETIM) - INEP: 226572
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226572' 
    WHERE UPPER(TRIM(name)) = 'EM MARGARIDA SOARES GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226572');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA ARACÉLIA ALVES (BETIM) - INEP: 312410
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312410' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA ARACÉLIA ALVES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312410');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DA CONCEIÇÃO BRITO (BETIM) - INEP: 242730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242730' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DA CONCEIÇÃO BRITO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DA PENHA SANTOS ALMEIDA (BETIM) - INEP: 260029
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260029' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DA PENHA SANTOS ALMEIDA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260029');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DE LOURDES OLIVEIRA (BETIM) - INEP: 251330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251330' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DE LOURDES OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA ELENA DA CUNHA BRAZ (BETIM) - INEP: 317136
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317136' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA ELENA DA CUNHA BRAZ' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317136');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA JOSÉ CAMPOS (BETIM) - INEP: 354252
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354252' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA JOSÉ CAMPOS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354252');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MÁRIO MARCOS C TUPYNAMBÁ (BETIM) - INEP: 311430
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311430' 
    WHERE UPPER(TRIM(name)) = 'EM MÁRIO MARCOS C TUPYNAMBÁ' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311430');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLÍMPIA MARIA DA GLÓRIA (BETIM) - INEP: 226599
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226599' 
    WHERE UPPER(TRIM(name)) = 'EM OLÍMPIA MARIA DA GLÓRIA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226599');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSÓRIO ALEIXO DA SILVA (BETIM) - INEP: 234591
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234591' 
    WHERE UPPER(TRIM(name)) = 'EM OSÓRIO ALEIXO DA SILVA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234591');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR KÁSSIO VINÍCIUS CASTRO GOMES (BETIM) - INEP: 354406
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354406' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR KÁSSIO VINÍCIUS CASTRO GOMES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354406');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RITA MARIA SILVA (BETIM) - INEP: 323781
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323781' 
    WHERE UPPER(TRIM(name)) = 'EM RITA MARIA SILVA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323781');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO FERREIRA DE OLIVEIRA (BETIM) - INEP: 226564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226564' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO FERREIRA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TITO FLÁVIUS LIMA ANDRADE (BETIM) - INEP: 226556
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226556' 
    WHERE UPPER(TRIM(name)) = 'EM TITO FLÁVIUS LIMA ANDRADE' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226556');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VALÉRIO FERREIRA PALHARES (BETIM) - INEP: 243141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '243141' 
    WHERE UPPER(TRIM(name)) = 'EM VALÉRIO FERREIRA PALHARES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '243141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR RAFAEL BARBIZAN (BETIM) - INEP: 321796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321796' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR RAFAEL BARBIZAN' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM WALDEMAR DA LUZ GONÇALVES (BETIM) - INEP: 223026
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223026' 
    WHERE UPPER(TRIM(name)) = 'EM WALDEMAR DA LUZ GONÇALVES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223026');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM MARIA SILVA LUCAS (CONTAGEM) - INEP: 236799
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236799' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM MARIA SILVA LUCAS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236799');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM  SENADOR JOSÉ DE ALENCAR (CONTAGEM) - INEP: 372137
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372137' 
    WHERE UPPER(TRIM(name)) = 'EM SENADOR JOSÉ DE ALENCAR' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372137');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALBERTINA ALVES DO NASCIMENTO (CONTAGEM) - INEP: 350109
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350109' 
    WHERE UPPER(TRIM(name)) = 'EM ALBERTINA ALVES DO NASCIMENTO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350109');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS DRUMOND DE ANDRADE (CONTAGEM) - INEP: 220957
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220957' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS DRUMOND DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220957');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOMINGOS JOSÉ DINIZ COSTA BELÉM (CONTAGEM) - INEP: 342912
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342912' 
    WHERE UPPER(TRIM(name)) = 'EM DOMINGOS JOSÉ DINIZ COSTA BELÉM' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342912');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ELI HORTA COSTA (CONTAGEM) - INEP: 350117
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350117' 
    WHERE UPPER(TRIM(name)) = 'EM ELI HORTA COSTA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350117');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ESTUDANTE LEONARDO SADRA (CONTAGEM) - INEP: 220965
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220965' 
    WHERE UPPER(TRIM(name)) = 'EM ESTUDANTE LEONARDO SADRA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220965');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO SALES DA SILVA DINIZ (CONTAGEM) - INEP: 307891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307891' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO SALES DA SILVA DINIZ' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GIOVANINI CHIODI (CONTAGEM) - INEP: 307904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307904' 
    WHERE UPPER(TRIM(name)) = 'EM GIOVANINI CHIODI' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307904');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GLÓRIA MARQUES DINIZ (CONTAGEM) - INEP: 247405
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247405' 
    WHERE UPPER(TRIM(name)) = 'EM GLÓRIA MARQUES DINIZ' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247405');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HEITOR VILLA LOBOS (CONTAGEM) - INEP: 217115
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217115' 
    WHERE UPPER(TRIM(name)) = 'EM HEITOR VILLA LOBOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217115');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HILDA NUNES DOS SANTOS (CONTAGEM) - INEP: 322377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322377' 
    WHERE UPPER(TRIM(name)) = 'EM HILDA NUNES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IVAN DINIZ MACEDO (CONTAGEM) - INEP: 277258
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277258' 
    WHERE UPPER(TRIM(name)) = 'EM IVAN DINIZ MACEDO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277258');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ LUCAS FILHO (CONTAGEM) - INEP: 222992
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222992' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ LUCAS FILHO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222992');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MACHADO DE ASSIS (CONTAGEM) - INEP: 220981
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220981' 
    WHERE UPPER(TRIM(name)) = 'EM MACHADO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220981');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DO CARMO ORECHIO (CONTAGEM) - INEP: 348597
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348597' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DO CARMO ORECHIO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348597');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OTACIR NUNES DOS SANTOS (CONTAGEM) - INEP: 307882
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307882' 
    WHERE UPPER(TRIM(name)) = 'EM OTACIR NUNES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307882');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE JOAQUIM DE SOUZA SILVA (CONTAGEM) - INEP: 222984
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222984' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE JOAQUIM DE SOUZA SILVA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222984');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO CÉZAR CUNHA (CONTAGEM) - INEP: 322709
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322709' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO CÉZAR CUNHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322709');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO LUIZ DA CUNHA (CONTAGEM) - INEP: 223018
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223018' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO LUIZ DA CUNHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223018');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR GERALDO BASÍLIO RAMOS (CONTAGEM) - INEP: 343811
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343811' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR GERALDO BASÍLIO RAMOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343811');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR HÍLTON ROCHA (CONTAGEM) - INEP: 253871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253871' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR HÍLTON ROCHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253871');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR RICARDO BRÁS GOMES BARRETO (CONTAGEM) - INEP: 350125
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350125' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR RICARDO BRÁS GOMES BARRETO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350125');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR WANCLEBER PACHECO (CONTAGEM) - INEP: 223000
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223000' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR WANCLEBER PACHECO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223000');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ANA GUEDES VIEIRA (CONTAGEM) - INEP: 231304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231304' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ANA GUEDES VIEIRA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA LÍGIA MAGALHÃES (CONTAGEM) - INEP: 212563
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212563' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA LÍGIA MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212563');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA DE MATOS SILVEIRA (CONTAGEM) - INEP: 223042
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223042' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA DE MATOS SILVEIRA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223042');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA MARTINS MARIINHA (CONTAGEM) - INEP: 372129
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372129' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA MARTINS MARIINHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372129');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA OLINTHA (CONTAGEM) - INEP: 376400
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376400' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA OLINTHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376400');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANDRA ROCHA (CONTAGEM) - INEP: 212571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212571' 
    WHERE UPPER(TRIM(name)) = 'EM SANDRA ROCHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TEMPO INTEGRAL PROFESSORA AUDREI CONSOLAÇÃO FERREIRA DE FREITAS COSTA (CONTAGEM) - INEP: 374881
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374881' 
    WHERE UPPER(TRIM(name)) = 'EM TEMPO INTEGRAL PROFESSORA AUDREI CONSOLAÇÃO FERREIRA DE FREITAS COSTA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374881');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VALTER FAUSTO DO AMARAL (CONTAGEM) - INEP: 226386
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226386' 
    WHERE UPPER(TRIM(name)) = 'EM VALTER FAUSTO DO AMARAL' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226386');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VASCO PINTO DA FONSECA (CONTAGEM) - INEP: 220990
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220990' 
    WHERE UPPER(TRIM(name)) = 'EM VASCO PINTO DA FONSECA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220990');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR BENEDITO BATISTA (CONTAGEM) - INEP: 343870
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343870' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR BENEDITO BATISTA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343870');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR JESUS MÍLTON DOS SANTOS (CONTAGEM) - INEP: 250724
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250724' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR JESUS MÍLTON DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250724');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VEREADOR JOSÉ FERREIRA DE AGUIAR (CONTAGEM) - INEP: 226378
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226378' 
    WHERE UPPER(TRIM(name)) = 'EM VEREADOR JOSÉ FERREIRA DE AGUIAR' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226378');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM WALTER LOPES (CONTAGEM) - INEP: 310344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310344' 
    WHERE UPPER(TRIM(name)) = 'EM WALTER LOPES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEC - UNIDADE OITIS (CONTAGEM) - INEP: 360171
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '360171' 
    WHERE UPPER(TRIM(name)) = 'IEC - UNIDADE OITIS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '360171');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEC UNIDADE INDUSTRIAL (CONTAGEM) - INEP: 223174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223174' 
    WHERE UPPER(TRIM(name)) = 'IEC UNIDADE INDUSTRIAL' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEC UNIDADE NOVA CONTAGEM (CONTAGEM) - INEP: 315486
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315486' 
    WHERE UPPER(TRIM(name)) = 'IEC UNIDADE NOVA CONTAGEM' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315486');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEC UNIDADE PETROLÂNDIA (CONTAGEM) - INEP: 223182
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223182' 
    WHERE UPPER(TRIM(name)) = 'IEC UNIDADE PETROLÂNDIA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223182');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEC UNIDADE XANGRILÁ (CONTAGEM) - INEP: 315478
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315478' 
    WHERE UPPER(TRIM(name)) = 'IEC UNIDADE XANGRILÁ' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315478');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EURICA ALVES MOREIRA (ESMERALDAS) - INEP: 325431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325431' 
    WHERE UPPER(TRIM(name)) = 'EM EURICA ALVES MOREIRA' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FELICIANO ALVES DINIZ (ESMERALDAS) - INEP: 222844
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222844' 
    WHERE UPPER(TRIM(name)) = 'EM FELICIANO ALVES DINIZ' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222844');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ LUCAS FILHO (ESMERALDAS) - INEP: 222852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222852' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ LUCAS FILHO' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222852');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSEFINA LUCAS MUNIZ (ESMERALDAS) - INEP: 222861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222861' 
    WHERE UPPER(TRIM(name)) = 'EM JOSEFINA LUCAS MUNIZ' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIETA RODRIGUES SOARES (ESMERALDAS) - INEP: 310930
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310930' 
    WHERE UPPER(TRIM(name)) = 'EM MARIETA RODRIGUES SOARES' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310930');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SADI ALVES VIEIRA (ESMERALDAS) - INEP: 222879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222879' 
    WHERE UPPER(TRIM(name)) = 'EM SADI ALVES VIEIRA' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL DURVAL DE BARROS (IBIRITÉ) - INEP: 239542
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239542' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL DURVAL DE BARROS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239542');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DA VILA IDEAL SERRA DOURADA (IBIRITÉ) - INEP: 322717
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322717' 
    WHERE UPPER(TRIM(name)) = 'EM DA VILA IDEAL SERRA DOURADA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322717');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO ÁGUIA DOURADA (IBIRITÉ) - INEP: 363715
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363715' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO ÁGUIA DOURADA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363715');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO DUVAL DE BARROS (IBIRITÉ) - INEP: 362700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362700' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO DUVAL DE BARROS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO JARDIM DAS ROSAS (IBIRITÉ) - INEP: 348902
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348902' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO JARDIM DAS ROSAS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348902');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO JARDIM MONTREAL OURO NEGRO (IBIRITÉ) - INEP: 331287
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331287' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO JARDIM MONTREAL OURO NEGRO' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331287');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO PALMEIRAS (IBIRITÉ) - INEP: 362719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362719' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO PALMEIRAS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362719');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO SERRA DOURADA (IBIRITÉ) - INEP: 348899
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348899' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO SERRA DOURADA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348899');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DAS MERCÊS AGUIAR (IBIRITÉ) - INEP: 348880
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348880' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DAS MERCÊS AGUIAR' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348880');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARINETE DAMASCENO PINHEIRO (IBIRITÉ) - INEP: 249271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249271' 
    WHERE UPPER(TRIM(name)) = 'EM MARINETE DAMASCENO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249271');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MORADA DA SERRA (IBIRITÉ) - INEP: 211419
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '211419' 
    WHERE UPPER(TRIM(name)) = 'EM MORADA DA SERRA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '211419');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PETRINA DE FREITAS CAMPOS (IBIRITÉ) - INEP: 348872
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348872' 
    WHERE UPPER(TRIM(name)) = 'EM PETRINA DE FREITAS CAMPOS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348872');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA CARMELITA  CARVALHO GARCIA (IBIRITÉ) - INEP: 231681
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231681' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA CARMELITA CARVALHO GARCIA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231681');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALÍPIO NOGUEIRA DO AMARAL (JUATUBA) - INEP: 258733
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258733' 
    WHERE UPPER(TRIM(name)) = 'EM ALÍPIO NOGUEIRA DO AMARAL' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258733');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ELZA DE OLIVEIRA SARAIVA (JUATUBA) - INEP: 236829
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236829' 
    WHERE UPPER(TRIM(name)) = 'EM ELZA DE OLIVEIRA SARAIVA' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236829');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ETELVINA DE OLIVEIRA GUIMARÃES (JUATUBA) - INEP: 297658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297658' 
    WHERE UPPER(TRIM(name)) = 'EM ETELVINA DE OLIVEIRA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JUQUITA FIRMINO (JUATUBA) - INEP: 236811
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236811' 
    WHERE UPPER(TRIM(name)) = 'EM JUQUITA FIRMINO' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236811');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA LUZIA DE ANDRADE (JUATUBA) - INEP: 258741
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258741' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA LUZIA DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258741');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA RENILDA FERREIRA (JUATUBA) - INEP: 234613
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234613' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA RENILDA FERREIRA' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234613');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MIGUEL RODRIGUES DUARTE (JUATUBA) - INEP: 205362
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205362' 
    WHERE UPPER(TRIM(name)) = 'EM MIGUEL RODRIGUES DUARTE' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205362');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE MOACIR CÂNDIDO RODRIGUES (JUATUBA) - INEP: 259331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259331' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE MOACIR CÂNDIDO RODRIGUES' 
      AND UPPER(TRIM(city)) = 'JUATUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ ANTÔNIO JÚNIOR (SÃO JOAQUIM DE BICAS) - INEP: 226432
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226432' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ ANTÔNIO JÚNIOR' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226432');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA JOSÉ DE ANDRADE HENRIQUES (SÃO JOAQUIM DE BICAS) - INEP: 226416
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226416' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA JOSÉ DE ANDRADE HENRIQUES' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226416');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ACADÊMICO VIVALDI MOREIRA (BELO HORIZONTE) - INEP: 312614
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312614' 
    WHERE UPPER(TRIM(name)) = 'EM ACADÊMICO VIVALDI MOREIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312614');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANNE FRANK (BELO HORIZONTE) - INEP: 219185
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219185' 
    WHERE UPPER(TRIM(name)) = 'EM ANNE FRANK' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219185');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARMANDO ZILLER (BELO HORIZONTE) - INEP: 232009
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232009' 
    WHERE UPPER(TRIM(name)) = 'EM ARMANDO ZILLER' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232009');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS DRUMMOND DE ANDRADE (BELO HORIZONTE) - INEP: 247294
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247294' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS DRUMMOND DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247294');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR JOSÉ XAVIER NOGUEIRA (BELO HORIZONTE) - INEP: 330850
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330850' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR JOSÉ XAVIER NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330850');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FLORESTAN FERNANDES (BELO HORIZONTE) - INEP: 283011
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '283011' 
    WHERE UPPER(TRIM(name)) = 'EM FLORESTAN FERNANDES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '283011');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO MAGALHÃES GOMES (BELO HORIZONTE) - INEP: 217891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217891' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO MAGALHÃES GOMES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HÉLIO PELLEGRINO (BELO HORIZONTE) - INEP: 247308
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247308' 
    WHERE UPPER(TRIM(name)) = 'EM HÉLIO PELLEGRINO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247308');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HERBERT JOSÉ DE SOUZA (BELO HORIZONTE) - INEP: 312622
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312622' 
    WHERE UPPER(TRIM(name)) = 'EM HERBERT JOSÉ DE SOUZA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312622');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JARDIM FELICIDADE (BELO HORIZONTE) - INEP: 212792
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212792' 
    WHERE UPPER(TRIM(name)) = 'EM JARDIM FELICIDADE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212792');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JARDIM LEBLON (BELO HORIZONTE) - INEP: 362247
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362247' 
    WHERE UPPER(TRIM(name)) = 'EM JARDIM LEBLON' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362247');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA DOS MARES GUIA (BELO HORIZONTE) - INEP: 223654
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223654' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA DOS MARES GUIA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223654');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE MARZANO MATIAS (BELO HORIZONTE) - INEP: 294641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294641' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE MARZANO MATIAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR AMÍLCAR MARTINS (BELO HORIZONTE) - INEP: 219568
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219568' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR AMÍLCAR MARTINS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219568');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR DANIEL ALVARENGA (BELO HORIZONTE) - INEP: 294632
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294632' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR DANIEL ALVARENGA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294632');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR TABAJARA PEDROSO (BELO HORIZONTE) - INEP: 206521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '206521' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR TABAJARA PEDROSO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '206521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RUI DA COSTA VAL (BELO HORIZONTE) - INEP: 233366
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233366' 
    WHERE UPPER(TRIM(name)) = 'EM RUI DA COSTA VAL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233366');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA TEREZINHA (BELO HORIZONTE) - INEP: 219231
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219231' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219231');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÉRGIO MIRANDA (BELO HORIZONTE) - INEP: 353752
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353752' 
    WHERE UPPER(TRIM(name)) = 'EM SÉRGIO MIRANDA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353752');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZILDA ARNS (BELO HORIZONTE) - INEP: 346900
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346900' 
    WHERE UPPER(TRIM(name)) = 'EM ZILDA ARNS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346900');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE LAPINHA (LAGOA SANTA) - INEP: 352942
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352942' 
    WHERE UPPER(TRIM(name)) = 'EM DE LAPINHA' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352942');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA ARAMITA (LAGOA SANTA) - INEP: 253898
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253898' 
    WHERE UPPER(TRIM(name)) = 'EM DONA ARAMITA' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253898');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LÍVIO MÚCIO CONRADO SILVA SENHOR TITO (LAGOA SANTA) - INEP: 354740
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354740' 
    WHERE UPPER(TRIM(name)) = 'EM LÍVIO MÚCIO CONRADO SILVA SENHOR TITO' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354740');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MÉRCIA MARGARIDA LACERDA MACHADO (LAGOA SANTA) - INEP: 345393
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345393' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MÉRCIA MARGARIDA LACERDA MACHADO' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345393');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA CARMEM BARROSO (PEDRO LEOPOLDO) - INEP: 321516
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321516' 
    WHERE UPPER(TRIM(name)) = 'EM DONA CARMEM BARROSO' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321516');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IZABEL GOMES TEIXEIRA (PEDRO LEOPOLDO) - INEP: 248461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248461' 
    WHERE UPPER(TRIM(name)) = 'EM IZABEL GOMES TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ ELIAS DA COSTA (PEDRO LEOPOLDO) - INEP: 223034
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223034' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ ELIAS DA COSTA' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223034');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALICE MARIA SMÉRIA (RIBEIRÃO DAS NEVES) - INEP: 347159
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347159' 
    WHERE UPPER(TRIM(name)) = 'EM ALICE MARIA SMÉRIA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347159');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLINDA RITTA DA SILVA (RIBEIRÃO DAS NEVES) - INEP: 322415
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322415' 
    WHERE UPPER(TRIM(name)) = 'EM CARLINDA RITTA DA SILVA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322415');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DERALDO JOSÉ DE SOUSA (RIBEIRÃO DAS NEVES) - INEP: 345962
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345962' 
    WHERE UPPER(TRIM(name)) = 'EM DERALDO JOSÉ DE SOUSA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345962');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO METROPOLITANO (RIBEIRÃO DAS NEVES) - INEP: 345946
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345946' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO METROPOLITANO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345946');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDSON CARLOS LOPES (RIBEIRÃO DAS NEVES) - INEP: 347124
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347124' 
    WHERE UPPER(TRIM(name)) = 'EM EDSON CARLOS LOPES' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347124');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JAIR AMÂNCIO (RIBEIRÃO DAS NEVES) - INEP: 247472
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247472' 
    WHERE UPPER(TRIM(name)) = 'EM JAIR AMÂNCIO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247472');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JANDIR CLEMENTE ROCHA (RIBEIRÃO DAS NEVES) - INEP: 349844
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349844' 
    WHERE UPPER(TRIM(name)) = 'EM JANDIR CLEMENTE ROCHA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349844');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ PINTO PIMENTA (RIBEIRÃO DAS NEVES) - INEP: 345954
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345954' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ PINTO PIMENTA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345954');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DA CRUZ RESENDE (RIBEIRÃO DAS NEVES) - INEP: 278190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278190' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DA CRUZ RESENDE' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA VIEIRA BARBOSA (RIBEIRÃO DAS NEVES) - INEP: 238945
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '238945' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA VIEIRA BARBOSA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '238945');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR AENDER MARQUES DA COSTA (RIBEIRÃO DAS NEVES) - INEP: 347140
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347140' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR AENDER MARQUES DA COSTA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347140');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA QUITA (SANTA LUZIA) - INEP: 224766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224766' 
    WHERE UPPER(TRIM(name)) = 'EM DONA QUITA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR OSWALDO FERREIRA (SANTA LUZIA) - INEP: 333107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333107' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR OSWALDO FERREIRA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333107');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ETELVINO SOUZA LIMA (SANTA LUZIA) - INEP: 218359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218359' 
    WHERE UPPER(TRIM(name)) = 'EM ETELVINO SOUZA LIMA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218359');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUISA ROSÁLIA DINIZ KENTISH (SANTA LUZIA) - INEP: 339873
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339873' 
    WHERE UPPER(TRIM(name)) = 'EM LUISA ROSÁLIA DINIZ KENTISH' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339873');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA JOSÉ DE BRITO CARVALHO (SANTA LUZIA) - INEP: 245852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245852' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA JOSÉ DE BRITO CARVALHO' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245852');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MIGUEL RESENDE (SANTA LUZIA) - INEP: 327115
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327115' 
    WHERE UPPER(TRIM(name)) = 'EM MIGUEL RESENDE' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327115');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDA JORGE DOS SANTOS (SANTANA DO RIACHO) - INEP: 267341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267341' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDA JORGE DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'SANTANA DO RIACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ODETE RODRIGUES FERREIRA (SÃO JOSÉ DA LAPA) - INEP: 236730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236730' 
    WHERE UPPER(TRIM(name)) = 'EM ODETE RODRIGUES FERREIRA' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAIMUNDO DAS CHAGAS QUINTÃO (TAQUARAÇU DE MINAS) - INEP: 272051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272051' 
    WHERE UPPER(TRIM(name)) = 'EM RAIMUNDO DAS CHAGAS QUINTÃO' 
      AND UPPER(TRIM(city)) = 'TAQUARAÇU DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BÁRBARA MARIA SALOMÃO (VESPASIANO) - INEP: 324183
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324183' 
    WHERE UPPER(TRIM(name)) = 'EM BÁRBARA MARIA SALOMÃO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324183');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CAROLINA CORRÊA DA COSTA (VESPASIANO) - INEP: 363839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363839' 
    WHERE UPPER(TRIM(name)) = 'EM CAROLINA CORRÊA DA COSTA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ELIZIO ANTONIO DE ALMEIDA (VESPASIANO) - INEP: 352373
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352373' 
    WHERE UPPER(TRIM(name)) = 'EM ELIZIO ANTONIO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352373');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ PAULO DE BARROS (VESPASIANO) - INEP: 321028
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321028' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ PAULO DE BARROS' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321028');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ SILVA (VESPASIANO) - INEP: 251348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251348' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ SILVA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSEFINA ALVES VIEIRA (VESPASIANO) - INEP: 293962
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293962' 
    WHERE UPPER(TRIM(name)) = 'EM JOSEFINA ALVES VIEIRA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293962');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JUSSARA GALEGO (VESPASIANO) - INEP: 358720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358720' 
    WHERE UPPER(TRIM(name)) = 'EM JUSSARA GALEGO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL FONSECA VIANA SOBRINHO (VESPASIANO) - INEP: 351890
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351890' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL FONSECA VIANA SOBRINHO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351890');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA APARECIDA BARROS SANTOS (VESPASIANO) - INEP: 340146
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340146' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA APARECIDA BARROS SANTOS' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340146');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DO CARMO SOARES - DONA NHANHÁ (VESPASIANO) - INEP: 371610
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371610' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DO CARMO SOARES - DONA NHANHÁ' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371610');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ORDELINA DE LOURDES COSTA (VESPASIANO) - INEP: 324191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324191' 
    WHERE UPPER(TRIM(name)) = 'EM ORDELINA DE LOURDES COSTA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO MARCONI ISSA (VESPASIANO) - INEP: 358711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358711' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO MARCONI ISSA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JUDAS TADEU (CASCALHO RICO) - INEP: 272337
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272337' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'CASCALHO RICO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272337');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO MATIAS PEREIRA (COROMANDEL) - INEP: 266396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266396' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO MATIAS PEREIRA' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LAÉRCIO MENDES DE SAIRRE (COROMANDEL) - INEP: 310964
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310964' 
    WHERE UPPER(TRIM(name)) = 'EM LAÉRCIO MENDES DE SAIRRE' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310964');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONS FLEURY CURADO (COROMANDEL) - INEP: 200417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200417' 
    WHERE UPPER(TRIM(name)) = 'EM MONS FLEURY CURADO' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CELSO BUENO (MONTE CARMELO) - INEP: 200565
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200565' 
    WHERE UPPER(TRIM(name)) = 'EM CELSO BUENO' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200565');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO CAMPOS (MONTE CARMELO) - INEP: 201910
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '201910' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO CAMPOS' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '201910');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DINAH SILVA AZEVEDO CALDEIRA (BOCAIÚVA) - INEP: 237400
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237400' 
    WHERE UPPER(TRIM(name)) = 'EM DINAH SILVA AZEVEDO CALDEIRA' 
      AND UPPER(TRIM(city)) = 'BOCAIÚVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237400');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ SEIXAS (BOCAIÚVA) - INEP: 237396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237396' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ SEIXAS' 
      AND UPPER(TRIM(city)) = 'BOCAIÚVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ZECA CALIXTO (BOCAIÚVA) - INEP: 276723
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276723' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ZECA CALIXTO' 
      AND UPPER(TRIM(city)) = 'BOCAIÚVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276723');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO HENRIQUE (BOTUMIRIM) - INEP: 207675
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '207675' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO HENRIQUE' 
      AND UPPER(TRIM(city)) = 'BOTUMIRIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '207675');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDO GOMES DOS SANTOS (CORAÇÃO DE JESUS) - INEP: 216399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '216399' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDO GOMES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '216399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ EVANGELISTA PEREIRA (CORAÇÃO DE JESUS) - INEP: 207764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '207764' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ EVANGELISTA PEREIRA' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '207764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUIRINO JOSÉ DA SILVA (CORAÇÃO DE JESUS) - INEP: 216356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '216356' 
    WHERE UPPER(TRIM(name)) = 'EM QUIRINO JOSÉ DA SILVA' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '216356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE SÃO GERALDO (FRANCISCO SÁ) - INEP: 298221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298221' 
    WHERE UPPER(TRIM(name)) = 'EM DE SÃO GERALDO' 
      AND UPPER(TRIM(city)) = 'FRANCISCO SÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF CÂNDIDO NEVES (ITACAMBIRA) - INEP: 207985
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '207985' 
    WHERE UPPER(TRIM(name)) = 'EM PROF CÂNDIDO NEVES' 
      AND UPPER(TRIM(city)) = 'ITACAMBIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '207985');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  EM DOMINGUINHOS PEREIRA - CAIC (MONTES CLAROS) - INEP: 242527
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242527' 
    WHERE UPPER(TRIM(name)) = 'EM DOMINGUINHOS PEREIRA - CAIC' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242527');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA VIDINHA PIRES (MONTES CLAROS) - INEP: 305936
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305936' 
    WHERE UPPER(TRIM(name)) = 'EM DONA VIDINHA PIRES' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305936');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR CRISANTINO BORÉM (MONTES CLAROS) - INEP: 227595
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227595' 
    WHERE UPPER(TRIM(name)) = 'EM DR CRISANTINO BORÉM' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227595');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDO PEREIRA DE SOUZA (MONTES CLAROS) - INEP: 223549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223549' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDO PEREIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO VALLE MAURÍCIO (MONTES CLAROS) - INEP: 223557
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223557' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO VALLE MAURÍCIO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223557');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MESTRA FININHA (MONTES CLAROS) - INEP: 227692
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227692' 
    WHERE UPPER(TRIM(name)) = 'EM MESTRA FININHA' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227692');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA EUNICE CARNEIRO (MONTES CLAROS) - INEP: 344060
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344060' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA EUNICE CARNEIRO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344060');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA NEIDE MELO FRANCO (MONTES CLAROS) - INEP: 227579
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227579' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA NEIDE MELO FRANCO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227579');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA DE LOURDES PINHEIRO (MONTES CLAROS) - INEP: 240168
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240168' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA DE LOURDES PINHEIRO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240168');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROTARY SÃO LUIZ (MONTES CLAROS) - INEP: 274305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274305' 
    WHERE UPPER(TRIM(name)) = 'EM ROTARY SÃO LUIZ' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274305');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROZENDA ZANE MORAES (MONTES CLAROS) - INEP: 368628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368628' 
    WHERE UPPER(TRIM(name)) = 'EM ROZENDA ZANE MORAES' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RUY LAGE (MONTES CLAROS) - INEP: 230359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230359' 
    WHERE UPPER(TRIM(name)) = 'EM RUY LAGE' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230359');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOANA FERREIRA DE BARROS (PATIS) - INEP: 315770
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315770' 
    WHERE UPPER(TRIM(name)) = 'EM JOANA FERREIRA DE BARROS' 
      AND UPPER(TRIM(city)) = 'PATIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315770');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DENIZAR VELOSO SANTOS (SÃO JOÃO DA PONTE) - INEP: 316709
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316709' 
    WHERE UPPER(TRIM(name)) = 'EM DENIZAR VELOSO SANTOS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316709');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO FERNANDES DOS SANTOS (SÃO JOÃO DA PONTE) - INEP: 297607
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297607' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO FERNANDES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297607');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA LOURDES RODRIGUES (BARÃO DE MONTE ALTO) - INEP: 269760
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269760' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA LOURDES RODRIGUES' 
      AND UPPER(TRIM(city)) = 'BARÃO DE MONTE ALTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269760');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA OLÍVIA MARIA COELHO (BARÃO DE MONTE ALTO) - INEP: 269751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269751' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA OLÍVIA MARIA COELHO' 
      AND UPPER(TRIM(city)) = 'BARÃO DE MONTE ALTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUEIROZES (EUGENÓPOLIS) - INEP: 244503
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '244503' 
    WHERE UPPER(TRIM(name)) = 'EM QUEIROZES' 
      AND UPPER(TRIM(city)) = 'EUGENÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '244503');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO MUNICIPAL NORBERTO BERNO (LARANJAL) - INEP: 259641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259641' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO MUNICIPAL NORBERTO BERNO' 
      AND UPPER(TRIM(city)) = 'LARANJAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM JOAQUIM RIBEIRO CARVALHO (MURIAÉ) - INEP: 245941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245941' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM JOAQUIM RIBEIRO CARVALHO' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÂNDIDO PORTINARI (MURIAÉ) - INEP: 250970
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250970' 
    WHERE UPPER(TRIM(name)) = 'EM CÂNDIDO PORTINARI' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250970');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA STELA FIDÉLIS (MURIAÉ) - INEP: 235172
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235172' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA STELA FIDÉLIS' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235172');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ELZA ROGÉRIO (MURIAÉ) - INEP: 227838
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227838' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ELZA ROGÉRIO' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227838');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ESMERALDA VIANNA (MURIAÉ) - INEP: 227846
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227846' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ESMERALDA VIANNA' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227846');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA AUXILIADORA G B BONATO (ROSÁRIO DA LIMEIRA) - INEP: 271039
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271039' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA AUXILIADORA G B BONATO' 
      AND UPPER(TRIM(city)) = 'ROSÁRIO DA LIMEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271039');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR JOÃO BATISTA DE RESENDE (SANTANA DE CATAGUASES) - INEP: 262978
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262978' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR JOÃO BATISTA DE RESENDE' 
      AND UPPER(TRIM(city)) = 'SANTANA DE CATAGUASES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262978');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ SOARES DE SOUZA FILHO (VIEIRAS) - INEP: 269824
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269824' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ SOARES DE SOUZA FILHO' 
      AND UPPER(TRIM(city)) = 'VIEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269824');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL PROFESSORA DIDI ANDRADE (ITABIRA) - INEP: 232190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232190' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL PROFESSORA DIDI ANDRADE' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO CAMILO ALVIM (ITABIRA) - INEP: 293849
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293849' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO CAMILO ALVIM' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293849');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ GOMES VIEIRA (ITABIRA) - INEP: 103268
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103268' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ GOMES VIEIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103268');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARINA BRAGANÇA DE MENDONÇA (ITABIRA) - INEP: 354481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354481' 
    WHERE UPPER(TRIM(name)) = 'EM MARINA BRAGANÇA DE MENDONÇA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ANTONINA MOREIRA (ITABIRA) - INEP: 103217
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103217' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ANTONINA MOREIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103217');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DE JOÃO MONLEVADE (JOÃO MONLEVADE) - INEP: 105091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105091' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DE JOÃO MONLEVADE' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÔNEGO JOSÉ HIGINO DE FREITAS (JOÃO MONLEVADE) - INEP: 103454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103454' 
    WHERE UPPER(TRIM(name)) = 'EM CÔNEGO JOSÉ HIGINO DE FREITAS' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERMIN LOUREIRO (JOÃO MONLEVADE) - INEP: 343110
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343110' 
    WHERE UPPER(TRIM(name)) = 'EM GERMIN LOUREIRO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343110');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GOV ISRAEL PINHEIRO (JOÃO MONLEVADE) - INEP: 105104
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105104' 
    WHERE UPPER(TRIM(name)) = 'EM GOV ISRAEL PINHEIRO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105104');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONTEIRO LOBATO (JOÃO MONLEVADE) - INEP: 227889
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227889' 
    WHERE UPPER(TRIM(name)) = 'EM MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227889');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROMORAR (JOÃO MONLEVADE) - INEP: 227897
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227897' 
    WHERE UPPER(TRIM(name)) = 'EM PROMORAR' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227897');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BERNARDO FERREIRA GUIMARÃES (RIO PIRACICABA) - INEP: 103748
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103748' 
    WHERE UPPER(TRIM(name)) = 'EM BERNARDO FERREIRA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103748');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÓRREGO SÃO MIGUEL (RIO PIRACICABA) - INEP: 339490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339490' 
    WHERE UPPER(TRIM(name)) = 'EM CÓRREGO SÃO MIGUEL' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MURILLO GARCIA MOREIRA (RIO PIRACICABA) - INEP: 103705
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103705' 
    WHERE UPPER(TRIM(name)) = 'EM MURILLO GARCIA MOREIRA' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103705');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNICIPAL DE SÃO GONÇALO DO RIO ABAIXO (SÃO GONÇALO DO RIO ABAIXO) - INEP: 347221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347221' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNICIPAL DE SÃO GONÇALO DO RIO ABAIXO' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO RIO ABAIXO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DE LOURDES DUARTE MOREIRA DOS SANTOS (SÃO GONÇALO DO RIO ABAIXO) - INEP: 345032
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345032' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DE LOURDES DUARTE MOREIRA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO RIO ABAIXO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345032');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EUCLIDES FERREIRA DE SÁ (TRÊS PONTAS) - INEP: 105201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105201' 
    WHERE UPPER(TRIM(name)) = 'EM EUCLIDES FERREIRA DE SÁ' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105201');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNICIPAL PROFESSOR ALCIDES R PEREIRA (ITABIRITO) - INEP: 107972
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107972' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNICIPAL PROFESSOR ALCIDES R PEREIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107972');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANA AMÉLIA QUEIROZ (ITABIRITO) - INEP: 332976
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332976' 
    WHERE UPPER(TRIM(name)) = 'EM ANA AMÉLIA QUEIROZ' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332976');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ FERREIRA BASTOS (ITABIRITO) - INEP: 215406
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215406' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ FERREIRA BASTOS' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215406');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL SALVADOR DE OLIVEIRA (ITABIRITO) - INEP: 106194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106194' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL SALVADOR DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEMPA - CENTRO DE  EDUCAÇÃO MUNICIPAL PADRE AVELAR (MARIANA) - INEP: 227960
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '227960' 
    WHERE UPPER(TRIM(name)) = 'CEMPA - CENTRO DE EDUCAÇÃO MUNICIPAL PADRE AVELAR' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '227960');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BENTO RODRIGUES (MARIANA) - INEP: 106241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106241' 
    WHERE UPPER(TRIM(name)) = 'EM BENTO RODRIGUES' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÔNEGO PAULO DILÁSCIO (MARIANA) - INEP: 107158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107158' 
    WHERE UPPER(TRIM(name)) = 'EM CÔNEGO PAULO DILÁSCIO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DANTE LUIZ DOS SANTOS (MARIANA) - INEP: 107174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107174' 
    WHERE UPPER(TRIM(name)) = 'EM DANTE LUIZ DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE BARRO  BRANCO (MARIANA) - INEP: 107301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107301' 
    WHERE UPPER(TRIM(name)) = 'EM DE BARRO BRANCO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE MAINART (MARIANA) - INEP: 107336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107336' 
    WHERE UPPER(TRIM(name)) = 'EM DE MAINART' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107336');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM LUCIANO PEDRO MENDES DE ALMEIDA (MARIANA) - INEP: 343021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343021' 
    WHERE UPPER(TRIM(name)) = 'EM DOM LUCIANO PEDRO MENDES DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM OSCAR DE OLIVEIRA (MARIANA) - INEP: 321524
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321524' 
    WHERE UPPER(TRIM(name)) = 'EM DOM OSCAR DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321524');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM EMÍLIO BAPTISTA (MARIANA) - INEP: 107247
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107247' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM EMÍLIO BAPTISTA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107247');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE ANTÔNIO GABRIEL DE CARVALHO (MARIANA) - INEP: 106356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106356' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE ANTÔNIO GABRIEL DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PARACATU DE BAIXO (MARIANA) - INEP: 107280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107280' 
    WHERE UPPER(TRIM(name)) = 'EM PARACATU DE BAIXO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA CELINA CÉLIA GOMES (MARIANA) - INEP: 107204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107204' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA CELINA CÉLIA GOMES' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SERRA DO CARMO (MARIANA) - INEP: 107352
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107352' 
    WHERE UPPER(TRIM(name)) = 'EM SERRA DO CARMO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107352');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SINHÔ MACHADO (MARIANA) - INEP: 106402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106402' 
    WHERE UPPER(TRIM(name)) = 'EM SINHÔ MACHADO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM WILSON PIMENTA FERREIRA (MARIANA) - INEP: 243957
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '243957' 
    WHERE UPPER(TRIM(name)) = 'EM WILSON PIMENTA FERREIRA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '243957');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALEIJADINHO (OURO PRETO) - INEP: 106712
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106712' 
    WHERE UPPER(TRIM(name)) = 'EM ALEIJADINHO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106712');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BENEDITO XAVIER (OURO PRETO) - INEP: 106682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106682' 
    WHERE UPPER(TRIM(name)) = 'EM BENEDITO XAVIER' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE LAVRAS NOVAS (OURO PRETO) - INEP: 106615
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106615' 
    WHERE UPPER(TRIM(name)) = 'EM DE LAVRAS NOVAS' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106615');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR ALVES DE BRITO (OURO PRETO) - INEP: 106704
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106704' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR ALVES DE BRITO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106704');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR PEDROSA (OURO PRETO) - INEP: 106739
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106739' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR PEDROSA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106739');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IZAURA MENDES (OURO PRETO) - INEP: 107441
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107441' 
    WHERE UPPER(TRIM(name)) = 'EM IZAURA MENDES' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107441');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MAJOR RAIMUNDO FELICÍSSIMO (OURO PRETO) - INEP: 106623
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106623' 
    WHERE UPPER(TRIM(name)) = 'EM MAJOR RAIMUNDO FELICÍSSIMO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106623');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONSENHOR JOÃO CASTILHO BARBOSA (OURO PRETO) - INEP: 106534
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106534' 
    WHERE UPPER(TRIM(name)) = 'EM MONSENHOR JOÃO CASTILHO BARBOSA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106534');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONSENHOR RAFAEL (OURO PRETO) - INEP: 106691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106691' 
    WHERE UPPER(TRIM(name)) = 'EM MONSENHOR RAFAEL' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE CARMÉLIO AUGUSTO TEIXEIRA (OURO PRETO) - INEP: 106518
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106518' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE CARMÉLIO AUGUSTO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106518');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA HAYDÉE ANTUNES (OURO PRETO) - INEP: 107573
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107573' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA HAYDÉE ANTUNES' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107573');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA JUVENTINA DRUMOND (OURO PRETO) - INEP: 107468
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107468' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA JUVENTINA DRUMOND' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107468');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TOMÁS ANTÔNIO GONZAGA (OURO PRETO) - INEP: 106593
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106593' 
    WHERE UPPER(TRIM(name)) = 'EM TOMÁS ANTÔNIO GONZAGA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106593');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SENADOR SOUZA VIANA (ABAETÉ) - INEP: 316962
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316962' 
    WHERE UPPER(TRIM(name)) = 'EM SENADOR SOUZA VIANA' 
      AND UPPER(TRIM(city)) = 'ABAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316962');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDO DE ASSIS (MARTINHO CAMPOS) - INEP: 256226
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256226' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'MARTINHO CAMPOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256226');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIA DO CARMO ÁLVARES SILVA (MORADA NOVA DE MINAS) - INEP: 268755
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268755' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIA DO CARMO ÁLVARES SILVA' 
      AND UPPER(TRIM(city)) = 'MORADA NOVA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268755');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC  EM PROFESSORA AMÉLIA GUIMARÃES (PARÁ DE MINAS) - INEP: 251020
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251020' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM PROFESSORA AMÉLIA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251020');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA COTINHA (PARÁ DE MINAS) - INEP: 226947
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '226947' 
    WHERE UPPER(TRIM(name)) = 'EM DONA COTINHA' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '226947');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA IZALTINA M MEIRELES (PARÁ DE MINAS) - INEP: 251046
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251046' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA IZALTINA M MEIRELES' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251046');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JUDAS TADEU (PARÁ DE MINAS) - INEP: 352233
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352233' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352233');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUÍS MACHADO FILHO (SERRA DA SAUDADE) - INEP: 274224
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274224' 
    WHERE UPPER(TRIM(name)) = 'EM LUÍS MACHADO FILHO' 
      AND UPPER(TRIM(city)) = 'SERRA DA SAUDADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274224');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM ISRAEL PINHEIRO (JOÃO PINHEIRO) - INEP: 111660
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '111660' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM ISRAEL PINHEIRO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '111660');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE VEREDAS (JOÃO PINHEIRO) - INEP: 108791
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108791' 
    WHERE UPPER(TRIM(name)) = 'EM DE VEREDAS' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108791');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EDMUNDO LOURENÇO (JOÃO PINHEIRO) - INEP: 112178
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112178' 
    WHERE UPPER(TRIM(name)) = 'EM EDMUNDO LOURENÇO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112178');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FREI PATRÍCIO (JOÃO PINHEIRO) - INEP: 108774
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108774' 
    WHERE UPPER(TRIM(name)) = 'EM FREI PATRÍCIO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108774');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA CLEUSA TEREZA ANDRADE (JOÃO PINHEIRO) - INEP: 111988
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '111988' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA CLEUSA TEREZA ANDRADE' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '111988');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AFONSO NOVAIS PINTO (PARACATU) - INEP: 112275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112275' 
    WHERE UPPER(TRIM(name)) = 'EM AFONSO NOVAIS PINTO' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALTINA DE PAULA SOUZA (PARACATU) - INEP: 112496
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112496' 
    WHERE UPPER(TRIM(name)) = 'EM ALTINA DE PAULA SOUZA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112496');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARQUIMEDES CÂNDIDO MEIRELES (PARACATU) - INEP: 112615
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112615' 
    WHERE UPPER(TRIM(name)) = 'EM ARQUIMEDES CÂNDIDO MEIRELES' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112615');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BERNARDINO DE FARIA PEREIRA (PARACATU) - INEP: 112631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112631' 
    WHERE UPPER(TRIM(name)) = 'EM BERNARDINO DE FARIA PEREIRA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CACILDA CAETANO DE SOUZA (PARACATU) - INEP: 208329
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '208329' 
    WHERE UPPER(TRIM(name)) = 'EM CACILDA CAETANO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '208329');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORACI MEIRELES OLIVEIRA (PARACATU) - INEP: 236381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236381' 
    WHERE UPPER(TRIM(name)) = 'EM CORACI MEIRELES OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GIDALTE MARIA DOS SANTOS (PARACATU) - INEP: 220833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220833' 
    WHERE UPPER(TRIM(name)) = 'EM GIDALTE MARIA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ PALMA (PARACATU) - INEP: 112623
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112623' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ PALMA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112623');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRO SILVA NEIVA (PARACATU) - INEP: 327549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327549' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRO SILVA NEIVA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ADA SANTANA RIBEIRO (PARACATU) - INEP: 108944
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108944' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ADA SANTANA RIBEIRO' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108944');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARCIA MACEDO MEIRELES - CAIC (PARACATU) - INEP: 249246
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249246' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARCIA MACEDO MEIRELES - CAIC' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249246');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA TRINDADE RODRIGUES (PARACATU) - INEP: 108936
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108936' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA TRINDADE RODRIGUES' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108936');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAIMUNDO JOSÉ DE SANTANA (PARACATU) - INEP: 112861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112861' 
    WHERE UPPER(TRIM(name)) = 'EM RAIMUNDO JOSÉ DE SANTANA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CALDEIRA BRANT (VAZANTE) - INEP: 109207
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109207' 
    WHERE UPPER(TRIM(name)) = 'EM CALDEIRA BRANT' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109207');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR MARTINHO CAMPOS (VAZANTE) - INEP: 114588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114588' 
    WHERE UPPER(TRIM(name)) = 'EM DR MARTINHO CAMPOS' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EMÍLIO ALVES RIOS (VAZANTE) - INEP: 236390
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236390' 
    WHERE UPPER(TRIM(name)) = 'EM EMÍLIO ALVES RIOS' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236390');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NAIR DE MELO FRANCO RIBEIRO (VAZANTE) - INEP: 109142
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109142' 
    WHERE UPPER(TRIM(name)) = 'EM NAIR DE MELO FRANCO RIBEIRO' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109142');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO TAQUARAL (CARMO DO RIO CLARO) - INEP: 116386
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '116386' 
    WHERE UPPER(TRIM(name)) = 'EM DO TAQUARAL' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '116386');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LÍDIO JOSÉ MARQUES (CARMO DO RIO CLARO) - INEP: 115045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115045' 
    WHERE UPPER(TRIM(name)) = 'EM LÍDIO JOSÉ MARQUES' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA LUZIA (CARMO DO RIO CLARO) - INEP: 116432
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '116432' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA LUZIA' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '116432');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOSÉ (CARMO DO RIO CLARO) - INEP: 116351
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '116351' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '116351');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAFAEL JOSÉ ALVES (CÓRREGO FUNDO) - INEP: 116815
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '116815' 
    WHERE UPPER(TRIM(name)) = 'EM RAFAEL JOSÉ ALVES' 
      AND UPPER(TRIM(city)) = 'CÓRREGO FUNDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '116815');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LOURDES APARECIDA DA SILVA (DELFINÓPOLIS) - INEP: 115169
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115169' 
    WHERE UPPER(TRIM(name)) = 'EM LOURDES APARECIDA DA SILVA' 
      AND UPPER(TRIM(city)) = 'DELFINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115169');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA DIAS MACHADO (DELFINÓPOLIS) - INEP: 115134
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115134' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA DIAS MACHADO' 
      AND UPPER(TRIM(city)) = 'DELFINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115134');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA EULÁLIA DE JESUS (DORESÓPOLIS) - INEP: 267201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267201' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA EULÁLIA DE JESUS' 
      AND UPPER(TRIM(city)) = 'DORESÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267201');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARLINDO DE MELLO (FORMIGA) - INEP: 222747
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222747' 
    WHERE UPPER(TRIM(name)) = 'EM ARLINDO DE MELLO' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222747');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CENTRO DE ATENÇÃO INTEGRAL A CRIANÇA - CAIC (FORMIGA) - INEP: 242357
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242357' 
    WHERE UPPER(TRIM(name)) = 'EM CENTRO DE ATENÇÃO INTEGRAL A CRIANÇA - CAIC' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242357');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FLORÊNCIO RODRIGUES NUNES (FORMIGA) - INEP: 115355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115355' 
    WHERE UPPER(TRIM(name)) = 'EM FLORÊNCIO RODRIGUES NUNES' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ ANTÔNIO DO COUTO (FORMIGA) - INEP: 342971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342971' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ ANTÔNIO DO COUTO' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ JOÃO DE MELO (FORMIGA) - INEP: 116874
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '116874' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ JOÃO DE MELO' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '116874');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MIRALDA DA SILVA CARVALHO (FORMIGA) - INEP: 215040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215040' 
    WHERE UPPER(TRIM(name)) = 'EM MIRALDA DA SILVA CARVALHO' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM  DR MANOEL PATTI (PASSOS) - INEP: 117498
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '117498' 
    WHERE UPPER(TRIM(name)) = 'EM DR MANOEL PATTI' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '117498');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CEL AZARIAS DE MELO (PASSOS) - INEP: 117218
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '117218' 
    WHERE UPPER(TRIM(name)) = 'EM CEL AZARIAS DE MELO' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '117218');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GERALDA CÂNDIDA DE OLIVEIRA (PASSOS) - INEP: 117561
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '117561' 
    WHERE UPPER(TRIM(name)) = 'EM GERALDA CÂNDIDA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '117561');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OILDA VALÉRIA SILVEIRA COELHO (PASSOS) - INEP: 117447
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '117447' 
    WHERE UPPER(TRIM(name)) = 'EM OILDA VALÉRIA SILVEIRA COELHO' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '117447');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF HILARINO MORAES (PASSOS) - INEP: 117471
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '117471' 
    WHERE UPPER(TRIM(name)) = 'EM PROF HILARINO MORAES' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '117471');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA JALILE BARBOSA CALIXTO (PASSOS) - INEP: 243655
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '243655' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA JALILE BARBOSA CALIXTO' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '243655');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ BALDOÍNO BORGES (MATUTINA) - INEP: 269131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269131' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ BALDOÍNO BORGES' 
      AND UPPER(TRIM(city)) = 'MATUTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269131');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ABDIAS CALDEIRA BRANT (PATOS DE MINAS) - INEP: 118907
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118907' 
    WHERE UPPER(TRIM(name)) = 'EM ABDIAS CALDEIRA BRANT' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118907');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÔNEGO GETÚLIO (PATOS DE MINAS) - INEP: 121347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '121347' 
    WHERE UPPER(TRIM(name)) = 'EM CÔNEGO GETÚLIO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '121347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DELFIM MOREIRA (PATOS DE MINAS) - INEP: 121380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '121380' 
    WHERE UPPER(TRIM(name)) = 'EM DELFIM MOREIRA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '121380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FREI LEOPOLDO (PATOS DE MINAS) - INEP: 118931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118931' 
    WHERE UPPER(TRIM(name)) = 'EM FREI LEOPOLDO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GINO ANDRÉ BARBOSA (PATOS DE MINAS) - INEP: 121746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '121746' 
    WHERE UPPER(TRIM(name)) = 'EM GINO ANDRÉ BARBOSA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '121746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JEREMIAS F DE PAULA (PATOS DE MINAS) - INEP: 121525
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '121525' 
    WHERE UPPER(TRIM(name)) = 'EM JEREMIAS F DE PAULA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '121525');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO GUALBERTO AMORIM JÚNIOR (PATOS DE MINAS) - INEP: 121193
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '121193' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO GUALBERTO AMORIM JÚNIOR' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '121193');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ PAULO DE AMORIM (PATOS DE MINAS) - INEP: 119075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119075' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ PAULO DE AMORIM' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119075');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MAJOR AUGUSTO PORTO (PATOS DE MINAS) - INEP: 119041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119041' 
    WHERE UPPER(TRIM(name)) = 'EM MAJOR AUGUSTO PORTO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA INÊS RUBINGER DE QUEIROZ RODRIGUES (PATOS DE MINAS) - INEP: 265331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265331' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA INÊS RUBINGER DE QUEIROZ RODRIGUES' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NORMA BORGES BELUCO (PATOS DE MINAS) - INEP: 265349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265349' 
    WHERE UPPER(TRIM(name)) = 'EM NORMA BORGES BELUCO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREF JAQUES CORREA DA COSTA (PATOS DE MINAS) - INEP: 249084
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249084' 
    WHERE UPPER(TRIM(name)) = 'EM PREF JAQUES CORREA DA COSTA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249084');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF ARISTIDES MEMÓRIA (PATOS DE MINAS) - INEP: 245381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245381' 
    WHERE UPPER(TRIM(name)) = 'EM PROF ARISTIDES MEMÓRIA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA MARLUCE M OLIVEIRA SCHER (PATOS DE MINAS) - INEP: 323560
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323560' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA MARLUCE M OLIVEIRA SCHER' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323560');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSVALDO CRUZ (PRESIDENTE OLEGÁRIO) - INEP: 122190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '122190' 
    WHERE UPPER(TRIM(name)) = 'EM OSVALDO CRUZ' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '122190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA CARMEM CELINA NOGUEIRA DE CASTILHO (PRESIDENTE OLEGÁRIO) - INEP: 119156
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119156' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA CARMEM CELINA NOGUEIRA DE CASTILHO' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119156');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO GERALDO (PRESIDENTE OLEGÁRIO) - INEP: 122581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '122581' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO GERALDO' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '122581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE GOULART II (RIO PARANAÍBA) - INEP: 119296
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119296' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE GOULART II' 
      AND UPPER(TRIM(city)) = 'RIO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119296');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL SEBASTIÃO FONTE BOA (SANTA ROSA DA SERRA) - INEP: 122653
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '122653' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL SEBASTIÃO FONTE BOA' 
      AND UPPER(TRIM(city)) = 'SANTA ROSA DA SERRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '122653');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLINTO GONÇALVES DE MELO (SÃO GONÇALO DO ABAETÉ) - INEP: 122955
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '122955' 
    WHERE UPPER(TRIM(name)) = 'EM OLINTO GONÇALVES DE MELO' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO ABAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '122955');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA JOSÉ DUTRA (SÃO GONÇALO DO ABAETÉ) - INEP: 119482
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119482' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA JOSÉ DUTRA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO ABAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119482');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUCIANO BORGES DE QUEIROZ (VARJÃO DE MINAS) - INEP: 265365
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265365' 
    WHERE UPPER(TRIM(name)) = 'EM LUCIANO BORGES DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'VARJÃO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265365');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MOISÉS BASÍLIO DE CAMARGOS (CRUZEIRO DA FORTALEZA) - INEP: 198919
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198919' 
    WHERE UPPER(TRIM(name)) = 'EM MOISÉS BASÍLIO DE CAMARGOS' 
      AND UPPER(TRIM(city)) = 'CRUZEIRO DA FORTALEZA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198919');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA DE FÁTIMA (CRUZEIRO DA FORTALEZA) - INEP: 198901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198901' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA DE FÁTIMA' 
      AND UPPER(TRIM(city)) = 'CRUZEIRO DA FORTALEZA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRO ALVES DE PAIVA (IBIÁ) - INEP: 159107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159107' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRO ALVES DE PAIVA' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159107');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUILOMBO DO AMBRÓSIO (IBIÁ) - INEP: 253596
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253596' 
    WHERE UPPER(TRIM(name)) = 'EM QUILOMBO DO AMBRÓSIO' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253596');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM STA BÁRBARA (IBIÁ) - INEP: 162442
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '162442' 
    WHERE UPPER(TRIM(name)) = 'EM STA BÁRBARA' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '162442');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM STA TEREZINHA (IBIÁ) - INEP: 162591
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '162591' 
    WHERE UPPER(TRIM(name)) = 'EM STA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '162591');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TATÃO ANACLETO (IBIÁ) - INEP: 159123
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159123' 
    WHERE UPPER(TRIM(name)) = 'EM TATÃO ANACLETO' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159123');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL MUN PROF OLÍMPIO DOS SANTOS (PATROCÍNIO) - INEP: 200221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200221' 
    WHERE UPPER(TRIM(name)) = 'COL MUN PROF OLÍMPIO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONSERVATÓRIO MUNICIPAL DE MÚSICA DR JOSÉ FIGUEIREDO (PATROCÍNIO) - INEP: 343196
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343196' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO MUNICIPAL DE MÚSICA DR JOSÉ FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343196');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ELISA VIANA BOTELHO (PATROCÍNIO) - INEP: 199818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199818' 
    WHERE UPPER(TRIM(name)) = 'EM ELISA VIANA BOTELHO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO BATISTA ROMÃO (PATROCÍNIO) - INEP: 199630
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199630' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO BATISTA ROMÃO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199630');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM MARTINS (PATROCÍNIO) - INEP: 199737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199737' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM MARTINS' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA ISABEL QUEIROZ ALVES - CAIC (PATROCÍNIO) - INEP: 248291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248291' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA ISABEL QUEIROZ ALVES - CAIC' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF AFRÂNIO AMARAL (PATROCÍNIO) - INEP: 261726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261726' 
    WHERE UPPER(TRIM(name)) = 'EM PROF AFRÂNIO AMARAL' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA RITA SANTOS BRAGA (PIRAPORA) - INEP: 221686
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '221686' 
    WHERE UPPER(TRIM(name)) = 'EM DONA RITA SANTOS BRAGA' 
      AND UPPER(TRIM(city)) = 'PIRAPORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '221686');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GABRIEL NUNES DE AZEVEDO (VÁRZEA DA PALMA) - INEP: 304417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '304417' 
    WHERE UPPER(TRIM(name)) = 'EM GABRIEL NUNES DE AZEVEDO' 
      AND UPPER(TRIM(city)) = 'VÁRZEA DA PALMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '304417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA YOLANDA DIAS RIBEIRO (ALTEROSA) - INEP: 123692
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123692' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA YOLANDA DIAS RIBEIRO' 
      AND UPPER(TRIM(city)) = 'ALTEROSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123692');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ISAURA VILELA BRASILEIRO (BOTELHOS) - INEP: 123994
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123994' 
    WHERE UPPER(TRIM(name)) = 'EM ISAURA VILELA BRASILEIRO' 
      AND UPPER(TRIM(city)) = 'BOTELHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123994');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL URIEL ALVIM (CALDAS) - INEP: 125741
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '125741' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL URIEL ALVIM' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '125741');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COMERCIAL PROFESSORA ILMA AMBROGI PRADO (CAMPESTRE) - INEP: 127884
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127884' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COMERCIAL PROFESSORA ILMA AMBROGI PRADO' 
      AND UPPER(TRIM(city)) = 'CAMPESTRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127884');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÔNEGO ARTUR (CAMPESTRE) - INEP: 277886
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277886' 
    WHERE UPPER(TRIM(name)) = 'EM CÔNEGO ARTUR' 
      AND UPPER(TRIM(city)) = 'CAMPESTRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277886');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NO BAIRRO POSSES (CAMPESTRE) - INEP: 124281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124281' 
    WHERE UPPER(TRIM(name)) = 'EM NO BAIRRO POSSES' 
      AND UPPER(TRIM(city)) = 'CAMPESTRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRA GRANDE (CAMPESTRE) - INEP: 126039
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '126039' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRA GRANDE' 
      AND UPPER(TRIM(city)) = 'CAMPESTRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '126039');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TIRADENTES (CONCEIÇÃO DA APARECIDA) - INEP: 124362
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124362' 
    WHERE UPPER(TRIM(name)) = 'EM TIRADENTES' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DA APARECIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124362');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA JOSÉ GODOY (NOVA RESENDE) - INEP: 124699
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124699' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA JOSÉ GODOY' 
      AND UPPER(TRIM(city)) = 'NOVA RESENDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124699');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM PROF ARINO FERREIRA PINTO (POÇOS DE CALDAS) - INEP: 249157
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249157' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM PROF ARINO FERREIRA PINTO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249157');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONSERVATÓRIO MÚSICA ANTÔNIO FERRUCIO VIVIANI (POÇOS DE CALDAS) - INEP: 245054
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245054' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO MÚSICA ANTÔNIO FERRUCIO VIVIANI' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245054');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALVINO HOSKEN DE OLIVEIRA (POÇOS DE CALDAS) - INEP: 124711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124711' 
    WHERE UPPER(TRIM(name)) = 'EM ALVINO HOSKEN DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA LÚCIA SACOMANN JUNQUEIRA (POÇOS DE CALDAS) - INEP: 127469
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127469' 
    WHERE UPPER(TRIM(name)) = 'EM DONA LÚCIA SACOMANN JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127469');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIQUINHAS BROCHADO (POÇOS DE CALDAS) - INEP: 124907
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124907' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIQUINHAS BROCHADO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124907');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR HAROLDO AFFONSO JUNQUEIRA (POÇOS DE CALDAS) - INEP: 124702
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124702' 
    WHERE UPPER(TRIM(name)) = 'EM DR HAROLDO AFFONSO JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124702');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR JOSÉ VARGAS DE SOUZA (POÇOS DE CALDAS) - INEP: 127329
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127329' 
    WHERE UPPER(TRIM(name)) = 'EM DR JOSÉ VARGAS DE SOUZA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127329');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR PEDRO AFONSO JUNQUEIRA (POÇOS DE CALDAS) - INEP: 124753
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124753' 
    WHERE UPPER(TRIM(name)) = 'EM DR PEDRO AFONSO JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124753');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IRMÃO JOSÉ GREGÓRIO (POÇOS DE CALDAS) - INEP: 127337
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127337' 
    WHERE UPPER(TRIM(name)) = 'EM IRMÃO JOSÉ GREGÓRIO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127337');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ AVELINO DE MELO (POÇOS DE CALDAS) - INEP: 127353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127353' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ AVELINO DE MELO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127353');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MAMUD ASSAN (POÇOS DE CALDAS) - INEP: 351199
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351199' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MAMUD ASSAN' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351199');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ RAPHAEL DOS SANTOS NETTO (POÇOS DE CALDAS) - INEP: 347485
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347485' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ RAPHAEL DOS SANTOS NETTO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347485');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA OVÍDIA JUNQUEIRA (POÇOS DE CALDAS) - INEP: 124869
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124869' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA OVÍDIA JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124869');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRESIDENTE WASHINGTON LUÍS (POÇOS DE CALDAS) - INEP: 124842
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124842' 
    WHERE UPPER(TRIM(name)) = 'EM PRESIDENTE WASHINGTON LUÍS' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124842');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF ANTÔNIO SÉRGIO TEIXEIRA (POÇOS DE CALDAS) - INEP: 124885
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124885' 
    WHERE UPPER(TRIM(name)) = 'EM PROF ANTÔNIO SÉRGIO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124885');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA CARMÉLIA DE CASTRO (POÇOS DE CALDAS) - INEP: 124796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124796' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA CARMÉLIA DE CASTRO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA NICOLINA BERNARDO (POÇOS DE CALDAS) - INEP: 127396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127396' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA NICOLINA BERNARDO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA EDIR FRAYHA (POÇOS DE CALDAS) - INEP: 232491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232491' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA EDIR FRAYHA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAPHAEL SANCHES (POÇOS DE CALDAS) - INEP: 127361
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127361' 
    WHERE UPPER(TRIM(name)) = 'EM RAPHAEL SANCHES' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127361');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÉRGIO DE FREITAS PACHECO (POÇOS DE CALDAS) - INEP: 127451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127451' 
    WHERE UPPER(TRIM(name)) = 'EM SÉRGIO DE FREITAS PACHECO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VITALINA ROSSI (POÇOS DE CALDAS) - INEP: 310182
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310182' 
    WHERE UPPER(TRIM(name)) = 'EM VITALINA ROSSI' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310182');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM WILSON HEDY MOLINARI (POÇOS DE CALDAS) - INEP: 124834
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124834' 
    WHERE UPPER(TRIM(name)) = 'EM WILSON HEDY MOLINARI' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124834');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR CUSTÓDIO DE PAULA RODRIGUES (ABRE CAMPO) - INEP: 305855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305855' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR CUSTÓDIO DE PAULA RODRIGUES' 
      AND UPPER(TRIM(city)) = 'ABRE CAMPO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO FIRMINO BITENCOURT (AMPARO DO SERRA) - INEP: 256242
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256242' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO FIRMINO BITENCOURT' 
      AND UPPER(TRIM(city)) = 'AMPARO DO SERRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256242');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLÍMPIO LOPES BAIÃO (AMPARO DO SERRA) - INEP: 128295
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128295' 
    WHERE UPPER(TRIM(name)) = 'EM OLÍMPIO LOPES BAIÃO' 
      AND UPPER(TRIM(city)) = 'AMPARO DO SERRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128295');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARNALDO DIAS DE ANDRADE FILHO (CAJURI) - INEP: 270563
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270563' 
    WHERE UPPER(TRIM(name)) = 'EM ARNALDO DIAS DE ANDRADE FILHO' 
      AND UPPER(TRIM(city)) = 'CAJURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270563');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR JUAREZ DE SOUZA CARMO (CAJURI) - INEP: 128473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128473' 
    WHERE UPPER(TRIM(name)) = 'EM DR JUAREZ DE SOUZA CARMO' 
      AND UPPER(TRIM(city)) = 'CAJURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CAMILO MARTINS DE MOURA (GUARACIABA) - INEP: 131237
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '131237' 
    WHERE UPPER(TRIM(name)) = 'EM CAMILO MARTINS DE MOURA' 
      AND UPPER(TRIM(city)) = 'GUARACIABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '131237');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VILMA HELENA SACRAMENTO BAIÃO (JEQUERI) - INEP: 324795
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324795' 
    WHERE UPPER(TRIM(name)) = 'EM VILMA HELENA SACRAMENTO BAIÃO' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324795');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PE ALÍPIO MARTINS PINHEIRO (ORATÓRIOS) - INEP: 271926
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271926' 
    WHERE UPPER(TRIM(name)) = 'EM PE ALÍPIO MARTINS PINHEIRO' 
      AND UPPER(TRIM(city)) = 'ORATÓRIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271926');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AGENOR BIBIANO DO CARMO (PEDRA BONITA) - INEP: 130311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '130311' 
    WHERE UPPER(TRIM(name)) = 'EM AGENOR BIBIANO DO CARMO' 
      AND UPPER(TRIM(city)) = 'PEDRA BONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '130311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO VIEIRA DE QUEIROZ (PEDRA BONITA) - INEP: 130354
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '130354' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO VIEIRA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'PEDRA BONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '130354');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PEDRO VÍTOR DE OLIVEIRA (PEDRA BONITA) - INEP: 130419
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '130419' 
    WHERE UPPER(TRIM(name)) = 'EM PEDRO VÍTOR DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PEDRA BONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '130419');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA DA FONSECA (PONTE NOVA) - INEP: 131954
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '131954' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '131954');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LUIZ MARTINS SOARES SOBRINHO (PONTE NOVA) - INEP: 129020
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129020' 
    WHERE UPPER(TRIM(name)) = 'EM LUIZ MARTINS SOARES SOBRINHO' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129020');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM N SRA DO ROSÁRIO (PONTE NOVA) - INEP: 321559
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321559' 
    WHERE UPPER(TRIM(name)) = 'EM N SRA DO ROSÁRIO' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321559');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PE RAFAEL FARACI (PONTE NOVA) - INEP: 129178
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129178' 
    WHERE UPPER(TRIM(name)) = 'EM PE RAFAEL FARACI' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129178');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM REINALDO ALVES COSTA (PONTE NOVA) - INEP: 129089
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129089' 
    WHERE UPPER(TRIM(name)) = 'EM REINALDO ALVES COSTA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129089');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SENADOR MIGUEL LANA (PONTE NOVA) - INEP: 129119
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129119' 
    WHERE UPPER(TRIM(name)) = 'EM SENADOR MIGUEL LANA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129119');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CEL JOÃO DOMINGOS (RAUL SOARES) - INEP: 129232
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129232' 
    WHERE UPPER(TRIM(name)) = 'EM CEL JOÃO DOMINGOS' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129232');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR JOSÉ MIRANDA CHAVES (RIO CASCA) - INEP: 129372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129372' 
    WHERE UPPER(TRIM(name)) = 'EM DR JOSÉ MIRANDA CHAVES' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ITAGIBA MARTINS CHAVES (RIO CASCA) - INEP: 129411
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129411' 
    WHERE UPPER(TRIM(name)) = 'EM ITAGIBA MARTINS CHAVES' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129411');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LOURDES FONSECA ZAIDAN (RIO CASCA) - INEP: 132667
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '132667' 
    WHERE UPPER(TRIM(name)) = 'EM LOURDES FONSECA ZAIDAN' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '132667');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SENADOR CUPERTINO (RIO CASCA) - INEP: 129402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129402' 
    WHERE UPPER(TRIM(name)) = 'EM SENADOR CUPERTINO' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AMARO RIBEIRO GOMES (SANTA CRUZ DO ESCALVADO) - INEP: 129453
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129453' 
    WHERE UPPER(TRIM(name)) = 'EM AMARO RIBEIRO GOMES' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DO ESCALVADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129453');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO LEÔNCIO CARNEIRO (SANTA CRUZ DO ESCALVADO) - INEP: 129500
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129500' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO LEÔNCIO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DO ESCALVADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129500');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ GOMES DE SOUZA (SANTA CRUZ DO ESCALVADO) - INEP: 129496
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129496' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ GOMES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DO ESCALVADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129496');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO CARLOS (TEIXEIRAS) - INEP: 129682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129682' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO CARLOS' 
      AND UPPER(TRIM(city)) = 'TEIXEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO MUNICIPAL DE EDUCAÇÃO DOUTOR JANUÁRIO DE ANDRADE FONTES (VIÇOSA) - INEP: 361208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361208' 
    WHERE UPPER(TRIM(name)) = 'CENTRO MUNICIPAL DE EDUCAÇÃO DOUTOR JANUÁRIO DE ANDRADE FONTES' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361208');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL ANTÔNIO DA SILVA BERNARDES (VIÇOSA) - INEP: 129933
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129933' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL ANTÔNIO DA SILVA BERNARDES' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129933');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR ARTHUR BERNARDES (VIÇOSA) - INEP: 133388
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133388' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR ARTHUR BERNARDES' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133388');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO FRANCISCO DA SILVA (VIÇOSA) - INEP: 129909
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129909' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO FRANCISCO DA SILVA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129909');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MINISTRO EDMUNDO LINS (VIÇOSA) - INEP: 129925
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129925' 
    WHERE UPPER(TRIM(name)) = 'EM MINISTRO EDMUNDO LINS' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129925');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA DE FÁTIMA (VIÇOSA) - INEP: 133426
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133426' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA DE FÁTIMA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133426');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE FRANCISCO JOSÉ DA SILVA (VIÇOSA) - INEP: 133434
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133434' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE FRANCISCO JOSÉ DA SILVA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133434');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO FERREIRA (ALBERTINA) - INEP: 123617
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123617' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO FERREIRA' 
      AND UPPER(TRIM(city)) = 'ALBERTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123617');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR DOUTOR ONOFRE VARGAS (CAMANDUCAIA) - INEP: 323179
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323179' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR DOUTOR ONOFRE VARGAS' 
      AND UPPER(TRIM(city)) = 'CAMANDUCAIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323179');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EVANDRO BRITO DA CUNHA (EXTREMA) - INEP: 273121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273121' 
    WHERE UPPER(TRIM(name)) = 'EM EVANDRO BRITO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ SEBASTIÃO MORBIDELLI (EXTREMA) - INEP: 368377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368377' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ SEBASTIÃO MORBIDELLI' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARISTELA CARNIEL ONISTO (EXTREMA) - INEP: 377643
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377643' 
    WHERE UPPER(TRIM(name)) = 'EM MARISTELA CARNIEL ONISTO' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377643');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


