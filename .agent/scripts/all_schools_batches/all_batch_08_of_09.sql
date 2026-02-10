-- Lote 8 de 9
-- Escolas 3501 a 4000

-- INSTITUTO EDUCACIONAL MONTEIRO LOBATO (CONTAGEM) - INEP: 291811
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '291811' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '291811');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL NÍDIA ZENHA (CONTAGEM) - INEP: 269913
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269913' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL NÍDIA ZENHA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269913');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EROS GUSTAVO (CONTAGEM) - INEP: 236934
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236934' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EROS GUSTAVO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236934');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO HELENA FERNANDES (CONTAGEM) - INEP: 329452
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329452' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO HELENA FERNANDES' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329452');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PEDAGÓGICO TEREZA CRISTINA (CONTAGEM) - INEP: 229857
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229857' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PEDAGÓGICO TEREZA CRISTINA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229857');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PETILANDIA (CONTAGEM) - INEP: 365637
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365637' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PETILANDIA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365637');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTUTO EDUCACIONAL NOVOS TEMPOS (CONTAGEM) - INEP: 267007
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267007' 
    WHERE UPPER(TRIM(name)) = 'INSTUTO EDUCACIONAL NOVOS TEMPOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267007');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NEFC - NÚCLEO EDUCACIONAL FRANCISCA CAMPOS (CONTAGEM) - INEP: 278572
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278572' 
    WHERE UPPER(TRIM(name)) = 'NEFC - NÚCLEO EDUCACIONAL FRANCISCA CAMPOS' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278572');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO EDUCACIONAL BRAZ NETTO (CONTAGEM) - INEP: 277185
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277185' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO EDUCACIONAL BRAZ NETTO' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277185');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PROZ - UNIDADE CONTAGEM (CONTAGEM) - INEP: 377155
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377155' 
    WHERE UPPER(TRIM(name)) = 'PROZ - UNIDADE CONTAGEM' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377155');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- QUATRO ELEMENTOS/ SÍTIO ESCOLA (CONTAGEM) - INEP: 347612
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347612' 
    WHERE UPPER(TRIM(name)) = 'QUATRO ELEMENTOS/ SÍTIO ESCOLA' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347612');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SEBRAE- ESCOLA DE FORMAÇÃO GERENCIAL - CONTAGEM (CONTAGEM) - INEP: 262382
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262382' 
    WHERE UPPER(TRIM(name)) = 'SEBRAE- ESCOLA DE FORMAÇÃO GERENCIAL - CONTAGEM' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262382');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SEMEAR SCHOLL (CONTAGEM) - INEP: 333700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333700' 
    WHERE UPPER(TRIM(name)) = 'SEMEAR SCHOLL' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL EUVALDO LODI (CONTAGEM) - INEP: 267767
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267767' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL EUVALDO LODI' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267767');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE TREINAMENTO E DESENVOLVIMENTO DA INDÚSTRIA 4.0 (CONTAGEM) - INEP: 380610
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380610' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE TREINAMENTO E DESENVOLVIMENTO DA INDÚSTRIA 4.0' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380610');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CONTAGEM CENTRO DE FORMAÇÃO PROFISSIONAL ALVIMAR CARNEIRO DE REZENDE (CONTAGEM) - INEP: 357189
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357189' 
    WHERE UPPER(TRIM(name)) = 'SENAI CONTAGEM CENTRO DE FORMAÇÃO PROFISSIONAL ALVIMAR CARNEIRO DE REZENDE' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357189');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AVANCE (ESMERALDAS) - INEP: 342505
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342505' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AVANCE' 
      AND UPPER(TRIM(city)) = 'ESMERALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342505');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BANDEIRAS (IBIRITÉ) - INEP: 340855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340855' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BANDEIRAS' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRESCER BUSCAR E MULTIPLICAR - CCBM (IBIRITÉ) - INEP: 349380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349380' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRESCER BUSCAR E MULTIPLICAR - CCBM' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRISTÃO PREPARANDO PARA O FUTURO (IBIRITÉ) - INEP: 362670
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362670' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRISTÃO PREPARANDO PARA O FUTURO' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362670');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ORDEM E PROGRESSO (IBIRITÉ) - INEP: 313521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313521' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ORDEM E PROGRESSO' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO CULTURAL SEMPRE JATOBÁ (IBIRITÉ) - INEP: 293202
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293202' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO CULTURAL SEMPRE JATOBÁ' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293202');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL ANA CATARINA (IBIRITÉ) - INEP: 340847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340847' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL ANA CATARINA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL CASTRO ALVES (IBIRITÉ) - INEP: 237043
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237043' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL CASTRO ALVES' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237043');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI IBIRITÉ CENTRO DE FORMAÇÃO PROFISSIONAL PROFESSORA IRENE DE MELO PINHEIRO (IBIRITÉ) - INEP: 358851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358851' 
    WHERE UPPER(TRIM(name)) = 'SENAI IBIRITÉ CENTRO DE FORMAÇÃO PROFISSIONAL PROFESSORA IRENE DE MELO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358851');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TEIXEIRA NETO (IGARAPÉ) - INEP: 343790
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343790' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TEIXEIRA NETO' 
      AND UPPER(TRIM(city)) = 'IGARAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343790');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRESCER (IGARAPÉ) - INEP: 310107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310107' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRESCER' 
      AND UPPER(TRIM(city)) = 'IGARAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310107');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRISTÃ VERBO VIVO (SÃO JOAQUIM DE BICAS) - INEP: 322202
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322202' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRISTÃ VERBO VIVO' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322202');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA DE ENSINO LUCAS NUNES (SÃO JOAQUIM DE BICAS) - INEP: 323845
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323845' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA DE ENSINO LUCAS NUNES' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323845');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MATTER (SARZEDO) - INEP: 327263
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327263' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MATTER' 
      AND UPPER(TRIM(city)) = 'SARZEDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327263');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  CENTRO EDUCACIONAL NOVO PROGRESSO (BELO HORIZONTE) - INEP: 325317
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325317' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NOVO PROGRESSO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325317');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- AQUARELA CENTRO DE EDUCAÇÃO (BELO HORIZONTE) - INEP: 329541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329541' 
    WHERE UPPER(TRIM(name)) = 'AQUARELA CENTRO DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO ELO (BELO HORIZONTE) - INEP: 332020
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332020' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO ELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332020');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO MÚLTIPLA (BELO HORIZONTE) - INEP: 350184
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350184' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO MÚLTIPLA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350184');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO PROFISSIONAL FILADÉLFIA (BELO HORIZONTE) - INEP: 319961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319961' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO PROFISSIONAL FILADÉLFIA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ICM (BELO HORIZONTE) - INEP: 297798
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297798' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ICM' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297798');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL SÃO BENTO (BELO HORIZONTE) - INEP: 378321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378321' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL SÃO BENTO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CHROMOS PAMPULHA (BELO HORIZONTE) - INEP: 290157
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '290157' 
    WHERE UPPER(TRIM(name)) = 'COL CHROMOS PAMPULHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '290157');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CHROMOS PAMPULHA - UNIDADE II (BELO HORIZONTE) - INEP: 377775
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377775' 
    WHERE UPPER(TRIM(name)) = 'COL CHROMOS PAMPULHA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377775');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CHROMOS VENDA NOVA (BELO HORIZONTE) - INEP: 246468
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246468' 
    WHERE UPPER(TRIM(name)) = 'COL CHROMOS VENDA NOVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246468');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALCEU COTTA - UNIDADE JARDIM ATLÂNTICO (BELO HORIZONTE) - INEP: 380342
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380342' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALCEU COTTA - UNIDADE JARDIM ATLÂNTICO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380342');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALCEU COTTA - UNIDADE SANTA BRANCA (BELO HORIZONTE) - INEP: 325554
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325554' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALCEU COTTA - UNIDADE SANTA BRANCA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325554');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÂNGULO (BELO HORIZONTE) - INEP: 370266
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370266' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÂNGULO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370266');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APRIMORAR (BELO HORIZONTE) - INEP: 341002
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '341002' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APRIMORAR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '341002');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA GETSÊMANI (BELO HORIZONTE) - INEP: 218529
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218529' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA GETSÊMANI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218529');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO - UNIDADE CASTELO (BELO HORIZONTE) - INEP: 370231
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370231' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO - UNIDADE CASTELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370231');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CAVALIERI (BELO HORIZONTE) - INEP: 316580
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316580' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CAVALIERI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316580');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COPBH - UNIDADE II (BELO HORIZONTE) - INEP: 362417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362417' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COPBH - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRISTÃO EFIGÊNIA TOBIAS (BELO HORIZONTE) - INEP: 309753
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309753' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRISTÃO EFIGÊNIA TOBIAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309753');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DONA CLARA (BELO HORIZONTE) - INEP: 246051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246051' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DONA CLARA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DONA CLARA - UNIDADE 2 (BELO HORIZONTE) - INEP: 379832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379832' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DONA CLARA - UNIDADE 2' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ECCELLENTE  - UNIDADE PAMPULHA (BELO HORIZONTE) - INEP: 355143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355143' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ECCELLENTE - UNIDADE PAMPULHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO HELENA BICALHO (BELO HORIZONTE) - INEP: 220353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220353' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO HELENA BICALHO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220353');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTER AÇÃO (BELO HORIZONTE) - INEP: 220345
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220345' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTER AÇÃO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220345');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTER AÇÃO UNID II (BELO HORIZONTE) - INEP: 332780
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332780' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTER AÇÃO UNID II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332780');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO M2 - BH (BELO HORIZONTE) - INEP: 368300
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368300' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO M2 - BH' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368300');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAXIMUS UNIDADE OURO PRETO/CASTELO (BELO HORIZONTE) - INEP: 361089
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361089' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAXIMUS UNIDADE OURO PRETO/CASTELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361089');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PAULO FREIRE (BELO HORIZONTE) - INEP: 297712
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297712' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297712');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO REFERÊNCIA (BELO HORIZONTE) - INEP: 339636
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339636' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO REFERÊNCIA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339636');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO RUI BARBOSA - UNIDADE II (BELO HORIZONTE) - INEP: 350648
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350648' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO RUI BARBOSA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350648');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA AMÉLIA - UNIDADE II (BELO HORIZONTE) - INEP: 361658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361658' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA AMÉLIA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA AMÉLIA-UNIDADE I (BELO HORIZONTE) - INEP: 333670
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333670' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA AMÉLIA-UNIDADE I' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333670');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM -  UNIDADE OURO PRETO I (BELO HORIZONTE) - INEP: 217123
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217123' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE OURO PRETO I' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217123');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM- UNIDADE OURO PRETO II (BELO HORIZONTE) - INEP: 351725
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351725' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM- UNIDADE OURO PRETO II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351725');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM UNIDADE SANTA AMÉLIA (BELO HORIZONTE) - INEP: 322873
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322873' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM UNIDADE SANTA AMÉLIA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322873');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCAR CENTRO EDUCACIONAL PEDAGÓGICO (BELO HORIZONTE) - INEP: 298158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298158' 
    WHERE UPPER(TRIM(name)) = 'EDUCAR CENTRO EDUCACIONAL PEDAGÓGICO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ADVENTISTA DA PAMPULHA (BELO HORIZONTE) - INEP: 376043
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376043' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ADVENTISTA DA PAMPULHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376043');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CASA FUNDAMENTAL (BELO HORIZONTE) - INEP: 369780
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369780' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CASA FUNDAMENTAL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369780');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM DO HOSPITAL EVANGÉLICO (BELO HORIZONTE) - INEP: 274861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274861' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM DO HOSPITAL EVANGÉLICO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA EDUCAR - UNIDADE II (BELO HORIZONTE) - INEP: 365874
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365874' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA EDUCAR - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365874');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA EDUCAR -UNIDADE I (BELO HORIZONTE) - INEP: 210200
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210200' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA EDUCAR -UNIDADE I' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210200');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ENSINANDO - PÓLO PAMPULHA (BELO HORIZONTE) - INEP: 363235
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363235' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ENSINANDO - PÓLO PAMPULHA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363235');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA HUB SÃO LUIZ (BELO HORIZONTE) - INEP: 378992
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378992' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA HUB SÃO LUIZ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378992');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MIGUEL ARCANJO WALDORF (BELO HORIZONTE) - INEP: 353582
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353582' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MIGUEL ARCANJO WALDORF' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353582');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA TECNOTÓRIOS (BELO HORIZONTE) - INEP: 372340
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372340' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA TECNOTÓRIOS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372340');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOTEC - ESCOLA TÉCNICA FAMINAS - BH (BELO HORIZONTE) - INEP: 353540
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353540' 
    WHERE UPPER(TRIM(name)) = 'ESCOTEC - ESCOLA TÉCNICA FAMINAS - BH' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353540');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO VENDA NOVA (BELO HORIZONTE) - INEP: 375373
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375373' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO VENDA NOVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375373');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO CECÍLIA MEIRELES - UNIDADE CASTELO (BELO HORIZONTE) - INEP: 372455
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372455' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO CECÍLIA MEIRELES - UNIDADE CASTELO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372455');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL ARCO ÍRIS (BELO HORIZONTE) - INEP: 344796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344796' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL ARCO ÍRIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL EVANGÉLICO MONTE SIÃO (BELO HORIZONTE) - INEP: 246077
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246077' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL EVANGÉLICO MONTE SIÃO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246077');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MANOEL PINHEIRO (BELO HORIZONTE) - INEP: 217263
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217263' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MANOEL PINHEIRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217263');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MISSÃO PAZ (BELO HORIZONTE) - INEP: 340391
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340391' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MISSÃO PAZ' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340391');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL RIO BRANCO (BELO HORIZONTE) - INEP: 270024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '270024' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL RIO BRANCO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '270024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SARAMENHA IESA (BELO HORIZONTE) - INEP: 327581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327581' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SARAMENHA IESA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EMÍLIA FERREIRO (BELO HORIZONTE) - INEP: 294039
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294039' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EMÍLIA FERREIRO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294039');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO NACIONAL DE EDUCAÇÃO TECNOLÓGICA HEILER ALVES DA ROCHA-INET-HAR (BELO HORIZONTE) - INEP: 358444
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358444' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO NACIONAL DE EDUCAÇÃO TECNOLÓGICA HEILER ALVES DA ROCHA-INET-HAR' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358444');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PE ANGÉLICO LIPÁNI (BELO HORIZONTE) - INEP: 210285
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210285' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PE ANGÉLICO LIPÁNI' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210285');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PEDAGÓGICO GÊNESIS (BELO HORIZONTE) - INEP: 329151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329151' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PEDAGÓGICO GÊNESIS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- REDE M2 - VENDA NOVA (BELO HORIZONTE) - INEP: 375233
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375233' 
    WHERE UPPER(TRIM(name)) = 'REDE M2 - VENDA NOVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375233');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC - CENTRO DE EDUCAÇÃO PROFISSIONAL VENDA NOVA (BELO HORIZONTE) - INEP: 366781
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366781' 
    WHERE UPPER(TRIM(name)) = 'SENAC - CENTRO DE EDUCAÇÃO PROFISSIONAL VENDA NOVA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366781');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAT SERVIÇO NACIONAL DE APRENDIZAGEM DO TRANSPORTE - ESCOLA DE AVIAÇÃO CIVIL (BELO HORIZONTE) - INEP: 337323
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '337323' 
    WHERE UPPER(TRIM(name)) = 'SENAT SERVIÇO NACIONAL DE APRENDIZAGEM DO TRANSPORTE - ESCOLA DE AVIAÇÃO CIVIL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '337323');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA DE ENSINO VOVÔ GRILO (BELO HORIZONTE) - INEP: 261840
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261840' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA DE ENSINO VOVÔ GRILO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261840');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA MASTER DE ENSINO (BELO HORIZONTE) - INEP: 279901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279901' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA MASTER DE ENSINO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- STELLA ESCOLA INFANTIL (BELO HORIZONTE) - INEP: 309141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309141' 
    WHERE UPPER(TRIM(name)) = 'STELLA ESCOLA INFANTIL' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- C DE DESENV EDUC VEM SER (JABOTICATUBAS) - INEP: 322440
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322440' 
    WHERE UPPER(TRIM(name)) = 'C DE DESENV EDUC VEM SER' 
      AND UPPER(TRIM(city)) = 'JABOTICATUBAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322440');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CHROMOS LAGOA SANTA (LAGOA SANTA) - INEP: 216003
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '216003' 
    WHERE UPPER(TRIM(name)) = 'COL CHROMOS LAGOA SANTA' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '216003');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EBENÉZER (LAGOA SANTA) - INEP: 279251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279251' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EBENÉZER' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO M2 (LAGOA SANTA) - INEP: 344176
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344176' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO M2' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344176');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO YUGEN (LAGOA SANTA) - INEP: 371688
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371688' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO YUGEN' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371688');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE LAGOA SANTA (LAGOA SANTA) - INEP: 254886
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254886' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE LAGOA SANTA' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254886');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA IPÊ AMARELO (LAGOA SANTA) - INEP: 353612
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353612' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA IPÊ AMARELO' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353612');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NINHO (LAGOA SANTA) - INEP: 379999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379999' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NINHO' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PALOMAR DE LAGOA SANTA (LAGOA SANTA) - INEP: 331511
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331511' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PALOMAR DE LAGOA SANTA' 
      AND UPPER(TRIM(city)) = 'LAGOA SANTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331511');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ALVO ESCOLA DE SAÚDE (PEDRO LEOPOLDO) - INEP: 378968
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378968' 
    WHERE UPPER(TRIM(name)) = 'ALVO ESCOLA DE SAÚDE' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378968');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CLITA BATISTA (PEDRO LEOPOLDO) - INEP: 211974
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '211974' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CLITA BATISTA' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '211974');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO M2 - PEDRO LEOPOLDO (PEDRO LEOPOLDO) - INEP: 376191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376191' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO M2 - PEDRO LEOPOLDO' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE FORMAÇÃO GERENCIAL - FPL -THEOTÔNIO BAPTISTA DE FREITAS (PEDRO LEOPOLDO) - INEP: 253901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253901' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE FORMAÇÃO GERENCIAL - FPL -THEOTÔNIO BAPTISTA DE FREITAS' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI  MARIA JOSÉ D'ALMEIDA MELLO (PEDRO LEOPOLDO) - INEP: 279129
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279129' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI MARIA JOSÉ D''ALMEIDA MELLO' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279129');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL GÉRSON DIAS (PEDRO LEOPOLDO) - INEP: 259403
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259403' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL GÉRSON DIAS' 
      AND UPPER(TRIM(city)) = 'PEDRO LEOPOLDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259403');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL GETSÊMANI (RIBEIRÃO DAS NEVES) - INEP: 349160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349160' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL GETSÊMANI' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL IMACULADA CONCEIÇÃO (RIBEIRÃO DAS NEVES) - INEP: 362441
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362441' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362441');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIVERSO (RIBEIRÃO DAS NEVES) - INEP: 351717
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351717' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIVERSO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351717');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MARIA CLARA MACHADO (RIBEIRÃO DAS NEVES) - INEP: 321591
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321591' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MARIA CLARA MACHADO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321591');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DIVINA PROVIDÊNCIA (RIBEIRÃO DAS NEVES) - INEP: 334111
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334111' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DIVINA PROVIDÊNCIA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334111');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GPA-GESTORES PRISIONAIS ASSOCIADOS (RIBEIRÃO DAS NEVES) - INEP: 355364
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355364' 
    WHERE UPPER(TRIM(name)) = 'GPA-GESTORES PRISIONAIS ASSOCIADOS' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355364');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL DOM BOSCO (RIBEIRÃO DAS NEVES) - INEP: 215813
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215813' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215813');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL EL SHADAI (RIBEIRÃO DAS NEVES) - INEP: 326194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326194' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL EL SHADAI' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO METHA (RIBEIRÃO DAS NEVES) - INEP: 323021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323021' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO METHA' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NOVA VISÃO (RIBEIRÃO DAS NEVES) - INEP: 334022
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334022' 
    WHERE UPPER(TRIM(name)) = 'NOVA VISÃO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334022');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- REDE DE ENSINO GÊNESIS (RIBEIRÃO DAS NEVES) - INEP: 253936
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253936' 
    WHERE UPPER(TRIM(name)) = 'REDE DE ENSINO GÊNESIS' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253936');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA NOVO ENSINO (RIBEIRÃO DAS NEVES) - INEP: 313513
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313513' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA NOVO ENSINO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313513');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA BETESDA (SANTA LUZIA) - INEP: 262528
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262528' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA BETESDA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262528');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRAMER (SANTA LUZIA) - INEP: 260487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260487' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRAMER' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAXIMUS (SANTA LUZIA) - INEP: 316059
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316059' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAXIMUS' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316059');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MONSENHOR  D'AMATO (SANTA LUZIA) - INEP: 316067
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316067' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MONSENHOR D''AMATO' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316067');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO BENEDITO- UNIDADE I (SANTA LUZIA) - INEP: 212067
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212067' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO BENEDITO- UNIDADE I' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212067');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO BENEDITO- UNIDADE II (SANTA LUZIA) - INEP: 349399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349399' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO BENEDITO- UNIDADE II' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONHECER ESCOLA TÉCNICA - UNIDADE III (SANTA LUZIA) - INEP: 371106
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371106' 
    WHERE UPPER(TRIM(name)) = 'CONHECER ESCOLA TÉCNICA - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371106');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI JOÃO CARLOS GIOVANNINI (SANTA LUZIA) - INEP: 309796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309796' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI JOÃO CARLOS GIOVANNINI' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL LONDRINA (SANTA LUZIA) - INEP: 261327
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261327' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL LONDRINA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261327');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL RACIONAL (SANTA LUZIA) - INEP: 211958
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '211958' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL RACIONAL' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '211958');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SANTA AMÉLIA (SANTA LUZIA) - INEP: 215830
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215830' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SANTA AMÉLIA' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215830');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI SANTA LUZIA CFP JOÃO CARLOS GIOVANNINI (SANTA LUZIA) - INEP: 360317
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '360317' 
    WHERE UPPER(TRIM(name)) = 'SENAI SANTA LUZIA CFP JOÃO CARLOS GIOVANNINI' 
      AND UPPER(TRIM(city)) = 'SANTA LUZIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '360317');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTEP -  CENTRO TECNOLÓGICO E FORMAÇÃO PROFISSIONAL (VESPASIANO) - INEP: 331414
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331414' 
    WHERE UPPER(TRIM(name)) = 'CENTEP - CENTRO TECNOLÓGICO E FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331414');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ATIVIDADES DO TRABALHADOR ANTONIO QUIRINO DA COSTA (VESPASIANO) - INEP: 345857
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345857' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ATIVIDADES DO TRABALHADOR ANTONIO QUIRINO DA COSTA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345857');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL DE VESPASIANO (VESPASIANO) - INEP: 345938
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345938' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL DE VESPASIANO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345938');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO M2 - VESPASIANO (VESPASIANO) - INEP: 371742
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371742' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO M2 - VESPASIANO' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371742');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENFERMAGEM SANTA CLARA (VESPASIANO) - INEP: 312240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312240' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENFERMAGEM SANTA CLARA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI ANTÔNIO QUIRINO DA COSTA (VESPASIANO) - INEP: 274089
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274089' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI ANTÔNIO QUIRINO DA COSTA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274089');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÔMEGA (COROMANDEL) - INEP: 346934
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346934' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÔMEGA' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346934');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL DE COROMANDEL INEC (COROMANDEL) - INEP: 317764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317764' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL DE COROMANDEL INEC' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE  ENSINO TECNICO - CFP COROMANDEL (COROMANDEL) - INEP: 329894
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329894' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE ENSINO TECNICO - CFP COROMANDEL' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329894');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO PROFISSIONAL ALPHA (MONTE CARMELO) - INEP: 326917
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326917' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO PROFISSIONAL ALPHA' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326917');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL N SRA DO AMPARO (MONTE CARMELO) - INEP: 202100
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202100' 
    WHERE UPPER(TRIM(name)) = 'COL N SRA DO AMPARO' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202100');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EXCELÊNCIA (BOCAIÚVA) - INEP: 314854
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314854' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EXCELÊNCIA' 
      AND UPPER(TRIM(city)) = 'BOCAIÚVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314854');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO E CULTURA DE BOCAIÚVA (BOCAIÚVA) - INEP: 344761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344761' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO E CULTURA DE BOCAIÚVA' 
      AND UPPER(TRIM(city)) = 'BOCAIÚVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEDULC CENTRO EDUCACIONAL E LABORATORIO DE CULTURA (BRASÍLIA DE MINAS) - INEP: 247341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247341' 
    WHERE UPPER(TRIM(name)) = 'CEDULC CENTRO EDUCACIONAL E LABORATORIO DE CULTURA' 
      AND UPPER(TRIM(city)) = 'BRASÍLIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÓLIDO - UNIDADE BRASÍLIA DE MINAS (BRASÍLIA DE MINAS) - INEP: 368318
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368318' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÓLIDO - UNIDADE BRASÍLIA DE MINAS' 
      AND UPPER(TRIM(city)) = 'BRASÍLIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368318');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO GÊNESIS (BRASÍLIA DE MINAS) - INEP: 347604
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347604' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO GÊNESIS' 
      AND UPPER(TRIM(city)) = 'BRASÍLIA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347604');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL OSVALDO VICINTIN (CAPITÃO ENÉAS) - INEP: 316989
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316989' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL OSVALDO VICINTIN' 
      AND UPPER(TRIM(city)) = 'CAPITÃO ENÉAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316989');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CORJESUS (CORAÇÃO DE JESUS) - INEP: 339679
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339679' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CORJESUS' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339679');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIRÂMIDE (FRANCISCO SÁ) - INEP: 321966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321966' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIRÂMIDE' 
      AND UPPER(TRIM(city)) = 'FRANCISCO SÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321966');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- C EDUC COTEMINAS (MONTES CLAROS) - INEP: 274291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274291' 
    WHERE UPPER(TRIM(name)) = 'C EDUC COTEMINAS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- C PEDAG ALEGRIA DE VIVER (MONTES CLAROS) - INEP: 293474
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293474' 
    WHERE UPPER(TRIM(name)) = 'C PEDAG ALEGRIA DE VIVER' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293474');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO GRAU TÉCNICO MONTES CLAROS (MONTES CLAROS) - INEP: 376477
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376477' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO GRAU TÉCNICO MONTES CLAROS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376477');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ÍMPAR (MONTES CLAROS) - INEP: 213845
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213845' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ÍMPAR' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213845');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MENDES E SANTOS (MONTES CLAROS) - INEP: 222259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222259' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MENDES E SANTOS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PIONEIRO (MONTES CLAROS) - INEP: 322326
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322326' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PIONEIRO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322326');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL BATISTA NOVA CANAÃ (MONTES CLAROS) - INEP: 249696
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249696' 
    WHERE UPPER(TRIM(name)) = 'COL BATISTA NOVA CANAÃ' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249696');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL SÃO MATEUS (MONTES CLAROS) - INEP: 248975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248975' 
    WHERE UPPER(TRIM(name)) = 'COL SÃO MATEUS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BIOMÁXIMO - UNIDADE II (MONTES CLAROS) - INEP: 365920
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365920' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BIOMÁXIMO - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365920');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRISTÃO (MONTES CLAROS) - INEP: 322822
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322822' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRISTÃO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322822');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO HG6 (MONTES CLAROS) - INEP: 371750
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371750' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO HG6' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371750');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÍCONE (MONTES CLAROS) - INEP: 299693
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299693' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÍCONE' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299693');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MÁXIMMUS (MONTES CLAROS) - INEP: 378151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378151' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MÁXIMMUS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PODIUM MONTES CLAROS (MONTES CLAROS) - INEP: 364223
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364223' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PODIUM MONTES CLAROS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364223');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÓLIDO - UNIDADE SÃO JOSÉ (MONTES CLAROS) - INEP: 367710
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367710' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÓLIDO - UNIDADE SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367710');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÓLIDO MÉDIO (MONTES CLAROS) - INEP: 346209
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346209' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÓLIDO MÉDIO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346209');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÓLIDO TEENS (MONTES CLAROS) - INEP: 369934
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369934' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÓLIDO TEENS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369934');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VITÓRIA (MONTES CLAROS) - INEP: 312932
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312932' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VITÓRIA' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312932');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLLEGIUM PRISMA (MONTES CLAROS) - INEP: 260541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260541' 
    WHERE UPPER(TRIM(name)) = 'COLLEGIUM PRISMA' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE EDUCAÇÃO PROFISSIONAL IBITURUNA - EEPI (MONTES CLAROS) - INEP: 348350
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348350' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE EDUCAÇÃO PROFISSIONAL IBITURUNA - EEPI' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348350');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ÍMPETO DO SABER (MONTES CLAROS) - INEP: 356263
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356263' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ÍMPETO DO SABER' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356263');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EXCELÊNCIA TÉCNICOS (MONTES CLAROS) - INEP: 348465
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348465' 
    WHERE UPPER(TRIM(name)) = 'EXCELÊNCIA TÉCNICOS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348465');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EXCELÊNCIA TÉCNICOS - UNIDADE II (MONTES CLAROS) - INEP: 366641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366641' 
    WHERE UPPER(TRIM(name)) = 'EXCELÊNCIA TÉCNICOS - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IESC INSTITUTO EDUCACIONAL SANTA CRUZ (MONTES CLAROS) - INEP: 348473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348473' 
    WHERE UPPER(TRIM(name)) = 'IESC INSTITUTO EDUCACIONAL SANTA CRUZ' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO QUALIFICAR (MONTES CLAROS) - INEP: 358070
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358070' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO QUALIFICAR' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358070');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO MONTESCLARENSE DE EDUCAÇÃO E DESENVOLVIMENTO (MONTES CLAROS) - INEP: 372331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372331' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO MONTESCLARENSE DE EDUCAÇÃO E DESENVOLVIMENTO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PROZ EDUCAÇÃO PROFISSIONAL - UNIDADE MONTES CLAROS (MONTES CLAROS) - INEP: 380997
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380997' 
    WHERE UPPER(TRIM(name)) = 'PROZ EDUCAÇÃO PROFISSIONAL - UNIDADE MONTES CLAROS' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380997');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC- CENTRO DE FORMAÇÃO PROFISSIONAL (MONTES CLAROS) - INEP: 316130
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316130' 
    WHERE UPPER(TRIM(name)) = 'SENAC- CENTRO DE FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316130');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI- CENTRO DE FORMAÇÃO PROFISSIONAL LUIZ DE PAULA (MONTES CLAROS) - INEP: 317691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317691' 
    WHERE UPPER(TRIM(name)) = 'SENAI- CENTRO DE FORMAÇÃO PROFISSIONAL LUIZ DE PAULA' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA DE ENSINO FOCO (MONTES CLAROS) - INEP: 370100
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370100' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA DE ENSINO FOCO' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370100');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RENASCER (MIRAÍ) - INEP: 352071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352071' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RENASCER' 
      AND UPPER(TRIM(city)) = 'MIRAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CECAP- CENTRO DE CAPACITAÇÃO PROFISSIONAL (MURIAÉ) - INEP: 278866
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278866' 
    WHERE UPPER(TRIM(name)) = 'CECAP- CENTRO DE CAPACITAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278866');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EQUIPE DE MURIAÉ (MURIAÉ) - INEP: 305847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305847' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EQUIPE DE MURIAÉ' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÔMEGA (MURIAÉ) - INEP: 377899
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377899' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÔMEGA' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377899');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA MARCELINA (MURIAÉ) - INEP: 102539
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102539' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA MARCELINA' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102539');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCANDARIO BATISTA DE MURIAÉ (MURIAÉ) - INEP: 288225
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '288225' 
    WHERE UPPER(TRIM(name)) = 'EDUCANDARIO BATISTA DE MURIAÉ' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '288225');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SÃO PAULO (MURIAÉ) - INEP: 102563
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102563' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SÃO PAULO' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102563');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL LUZ SUBLIME (BELA VISTA DE MINAS) - INEP: 321800
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321800' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL LUZ SUBLIME' 
      AND UPPER(TRIM(city)) = 'BELA VISTA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321800');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- BIOTEC – CENTRO DE EDUCAÇÃO (ITABIRA) - INEP: 326879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326879' 
    WHERE UPPER(TRIM(name)) = 'BIOTEC – CENTRO DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL AMIGUINHOS DA MÔNICA (ITABIRA) - INEP: 301311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '301311' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL AMIGUINHOS DA MÔNICA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '301311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CAMPOS (ITABIRA) - INEP: 352365
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352365' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CAMPOS' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352365');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ROBERTO PORTO - UNID VII (ITABIRA) - INEP: 339300
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339300' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ROBERTO PORTO - UNID VII' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339300');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AUGE (ITABIRA) - INEP: 361496
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361496' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AUGE' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361496');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CESE  - UNIDADE II (ITABIRA) - INEP: 377767
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377767' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CESE - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377767');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COMERCIAL ITABIRANO (ITABIRA) - INEP: 105899
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105899' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COMERCIAL ITABIRANO' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105899');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DE ENSINO TÉCNICO BRASILEIRO EDUCACIONAL (ITABIRA) - INEP: 375764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375764' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DE ENSINO TÉCNICO BRASILEIRO EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DAS DORES (ITABIRA) - INEP: 105902
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105902' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DAS DORES' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105902');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SUPER MAIS (ITABIRA) - INEP: 368113
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368113' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SUPER MAIS' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368113');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA CURSO NOBRE - ITABIRA (ITABIRA) - INEP: 363766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363766' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA CURSO NOBRE - ITABIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE FORMAÇÃO GERENCIAL - ITABIRA (ITABIRA) - INEP: 246000
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246000' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE FORMAÇÃO GERENCIAL - ITABIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246000');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA FIDE (ITABIRA) - INEP: 317730
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317730' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA FIDE' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317730');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO BRASILEIRO DE INOVAÇÃO E SUSTENTABILIDADE - IBIS (ITABIRA) - INEP: 349240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349240' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO BRASILEIRO DE INOVAÇÃO E SUSTENTABILIDADE - IBIS' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC- INIDADE DE ENSINO TÉCNICO - CFP DE ITABIRA (ITABIRA) - INEP: 342939
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342939' 
    WHERE UPPER(TRIM(name)) = 'SENAC- INIDADE DE ENSINO TÉCNICO - CFP DE ITABIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342939');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL PEDRO MARTINS GUERRA (ITABIRA) - INEP: 322041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322041' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL PEDRO MARTINS GUERRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SEPRO- SISTEMA DE EDUCAÇÃO PROFISSIONAL DE ITABIRA (ITABIRA) - INEP: 293181
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293181' 
    WHERE UPPER(TRIM(name)) = 'SEPRO- SISTEMA DE EDUCAÇÃO PROFISSIONAL DE ITABIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293181');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ASSOCIAÇÃO MONLEVADENSE DE ENSINO COOPER (JOÃO MONLEVADE) - INEP: 105961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105961' 
    WHERE UPPER(TRIM(name)) = 'ASSOCIAÇÃO MONLEVADENSE DE ENSINO COOPER' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEBRAC CENTRO DE ENSINO BRASILEIRO E FORMAÇÃO PROFISSIONAL (JOÃO MONLEVADE) - INEP: 345504
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345504' 
    WHERE UPPER(TRIM(name)) = 'CEBRAC CENTRO DE ENSINO BRASILEIRO E FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345504');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ROBERTO PORTO (JOÃO MONLEVADE) - INEP: 317853
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317853' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ROBERTO PORTO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317853');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ROBERTO PORTO - UNIDADE V (JOÃO MONLEVADE) - INEP: 333212
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333212' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ROBERTO PORTO - UNIDADE V' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333212');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ROBERTO PORTO UNIDADE II (JOÃO MONLEVADE) - INEP: 325546
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325546' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ROBERTO PORTO UNIDADE II' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325546');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CESP (JOÃO MONLEVADE) - INEP: 281298
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281298' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CESP' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281298');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO KENNEDY (JOÃO MONLEVADE) - INEP: 105953
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105953' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO KENNEDY' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105953');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CTM - CENTRO TÉCNICO MUNDIAL (JOÃO MONLEVADE) - INEP: 373265
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373265' 
    WHERE UPPER(TRIM(name)) = 'CTM - CENTRO TÉCNICO MUNDIAL' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373265');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL NANSEN ARAÚJO (JOÃO MONLEVADE) - INEP: 317322
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317322' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL NANSEN ARAÚJO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317322');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOVAERENSE (NOVA ERA) - INEP: 105970
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '105970' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOVAERENSE' 
      AND UPPER(TRIM(city)) = 'NOVA ERA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '105970');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ FERNANDO COURA (SÃO GONÇALO DO RIO ABAIXO) - INEP: 347108
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347108' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ FERNANDO COURA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO RIO ABAIXO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347108');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA PAULO FREIRE (ACAIACA) - INEP: 328031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '328031' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'ACAIACA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '328031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO TÉCNICO SÃO CARLOS (ITABIRITO) - INEP: 325945
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325945' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO TÉCNICO SÃO CARLOS' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325945');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIPAC (ITABIRITO) - INEP: 372293
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372293' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIPAC' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372293');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA EPHIGÊNIA DE OLIVEIRA BATISTA (ITABIRITO) - INEP: 299979
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299979' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA EPHIGÊNIA DE OLIVEIRA BATISTA' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299979');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PROFESSOR JAYME DE SOUZA MARTINS (ITABIRITO) - INEP: 108014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108014' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PROFESSOR JAYME DE SOUZA MARTINS' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PROFESSOR JAYME DE SOUZA MARTINS - UNIDADE II (ITABIRITO) - INEP: 378097
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378097' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PROFESSOR JAYME DE SOUZA MARTINS - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378097');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO SANTO ANTÔNIO DE PÁDUA (ITABIRITO) - INEP: 107981
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '107981' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO SANTO ANTÔNIO DE PÁDUA' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '107981');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL LAÉRCIO GARCIA NOGUEIRA (ITABIRITO) - INEP: 358940
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358940' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL LAÉRCIO GARCIA NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'ITABIRITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358940');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ADJETIVO - CETEP- CENTRO TÉCNICO DE ENSINO PROFISSIONAL (MARIANA) - INEP: 323772
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323772' 
    WHERE UPPER(TRIM(name)) = 'ADJETIVO - CETEP- CENTRO TÉCNICO DE ENSINO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323772');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO TÉCNICO E PROFISSIONALIZANTE MORAIS (MARIANA) - INEP: 373494
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373494' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO TÉCNICO E PROFISSIONALIZANTE MORAIS' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373494');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO PROFISSIONAL DOUTOR JOSÉ LUCIANO DUARTE PENIDO (MARIANA) - INEP: 340960
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340960' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO PROFISSIONAL DOUTOR JOSÉ LUCIANO DUARTE PENIDO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340960');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL GETSÊMANI (MARIANA) - INEP: 356336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356336' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL GETSÊMANI' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356336');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM VIÇOSO (MARIANA) - INEP: 274127
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274127' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM VIÇOSO' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274127');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FLECHA (MARIANA) - INEP: 237167
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237167' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FLECHA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237167');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROVIDÊNCIA (MARIANA) - INEP: 108031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108031' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROVIDÊNCIA' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TEIXEIRA DIAS (MARIANA) - INEP: 300063
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '300063' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TEIXEIRA DIAS' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '300063');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO CECÍLIA MEIRELES (OURO PRETO) - INEP: 361259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361259' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO CECÍLIA MEIRELES' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNDO MÁGICO (OURO PRETO) - INEP: 300012
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '300012' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNDO MÁGICO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '300012');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL OURO PRETO (OURO PRETO) - INEP: 261041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261041' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL OURO PRETO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ARQUIDIOCESANO (OURO PRETO) - INEP: 108103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108103' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ARQUIDIOCESANO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RENASCER (OURO PRETO) - INEP: 368296
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368296' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RENASCER' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368296');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SINAPSE (OURO PRETO) - INEP: 321532
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321532' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SINAPSE' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321532');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO INCONFIDENTE ÁLVARES MACIEL (OURO PRETO) - INEP: 339202
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339202' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO INCONFIDENTE ÁLVARES MACIEL' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339202');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ARTE RODRIGO MELO FRANCO DE ANDRADE (OURO PRETO) - INEP: 314722
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314722' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ARTE RODRIGO MELO FRANCO DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314722');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENSINO TÉCNICO EURÍPEDES BARSANULFO (OURO PRETO) - INEP: 311006
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311006' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENSINO TÉCNICO EURÍPEDES BARSANULFO' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311006');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CTA - COLÉGIO TÉCNICO AVANÇAR (ABAETÉ) - INEP: 340766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340766' 
    WHERE UPPER(TRIM(name)) = 'CTA - COLÉGIO TÉCNICO AVANÇAR' 
      AND UPPER(TRIM(city)) = 'ABAETÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE BOM DESPACHO (BOM DESPACHO) - INEP: 343668
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343668' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE BOM DESPACHO' 
      AND UPPER(TRIM(city)) = 'BOM DESPACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343668');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LEONARDO DA VINCI (BOM DESPACHO) - INEP: 322849
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322849' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LEONARDO DA VINCI' 
      AND UPPER(TRIM(city)) = 'BOM DESPACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322849');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIPURA (BOM DESPACHO) - INEP: 375675
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375675' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIPURA' 
      AND UPPER(TRIM(city)) = 'BOM DESPACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375675');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIVERSO (BOM DESPACHO) - INEP: 362514
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362514' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIVERSO' 
      AND UPPER(TRIM(city)) = 'BOM DESPACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362514');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA SANTA CLARA-BOM DESPACHO (BOM DESPACHO) - INEP: 354937
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354937' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA SANTA CLARA-BOM DESPACHO' 
      AND UPPER(TRIM(city)) = 'BOM DESPACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354937');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ELYSIUM (DORES DO INDAIÁ) - INEP: 274151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274151' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ELYSIUM' 
      AND UPPER(TRIM(city)) = 'DORES DO INDAIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MAANAIM (DORES DO INDAIÁ) - INEP: 280801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280801' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MAANAIM' 
      AND UPPER(TRIM(city)) = 'DORES DO INDAIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280801');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PARTICULAR DORENSE (DORES DO INDAIÁ) - INEP: 251551
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251551' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARTICULAR DORENSE' 
      AND UPPER(TRIM(city)) = 'DORES DO INDAIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251551');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU PARÁ DE MINAS (PARÁ DE MINAS) - INEP: 258512
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258512' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU PARÁ DE MINAS' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258512');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE PARÁ DE MINAS (PARÁ DE MINAS) - INEP: 342327
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342327' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE PARÁ DE MINAS' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342327');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO SÃO FRANCISCO DE ASSIS (PARÁ DE MINAS) - INEP: 246158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246158' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI DOUTOR CELSO CHARURI (PARÁ DE MINAS) - INEP: 369616
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369616' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI DOUTOR CELSO CHARURI' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369616');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL CELSO CHARURI (PARÁ DE MINAS) - INEP: 322962
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322962' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL CELSO CHARURI' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322962');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PROFESSOR FRANCISCO SALDANHA (PITANGUI) - INEP: 253367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253367' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PROFESSOR FRANCISCO SALDANHA' 
      AND UPPER(TRIM(city)) = 'PITANGUI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO PEDAGÓGICO OTONI BRAGA (PITANGUI) - INEP: 296287
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296287' 
    WHERE UPPER(TRIM(name)) = 'CENTRO PEDAGÓGICO OTONI BRAGA' 
      AND UPPER(TRIM(city)) = 'PITANGUI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296287');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COTEFER – COLÉGIO TÉCNICO FERNANDES (PITANGUI) - INEP: 351490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351490' 
    WHERE UPPER(TRIM(name)) = 'COTEFER – COLÉGIO TÉCNICO FERNANDES' 
      AND UPPER(TRIM(city)) = 'PITANGUI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO ESTHER VALÉRIO (PITANGUI) - INEP: 279382
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279382' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO ESTHER VALÉRIO' 
      AND UPPER(TRIM(city)) = 'PITANGUI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279382');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO BALUARTE (JOÃO PINHEIRO) - INEP: 330817
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330817' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO BALUARTE' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330817');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL VISÃO (JOÃO PINHEIRO) - INEP: 317284
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317284' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL VISÃO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317284');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CENECISTA JOÃO PINHEIRO (JOÃO PINHEIRO) - INEP: 245003
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245003' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CENECISTA JOÃO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245003');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DARCÍLIA COIMBRA (JOÃO PINHEIRO) - INEP: 374652
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374652' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DARCÍLIA COIMBRA' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374652');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATENAS - UNIDADE II (PARACATU) - INEP: 357138
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357138' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATENAS - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357138');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATENAS- UNIDADE I (PARACATU) - INEP: 260941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260941' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATENAS- UNIDADE I' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMPÉRIO EDUCACIONAL (PARACATU) - INEP: 334251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334251' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMPÉRIO EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SOMA (PARACATU) - INEP: 215571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215571' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SOMA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DOM ELIZEU VAN DE WEIJER (PARACATU) - INEP: 114774
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114774' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DOM ELIZEU VAN DE WEIJER' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114774');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MULTI-TECH CURSOS E INFORMÁTICA (PARACATU) - INEP: 334030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334030' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MULTI-TECH CURSOS E INFORMÁTICA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA POLITÉCNICA DE PARACATU (PARACATU) - INEP: 368482
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368482' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA POLITÉCNICA DE PARACATU' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368482');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE PARACATU (PARACATU) - INEP: 292605
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292605' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE PARACATU' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292605');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL EPITÁCIO CARDOSO NAVES (PARACATU) - INEP: 342165
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342165' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL EPITÁCIO CARDOSO NAVES' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342165');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL SEBASTIANA ALVES (VAZANTE) - INEP: 245372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245372' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL SEBASTIANA ALVES' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE VAZANTE (VAZANTE) - INEP: 352691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352691' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE VAZANTE' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL MARCELO IANHEZ (VAZANTE) - INEP: 321915
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321915' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL MARCELO IANHEZ' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321915');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SEV - SOCIEDADE EDUCACIONAL DE VAZANTE (VAZANTE) - INEP: 310751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310751' 
    WHERE UPPER(TRIM(name)) = 'SEV - SOCIEDADE EDUCACIONAL DE VAZANTE' 
      AND UPPER(TRIM(city)) = 'VAZANTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALBERTINO GONÇALVES DOS REIS (ALPINÓPOLIS) - INEP: 298905
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298905' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALBERTINO GONÇALVES DOS REIS' 
      AND UPPER(TRIM(city)) = 'ALPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298905');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL PADRE UBIRAJARA CABRAL (ALPINÓPOLIS) - INEP: 254291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254291' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL PADRE UBIRAJARA CABRAL' 
      AND UPPER(TRIM(city)) = 'ALPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VENCER (CARMO DO RIO CLARO) - INEP: 295175
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295175' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VENCER' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295175');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INST EDUC CULT CARMO DO RIO CLARO (CARMO DO RIO CLARO) - INEP: 249203
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249203' 
    WHERE UPPER(TRIM(name)) = 'INST EDUC CULT CARMO DO RIO CLARO' 
      AND UPPER(TRIM(city)) = 'CARMO DO RIO CLARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249203');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO DE FORMIGA-UNIDADE I (FORMIGA) - INEP: 309770
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309770' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO DE FORMIGA-UNIDADE I' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309770');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA TERESINHA (FORMIGA) - INEP: 118311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118311' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA TERESINHA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118311');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO CECON FORMIGA (FORMIGA) - INEP: 317748
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317748' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO CECON FORMIGA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317748');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIFOR (FORMIGA) - INEP: 118281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118281' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIFOR' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIFOR - UNIDADE II (FORMIGA) - INEP: 355313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355313' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIFOR - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI FORMIGA CT LUIZ RODRIGUES DA COSTA (FORMIGA) - INEP: 380369
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380369' 
    WHERE UPPER(TRIM(name)) = 'SENAI FORMIGA CT LUIZ RODRIGUES DA COSTA' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380369');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DEL REY (PASSOS) - INEP: 294900
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294900' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DEL REY' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294900');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ETEP- ESCOLA TÉCNICA DE PASSOS (PASSOS) - INEP: 321133
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321133' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ETEP- ESCOLA TÉCNICA DE PASSOS' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321133');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMACULADA CONCEIÇÃO (PASSOS) - INEP: 118320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118320' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118320');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO DE PASSOS (PASSOS) - INEP: 223883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223883' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO DE PASSOS' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO FRANCISCO – UNIDADE II (PASSOS) - INEP: 362735
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362735' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO FRANCISCO – UNIDADE II' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362735');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO STATUS (PASSOS) - INEP: 118346
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118346' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO STATUS' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118346');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA PROFESSOR JOSÉ PAULO DE SOUZA (PASSOS) - INEP: 324779
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324779' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA PROFESSOR JOSÉ PAULO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324779');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL FIT - MG (PASSOS) - INEP: 374199
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374199' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL FIT - MG' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374199');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MÁRIS CÉLIS (PASSOS) - INEP: 311553
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311553' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MÁRIS CÉLIS' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311553');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PRO EDUCAR ESCOLA TÉCNICA (PASSOS) - INEP: 368490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368490' 
    WHERE UPPER(TRIM(name)) = 'PRO EDUCAR ESCOLA TÉCNICA' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO DE PIUMHI (PIUMHI) - INEP: 310956
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310956' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO DE PIUMHI' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310956');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRESBITERIANO DE PIUMHI (PIUMHI) - INEP: 257664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257664' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRESBITERIANO DE PIUMHI' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PERFIL DE EDUCAÇÃO (PIUMHI) - INEP: 241776
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '241776' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PERFIL DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '241776');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO ELLOS DE EDUCAÇÃO (SÃO ROQUE DE MINAS) - INEP: 295345
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295345' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO ELLOS DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'SÃO ROQUE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295345');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PÓLIS (CARMO DO PARANAÍBA) - INEP: 276227
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276227' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PÓLIS' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276227');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCAR (LAGAMAR) - INEP: 302422
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302422' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCAR' 
      AND UPPER(TRIM(city)) = 'LAGAMAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302422');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO POLITÉCNICO TREINAMENTO ENSINO E PESQUISA (PATOS DE MINAS) - INEP: 279048
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279048' 
    WHERE UPPER(TRIM(name)) = 'CENTRO POLITÉCNICO TREINAMENTO ENSINO E PESQUISA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279048');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE PATOS DE MINAS (PATOS DE MINAS) - INEP: 321079
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321079' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE PATOS DE MINAS' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321079');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CORAÇÃO MATERNO (PATOS DE MINAS) - INEP: 305286
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305286' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CORAÇÃO MATERNO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305286');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FONSECA RODRIGUES (PATOS DE MINAS) - INEP: 123501
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123501' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FONSECA RODRIGUES' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123501');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LEONARDO DA VINCI (PATOS DE MINAS) - INEP: 123544
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123544' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LEONARDO DA VINCI' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123544');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MARISTA (PATOS DE MINAS) - INEP: 123510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123510' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MARISTA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DAS GRAÇAS (PATOS DE MINAS) - INEP: 123536
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123536' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123536');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIVERSITÁRIO (PATOS DE MINAS) - INEP: 371696
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371696' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIVERSITÁRIO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371696');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE PATOS DE MINAS (PATOS DE MINAS) - INEP: 364380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364380' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE PATOS DE MINAS' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PRESBITERIANO DE EDUCAÇÃO (PATOS DE MINAS) - INEP: 281174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281174' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PRESBITERIANO DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO INTEGRAL FORMAÇÃO E PESQUISA TECNICO PROFISSIONAL (PATOS DE MINAS) - INEP: 322024
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322024' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO INTEGRAL FORMAÇÃO E PESQUISA TECNICO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322024');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CFP PATOS DE MINAS (PATOS DE MINAS) - INEP: 321729
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321729' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CFP PATOS DE MINAS' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321729');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI- CENTRO PROFISSIONAL ANÁVIO BRAZ QUEIROZ (PATOS DE MINAS) - INEP: 312347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312347' 
    WHERE UPPER(TRIM(name)) = 'SENAI- CENTRO PROFISSIONAL ANÁVIO BRAZ QUEIROZ' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PAULO FREIRE (RIO PARANAÍBA) - INEP: 355488
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355488' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'RIO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355488');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  ESCOLA PARTICULAR GAMA – CENTRO EDUCACIONAL GARCIA MARQUES (SÃO GOTARDO) - INEP: 253324
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253324' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARTICULAR GAMA – CENTRO EDUCACIONAL GARCIA MARQUES' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253324');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DIMENSÃO (SÃO GOTARDO) - INEP: 260711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260711' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DIMENSÃO' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GAMA DE SÃO GOTARDO (SÃO GOTARDO) - INEP: 305294
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305294' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GAMA DE SÃO GOTARDO' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305294');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ETEC - SG ESCOLA TÉCNICA DE SÃO GOTARDO (SÃO GOTARDO) - INEP: 369306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369306' 
    WHERE UPPER(TRIM(name)) = 'ETEC - SG ESCOLA TÉCNICA DE SÃO GOTARDO' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FETEP - FUTURISTA ENSINO TÉCNICO PROFISSIONALIZANTE (SÃO GOTARDO) - INEP: 365076
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365076' 
    WHERE UPPER(TRIM(name)) = 'FETEP - FUTURISTA ENSINO TÉCNICO PROFISSIONALIZANTE' 
      AND UPPER(TRIM(city)) = 'SÃO GOTARDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365076');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL EDUQUE (TIROS) - INEP: 295108
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295108' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL EDUQUE' 
      AND UPPER(TRIM(city)) = 'TIROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295108');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SISTEMA PÓLIS DE ENSINO (GUIMARÂNIA) - INEP: 312584
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312584' 
    WHERE UPPER(TRIM(name)) = 'SISTEMA PÓLIS DE ENSINO' 
      AND UPPER(TRIM(city)) = 'GUIMARÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312584');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÁRCADE DE IBIÁ (IBIÁ) - INEP: 276260
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276260' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÁRCADE DE IBIÁ' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276260');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOVA DIMENSÃO (IBIÁ) - INEP: 215759
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215759' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOVA DIMENSÃO' 
      AND UPPER(TRIM(city)) = 'IBIÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215759');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CANTINHO DA ALEGRIA (IRAÍ DE MINAS) - INEP: 295868
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295868' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CANTINHO DA ALEGRIA' 
      AND UPPER(TRIM(city)) = 'IRAÍ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295868');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATENAS (PATROCÍNIO) - INEP: 200247
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200247' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATENAS' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200247');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BERLAAR NOSSA SENHORA DO PATROCÍNIO (PATROCÍNIO) - INEP: 200212
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200212' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BERLAAR NOSSA SENHORA DO PATROCÍNIO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200212');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BIAS DE PRIENE (PATROCÍNIO) - INEP: 372463
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372463' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BIAS DE PRIENE' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372463');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCACIONAL ABC (PATROCÍNIO) - INEP: 223417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223417' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCACIONAL ABC' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCACIONAL CRIARTE (PATROCÍNIO) - INEP: 324876
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324876' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCACIONAL CRIARTE' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324876');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCACIONAL CRIARTE (PATROCÍNIO) - INEP: 377120
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377120' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCACIONAL CRIARTE' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377120');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MONTEIRO LOBATO (PATROCÍNIO) - INEP: 325741
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325741' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325741');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRISMA (PATROCÍNIO) - INEP: 277487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277487' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRISMA' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA AGROTÉCNICA SERGIO DE FREITAS PACHECO / EASFP (PATROCÍNIO) - INEP: 200239
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200239' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA AGROTÉCNICA SERGIO DE FREITAS PACHECO / EASFP' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200239');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PEOPLE FORMAÇÃO COMPLETA (PATROCÍNIO) - INEP: 378372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378372' 
    WHERE UPPER(TRIM(name)) = 'PEOPLE FORMAÇÃO COMPLETA' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- UNIDADE DE ENSINO TÉCNICO DO CEP SENAC PATROCÍNIO (PATROCÍNIO) - INEP: 376574
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376574' 
    WHERE UPPER(TRIM(name)) = 'UNIDADE DE ENSINO TÉCNICO DO CEP SENAC PATROCÍNIO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376574');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO JOÃO BATISTA (PIRAPORA) - INEP: 213896
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213896' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO JOÃO BATISTA' 
      AND UPPER(TRIM(city)) = 'PIRAPORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213896');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÓLIDO - UNIDADE PIRAPORA (PIRAPORA) - INEP: 381101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381101' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÓLIDO - UNIDADE PIRAPORA' 
      AND UPPER(TRIM(city)) = 'PIRAPORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI PIRAPORA CFP PIRAPORA (PIRAPORA) - INEP: 371092
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371092' 
    WHERE UPPER(TRIM(name)) = 'SENAI PIRAPORA CFP PIRAPORA' 
      AND UPPER(TRIM(city)) = 'PIRAPORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371092');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DARCÍLIA COIMBRA - UNIDADE VÁRZEA DA PALMA (VÁRZEA DA PALMA) - INEP: 379905
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379905' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DARCÍLIA COIMBRA - UNIDADE VÁRZEA DA PALMA' 
      AND UPPER(TRIM(city)) = 'VÁRZEA DA PALMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379905');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DESTAQUE (VÁRZEA DA PALMA) - INEP: 223433
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223433' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DESTAQUE' 
      AND UPPER(TRIM(city)) = 'VÁRZEA DA PALMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223433');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO JOAQUIM DE PAULA FERREIRA (VÁRZEA DA PALMA) - INEP: 325457
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325457' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO JOAQUIM DE PAULA FERREIRA' 
      AND UPPER(TRIM(city)) = 'VÁRZEA DA PALMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325457');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JUNQUEIRA - UNIDADE I (ANDRADAS) - INEP: 272957
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272957' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JUNQUEIRA - UNIDADE I' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272957');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JUNQUEIRA - UNIDADE II (ANDRADAS) - INEP: 343447
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343447' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JUNQUEIRA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343447');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ADVENTISTA DE ANDRADAS (ANDRADAS) - INEP: 312860
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312860' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ADVENTISTA DE ANDRADAS' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312860');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ULTRA (ANDRADAS) - INEP: 127833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127833' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ULTRA' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ULTRA DE ENSINO MÉDIO E PROFISSIONAL (ANDRADAS) - INEP: 310808
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310808' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ULTRA DE ENSINO MÉDIO E PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310808');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO ALFA (ANDRADAS) - INEP: 127841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127841' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO ALFA' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO ALFA I (ANDRADAS) - INEP: 355356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355356' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO ALFA I' 
      AND UPPER(TRIM(city)) = 'ANDRADAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- LOGOS COLÉGIO E CURSO - FORMAÇÃO INTEGRAL (AREADO) - INEP: 127868
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127868' 
    WHERE UPPER(TRIM(name)) = 'LOGOS COLÉGIO E CURSO - FORMAÇÃO INTEGRAL' 
      AND UPPER(TRIM(city)) = 'AREADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127868');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO  EDUCACIONAL ANTÔNIO DE SOUZA GONÇALVES (BOTELHOS) - INEP: 305146
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305146' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ANTÔNIO DE SOUZA GONÇALVES' 
      AND UPPER(TRIM(city)) = 'BOTELHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305146');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEMA - CENTRO EDUCACIONAL MOURA ALMEIDA (MUZAMBINHO) - INEP: 358436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358436' 
    WHERE UPPER(TRIM(name)) = 'CEMA - CENTRO EDUCACIONAL MOURA ALMEIDA' 
      AND UPPER(TRIM(city)) = 'MUZAMBINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358436');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DELTA PROFESSORA ANTÔNIA FERNANDES (MUZAMBINHO) - INEP: 342416
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342416' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DELTA PROFESSORA ANTÔNIA FERNANDES' 
      AND UPPER(TRIM(city)) = 'MUZAMBINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342416');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LYCEU (MUZAMBINHO) - INEP: 230642
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230642' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LYCEU' 
      AND UPPER(TRIM(city)) = 'MUZAMBINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230642');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL NOVA RESENDE (NOVA RESENDE) - INEP: 349690
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349690' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NOVA RESENDE' 
      AND UPPER(TRIM(city)) = 'NOVA RESENDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349690');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL INOVAÇÃO (POÇOS DE CALDAS) - INEP: 310841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310841' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL INOVAÇÃO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL POÇOS (POÇOS DE CALDAS) - INEP: 310191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310191' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL POÇOS' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JESUS MARIA JOSÉ (POÇOS DE CALDAS) - INEP: 127965
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127965' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JESUS MARIA JOSÉ' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127965');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NINI MOURÃO (POÇOS DE CALDAS) - INEP: 127949
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127949' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NINI MOURÃO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127949');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIO XII (POÇOS DE CALDAS) - INEP: 127973
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127973' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIO XII' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127973');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO JOSÉ DA IMACULADA CONCEIÇÃO (POÇOS DE CALDAS) - INEP: 371831
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371831' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO JOSÉ DA IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371831');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SETE DE SETEMBRO (POÇOS DE CALDAS) - INEP: 128031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128031' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SETE DE SETEMBRO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESC PROFIS DOM BOSCO (POÇOS DE CALDAS) - INEP: 128023
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128023' 
    WHERE UPPER(TRIM(name)) = 'ESC PROFIS DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128023');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRIATIVA IDADE SISTEMA EDUCACIONAL (POÇOS DE CALDAS) - INEP: 245968
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245968' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRIATIVA IDADE SISTEMA EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245968');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA LUMIAR (POÇOS DE CALDAS) - INEP: 372307
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372307' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA LUMIAR' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372307');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA RUTH SEE (POÇOS DE CALDAS) - INEP: 378330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378330' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA RUTH SEE' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SANTA ROSA (POÇOS DE CALDAS) - INEP: 340839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340839' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SANTA ROSA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SÃO JOÃO DA ESCÓCIA (POÇOS DE CALDAS) - INEP: 128058
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128058' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SÃO JOÃO DA ESCÓCIA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128058');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- REDE PROSPER POÇOS DE CALDAS (POÇOS DE CALDAS) - INEP: 222976
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222976' 
    WHERE UPPER(TRIM(name)) = 'REDE PROSPER POÇOS DE CALDAS' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222976');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CFP POÇOS DE CALDAS (POÇOS DE CALDAS) - INEP: 313459
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313459' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CFP POÇOS DE CALDAS' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313459');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOÃO MOREIRA SALLES (POÇOS DE CALDAS) - INEP: 259454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259454' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOÃO MOREIRA SALLES' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA PURIS DE ARAPONGA (ARAPONGA) - INEP: 343064
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343064' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA PURIS DE ARAPONGA' 
      AND UPPER(TRIM(city)) = 'ARAPONGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343064');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA DE JEQUERI (JEQUERI) - INEP: 312631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312631' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA DE JEQUERI' 
      AND UPPER(TRIM(city)) = 'JEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MACIEL AGUIAR PRIMEIRO - UNIDADE II (PONTE NOVA) - INEP: 370274
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370274' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MACIEL AGUIAR PRIMEIRO - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370274');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MACIEL AGUIAR PRIMEIRO-CEMAP (PONTE NOVA) - INEP: 259527
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259527' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MACIEL AGUIAR PRIMEIRO-CEMAP' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259527');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE PONTE NOVA (PONTE NOVA) - INEP: 379980
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379980' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE PONTE NOVA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379980');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATHENAS EQUIPE DE PONTE NOVA (PONTE NOVA) - INEP: 231088
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231088' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATHENAS EQUIPE DE PONTE NOVA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231088');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CÓLEGIO CERP (PONTE NOVA) - INEP: 363090
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363090' 
    WHERE UPPER(TRIM(name)) = 'CÓLEGIO CERP' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363090');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOSSA SENHORA AUXILIADORA (PONTE NOVA) - INEP: 133612
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133612' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOSSA SENHORA AUXILIADORA' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133612');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO MONTESSORI (PONTE NOVA) - INEP: 133621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133621' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO MONTESSORI' 
      AND UPPER(TRIM(city)) = 'PONTE NOVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DARWIN DE RAUL SOARES (RAUL SOARES) - INEP: 325694
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325694' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DARWIN DE RAUL SOARES' 
      AND UPPER(TRIM(city)) = 'RAUL SOARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325694');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATHENAS EQUIPE DE RIO CASCA (RIO CASCA) - INEP: 239526
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239526' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATHENAS EQUIPE DE RIO CASCA' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239526');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCAR DE RIO CASCA (RIO CASCA) - INEP: 376299
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376299' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCAR DE RIO CASCA' 
      AND UPPER(TRIM(city)) = 'RIO CASCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376299');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA DE CAMÕES (SEM-PEIXE) - INEP: 277991
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277991' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA DE CAMÕES' 
      AND UPPER(TRIM(city)) = 'SEM-PEIXE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277991');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL RAINHA DA PAZ (TEIXEIRAS) - INEP: 268682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268682' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL RAINHA DA PAZ' 
      AND UPPER(TRIM(city)) = 'TEIXEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL COEDUCAR (VIÇOSA) - INEP: 246395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246395' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL COEDUCAR' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PRÓ-EFEITO (VIÇOSA) - INEP: 253332
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253332' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PRÓ-EFEITO' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253332');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO REFERENCIAL DE ENSINO EM SAÚDE (VIÇOSA) - INEP: 368040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368040' 
    WHERE UPPER(TRIM(name)) = 'CENTRO REFERENCIAL DE ENSINO EM SAÚDE' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÁGORA (VIÇOSA) - INEP: 242233
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242233' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÁGORA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242233');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÂNGULO DE VIÇOSA (VIÇOSA) - INEP: 242241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242241' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÂNGULO DE VIÇOSA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CIDADE DE VIÇOSA (VIÇOSA) - INEP: 380202
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380202' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CIDADE DE VIÇOSA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380202');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EQUIPE (VIÇOSA) - INEP: 133680
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133680' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EQUIPE' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133680');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DO CARMO (VIÇOSA) - INEP: 133701
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '133701' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '133701');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÔMEGA (VIÇOSA) - INEP: 371971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371971' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÔMEGA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PASSO A PASSO (VIÇOSA) - INEP: 220043
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220043' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PASSO A PASSO' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220043');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA ÂNCORA (VIÇOSA) - INEP: 314501
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314501' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA ÂNCORA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314501');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EVATA -  EDUCAÇÃO AVANÇADA (VIÇOSA) - INEP: 324418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324418' 
    WHERE UPPER(TRIM(name)) = 'EVATA - EDUCAÇÃO AVANÇADA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO PAULISTA DE ESTUDOS EM AGRONEGÓCIO (BOM REPOUSO) - INEP: 379859
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379859' 
    WHERE UPPER(TRIM(name)) = 'CENTRO PAULISTA DE ESTUDOS EM AGRONEGÓCIO' 
      AND UPPER(TRIM(city)) = 'BOM REPOUSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379859');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA WASHINGTON CÁSSIO MARIANO (BOM REPOUSO) - INEP: 255459
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '255459' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA WASHINGTON CÁSSIO MARIANO' 
      AND UPPER(TRIM(city)) = 'BOM REPOUSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '255459');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MARANATHA (CAMANDUCAIA) - INEP: 292524
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292524' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MARANATHA' 
      AND UPPER(TRIM(city)) = 'CAMANDUCAIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292524');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCATIVO NOVA VIDA (CAMANDUCAIA) - INEP: 347850
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347850' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCATIVO NOVA VIDA' 
      AND UPPER(TRIM(city)) = 'CAMANDUCAIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347850');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCATIVO VIDA NOVA (CAMANDUCAIA) - INEP: 357251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357251' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCATIVO VIDA NOVA' 
      AND UPPER(TRIM(city)) = 'CAMANDUCAIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NILTA D'ONOFRIO DE CARVALHO (CAMBUÍ) - INEP: 343889
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343889' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NILTA D''ONOFRIO DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'CAMBUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343889');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ANA BUENO (CAMBUÍ) - INEP: 235725
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235725' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ANA BUENO' 
      AND UPPER(TRIM(city)) = 'CAMBUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235725');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DOCE SABER (CONGONHAL) - INEP: 306720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306720' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DOCE SABER' 
      AND UPPER(TRIM(city)) = 'CONGONHAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO FUTURO (EXTREMA) - INEP: 250058
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250058' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO FUTURO' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250058');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇAO PROFISSIONAL JANEZ HLEBANJA (EXTREMA) - INEP: 348252
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348252' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇAO PROFISSIONAL JANEZ HLEBANJA' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348252');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL TERRA - UNIDADE CENTRO (EXTREMA) - INEP: 358681
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358681' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL TERRA - UNIDADE CENTRO' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358681');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO MÉDIO PROFISSIONALIZANTE DE EXTREMA - CEMPRE (EXTREMA) - INEP: 370746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370746' 
    WHERE UPPER(TRIM(name)) = 'CENTRO MÉDIO PROFISSIONALIZANTE DE EXTREMA - CEMPRE' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO DE EDUCAÇÃO BOM PASTOR (EXTREMA) - INEP: 264342
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '264342' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO DE EDUCAÇÃO BOM PASTOR' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '264342');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PRIVEST -  SISTEMA COC DE ENSINO (EXTREMA) - INEP: 250040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250040' 
    WHERE UPPER(TRIM(name)) = 'PRIVEST - SISTEMA COC DE ENSINO' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250040');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA YOLANDA FERREIRA FRANCO (IPUIÚNA) - INEP: 279978
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279978' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA YOLANDA FERREIRA FRANCO' 
      AND UPPER(TRIM(city)) = 'IPUIÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279978');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APLICATIVO (JACUTINGA) - INEP: 365742
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365742' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APLICATIVO' 
      AND UPPER(TRIM(city)) = 'JACUTINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365742');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCAÇÃO E CULTURA (JACUTINGA) - INEP: 230898
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230898' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCAÇÃO E CULTURA' 
      AND UPPER(TRIM(city)) = 'JACUTINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230898');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTEGRADO JEAN PIAGET (JACUTINGA) - INEP: 302520
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302520' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTEGRADO JEAN PIAGET' 
      AND UPPER(TRIM(city)) = 'JACUTINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302520');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MONTE SIONENSE (MONTE SIÃO) - INEP: 256927
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256927' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MONTE SIONENSE' 
      AND UPPER(TRIM(city)) = 'MONTE SIÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256927');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VILLA LOBOS - UNIDADE MONTE SIÃO (MONTE SIÃO) - INEP: 319091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319091' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VILLA LOBOS - UNIDADE MONTE SIÃO' 
      AND UPPER(TRIM(city)) = 'MONTE SIÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ABNARA (OURO FINO) - INEP: 354163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354163' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ABNARA' 
      AND UPPER(TRIM(city)) = 'OURO FINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO E CURSO MÁXIMUS (OURO FINO) - INEP: 340030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340030' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO E CURSO MÁXIMUS' 
      AND UPPER(TRIM(city)) = 'OURO FINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ROCHEL (OURO FINO) - INEP: 235776
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '235776' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ROCHEL' 
      AND UPPER(TRIM(city)) = 'OURO FINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '235776');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL EUROPA (POUSO ALEGRE) - INEP: 368520
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368520' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL EUROPA' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368520');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL REIS MAGOS (POUSO ALEGRE) - INEP: 290963
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '290963' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL REIS MAGOS' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '290963');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL RENOVAÇÃO (POUSO ALEGRE) - INEP: 327026
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327026' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL RENOVAÇÃO' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327026');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADVENTISTA DE POUSO ALEGRE (POUSO ALEGRE) - INEP: 372838
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372838' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADVENTISTA DE POUSO ALEGRE' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372838');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU - UNIDADE V (POUSO ALEGRE) - INEP: 368385
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368385' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU - UNIDADE V' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368385');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FÊNIX (POUSO ALEGRE) - INEP: 358266
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358266' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FÊNIX' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358266');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FOCH (POUSO ALEGRE) - INEP: 369748
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369748' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FOCH' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369748');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JOÃO PAULO II (POUSO ALEGRE) - INEP: 210307
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210307' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JOÃO PAULO II' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210307');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TÉCNICO ENDEX (POUSO ALEGRE) - INEP: 375349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375349' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TÉCNICO ENDEX' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VALE DO SAPUCAÍ (POUSO ALEGRE) - INEP: 343781
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343781' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VALE DO SAPUCAÍ' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343781');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI ORLANDO CHIARINI (POUSO ALEGRE) - INEP: 258393
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258393' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI ORLANDO CHIARINI' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258393');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ETEMG - ESCOLA TÉCNICA MINAS GERIAS (POUSO ALEGRE) - INEP: 368873
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368873' 
    WHERE UPPER(TRIM(name)) = 'ETEMG - ESCOLA TÉCNICA MINAS GERIAS' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368873');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MAPLE BEAR CANADIAN SCHOOL (POUSO ALEGRE) - INEP: 356514
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356514' 
    WHERE UPPER(TRIM(name)) = 'MAPLE BEAR CANADIAN SCHOOL' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356514');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CFP POUSO ALEGRE (POUSO ALEGRE) - INEP: 338958
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338958' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CFP POUSO ALEGRE' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338958');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO  PROFISSIONAL ORLANDO CHIARINII (POUSO ALEGRE) - INEP: 268500
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268500' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL ORLANDO CHIARINII' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268500');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INST PRESBITERIANO (SANTA RITA DO SAPUCAÍ) - INEP: 262005
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262005' 
    WHERE UPPER(TRIM(name)) = 'INST PRESBITERIANO' 
      AND UPPER(TRIM(city)) = 'SANTA RITA DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262005');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE DESENVIMENTO TECNOLÓGICO STEFAN BOGDAN SALEJ (SANTA RITA DO SAPUCAÍ) - INEP: 320498
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320498' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE DESENVIMENTO TECNOLÓGICO STEFAN BOGDAN SALEJ' 
      AND UPPER(TRIM(city)) = 'SANTA RITA DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320498');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO INTEGRADA PAULO FREIRE (BOM SUCESSO) - INEP: 365866
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365866' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO INTEGRADA PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'BOM SUCESSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365866');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL WANDERLEY ARRUDA - CEWA (DORES DE CAMPOS) - INEP: 304395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '304395' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL WANDERLEY ARRUDA - CEWA' 
      AND UPPER(TRIM(city)) = 'DORES DE CAMPOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '304395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE ENSINO TÉCNICO CARVALHO CHIARINI (NAZARENO) - INEP: 337510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '337510' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE ENSINO TÉCNICO CARVALHO CHIARINI' 
      AND UPPER(TRIM(city)) = 'NAZARENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '337510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  CENTRO FORMAÇÃO PROFISSIONAL SÍLVIO ASSUNÇÃO TEIXEIRA-SENAI (SÃO JOÃO DEL REI) - INEP: 259462
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259462' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FORMAÇÃO PROFISSIONAL SÍLVIO ASSUNÇÃO TEIXEIRA-SENAI' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259462');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL FREI SERÁFICO (SÃO JOÃO DEL REI) - INEP: 245976
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245976' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL FREI SERÁFICO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245976');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CAMINHO DO SOL (SÃO JOÃO DEL REI) - INEP: 232602
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232602' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CAMINHO DO SOL' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232602');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMPACTO (SÃO JOÃO DEL REI) - INEP: 376817
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376817' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMPACTO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376817');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DAS DORES (SÃO JOÃO DEL REI) - INEP: 136760
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136760' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DAS DORES' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136760');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO REVISÃO (SÃO JOÃO DEL REI) - INEP: 326577
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326577' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO REVISÃO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326577');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COMPANHIA EDUCACIONAL ENLACE (SÃO JOÃO DEL REI) - INEP: 281701
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281701' 
    WHERE UPPER(TRIM(name)) = 'COMPANHIA EDUCACIONAL ENLACE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281701');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE EDUCAÇÃO BÁSICA E PROFISSIONAL DONA SINHÁ NEVES (SÃO JOÃO DEL REI) - INEP: 136816
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136816' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE EDUCAÇÃO BÁSICA E PROFISSIONAL DONA SINHÁ NEVES' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136816');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DE SAÚDE ANTONINA NEVES (SÃO JOÃO DEL REI) - INEP: 250783
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250783' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DE SAÚDE ANTONINA NEVES' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250783');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI DOM BOSCO (SÃO JOÃO DEL REI) - INEP: 136727
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136727' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136727');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO AUXILIADORA (SÃO JOÃO DEL REI) - INEP: 136751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136751' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO AUXILIADORA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SERVIÇO NACIONAL DE APRENDIZAGEM COMERCIAL - SENAC SÃO JOÃO DEL REI (SÃO JOÃO DEL REI) - INEP: 363103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363103' 
    WHERE UPPER(TRIM(name)) = 'SERVIÇO NACIONAL DE APRENDIZAGEM COMERCIAL - SENAC SÃO JOÃO DEL REI' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CORY (ARCEBURGO) - INEP: 317161
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317161' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CORY' 
      AND UPPER(TRIM(city)) = 'ARCEBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317161');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ANA DE MELO AZEVEDO (CÁSSIA) - INEP: 210471
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210471' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ANA DE MELO AZEVEDO' 
      AND UPPER(TRIM(city)) = 'CÁSSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210471');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PRIMEIROS PASSOS (GUARANÉSIA) - INEP: 333395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '333395' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PRIMEIROS PASSOS' 
      AND UPPER(TRIM(city)) = 'GUARANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '333395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALTERNATIVO (GUARANÉSIA) - INEP: 261971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261971' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALTERNATIVO' 
      AND UPPER(TRIM(city)) = 'GUARANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ACADEMIA DE COMÉRCIO SÃO JOSÉ (GUAXUPÉ) - INEP: 140163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140163' 
    WHERE UPPER(TRIM(name)) = 'ACADEMIA DE COMÉRCIO SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BORA PASSAR (GUAXUPÉ) - INEP: 376078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376078' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BORA PASSAR' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM INÁCIO (GUAXUPÉ) - INEP: 140171
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140171' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM INÁCIO' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140171');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO DE GUAXUPÉ UNIDADE I (GUAXUPÉ) - INEP: 240443
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240443' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO DE GUAXUPÉ UNIDADE I' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240443');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO DE GUAXUPÉ UNIDADE II (GUAXUPÉ) - INEP: 316687
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316687' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO DE GUAXUPÉ UNIDADE II' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316687');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PHD (GUAXUPÉ) - INEP: 364533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364533' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PHD' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA INTERATIVA (GUAXUPÉ) - INEP: 280071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280071' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA INTERATIVA' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC- CENTRO DE FORMAÇÃO PROFISSIONAL DE GUAXUPÉ (GUAXUPÉ) - INEP: 320200
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320200' 
    WHERE UPPER(TRIM(name)) = 'SENAC- CENTRO DE FORMAÇÃO PROFISSIONAL DE GUAXUPÉ' 
      AND UPPER(TRIM(city)) = 'GUAXUPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320200');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUC IBIRACI (IBIRACI) - INEP: 347744
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347744' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUC IBIRACI' 
      AND UPPER(TRIM(city)) = 'IBIRACI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347744');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOVA ARTE & CIA (ITAMOGI) - INEP: 295078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295078' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOVA ARTE & CIA' 
      AND UPPER(TRIM(city)) = 'ITAMOGI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCACIONAL DE ITAÚ DE MINAS (ITAÚ DE MINAS) - INEP: 341398
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '341398' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCACIONAL DE ITAÚ DE MINAS' 
      AND UPPER(TRIM(city)) = 'ITAÚ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '341398');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTERATIVO (ITAÚ DE MINAS) - INEP: 332402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332402' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTERATIVO' 
      AND UPPER(TRIM(city)) = 'ITAÚ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DEGRAUS (MONTE SANTO DE MINAS) - INEP: 231916
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231916' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DEGRAUS' 
      AND UPPER(TRIM(city)) = 'MONTE SANTO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231916');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOVA CRIANÇA E CIA (MONTE SANTO DE MINAS) - INEP: 247251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247251' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOVA CRIANÇA E CIA' 
      AND UPPER(TRIM(city)) = 'MONTE SANTO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO PROFISSIONAL DO SUDOESTE MINEIRO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 315958
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315958' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO PROFISSIONAL DO SUDOESTE MINEIRO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315958');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRESCER (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 256943
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256943' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRESCER' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256943');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GALILEU (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 281883
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281883' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GALILEU' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281883');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NESFA-NÚCLEO EDUCACIONAL SÃO FRANCISCO DE ASSIS (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 296139
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296139' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NESFA-NÚCLEO EDUCACIONAL SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296139');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO DE SÃO SEBASTIÃO DO PARAÍSO NHNEC (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 316644
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316644' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO DE SÃO SEBASTIÃO DO PARAÍSO NHNEC' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316644');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO DE SÃO SEBASTIÃO PARAÍSO-NHN (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 230669
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230669' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO DE SÃO SEBASTIÃO PARAÍSO-NHN' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230669');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PAULA FRASSINETTI (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 140252
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140252' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PAULA FRASSINETTI' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140252');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TESLA - SISTEMA MACKENZIE DE ENSINO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 376264
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376264' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TESLA - SISTEMA MACKENZIE DE ENSINO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376264');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CAIXINHA DE SURPRESA (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 298255
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298255' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CAIXINHA DE SURPRESA' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298255');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL MONSENHOR JERÔNIMO MANCINI (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 358797
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358797' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL MONSENHOR JERÔNIMO MANCINI' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358797');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CENECISTA BERNARDO MASCARENHAS (CAETANÓPOLIS) - INEP: 145548
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145548' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CENECISTA BERNARDO MASCARENHAS' 
      AND UPPER(TRIM(city)) = 'CAETANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145548');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- C EDUC NOSSO MUNDO (MATOZINHOS) - INEP: 278050
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278050' 
    WHERE UPPER(TRIM(name)) = 'C EDUC NOSSO MUNDO' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278050');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCACIONAL ALTERNATIVA (MATOZINHOS) - INEP: 239534
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239534' 
    WHERE UPPER(TRIM(name)) = 'EDUCACIONAL ALTERNATIVA' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239534');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCANDÁRIO CECÍLIA MEIRELES (PAPAGAIOS) - INEP: 254118
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254118' 
    WHERE UPPER(TRIM(name)) = 'EDUCANDÁRIO CECÍLIA MEIRELES' 
      AND UPPER(TRIM(city)) = 'PAPAGAIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254118');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO NOSSA SRA DO CARMO (PARAOPEBA) - INEP: 230715
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230715' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO NOSSA SRA DO CARMO' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230715');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO SANTA MARIA (POMPÉU) - INEP: 259764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259764' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO SANTA MARIA' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEFAP- CENTRO DE FORMAÇÃO  E APERFEIÇOAMENTO PROFISSIONAL (SETE LAGOAS) - INEP: 312363
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312363' 
    WHERE UPPER(TRIM(name)) = 'CEFAP- CENTRO DE FORMAÇÃO E APERFEIÇOAMENTO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312363');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALPHA (SETE LAGOAS) - INEP: 357154
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357154' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALPHA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357154');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÂNGULO DE SETE LAGOAS (SETE LAGOAS) - INEP: 278033
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278033' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÂNGULO DE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278033');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO - UNIDADE SETE LAGOAS (SETE LAGOAS) - INEP: 374202
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374202' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO - UNIDADE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374202');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CAETANO (SETE LAGOAS) - INEP: 334049
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334049' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CAETANO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334049');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ELITE MASTER (SETE LAGOAS) - INEP: 367672
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367672' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ELITE MASTER' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367672');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FRANCISCANO REGINA PACIS (SETE LAGOAS) - INEP: 145734
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145734' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FRANCISCANO REGINA PACIS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145734');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMPULSO (SETE LAGOAS) - INEP: 260908
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260908' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMPULSO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260908');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LAIS FARNETTI (SETE LAGOAS) - INEP: 335746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '335746' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LAIS FARNETTI' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '335746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROFESSOR ROBERTO HERBSTER GUSMÃO (SETE LAGOAS) - INEP: 361500
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361500' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROFESSOR ROBERTO HERBSTER GUSMÃO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361500');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROMOVE DE SETE LAGOAS (SETE LAGOAS) - INEP: 368687
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368687' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROMOVE DE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368687');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


