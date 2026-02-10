-- Lote 9 de 9
-- Escolas 4001 a 4282

-- COLÉGIO RUTHERFORD (SETE LAGOAS) - INEP: 379719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379719' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RUTHERFORD' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379719');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA MARIA MINAS - UNIDADE SETE LAGOAS (SETE LAGOAS) - INEP: 145726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145726' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA MARIA MINAS - UNIDADE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGUIUM - UNIDADE DE SETE LAGOAS (SETE LAGOAS) - INEP: 368679
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368679' 
    WHERE UPPER(TRIM(name)) = 'COLEGUIUM - UNIDADE DE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368679');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TECNICA DE FORMAÇÃO GERENCIAL - UNIFEMM (SETE LAGOAS) - INEP: 350885
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350885' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TECNICA DE FORMAÇÃO GERENCIAL - UNIFEMM' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350885');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA SETE LAGOAS - TECSETE (SETE LAGOAS) - INEP: 377805
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377805' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA SETE LAGOAS - TECSETE' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377805');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GRAU TÉCNICO - UNIDADE SETE LAGOAS (SETE LAGOAS) - INEP: 376825
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376825' 
    WHERE UPPER(TRIM(name)) = 'GRAU TÉCNICO - UNIDADE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376825');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO ALICE MACIEL (SETE LAGOAS) - INEP: 145700
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145700' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO ALICE MACIEL' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145700');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CFP SETE LAGOAS (SETE LAGOAS) - INEP: 312975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312975' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CFP SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI SETE LAGOAS FUNDAÇÃO ZERRENNER (SETE LAGOAS) - INEP: 367079
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367079' 
    WHERE UPPER(TRIM(name)) = 'SENAI SETE LAGOAS FUNDAÇÃO ZERRENNER' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367079');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI OTONI ALVES DA COSTA UNIDADE II (SETE LAGOAS) - INEP: 268259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268259' 
    WHERE UPPER(TRIM(name)) = 'SESI OTONI ALVES DA COSTA UNIDADE II' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PARTICULAR INTERAÇÃO (ÁGUAS FORMOSAS) - INEP: 274348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274348' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARTICULAR INTERAÇÃO' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COOP EDUC CARLOS CHAGAS COOEDUCAR (CARLOS CHAGAS) - INEP: 279684
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279684' 
    WHERE UPPER(TRIM(name)) = 'COOP EDUC CARLOS CHAGAS COOEDUCAR' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279684');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EFACIL ESCOLA FAMÍLIA AGRÍCOLA DE CARAÍ,CATUJI,ITAIPÉ E LADAINHA (ITAIPÉ) - INEP: 356409
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356409' 
    WHERE UPPER(TRIM(name)) = 'EFACIL ESCOLA FAMÍLIA AGRÍCOLA DE CARAÍ,CATUJI,ITAIPÉ E LADAINHA' 
      AND UPPER(TRIM(city)) = 'ITAIPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356409');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESC COOPERATIVA CEPI (ITAMBACURI) - INEP: 277240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277240' 
    WHERE UPPER(TRIM(name)) = 'ESC COOPERATIVA CEPI' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SÃO FRANCISCO DE ASSIS - IESFA (ITAMBACURI) - INEP: 266060
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266060' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SÃO FRANCISCO DE ASSIS - IESFA' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266060');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO TÉCNICO PROFISSIONAL DE ITAMBACURI (ITAMBACURI) - INEP: 375390
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375390' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO TÉCNICO PROFISSIONAL DE ITAMBACURI' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375390');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EFASET - ESCOLA FAMÍLIA AGRÍCOLA DO SETÚBAL (MALACACHETA) - INEP: 354899
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354899' 
    WHERE UPPER(TRIM(name)) = 'EFASET - ESCOLA FAMÍLIA AGRÍCOLA DO SETÚBAL' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354899');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PARTICULAR REINO ENCANTADO (MALACACHETA) - INEP: 302571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302571' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARTICULAR REINO ENCANTADO' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MESTEP MALACACHETA ESCOLA TÉCNICA PROFISSIONALIZANTE (MALACACHETA) - INEP: 356204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356204' 
    WHERE UPPER(TRIM(name)) = 'MESTEP MALACACHETA ESCOLA TÉCNICA PROFISSIONALIZANTE' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTO ANTÔNIO (NANUQUE) - INEP: 157902
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157902' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157902');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCANDÁRIO CARLOS DRUMOND DE ANDRADE (NANUQUE) - INEP: 157953
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157953' 
    WHERE UPPER(TRIM(name)) = 'EDUCANDÁRIO CARLOS DRUMOND DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157953');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ADVENTISTA DE NANUQUE (NANUQUE) - INEP: 157911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157911' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ADVENTISTA DE NANUQUE' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA AGRÍCOLA TERRA MÃE (NOVO ORIENTE DE MINAS) - INEP: 299235
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299235' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA AGRÍCOLA TERRA MÃE' 
      AND UPPER(TRIM(city)) = 'NOVO ORIENTE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299235');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ORLANDO TAVARES (PADRE PARAÍSO) - INEP: 263800
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '263800' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ORLANDO TAVARES' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '263800');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CRISTÃO ALPHA BRASIL (TEÓFILO OTONI) - INEP: 274658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274658' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CRISTÃO ALPHA BRASIL' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CETEC- CENTRO DE EDUCAÇÃO TECNOLÓGICA TOP LINE (TEÓFILO OTONI) - INEP: 339628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339628' 
    WHERE UPPER(TRIM(name)) = 'CETEC- CENTRO DE EDUCAÇÃO TECNOLÓGICA TOP LINE' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADVENTISTA DE TEÓFILO OTONI (TEÓFILO OTONI) - INEP: 347230
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347230' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADVENTISTA DE TEÓFILO OTONI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347230');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GENOMA (TEÓFILO OTONI) - INEP: 356190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356190' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GENOMA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GENOMA  II (TEÓFILO OTONI) - INEP: 378496
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378496' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GENOMA II' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378496');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA COOPERATIVA EDUCACIONAL DE TEÓFILO OTONI - COOPED (TEÓFILO OTONI) - INEP: 242918
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242918' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA COOPERATIVA EDUCACIONAL DE TEÓFILO OTONI - COOPED' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242918');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PARTICULAR PEQUENO PRÍNCIPE (TEÓFILO OTONI) - INEP: 158101
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158101' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARTICULAR PEQUENO PRÍNCIPE' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158101');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SANTO AGOSTINHO (TEÓFILO OTONI) - INEP: 158143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158143' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SANTO AGOSTINHO' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA EGÍDIO JOSÉ DA SILVA (TEÓFILO OTONI) - INEP: 306916
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306916' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA EGÍDIO JOSÉ DA SILVA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306916');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL PEQUENO POLEGAR (TEÓFILO OTONI) - INEP: 365157
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365157' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL PEQUENO POLEGAR' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365157');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO SEMEAR (TEÓFILO OTONI) - INEP: 347426
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347426' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO SEMEAR' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347426');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DE ERVÁLIA - COLÉGIO CENER (ERVÁLIA) - INEP: 312096
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312096' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DE ERVÁLIA - COLÉGIO CENER' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312096');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO REFERENCIAL DE ENSINO EM SAÚDE - UNIDADE ERVÁLIA (ERVÁLIA) - INEP: 373508
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373508' 
    WHERE UPPER(TRIM(name)) = 'CENTRO REFERENCIAL DE ENSINO EM SAÚDE - UNIDADE ERVÁLIA' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373508');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCAR (ERVÁLIA) - INEP: 364410
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364410' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCAR' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364410');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA SERRA DO BRIGADEIRO (ERVÁLIA) - INEP: 338346
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338346' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA SERRA DO BRIGADEIRO' 
      AND UPPER(TRIM(city)) = 'ERVÁLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338346');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO REGINA COELI (RIO POMBA) - INEP: 184292
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184292' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO REGINA COELI' 
      AND UPPER(TRIM(city)) = 'RIO POMBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184292');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MASTER ÊXITUS (RIO POMBA) - INEP: 365530
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365530' 
    WHERE UPPER(TRIM(name)) = 'MASTER ÊXITUS' 
      AND UPPER(TRIM(city)) = 'RIO POMBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365530');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EQUIPE DE TOCANTINS (TOCANTINS) - INEP: 320218
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320218' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EQUIPE DE TOCANTINS' 
      AND UPPER(TRIM(city)) = 'TOCANTINS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320218');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL JEAN PIAGET (UBÁ) - INEP: 240338
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240338' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL JEAN PIAGET' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240338');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU UBÁ (UBÁ) - INEP: 377783
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377783' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU UBÁ' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377783');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO DE UBÁ (UBÁ) - INEP: 184349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184349' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO DE UBÁ' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LUNOS EDUCACIONAL (UBÁ) - INEP: 372013
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372013' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LUNOS EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372013');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PILAR (UBÁ) - INEP: 276057
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276057' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PILAR' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276057');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SAGRADO CORAÇÃO DE MARIA (UBÁ) - INEP: 184331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184331' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SAGRADO CORAÇÃO DE MARIA' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ETTAL - ESCOLA TECNICA TERESA ALMEIDA (UBÁ) - INEP: 350079
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350079' 
    WHERE UPPER(TRIM(name)) = 'ETTAL - ESCOLA TECNICA TERESA ALMEIDA' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350079');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEB - INSTITUTO EDUCACIONAL BETHEL (UBÁ) - INEP: 356492
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356492' 
    WHERE UPPER(TRIM(name)) = 'IEB - INSTITUTO EDUCACIONAL BETHEL' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356492');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE APLICAÇÃO EDUCACIONAL (UBÁ) - INEP: 238082
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '238082' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE APLICAÇÃO EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '238082');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ ALENCAR GOMES DA SILVA (UBÁ) - INEP: 310832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310832' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL JOSÉ ALENCAR GOMES DA SILVA' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI ESCOLA JOSÉ ALENCAR GOMES DA SILVA (UBÁ) - INEP: 278726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278726' 
    WHERE UPPER(TRIM(name)) = 'SESI ESCOLA JOSÉ ALENCAR GOMES DA SILVA' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO (VISCONDE DO RIO BRANCO) - INEP: 213942
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213942' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213942');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SUPREMO (VISCONDE DO RIO BRANCO) - INEP: 374660
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374660' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SUPREMO' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374660');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VERDY (VISCONDE DO RIO BRANCO) - INEP: 257320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '257320' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VERDY' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '257320');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA RAFAELA MENICUCCI (VISCONDE DO RIO BRANCO) - INEP: 184365
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184365' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA RAFAELA MENICUCCI' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184365');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI VISCONDE DO RIO BRANCO CFP SILVIO BENATTI (VISCONDE DO RIO BRANCO) - INEP: 352586
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352586' 
    WHERE UPPER(TRIM(name)) = 'SENAI VISCONDE DO RIO BRANCO CFP SILVIO BENATTI' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352586');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO PROFISSIONAL- BIT COMPANY ARAXÁ (ARAXÁ) - INEP: 339709
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339709' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO PROFISSIONAL- BIT COMPANY ARAXÁ' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339709');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATENA (ARAXÁ) - INEP: 218553
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218553' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATENA' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218553');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM BOSCO (ARAXÁ) - INEP: 166090
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166090' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166090');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GABARITO (ARAXÁ) - INEP: 371777
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371777' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GABARITO' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371777');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MÚLTIPLA ESCOLHA (ARAXÁ) - INEP: 361534
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361534' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MÚLTIPLA ESCOLHA' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361534');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO DOMINGOS (ARAXÁ) - INEP: 166103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166103' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO DOMINGOS' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA POLITÉCNICA DO PLANALTO DE ARAXÁ (ARAXÁ) - INEP: 377864
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377864' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA POLITÉCNICA DO PLANALTO DE ARAXÁ' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377864');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA SANTA EDWIGES (ARAXÁ) - INEP: 325911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325911' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA SANTA EDWIGES' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CENTRO DE FORMAÇÃO PROFISSIONAL DE ARAXÁ (ARAXÁ) - INEP: 317888
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317888' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CENTRO DE FORMAÇÃO PROFISSIONAL DE ARAXÁ' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317888');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL DJALMA GUIMARÃES (ARAXÁ) - INEP: 298719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '298719' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL DJALMA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '298719');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PODIUM (CAMPOS ALTOS) - INEP: 373540
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373540' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PODIUM' 
      AND UPPER(TRIM(city)) = 'CAMPOS ALTOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373540');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO MIGUEL (CAMPOS ALTOS) - INEP: 365971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365971' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO MIGUEL' 
      AND UPPER(TRIM(city)) = 'CAMPOS ALTOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO ARAOLISS (CONCEIÇÃO DAS ALAGOAS) - INEP: 367974
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367974' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO ARAOLISS' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DAS ALAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367974');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIÃO - CÉU (CONCEIÇÃO DAS ALAGOAS) - INEP: 237060
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237060' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIÃO - CÉU' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DAS ALAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237060');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DESTAQUE (FRONTEIRA) - INEP: 349950
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349950' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DESTAQUE' 
      AND UPPER(TRIM(city)) = 'FRONTEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349950');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EQUILÍBRIO (FRONTEIRA) - INEP: 360490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '360490' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EQUILÍBRIO' 
      AND UPPER(TRIM(city)) = 'FRONTEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '360490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO (FRUTAL) - INEP: 246905
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246905' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246905');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO VICENTE DE PAULO (FRUTAL) - INEP: 166219
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166219' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO VICENTE DE PAULO' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166219');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PRESIDENTE VARGAS (FRUTAL) - INEP: 166201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166201' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PRESIDENTE VARGAS' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166201');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GALILEU PRÉ - VESTIBULAR (FRUTAL) - INEP: 347671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347671' 
    WHERE UPPER(TRIM(name)) = 'GALILEU PRÉ - VESTIBULAR' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FAMA (ITURAMA) - INEP: 368920
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368920' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FAMA' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368920');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DINÂMICA (ITURAMA) - INEP: 261980
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261980' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DINÂMICA' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261980');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SISTEMA INTELIGENTE DE APRENDIZAGEM (ITURAMA) - INEP: 247359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247359' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SISTEMA INTELIGENTE DE APRENDIZAGEM' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247359');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL PROFISSIONALIZANTE DE ITURAMA (ITURAMA) - INEP: 320871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320871' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL PROFISSIONALIZANTE DE ITURAMA' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320871');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BOM JESUS (PIRAJUBA) - INEP: 370290
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370290' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BOM JESUS' 
      AND UPPER(TRIM(city)) = 'PIRAJUBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370290');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ROUSSEAU (SACRAMENTO) - INEP: 304468
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '304468' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ROUSSEAU' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '304468');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA EURÍPEDES BARSANULFO (SACRAMENTO) - INEP: 166260
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166260' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA EURÍPEDES BARSANULFO' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166260');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL NOVO MUNDO (SANTA JULIANA) - INEP: 352039
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352039' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NOVO MUNDO' 
      AND UPPER(TRIM(city)) = 'SANTA JULIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352039');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO GRAU TÉCNICO UBERABA (UBERABA) - INEP: 376663
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376663' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO GRAU TÉCNICO UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376663');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL BIT MAIS UBERABA (UBERABA) - INEP: 315966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '315966' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL BIT MAIS UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '315966');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL FUTURA (UBERABA) - INEP: 299651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299651' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL FUTURA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MONTEIRO LOBATO (UBERABA) - INEP: 370355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370355' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL OPÇÃO (UBERABA) - INEP: 243418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '243418' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL OPÇÃO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '243418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL SÃO FRANCISCO ASSIS (UBERABA) - INEP: 247367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247367' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL SÃO FRANCISCO ASSIS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE UBERABA (UBERABA) - INEP: 381489
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381489' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381489');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COL CENECISTA DR JOSÉ FERREIRA (UBERABA) - INEP: 166481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166481' 
    WHERE UPPER(TRIM(name)) = 'COL CENECISTA DR JOSÉ FERREIRA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ANTARES (UBERABA) - INEP: 166448
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166448' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ANTARES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166448');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOIO (UBERABA) - INEP: 320536
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '320536' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOIO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '320536');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM BOSCO (UBERABA) - INEP: 278076
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278076' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278076');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO F.A.S (UBERABA) - INEP: 342041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342041' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO F.A.S' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GABARITO (UBERABA) - INEP: 354562
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354562' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GABARITO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354562');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTEGRADO UBERABA (UBERABA) - INEP: 377953
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377953' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTEGRADO UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377953');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JEAN CHRISTOPHE (UBERABA) - INEP: 166383
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166383' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JEAN CHRISTOPHE' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166383');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LICEU ALBERT EINSTEIN (UBERABA) - INEP: 260762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260762' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LICEU ALBERT EINSTEIN' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LIVRE APRENDER (UBERABA) - INEP: 376442
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376442' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LIVRE APRENDER' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376442');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MACHADO DE ASSIS (UBERABA) - INEP: 297071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297071' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MACHADO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MARISTA DIOCESANO (UBERABA) - INEP: 166332
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166332' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MARISTA DIOCESANO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166332');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MASTER MED (UBERABA) - INEP: 370614
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370614' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MASTER MED' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370614');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DAS DORES (UBERABA) - INEP: 166359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166359' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DAS DORES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166359');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DAS GRAÇAS (UBERABA) - INEP: 166375
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166375' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166375');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRESBITERIANO COMENIUS (UBERABA) - INEP: 347248
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347248' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRESBITERIANO COMENIUS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347248');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROJETO (UBERABA) - INEP: 166367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166367' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROJETO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ROUSSEAU - UNIDADE UBERABA (UBERABA) - INEP: 378240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378240' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ROUSSEAU - UNIDADE UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RUBEM ALVES (UBERABA) - INEP: 166456
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166456' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RUBEM ALVES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166456');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ADVENTISTA DE UBERABA (UBERABA) - INEP: 368539
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368539' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ADVENTISTA DE UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368539');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRIATIVA DE UBERABA (UBERABA) - INEP: 213365
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213365' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRIATIVA DE UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213365');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRISTÃ DE UBERABA - ESCRIBA (UBERABA) - INEP: 366609
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366609' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRISTÃ DE UBERABA - ESCRIBA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366609');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA POLITÉCNICA DO ALTO PARANAÍBA (UBERABA) - INEP: 368180
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368180' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA POLITÉCNICA DO ALTO PARANAÍBA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368180');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI ALBERTO MARTINS FONTOURA BORGES - UNIDADE II (UBERABA) - INEP: 379735
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379735' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI ALBERTO MARTINS FONTOURA BORGES - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379735');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE FORMAÇÃO PROFISSIONAL MG - EFOP (UBERABA) - INEP: 316105
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316105' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE FORMAÇÃO PROFISSIONAL MG - EFOP' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316105');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE UBERABA (UBERABA) - INEP: 323098
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323098' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323098');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA VITÓRIA FORMAÇÃO PROFISSIONAL (UBERABA) - INEP: 325902
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325902' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA VITÓRIA FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325902');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL FERREIRA GOMES (UBERABA) - INEP: 310395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310395' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL FERREIRA GOMES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO - CFP DE UBERABA (UBERABA) - INEP: 317446
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317446' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO - CFP DE UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317446');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI C DE FORM PROFIS FIDÉLIS REIS (UBERABA) - INEP: 311529
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311529' 
    WHERE UPPER(TRIM(name)) = 'SENAI C DE FORM PROFIS FIDÉLIS REIS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311529');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI ESC ALBERTO MARTINS FONTOURA BORGES (UBERABA) - INEP: 278084
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278084' 
    WHERE UPPER(TRIM(name)) = 'SESI ESC ALBERTO MARTINS FONTOURA BORGES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278084');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL BEIJA FLOR (ARAGUARI) - INEP: 311570
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311570' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL BEIJA FLOR' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311570');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL NOSSO LAR (ARAGUARI) - INEP: 278912
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278912' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NOSSO LAR' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278912');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALFA (ARAGUARI) - INEP: 340367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340367' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALFA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BERLAAR SAGRADO CORAÇÃO JESUS (ARAGUARI) - INEP: 170216
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170216' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BERLAAR SAGRADO CORAÇÃO JESUS' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170216');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NACIONAL (ARAGUARI) - INEP: 239666
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239666' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NACIONAL' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239666');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NACIONAL DE ARAGUARI (ARAGUARI) - INEP: 259349
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '259349' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NACIONAL DE ARAGUARI' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '259349');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA EDUCARE - UNIDADE II (ARAGUARI) - INEP: 370924
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370924' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA EDUCARE - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370924');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MACHADO DE ASSIS (ARAGUARI) - INEP: 170208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170208' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MACHADO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170208');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO FRANCISCO SAVÉRIO PETANHA (ARAGUARI) - INEP: 170232
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170232' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO FRANCISCO SAVÉRIO PETANHA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170232');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL MÁRIO ABDALLA (ARAGUARI) - INEP: 330931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330931' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL MÁRIO ABDALLA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI JOSE ALENCAR GOMES DA SILVA (ARAGUARI) - INEP: 268283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268283' 
    WHERE UPPER(TRIM(name)) = 'SESI JOSE ALENCAR GOMES DA SILVA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268283');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL GALILEU GALILEI (CAMPINA VERDE) - INEP: 247481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247481' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL GALILEU GALILEI' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SANTA TEREZINHA (CAMPINA VERDE) - INEP: 166162
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166162' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SANTA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166162');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PRÓTON ESCOLA TÉCNICA E PROFISSIONALIZANTE - UNIDADE CAMPINA VERDE (CAMPINA VERDE) - INEP: 326241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326241' 
    WHERE UPPER(TRIM(name)) = 'PRÓTON ESCOLA TÉCNICA E PROFISSIONALIZANTE - UNIDADE CAMPINA VERDE' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CASA ESCOLA PRIMEIROS PASSOS (MONTE ALEGRE DE MINAS) - INEP: 349224
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349224' 
    WHERE UPPER(TRIM(name)) = 'CASA ESCOLA PRIMEIROS PASSOS' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349224');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO MONTEALEGRENSE (MONTE ALEGRE DE MINAS) - INEP: 273911
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273911' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO MONTEALEGRENSE' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273911');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESA ESCOLA SOUZA ALVES (PRATA) - INEP: 324485
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324485' 
    WHERE UPPER(TRIM(name)) = 'ESA ESCOLA SOUZA ALVES' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324485');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NOSSA SENHORA APARECIDA (PRATA) - INEP: 232637
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232637' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NOSSA SENHORA APARECIDA' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232637');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- PRÓTON- ESCOLA TÉCNICA PROFISSIONALIZANTE (PRATA) - INEP: 324477
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324477' 
    WHERE UPPER(TRIM(name)) = 'PRÓTON- ESCOLA TÉCNICA PROFISSIONALIZANTE' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324477');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL NOSSA ESCOLA (TUPACIGUARA) - INEP: 351377
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351377' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL NOSSA ESCOLA' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351377');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ABELHINHA C EDUCACIONAL (TUPACIGUARA) - INEP: 170291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170291' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ABELHINHA C EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170291');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- AMEDUCA - COMPLEXO EDUCACIONAL (UBERLÂNDIA) - INEP: 275557
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '275557' 
    WHERE UPPER(TRIM(name)) = 'AMEDUCA - COMPLEXO EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '275557');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ASSOCIAÇÃO EDUCACIONAL JOHANN KEPLER (UBERLÂNDIA) - INEP: 323942
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323942' 
    WHERE UPPER(TRIM(name)) = 'ASSOCIAÇÃO EDUCACIONAL JOHANN KEPLER' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323942');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEIA -  ESCOLA PROFESSOR LUIZMAR ANTÔNIO DOS SANTOS (UBERLÂNDIA) - INEP: 350702
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350702' 
    WHERE UPPER(TRIM(name)) = 'CEIA - ESCOLA PROFESSOR LUIZMAR ANTÔNIO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350702');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO GRAU TÉCNICO UBERLÂNDIA (UBERLÂNDIA) - INEP: 375411
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375411' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO GRAU TÉCNICO UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375411');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL ADVENTISTA DE UBERLÂNDIA (UBERLÂNDIA) - INEP: 170348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170348' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL ADVENTISTA DE UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL BATISTA BETEL (UBERLÂNDIA) - INEP: 325325
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325325' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL BATISTA BETEL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325325');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CAMINHO SUAVE (UBERLÂNDIA) - INEP: 323055
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323055' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CAMINHO SUAVE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323055');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL COLIBRI (UBERLÂNDIA) - INEP: 280089
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280089' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL COLIBRI' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280089');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL EURÍPEDES BARSANULFO (UBERLÂNDIA) - INEP: 310280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310280' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL EURÍPEDES BARSANULFO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL GATO DE BOTAS - DRUMMOND (UBERLÂNDIA) - INEP: 275549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '275549' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL GATO DE BOTAS - DRUMMOND' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '275549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MONTEIRO LOBATO (UBERLÂNDIA) - INEP: 313301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313301' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO PEDAGÓGICO METTA (UBERLÂNDIA) - INEP: 368415
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368415' 
    WHERE UPPER(TRIM(name)) = 'CENTRO PEDAGÓGICO METTA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368415');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CETEC - CENTRO EDUCACIONAL E TECNOLÓGICO (UBERLÂNDIA) - INEP: 348090
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348090' 
    WHERE UPPER(TRIM(name)) = 'CETEC - CENTRO EDUCACIONAL E TECNOLÓGICO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348090');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ANN MACKENZIE (UBERLÂNDIA) - INEP: 375071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375071' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ANN MACKENZIE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ANN MACKENZIE UNIDADE GÁVEA - KARAÍBA (UBERLÂNDIA) - INEP: 380210
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380210' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ANN MACKENZIE UNIDADE GÁVEA - KARAÍBA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380210');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APOGEU (UBERLÂNDIA) - INEP: 278939
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278939' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APOGEU' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278939');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO (UBERLÂNDIA) - INEP: 275531
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '275531' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '275531');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO CASA BRANCA (UBERLÂNDIA) - INEP: 170615
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170615' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO CASA BRANCA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170615');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO CECON UBERLÂNDIA (UBERLÂNDIA) - INEP: 349046
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349046' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO CECON UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349046');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COPACABANA (UBERLÂNDIA) - INEP: 279846
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279846' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COPACABANA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279846');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DO TRABALHO UNIDADE I (UBERLÂNDIA) - INEP: 319953
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319953' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DO TRABALHO UNIDADE I' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319953');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DO TRABALHO UNIDADE II (UBERLÂNDIA) - INEP: 332712
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '332712' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DO TRABALHO UNIDADE II' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '332712');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM BOSCO (UBERLÂNDIA) - INEP: 343099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343099' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ENGETEC (UBERLÂNDIA) - INEP: 355682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355682' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ENGETEC' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ESPAÇO LETRADO (UBERLÂNDIA) - INEP: 335053
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '335053' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ESPAÇO LETRADO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '335053');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GABARITO (UBERLÂNDIA) - INEP: 352195
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352195' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GABARITO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352195');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTEGRAÇÃO PEQUENINO MUNDO (UBERLÂNDIA) - INEP: 170658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170658' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTEGRAÇÃO PEQUENINO MUNDO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAIS - UNIDADE JOÃO NAVES (UBERLÂNDIA) - INEP: 373893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373893' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAIS - UNIDADE JOÃO NAVES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373893');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MAIS POSITIVO (UBERLÂNDIA) - INEP: 342599
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342599' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MAIS POSITIVO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342599');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MARIA DE NAZARÉ (UBERLÂNDIA) - INEP: 318094
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318094' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MARIA DE NAZARÉ' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318094');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MARISTA CHAMPAGNAT (UBERLÂNDIA) - INEP: 170402
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170402' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MARISTA CHAMPAGNAT' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170402');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NACIONAL - UNIDADE I (UBERLÂNDIA) - INEP: 220094
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220094' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NACIONAL - UNIDADE I' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220094');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NACIONAL - UNIDADE IV (UBERLÂNDIA) - INEP: 369969
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369969' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NACIONAL - UNIDADE IV' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369969');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NACIONAL - UNIDADE V (UBERLÂNDIA) - INEP: 375276
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375276' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NACIONAL - UNIDADE V' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375276');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OLIMPO (UBERLÂNDIA) - INEP: 318426
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318426' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OLIMPO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318426');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIRLIMPIMPIM - SÃO PASCHOALL – UNIDADE II (UBERLÂNDIA) - INEP: 236187
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236187' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIRLIMPIMPIM - SÃO PASCHOALL – UNIDADE II' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236187');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIRLIMPIMPIM SÃO PASCHOALL - UNIDADE III (UBERLÂNDIA) - INEP: 375446
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375446' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIRLIMPIMPIM SÃO PASCHOALL - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375446');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIRLIMPIMPIM-SÃO PASCHOAL (UBERLÂNDIA) - INEP: 170534
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170534' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIRLIMPIMPIM-SÃO PASCHOAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170534');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROFISSIONAL (UBERLÂNDIA) - INEP: 310298
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310298' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310298');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROFISSIONAL - UNIDADE II (UBERLÂNDIA) - INEP: 351237
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351237' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROFISSIONAL - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351237');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO RESSURREIÇÃO NOSSA SENHORA (UBERLÂNDIA) - INEP: 170461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170461' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO RESSURREIÇÃO NOSSA SENHORA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ENFERMINAS - ESCOLA DE ENFERMAGEM DE MINAS GERAIS - UNIDADE UBERLÂNDIA (UBERLÂNDIA) - INEP: 381152
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381152' 
    WHERE UPPER(TRIM(name)) = 'ENFERMINAS - ESCOLA DE ENFERMAGEM DE MINAS GERAIS - UNIDADE UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381152');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ATHENAS (UBERLÂNDIA) - INEP: 309966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309966' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ATHENAS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309966');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA DA CRIANÇA ESPAÇO ADOLESCER (UBERLÂNDIA) - INEP: 230812
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230812' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA DA CRIANÇA ESPAÇO ADOLESCER' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230812');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA OFICINA DO SABER (UBERLÂNDIA) - INEP: 297241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297241' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA OFICINA DO SABER' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FAMATRI-CURSOS TÉCNICOS PROFISSIONALIZANTES (UBERLÂNDIA) - INEP: 324264
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324264' 
    WHERE UPPER(TRIM(name)) = 'FAMATRI-CURSOS TÉCNICOS PROFISSIONALIZANTES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324264');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- FUNDAÇÃO DE EDUCAÇÃO PARA O TRABALHO DE MINAS GERAIS - UTRAMIG (UBERLÂNDIA) - INEP: 361542
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361542' 
    WHERE UPPER(TRIM(name)) = 'FUNDAÇÃO DE EDUCAÇÃO PARA O TRABALHO DE MINAS GERAIS - UTRAMIG' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361542');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- GABARITO SISTEMA EDUCACIONAL (UBERLÂNDIA) - INEP: 357065
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357065' 
    WHERE UPPER(TRIM(name)) = 'GABARITO SISTEMA EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357065');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE ESTUDOS INTEGRADOS (UBERLÂNDIA) - INEP: 346845
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346845' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE ESTUDOS INTEGRADOS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346845');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SANTA MÔNICA (UBERLÂNDIA) - INEP: 210510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210510' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SANTA MÔNICA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL SHALOM (UBERLÂNDIA) - INEP: 230758
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230758' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL SHALOM' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230758');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PROPÉ (UBERLÂNDIA) - INEP: 375268
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375268' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PROPÉ' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375268');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO TERESA VALSÉ (UBERLÂNDIA) - INEP: 170607
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170607' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO TERESA VALSÉ' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170607');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MAPLE BEAR UBERLÂNDIA - UNIDADE II (UBERLÂNDIA) - INEP: 376590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376590' 
    WHERE UPPER(TRIM(name)) = 'MAPLE BEAR UBERLÂNDIA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376590');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC CENTRO DE FORMAÇÃO PROFISSIONAL (UBERLÂNDIA) - INEP: 318078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318078' 
    WHERE UPPER(TRIM(name)) = 'SENAC CENTRO DE FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI UBERLÂNDIA CENTRO DE FORMAÇÃO PROFISSIONAL DOUTOR CELSO CHARURI (UBERLÂNDIA) - INEP: 358843
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358843' 
    WHERE UPPER(TRIM(name)) = 'SENAI UBERLÂNDIA CENTRO DE FORMAÇÃO PROFISSIONAL DOUTOR CELSO CHARURI' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358843');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI UBERLÂNIA  CENTRO DE FORMAÇÃO PROFISSIONAL FÁBIO ARAÚJO MOTTA (UBERLÂNDIA) - INEP: 321575
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321575' 
    WHERE UPPER(TRIM(name)) = 'SENAI UBERLÂNIA CENTRO DE FORMAÇÃO PROFISSIONAL FÁBIO ARAÚJO MOTTA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321575');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI ESCOLA GUIOMAR DE FREITAS COSTA (UBERLÂNDIA) - INEP: 170321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170321' 
    WHERE UPPER(TRIM(name)) = 'SESI ESCOLA GUIOMAR DE FREITAS COSTA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL GÊNESIS (ARINOS) - INEP: 363774
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363774' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL GÊNESIS' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363774');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA JUSCELINO KUBITSCHEK (ARINOS) - INEP: 114715
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114715' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA JUSCELINO KUBITSCHEK' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114715');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE BONFINÓPOLIS DE MINAS (BONFINÓPOLIS DE MINAS) - INEP: 378500
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378500' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE BONFINÓPOLIS DE MINAS' 
      AND UPPER(TRIM(city)) = 'BONFINÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378500');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AMETISTA (BURITIS) - INEP: 348384
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348384' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AMETISTA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348384');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DA PENA (BURITIS) - INEP: 255262
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '255262' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DA PENA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '255262');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA DE NATALÂNDIA - EFAN (NATALÂNDIA) - INEP: 349372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349372' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA DE NATALÂNDIA - EFAN' 
      AND UPPER(TRIM(city)) = 'NATALÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- BOM SUCESSO ESCOLA MONTESSORIANA (UNAÍ) - INEP: 365599
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365599' 
    WHERE UPPER(TRIM(name)) = 'BOM SUCESSO ESCOLA MONTESSORIANA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365599');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATHOS - UNIDADE II (UNAÍ) - INEP: 380229
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380229' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATHOS - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380229');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CENECISTA NOSSA SENHORA DO CARMO (UNAÍ) - INEP: 114812
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114812' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CENECISTA NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114812');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOVO MUNDO (UNAÍ) - INEP: 322245
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322245' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOVO MUNDO' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322245');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE UNAÍ (UNAÍ) - INEP: 310336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310336' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE UNAÍ' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310336');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IEL - INSTITUTO EDUCACIONAL LATTES (UNAÍ) - INEP: 376671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376671' 
    WHERE UPPER(TRIM(name)) = 'IEL - INSTITUTO EDUCACIONAL LATTES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO ATHOS (UNAÍ) - INEP: 114804
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114804' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO ATHOS' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114804');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PALMARES (ALFENAS) - INEP: 321991
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321991' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PALMARES' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321991');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÁGUIA (ALFENAS) - INEP: 355640
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '355640' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÁGUIA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '355640');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATENAS (ALFENAS) - INEP: 180211
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180211' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATENAS' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180211');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ATENAS UNID II (ALFENAS) - INEP: 331163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331163' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ATENAS UNID II' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CRA (ALFENAS) - INEP: 346799
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346799' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CRA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346799');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PONTUAL DE ALFENAS (ALFENAS) - INEP: 318345
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318345' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PONTUAL DE ALFENAS' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318345');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROFESSOR ROQUE NICOLAU TAMBURINI (ALFENAS) - INEP: 319945
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319945' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROFESSOR ROQUE NICOLAU TAMBURINI' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319945');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SAGRADO CORAÇÃO DE JESUS (ALFENAS) - INEP: 180220
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180220' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SAGRADO CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180220');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ETAP - ESCOLA TÉCNICA DE APRENDIZADO PROFISSIONAL (ALFENAS) - INEP: 328901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '328901' 
    WHERE UPPER(TRIM(name)) = 'ETAP - ESCOLA TÉCNICA DE APRENDIZADO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '328901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP DE ALFENAS (ALFENAS) - INEP: 359491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359491' 
    WHERE UPPER(TRIM(name)) = 'SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP DE ALFENAS' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PADRE JÚLIO MARIA (BOA ESPERANÇA) - INEP: 180271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180271' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PADRE JÚLIO MARIA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180271');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SEI (BOA ESPERANÇA) - INEP: 256501
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256501' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SEI' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256501');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SÃO JOÃO (CAMPANHA) - INEP: 268321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268321' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SÃO JOÃO' 
      AND UPPER(TRIM(city)) = 'CAMPANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EXTERNATO NOSSA SENHORA DE LOURDES (CAMPANHA) - INEP: 180319
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180319' 
    WHERE UPPER(TRIM(name)) = 'EXTERNATO NOSSA SENHORA DE LOURDES' 
      AND UPPER(TRIM(city)) = 'CAMPANHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180319');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COLIBRI (CAMPOS GERAIS) - INEP: 247189
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247189' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COLIBRI' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247189');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA LUZIA (CAMPOS GERAIS) - INEP: 279081
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279081' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA LUZIA' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279081');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PARQUE TIBETANO (CARMO DA CACHOEIRA) - INEP: 354546
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354546' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARQUE TIBETANO' 
      AND UPPER(TRIM(city)) = 'CARMO DA CACHOEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354546');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PARQUE TIBETANO COMUNIDADE FIGUEIRA (CARMO DA CACHOEIRA) - INEP: 346870
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346870' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PARQUE TIBETANO COMUNIDADE FIGUEIRA' 
      AND UPPER(TRIM(city)) = 'CARMO DA CACHOEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346870');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL PADRE NATAL FERLONI (ELÓI MENDES) - INEP: 372064
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372064' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL PADRE NATAL FERLONI' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372064');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FÊNIX (ELÓI MENDES) - INEP: 265306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265306' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FÊNIX' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EDUCAÇÃO E LAZER (LAMBARI) - INEP: 271616
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271616' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EDUCAÇÃO E LAZER' 
      AND UPPER(TRIM(city)) = 'LAMBARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271616');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO OBJETIVO DE LAMBARI (LAMBARI) - INEP: 310697
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310697' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO OBJETIVO DE LAMBARI' 
      AND UPPER(TRIM(city)) = 'LAMBARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310697');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA AGROECOLÓGICA SÍTIO ESPERANÇA (LAMBARI) - INEP: 347647
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347647' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA AGROECOLÓGICA SÍTIO ESPERANÇA' 
      AND UPPER(TRIM(city)) = 'LAMBARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347647');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO -  ESPACC ESPAÇO CULTURAL E EDUCACIONAL (MACHADO) - INEP: 310158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310158' 
    WHERE UPPER(TRIM(name)) = 'CENTRO - ESPACC ESPAÇO CULTURAL E EDUCACIONAL' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE FORMAÇÃO EDUCACIONAL MACHADENSE (MACHADO) - INEP: 279986
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279986' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE FORMAÇÃO EDUCACIONAL MACHADENSE' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279986');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL UNIMAPE (MACHADO) - INEP: 260878
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260878' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL UNIMAPE' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260878');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALIANÇA (MACHADO) - INEP: 369381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369381' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALIANÇA' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMACULADA CONCEIÇÃO (MACHADO) - INEP: 180408
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180408' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180408');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIVERSITÁRIO - UNICOL (MACHADO) - INEP: 330833
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330833' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIVERSITÁRIO - UNICOL' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330833');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL LOSANGO DONA CORINA (NEPOMUCENO) - INEP: 213926
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213926' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL LOSANGO DONA CORINA' 
      AND UPPER(TRIM(city)) = 'NEPOMUCENO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213926');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL FAZENDO ACONTECER CEFA (PARAGUAÇU) - INEP: 343315
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343315' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL FAZENDO ACONTECER CEFA' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343315');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BRILHO DO SABER (PARAGUAÇU) - INEP: 351393
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351393' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BRILHO DO SABER' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351393');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL COOPERAR (POÇO FUNDO) - INEP: 323951
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323951' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL COOPERAR' 
      AND UPPER(TRIM(city)) = 'POÇO FUNDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323951');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DESAFIO (SÃO GONÇALO DO SAPUCAÍ) - INEP: 316113
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316113' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DESAFIO' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316113');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO IRMÃO LUCAS (SÃO GONÇALO DO SAPUCAÍ) - INEP: 258920
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258920' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO IRMÃO LUCAS' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258920');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO GONÇALO DO SAPUCAÍ (SÃO GONÇALO DO SAPUCAÍ) - INEP: 375195
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375195' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO GONÇALO DO SAPUCAÍ' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375195');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI JOSÉ BENTO NOGUEIRA JUNQUEIRA (SÃO GONÇALO DO SAPUCAÍ) - INEP: 322903
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322903' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI JOSÉ BENTO NOGUEIRA JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322903');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SERVIÇO NACIONAL DE APRENDIZAGEM INDUSTRIAL - DRMG (SÃO GONÇALO DO SAPUCAÍ) - INEP: 370916
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370916' 
    WHERE UPPER(TRIM(name)) = 'SERVIÇO NACIONAL DE APRENDIZAGEM INDUSTRIAL - DRMG' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370916');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL FLOR DO IPÊ (TRÊS CORAÇÕES) - INEP: 313386
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313386' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL FLOR DO IPÊ' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313386');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CASTELO (TRÊS CORAÇÕES) - INEP: 368466
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368466' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CASTELO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368466');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMPÉRIO - UNIDADE III (TRÊS CORAÇÕES) - INEP: 374679
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374679' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMPÉRIO - UNIDADE III' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374679');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOVA GERAÇÃO (TRÊS CORAÇÕES) - INEP: 342742
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342742' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOVA GERAÇÃO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342742');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIÃO - UNIDADE II (TRÊS CORAÇÕES) - INEP: 342998
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342998' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIÃO - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342998');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIVERSITÁRIO APLICAÇÃO DA UNINCOR PROF JOSÉ MARIA FERREIRA MACIEL (TRÊS CORAÇÕES) - INEP: 180556
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180556' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIVERSITÁRIO APLICAÇÃO DA UNINCOR PROF JOSÉ MARIA FERREIRA MACIEL' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180556');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PADRÃO (TRÊS CORAÇÕES) - INEP: 310174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310174' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PADRÃO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE ENSINO TECNICO - CFP DE TRÊS CORAÇÕES (TRÊS CORAÇÕES) - INEP: 343510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343510' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE ENSINO TECNICO - CFP DE TRÊS CORAÇÕES' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOVO MILÊNIO (TRÊS PONTAS) - INEP: 296848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296848' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOVO MILÊNIO' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLEGIO PRÓSPERI (TRÊS PONTAS) - INEP: 222381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222381' 
    WHERE UPPER(TRIM(name)) = 'COLEGIO PRÓSPERI' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TRAVESSIA (TRÊS PONTAS) - INEP: 361313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361313' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TRAVESSIA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CORAÇÃO DE JESUS (TRÊS PONTAS) - INEP: 180572
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180572' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180572');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ETEC - ESCOLA TÉCNICA NOVO HORIZONTE (TRÊS PONTAS) - INEP: 329941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329941' 
    WHERE UPPER(TRIM(name)) = 'ETEC - ESCOLA TÉCNICA NOVO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- APLICAR - CURSOS DE EXCELÊNCIA (VARGINHA) - INEP: 373737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373737' 
    WHERE UPPER(TRIM(name)) = 'APLICAR - CURSOS DE EXCELÊNCIA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADVENTISTA DE VARGINHA - UNIDADE II (VARGINHA) - INEP: 372480
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372480' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADVENTISTA DE VARGINHA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372480');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÁGAPE DOM (VARGINHA) - INEP: 366269
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366269' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÁGAPE DOM' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366269');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALPHA (VARGINHA) - INEP: 180599
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180599' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALPHA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180599');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA DE VARGINHA (VARGINHA) - INEP: 180602
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180602' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA DE VARGINHA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180602');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOS SANTOS ANJOS (VARGINHA) - INEP: 180611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180611' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOS SANTOS ANJOS' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INOVA CAMINHOS DOURADOS (VARGINHA) - INEP: 306215
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306215' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INOVA CAMINHOS DOURADOS' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306215');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MARISTA (VARGINHA) - INEP: 293687
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293687' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MARISTA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293687');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MASTER VARGINHA (VARGINHA) - INEP: 296856
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '296856' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MASTER VARGINHA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '296856');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MARISTA CHAMPAGNAT DE VARGINHA (VARGINHA) - INEP: 351407
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351407' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MARISTA CHAMPAGNAT DE VARGINHA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351407');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMPACTO ESCOLA DE SAÚDE (VARGINHA) - INEP: 317497
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317497' 
    WHERE UPPER(TRIM(name)) = 'IMPACTO ESCOLA DE SAÚDE' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317497');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- LOGOS COLÉGIO E CURSO - FORMACAO INTEGRAL DE ENSINO FUNDAMENTAL E ENSINO MÉDIO (VARGINHA) - INEP: 316237
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '316237' 
    WHERE UPPER(TRIM(name)) = 'LOGOS COLÉGIO E CURSO - FORMACAO INTEGRAL DE ENSINO FUNDAMENTAL E ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '316237');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNID ENS TEC - CFP VARGINHA (VARGINHA) - INEP: 317675
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '317675' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNID ENS TEC - CFP VARGINHA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '317675');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI CENTRO DE FORMAÇÃO PROFISSIONAL ALOYSIO RIBEIRO DE ALMEIDA (VARGINHA) - INEP: 267414
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267414' 
    WHERE UPPER(TRIM(name)) = 'SENAI CENTRO DE FORMAÇÃO PROFISSIONAL ALOYSIO RIBEIRO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267414');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SESI ALOYSIO RIBEIRO DE ALMEIDA (VARGINHA) - INEP: 368954
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368954' 
    WHERE UPPER(TRIM(name)) = 'SESI ALOYSIO RIBEIRO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368954');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- VERIFICAÇÃO FINAL
SELECT COUNT(*) as total_com_inep FROM schools WHERE inep_code IS NOT NULL;
SELECT COUNT(*) as total_sem_inep FROM schools WHERE inep_code IS NULL;

