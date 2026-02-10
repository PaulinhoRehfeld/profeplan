-- Lote 1 de 9
-- Escolas 1 a 500

-- =====================================================
-- ATUALIZAÇÃO DE INEPs - TODAS AS REDES
-- Filtro: Fund2 (Anos Finais) + Ensino Médio + Técnico
-- Total de escolas: 4281
-- Escolas filtradas (não atendem critério): 10126
-- =====================================================


-- EE CORONEL JOSÉ VENÂNCIO DE SOUSA (ÁGUAS VERMELHAS) - INEP: 184381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184381' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ VENÂNCIO DE SOUSA' 
      AND UPPER(TRIM(city)) = 'ÁGUAS VERMELHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ITAMARATI (ÁGUAS VERMELHAS) - INEP: 184462
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184462' 
    WHERE UPPER(TRIM(name)) = 'EE DE ITAMARATI' 
      AND UPPER(TRIM(city)) = 'ÁGUAS VERMELHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184462');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MACHADO MINEIRO (ÁGUAS VERMELHAS) - INEP: 184403
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184403' 
    WHERE UPPER(TRIM(name)) = 'EE DE MACHADO MINEIRO' 
      AND UPPER(TRIM(city)) = 'ÁGUAS VERMELHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184403');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM FERNANDES ABADE (ÁGUAS VERMELHAS) - INEP: 184420
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184420' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM FERNANDES ABADE' 
      AND UPPER(TRIM(city)) = 'ÁGUAS VERMELHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184420');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC QUERUBIM FRÓES OTONI (ALMENARA) - INEP: 184578
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184578' 
    WHERE UPPER(TRIM(name)) = 'CESEC QUERUBIM FRÓES OTONI' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184578');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CONDE AFONSO CELSO (ALMENARA) - INEP: 184527
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184527' 
    WHERE UPPER(TRIM(name)) = 'EE CONDE AFONSO CELSO' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184527');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE PEDRA GRANDE (ALMENARA) - INEP: 184608
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184608' 
    WHERE UPPER(TRIM(name)) = 'EE DE PEDRA GRANDE' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184608');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOEL MARES (ALMENARA) - INEP: 246336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246336' 
    WHERE UPPER(TRIM(name)) = 'EE JOEL MARES' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246336');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOVIANO NAVES (ALMENARA) - INEP: 184551
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184551' 
    WHERE UPPER(TRIM(name)) = 'EE JOVIANO NAVES' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184551');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAUDELINA DIAS LACERDA (ALMENARA) - INEP: 184543
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184543' 
    WHERE UPPER(TRIM(name)) = 'EE LAUDELINA DIAS LACERDA' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184543');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TANCREDO NEVES (ALMENARA) - INEP: 184519
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184519' 
    WHERE UPPER(TRIM(name)) = 'EE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184519');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DOS SANTOS AMARAL (BANDEIRA) - INEP: 184632
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184632' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DOS SANTOS AMARAL' 
      AND UPPER(TRIM(city)) = 'BANDEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184632');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BARÃO DO RIO BRANCO (CACHOEIRA DE PAJEÚ) - INEP: 184616
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184616' 
    WHERE UPPER(TRIM(name)) = 'EE BARÃO DO RIO BRANCO' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DE PAJEÚ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184616');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO CARIRI (CACHOEIRA DE PAJEÚ) - INEP: 246328
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246328' 
    WHERE UPPER(TRIM(name)) = 'EE DO CARIRI' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DE PAJEÚ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246328');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO POVOADO DE ÁGUAS ALTAS (CACHOEIRA DE PAJEÚ) - INEP: 205613
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205613' 
    WHERE UPPER(TRIM(name)) = 'EE DO POVOADO DE ÁGUAS ALTAS' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DE PAJEÚ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205613');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MARISTELA (CURRAL DE DENTRO) - INEP: 184411
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184411' 
    WHERE UPPER(TRIM(name)) = 'EE DE MARISTELA' 
      AND UPPER(TRIM(city)) = 'CURRAL DE DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184411');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VERÍSSIMO TEIXEIRA COSTA (CURRAL DE DENTRO) - INEP: 184446
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184446' 
    WHERE UPPER(TRIM(name)) = 'EE VERÍSSIMO TEIXEIRA COSTA' 
      AND UPPER(TRIM(city)) = 'CURRAL DE DENTRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184446');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE DIVISA ALEGRE (DIVISA ALEGRE) - INEP: 184454
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184454' 
    WHERE UPPER(TRIM(name)) = 'EE DE DIVISA ALEGRE' 
      AND UPPER(TRIM(city)) = 'DIVISA ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184454');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBERTO VICENTE PEREIRA (DIVISÓPOLIS) - INEP: 184586
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184586' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERTO VICENTE PEREIRA' 
      AND UPPER(TRIM(city)) = 'DIVISÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184586');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE FELISBURGO (FELISBURGO) - INEP: 184691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184691' 
    WHERE UPPER(TRIM(name)) = 'EE DE FELISBURGO' 
      AND UPPER(TRIM(city)) = 'FELISBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TRANQUILINO PINTO COELHO (FELISBURGO) - INEP: 184705
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184705' 
    WHERE UPPER(TRIM(name)) = 'EE TRANQUILINO PINTO COELHO' 
      AND UPPER(TRIM(city)) = 'FELISBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184705');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALÍPIO DE MORAES (JACINTO) - INEP: 184764
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184764' 
    WHERE UPPER(TRIM(name)) = 'EE ALÍPIO DE MORAES' 
      AND UPPER(TRIM(city)) = 'JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184764');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO HAVAÍ (JACINTO) - INEP: 184799
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184799' 
    WHERE UPPER(TRIM(name)) = 'EE DO HAVAÍ' 
      AND UPPER(TRIM(city)) = 'JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184799');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ESTÊVÃO ARAÚJO (JACINTO) - INEP: 184756
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184756' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ESTÊVÃO ARAÚJO' 
      AND UPPER(TRIM(city)) = 'JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184756');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC ZEMARIA DO NORTE (JEQUITINHONHA) - INEP: 184969
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184969' 
    WHERE UPPER(TRIM(name)) = 'CESEC ZEMARIA DO NORTE' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184969');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOÃO DA CUNHA (JEQUITINHONHA) - INEP: 184977
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184977' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOÃO DA CUNHA' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184977');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL RAMIRO PEREIRA (JEQUITINHONHA) - INEP: 184837
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184837' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL RAMIRO PEREIRA' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184837');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR HENRIQUE HEITMANN (JEQUITINHONHA) - INEP: 232084
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232084' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR HENRIQUE HEITMANN' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232084');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO EPAMINONDAS RAMOS (JEQUITINHONHA) - INEP: 185001
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185001' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO EPAMINONDAS RAMOS' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185001');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANUEL DO NORTE (JEQUITINHONHA) - INEP: 184900
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184900' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANUEL DO NORTE' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184900');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO MIGUEL (JEQUITINHONHA) - INEP: 184918
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184918' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO MIGUEL' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184918');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE GIRU (JOAÍMA) - INEP: 185043
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185043' 
    WHERE UPPER(TRIM(name)) = 'EE DE GIRU' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185043');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO GOMES MOREIRA (JOAÍMA) - INEP: 185019
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185019' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO GOMES MOREIRA' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185019');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANOEL DO NORTE (JOAÍMA) - INEP: 185051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185051' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANOEL DO NORTE' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE JORDÂNIA (JORDÂNIA) - INEP: 185078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185078' 
    WHERE UPPER(TRIM(name)) = 'EE DE JORDÂNIA' 
      AND UPPER(TRIM(city)) = 'JORDÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FREI HENRIQUE DE COIMBRA (JORDÂNIA) - INEP: 185086
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185086' 
    WHERE UPPER(TRIM(name)) = 'EE FREI HENRIQUE DE COIMBRA' 
      AND UPPER(TRIM(city)) = 'JORDÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185086');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANOEL DA ROCHA PINTO (JORDÂNIA) - INEP: 185116
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185116' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANOEL DA ROCHA PINTO' 
      AND UPPER(TRIM(city)) = 'JORDÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185116');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE MATA VERDE (MATA VERDE) - INEP: 184594
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184594' 
    WHERE UPPER(TRIM(name)) = 'EE DE MATA VERDE' 
      AND UPPER(TRIM(city)) = 'MATA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184594');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ FERREIRA DA ROCHA (MATA VERDE) - INEP: 209643
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '209643' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ FERREIRA DA ROCHA' 
      AND UPPER(TRIM(city)) = 'MATA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '209643');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL DE SOUZA SANTOS (MONTE FORMOSO) - INEP: 185035
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185035' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL DE SOUZA SANTOS' 
      AND UPPER(TRIM(city)) = 'MONTE FORMOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185035');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOIS DE ABRIL (PALMÓPOLIS) - INEP: 185329
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185329' 
    WHERE UPPER(TRIM(name)) = 'EE DOIS DE ABRIL' 
      AND UPPER(TRIM(city)) = 'PALMÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185329');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR CLÓVIS SALGADO (PALMÓPOLIS) - INEP: 185353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185353' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'PALMÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185353');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC EDIRALVA DE OLIVEIRA ALMEIDA (PEDRA AZUL) - INEP: 311952
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311952' 
    WHERE UPPER(TRIM(name)) = 'CESEC EDIRALVA DE OLIVEIRA ALMEIDA' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311952');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANA FARIA (PEDRA AZUL) - INEP: 185213
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185213' 
    WHERE UPPER(TRIM(name)) = 'EE ANA FARIA' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185213');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CASSIANO MENDES (PEDRA AZUL) - INEP: 185205
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185205' 
    WHERE UPPER(TRIM(name)) = 'EE CASSIANO MENDES' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185205');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL PACÍFICO FARIA (PEDRA AZUL) - INEP: 185221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185221' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL PACÍFICO FARIA' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO JOÃO DE ALMEIDA (PEDRA AZUL) - INEP: 212831
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212831' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO JOÃO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212831');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GENI MARIA DE SOUZA (RIO DO PRADO) - INEP: 353558
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353558' 
    WHERE UPPER(TRIM(name)) = 'EE GENI MARIA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'RIO DO PRADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353558');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TEREZINHA PORTO FAGUNDES (RIO DO PRADO) - INEP: 245160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245160' 
    WHERE UPPER(TRIM(name)) = 'EE TEREZINHA PORTO FAGUNDES' 
      AND UPPER(TRIM(city)) = 'RIO DO PRADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LÍDIO ALMEIDA (RUBIM) - INEP: 185396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185396' 
    WHERE UPPER(TRIM(name)) = 'EE LÍDIO ALMEIDA' 
      AND UPPER(TRIM(city)) = 'RUBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE WALMIR ALMEIDA COSTA (RUBIM) - INEP: 185388
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185388' 
    WHERE UPPER(TRIM(name)) = 'EE WALMIR ALMEIDA COSTA' 
      AND UPPER(TRIM(city)) = 'RUBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185388');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL ELPÍDIO ALVES FERREIRA (SALTO DA DIVISA) - INEP: 185400
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185400' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ELPÍDIO ALVES FERREIRA' 
      AND UPPER(TRIM(city)) = 'SALTO DA DIVISA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185400');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL TINÔ (SALTO DA DIVISA) - INEP: 185418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185418' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL TINÔ' 
      AND UPPER(TRIM(city)) = 'SALTO DA DIVISA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ JOAQUIM CABRAL (SANTA MARIA DO SALTO) - INEP: 185442
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185442' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ JOAQUIM CABRAL' 
      AND UPPER(TRIM(city)) = 'SANTA MARIA DO SALTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185442');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CLEMENTE DA ROCHA BANDEIRA (SANTO ANTÔNIO DO JACINTO) - INEP: 185451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185451' 
    WHERE UPPER(TRIM(name)) = 'EE CLEMENTE DA ROCHA BANDEIRA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE CATAJÁS (SANTO ANTÔNIO DO JACINTO) - INEP: 185469
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185469' 
    WHERE UPPER(TRIM(name)) = 'EE DE CATAJÁS' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185469');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO POVOADO DE CRISTIANÓPOLIS (SANTO ANTÔNIO DO JACINTO) - INEP: 246301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246301' 
    WHERE UPPER(TRIM(name)) = 'EE DO POVOADO DE CRISTIANÓPOLIS' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO VIEIRA DE SOUZA (SANTO ANTÔNIO DO JACINTO) - INEP: 218324
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218324' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO VIEIRA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218324');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BOM JESUS DE AGUADA NOVA (ARAÇUAÍ) - INEP: 146013
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146013' 
    WHERE UPPER(TRIM(name)) = 'EE BOM JESUS DE AGUADA NOVA' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146013');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA DIAMANTINO (ARAÇUAÍ) - INEP: 146048
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146048' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA DIAMANTINO' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146048');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM JOSÉ DE HAAS (ARAÇUAÍ) - INEP: 146081
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146081' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOSÉ DE HAAS' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146081');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FREI ROGATO (ARAÇUAÍ) - INEP: 247707
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247707' 
    WHERE UPPER(TRIM(name)) = 'EE FREI ROGATO' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247707');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HILÁRIO PINHEIRO JARDIM (ARAÇUAÍ) - INEP: 146161
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146161' 
    WHERE UPPER(TRIM(name)) = 'EE HILÁRIO PINHEIRO JARDIM' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146161');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDUSTRIAL SÃO JOSÉ (ARAÇUAÍ) - INEP: 146099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146099' 
    WHERE UPPER(TRIM(name)) = 'EE INDUSTRIAL SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ISALTINA CAJUBI FULGÊNCIO (ARAÇUAÍ) - INEP: 146102
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146102' 
    WHERE UPPER(TRIM(name)) = 'EE ISALTINA CAJUBI FULGÊNCIO' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146102');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ DOS SANTOS NEIVA (ARAÇUAÍ) - INEP: 146170
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146170' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ DOS SANTOS NEIVA' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146170');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LEOPOLDO PEREIRA (ARAÇUAÍ) - INEP: 146129
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146129' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LEOPOLDO PEREIRA' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146129');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO MARQUES DE ABREU (CHAPADA DO NORTE) - INEP: 338729
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338729' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO MARQUES DE ABREU' 
      AND UPPER(TRIM(city)) = 'CHAPADA DO NORTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338729');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALPHONSUS DE GUIMARÃES (COMERCINHO) - INEP: 184641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184641' 
    WHERE UPPER(TRIM(name)) = 'EE ALPHONSUS DE GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'COMERCINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184641');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FERNANDO DA COSTA AMARAL (COMERCINHO) - INEP: 184667
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184667' 
    WHERE UPPER(TRIM(name)) = 'EE FERNANDO DA COSTA AMARAL' 
      AND UPPER(TRIM(city)) = 'COMERCINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184667');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARTHUR ANTÔNIO FERNANDES (CORONEL MURTA) - INEP: 146676
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146676' 
    WHERE UPPER(TRIM(name)) = 'EE ARTHUR ANTÔNIO FERNANDES' 
      AND UPPER(TRIM(city)) = 'CORONEL MURTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146676');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL MARIANO MURTA (CORONEL MURTA) - INEP: 146650
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146650' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL MARIANO MURTA' 
      AND UPPER(TRIM(city)) = 'CORONEL MURTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146650');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO MIRANDA (INDAIABIRA) - INEP: 276898
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276898' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO MIRANDA' 
      AND UPPER(TRIM(city)) = 'INDAIABIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276898');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CHAVES RIBEIRO (ITAOBIM) - INEP: 146889
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146889' 
    WHERE UPPER(TRIM(name)) = 'EE CHAVES RIBEIRO' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146889');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ITAOBIM (ITAOBIM) - INEP: 146897
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146897' 
    WHERE UPPER(TRIM(name)) = 'EE DE ITAOBIM' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146897');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃOS FERNANDES (ITAOBIM) - INEP: 146901
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146901' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃOS FERNANDES' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146901');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA DEYS LOPES JARDIM (ITAOBIM) - INEP: 310271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310271' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DEYS LOPES JARDIM' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310271');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE COMENDADOR MURTA (ITINGA) - INEP: 146951
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146951' 
    WHERE UPPER(TRIM(name)) = 'EE COMENDADOR MURTA' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146951');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ITINGA (ITINGA) - INEP: 322504
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322504' 
    WHERE UPPER(TRIM(name)) = 'EE DE ITINGA' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322504');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO POVOADO DE TAQUARAL (ITINGA) - INEP: 146978
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146978' 
    WHERE UPPER(TRIM(name)) = 'EE DO POVOADO DE TAQUARAL' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146978');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL DA SILVA GUSMÃO (ITINGA) - INEP: 146986
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146986' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL DA SILVA GUSMÃO' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146986');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO RAMALHO MOTA (JENIPAPO DE MINAS) - INEP: 330621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330621' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO RAMALHO MOTA' 
      AND UPPER(TRIM(city)) = 'JENIPAPO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE WILLY (JENIPAPO DE MINAS) - INEP: 330612
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330612' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE WILLY' 
      AND UPPER(TRIM(city)) = 'JENIPAPO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330612');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANÍBAL MELO (MEDINA) - INEP: 185175
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185175' 
    WHERE UPPER(TRIM(name)) = 'EE ANÍBAL MELO' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185175');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR MAX MACHADO (MEDINA) - INEP: 185191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185191' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR MAX MACHADO' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO FRANCISCO COSTA (MEDINA) - INEP: 185183
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185183' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO FRANCISCO COSTA' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185183');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZ TANURE (MEDINA) - INEP: 185159
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185159' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZ TANURE' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185159');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR MANOEL (MEDINA) - INEP: 185124
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185124' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR MANOEL' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185124');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR QUERUBIM CIRINO DE MATOS (MEDINA) - INEP: 185167
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185167' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR QUERUBIM CIRINO DE MATOS' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185167');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DAVID FERRAZ DE OLIVEIRA (NINHEIRA) - INEP: 349259
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349259' 
    WHERE UPPER(TRIM(name)) = 'EE DAVID FERRAZ DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'NINHEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349259');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MARCIONILO PEREIRA DUTRA (NINHEIRA) - INEP: 338737
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338737' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MARCIONILO PEREIRA DUTRA' 
      AND UPPER(TRIM(city)) = 'NINHEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338737');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR OSVALDO PREDILIANO SANT'ANA (SALINAS) - INEP: 218189
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218189' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR OSVALDO PREDILIANO SANT''ANA' 
      AND UPPER(TRIM(city)) = 'SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218189');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VICENTE JOSÉ FERREIRA (SALINAS) - INEP: 342807
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342807' 
    WHERE UPPER(TRIM(name)) = 'EE VICENTE JOSÉ FERREIRA' 
      AND UPPER(TRIM(city)) = 'SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342807');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (SANTA CRUZ DE SALINAS) - INEP: 361674
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361674' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DE SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361674');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DA LAPA (VIRGEM DA LAPA) - INEP: 148521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148521' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DA LAPA' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE OLEGÁRIO MACIEL (VIRGEM DA LAPA) - INEP: 148482
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148482' 
    WHERE UPPER(TRIM(name)) = 'EE OLEGÁRIO MACIEL' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148482');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO DOMINGOS (VIRGEM DA LAPA) - INEP: 148491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148491' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO DOMINGOS' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOÃO DO VACARIA (VIRGEM DA LAPA) - INEP: 148504
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148504' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOÃO DO VACARIA' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148504');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VALDOMIRO SILVA COSTA (VIRGEM DA LAPA) - INEP: 148512
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148512' 
    WHERE UPPER(TRIM(name)) = 'EE VALDOMIRO SILVA COSTA' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148512');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LIMA DUARTE (ANTÔNIO CARLOS) - INEP: 239372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239372' 
    WHERE UPPER(TRIM(name)) = 'EE LIMA DUARTE' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO CARLOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL E MÉDIO (BARBACENA) - INEP: 356905
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356905' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356905');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEPUTADO JOSÉ BONIFÁCIO LAFAYETTE DE ANDRADA (BARBACENA) - INEP: 273376
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273376' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO JOSÉ BONIFÁCIO LAFAYETTE DE ANDRADA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273376');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SENHORA DAS DORES (BARBACENA) - INEP: 302627
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '302627' 
    WHERE UPPER(TRIM(name)) = 'EE SENHORA DAS DORES' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '302627');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RUBEM ESTEVES RUFFO (OLIVEIRA FORTES) - INEP: 338664
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338664' 
    WHERE UPPER(TRIM(name)) = 'EE RUBEM ESTEVES RUFFO' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA FORTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338664');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ANTÔNIO BATISTA DO NASCIMENTO (PIEDADE DO RIO GRANDE) - INEP: 248479
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248479' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTÔNIO BATISTA DO NASCIMENTO' 
      AND UPPER(TRIM(city)) = 'PIEDADE DO RIO GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248479');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE EGYDIO REIS (SENHORA DOS REMÉDIOS) - INEP: 255611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '255611' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE EGYDIO REIS' 
      AND UPPER(TRIM(city)) = 'SENHORA DOS REMÉDIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '255611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LEONIDES ALVARENGA (AGUANIL) - INEP: 202134
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202134' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LEONIDES ALVARENGA' 
      AND UPPER(TRIM(city)) = 'AGUANIL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202134');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NÉLSON FERNANDES FRIAÇA (CAMACHO) - INEP: 202177
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202177' 
    WHERE UPPER(TRIM(name)) = 'EE NÉLSON FERNANDES FRIAÇA' 
      AND UPPER(TRIM(city)) = 'CAMACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202177');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSOR JOÃO DE OLIVEIRA  BARBOSA (CAMPO BELO) - INEP: 305219
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305219' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR JOÃO DE OLIVEIRA BARBOSA' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305219');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ABÍLIO NEVES (CAMPO BELO) - INEP: 202185
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202185' 
    WHERE UPPER(TRIM(name)) = 'EE ABÍLIO NEVES' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202185');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JARBAS GAMBOGI (CAMPO BELO) - INEP: 202304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202304' 
    WHERE UPPER(TRIM(name)) = 'EE JARBAS GAMBOGI' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA BAUAB GIBRAM (CAMPO BELO) - INEP: 202355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202355' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA BAUAB GIBRAM' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MIGUEL ROGANA (CAMPO BELO) - INEP: 202321
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202321' 
    WHERE UPPER(TRIM(name)) = 'EE MIGUEL ROGANA' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202321');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE ALBERTO FUGER (CAMPO BELO) - INEP: 202193
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202193' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ALBERTO FUGER' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202193');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOSÉ MONTEIRO (CAMPO BELO) - INEP: 202339
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202339' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ MONTEIRO' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202339');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ ESTEVES DE ANDRADE BOTELHO (CANA VERDE) - INEP: 202401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202401' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ ESTEVES DE ANDRADE BOTELHO' 
      AND UPPER(TRIM(city)) = 'CANA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE AMÉRICO (CANDEIAS) - INEP: 202487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202487' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE AMÉRICO' 
      AND UPPER(TRIM(city)) = 'CANDEIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE KENNEDY (CANDEIAS) - INEP: 202495
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202495' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE KENNEDY' 
      AND UPPER(TRIM(city)) = 'CANDEIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202495');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR OSMAR BICALHO (CRISTAIS) - INEP: 202665
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202665' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR OSMAR BICALHO' 
      AND UPPER(TRIM(city)) = 'CRISTAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202665');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (LAVRAS) - INEP: 203122
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203122' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203122');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AZARIAS RIBEIRO (LAVRAS) - INEP: 202894
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202894' 
    WHERE UPPER(TRIM(name)) = 'EE AZARIAS RIBEIRO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202894');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CINIRA CARVALHO (LAVRAS) - INEP: 217743
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217743' 
    WHERE UPPER(TRIM(name)) = 'EE CINIRA CARVALHO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217743');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CRISTIANO DE SOUZA (LAVRAS) - INEP: 202908
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202908' 
    WHERE UPPER(TRIM(name)) = 'EE CRISTIANO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202908');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DORA MATARAZZO (LAVRAS) - INEP: 202967
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202967' 
    WHERE UPPER(TRIM(name)) = 'EE DORA MATARAZZO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202967');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOÃO BATISTA HERMETO (LAVRAS) - INEP: 202975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202975' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOÃO BATISTA HERMETO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FIRMINO COSTA (LAVRAS) - INEP: 203009
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203009' 
    WHERE UPPER(TRIM(name)) = 'EE FIRMINO COSTA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203009');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TIRADENTES (LAVRAS) - INEP: 203106
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203106' 
    WHERE UPPER(TRIM(name)) = 'EE TIRADENTES' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203106');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARMELITA CARVALHO GARCIA (PERDÕES) - INEP: 203483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203483' 
    WHERE UPPER(TRIM(name)) = 'EE CARMELITA CARVALHO GARCIA' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ELVIRA LOPES RESENDE (PERDÕES) - INEP: 203491
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203491' 
    WHERE UPPER(TRIM(name)) = 'EE ELVIRA LOPES RESENDE' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203491');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO MELO GOMIDE (PERDÕES) - INEP: 203441
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203441' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO MELO GOMIDE' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203441');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR GETÚLIO JOSÉ SOARES (PERDÕES) - INEP: 203475
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203475' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR GETÚLIO JOSÉ SOARES' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203475');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO NOVAIS (RIBEIRÃO VERMELHO) - INEP: 203521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203521' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO NOVAIS' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO VERMELHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARMELITA CARVALHO GARCIA (SANTANA DO JACARÉ) - INEP: 203530
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203530' 
    WHERE UPPER(TRIM(name)) = 'EE CARMELITA CARVALHO GARCIA' 
      AND UPPER(TRIM(city)) = 'SANTANA DO JACARÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203530');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBERICO FERREIRA NAVES (SANTO ANTÔNIO DO AMPARO) - INEP: 134473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134473' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERICO FERREIRA NAVES' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR CÍCERO FERREIRA (SANTO ANTÔNIO DO AMPARO) - INEP: 134490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134490' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR CÍCERO FERREIRA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NEWTON FERREIRA DE PAIVA (SANTO ANTÔNIO DO AMPARO) - INEP: 134511
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134511' 
    WHERE UPPER(TRIM(name)) = 'EE NEWTON FERREIRA DE PAIVA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134511');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL MÁRIO CAMPOS (SÃO FRANCISCO DE PAULA) - INEP: 203564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203564' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL MÁRIO CAMPOS' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO DE PAULA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA ROSA DE FREITAS (FERVEDOURO) - INEP: 351148
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351148' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ROSA DE FREITAS' 
      AND UPPER(TRIM(city)) = 'FERVEDOURO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351148');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA CONCEIÇÃO GONÇALVES CARRARA (PEDRA DOURADA) - INEP: 322652
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322652' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA CONCEIÇÃO GONÇALVES CARRARA' 
      AND UPPER(TRIM(city)) = 'PEDRA DOURADA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322652');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO PAULO II (BOM JESUS DO GALHO) - INEP: 213314
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213314' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO PAULO II' 
      AND UPPER(TRIM(city)) = 'BOM JESUS DO GALHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213314');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELICIANO MIGUEL ABDALLA (CARATINGA) - INEP: 353450
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353450' 
    WHERE UPPER(TRIM(name)) = 'EE FELICIANO MIGUEL ABDALLA' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353450');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MOACYR DE MATTOS (CARATINGA) - INEP: 253855
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253855' 
    WHERE UPPER(TRIM(name)) = 'EE MOACYR DE MATTOS' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253855');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR JOAQUIM NUNES (CARATINGA) - INEP: 218766
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218766' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOAQUIM NUNES' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218766');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA DINALVA MARIA DE SOUZA (PINGO-D'ÁGUA) - INEP: 213306
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213306' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DINALVA MARIA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'PINGO-D''ÁGUA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213306');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CONSELHEIRO FIDÉLIS (AIURUOCA) - INEP: 170682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170682' 
    WHERE UPPER(TRIM(name)) = 'EE CONSELHEIRO FIDÉLIS' 
      AND UPPER(TRIM(city)) = 'AIURUOCA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA DO CARMO LIMA PINTO (ALAGOA) - INEP: 276464
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276464' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA DO CARMO LIMA PINTO' 
      AND UPPER(TRIM(city)) = 'ALAGOA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276464');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANÍSIO ESAÚ DOS SANTOS (BAEPENDI) - INEP: 171026
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171026' 
    WHERE UPPER(TRIM(name)) = 'EE ANÍSIO ESAÚ DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171026');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM ALVARENGA MACIEL (BAEPENDI) - INEP: 170984
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170984' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM ALVARENGA MACIEL' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170984');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DE MONTSERRAT (BAEPENDI) - INEP: 171042
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171042' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DE MONTSERRAT' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171042');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VARGEM DA LAGE (BAEPENDI) - INEP: 171051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171051' 
    WHERE UPPER(TRIM(name)) = 'EE VARGEM DA LAGE' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO JOÃO SEVERO (BOCAINA DE MINAS) - INEP: 294667
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294667' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO JOÃO SEVERO' 
      AND UPPER(TRIM(city)) = 'BOCAINA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294667');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEP-CENTRO DE EDUCAÇÃO PROFISSIONAL DE CAXAMBU (CAXAMBU) - INEP: 344656
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344656' 
    WHERE UPPER(TRIM(name)) = 'CEP-CENTRO DE EDUCAÇÃO PROFISSIONAL DE CAXAMBU' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344656');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CABO LUIZ DE QUEIROZ (CAXAMBU) - INEP: 311880
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311880' 
    WHERE UPPER(TRIM(name)) = 'EE CABO LUIZ DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311880');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOMINGOS GONÇALVES DE MELLO MINGOTE (CAXAMBU) - INEP: 172073
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172073' 
    WHERE UPPER(TRIM(name)) = 'EE DOMINGOS GONÇALVES DE MELLO MINGOTE' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172073');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RUTH MARTINS DE ALMEIDA (CAXAMBU) - INEP: 172081
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172081' 
    WHERE UPPER(TRIM(name)) = 'EE RUTH MARTINS DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172081');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM OTHON MOTTA (CONCEIÇÃO DO RIO VERDE) - INEP: 172146
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172146' 
    WHERE UPPER(TRIM(name)) = 'EE DOM OTHON MOTTA' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO RIO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172146');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE PEDRO RIBEIRO DE CASTRO (CONCEIÇÃO DO RIO VERDE) - INEP: 172120
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172120' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE PEDRO RIBEIRO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO RIO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172120');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR JOÃO CÂNCIO (CRUZÍLIA) - INEP: 172456
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172456' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR JOÃO CÂNCIO' 
      AND UPPER(TRIM(city)) = 'CRUZÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172456');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO SEBASTIÃO (CRUZÍLIA) - INEP: 172464
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172464' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'CRUZÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172464');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NILO PEÇANHA (ITAMONTE) - INEP: 172847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172847' 
    WHERE UPPER(TRIM(name)) = 'EE NILO PEÇANHA' 
      AND UPPER(TRIM(city)) = 'ITAMONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA SEMIANA (ITANHANDU) - INEP: 172910
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172910' 
    WHERE UPPER(TRIM(name)) = 'EE DONA SEMIANA' 
      AND UPPER(TRIM(city)) = 'ITANHANDU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172910');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR SOUZA NILO (ITANHANDU) - INEP: 172936
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172936' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR SOUZA NILO' 
      AND UPPER(TRIM(city)) = 'ITANHANDU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172936');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO DE ALMEIDA LISBOA (JESUÂNIA) - INEP: 172961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172961' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO DE ALMEIDA LISBOA' 
      AND UPPER(TRIM(city)) = 'JESUÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172961');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA ANTONIETA ROMANO SALGADO (OLÍMPIO NORONHA) - INEP: 173487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173487' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA ANTONIETA ROMANO SALGADO' 
      AND UPPER(TRIM(city)) = 'OLÍMPIO NORONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA APARECIDA (PASSA QUATRO) - INEP: 173762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173762' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA APARECIDA' 
      AND UPPER(TRIM(city)) = 'PASSA QUATRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA LOURDES CASTILHO FREITAS (PASSA QUATRO) - INEP: 173665
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173665' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA LOURDES CASTILHO FREITAS' 
      AND UPPER(TRIM(city)) = 'PASSA QUATRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173665');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELIZARDA RUSSANO (POUSO ALTO) - INEP: 173916
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173916' 
    WHERE UPPER(TRIM(name)) = 'EE FELIZARDA RUSSANO' 
      AND UPPER(TRIM(city)) = 'POUSO ALTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173916');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC PROFESSORA NOÊMIA GOULART FERREIRA (SÃO LOURENÇO) - INEP: 174203
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174203' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA NOÊMIA GOULART FERREIRA' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174203');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR HUMBERTO SANCHES (SÃO LOURENÇO) - INEP: 174149
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174149' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR HUMBERTO SANCHES' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174149');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO MAGALHÃES ALVES (SÃO LOURENÇO) - INEP: 174190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174190' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO MAGALHÃES ALVES' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MÁRIO JUNQUEIRA FERRAZ (SÃO LOURENÇO) - INEP: 174181
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174181' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MÁRIO JUNQUEIRA FERRAZ' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174181');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR TÚLIO BENTO (SÃO LOURENÇO) - INEP: 356832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356832' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR TÚLIO BENTO' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ RIBEIRO MIRA (SÃO SEBASTIÃO DO RIO VERDE) - INEP: 330744
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330744' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ RIBEIRO MIRA' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO RIO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330744');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO SOBRADINHO (SÃO THOMÉ DAS LETRAS) - INEP: 174220
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174220' 
    WHERE UPPER(TRIM(name)) = 'EE DO SOBRADINHO' 
      AND UPPER(TRIM(city)) = 'SÃO THOMÉ DAS LETRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174220');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ CRISTIANO ALVES (SÃO THOMÉ DAS LETRAS) - INEP: 174246
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174246' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ CRISTIANO ALVES' 
      AND UPPER(TRIM(city)) = 'SÃO THOMÉ DAS LETRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174246');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINISTRO CLÓVIS SALGADO (SERITINGA) - INEP: 174289
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174289' 
    WHERE UPPER(TRIM(name)) = 'EE MINISTRO CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'SERITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174289');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DO BONSUCESSO (SERRANOS) - INEP: 305260
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305260' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DO BONSUCESSO' 
      AND UPPER(TRIM(city)) = 'SERRANOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305260');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA MARIANA CARVALHAL COSTA (SOLEDADE DE MINAS) - INEP: 174319
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174319' 
    WHERE UPPER(TRIM(name)) = 'EE DONA MARIANA CARVALHAL COSTA' 
      AND UPPER(TRIM(city)) = 'SOLEDADE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174319');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SILVESTRE NUNES (CASA GRANDE) - INEP: 193348
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193348' 
    WHERE UPPER(TRIM(name)) = 'EE SILVESTRE NUNES' 
      AND UPPER(TRIM(city)) = 'CASA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193348');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GUSTAVO AUGUSTO DA SILVA (CATAS ALTAS DA NORUEGA) - INEP: 193356
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193356' 
    WHERE UPPER(TRIM(name)) = 'EE GUSTAVO AUGUSTO DA SILVA' 
      AND UPPER(TRIM(city)) = 'CATAS ALTAS DA NORUEGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193356');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BARÃO DE PARAOPEBA (CONGONHAS) - INEP: 193399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193399' 
    WHERE UPPER(TRIM(name)) = 'EE BARÃO DE PARAOPEBA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELICIANO MENDES (CONGONHAS) - INEP: 193429
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193429' 
    WHERE UPPER(TRIM(name)) = 'EE FELICIANO MENDES' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193429');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAMARTINE DE FREITAS (CONGONHAS) - INEP: 193453
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193453' 
    WHERE UPPER(TRIM(name)) = 'EE LAMARTINE DE FREITAS' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193453');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AUGUSTO JOSÉ VIEIRA (CONSELHEIRO LAFAIETE) - INEP: 193551
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193551' 
    WHERE UPPER(TRIM(name)) = 'EE AUGUSTO JOSÉ VIEIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193551');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOMINGOS BEBIANO (CONSELHEIRO LAFAIETE) - INEP: 193577
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193577' 
    WHERE UPPER(TRIM(name)) = 'EE DOMINGOS BEBIANO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193577');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ANTERO CHAVES (CONSELHEIRO LAFAIETE) - INEP: 193593
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193593' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTERO CHAVES' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193593');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ANTONIO NOGUEIRA DE REZENDE (CONSELHEIRO LAFAIETE) - INEP: 193801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193801' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTONIO NOGUEIRA DE REZENDE' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193801');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GENERAL SYLVIO RAULINO DE OLIVEIRA (CONSELHEIRO LAFAIETE) - INEP: 193631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193631' 
    WHERE UPPER(TRIM(name)) = 'EE GENERAL SYLVIO RAULINO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO BITTENCOURT (CONSELHEIRO LAFAIETE) - INEP: 193658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193658' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO BITTENCOURT' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193658');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ISAURA FERREIRA (CONSELHEIRO LAFAIETE) - INEP: 193691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193691' 
    WHERE UPPER(TRIM(name)) = 'EE ISAURA FERREIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LOPES FRANCO (CONSELHEIRO LAFAIETE) - INEP: 193747
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193747' 
    WHERE UPPER(TRIM(name)) = 'EE LOPES FRANCO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193747');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LUIZ DE MELLO VIANNA SOBRINHO (CONSELHEIRO LAFAIETE) - INEP: 193755
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193755' 
    WHERE UPPER(TRIM(name)) = 'EE LUIZ DE MELLO VIANNA SOBRINHO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193755');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MOACIR DE SOUZA DIAS (CONSELHEIRO LAFAIETE) - INEP: 219037
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219037' 
    WHERE UPPER(TRIM(name)) = 'EE MOACIR DE SOUZA DIAS' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219037');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR ANTÔNIO JOSÉ FERREIRA (CONSELHEIRO LAFAIETE) - INEP: 193682
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193682' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR ANTÔNIO JOSÉ FERREIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193682');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR HORTA (CONSELHEIRO LAFAIETE) - INEP: 193666
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193666' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR HORTA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193666');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NARCISO DE QUEIRÓS (CONSELHEIRO LAFAIETE) - INEP: 193771
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193771' 
    WHERE UPPER(TRIM(name)) = 'EE NARCISO DE QUEIRÓS' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193771');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PACÍFICO VIEIRA (CONSELHEIRO LAFAIETE) - INEP: 193780
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193780' 
    WHERE UPPER(TRIM(name)) = 'EE PACÍFICO VIEIRA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193780');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ASTOR VIANNA (CONSELHEIRO LAFAIETE) - INEP: 193542
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193542' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ASTOR VIANNA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193542');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE QUEIROZ JÚNIOR (CONSELHEIRO LAFAIETE) - INEP: 193585
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193585' 
    WHERE UPPER(TRIM(name)) = 'EE QUEIROZ JÚNIOR' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193585');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL ALCIDES DUTRA (CRISTIANO OTONI) - INEP: 193828
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193828' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ALCIDES DUTRA' 
      AND UPPER(TRIM(city)) = 'CRISTIANO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193828');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARMELA DUTRA (DESTERRO DE ENTRE RIOS) - INEP: 193879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193879' 
    WHERE UPPER(TRIM(name)) = 'EE CARMELA DUTRA' 
      AND UPPER(TRIM(city)) = 'DESTERRO DE ENTRE RIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EVARISTO AUGUSTO DE OLIVEIRA (DESTERRO DE ENTRE RIOS) - INEP: 193895
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193895' 
    WHERE UPPER(TRIM(name)) = 'EE EVARISTO AUGUSTO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'DESTERRO DE ENTRE RIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193895');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DE FÁTIMA (DESTERRO DE ENTRE RIOS) - INEP: 193852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193852' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DE FÁTIMA' 
      AND UPPER(TRIM(city)) = 'DESTERRO DE ENTRE RIOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193852');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM RODOLFO (ENTRE RIOS DE MINAS) - INEP: 218383
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218383' 
    WHERE UPPER(TRIM(name)) = 'EE DOM RODOLFO' 
      AND UPPER(TRIM(city)) = 'ENTRE RIOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218383');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EXPEDICIONÁRIO GERALDO BAETA (ENTRE RIOS DE MINAS) - INEP: 193925
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193925' 
    WHERE UPPER(TRIM(name)) = 'EE EXPEDICIONÁRIO GERALDO BAETA' 
      AND UPPER(TRIM(city)) = 'ENTRE RIOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193925');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO DOMINGUES (ENTRE RIOS DE MINAS) - INEP: 193950
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193950' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO DOMINGUES' 
      AND UPPER(TRIM(city)) = 'ENTRE RIOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193950');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RIBEIRO DE OLIVEIRA (ENTRE RIOS DE MINAS) - INEP: 193968
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193968' 
    WHERE UPPER(TRIM(name)) = 'EE RIBEIRO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'ENTRE RIOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193968');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CONSELHEIRO ANTÃO (ITAVERAVA) - INEP: 193992
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193992' 
    WHERE UPPER(TRIM(name)) = 'EE CONSELHEIRO ANTÃO' 
      AND UPPER(TRIM(city)) = 'ITAVERAVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193992');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA NOEMI NOGUEIRA (ITAVERAVA) - INEP: 194000
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194000' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA NOEMI NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'ITAVERAVA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194000');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTOS REIS (JECEABA) - INEP: 194042
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194042' 
    WHERE UPPER(TRIM(name)) = 'EE SANTOS REIS' 
      AND UPPER(TRIM(city)) = 'JECEABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194042');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NAPOLEÃO REIS (LAMIM) - INEP: 194107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194107' 
    WHERE UPPER(TRIM(name)) = 'EE NAPOLEÃO REIS' 
      AND UPPER(TRIM(city)) = 'LAMIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194107');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO LUIZ VIEIRA DA SILVA (OURO BRANCO) - INEP: 194123
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194123' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO LUIZ VIEIRA DA SILVA' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194123');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRACEMA DE ALMEIDA (OURO BRANCO) - INEP: 194158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194158' 
    WHERE UPPER(TRIM(name)) = 'EE IRACEMA DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LEVINDO COSTA CARVALHO (OURO BRANCO) - INEP: 194182
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194182' 
    WHERE UPPER(TRIM(name)) = 'EE LEVINDO COSTA CARVALHO' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194182');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO DE PAULA DIAS (PIRANGA) - INEP: 194298
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194298' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO DE PAULA DIAS' 
      AND UPPER(TRIM(city)) = 'PIRANGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194298');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL AMANTINO MACIEL (PIRANGA) - INEP: 194191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194191' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL AMANTINO MACIEL' 
      AND UPPER(TRIM(city)) = 'PIRANGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOSÉ ILDEFONSO (PIRANGA) - INEP: 194204
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194204' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ ILDEFONSO' 
      AND UPPER(TRIM(city)) = 'PIRANGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194204');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO FERREIRA MACIEL (PIRANGA) - INEP: 194263
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194263' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO FERREIRA MACIEL' 
      AND UPPER(TRIM(city)) = 'PIRANGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194263');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FRANCISCO SALES FERREIRA (PIRANGA) - INEP: 194255
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194255' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO SALES FERREIRA' 
      AND UPPER(TRIM(city)) = 'PIRANGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194255');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTO AMARO (QUELUZITO) - INEP: 194328
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194328' 
    WHERE UPPER(TRIM(name)) = 'EE SANTO AMARO' 
      AND UPPER(TRIM(city)) = 'QUELUZITO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194328');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MONSENHOR FRANCISCO MIGUEL FERNANDES (RIO ESPERA) - INEP: 196347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196347' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR FRANCISCO MIGUEL FERNANDES' 
      AND UPPER(TRIM(city)) = 'RIO ESPERA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DR JOÃO NOGUEIRA DE ALMEIDA (SANTANA DOS MONTES) - INEP: 194395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194395' 
    WHERE UPPER(TRIM(name)) = 'EE DR JOÃO NOGUEIRA DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'SANTANA DOS MONTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DESEMBARGADOR APRÍGIO RIBEIRO DE OLIVEIRA (SÃO BRÁS DO SUAÇUÍ) - INEP: 194425
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194425' 
    WHERE UPPER(TRIM(name)) = 'EE DESEMBARGADOR APRÍGIO RIBEIRO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SÃO BRÁS DO SUAÇUÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194425');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE QUINZINHO INÁCIO (SENHORA DE OLIVEIRA) - INEP: 194468
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194468' 
    WHERE UPPER(TRIM(name)) = 'EE QUINZINHO INÁCIO' 
      AND UPPER(TRIM(city)) = 'SENHORA DE OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194468');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERMANO PEDRO DE SOUZA (ANTÔNIO DIAS) - INEP: 190705
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190705' 
    WHERE UPPER(TRIM(name)) = 'EE GERMANO PEDRO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO DIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190705');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LETRO (ANTÔNIO DIAS) - INEP: 190683
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190683' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LETRO' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO DIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190683');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VICENTE INÁCIO BISPO (ANTÔNIO DIAS) - INEP: 190659
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190659' 
    WHERE UPPER(TRIM(name)) = 'EE VICENTE INÁCIO BISPO' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO DIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190659');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO HEMÉTRIO DE MENEZES (BELO ORIENTE) - INEP: 273368
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273368' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO HEMÉTRIO DE MENEZES' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273368');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRESIDENTE TANCREDO NEVES (BELO ORIENTE) - INEP: 190756
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190756' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'BELO ORIENTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190756');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FAGUNDES VARELA (BRAÚNAS) - INEP: 190772
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190772' 
    WHERE UPPER(TRIM(name)) = 'EE FAGUNDES VARELA' 
      AND UPPER(TRIM(city)) = 'BRAÚNAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190772');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA IZABEL MOREIRA PINTO (BRAÚNAS) - INEP: 190799
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190799' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA IZABEL MOREIRA PINTO' 
      AND UPPER(TRIM(city)) = 'BRAÚNAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190799');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBERTO GIOVANNINI (CORONEL FABRICIANO) - INEP: 190802
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190802' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERTO GIOVANNINI' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190802');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL SILVINO PEREIRA (CORONEL FABRICIANO) - INEP: 190926
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190926' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL SILVINO PEREIRA' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190926');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR GERALDO PERLINGEIRO DE ABREU (CORONEL FABRICIANO) - INEP: 221449
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '221449' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR GERALDO PERLINGEIRO DE ABREU' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '221449');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOAQUIM GOMES DA SILVEIRA NETO (CORONEL FABRICIANO) - INEP: 190829
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190829' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOAQUIM GOMES DA SILVEIRA NETO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190829');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ MARIA DE MAN (CORONEL FABRICIANO) - INEP: 190942
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190942' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ MARIA DE MAN' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190942');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR PEDRO CALMON (CORONEL FABRICIANO) - INEP: 190888
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190888' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PEDRO CALMON' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190888');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA CELINA MACHADO (CORONEL FABRICIANO) - INEP: 190900
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190900' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CELINA MACHADO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190900');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE RAULINO COTTA PACHECO (CORONEL FABRICIANO) - INEP: 190918
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190918' 
    WHERE UPPER(TRIM(name)) = 'EE RAULINO COTTA PACHECO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190918');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROTILDINO AVELINO (CORONEL FABRICIANO) - INEP: 190969
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190969' 
    WHERE UPPER(TRIM(name)) = 'EE ROTILDINO AVELINO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190969');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TANCREDO DE ALMEIDA NEVES (CORONEL FABRICIANO) - INEP: 190985
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190985' 
    WHERE UPPER(TRIM(name)) = 'EE TANCREDO DE ALMEIDA NEVES' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190985');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ZACARIAS ROQUE (CORONEL FABRICIANO) - INEP: 190977
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190977' 
    WHERE UPPER(TRIM(name)) = 'EE ZACARIAS ROQUE' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190977');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC JOÃO GUIMARÃES ROSA (IPATINGA) - INEP: 313726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313726' 
    WHERE UPPER(TRIM(name)) = 'CESEC JOÃO GUIMARÃES ROSA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (IPATINGA) - INEP: 191132
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191132' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191132');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALMIRANTE TOYODA (IPATINGA) - INEP: 190993
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190993' 
    WHERE UPPER(TRIM(name)) = 'EE ALMIRANTE TOYODA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190993');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CHICO MENDES (IPATINGA) - INEP: 191281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191281' 
    WHERE UPPER(TRIM(name)) = 'EE CHICO MENDES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOM HELVÉCIO (IPATINGA) - INEP: 191027
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191027' 
    WHERE UPPER(TRIM(name)) = 'EE DOM HELVÉCIO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191027');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA CAETANA AMÉRICA MENEZES (IPATINGA) - INEP: 191191
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191191' 
    WHERE UPPER(TRIM(name)) = 'EE DONA CAETANA AMÉRICA MENEZES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191191');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA CANUTA ROSA OLIVEIRA BARBOSA (IPATINGA) - INEP: 191221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191221' 
    WHERE UPPER(TRIM(name)) = 'EE DONA CANUTA ROSA OLIVEIRA BARBOSA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR OVÍDIO DE ANDRADE (IPATINGA) - INEP: 191035
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191035' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR OVÍDIO DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191035');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ENGENHEIRO AMARO LANARI JÚNIOR (IPATINGA) - INEP: 191183
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191183' 
    WHERE UPPER(TRIM(name)) = 'EE ENGENHEIRO AMARO LANARI JÚNIOR' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191183');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ENGENHEIRO MÁRCIO AGUIAR DA CUNHA (IPATINGA) - INEP: 191043
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191043' 
    WHERE UPPER(TRIM(name)) = 'EE ENGENHEIRO MÁRCIO AGUIAR DA CUNHA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191043');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GERALDO GOMES RIBEIRO (IPATINGA) - INEP: 191205
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191205' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO GOMES RIBEIRO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191205');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HAYDÉE MARIA IMACULADA SCHITTINI (IPATINGA) - INEP: 191159
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191159' 
    WHERE UPPER(TRIM(name)) = 'EE HAYDÉE MARIA IMACULADA SCHITTINI' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191159');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO WALMICK (IPATINGA) - INEP: 191078
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191078' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO WALMICK' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191078');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO XXIII (IPATINGA) - INEP: 191060
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191060' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO XXIII' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191060');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAURA XAVIER SANTANA (IPATINGA) - INEP: 191001
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191001' 
    WHERE UPPER(TRIM(name)) = 'EE LAURA XAVIER SANTANA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191001');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL IZÍDIO (IPATINGA) - INEP: 191086
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191086' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL IZÍDIO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191086');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOELA SOARES BICALHO (IPATINGA) - INEP: 191264
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191264' 
    WHERE UPPER(TRIM(name)) = 'EE MANOELA SOARES BICALHO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191264');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAURÍLIO ALBANESE NOVAES (IPATINGA) - INEP: 191124
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191124' 
    WHERE UPPER(TRIM(name)) = 'EE MAURÍLIO ALBANESE NOVAES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191124');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NACIF SELIM DE SALES (IPATINGA) - INEP: 191213
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191213' 
    WHERE UPPER(TRIM(name)) = 'EE NACIF SELIM DE SALES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191213');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NILZA LUZIA DE SOUZA BUTTA (IPATINGA) - INEP: 217310
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217310' 
    WHERE UPPER(TRIM(name)) = 'EE NILZA LUZIA DE SOUZA BUTTA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217310');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ELZA DE OLIVEIRA LAGE (IPATINGA) - INEP: 191299
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191299' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ELZA DE OLIVEIRA LAGE' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191299');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA ANTONIETA (IPATINGA) - INEP: 191116
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191116' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA ANTONIETA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191116');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SELIM JOSÉ DE SALLES (IPATINGA) - INEP: 191256
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191256' 
    WHERE UPPER(TRIM(name)) = 'EE SELIM JOSÉ DE SALLES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191256');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÔNIA MARIA SILVA GOMES (IPATINGA) - INEP: 191302
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191302' 
    WHERE UPPER(TRIM(name)) = 'EE SÔNIA MARIA SILVA GOMES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191302');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE WILSON ALVARENGA (IPATINGA) - INEP: 191248
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191248' 
    WHERE UPPER(TRIM(name)) = 'EE WILSON ALVARENGA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191248');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA SEBASTIANA DE ALMEIDA E SILVA (JAGUARAÇU) - INEP: 361453
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361453' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA SEBASTIANA DE ALMEIDA E SILVA' 
      AND UPPER(TRIM(city)) = 'JAGUARAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361453');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ANTÔNIO MARCIANO (JOANÉSIA) - INEP: 205621
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205621' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ANTÔNIO MARCIANO' 
      AND UPPER(TRIM(city)) = 'JOANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205621');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANOEL GONÇALVES FERREIRA (JOANÉSIA) - INEP: 191353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191353' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANOEL GONÇALVES FERREIRA' 
      AND UPPER(TRIM(city)) = 'JOANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191353');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA EUNICE DOS SANTOS COSTA (JOANÉSIA) - INEP: 191345
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191345' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA EUNICE DOS SANTOS COSTA' 
      AND UPPER(TRIM(city)) = 'JOANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191345');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HORTO BELÉM (MARLIÉRIA) - INEP: 191396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191396' 
    WHERE UPPER(TRIM(name)) = 'EE HORTO BELÉM' 
      AND UPPER(TRIM(city)) = 'MARLIÉRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LIBERATO DE CASTRO (MARLIÉRIA) - INEP: 191361
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191361' 
    WHERE UPPER(TRIM(name)) = 'EE LIBERATO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'MARLIÉRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191361');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CAETANO DIAS (MESQUITA) - INEP: 191434
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191434' 
    WHERE UPPER(TRIM(name)) = 'EE CAETANO DIAS' 
      AND UPPER(TRIM(city)) = 'MESQUITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191434');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRUDENTE DE MORAIS (MESQUITA) - INEP: 191418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191418' 
    WHERE UPPER(TRIM(name)) = 'EE PRUDENTE DE MORAIS' 
      AND UPPER(TRIM(city)) = 'MESQUITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALBERTINO FERREIRA DRUMOND (SANTANA DO PARAÍSO) - INEP: 191442
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191442' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERTINO FERREIRA DRUMOND' 
      AND UPPER(TRIM(city)) = 'SANTANA DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191442');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO LUIZ (SANTANA DO PARAÍSO) - INEP: 191451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191451' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO LUIZ' 
      AND UPPER(TRIM(city)) = 'SANTANA DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HERBERT JOSÉ DE SOUZA BETINHO (SANTANA DO PARAÍSO) - INEP: 330540
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330540' 
    WHERE UPPER(TRIM(name)) = 'EE HERBERT JOSÉ DE SOUZA BETINHO' 
      AND UPPER(TRIM(city)) = 'SANTANA DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330540');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM ELIZIÁRIO DA SILVA (SANTANA DO PARAÍSO) - INEP: 191469
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191469' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM ELIZIÁRIO DA SILVA' 
      AND UPPER(TRIM(city)) = 'SANTANA DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191469');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ROSA DAMASCENO (SANTANA DO PARAÍSO) - INEP: 191426
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191426' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ROSA DAMASCENO' 
      AND UPPER(TRIM(city)) = 'SANTANA DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191426');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SALVELINO FERNANDES MADEIRA (SANTANA DO PARAÍSO) - INEP: 191477
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191477' 
    WHERE UPPER(TRIM(name)) = 'EE SALVELINO FERNANDES MADEIRA' 
      AND UPPER(TRIM(city)) = 'SANTANA DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191477');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO SILVA (TIMÓTEO) - INEP: 191540
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191540' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO SILVA' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191540');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO COTTA DE FIGUEIREDO BARCELOS (TIMÓTEO) - INEP: 191663
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191663' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO COTTA DE FIGUEIREDO BARCELOS' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191663');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LEÔNCIO DE ARAÚJO (TIMÓTEO) - INEP: 191639
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191639' 
    WHERE UPPER(TRIM(name)) = 'EE LEÔNCIO DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191639');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ANA LETRO STAACKS (TIMÓTEO) - INEP: 191531
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191531' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ANA LETRO STAACKS' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191531');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA HAYDÉE DE SOUZA ABREU (TIMÓTEO) - INEP: 326445
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326445' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA HAYDÉE DE SOUZA ABREU' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326445');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA HILDA DE ARAÚJO OSÓRIO ZAUZA (TIMÓTEO) - INEP: 191566
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191566' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA HILDA DE ARAÚJO OSÓRIO ZAUZA' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191566');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO SEBASTIÃO (TIMÓTEO) - INEP: 191507
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191507' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO SEBASTIÃO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191507');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AFONSO SOARES DE FREITAS (AUGUSTO DE LIMA) - INEP: 140309
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140309' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO SOARES DE FREITAS' 
      AND UPPER(TRIM(city)) = 'AUGUSTO DE LIMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140309');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DO CARMO (BUENÓPOLIS) - INEP: 140384
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140384' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DO CARMO' 
      AND UPPER(TRIM(city)) = 'BUENÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140384');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE LAERTE ESPERANÇA OLIVEIRA (BUENÓPOLIS) - INEP: 140392
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140392' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE LAERTE ESPERANÇA OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'BUENÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140392');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALENCASTRO GUIMARÃES (CORINTO) - INEP: 140597
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140597' 
    WHERE UPPER(TRIM(name)) = 'EE ALENCASTRO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140597');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO VIEIRA MACHADO (CORINTO) - INEP: 140601
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140601' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO VIEIRA MACHADO' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140601');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DESEMBARGADOR CANEDO (CORINTO) - INEP: 140627
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140627' 
    WHERE UPPER(TRIM(name)) = 'EE DESEMBARGADOR CANEDO' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140627');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ BRÍGIDO PEREIRA PEDRA (CORINTO) - INEP: 140619
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140619' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ BRÍGIDO PEREIRA PEDRA' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140619');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAJOR CLARINDO DE PAIVA (CORINTO) - INEP: 140651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140651' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR CLARINDO DE PAIVA' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA AMÁLIA CAMPOS (CORINTO) - INEP: 140686
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140686' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA AMÁLIA CAMPOS' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140686');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE WALDEMAR ARAÚJO (CORINTO) - INEP: 140694
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140694' 
    WHERE UPPER(TRIM(name)) = 'EE WALDEMAR ARAÚJO' 
      AND UPPER(TRIM(city)) = 'CORINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140694');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DE CURVELO (CURVELO) - INEP: 346080
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346080' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346080');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG - UNIDADE CURVELO (CURVELO) - INEP: 368288
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368288' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG - UNIDADE CURVELO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368288');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTONINA MASCARENHAS GONZAGA (CURVELO) - INEP: 140864
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140864' 
    WHERE UPPER(TRIM(name)) = 'EE ANTONINA MASCARENHAS GONZAGA' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140864');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BASÍLIO FRANCISCO XAVIER (CURVELO) - INEP: 140899
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140899' 
    WHERE UPPER(TRIM(name)) = 'EE BASÍLIO FRANCISCO XAVIER' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140899');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BOLÍVAR DE FREITAS (CURVELO) - INEP: 140716
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140716' 
    WHERE UPPER(TRIM(name)) = 'EE BOLÍVAR DE FREITAS' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140716');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EURÍPEDES DE PAULA (CURVELO) - INEP: 140767
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140767' 
    WHERE UPPER(TRIM(name)) = 'EE EURÍPEDES DE PAULA' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140767');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INTERVENTOR ALCIDES LINS (CURVELO) - INEP: 140775
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140775' 
    WHERE UPPER(TRIM(name)) = 'EE INTERVENTOR ALCIDES LINS' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140775');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃ CLARENTINA (CURVELO) - INEP: 140856
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140856' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃ CLARENTINA' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140856');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IRMÃ RAIMUNDA MARQUES (CURVELO) - INEP: 140848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140848' 
    WHERE UPPER(TRIM(name)) = 'EE IRMÃ RAIMUNDA MARQUES' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MAJOR ANTÔNIO SALVO (CURVELO) - INEP: 140791
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140791' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR ANTÔNIO SALVO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140791');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MINISTRO ADAUTO LÚCIO CARDOSO (CURVELO) - INEP: 140708
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140708' 
    WHERE UPPER(TRIM(name)) = 'EE MINISTRO ADAUTO LÚCIO CARDOSO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140708');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE AUGUSTO HORTA (CURVELO) - INEP: 140872
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140872' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE AUGUSTO HORTA' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140872');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO GERALDO (CURVELO) - INEP: 140821
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140821' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO GERALDO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140821');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO VICENTE DE PAULO (CURVELO) - INEP: 140830
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140830' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO VICENTE DE PAULO' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140830');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÉRGIO EUGÊNIO DA SILVA (CURVELO) - INEP: 253421
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253421' 
    WHERE UPPER(TRIM(name)) = 'EE SÉRGIO EUGÊNIO DA SILVA' 
      AND UPPER(TRIM(city)) = 'CURVELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253421');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC HUMBERTO JOSÉ ELIAS (FELIXLÂNDIA) - INEP: 218685
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218685' 
    WHERE UPPER(TRIM(name)) = 'CESEC HUMBERTO JOSÉ ELIAS' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218685');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOSÉ GONÇALVES DE SOUZA (FELIXLÂNDIA) - INEP: 140953
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140953' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ GONÇALVES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140953');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ DO BURITI (FELIXLÂNDIA) - INEP: 140988
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140988' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ DO BURITI' 
      AND UPPER(TRIM(city)) = 'FELIXLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140988');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR PACÍFICO MASCARENHAS (INIMUTABA) - INEP: 141119
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141119' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR PACÍFICO MASCARENHAS' 
      AND UPPER(TRIM(city)) = 'INIMUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141119');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOSSA SENHORA DAS DORES (JOAQUIM FELÍCIO) - INEP: 141178
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141178' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DAS DORES' 
      AND UPPER(TRIM(city)) = 'JOAQUIM FELÍCIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141178');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO WALTER COELHO DA ROCHA (MORRO DA GARÇA) - INEP: 312070
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312070' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO WALTER COELHO DA ROCHA' 
      AND UPPER(TRIM(city)) = 'MORRO DA GARÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312070');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARLOS ALEXANDRE DE OLIVEIRA (TRÊS MARIAS) - INEP: 142042
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '142042' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS ALEXANDRE DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '142042');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO GUIMARÃES ROSA (TRÊS MARIAS) - INEP: 246417
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246417' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO GUIMARÃES ROSA' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246417');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ ERMÍRIO DE MORAIS (TRÊS MARIAS) - INEP: 141976
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141976' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ERMÍRIO DE MORAIS' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141976');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL PEREIRA DE FREITAS (TRÊS MARIAS) - INEP: 142026
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '142026' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL PEREIRA DE FREITAS' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '142026');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IVETA GOMES SANTANA (ANGELÂNDIA) - INEP: 330604
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330604' 
    WHERE UPPER(TRIM(name)) = 'EE IVETA GOMES SANTANA' 
      AND UPPER(TRIM(city)) = 'ANGELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330604');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENTO ROCHA DE JESUS (CAPELINHA) - INEP: 319376
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319376' 
    WHERE UPPER(TRIM(name)) = 'EE BENTO ROCHA DE JESUS' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319376');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOMINGOS PIMENTA DE FIGUEIREDO (CAPELINHA) - INEP: 205893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205893' 
    WHERE UPPER(TRIM(name)) = 'EE DOMINGOS PIMENTA DE FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205893');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROSARINHA PIMENTINHA (CAPELINHA) - INEP: 217646
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217646' 
    WHERE UPPER(TRIM(name)) = 'EE ROSARINHA PIMENTINHA' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217646');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO PEÇANHA DE OLIVEIRA (CAPELINHA) - INEP: 342718
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342718' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO PEÇANHA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342718');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JULIANA CATARINA DA SILVEIRA (DATAS) - INEP: 254355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254355' 
    WHERE UPPER(TRIM(name)) = 'EE JULIANA CATARINA DA SILVEIRA' 
      AND UPPER(TRIM(city)) = 'DATAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254355');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESTRA BEZINHA GANDRA (ITAMARANDIBA) - INEP: 217611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217611' 
    WHERE UPPER(TRIM(name)) = 'EE MESTRA BEZINHA GANDRA' 
      AND UPPER(TRIM(city)) = 'ITAMARANDIBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ERNESTO ALVES DE MENDONÇA (MINAS NOVAS) - INEP: 218448
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218448' 
    WHERE UPPER(TRIM(name)) = 'EE ERNESTO ALVES DE MENDONÇA' 
      AND UPPER(TRIM(city)) = 'MINAS NOVAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218448');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO FERNANDES DE AZEVEDO (MINAS NOVAS) - INEP: 218421
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218421' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO FERNANDES DE AZEVEDO' 
      AND UPPER(TRIM(city)) = 'MINAS NOVAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218421');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SEBASTIÃO GOMES DE ALMEIDA (MINAS NOVAS) - INEP: 217638
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217638' 
    WHERE UPPER(TRIM(name)) = 'EE SEBASTIÃO GOMES DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'MINAS NOVAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217638');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC SENHORA DA PIEDADE (TURMALINA) - INEP: 218367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218367' 
    WHERE UPPER(TRIM(name)) = 'CESEC SENHORA DA PIEDADE' 
      AND UPPER(TRIM(city)) = 'TURMALINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA EDITE GOMES (TURMALINA) - INEP: 246344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246344' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA EDITE GOMES' 
      AND UPPER(TRIM(city)) = 'TURMALINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO FRANCISCO DE ASSIS (CARMO DO CAJURU) - INEP: 307335
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307335' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'CARMO DO CAJURU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307335');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO TIRADENTES PMMG (DIVINÓPOLIS) - INEP: 364592
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364592' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO TIRADENTES PMMG' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364592');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARMELO MESQUITA (ITAPECERICA) - INEP: 202851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202851' 
    WHERE UPPER(TRIM(name)) = 'EE CARMELO MESQUITA' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202851');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE IMACULADA CONCEIÇÃO (ITAPECERICA) - INEP: 202762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202762' 
    WHERE UPPER(TRIM(name)) = 'EE IMACULADA CONCEIÇÃO' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA PATAXÓ MUÃ MIMATXI (ITAPECERICA) - INEP: 342521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342521' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA PATAXÓ MUÃ MIMATXI' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAMOUNIER GODOFREDO (ITAPECERICA) - INEP: 202843
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202843' 
    WHERE UPPER(TRIM(name)) = 'EE LAMOUNIER GODOFREDO' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202843');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE HERCULANO PAZ (ITAPECERICA) - INEP: 202797
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202797' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE HERCULANO PAZ' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202797');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEDRO LUIZ (ITAPECERICA) - INEP: 202860
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202860' 
    WHERE UPPER(TRIM(name)) = 'EE PEDRO LUIZ' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202860');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA GERALDA MAGELA LEÃO DE MELO (ITAÚNA) - INEP: 330841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330841' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA GERALDA MAGELA LEÃO DE MELO' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA GILKA DRUMOND DE FARIA (ITAÚNA) - INEP: 305642
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305642' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA GILKA DRUMOND DE FARIA' 
      AND UPPER(TRIM(city)) = 'ITAÚNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305642');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ TEOTÔNIO DE CASTRO (LAGOA DA PRATA) - INEP: 231746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231746' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ TEOTÔNIO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA LICA RAPOSO (LUZ) - INEP: 218405
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218405' 
    WHERE UPPER(TRIM(name)) = 'EE DONA LICA RAPOSO' 
      AND UPPER(TRIM(city)) = 'LUZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218405');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA ZELI DINIZ FONSECA (NOVA SERRANA) - INEP: 342530
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342530' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ZELI DINIZ FONSECA' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342530');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE LAURO (NOVA SERRANA) - INEP: 326135
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326135' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE LAURO' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326135');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ MARIA LOBATO (OLIVEIRA) - INEP: 203301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203301' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ MARIA LOBATO' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MÁRIO CAMPOS E SILVA (OLIVEIRA) - INEP: 203343
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203343' 
    WHERE UPPER(TRIM(name)) = 'EE MÁRIO CAMPOS E SILVA' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203343');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR PINHEIRO CAMPOS (OLIVEIRA) - INEP: 203360
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203360' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PINHEIRO CAMPOS' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203360');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOÃO BATISTA (OLIVEIRA) - INEP: 203408
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203408' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOÃO BATISTA' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203408');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE PAULO (SANTO ANTÔNIO DO MONTE) - INEP: 224014
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224014' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE PAULO' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO MONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224014');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE TAPIRAÍ (TAPIRAÍ) - INEP: 307416
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307416' 
    WHERE UPPER(TRIM(name)) = 'EE DE TAPIRAÍ' 
      AND UPPER(TRIM(city)) = 'TAPIRAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307416');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ELGE RENAN BRAGA (COROACI) - INEP: 267228
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '267228' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ELGE RENAN BRAGA' 
      AND UPPER(TRIM(city)) = 'COROACI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '267228');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CECÍLIA MEIRELES (GOVERNADOR VALADARES) - INEP: 354716
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354716' 
    WHERE UPPER(TRIM(name)) = 'EE CECÍLIA MEIRELES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354716');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO BAIRRO JARDIM DO IPÊ (GOVERNADOR VALADARES) - INEP: 205371
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205371' 
    WHERE UPPER(TRIM(name)) = 'EE DO BAIRRO JARDIM DO IPÊ' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205371');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR DARCY RIBEIRO (GOVERNADOR VALADARES) - INEP: 271241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271241' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR DARCY RIBEIRO' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA DAMÁZIO DE BARROS MENEZES (GOVERNADOR VALADARES) - INEP: 354724
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354724' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA DAMÁZIO DE BARROS MENEZES' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354724');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO FRANCISCO DE ASSIS (GOVERNADOR VALADARES) - INEP: 326861
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326861' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326861');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC DE ITABIRINHA (ITABIRINHA) - INEP: 351423
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351423' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE ITABIRINHA' 
      AND UPPER(TRIM(city)) = 'ITABIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351423');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR ALAIR ALVES COSTA (NOVA MÓDICA) - INEP: 147532
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147532' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ALAIR ALVES COSTA' 
      AND UPPER(TRIM(city)) = 'NOVA MÓDICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147532');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TRANQUILINO DIAS BRITO (SÃO JOSÉ DO DIVINO) - INEP: 147885
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147885' 
    WHERE UPPER(TRIM(name)) = 'EE TRANQUILINO DIAS BRITO' 
      AND UPPER(TRIM(city)) = 'SÃO JOSÉ DO DIVINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147885');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRIMEIRO DE JUNHO (TUMIRITINGA) - INEP: 246379
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246379' 
    WHERE UPPER(TRIM(name)) = 'EE PRIMEIRO DE JUNHO' 
      AND UPPER(TRIM(city)) = 'TUMIRITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246379');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ BONIFÁCIO SANTANA (ÁGUA BOA) - INEP: 254045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254045' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ BONIFÁCIO SANTANA' 
      AND UPPER(TRIM(city)) = 'ÁGUA BOA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA ÃGOHÓ KUÂP PATAXÓ (CARMÉSIA) - INEP: 369802
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369802' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA ÃGOHÓ KUÂP PATAXÓ' 
      AND UPPER(TRIM(city)) = 'CARMÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369802');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA PATAXÓ BACUMUXÁ (CARMÉSIA) - INEP: 277657
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277657' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA PATAXÓ BACUMUXÁ' 
      AND UPPER(TRIM(city)) = 'CARMÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277657');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ALMERINDA AGUIAR (COLUNA) - INEP: 213969
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213969' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ALMERINDA AGUIAR' 
      AND UPPER(TRIM(city)) = 'COLUNA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213969');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NADIM NOMAN (DORES DE GUANHÃES) - INEP: 322857
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322857' 
    WHERE UPPER(TRIM(name)) = 'EE NADIM NOMAN' 
      AND UPPER(TRIM(city)) = 'DORES DE GUANHÃES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322857');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARGARET BARROSO PINTO (SABINÓPOLIS) - INEP: 330680
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330680' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARGARET BARROSO PINTO' 
      AND UPPER(TRIM(city)) = 'SABINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330680');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALTAIR ANDRADE GUIMARÃES (SÃO SEBASTIÃO DO MARANHÃO) - INEP: 253316
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253316' 
    WHERE UPPER(TRIM(name)) = 'EE ALTAIR ANDRADE GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO MARANHÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253316');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA CIVA SIMÕES FONSECA (SENHORA DO PORTO) - INEP: 342548
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342548' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CIVA SIMÕES FONSECA' 
      AND UPPER(TRIM(city)) = 'SENHORA DO PORTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342548');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO POVOADO DE BOM JESUS DA BOA VISTA (VIRGINÓPOLIS) - INEP: 218146
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218146' 
    WHERE UPPER(TRIM(name)) = 'EE DO POVOADO DE BOM JESUS DA BOA VISTA' 
      AND UPPER(TRIM(city)) = 'VIRGINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218146');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GABRIEL RIBEIRO (CARMO DE MINAS) - INEP: 171956
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171956' 
    WHERE UPPER(TRIM(name)) = 'EE GABRIEL RIBEIRO' 
      AND UPPER(TRIM(city)) = 'CARMO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171956');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR GUEDES FERNANDES (CARMO DE MINAS) - INEP: 171964
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171964' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR GUEDES FERNANDES' 
      AND UPPER(TRIM(city)) = 'CARMO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171964');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO JOSÉ DIVINO (DOM VIÇOSO) - INEP: 305375
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305375' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO JOSÉ DIVINO' 
      AND UPPER(TRIM(city)) = 'DOM VIÇOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305375');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEP - CENTRO DE EDUCAÇÃO PROFISSIONAL DE ITAJUBÁ (ITAJUBÁ) - INEP: 310778
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310778' 
    WHERE UPPER(TRIM(name)) = 'CEP - CENTRO DE EDUCAÇÃO PROFISSIONAL DE ITAJUBÁ' 
      AND UPPER(TRIM(city)) = 'ITAJUBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310778');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EULÁLIA GOMES DE OLIVEIRA (PARAISÓPOLIS) - INEP: 305383
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305383' 
    WHERE UPPER(TRIM(name)) = 'EE EULÁLIA GOMES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PARAISÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305383');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DELFIM MOREIRA (VIRGÍNIA) - INEP: 175137
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175137' 
    WHERE UPPER(TRIM(name)) = 'EE DELFIM MOREIRA' 
      AND UPPER(TRIM(city)) = 'VIRGÍNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175137');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MANOEL MACHADO (VIRGÍNIA) - INEP: 175153
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175153' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MANOEL MACHADO' 
      AND UPPER(TRIM(city)) = 'VIRGÍNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175153');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO GONÇALVES DE OLIVEIRA (CACHOEIRA DOURADA) - INEP: 322814
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322814' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO GONÇALVES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DOURADA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322814');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ EZEQUIEL DE QUEIRÓS (CANÁPOLIS) - INEP: 312045
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312045' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ EZEQUIEL DE QUEIRÓS' 
      AND UPPER(TRIM(city)) = 'CANÁPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312045');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO FRANCISCO DE ASSIS (CANÁPOLIS) - INEP: 196380
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196380' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'CANÁPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196380');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR JUSCELINO (CAPINÓPOLIS) - INEP: 196401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196401' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR JUSCELINO' 
      AND UPPER(TRIM(city)) = 'CAPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÉRGIO DE FREITAS PACHECO (CAPINÓPOLIS) - INEP: 196398
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196398' 
    WHERE UPPER(TRIM(name)) = 'EE SÉRGIO DE FREITAS PACHECO' 
      AND UPPER(TRIM(city)) = 'CAPINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196398');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE WILSON DE MELO (CENTRALINA) - INEP: 196452
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196452' 
    WHERE UPPER(TRIM(name)) = 'EE WILSON DE MELO' 
      AND UPPER(TRIM(city)) = 'CENTRALINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196452');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE GURINHATÃ (GURINHATÃ) - INEP: 196461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196461' 
    WHERE UPPER(TRIM(name)) = 'EE DE GURINHATÃ' 
      AND UPPER(TRIM(city)) = 'GURINHATÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE HEITOR JOSÉ DE CASTRO (GURINHATÃ) - INEP: 196487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196487' 
    WHERE UPPER(TRIM(name)) = 'EE HEITOR JOSÉ DE CASTRO' 
      AND UPPER(TRIM(city)) = 'GURINHATÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BENEDITO WALDEMAR DA SILVA (IPIAÇU) - INEP: 196517
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196517' 
    WHERE UPPER(TRIM(name)) = 'EE BENEDITO WALDEMAR DA SILVA' 
      AND UPPER(TRIM(city)) = 'IPIAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196517');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC CLORINDA MARTINS TAVARES (ITUIUTABA) - INEP: 196703
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196703' 
    WHERE UPPER(TRIM(name)) = 'CESEC CLORINDA MARTINS TAVARES' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196703');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CONSERVATÓRIO ESTADUAL DE MÚSICA DOUTOR JOSÉ ZÓCCOLI DE ANDRADE (ITUIUTABA) - INEP: 196622
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196622' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO ESTADUAL DE MÚSICA DOUTOR JOSÉ ZÓCCOLI DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196622');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO SOUZA MARTINS (ITUIUTABA) - INEP: 196631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196631' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO SOUZA MARTINS' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ARTHUR JUNQUEIRA DE ALMEIDA (ITUIUTABA) - INEP: 196576
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196576' 
    WHERE UPPER(TRIM(name)) = 'EE ARTHUR JUNQUEIRA DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196576');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CÔNEGO ÂNGELO (ITUIUTABA) - INEP: 196541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196541' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO ÂNGELO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL JOÃO MARTINS (ITUIUTABA) - INEP: 196525
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196525' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOÃO MARTINS' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196525');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CORONEL TONICO FRANCO (ITUIUTABA) - INEP: 196533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196533' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL TONICO FRANCO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR FERNANDO ALEXANDRE (ITUIUTABA) - INEP: 196550
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196550' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR FERNANDO ALEXANDRE' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196550');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR BIAS FORTES (ITUIUTABA) - INEP: 196568
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196568' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR BIAS FORTES' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196568');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR CLÓVIS SALGADO (ITUIUTABA) - INEP: 196681
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196681' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196681');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GOVERNADOR ISRAEL PINHEIRO (ITUIUTABA) - INEP: 196584
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196584' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR ISRAEL PINHEIRO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196584');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO PINHEIRO (ITUIUTABA) - INEP: 196606
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196606' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196606');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR ÁLVARO BRANDÃO DE ANDRADE (ITUIUTABA) - INEP: 196657
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196657' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ÁLVARO BRANDÃO DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196657');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARIA DE BARROS (ITUIUTABA) - INEP: 196592
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196592' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA DE BARROS' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196592');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ROTARY (ITUIUTABA) - INEP: 196665
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196665' 
    WHERE UPPER(TRIM(name)) = 'EE ROTARY' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196665');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SENADOR CAMILO CHAVES (ITUIUTABA) - INEP: 196673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196673' 
    WHERE UPPER(TRIM(name)) = 'EE SENADOR CAMILO CHAVES' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196673');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ PARANAÍBA (SANTA VITÓRIA) - INEP: 196738
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196738' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ PARANAÍBA' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196738');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO JOSÉ FRANCO DE GOUVEIA (SANTA VITÓRIA) - INEP: 196720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196720' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO JOSÉ FRANCO DE GOUVEIA' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA DIRCE MARIA DE OLIVEIRA (SANTA VITÓRIA) - INEP: 338672
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338672' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DIRCE MARIA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SANTA VITÓRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338672');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM TEIXEIRA DE BRITO (CATUTI) - INEP: 239194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239194' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM TEIXEIRA DE BRITO' 
      AND UPPER(TRIM(city)) = 'CATUTI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALVACY DE FREITAS (ESPINOSA) - INEP: 362484
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '362484' 
    WHERE UPPER(TRIM(name)) = 'EE ALVACY DE FREITAS' 
      AND UPPER(TRIM(city)) = 'ESPINOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '362484');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BETÂNIA TOLENTINO SILVEIRA (ESPINOSA) - INEP: 212261
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212261' 
    WHERE UPPER(TRIM(name)) = 'EE BETÂNIA TOLENTINO SILVEIRA' 
      AND UPPER(TRIM(city)) = 'ESPINOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212261');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTOS DUMONT (ESPINOSA) - INEP: 218286
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218286' 
    WHERE UPPER(TRIM(name)) = 'EE SANTOS DUMONT' 
      AND UPPER(TRIM(city)) = 'ESPINOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218286');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO NÚCLEO HABITACIONAL I (JAÍBA) - INEP: 231843
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231843' 
    WHERE UPPER(TRIM(name)) = 'EE DO NÚCLEO HABITACIONAL I' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231843');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GUIMARÃES ROSA (JAÍBA) - INEP: 295086
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '295086' 
    WHERE UPPER(TRIM(name)) = 'EE GUIMARÃES ROSA' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '295086');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PEQUENOS IRRIGANTES (JAÍBA) - INEP: 231835
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231835' 
    WHERE UPPER(TRIM(name)) = 'EE PEQUENOS IRRIGANTES' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231835');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE TIMÓTEO LISBOA GUERRA (JAÍBA) - INEP: 239208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239208' 
    WHERE UPPER(TRIM(name)) = 'EE TIMÓTEO LISBOA GUERRA' 
      AND UPPER(TRIM(city)) = 'JAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239208');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CECÍLIA MARIA DE JESUS (JANAÚBA) - INEP: 218251
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218251' 
    WHERE UPPER(TRIM(name)) = 'EE CECÍLIA MARIA DE JESUS' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218251');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DOUTOR JOSÉ ESTEVES RODRIGUES (JANAÚBA) - INEP: 338680
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338680' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ ESTEVES RODRIGUES' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338680');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM MAURÍCIO DE AZEVEDO (JANAÚBA) - INEP: 233374
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233374' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM MAURÍCIO DE AZEVEDO' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233374');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JULIÃO MENDES FERREIRA (JANAÚBA) - INEP: 338699
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338699' 
    WHERE UPPER(TRIM(name)) = 'EE JULIÃO MENDES FERREIRA' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338699');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EREZINHA ANTUNES MARTINS (NOVA PORTEIRINHA) - INEP: 205648
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205648' 
    WHERE UPPER(TRIM(name)) = 'EE EREZINHA ANTUNES MARTINS' 
      AND UPPER(TRIM(city)) = 'NOVA PORTEIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205648');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MESTRE TOMAZ VALERIANO DE ARAÚJO (PORTEIRINHA) - INEP: 338702
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338702' 
    WHERE UPPER(TRIM(name)) = 'EE MESTRE TOMAZ VALERIANO DE ARAÚJO' 
      AND UPPER(TRIM(city)) = 'PORTEIRINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338702');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (RIO PARDO DE MINAS) - INEP: 349267
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349267' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'RIO PARDO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349267');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA MARLENE CARMO (RIO PARDO DE MINAS) - INEP: 212253
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212253' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARLENE CARMO' 
      AND UPPER(TRIM(city)) = 'RIO PARDO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212253');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALICE DE JESUS RODRIGUES (VERDELÂNDIA) - INEP: 351091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351091' 
    WHERE UPPER(TRIM(name)) = 'EE ALICE DE JESUS RODRIGUES' 
      AND UPPER(TRIM(city)) = 'VERDELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTONINA FERNANDES SAMPAIO (VERDELÂNDIA) - INEP: 351083
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351083' 
    WHERE UPPER(TRIM(name)) = 'EE ANTONINA FERNANDES SAMPAIO' 
      AND UPPER(TRIM(city)) = 'VERDELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351083');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CESÁRIO NUNES DOS SANTOS (BONITO DE MINAS) - INEP: 205532
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205532' 
    WHERE UPPER(TRIM(name)) = 'EE CESÁRIO NUNES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205532');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE BONFIM (BONITO DE MINAS) - INEP: 205516
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205516' 
    WHERE UPPER(TRIM(name)) = 'EE DE BONFIM' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205516');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL ANOS FINAIS E ENSINO MÉDIO (BONITO DE MINAS) - INEP: 369810
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369810' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL ANOS FINAIS E ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369810');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL PEREIRA MAGALHÃES (BONITO DE MINAS) - INEP: 205451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205451' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL PEREIRA MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SÃO JOSÉ DO GIBÃO (BONITO DE MINAS) - INEP: 205508
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205508' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ DO GIBÃO' 
      AND UPPER(TRIM(city)) = 'BONITO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205508');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MOACIR CÂNDIDO (CHAPADA GAÚCHA) - INEP: 205460
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205460' 
    WHERE UPPER(TRIM(name)) = 'EE MOACIR CÂNDIDO' 
      AND UPPER(TRIM(city)) = 'CHAPADA GAÚCHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205460');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO FUNDAMENTAL ANOS FINAIS E ENSINO MÉDIO (CÔNEGO MARINHO) - INEP: 369829
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369829' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL ANOS FINAIS E ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'CÔNEGO MARINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369829');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO FERNANDES VIANA (JANUÁRIA) - INEP: 246271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246271' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO FERNANDES VIANA' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246271');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE BOA VISTA (JANUÁRIA) - INEP: 212822
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '212822' 
    WHERE UPPER(TRIM(name)) = 'EE DE BOA VISTA' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '212822');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (JANUÁRIA) - INEP: 356778
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356778' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356778');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EULER TUPINÁ BASTOS (JANUÁRIA) - INEP: 253685
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253685' 
    WHERE UPPER(TRIM(name)) = 'EE EULER TUPINÁ BASTOS' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253685');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE FELIPE DIAS CORRÊA (JANUÁRIA) - INEP: 253677
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253677' 
    WHERE UPPER(TRIM(name)) = 'EE FELIPE DIAS CORRÊA' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253677');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MARIA ROSA NUNES (JANUÁRIA) - INEP: 246280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246280' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ROSA NUNES' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246280');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NOVA ESPERANÇA (JANUÁRIA) - INEP: 253651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253651' 
    WHERE UPPER(TRIM(name)) = 'EE NOVA ESPERANÇA' 
      AND UPPER(TRIM(city)) = 'JANUÁRIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL FERNANDES DA SILVA (JUVENÍLIA) - INEP: 342726
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342726' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL FERNANDES DA SILVA' 
      AND UPPER(TRIM(city)) = 'JUVENÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342726');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (MATIAS CARDOSO) - INEP: 342734
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342734' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'MATIAS CARDOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342734');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA VILA NOVO HORIZONTE (MONTALVÂNIA) - INEP: 217913
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217913' 
    WHERE UPPER(TRIM(name)) = 'EE DA VILA NOVO HORIZONTE' 
      AND UPPER(TRIM(city)) = 'MONTALVÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217913');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE POÇÃOZINHO (PEDRAS DE MARIA DA CRUZ) - INEP: 239429
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239429' 
    WHERE UPPER(TRIM(name)) = 'EE DE POÇÃOZINHO' 
      AND UPPER(TRIM(city)) = 'PEDRAS DE MARIA DA CRUZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239429');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DONA CILA (PEDRAS DE MARIA DA CRUZ) - INEP: 239330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239330' 
    WHERE UPPER(TRIM(name)) = 'EE DONA CILA' 
      AND UPPER(TRIM(city)) = 'PEDRAS DE MARIA DA CRUZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PRIMAVERA (PINTÓPOLIS) - INEP: 253847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253847' 
    WHERE UPPER(TRIM(name)) = 'EE PRIMAVERA' 
      AND UPPER(TRIM(city)) = 'PINTÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE BRASILIANO BRAZ (SÃO FRANCISCO) - INEP: 240222
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240222' 
    WHERE UPPER(TRIM(name)) = 'EE BRASILIANO BRAZ' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240222');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA PASSAGEM FUNDA (SÃO FRANCISCO) - INEP: 239411
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239411' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA PASSAGEM FUNDA' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239411');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EPAMINONDAS LEITE (SÃO FRANCISCO) - INEP: 253588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253588' 
    WHERE UPPER(TRIM(name)) = 'EE EPAMINONDAS LEITE' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EVERARDO GONÇALVES BOTELHO (SÃO FRANCISCO) - INEP: 239313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239313' 
    WHERE UPPER(TRIM(name)) = 'EE EVERARDO GONÇALVES BOTELHO' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ALINE DIAS NEVES (SÃO JOÃO DAS MISSÕES) - INEP: 338761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338761' 
    WHERE UPPER(TRIM(name)) = 'EE ALINE DIAS NEVES' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA BUKIMUJU (SÃO JOÃO DAS MISSÕES) - INEP: 269875
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269875' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA BUKIMUJU' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269875');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA BUKINUK (SÃO JOÃO DAS MISSÕES) - INEP: 322571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322571' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA BUKINUK' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (SÃO JOÃO DAS MISSÕES) - INEP: 369837
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369837' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369837');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL E ENSINO MÉDIO (SÃO JOÃO DAS MISSÕES) - INEP: 356786
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356786' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL E ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356786');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL E ENSINO MÉDIO (SÃO JOÃO DAS MISSÕES) - INEP: 361461
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361461' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL E ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361461');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA KUHINAN XACRIABÁ (SÃO JOÃO DAS MISSÕES) - INEP: 319058
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319058' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA KUHINAN XACRIABÁ' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319058');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA MAMBUKA (SÃO JOÃO DAS MISSÕES) - INEP: 338753
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338753' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA MAMBUKA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338753');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA OAYTOMORIM (SÃO JOÃO DAS MISSÕES) - INEP: 338770
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338770' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA OAYTOMORIM' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338770');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA UIKITU KUHINÃ (SÃO JOÃO DAS MISSÕES) - INEP: 338745
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338745' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA UIKITU KUHINÃ' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338745');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE INDÍGENA XUKURANK (SÃO JOÃO DAS MISSÕES) - INEP: 297518
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297518' 
    WHERE UPPER(TRIM(name)) = 'EE INDÍGENA XUKURANK' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DAS MISSÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297518');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DA FAZENDA CAMPO LINDO (UBAÍ) - INEP: 213543
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213543' 
    WHERE UPPER(TRIM(name)) = 'EE DA FAZENDA CAMPO LINDO' 
      AND UPPER(TRIM(city)) = 'UBAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213543');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE AMÉLIA CAVALCANTE PIMENTA (VARZELÂNDIA) - INEP: 253499
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253499' 
    WHERE UPPER(TRIM(name)) = 'EE AMÉLIA CAVALCANTE PIMENTA' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253499');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DEUSÂNIA DE BRITO SALES (VARZELÂNDIA) - INEP: 253481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253481' 
    WHERE UPPER(TRIM(name)) = 'EE DEUSÂNIA DE BRITO SALES' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE GILBERTO ALVES COUTINHO (VARZELÂNDIA) - INEP: 253511
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253511' 
    WHERE UPPER(TRIM(name)) = 'EE GILBERTO ALVES COUTINHO' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253511');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ISABEL SOARES DE JESUS (VARZELÂNDIA) - INEP: 217344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217344' 
    WHERE UPPER(TRIM(name)) = 'EE ISABEL SOARES DE JESUS' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOSÉ FERNANDES DE SOUZA (VARZELÂNDIA) - INEP: 213527
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213527' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ FERNANDES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213527');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JUCA VELOSO (VARZELÂNDIA) - INEP: 223999
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223999' 
    WHERE UPPER(TRIM(name)) = 'EE JUCA VELOSO' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223999');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE MANOEL ALVES DE ALMEIDA (VARZELÂNDIA) - INEP: 217352
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217352' 
    WHERE UPPER(TRIM(name)) = 'EE MANOEL ALVES DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217352');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NILZA MARIA DOS SANTOS (VARZELÂNDIA) - INEP: 253472
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '253472' 
    WHERE UPPER(TRIM(name)) = 'EE NILZA MARIA DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'VARZELÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '253472');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE SANTO ANTÔNIO (CHIADOR) - INEP: 346217
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346217' 
    WHERE UPPER(TRIM(name)) = 'EE SANTO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'CHIADOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346217');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR MILTON SANTOS (CORONEL PACHECO) - INEP: 322512
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322512' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MILTON SANTOS' 
      AND UPPER(TRIM(city)) = 'CORONEL PACHECO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322512');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE CARLOS HENRIQUE RIBEIRO DOS SANTOS (GOIANÁ) - INEP: 369845
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369845' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS HENRIQUE RIBEIRO DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'GOIANÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369845');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR IRINEU GUIMARÃES (GUARARÁ) - INEP: 330558
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330558' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR IRINEU GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'GUARARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330558');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE NYRCE VILLA VERDE COELHO DE MAGALHÃES (JUIZ DE FORA) - INEP: 342637
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342637' 
    WHERE UPPER(TRIM(name)) = 'EE NYRCE VILLA VERDE COELHO DE MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342637');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PREFEITO WALTER TREZZA (MARIPÁ DE MINAS) - INEP: 322539
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322539' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO WALTER TREZZA' 
      AND UPPER(TRIM(city)) = 'MARIPÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322539');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOAQUIM ALVES DE CARVALHO (OLARIA) - INEP: 330566
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330566' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUIM ALVES DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'OLARIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330566');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (PEDRO TEIXEIRA) - INEP: 338788
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338788' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'PEDRO TEIXEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338788');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PADRE JOÃO BATISTA DE OLIVEIRA (PEQUERI) - INEP: 322547
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322547' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOÃO BATISTA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PEQUERI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322547');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (ROCHEDO DE MINAS) - INEP: 342645
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342645' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'ROCHEDO DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342645');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOÃO AUGUSTO DA SILVA BARRETO (SANTA BÁRBARA DO MONTE VERDE) - INEP: 342653
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342653' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO AUGUSTO DA SILVA BARRETO' 
      AND UPPER(TRIM(city)) = 'SANTA BÁRBARA DO MONTE VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342653');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DYRCE JOSÉ  DA SILVA E SOUZA (SANTANA DO DESERTO) - INEP: 338796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338796' 
    WHERE UPPER(TRIM(name)) = 'EE DYRCE JOSÉ DA SILVA E SOUZA' 
      AND UPPER(TRIM(city)) = 'SANTANA DO DESERTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSORA ROMILDA BARBOSA (SENADOR CORTES) - INEP: 342661
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342661' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ROMILDA BARBOSA' 
      AND UPPER(TRIM(city)) = 'SENADOR CORTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342661');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DE ENSINO MÉDIO (SIMÃO PEREIRA) - INEP: 338800
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338800' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO MÉDIO' 
      AND UPPER(TRIM(city)) = 'SIMÃO PEREIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338800');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR LUIZ ANTÔNIO PIRES DE SOUZA (ARGIRITA) - INEP: 305316
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305316' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR LUIZ ANTÔNIO PIRES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'ARGIRITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305316');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ISA MORAES FREITAS (ITAMARATI DE MINAS) - INEP: 305324
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305324' 
    WHERE UPPER(TRIM(name)) = 'EE ISA MORAES FREITAS' 
      AND UPPER(TRIM(city)) = 'ITAMARATI DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305324');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EMÍLIA MARIA DINIZ (DURANDÉ) - INEP: 319066
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319066' 
    WHERE UPPER(TRIM(name)) = 'EE EMÍLIA MARIA DINIZ' 
      AND UPPER(TRIM(city)) = 'DURANDÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319066');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE ANTÔNIO SILVA ROCHA (MANHUAÇU) - INEP: 364940
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364940' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO SILVA ROCHA' 
      AND UPPER(TRIM(city)) = 'MANHUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364940');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DO BAIRRO BOA VISTA (MATIPÓ) - INEP: 205541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205541' 
    WHERE UPPER(TRIM(name)) = 'EE DO BAIRRO BOA VISTA' 
      AND UPPER(TRIM(city)) = 'MATIPÓ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205541');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC VALDIR PINHEIRO DE LACERDA (MUTUM) - INEP: 312479
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312479' 
    WHERE UPPER(TRIM(name)) = 'CESEC VALDIR PINHEIRO DE LACERDA' 
      AND UPPER(TRIM(city)) = 'MUTUM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312479');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE DALILA CERQUEIRA PESSOA (SANTA MARGARIDA) - INEP: 346381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346381' 
    WHERE UPPER(TRIM(name)) = 'EE DALILA CERQUEIRA PESSOA' 
      AND UPPER(TRIM(city)) = 'SANTA MARGARIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE VIOLETA MAGESTE PEREIRA (SANTA MARGARIDA) - INEP: 346187
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346187' 
    WHERE UPPER(TRIM(name)) = 'EE VIOLETA MAGESTE PEREIRA' 
      AND UPPER(TRIM(city)) = 'SANTA MARGARIDA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346187');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE EFIGÊNIA DE BARROS OLIVEIRA (BARÃO DE COCAIS) - INEP: 218723
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218723' 
    WHERE UPPER(TRIM(name)) = 'EE EFIGÊNIA DE BARROS OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'BARÃO DE COCAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218723');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO INTERESCOLAR DE CULTURA ARTE LINGUAGENS E TECNOLOGIAS (BELO HORIZONTE) - INEP: 364932
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364932' 
    WHERE UPPER(TRIM(name)) = 'CENTRO INTERESCOLAR DE CULTURA ARTE LINGUAGENS E TECNOLOGIAS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364932');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESEC POETA MURILO MENDES (BELO HORIZONTE) - INEP: 307068
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307068' 
    WHERE UPPER(TRIM(name)) = 'CESEC POETA MURILO MENDES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307068');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE JOVEM PROTAGONISTA (BELO HORIZONTE) - INEP: 322563
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322563' 
    WHERE UPPER(TRIM(name)) = 'EE JOVEM PROTAGONISTA' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322563');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE LAR DOS MENINOS (BELO HORIZONTE) - INEP: 322555
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322555' 
    WHERE UPPER(TRIM(name)) = 'EE LAR DOS MENINOS' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322555');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EE PROFESSOR NEIDSON RODRIGUES (BELO HORIZONTE) - INEP: 342432
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342432' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR NEIDSON RODRIGUES' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342432');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


