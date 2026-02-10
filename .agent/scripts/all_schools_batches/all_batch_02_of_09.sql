-- Lote 2 de 9
-- Escolas 501 a 1000

-- EE PROFESSORA ALAÍDE LISBOA DE OLIVEIRA (BELO HORIZONTE) - INEP: 342459
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342459' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ALAÍDE LISBOA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342459');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA HENRIQUETA LISBOA (BELO HORIZONTE) - INEP: 342424
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342424' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA HENRIQUETA LISBOA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342424');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ZILDA ARNS NEUMANN (BELO HORIZONTE) - INEP: 342440
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342440' 
    WHERE UPPER(TRIM(name)) = 'EE ZILDA ARNS NEUMANN' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342440');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR GAMA CERQUEIRA (BELO VALE) - INEP: 106020
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106020' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR GAMA CERQUEIRA' 
      AND UPPER(TRIM(city)) = 'BELO VALE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106020');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EDMUNDO PENA (BOM JESUS DO AMPARO) - INEP: 102792
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102792' 
    WHERE UPPER(TRIM(name)) = 'EE EDMUNDO PENA' 
      AND UPPER(TRIM(city)) = 'BOM JESUS DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102792');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABELARDO DUARTE PASSOS (BRUMADINHO) - INEP: 351075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351075' 
    WHERE UPPER(TRIM(name)) = 'EE ABELARDO DUARTE PASSOS' 
      AND UPPER(TRIM(city)) = 'BRUMADINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351075');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SENADOR MELO VIANA (MOEDA) - INEP: 106437
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106437' 
    WHERE UPPER(TRIM(name)) = 'EE SENADOR MELO VIANA' 
      AND UPPER(TRIM(city)) = 'MOEDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106437');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA JOSEFINA SALES WARDI (NOVA LIMA) - INEP: 305014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305014' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA JOSEFINA SALES WARDI' 
      AND UPPER(TRIM(city)) = 'NOVA LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUQUINHA DE ALMEIDA (SABARÁ) - INEP: 222470
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222470' 
    WHERE UPPER(TRIM(name)) = 'EE JUQUINHA DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222470');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA (SABARÁ) - INEP: 318418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318418' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOÃO DE ARRUDA PINTO (SABARÁ) - INEP: 291102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '291102' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOÃO DE ARRUDA PINTO' 
      AND UPPER(TRIM(city)) = 'SABARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '291102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA NHANITA (SANTA BÁRBARA) - INEP: 346284
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346284' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA NHANITA' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346284');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG - UNIDADE GAMELEIRA (BELO HORIZONTE) - INEP: 307696
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307696' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG - UNIDADE GAMELEIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307696');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG- UNIDADE NOSSA SENHORA DAS VITÓRIAS (BELO HORIZONTE) - INEP: 307718
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307718' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG- UNIDADE NOSSA SENHORA DAS VITÓRIAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307718');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EMÍLIA CERDEIRA (BELO HORIZONTE) - INEP: 246433
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246433' 
    WHERE UPPER(TRIM(name)) = 'EE EMÍLIA CERDEIRA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246433');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (BETIM) - INEP: 321061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321061' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO AUGUSTO RIBEIRO (BETIM) - INEP: 212598
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212598' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO AUGUSTO RIBEIRO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212598');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO BAIRRO AMAZONAS (BETIM) - INEP: 215082
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215082' 
    WHERE UPPER(TRIM(name)) = 'EE DO BAIRRO AMAZONAS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215082');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GABRIEL PASSOS (BETIM) - INEP: 361445
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361445' 
    WHERE UPPER(TRIM(name)) = 'EE GABRIEL PASSOS' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361445');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR OSVALDO FRANCO (BETIM) - INEP: 212601
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212601' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR OSVALDO FRANCO' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212601');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VINÍCIUS DE MORAES (BETIM) - INEP: 353787
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353787' 
    WHERE UPPER(TRIM(name)) = 'EE VINÍCIUS DE MORAES' 
      AND UPPER(TRIM(city)) = 'BETIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353787');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (CONTAGEM) - INEP: 307726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307726' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG - UNIDADE AVELINO CAMARGOS (CONTAGEM) - INEP: 368903
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368903' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG - UNIDADE AVELINO CAMARGOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368903');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (CONTAGEM) - INEP: 349283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349283' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349283');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DE SALLES FERREIRA (CONTAGEM) - INEP: 212644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212644' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DE SALLES FERREIRA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROBERTO FERNANDES (CONTAGEM) - INEP: 349275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349275' 
    WHERE UPPER(TRIM(name)) = 'EE ROBERTO FERNANDES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VINÍCIUS DE MORAES (CONTAGEM) - INEP: 212652
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212652' 
    WHERE UPPER(TRIM(name)) = 'EE VINÍCIUS DE MORAES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212652');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONTE SINAI (ESMERALDAS) - INEP: 353868
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353868' 
    WHERE UPPER(TRIM(name)) = 'EE MONTE SINAI' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353868');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR RAYMUNDO CÂNDIDO (ESMERALDAS) - INEP: 330647
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330647' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR RAYMUNDO CÂNDIDO' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330647');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO MARINHO CAMPOS (IBIRITÉ) - INEP: 231665
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231665' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO MARINHO CAMPOS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231665');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO PINHEIRO DINIZ (IBIRITÉ) - INEP: 322989
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322989' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO PINHEIRO DINIZ' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322989');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORA CORALINA (IBIRITÉ) - INEP: 270407
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270407' 
    WHERE UPPER(TRIM(name)) = 'EE CORA CORALINA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270407');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (IBIRITÉ) - INEP: 353507
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353507' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353507');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IMPERATRIZ PIMENTA (IBIRITÉ) - INEP: 232483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232483' 
    WHERE UPPER(TRIM(name)) = 'EE IMPERATRIZ PIMENTA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO FERREIRA DE FREITAS (IBIRITÉ) - INEP: 223590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223590' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO FERREIRA DE FREITAS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223590');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ELZA CARDOSO RANGEL (IBIRITÉ) - INEP: 231673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231673' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ELZA CARDOSO RANGEL' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231673');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CRISTIANO CHAVES DE OLIVEIRA (IGARAPÉ) - INEP: 254720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254720' 
    WHERE UPPER(TRIM(name)) = 'EE CRISTIANO CHAVES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'IGARAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOELMA ALVES DE OLIVEIRA (IGARAPÉ) - INEP: 212466
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212466' 
    WHERE UPPER(TRIM(name)) = 'EE JOELMA ALVES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'IGARAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212466');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE CARLOS ROBERTO MARQUES (SÃO JOAQUIM DE BICAS) - INEP: 309842
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309842' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE CARLOS ROBERTO MARQUES' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309842');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ PEREIRA DOS SANTOS (SARZEDO) - INEP: 266094
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266094' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ PEREIRA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'SARZEDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266094');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA NILZA GOMES BERGMAN (SARZEDO) - INEP: 367826
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367826' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA NILZA GOMES BERGMAN' 
      AND UPPER(TRIM(city)) = 'SARZEDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367826');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG- UNIDADE MINASCAIXA (BELO HORIZONTE) - INEP: 307700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307700' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG- UNIDADE MINASCAIXA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA ANDRADE RESENDE (BELO HORIZONTE) - INEP: 253413
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253413' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ANDRADE RESENDE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253413');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOÃO DE MATTOS ALMEIDA (BELO HORIZONTE) - INEP: 322636
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322636' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOÃO DE MATTOS ALMEIDA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322636');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR AGNELO CORREIA VIANA (BELO HORIZONTE) - INEP: 317357
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317357' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR AGNELO CORREIA VIANA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317357');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INTENDENTE CÂMARA (MORRO DO PILAR) - INEP: 141291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141291' 
    WHERE UPPER(TRIM(name)) = 'EE INTENDENTE CÂMARA' 
      AND UPPER(TRIM(city)) = 'MORRO DO PILAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALESSANDRA SALUM CADAR (RIBEIRÃO DAS NEVES) - INEP: 231720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231720' 
    WHERE UPPER(TRIM(name)) = 'EE ALESSANDRA SALUM CADAR' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALIZON THEMÓTER COSTA (RIBEIRÃO DAS NEVES) - INEP: 339156
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339156' 
    WHERE UPPER(TRIM(name)) = 'EE ALIZON THEMÓTER COSTA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339156');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO RIGUEIRA DA FONSECA (RIBEIRÃO DAS NEVES) - INEP: 222461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222461' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO RIGUEIRA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARLOS DRUMMOND DE ANDRADE (RIBEIRÃO DAS NEVES) - INEP: 310221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310221' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS DRUMMOND DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CIDADE DOS MENINOS (RIBEIRÃO DAS NEVES) - INEP: 277037
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277037' 
    WHERE UPPER(TRIM(name)) = 'EE CIDADE DOS MENINOS' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277037');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CUSTÓDIO FÉLIX (RIBEIRÃO DAS NEVES) - INEP: 317195
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317195' 
    WHERE UPPER(TRIM(name)) = 'EE CUSTÓDIO FÉLIX' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317195');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (RIBEIRÃO DAS NEVES) - INEP: 342564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342564' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DJALMA MARQUES (RIBEIRÃO DAS NEVES) - INEP: 317489
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317489' 
    WHERE UPPER(TRIM(name)) = 'EE DJALMA MARQUES' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317489');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR REYNALDO MARTINS MARQUES (RIBEIRÃO DAS NEVES) - INEP: 342491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342491' 
    WHERE UPPER(TRIM(name)) = 'EE DR REYNALDO MARTINS MARQUES' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GUADALAJARA (RIBEIRÃO DAS NEVES) - INEP: 219045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219045' 
    WHERE UPPER(TRIM(name)) = 'EE GUADALAJARA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HENRIQUE DE SOUZA FILHO - HENFIL (RIBEIRÃO DAS NEVES) - INEP: 239381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239381' 
    WHERE UPPER(TRIM(name)) = 'EE HENRIQUE DE SOUZA FILHO - HENFIL' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ITÁLIA CAUTIERO FRANCO (RIBEIRÃO DAS NEVES) - INEP: 317349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317349' 
    WHERE UPPER(TRIM(name)) = 'EE ITÁLIA CAUTIERO FRANCO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO CORREA ARMOND (RIBEIRÃO DAS NEVES) - INEP: 231738
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231738' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO CORREA ARMOND' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231738');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DE ALMEIDA (RIBEIRÃO DAS NEVES) - INEP: 218758
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218758' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218758');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ SOARES DINIZ E SILVA (RIBEIRÃO DAS NEVES) - INEP: 218715
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218715' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ SOARES DINIZ E SILVA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218715');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL MARTINS DE MELO (RIBEIRÃO DAS NEVES) - INEP: 218995
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218995' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL MARTINS DE MELO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218995');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DA GLÓRIA ASSUNÇÃO (RIBEIRÃO DAS NEVES) - INEP: 212679
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212679' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DA GLÓRIA ASSUNÇÃO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212679');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DA PIEDADE SOUZA ROCHA (RIBEIRÃO DAS NEVES) - INEP: 231711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231711' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DA PIEDADE SOUZA ROCHA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA PEREIRA DE ARAÚJO (RIBEIRÃO DAS NEVES) - INEP: 322628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322628' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA PEREIRA DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DAS NEVES (RIBEIRÃO DAS NEVES) - INEP: 280160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280160' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DAS NEVES' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR PAULO FREIRE (RIBEIRÃO DAS NEVES) - INEP: 310212
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310212' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310212');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JUDAS TADEU (RIBEIRÃO DAS NEVES) - INEP: 219053
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219053' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219053');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE WASHINGTON MODESTO GONTIJO DE FARIA (RIBEIRÃO DAS NEVES) - INEP: 339105
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339105' 
    WHERE UPPER(TRIM(name)) = 'EE WASHINGTON MODESTO GONTIJO DE FARIA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339105');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EPHIGENIA DE JESUS WERNECK (SANTA LUZIA) - INEP: 351040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351040' 
    WHERE UPPER(TRIM(name)) = 'EE EPHIGENIA DE JESUS WERNECK' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE ITAMAR FRANCO (SANTA LUZIA) - INEP: 356727
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356727' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE ITAMAR FRANCO' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356727');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO EMÍLIO DE VASCONCELOS (SANTANA DO RIACHO) - INEP: 330761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330761' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO EMÍLIO DE VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'SANTANA DO RIACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BEATRIZ MARIA DE JESUS (SÃO JOSÉ DA LAPA) - INEP: 224103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224103' 
    WHERE UPPER(TRIM(name)) = 'EE BEATRIZ MARIA DE JESUS' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DE VESPASIANO (VESPASIANO) - INEP: 346306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346306' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE VESPASIANO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (VESPASIANO) - INEP: 331121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331121' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE  DE ENSINO FUNDAMENTAL E MÉDIO (VESPASIANO) - INEP: 374270
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374270' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374270');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (VESPASIANO) - INEP: 374288
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374288' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374288');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ GABRIEL DE OLIVEIRA (VESPASIANO) - INEP: 218979
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218979' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ GABRIEL DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218979');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NILA FARAJ (VESPASIANO) - INEP: 218740
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218740' 
    WHERE UPPER(TRIM(name)) = 'EE NILA FARAJ' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218740');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO ÁLVARES CABRAL (ABADIA DOS DOURADOS) - INEP: 200271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200271' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO ÁLVARES CABRAL' 
      AND UPPER(TRIM(city)) = 'ABADIA DOS DOURADOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200271');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENEDITO VALADARES (CASCALHO RICO) - INEP: 200280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200280' 
    WHERE UPPER(TRIM(name)) = 'EE BENEDITO VALADARES' 
      AND UPPER(TRIM(city)) = 'CASCALHO RICO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALÍRIO HERVAL (COROMANDEL) - INEP: 219011
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219011' 
    WHERE UPPER(TRIM(name)) = 'EE ALÍRIO HERVAL' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219011');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM BOTELHO (COROMANDEL) - INEP: 200395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200395' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM BOTELHO' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM JOSÉ DE ASSUNÇÃO (COROMANDEL) - INEP: 200433
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200433' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM JOSÉ DE ASSUNÇÃO' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200433');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE LÁZARO MENEZES (COROMANDEL) - INEP: 219002
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219002' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE LÁZARO MENEZES' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219002');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO GERALDO (COROMANDEL) - INEP: 200344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200344' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO GERALDO' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANITA RAMOS (DOURADOQUARA) - INEP: 307980
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307980' 
    WHERE UPPER(TRIM(name)) = 'EE ANITA RAMOS' 
      AND UPPER(TRIM(city)) = 'DOURADOQUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307980');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE DOLEARINA (ESTRELA DO SUL) - INEP: 200531
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200531' 
    WHERE UPPER(TRIM(name)) = 'EE DE DOLEARINA' 
      AND UPPER(TRIM(city)) = 'ESTRELA DO SUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200531');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROBERT KENNEDY (ESTRELA DO SUL) - INEP: 200484
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200484' 
    WHERE UPPER(TRIM(name)) = 'EE ROBERT KENNEDY' 
      AND UPPER(TRIM(city)) = 'ESTRELA DO SUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200484');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOSÉ FALEIROS DE AGUIAR (GRUPIARA) - INEP: 200549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200549' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ FALEIROS DE AGUIAR' 
      AND UPPER(TRIM(city)) = 'GRUPIARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC ZENITH CAMPOS (MONTE CARMELO) - INEP: 200671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200671' 
    WHERE UPPER(TRIM(name)) = 'CESEC ZENITH CAMPOS' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLARA CHAVES (MONTE CARMELO) - INEP: 200573
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200573' 
    WHERE UPPER(TRIM(name)) = 'EE CLARA CHAVES' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200573');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ELIAS DE MORAES (MONTE CARMELO) - INEP: 200603
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200603' 
    WHERE UPPER(TRIM(name)) = 'EE ELIAS DE MORAES' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200603');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GREGORIANO CANEDO (MONTE CARMELO) - INEP: 200611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200611' 
    WHERE UPPER(TRIM(name)) = 'EE GREGORIANO CANEDO' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MELO VIANA (MONTE CARMELO) - INEP: 200638
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200638' 
    WHERE UPPER(TRIM(name)) = 'EE MELO VIANA' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200638');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR VICENTE LOPES PEREZ (MONTE CARMELO) - INEP: 200654
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200654' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR VICENTE LOPES PEREZ' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200654');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA MARIA GORETTI (ROMARIA) - INEP: 200689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200689' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA MARIA GORETTI' 
      AND UPPER(TRIM(city)) = 'ROMARIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARLOS ANTÔNIO DOS SANTOS (BRASÍLIA DE MINAS) - INEP: 231533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231533' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS ANTÔNIO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'BRASÍLIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO XAVIER ANTUNES (BRASÍLIA DE MINAS) - INEP: 214981
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '214981' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO XAVIER ANTUNES' 
      AND UPPER(TRIM(city)) = 'BRASÍLIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '214981');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BARREIRO DE BAIXO (CORAÇÃO DE JESUS) - INEP: 239291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239291' 
    WHERE UPPER(TRIM(name)) = 'EE BARREIRO DE BAIXO' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DA CONCEIÇÃO CHAVES (CORAÇÃO DE JESUS) - INEP: 239275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239275' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DA CONCEIÇÃO CHAVES' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DA CONCEIÇÃO (CORAÇÃO DE JESUS) - INEP: 239259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239259' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DAS GRAÇAS (CORAÇÃO DE JESUS) - INEP: 239267
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239267' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239267');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ (CORAÇÃO DE JESUS) - INEP: 239241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239241' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO LUÍS (CORAÇÃO DE JESUS) - INEP: 239704
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239704' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO LUÍS' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239704');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO SEBASTIÃO (CORAÇÃO DE JESUS) - INEP: 239232
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239232' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239232');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (CRISTÁLIA) - INEP: 351067
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351067' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'CRISTÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351067');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (GRÃO MOGOL) - INEP: 346098
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346098' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'GRÃO MOGOL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346098');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ DO RIO PRETO (ITACAMBIRA) - INEP: 253430
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253430' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ DO RIO PRETO' 
      AND UPPER(TRIM(city)) = 'ITACAMBIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253430');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL PEREIRA DE ARAÚJO (JAPONVAR) - INEP: 239054
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239054' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL PEREIRA DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'JAPONVAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239054');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JUDAS TADEU (LUISLÂNDIA) - INEP: 276880
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276880' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'LUISLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276880');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA MARIA (MIRABELA) - INEP: 242217
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242217' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA MARIA' 
      AND UPPER(TRIM(city)) = 'MIRABELA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242217');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (MONTES CLAROS) - INEP: 326682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326682' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (MONTES CLAROS) - INEP: 346128
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346128' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346128');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (MONTES CLAROS) - INEP: 353833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353833' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (MONTES CLAROS) - INEP: 353841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353841' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GUTEMBERG TEODORO PENHA (MONTES CLAROS) - INEP: 346110
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346110' 
    WHERE UPPER(TRIM(name)) = 'EE GUTEMBERG TEODORO PENHA' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346110');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO MIGUEL TEIXEIRA DE JESUS (MONTES CLAROS) - INEP: 369861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369861' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO MIGUEL TEIXEIRA DE JESUS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LEVI DURÃES PERES (MONTES CLAROS) - INEP: 205664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205664' 
    WHERE UPPER(TRIM(name)) = 'EE LEVI DURÃES PERES' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ELIZABETE PEREIRA SOARES (MONTES CLAROS) - INEP: 346101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346101' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ELIZABETE PEREIRA SOARES' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA EMÍLIA SILVA SANTOS (MONTES CLAROS) - INEP: 369853
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369853' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA EMÍLIA SILVA SANTOS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369853');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE SAÚDE DO CENTRO DE EDUCAÇÃO PROFISSIONAL E TECNOLÓGICA DA UNIMONTES (MONTES CLAROS) - INEP: 261891
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261891' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE SAÚDE DO CENTRO DE EDUCAÇÃO PROFISSIONAL E TECNOLÓGICA DA UNIMONTES' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261891');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (SÃO JOÃO DA PONTE) - INEP: 346160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346160' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (SÃO JOÃO DA PONTE) - INEP: 353850
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353850' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353850');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LIODORA MARIA DA CONCEIÇÃO (SÃO JOÃO DA PONTE) - INEP: 356735
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356735' 
    WHERE UPPER(TRIM(name)) = 'EE LIODORA MARIA DA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356735');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DIVANE ROCHA DE SÁ (SÃO JOÃO DO PARAÍSO) - INEP: 254321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254321' 
    WHERE UPPER(TRIM(name)) = 'EE DIVANE ROCHA DE SÁ' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MÁRIO COELHO (SÃO JOÃO DO PARAÍSO) - INEP: 319074
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319074' 
    WHERE UPPER(TRIM(name)) = 'EE MÁRIO COELHO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319074');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTO ANTÔNIO (SÃO JOÃO DO PARAÍSO) - INEP: 246255
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246255' 
    WHERE UPPER(TRIM(name)) = 'EE SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246255');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO TIAGO (SÃO JOÃO DO PARAÍSO) - INEP: 254312
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254312' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO TIAGO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254312');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO ROCHA (ANTÔNIO PRADO DE MINAS) - INEP: 305278
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305278' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO ROCHA' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO PRADO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305278');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ORMEZINDA ALVES DUARTE (SÃO SEBASTIÃO DA VARGEM ALEGRE) - INEP: 276901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276901' 
    WHERE UPPER(TRIM(name)) = 'EE ORMEZINDA ALVES DUARTE' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DA VARGEM ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ MODESTO ÁVILA (BELA VISTA DE MINAS) - INEP: 102750
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102750' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MODESTO ÁVILA' 
      AND UPPER(TRIM(city)) = 'BELA VISTA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102750');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE OSWALDO DE PODESTÁ (BELA VISTA DE MINAS) - INEP: 102733
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102733' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE OSWALDO DE PODESTÁ' 
      AND UPPER(TRIM(city)) = 'BELA VISTA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102733');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ADELINA DA CONCEIÇÃO MENDES (BELA VISTA DE MINAS) - INEP: 102784
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102784' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ADELINA DA CONCEIÇÃO MENDES' 
      AND UPPER(TRIM(city)) = 'BELA VISTA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102784');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA JACY FRANCISCA GARCIA (DIONÍSIO) - INEP: 102831
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102831' 
    WHERE UPPER(TRIM(name)) = 'EE DONA JACY FRANCISCA GARCIA' 
      AND UPPER(TRIM(city)) = 'DIONÍSIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102831');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ MARTINS DRUMOND (DIONÍSIO) - INEP: 102873
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102873' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MARTINS DRUMOND' 
      AND UPPER(TRIM(city)) = 'DIONÍSIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102873');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR BENJAMIM ARAÚJO (DIONÍSIO) - INEP: 102814
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102814' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR BENJAMIM ARAÚJO' 
      AND UPPER(TRIM(city)) = 'DIONÍSIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102814');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSOR JÚLIO CARVALHO SOARES (FERROS) - INEP: 102971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102971' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR JÚLIO CARVALHO SOARES' 
      AND UPPER(TRIM(city)) = 'FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LEOPOLDINA BARROS DRUMOND (FERROS) - INEP: 103021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103021' 
    WHERE UPPER(TRIM(name)) = 'EE LEOPOLDINA BARROS DRUMOND' 
      AND UPPER(TRIM(city)) = 'FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PONCIANO PEREIRA DA COSTA (FERROS) - INEP: 103012
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103012' 
    WHERE UPPER(TRIM(name)) = 'EE PONCIANO PEREIRA DA COSTA' 
      AND UPPER(TRIM(city)) = 'FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103012');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ALCIDES FERNANDES DE ASSUNÇÃO (FERROS) - INEP: 102911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102911' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ALCIDES FERNANDES DE ASSUNÇÃO' 
      AND UPPER(TRIM(city)) = 'FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA DORINHA FERREIRA (ITABIRA) - INEP: 103284
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103284' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA DORINHA FERREIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103284');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES DA PMMG - CTPM - UNIDADE DOUTOR JOSÉ DE GRISOLIA (ITABIRA) - INEP: 370002
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370002' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES DA PMMG - CTPM - UNIDADE DOUTOR JOSÉ DE GRISOLIA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370002');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO LINHARES GUERRA (ITABIRA) - INEP: 103098
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103098' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO LINHARES GUERRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103098');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO MARTINS PEREIRA (ITABIRA) - INEP: 103314
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103314' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO MARTINS PEREIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103314');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA DA BETÂNIA (ITABIRA) - INEP: 103179
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103179' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA DA BETÂNIA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103179');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA ELEONORA NUNES PEREIRA (ITABIRA) - INEP: 103101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103101' 
    WHERE UPPER(TRIM(name)) = 'EE DONA ELEONORA NUNES PEREIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ RICARDO MARTINS FONSECA (ITABIRA) - INEP: 103152
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103152' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ RICARDO MARTINS FONSECA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103152');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAJOR LAGE (ITABIRA) - INEP: 103144
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103144' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR LAGE' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103144');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESTRE ZECA AMÂNCIO (ITABIRA) - INEP: 103161
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103161' 
    WHERE UPPER(TRIM(name)) = 'EE MESTRE ZECA AMÂNCIO' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103161');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR EMÍLIO PEREIRA DE MAGALHÃES (ITABIRA) - INEP: 103209
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103209' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR EMÍLIO PEREIRA DE MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103209');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANOEL SOARES (ITABIRA) - INEP: 103306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103306' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANOEL SOARES' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARCIANA MAGALHÃES (ITABIRA) - INEP: 103241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103241' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARCIANA MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA PALMIRA MORAIS (ITABIRA) - INEP: 103225
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103225' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA PALMIRA MORAIS' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103225');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TRAJANO PROCÓPIO DE ALVARENGA SILVA MONTEIRO (ITABIRA) - INEP: 103187
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103187' 
    WHERE UPPER(TRIM(name)) = 'EE TRAJANO PROCÓPIO DE ALVARENGA SILVA MONTEIRO' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103187');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EMÍDIO DE SALES (ITAMBÉ DO MATO DENTRO) - INEP: 103331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103331' 
    WHERE UPPER(TRIM(name)) = 'EE EMÍDIO DE SALES' 
      AND UPPER(TRIM(city)) = 'ITAMBÉ DO MATO DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA ELZA MARIA (JOÃO MONLEVADE) - INEP: 103373
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103373' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA ELZA MARIA' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103373');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBERTO PEREIRA LIMA (JOÃO MONLEVADE) - INEP: 103349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103349' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERTO PEREIRA LIMA' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA JENNY FARIA (JOÃO MONLEVADE) - INEP: 103420
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103420' 
    WHERE UPPER(TRIM(name)) = 'EE DONA JENNY FARIA' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103420');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR GERALDO PARREIRAS (JOÃO MONLEVADE) - INEP: 103527
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103527' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR GERALDO PARREIRAS' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103527');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZ PRISCO DE BRAGA (JOÃO MONLEVADE) - INEP: 103489
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103489' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZ PRISCO DE BRAGA' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103489');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL LOUREIRO (JOÃO MONLEVADE) - INEP: 103497
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103497' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL LOUREIRO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103497');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA VILA SANTA ROSA (NOVA ERA) - INEP: 103616
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103616' 
    WHERE UPPER(TRIM(name)) = 'EE DA VILA SANTA ROSA' 
      AND UPPER(TRIM(city)) = 'NOVA ERA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103616');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DE FÁTIMA (NOVA ERA) - INEP: 103586
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103586' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DE FÁTIMA' 
      AND UPPER(TRIM(city)) = 'NOVA ERA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103586');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE VIDIGAL (NOVA ERA) - INEP: 103594
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103594' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE VIDIGAL' 
      AND UPPER(TRIM(city)) = 'NOVA ERA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103594');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZA DOS SANTOS FERREIRA (PASSABÉM) - INEP: 103641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103641' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZA DOS SANTOS FERREIRA' 
      AND UPPER(TRIM(city)) = 'PASSABÉM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC MARTINHA DE OLIVEIRA ARAÚJO (RIO PIRACICABA) - INEP: 103721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103721' 
    WHERE UPPER(TRIM(name)) = 'CESEC MARTINHA DE OLIVEIRA ARAÚJO' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103721');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTONINO FERREIRA MENDES (RIO PIRACICABA) - INEP: 103730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103730' 
    WHERE UPPER(TRIM(name)) = 'EE ANTONINO FERREIRA MENDES' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARINHO SILVA (RIO PIRACICABA) - INEP: 338656
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338656' 
    WHERE UPPER(TRIM(name)) = 'EE MARINHO SILVA' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338656');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO FERNANDES PINTO (RIO PIRACICABA) - INEP: 103691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103691' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO FERNANDES PINTO' 
      AND UPPER(TRIM(city)) = 'RIO PIRACICABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AGENOR GUERRA (SANTA MARIA DE ITABIRA) - INEP: 103802
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103802' 
    WHERE UPPER(TRIM(name)) = 'EE AGENOR GUERRA' 
      AND UPPER(TRIM(city)) = 'SANTA MARIA DE ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103802');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR COSTA (SANTA MARIA DE ITABIRA) - INEP: 103756
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103756' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR COSTA' 
      AND UPPER(TRIM(city)) = 'SANTA MARIA DE ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103756');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ MADUREIRA DE OLIVEIRA (SANTO ANTÔNIO DO RIO ABAIXO) - INEP: 103829
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103829' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ MADUREIRA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO RIO ABAIXO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103829');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL FRANCISCO ROLLA (SÃO DOMINGOS DO PRATA) - INEP: 103845
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103845' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL FRANCISCO ROLLA' 
      AND UPPER(TRIM(city)) = 'SÃO DOMINGOS DO PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103845');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOSÉ GOMES DE ARAÚJO (SÃO DOMINGOS DO PRATA) - INEP: 103900
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103900' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ GOMES DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'SÃO DOMINGOS DO PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103900');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CRISTIANO MACHADO (SÃO DOMINGOS DO PRATA) - INEP: 103969
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103969' 
    WHERE UPPER(TRIM(name)) = 'EE CRISTIANO MACHADO' 
      AND UPPER(TRIM(city)) = 'SÃO DOMINGOS DO PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103969');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARQUES AFONSO (SÃO DOMINGOS DO PRATA) - INEP: 103888
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103888' 
    WHERE UPPER(TRIM(name)) = 'EE MARQUES AFONSO' 
      AND UPPER(TRIM(city)) = 'SÃO DOMINGOS DO PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103888');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VICENTE DE PAULA FRAGA (SÃO DOMINGOS DO PRATA) - INEP: 103993
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103993' 
    WHERE UPPER(TRIM(name)) = 'EE VICENTE DE PAULA FRAGA' 
      AND UPPER(TRIM(city)) = 'SÃO DOMINGOS DO PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103993');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DESEMBARGADOR MOREIRA SANTOS (SÃO GONÇALO DO RIO ABAIXO) - INEP: 104051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '104051' 
    WHERE UPPER(TRIM(name)) = 'EE DESEMBARGADOR MOREIRA SANTOS' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO RIO ABAIXO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '104051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROMEU PERDIGÃO (SÃO JOSÉ DO GOIABAL) - INEP: 104108
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '104108' 
    WHERE UPPER(TRIM(name)) = 'EE ROMEU PERDIGÃO' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DO GOIABAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '104108');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ODILON BEHRENS (SÃO SEBASTIÃO DO RIO PRETO) - INEP: 104141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '104141' 
    WHERE UPPER(TRIM(name)) = 'EE ODILON BEHRENS' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO RIO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '104141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE SIMIM (ACAIACA) - INEP: 106003
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106003' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE SIMIM' 
      AND UPPER(TRIM(city)) = 'ACAIACA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106003');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MARTINS (ACAIACA) - INEP: 330663
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330663' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MARTINS' 
      AND UPPER(TRIM(city)) = 'ACAIACA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330663');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL NICOLAU SAMPAIO (DIOGO DE VASCONCELOS) - INEP: 106101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106101' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL NICOLAU SAMPAIO' 
      AND UPPER(TRIM(city)) = 'DIOGO DE VASCONCELOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR RAUL SOARES (ITABIRITO) - INEP: 106143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106143' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR RAUL SOARES' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ENGENHEIRO QUEIROZ JÚNIOR (ITABIRITO) - INEP: 106151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106151' 
    WHERE UPPER(TRIM(name)) = 'EE ENGENHEIRO QUEIROZ JÚNIOR' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HENRIQUE MICHEL (ITABIRITO) - INEP: 106160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106160' 
    WHERE UPPER(TRIM(name)) = 'EE HENRIQUE MICHEL' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INTENDENTE CÂMARA (ITABIRITO) - INEP: 106178
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106178' 
    WHERE UPPER(TRIM(name)) = 'EE INTENDENTE CÂMARA' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106178');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR TIBÚRCIO (ITABIRITO) - INEP: 106127
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106127' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR TIBÚRCIO' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106127');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO BRAGA (MARIANA) - INEP: 106372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106372' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO BRAGA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO MAURO DE FARIA (MARIANA) - INEP: 106348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106348' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO MAURO DE FARIA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL BENJAMIM GUIMARÃES (MARIANA) - INEP: 106399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106399' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL BENJAMIM GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM BENEVIDES (MARIANA) - INEP: 106275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106275' 
    WHERE UPPER(TRIM(name)) = 'EE DOM BENEVIDES' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM SILVÉRIO (MARIANA) - INEP: 106291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106291' 
    WHERE UPPER(TRIM(name)) = 'EE DOM SILVÉRIO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA REPARATA DIAS DE OLIVEIRA (MARIANA) - INEP: 106259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106259' 
    WHERE UPPER(TRIM(name)) = 'EE DONA REPARATA DIAS DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO RAMOS FILHO (MARIANA) - INEP: 356808
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356808' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO RAMOS FILHO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356808');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR MORAIS (MARIANA) - INEP: 106364
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106364' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR MORAIS' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106364');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE VIEGAS (MARIANA) - INEP: 106381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106381' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE VIEGAS' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR SOARES FERREIRA (MARIANA) - INEP: 106321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106321' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR SOARES FERREIRA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO PEREIRA (OURO PRETO) - INEP: 106631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106631' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO PEREIRA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE OURO PRETO (OURO PRETO) - INEP: 106488
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106488' 
    WHERE UPPER(TRIM(name)) = 'EE DE OURO PRETO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106488');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DESEMBARGADOR HORÁCIO ANDRADE (OURO PRETO) - INEP: 106496
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106496' 
    WHERE UPPER(TRIM(name)) = 'EE DESEMBARGADOR HORÁCIO ANDRADE' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106496');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM PEDRO II (OURO PRETO) - INEP: 106500
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106500' 
    WHERE UPPER(TRIM(name)) = 'EE DOM PEDRO II' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106500');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM VELLOSO (OURO PRETO) - INEP: 106470
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106470' 
    WHERE UPPER(TRIM(name)) = 'EE DOM VELLOSO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106470');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ LEANDRO (OURO PRETO) - INEP: 106721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106721' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ LEANDRO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106721');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARÍLIA DE DIRCEU (OURO PRETO) - INEP: 106526
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106526' 
    WHERE UPPER(TRIM(name)) = 'EE MARÍLIA DE DIRCEU' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106526');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE AFONSO DE LEMOS (OURO PRETO) - INEP: 106666
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106666' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE AFONSO DE LEMOS' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106666');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA DAURA DE CARVALHO NETO (OURO PRETO) - INEP: 338915
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338915' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DAURA DE CARVALHO NETO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338915');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA DO CARMO ALMEIDA (OURO PRETO) - INEP: 351059
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351059' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA DO CARMO ALMEIDA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351059');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SORAMA GERALDA RICHARD XAVIER (BIQUINHAS) - INEP: 305626
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305626' 
    WHERE UPPER(TRIM(name)) = 'EE SORAMA GERALDA RICHARD XAVIER' 
      AND UPPER(TRIM(city)) = 'BIQUINHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305626');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ RIBEIRO DE ANDRADE (CEDRO DO ABAETÉ) - INEP: 307343
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307343' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ RIBEIRO DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'CEDRO DO ABAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307343');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA CAXIXÓ TAOCA SÉRGIA (MARTINHO CAMPOS) - INEP: 322865
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322865' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA CAXIXÓ TAOCA SÉRGIA' 
      AND UPPER(TRIM(city)) = 'MARTINHO CAMPOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322865');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AVANY VILLENA DINIZ (PARÁ DE MINAS) - INEP: 346152
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346152' 
    WHERE UPPER(TRIM(name)) = 'EE AVANY VILLENA DINIZ' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346152');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE LIBÉRIO (PARÁ DE MINAS) - INEP: 353477
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353477' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE LIBÉRIO' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353477');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR WILSON DE MELO GUIMARÃES (PARÁ DE MINAS) - INEP: 233391
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233391' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR WILSON DE MELO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233391');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GUSTAVO CAPANEMA (PITANGUI) - INEP: 310522
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310522' 
    WHERE UPPER(TRIM(name)) = 'EE GUSTAVO CAPANEMA' 
      AND UPPER(TRIM(city)) = 'PITANGUI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310522');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO TECNOLÓGICO DE AGROPECUÁRIA DE PITANGUI - ITAP (PITANGUI) - INEP: 217905
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217905' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO TECNOLÓGICO DE AGROPECUÁRIA DE PITANGUI - ITAP' 
      AND UPPER(TRIM(city)) = 'PITANGUI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217905');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO CAMPOS (QUARTEL GERAL) - INEP: 305651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305651' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO CAMPOS' 
      AND UPPER(TRIM(city)) = 'QUARTEL GERAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALMINDA ALVES DA SILVA (BRASILÂNDIA DE MINAS) - INEP: 239402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239402' 
    WHERE UPPER(TRIM(name)) = 'EE ALMINDA ALVES DA SILVA' 
      AND UPPER(TRIM(city)) = 'BRASILÂNDIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CYRO GÓES (BRASILÂNDIA DE MINAS) - INEP: 108731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108731' 
    WHERE UPPER(TRIM(name)) = 'EE CYRO GÓES' 
      AND UPPER(TRIM(city)) = 'BRASILÂNDIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ PACHECO PIMENTA (BRASILÂNDIA DE MINAS) - INEP: 108669
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108669' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ PACHECO PIMENTA' 
      AND UPPER(TRIM(city)) = 'BRASILÂNDIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108669');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ANTÔNIO RIBEIRO (GUARDA-MOR) - INEP: 108481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108481' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTÔNIO RIBEIRO' 
      AND UPPER(TRIM(city)) = 'GUARDA-MOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARMINDA MARIA DA COSTA (JOÃO PINHEIRO) - INEP: 108553
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108553' 
    WHERE UPPER(TRIM(name)) = 'EE ARMINDA MARIA DA COSTA' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108553');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAPITÃO SPERIDIÃO (JOÃO PINHEIRO) - INEP: 108511
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108511' 
    WHERE UPPER(TRIM(name)) = 'EE CAPITÃO SPERIDIÃO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108511');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO GUIMARÃES ROSA (JOÃO PINHEIRO) - INEP: 108596
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108596' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO GUIMARÃES ROSA' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108596');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ROMERO DA SILVEIRA (JOÃO PINHEIRO) - INEP: 220671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220671' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ROMERO DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA GONÇALVES AZEVEDO (JOÃO PINHEIRO) - INEP: 108561
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108561' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA GONÇALVES AZEVEDO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108561');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ORLINDA SARAIVA SIMÕES (JOÃO PINHEIRO) - INEP: 108545
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108545' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ORLINDA SARAIVA SIMÕES' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108545');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE QUINTINO VARGAS (JOÃO PINHEIRO) - INEP: 108537
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108537' 
    WHERE UPPER(TRIM(name)) = 'EE QUINTINO VARGAS' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108537');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO SIMÃO DE MELO (JOÃO PINHEIRO) - INEP: 256234
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256234' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO SIMÃO DE MELO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256234');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TANCREDO DE ALMEIDA NEVES (JOÃO PINHEIRO) - INEP: 108588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108588' 
    WHERE UPPER(TRIM(name)) = 'EE TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEOTÔNIO BRANDÃO VILELA (JOÃO PINHEIRO) - INEP: 108766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108766' 
    WHERE UPPER(TRIM(name)) = 'EE TEOTÔNIO BRANDÃO VILELA' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFFONSO ROQUETTE (PARACATU) - INEP: 108839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108839' 
    WHERE UPPER(TRIM(name)) = 'EE AFFONSO ROQUETTE' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALTINA DE PAULA GUIMARÃES (PARACATU) - INEP: 108863
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108863' 
    WHERE UPPER(TRIM(name)) = 'EE ALTINA DE PAULA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108863');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO CARLOS (PARACATU) - INEP: 108855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108855' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO CARLOS' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA RIACHO LAFERSA (PARACATU) - INEP: 108901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108901' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA RIACHO LAFERSA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DELANO BROCHADO ADJUTO (PARACATU) - INEP: 220663
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220663' 
    WHERE UPPER(TRIM(name)) = 'EE DELANO BROCHADO ADJUTO' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220663');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM SERAFIM GOMES JARDIM (PARACATU) - INEP: 108952
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108952' 
    WHERE UPPER(TRIM(name)) = 'EE DOM SERAFIM GOMES JARDIM' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108952');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR VIRGÍLIO DE MELO FRANCO (PARACATU) - INEP: 108847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108847' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR VIRGÍLIO DE MELO FRANCO' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JÚLIA CAMARGOS (PARACATU) - INEP: 108979
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108979' 
    WHERE UPPER(TRIM(name)) = 'EE JÚLIA CAMARGOS' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108979');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NEUSA PIMENTEL BARBOSA (PARACATU) - INEP: 353205
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353205' 
    WHERE UPPER(TRIM(name)) = 'EE NEUSA PIMENTEL BARBOSA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353205');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OLINDINA LOUREIRO (PARACATU) - INEP: 108880
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108880' 
    WHERE UPPER(TRIM(name)) = 'EE OLINDINA LOUREIRO' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108880');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEMÍSTOCLES ROCHA (PARACATU) - INEP: 108821
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108821' 
    WHERE UPPER(TRIM(name)) = 'EE TEMÍSTOCLES ROCHA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108821');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAROLINA SILVA (VAZANTE) - INEP: 308412
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '308412' 
    WHERE UPPER(TRIM(name)) = 'EE CAROLINA SILVA' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '308412');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO CÂNDIDO ULHOA (VAZANTE) - INEP: 109134
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109134' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO CÂNDIDO ULHOA' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109134');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA MARIANA SOLIS ROSA (VAZANTE) - INEP: 109177
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109177' 
    WHERE UPPER(TRIM(name)) = 'EE DONA MARIANA SOLIS ROSA' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109177');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO PEREIRA GUIMARÃES (VAZANTE) - INEP: 109151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109151' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO PEREIRA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA (VAZANTE) - INEP: 109169
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109169' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109169');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DOUTOR HÉLIO FERREIRA LOPES (ALPINÓPOLIS) - INEP: 114898
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114898' 
    WHERE UPPER(TRIM(name)) = 'CESEC DOUTOR HÉLIO FERREIRA LOPES' 
      AND UPPER(TRIM(city)) = 'ALPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114898');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM JOÃO VI (ALPINÓPOLIS) - INEP: 114863
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114863' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOÃO VI' 
      AND UPPER(TRIM(city)) = 'ALPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114863');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA INDÁ (ALPINÓPOLIS) - INEP: 114855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114855' 
    WHERE UPPER(TRIM(name)) = 'EE DONA INDÁ' 
      AND UPPER(TRIM(city)) = 'ALPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL ANTÔNIO DOMINGOS RIBEIRO (BOM JESUS DA PENHA) - INEP: 123901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123901' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ANTÔNIO DOMINGOS RIBEIRO' 
      AND UPPER(TRIM(city)) = 'BOM JESUS DA PENHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL LOURENÇO BELO (CAPITÓLIO) - INEP: 317462
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317462' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL LOURENÇO BELO' 
      AND UPPER(TRIM(city)) = 'CAPITÓLIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317462');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MODESTO ANTÔNIO DE OLIVEIRA (CAPITÓLIO) - INEP: 114961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114961' 
    WHERE UPPER(TRIM(name)) = 'EE MODESTO ANTÔNIO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CAPITÓLIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO DE ANDRADE VILELA (CARMO DO RIO CLARO) - INEP: 115061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115061' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO DE ANDRADE VILELA' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR MÁRIO ARAÚJO GUIMARÃES (CARMO DO RIO CLARO) - INEP: 115088
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115088' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR MÁRIO ARAÚJO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115088');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ SANGALI (CÓRREGO FUNDO) - INEP: 115347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115347' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ SANGALI' 
      AND UPPER(TRIM(city)) = 'CÓRREGO FUNDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA NEIVA MARIA LEITE (DELFINÓPOLIS) - INEP: 115126
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115126' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA NEIVA MARIA LEITE' 
      AND UPPER(TRIM(city)) = 'DELFINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115126');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE STA TEREZINHA (DORESÓPOLIS) - INEP: 115177
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115177' 
    WHERE UPPER(TRIM(name)) = 'EE STA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'DORESÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115177');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC ÂNGELA MARIA CASSEMIRO CORRÊA (FORMIGA) - INEP: 313700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313700' 
    WHERE UPPER(TRIM(name)) = 'CESEC ÂNGELA MARIA CASSEMIRO CORRÊA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AURELIANO RODRIGUES NUNES (FORMIGA) - INEP: 115258
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115258' 
    WHERE UPPER(TRIM(name)) = 'EE AURELIANO RODRIGUES NUNES' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115258');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR ABÍLIO MACHADO (FORMIGA) - INEP: 115282
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115282' 
    WHERE UPPER(TRIM(name)) = 'EE DR ABÍLIO MACHADO' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115282');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JALCIRA SANTOS VALADÃO (FORMIGA) - INEP: 115266
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115266' 
    WHERE UPPER(TRIM(name)) = 'EE JALCIRA SANTOS VALADÃO' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115266');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ BERNARDES DE FARIA (FORMIGA) - INEP: 115304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115304' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ BERNARDES DE FARIA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOAQUIM RODARTE (FORMIGA) - INEP: 115207
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115207' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOAQUIM RODARTE' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115207');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR TONICO LEITE (FORMIGA) - INEP: 115223
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115223' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR TONICO LEITE' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115223');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RODOLFO ALMEIDA (FORMIGA) - INEP: 115240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115240' 
    WHERE UPPER(TRIM(name)) = 'EE RODOLFO ALMEIDA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR NORALDINO DE LIMA (FORTALEZA DE MINAS) - INEP: 115363
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115363' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR NORALDINO DE LIMA' 
      AND UPPER(TRIM(city)) = 'FORTALEZA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115363');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DONA EMÍLIA LEAL (PASSOS) - INEP: 232653
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232653' 
    WHERE UPPER(TRIM(name)) = 'CESEC DONA EMÍLIA LEAL' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232653');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (PASSOS) - INEP: 115479
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115479' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115479');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABRAÃO LINCOLN (PASSOS) - INEP: 115380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115380' 
    WHERE UPPER(TRIM(name)) = 'EE ABRAÃO LINCOLN' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAETANO MACHADO DA SILVEIRA (PASSOS) - INEP: 115401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115401' 
    WHERE UPPER(TRIM(name)) = 'EE CAETANO MACHADO DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEUS UNIVERSO E VIRTUDE (PASSOS) - INEP: 115428
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115428' 
    WHERE UPPER(TRIM(name)) = 'EE DEUS UNIVERSO E VIRTUDE' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115428');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR TANCREDO DE ALMEIDA NEVES (PASSOS) - INEP: 115495
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115495' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115495');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DULCE FERREIRA DE SOUZA (PASSOS) - INEP: 115576
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115576' 
    WHERE UPPER(TRIM(name)) = 'EE DULCE FERREIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115576');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO DA SILVA MAIA (PASSOS) - INEP: 115487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115487' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO DA SILVA MAIA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LOURENÇO ANDRADE (PASSOS) - INEP: 115533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115533' 
    WHERE UPPER(TRIM(name)) = 'EE LOURENÇO ANDRADE' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZ DE MELLO VIANNA SOBRINHO (PASSOS) - INEP: 115541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115541' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZ DE MELLO VIANNA SOBRINHO' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NAZLE JABUR (PASSOS) - INEP: 115517
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115517' 
    WHERE UPPER(TRIM(name)) = 'EE NAZLE JABUR' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115517');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NECA QUIRINO (PASSOS) - INEP: 115550
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115550' 
    WHERE UPPER(TRIM(name)) = 'EE NECA QUIRINO' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115550');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DA PENHA (PASSOS) - INEP: 115568
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115568' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DA PENHA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115568');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JAIR SANTOS (PASSOS) - INEP: 218154
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218154' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JAIR SANTOS' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218154');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA JÚLIA KUBITSCHEK (PASSOS) - INEP: 115398
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115398' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA JÚLIA KUBITSCHEK' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115398');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ (PASSOS) - INEP: 115436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115436' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115436');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ ESPÍNDOLA (PIMENTA) - INEP: 115606
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115606' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ ESPÍNDOLA' 
      AND UPPER(TRIM(city)) = 'PIMENTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115606');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC SEBASTIÃO GONÇALVES DA SILVA (PIUMHI) - INEP: 115720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115720' 
    WHERE UPPER(TRIM(name)) = 'CESEC SEBASTIÃO GONÇALVES DA SILVA' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR FRANCISCO DE PAULA REBELO HORTA (PIUMHI) - INEP: 115690
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115690' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR FRANCISCO DE PAULA REBELO HORTA' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115690');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOÃO MENEZES (PIUMHI) - INEP: 115703
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115703' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOÃO MENEZES' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115703');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ SEVERIANO FILHO (SÃO JOÃO BATISTA DO GLÓRIA) - INEP: 115762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115762' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ SEVERIANO FILHO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO BATISTA DO GLÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE FURNAS (SÃO JOSÉ DA BARRA) - INEP: 114901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114901' 
    WHERE UPPER(TRIM(name)) = 'EE DE FURNAS' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DA BARRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JUSCELINO KUBITSCHEK (SÃO JOSÉ DA BARRA) - INEP: 114910
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114910' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JUSCELINO KUBITSCHEK' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DA BARRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114910');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GENERAL CARNEIRO (SÃO ROQUE DE MINAS) - INEP: 115789
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115789' 
    WHERE UPPER(TRIM(name)) = 'EE GENERAL CARNEIRO' 
      AND UPPER(TRIM(city)) = 'SÃO ROQUE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115789');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA IZAURA DE OLIVEIRA VILELA (SÃO ROQUE DE MINAS) - INEP: 346136
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346136' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA IZAURA DE OLIVEIRA VILELA' 
      AND UPPER(TRIM(city)) = 'SÃO ROQUE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346136');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO FRANCISCO (VARGEM BONITA) - INEP: 115843
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115843' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO FRANCISCO' 
      AND UPPER(TRIM(city)) = 'VARGEM BONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115843');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL GONÇALVES BOAVENTURA (ARAPUÁ) - INEP: 118419
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118419' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL GONÇALVES BOAVENTURA' 
      AND UPPER(TRIM(city)) = 'ARAPUÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118419');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMADEU GONÇALVES BOAVENTURA (CARMO DO PARANAÍBA) - INEP: 118443
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118443' 
    WHERE UPPER(TRIM(name)) = 'EE AMADEU GONÇALVES BOAVENTURA' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118443');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO ATANÁSIO (CARMO DO PARANAÍBA) - INEP: 118559
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118559' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO ATANÁSIO' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118559');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LEÔNCIO FERREIRA DE MELO (CARMO DO PARANAÍBA) - INEP: 305341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305341' 
    WHERE UPPER(TRIM(name)) = 'EE LEÔNCIO FERREIRA DE MELO' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DO CARMO (CARMO DO PARANAÍBA) - INEP: 326631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326631' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ HUGO GUIMARÃES (CARMO DO PARANAÍBA) - INEP: 118494
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118494' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ HUGO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118494');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC AUGUSTA RAQUEL DA SILVEIRA (LAGAMAR) - INEP: 118648
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118648' 
    WHERE UPPER(TRIM(name)) = 'CESEC AUGUSTA RAQUEL DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'LAGAMAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118648');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFONSO CORRÊA (LAGAMAR) - INEP: 118575
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118575' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO CORRÊA' 
      AND UPPER(TRIM(city)) = 'LAGAMAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118575');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉRICO ALVES (LAGAMAR) - INEP: 118583
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118583' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉRICO ALVES' 
      AND UPPER(TRIM(city)) = 'LAGAMAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118583');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM BOSCO (LAGAMAR) - INEP: 118605
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118605' 
    WHERE UPPER(TRIM(name)) = 'EE DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'LAGAMAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118605');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL CRISTIANO (LAGOA FORMOSA) - INEP: 118656
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118656' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL CRISTIANO' 
      AND UPPER(TRIM(city)) = 'LAGOA FORMOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118656');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ MARCIANO BRANDÃO (LAGOA FORMOSA) - INEP: 118672
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118672' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MARCIANO BRANDÃO' 
      AND UPPER(TRIM(city)) = 'LAGOA FORMOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118672');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DA PIEDADE (LAGOA FORMOSA) - INEP: 118664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118664' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DA PIEDADE' 
      AND UPPER(TRIM(city)) = 'LAGOA FORMOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA TEREZINHA (LAGOA GRANDE) - INEP: 119172
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119172' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'LAGOA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119172');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANA ROCHA (MATUTINA) - INEP: 118737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118737' 
    WHERE UPPER(TRIM(name)) = 'EE ANA ROCHA' 
      AND UPPER(TRIM(city)) = 'MATUTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (PATOS DE MINAS) - INEP: 118770
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118770' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118770');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABÍLIO CAIXETA DE QUEIROZ (PATOS DE MINAS) - INEP: 118818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118818' 
    WHERE UPPER(TRIM(name)) = 'EE ABÍLIO CAIXETA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABNER AFONSO (PATOS DE MINAS) - INEP: 118761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118761' 
    WHERE UPPER(TRIM(name)) = 'EE ABNER AFONSO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ADELAIDE MACIEL (PATOS DE MINAS) - INEP: 118788
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118788' 
    WHERE UPPER(TRIM(name)) = 'EE ADELAIDE MACIEL' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118788');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AGROTÉCNICA AFONSO QUEIROZ (PATOS DE MINAS) - INEP: 212229
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212229' 
    WHERE UPPER(TRIM(name)) = 'EE AGROTÉCNICA AFONSO QUEIROZ' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212229');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARLINDO PORTO (PATOS DE MINAS) - INEP: 305367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305367' 
    WHERE UPPER(TRIM(name)) = 'EE ARLINDO PORTO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEIRÓ EUNÁPIO BORGES (PATOS DE MINAS) - INEP: 118800
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118800' 
    WHERE UPPER(TRIM(name)) = 'EE DEIRÓ EUNÁPIO BORGES' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118800');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA GUIOMAR DE MELO (PATOS DE MINAS) - INEP: 118923
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118923' 
    WHERE UPPER(TRIM(name)) = 'EE DONA GUIOMAR DE MELO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118923');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR PAULO BORGES (PATOS DE MINAS) - INEP: 118796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118796' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR PAULO BORGES' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EUSTÁQUIO JOSÉ DA SILVA (PATOS DE MINAS) - INEP: 342483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342483' 
    WHERE UPPER(TRIM(name)) = 'EE EUSTÁQUIO JOSÉ DA SILVA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ILÍDIO CAIXETA DE MELO (PATOS DE MINAS) - INEP: 118834
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118834' 
    WHERE UPPER(TRIM(name)) = 'EE ILÍDIO CAIXETA DE MELO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118834');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO BARBOSA PORTO (PATOS DE MINAS) - INEP: 119032
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119032' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO BARBOSA PORTO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119032');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUCA MANDU (PATOS DE MINAS) - INEP: 119083
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119083' 
    WHERE UPPER(TRIM(name)) = 'EE JUCA MANDU' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119083');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAJOR MOTA (PATOS DE MINAS) - INEP: 119067
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119067' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR MOTA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119067');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARCOLINO DE BARROS (PATOS DE MINAS) - INEP: 118958
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118958' 
    WHERE UPPER(TRIM(name)) = 'EE MARCOLINO DE BARROS' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118958');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ALMIR NEVES DE MEDEIROS (PATOS DE MINAS) - INEP: 212237
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212237' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ALMIR NEVES DE MEDEIROS' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212237');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO DIAS MACIEL (PATOS DE MINAS) - INEP: 118982
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118982' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO DIAS MACIEL' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118982');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANOEL LOPES NOGUEIRA (PATOS DE MINAS) - INEP: 305359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305359' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANOEL LOPES NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305359');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR RENÉ DE DEUS VIEIRA (PATOS DE MINAS) - INEP: 360813
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '360813' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR RENÉ DE DEUS VIEIRA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '360813');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ZAMA MACIEL (PATOS DE MINAS) - INEP: 119024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119024' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ZAMA MACIEL' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA PAULINA DE MELO PORTO (PATOS DE MINAS) - INEP: 353485
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353485' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA PAULINA DE MELO PORTO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353485');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA TEREZINHA (PATOS DE MINAS) - INEP: 119016
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119016' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119016');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC TANCREDO NEVES (PRESIDENTE OLEGÁRIO) - INEP: 232645
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232645' 
    WHERE UPPER(TRIM(name)) = 'CESEC TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232645');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL - ANOS INICIAIS E FINAIS (PRESIDENTE OLEGÁRIO) - INEP: 375853
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375853' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL - ANOS INICIAIS E FINAIS' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375853');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE PONTE FIRME (PRESIDENTE OLEGÁRIO) - INEP: 119199
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119199' 
    WHERE UPPER(TRIM(name)) = 'EE DE PONTE FIRME' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119199');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ ANDRÉ CALDEIRA COIMBRA (PRESIDENTE OLEGÁRIO) - INEP: 119121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119121' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ ANDRÉ CALDEIRA COIMBRA' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119121');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE VARGAS (PRESIDENTE OLEGÁRIO) - INEP: 119164
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119164' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE VARGAS' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE OLEGÁRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119164');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ADIRON GONÇALVES BOAVENTURA (RIO PARANAÍBA) - INEP: 122629
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '122629' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ADIRON GONÇALVES BOAVENTURA' 
      AND UPPER(TRIM(city)) = 'RIO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '122629');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTERO MAGALHÃES DE AGUIAR (SANTA ROSA DA SERRA) - INEP: 119458
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119458' 
    WHERE UPPER(TRIM(name)) = 'EE ANTERO MAGALHÃES DE AGUIAR' 
      AND UPPER(TRIM(city)) = 'SANTA ROSA DA SERRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119458');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ZICO MENDONÇA (SÃO GONÇALO DO ABAETÉ) - INEP: 119504
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119504' 
    WHERE UPPER(TRIM(name)) = 'EE ZICO MENDONÇA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO ABAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119504');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC MARIA COELI FRANCO (SÃO GOTARDO) - INEP: 119601
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119601' 
    WHERE UPPER(TRIM(name)) = 'CESEC MARIA COELI FRANCO' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119601');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CONSELHEIRO AFONSO PENA (SÃO GOTARDO) - INEP: 318531
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318531' 
    WHERE UPPER(TRIM(name)) = 'EE CONSELHEIRO AFONSO PENA' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318531');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL HERMENEGILDO LADEIRA (SÃO GOTARDO) - INEP: 119628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119628' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL HERMENEGILDO LADEIRA' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL OSCAR PRADOS (SÃO GOTARDO) - INEP: 119539
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119539' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL OSCAR PRADOS' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119539');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ CAETANO RIBEIRO (SÃO GOTARDO) - INEP: 119598
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119598' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ CAETANO RIBEIRO' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119598');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE SINFRÔNIO BAHIA (SÃO GOTARDO) - INEP: 119571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119571' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE SINFRÔNIO BAHIA' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO PIO X (SÃO GOTARDO) - INEP: 119563
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119563' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO PIO X' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119563');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ COELHO (TIROS) - INEP: 119679
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119679' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ COELHO' 
      AND UPPER(TRIM(city)) = 'TIROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119679');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO PEREIRA BRANDÃO (VARJÃO DE MINAS) - INEP: 119521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '119521' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO PEREIRA BRANDÃO' 
      AND UPPER(TRIM(city)) = 'VARJÃO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '119521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÂNDIDA CORTES CORRÊA (CRUZEIRO DA FORTALEZA) - INEP: 278718
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278718' 
    WHERE UPPER(TRIM(name)) = 'EE CÂNDIDA CORTES CORRÊA' 
      AND UPPER(TRIM(city)) = 'CRUZEIRO DA FORTALEZA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278718');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃOS GUIMARÃES (GUIMARÂNIA) - INEP: 198943
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198943' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃOS GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'GUIMARÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198943');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR PEDRO DIAS DOS REIS (IBIÁ) - INEP: 159026
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159026' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR PEDRO DIAS DOS REIS' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159026');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ (IBIÁ) - INEP: 159069
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159069' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159069');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE EUSTÁQUIO (IRAÍ DE MINAS) - INEP: 198960
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198960' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE EUSTÁQUIO' 
      AND UPPER(TRIM(city)) = 'IRAÍ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198960');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ DO BARREIRO (IRAÍ DE MINAS) - INEP: 198986
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198986' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ DO BARREIRO' 
      AND UPPER(TRIM(city)) = 'IRAÍ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198986');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMIR AMARAL (PATROCÍNIO) - INEP: 198994
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '198994' 
    WHERE UPPER(TRIM(name)) = 'EE AMIR AMARAL' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '198994');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL ELMIRO ALVES DO NASCIMENTO (PATROCÍNIO) - INEP: 199214
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199214' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ELMIRO ALVES DO NASCIMENTO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199214');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DALVA STELA DE QUEIROZ (PATROCÍNIO) - INEP: 199141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199141' 
    WHERE UPPER(TRIM(name)) = 'EE DALVA STELA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM LUSTOSA (PATROCÍNIO) - INEP: 199010
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199010' 
    WHERE UPPER(TRIM(name)) = 'EE DOM LUSTOSA' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199010');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA COTINHA (PATROCÍNIO) - INEP: 199036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199036' 
    WHERE UPPER(TRIM(name)) = 'EE DONA COTINHA' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃ GISLENE (PATROCÍNIO) - INEP: 199061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199061' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃ GISLENE' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM DIAS (PATROCÍNIO) - INEP: 199095
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199095' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM DIAS' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199095');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ EDUARDO AQUINO (PATROCÍNIO) - INEP: 199133
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199133' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ EDUARDO AQUINO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199133');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NELY AMARAL (PATROCÍNIO) - INEP: 199117
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199117' 
    WHERE UPPER(TRIM(name)) = 'EE NELY AMARAL' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199117');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ODILON BEHRENS (PATROCÍNIO) - INEP: 199184
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199184' 
    WHERE UPPER(TRIM(name)) = 'EE ODILON BEHRENS' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199184');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ORMY ARAÚJO AMARAL (PATROCÍNIO) - INEP: 310603
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310603' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ORMY ARAÚJO AMARAL' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310603');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEREZINHA MOREIRA MARRA (PATROCÍNIO) - INEP: 356794
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356794' 
    WHERE UPPER(TRIM(name)) = 'EE TEREZINHA MOREIRA MARRA' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356794');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VENINA TAVARES AMARAL (PATROCÍNIO) - INEP: 199168
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199168' 
    WHERE UPPER(TRIM(name)) = 'EE VENINA TAVARES AMARAL' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199168');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HORÁCIO AFONSO (PERDIZES) - INEP: 159344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159344' 
    WHERE UPPER(TRIM(name)) = 'EE HORÁCIO AFONSO' 
      AND UPPER(TRIM(city)) = 'PERDIZES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSEFA MARGARIDA TRINDADE (PERDIZES) - INEP: 159352
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159352' 
    WHERE UPPER(TRIM(name)) = 'EE JOSEFA MARGARIDA TRINDADE' 
      AND UPPER(TRIM(city)) = 'PERDIZES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159352');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOÃO BALKER (PERDIZES) - INEP: 159387
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159387' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOÃO BALKER' 
      AND UPPER(TRIM(city)) = 'PERDIZES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159387');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO VIRMONDES AFONSO (PERDIZES) - INEP: 326704
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326704' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO VIRMONDES AFONSO' 
      AND UPPER(TRIM(city)) = 'PERDIZES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326704');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORNÉLIA REGINA (SERRA DO SALITRE) - INEP: 199303
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199303' 
    WHERE UPPER(TRIM(name)) = 'EE CORNÉLIA REGINA' 
      AND UPPER(TRIM(city)) = 'SERRA DO SALITRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199303');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SERRA DO SALITRE (SERRA DO SALITRE) - INEP: 199265
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199265' 
    WHERE UPPER(TRIM(name)) = 'EE SERRA DO SALITRE' 
      AND UPPER(TRIM(city)) = 'SERRA DO SALITRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199265');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEREZA DE CASTRO MARIANO (SERRA DO SALITRE) - INEP: 361607
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361607' 
    WHERE UPPER(TRIM(name)) = 'EE TEREZA DE CASTRO MARIANO' 
      AND UPPER(TRIM(city)) = 'SERRA DO SALITRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361607');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (BURITIZEIRO) - INEP: 346233
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346233' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'BURITIZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346233');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO JOSÉ MARIA PEREIRA (BURITIZEIRO) - INEP: 246131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246131' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO JOSÉ MARIA PEREIRA' 
      AND UPPER(TRIM(city)) = 'BURITIZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246131');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA SÍLVIA ALENCAR ZSCHABER (BURITIZEIRO) - INEP: 246140
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246140' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA SÍLVIA ALENCAR ZSCHABER' 
      AND UPPER(TRIM(city)) = 'BURITIZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246140');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR PAULO FREIRE (PIRAPORA) - INEP: 365270
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365270' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'PIRAPORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365270');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA GEOVANINA FERREIRA DIAS (SÃO ROMÃO) - INEP: 346225
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346225' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA GEOVANINA FERREIRA DIAS' 
      AND UPPER(TRIM(city)) = 'SÃO ROMÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346225');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO SANGUINETTE (VÁRZEA DA PALMA) - INEP: 223671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223671' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO SANGUINETTE' 
      AND UPPER(TRIM(city)) = 'VÁRZEA DA PALMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BOLÍVAR BOANERGES DA SILVEIRA (ALTEROSA) - INEP: 123668
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123668' 
    WHERE UPPER(TRIM(name)) = 'EE BOLÍVAR BOANERGES DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'ALTEROSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123668');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO JALES MACHADO (ALTEROSA) - INEP: 123684
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123684' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO JALES MACHADO' 
      AND UPPER(TRIM(city)) = 'ALTEROSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123684');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ADOLFO FIRMINO SOUZA MARQUES (ANDRADAS) - INEP: 123773
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123773' 
    WHERE UPPER(TRIM(name)) = 'EE ADOLFO FIRMINO SOUZA MARQUES' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123773');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOÃO MOSCONI (ANDRADAS) - INEP: 123706
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123706' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOÃO MOSCONI' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123706');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DANIEL RIBEIRO MOGGI (ANDRADAS) - INEP: 123757
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123757' 
    WHERE UPPER(TRIM(name)) = 'EE DANIEL RIBEIRO MOGGI' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123757');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ALCIDES MOSCONI (ANDRADAS) - INEP: 123714
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123714' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ALCIDES MOSCONI' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123714');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR EDMUNDO VIEIRA (ANDRADAS) - INEP: 123731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123731' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR EDMUNDO VIEIRA' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO LOURENÇO (AREADO) - INEP: 123846
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123846' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO LOURENÇO' 
      AND UPPER(TRIM(city)) = 'AREADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123846');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ BANDEIRA DE CARVALHO (BANDEIRA DO SUL) - INEP: 123897
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123897' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ BANDEIRA DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'BANDEIRA DO SUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123897');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFONSO ROMÃO DE SIQUEIRA (BOTELHOS) - INEP: 124010
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124010' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO ROMÃO DE SIQUEIRA' 
      AND UPPER(TRIM(city)) = 'BOTELHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124010');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DE SOUZA GONÇALVES (BOTELHOS) - INEP: 123951
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123951' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DE SOUZA GONÇALVES' 
      AND UPPER(TRIM(city)) = 'BOTELHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123951');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAJOR LEONEL (CABO VERDE) - INEP: 124095
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124095' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR LEONEL' 
      AND UPPER(TRIM(city)) = 'CABO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124095');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR PEDRO SATURNINO DE MAGALHÃES (CABO VERDE) - INEP: 124079
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124079' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PEDRO SATURNINO DE MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'CABO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124079');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA ELVIRA RODRIGUES PEREIRA (CALDAS) - INEP: 124214
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124214' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA ELVIRA RODRIGUES PEREIRA' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124214');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL - ANOS INICIAIS E FINAIS E ENSINO MÉDIO (CALDAS) - INEP: 377929
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377929' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL - ANOS INICIAIS E FINAIS E ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377929');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA XUCURU KARIRI - WARKANÃ DE ARUANÃ (CALDAS) - INEP: 322610
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322610' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA XUCURU KARIRI - WARKANÃ DE ARUANÃ' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322610');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ FRANCO (CALDAS) - INEP: 124231
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124231' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ FRANCO' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124231');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SOUZA NOVAIS (CALDAS) - INEP: 124184
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124184' 
    WHERE UPPER(TRIM(name)) = 'EE SOUZA NOVAIS' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124184');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VICENTE LANDI JÚNIOR (CALDAS) - INEP: 124192
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124192' 
    WHERE UPPER(TRIM(name)) = 'EE VICENTE LANDI JÚNIOR' 
      AND UPPER(TRIM(city)) = 'CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124192');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ELIAS JORGE ZENUN (CAMPESTRE) - INEP: 124290
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124290' 
    WHERE UPPER(TRIM(name)) = 'EE ELIAS JORGE ZENUN' 
      AND UPPER(TRIM(city)) = 'CAMPESTRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124290');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RUI BARBOSA (CAMPESTRE) - INEP: 124303
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124303' 
    WHERE UPPER(TRIM(name)) = 'EE RUI BARBOSA' 
      AND UPPER(TRIM(city)) = 'CAMPESTRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124303');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA COTINHA (CONCEIÇÃO DA APARECIDA) - INEP: 124346
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124346' 
    WHERE UPPER(TRIM(name)) = 'EE DONA COTINHA' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DA APARECIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124346');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ ANTÔNIO PANUCCI (CONCEIÇÃO DA APARECIDA) - INEP: 124311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124311' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ ANTÔNIO PANUCCI' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DA APARECIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SECRETÁRIO TRISTÃO DA CUNHA (DIVISA NOVA) - INEP: 124419
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124419' 
    WHERE UPPER(TRIM(name)) = 'EE SECRETÁRIO TRISTÃO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'DIVISA NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124419');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CALIMÉRIA SILVEIRA (IBITIÚRA DE MINAS) - INEP: 279293
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279293' 
    WHERE UPPER(TRIM(name)) = 'EE CALIMÉRIA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'IBITIÚRA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279293');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FREI LEVINO (MONTE BELO) - INEP: 124516
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124516' 
    WHERE UPPER(TRIM(name)) = 'EE FREI LEVINO' 
      AND UPPER(TRIM(city)) = 'MONTE BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124516');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO DE ALMEIDA NEVES (MONTE BELO) - INEP: 124524
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124524' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'MONTE BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124524');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CESÁRIO COIMBRA (MUZAMBINHO) - INEP: 124575
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124575' 
    WHERE UPPER(TRIM(name)) = 'EE CESÁRIO COIMBRA' 
      AND UPPER(TRIM(city)) = 'MUZAMBINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124575');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR SALATIEL DE ALMEIDA (MUZAMBINHO) - INEP: 124656
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124656' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR SALATIEL DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'MUZAMBINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124656');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE LUIZ MORENO (NOVA RESENDE) - INEP: 312061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312061' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE LUIZ MORENO' 
      AND UPPER(TRIM(city)) = 'NOVA RESENDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR CAIO ALBUQUERQUE (NOVA RESENDE) - INEP: 124664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124664' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CAIO ALBUQUERQUE' 
      AND UPPER(TRIM(city)) = 'NOVA RESENDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DAVID CAMPISTA (POÇOS DE CALDAS) - INEP: 124737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124737' 
    WHERE UPPER(TRIM(name)) = 'EE DAVID CAMPISTA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (POÇOS DE CALDAS) - INEP: 338869
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338869' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338869');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA FRANCISCA TAMM BIAS FORTES (POÇOS DE CALDAS) - INEP: 124745
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124745' 
    WHERE UPPER(TRIM(name)) = 'EE DONA FRANCISCA TAMM BIAS FORTES' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124745');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR EDMUNDO GOUVEA CARDILLO (POÇOS DE CALDAS) - INEP: 124877
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124877' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR EDMUNDO GOUVEA CARDILLO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124877');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOÃO EUGÊNIO DE ALMEIDA (POÇOS DE CALDAS) - INEP: 124729
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124729' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOÃO EUGÊNIO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124729');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO ESCOBAR (POÇOS DE CALDAS) - INEP: 124761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124761' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO ESCOBAR' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ARLINDO PEREIRA - CENTRO DE EDUCAÇÃO POLITÉCNICA (POÇOS DE CALDAS) - INEP: 124818
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124818' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ARLINDO PEREIRA - CENTRO DE EDUCAÇÃO POLITÉCNICA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124818');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ CASTRO DE ARAÚJO (POÇOS DE CALDAS) - INEP: 124923
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124923' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ CASTRO DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124923');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA CLEUSA LOVATO CALIARI (POÇOS DE CALDAS) - INEP: 124826
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124826' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CLEUSA LOVATO CALIARI' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124826');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARLOS MAGNO DE CARVALHO (SANTA RITA DE CALDAS) - INEP: 124974
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124974' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS MAGNO DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'SANTA RITA DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124974');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA RITA AMÉLIA DE CARVALHO (SANTA RITA DE CALDAS) - INEP: 124940
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124940' 
    WHERE UPPER(TRIM(name)) = 'EE DONA RITA AMÉLIA DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'SANTA RITA DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124940');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DIRETOR NELSON RODRIGUES (SERRANIA) - INEP: 125024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '125024' 
    WHERE UPPER(TRIM(name)) = 'EE DIRETOR NELSON RODRIGUES' 
      AND UPPER(TRIM(city)) = 'SERRANIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '125024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABRE CAMPO (ABRE CAMPO) - INEP: 258971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258971' 
    WHERE UPPER(TRIM(name)) = 'EE ABRE CAMPO' 
      AND UPPER(TRIM(city)) = 'ABRE CAMPO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM JOÃO BOSCO (ABRE CAMPO) - INEP: 128104
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128104' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOÃO BOSCO' 
      AND UPPER(TRIM(city)) = 'ABRE CAMPO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128104');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ERNESTO DE MELO BRANDÃO (ABRE CAMPO) - INEP: 128139
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128139' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ERNESTO DE MELO BRANDÃO' 
      AND UPPER(TRIM(city)) = 'ABRE CAMPO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128139');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO CARLOS (ALVINÓPOLIS) - INEP: 128252
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128252' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO CARLOS' 
      AND UPPER(TRIM(city)) = 'ALVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128252');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DESEMBARGADOR BARCELOS CORREA (ALVINÓPOLIS) - INEP: 128261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128261' 
    WHERE UPPER(TRIM(name)) = 'EE DESEMBARGADOR BARCELOS CORREA' 
      AND UPPER(TRIM(city)) = 'ALVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR CÂNDIDO GOMES (ALVINÓPOLIS) - INEP: 128244
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128244' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CÂNDIDO GOMES' 
      AND UPPER(TRIM(city)) = 'ALVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128244');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALFREDO DO CARMO (AMPARO DO SERRA) - INEP: 128279
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128279' 
    WHERE UPPER(TRIM(name)) = 'EE ALFREDO DO CARMO' 
      AND UPPER(TRIM(city)) = 'AMPARO DO SERRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128279');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO JOSÉ ERMELINDO DE SOUZA (ARAPONGA) - INEP: 128325
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128325' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO JOSÉ ERMELINDO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'ARAPONGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128325');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ DIAS DO CARMO (ARAPONGA) - INEP: 128341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128341' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ DIAS DO CARMO' 
      AND UPPER(TRIM(city)) = 'ARAPONGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ EPIFÂNIO GONÇALVES (BARRA LONGA) - INEP: 128414
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128414' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ EPIFÂNIO GONÇALVES' 
      AND UPPER(TRIM(city)) = 'BARRA LONGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128414');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAPITÃO ARNALDO DIAS ANDRADE (CAJURI) - INEP: 128449
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128449' 
    WHERE UPPER(TRIM(name)) = 'EE CAPITÃO ARNALDO DIAS ANDRADE' 
      AND UPPER(TRIM(city)) = 'CAJURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128449');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO LOPES SOARES (CANAÃ) - INEP: 128490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128490' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO LOPES SOARES' 
      AND UPPER(TRIM(city)) = 'CANAÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA APARECIDA DAVID (CANAÃ) - INEP: 233200
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233200' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA APARECIDA DAVID' 
      AND UPPER(TRIM(city)) = 'CANAÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233200');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO NEVES (DOM SILVÉRIO) - INEP: 128678
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128678' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'DOM SILVÉRIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128678');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AGOSTINHO HIPÓLITO DE F FREIRE (GUARACIABA) - INEP: 128694
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128694' 
    WHERE UPPER(TRIM(name)) = 'EE AGOSTINHO HIPÓLITO DE F FREIRE' 
      AND UPPER(TRIM(city)) = 'GUARACIABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128694');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HERMÓGENES FERREIRA DA SILVA (GUARACIABA) - INEP: 128732
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128732' 
    WHERE UPPER(TRIM(name)) = 'EE HERMÓGENES FERREIRA DA SILVA' 
      AND UPPER(TRIM(city)) = 'GUARACIABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128732');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ MATEUS DE VASCONCELOS (GUARACIABA) - INEP: 128716
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128716' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MATEUS DE VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'GUARACIABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128716');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE PISCAMBA (JEQUERI) - INEP: 128791
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128791' 
    WHERE UPPER(TRIM(name)) = 'EE DE PISCAMBA' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128791');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO GROTA (JEQUERI) - INEP: 128775
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128775' 
    WHERE UPPER(TRIM(name)) = 'EE DO GROTA' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128775');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE BENEVENUTO (JEQUERI) - INEP: 128741
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128741' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE BENEVENUTO' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128741');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO VICENTE DO GRAMA (JEQUERI) - INEP: 128821
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128821' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO VICENTE DO GRAMA' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128821');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TENENTE MOL (JEQUERI) - INEP: 128759
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128759' 
    WHERE UPPER(TRIM(name)) = 'EE TENENTE MOL' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128759');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR FRANCISCO VIEIRA MARTINS (ORATÓRIOS) - INEP: 129135
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129135' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR FRANCISCO VIEIRA MARTINS' 
      AND UPPER(TRIM(city)) = 'ORATÓRIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129135');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALFENO FRANCISCO DO CARMO (PEDRA BONITA) - INEP: 353825
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353825' 
    WHERE UPPER(TRIM(name)) = 'EE ALFENO FRANCISCO DO CARMO' 
      AND UPPER(TRIM(city)) = 'PEDRA BONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353825');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM OSCAR DE OLIVEIRA (PEDRA BONITA) - INEP: 128147
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128147' 
    WHERE UPPER(TRIM(name)) = 'EE DOM OSCAR DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PEDRA BONITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128147');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ALBINO LEAL (PEDRA DO ANTA) - INEP: 128856
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128856' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ALBINO LEAL' 
      AND UPPER(TRIM(city)) = 'PEDRA DO ANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128856');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL ANTONINHO (PIEDADE DE PONTE NOVA) - INEP: 128881
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128881' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ANTONINHO' 
      AND UPPER(TRIM(city)) = 'PIEDADE DE PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128881');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA VERA PARENTONI (PONTE NOVA) - INEP: 129127
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129127' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA VERA PARENTONI' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129127');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO COELHO (PONTE NOVA) - INEP: 338877
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338877' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO COELHO' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338877');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAETANO MARINHO (PONTE NOVA) - INEP: 128902
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128902' 
    WHERE UPPER(TRIM(name)) = 'EE CAETANO MARINHO' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128902');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARLOS TRIVELLATO (PONTE NOVA) - INEP: 128929
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128929' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS TRIVELLATO' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128929');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL CANTÍDIO DRUMOND (PONTE NOVA) - INEP: 128945
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128945' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL CANTÍDIO DRUMOND' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128945');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO GONÇALVES LANNA (PONTE NOVA) - INEP: 129062
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129062' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO GONÇALVES LANNA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129062');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR RAYMUNDO MARTINIANO FERREIRA (PONTE NOVA) - INEP: 129071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129071' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR RAYMUNDO MARTINIANO FERREIRA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SENADOR ANTÔNIO MARTINS (PONTE NOVA) - INEP: 129101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129101' 
    WHERE UPPER(TRIM(name)) = 'EE SENADOR ANTÔNIO MARTINS' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL AMANTINO (PORTO FIRME) - INEP: 310590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310590' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL AMANTINO' 
      AND UPPER(TRIM(city)) = 'PORTO FIRME' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310590');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IMACULADA CONCEIÇÃO (PORTO FIRME) - INEP: 129194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129194' 
    WHERE UPPER(TRIM(name)) = 'EE IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'PORTO FIRME' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC RÉCIO DE SOUZA RIBEIRO (RAUL SOARES) - INEP: 129241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129241' 
    WHERE UPPER(TRIM(name)) = 'CESEC RÉCIO DE SOUZA RIBEIRO' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBANO PIRES (RAUL SOARES) - INEP: 129283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129283' 
    WHERE UPPER(TRIM(name)) = 'EE ALBANO PIRES' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129283');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENEDITO VALADARES (RAUL SOARES) - INEP: 129224
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129224' 
    WHERE UPPER(TRIM(name)) = 'EE BENEDITO VALADARES' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129224');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM HELVÉCIO GOMES DE OLIVEIRA (RAUL SOARES) - INEP: 129259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129259' 
    WHERE UPPER(TRIM(name)) = 'EE DOM HELVÉCIO GOMES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR LUIZ MARTINS SOARES (RAUL SOARES) - INEP: 129305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129305' 
    WHERE UPPER(TRIM(name)) = 'EE DR LUIZ MARTINS SOARES' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129305');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO FELISBERTO DA COSTA (RAUL SOARES) - INEP: 129275
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129275' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO FELISBERTO DA COSTA' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129275');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JÚLIO MARIA (RAUL SOARES) - INEP: 129267
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129267' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JÚLIO MARIA' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129267');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE REGINA PACIS (RAUL SOARES) - INEP: 129313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129313' 
    WHERE UPPER(TRIM(name)) = 'EE REGINA PACIS' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IMACULADA CONCEIÇÃO (RIO CASCA) - INEP: 129381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129381' 
    WHERE UPPER(TRIM(name)) = 'EE IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA AMÉLIA (RIO DOCE) - INEP: 129437
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129437' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA AMÉLIA' 
      AND UPPER(TRIM(city)) = 'RIO DOCE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129437');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR OTÁVIO SOARES (SANTA CRUZ DO ESCALVADO) - INEP: 129461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129461' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR OTÁVIO SOARES' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DO ESCALVADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIANO GOMES (SANTO ANTÔNIO DO GRAMA) - INEP: 129534
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129534' 
    WHERE UPPER(TRIM(name)) = 'EE MARIANO GOMES' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO GRAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129534');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ DE ASSIS PINTO (SÃO MIGUEL DO ANTA) - INEP: 129551
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129551' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ DE ASSIS PINTO' 
      AND UPPER(TRIM(city)) = 'SÃO MIGUEL DO ANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129551');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO LESSA (SÃO MIGUEL DO ANTA) - INEP: 129585
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129585' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO LESSA' 
      AND UPPER(TRIM(city)) = 'SÃO MIGUEL DO ANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129585');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO LAJÃO (SÃO PEDRO DOS FERROS) - INEP: 129593
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129593' 
    WHERE UPPER(TRIM(name)) = 'EE DO LAJÃO' 
      AND UPPER(TRIM(city)) = 'SÃO PEDRO DOS FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129593');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OMAR REZENDE PEREZ (SÃO PEDRO DOS FERROS) - INEP: 129666
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129666' 
    WHERE UPPER(TRIM(name)) = 'EE OMAR REZENDE PEREZ' 
      AND UPPER(TRIM(city)) = 'SÃO PEDRO DOS FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129666');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SENADOR LEVINDO COELHO (SÃO PEDRO DOS FERROS) - INEP: 129658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129658' 
    WHERE UPPER(TRIM(name)) = 'EE SENADOR LEVINDO COELHO' 
      AND UPPER(TRIM(city)) = 'SÃO PEDRO DOS FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO SEBASTIÃO (SEM-PEIXE) - INEP: 128686
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128686' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'SEM-PEIXE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128686');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLÉLIA BERNARDES (SERICITA) - INEP: 129674
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129674' 
    WHERE UPPER(TRIM(name)) = 'EE CLÉLIA BERNARDES' 
      AND UPPER(TRIM(city)) = 'SERICITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129674');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO MOREIRA DE QUEIROZ (TEIXEIRAS) - INEP: 317420
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317420' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO MOREIRA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'TEIXEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317420');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR MARIANO DA ROCHA (TEIXEIRAS) - INEP: 129763
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129763' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR MARIANO DA ROCHA' 
      AND UPPER(TRIM(city)) = 'TEIXEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129763');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CUSTÓDIO MARTINS DA SILVA (URUCÂNIA) - INEP: 129801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129801' 
    WHERE UPPER(TRIM(name)) = 'EE CUSTÓDIO MARTINS DA SILVA' 
      AND UPPER(TRIM(city)) = 'URUCÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129801');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HELDER DE AQUINO (URUCÂNIA) - INEP: 129828
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129828' 
    WHERE UPPER(TRIM(name)) = 'EE HELDER DE AQUINO' 
      AND UPPER(TRIM(city)) = 'URUCÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129828');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANUEL RUFINO (URUCÂNIA) - INEP: 129836
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129836' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANUEL RUFINO' 
      AND UPPER(TRIM(city)) = 'URUCÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129836');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FARMACÊUTICO SOARES (VERMELHO NOVO) - INEP: 129321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129321' 
    WHERE UPPER(TRIM(name)) = 'EE FARMACÊUTICO SOARES' 
      AND UPPER(TRIM(city)) = 'VERMELHO NOVO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DOUTOR ALTAMIRO SARAIVA (VIÇOSA) - INEP: 259551
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259551' 
    WHERE UPPER(TRIM(name)) = 'CESEC DOUTOR ALTAMIRO SARAIVA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259551');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALICE LOUREIRO (VIÇOSA) - INEP: 130036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '130036' 
    WHERE UPPER(TRIM(name)) = 'EE ALICE LOUREIRO' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '130036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR RAIMUNDO ALVES TORRES (VIÇOSA) - INEP: 129992
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129992' 
    WHERE UPPER(TRIM(name)) = 'EE DR RAIMUNDO ALVES TORRES' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129992');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EFFIE ROLFS (VIÇOSA) - INEP: 129861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129861' 
    WHERE UPPER(TRIM(name)) = 'EE EFFIE ROLFS' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ LOURENÇO DE FREITAS (VIÇOSA) - INEP: 130044
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '130044' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ LOURENÇO DE FREITAS' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '130044');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ÁLVARO CORREA BORGES (VIÇOSA) - INEP: 129941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129941' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ÁLVARO CORREA BORGES' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAUL DE LEONI (VIÇOSA) - INEP: 217778
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217778' 
    WHERE UPPER(TRIM(name)) = 'EE RAUL DE LEONI' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217778');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTA RITA DE CÁSSIA (VIÇOSA) - INEP: 130001
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '130001' 
    WHERE UPPER(TRIM(name)) = 'EE SANTA RITA DE CÁSSIA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '130001');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ GOMES DE MORAIS FILHO (ALBERTINA) - INEP: 294705
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294705' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ GOMES DE MORAIS FILHO' 
      AND UPPER(TRIM(city)) = 'ALBERTINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294705');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VERNER GRINBERG (CAMANDUCAIA) - INEP: 342700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342700' 
    WHERE UPPER(TRIM(name)) = 'EE VERNER GRINBERG' 
      AND UPPER(TRIM(city)) = 'CAMANDUCAIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MENDES DE OLIVEIRA (CONGONHAL) - INEP: 124389
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124389' 
    WHERE UPPER(TRIM(name)) = 'EE MENDES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CONGONHAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124389');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO CELSO VIEIRA VILELA (HELIODORA) - INEP: 172766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172766' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO CELSO VIEIRA VILELA' 
      AND UPPER(TRIM(city)) = 'HELIODORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CRISTIANO MACHADO (IPUIÚNA) - INEP: 124460
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124460' 
    WHERE UPPER(TRIM(name)) = 'EE CRISTIANO MACHADO' 
      AND UPPER(TRIM(city)) = 'IPUIÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124460');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (POUSO ALEGRE) - INEP: 362280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362280' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (POUSO ALEGRE) - INEP: 372099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372099' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


