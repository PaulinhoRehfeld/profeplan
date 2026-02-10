-- =====================================================
-- ATUALIZAÇÃO AUTOMÁTICA DE INEPs (COM EXCEPTION HANDLER)
-- Total de escolas: 1832
-- Duplicatas serão ignoradas automaticamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE EPAMINONDAS RAMOS (JEQUITINHONHA) - INEP: 184942
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184942' 
    WHERE UPPER(TRIM(name)) = 'EE EPAMINONDAS RAMOS' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184942');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE JOAÍMA (JOAÍMA) - INEP: 312126
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312126' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE JOAÍMA' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312126');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOM JOSÉ (JORDÂNIA) - INEP: 185094
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185094' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOSÉ' 
      AND UPPER(TRIM(city)) = 'JORDÂNIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185094');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR CLEMENTE TRINDADE (RIO DO PRADO) - INEP: 185302
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '185302' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CLEMENTE TRINDADE' 
      AND UPPER(TRIM(city)) = 'RIO DO PRADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '185302');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ARTHUR BERGANHOLI (ARAÇUAÍ) - INEP: 146005
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146005' 
    WHERE UPPER(TRIM(name)) = 'EE ARTHUR BERGANHOLI' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146005');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA APARECIDA DUTRA (ARAÇUAÍ) - INEP: 145998
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145998' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA APARECIDA DUTRA' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145998');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE TEREZINHA GONÇALVES DOS SANTOS (ARAÇUAÍ) - INEP: 330809
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330809' 
    WHERE UPPER(TRIM(name)) = 'EE TEREZINHA GONÇALVES DOS SANTOS' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330809');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE BERILO (BERILO) - INEP: 330655
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330655' 
    WHERE UPPER(TRIM(name)) = 'EE DE BERILO' 
      AND UPPER(TRIM(city)) = 'BERILO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330655');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC NANETE ANTUNES GUIMARÃES (MEDINA) - INEP: 311944
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311944' 
    WHERE UPPER(TRIM(name)) = 'CESEC NANETE ANTUNES GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311944');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CATULO CEARENSE (VIRGEM DA LAPA) - INEP: 148474
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148474' 
    WHERE UPPER(TRIM(name)) = 'EE CATULO CEARENSE' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148474');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CENTRO ESTADUAL DE EDUCAÇÃO ESPECIAL MARIA DO ROSÁRIO (BARBACENA) - INEP: 232131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '232131' 
    WHERE UPPER(TRIM(name)) = 'CENTRO ESTADUAL DE EDUCAÇÃO ESPECIAL MARIA DO ROSÁRIO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '232131');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DÊNIO MOREIRA DE CARVALHO (IPABA) - INEP: 268879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268879' 
    WHERE UPPER(TRIM(name)) = 'EE DÊNIO MOREIRA DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'IPABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268879');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC MARIA CECÍLIA DE MOURA (IPANEMA) - INEP: 310581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310581' 
    WHERE UPPER(TRIM(name)) = 'CESEC MARIA CECÍLIA DE MOURA' 
      AND UPPER(TRIM(city)) = 'IPANEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310581');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DONA LEONINA NUNES MACIEL (CRUZÍLIA) - INEP: 172448
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172448' 
    WHERE UPPER(TRIM(name)) = 'EE DONA LEONINA NUNES MACIEL' 
      AND UPPER(TRIM(city)) = 'CRUZÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172448');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL ARTUR TIBÚRCIO (PASSA QUATRO) - INEP: 173673
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173673' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL ARTUR TIBÚRCIO' 
      AND UPPER(TRIM(city)) = 'PASSA QUATRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173673');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PRESIDENTE ROOSEVELT (PASSA QUATRO) - INEP: 173789
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173789' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE ROOSEVELT' 
      AND UPPER(TRIM(city)) = 'PASSA QUATRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173789');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE EURÍPEDES PRAZERES (SÃO LOURENÇO) - INEP: 174157
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174157' 
    WHERE UPPER(TRIM(name)) = 'EE EURÍPEDES PRAZERES' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174157');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SÃO FRANCISCO DE ASSIS (SÃO LOURENÇO) - INEP: 338710
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338710' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338710');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC PROFESSOR JOSÉ MARTINS SOBRINHO (CONSELHEIRO LAFAIETE) - INEP: 193704
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193704' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR JOSÉ MARTINS SOBRINHO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193704');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE GENERAL OSWALDO PINTO DA VEIGA (CONSELHEIRO LAFAIETE) - INEP: 193615
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193615' 
    WHERE UPPER(TRIM(name)) = 'EE GENERAL OSWALDO PINTO DA VEIGA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193615');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARECHAL HUMBERTO DE ALENCAR CASTELLO BRANCO (CONSELHEIRO LAFAIETE) - INEP: 193763
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193763' 
    WHERE UPPER(TRIM(name)) = 'EE MARECHAL HUMBERTO DE ALENCAR CASTELLO BRANCO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193763');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC JOSÉ BRÁS DOS REIS (OURO BRANCO) - INEP: 194131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194131' 
    WHERE UPPER(TRIM(name)) = 'CESEC JOSÉ BRÁS DOS REIS' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194131');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE EDUCAÇÃO ESPECIAL PROFESSORA MARIA CORRÊA COUTINHO (OURO BRANCO) - INEP: 222208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222208' 
    WHERE UPPER(TRIM(name)) = 'EE DE EDUCAÇÃO ESPECIAL PROFESSORA MARIA CORRÊA COUTINHO' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222208');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MAJOR MIRANDA (RIO ESPERA) - INEP: 194336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '194336' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR MIRANDA' 
      AND UPPER(TRIM(city)) = 'RIO ESPERA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '194336');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL FABRICIANO FELISBERTO DE BRITO (ANTÔNIO DIAS) - INEP: 190641
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190641' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL FABRICIANO FELISBERTO DE BRITO' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO DIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190641');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE INTENDENTE CÂMARA (CORONEL FABRICIANO) - INEP: 190870
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190870' 
    WHERE UPPER(TRIM(name)) = 'EE INTENDENTE CÂMARA' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190870');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE DEOLINDO COELHO (CORONEL FABRICIANO) - INEP: 190934
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190934' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE DEOLINDO COELHO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190934');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR FRANCISCO LETRO (CORONEL FABRICIANO) - INEP: 190951
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '190951' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR FRANCISCO LETRO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '190951');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CAPITÃO EGÍDIO LIMA (TIMÓTEO) - INEP: 191558
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191558' 
    WHERE UPPER(TRIM(name)) = 'EE CAPITÃO EGÍDIO LIMA' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191558');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE GETÚLIO VARGAS (TIMÓTEO) - INEP: 191574
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191574' 
    WHERE UPPER(TRIM(name)) = 'EE GETÚLIO VARGAS' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191574');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE JOSÉ FERREIRA MAIA (TIMÓTEO) - INEP: 191655
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191655' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ FERREIRA MAIA' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191655');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE TENENTE JOSÉ LUCIANO (TIMÓTEO) - INEP: 191523
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '191523' 
    WHERE UPPER(TRIM(name)) = 'EE TENENTE JOSÉ LUCIANO' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '191523');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA (TRÊS MARIAS) - INEP: 141984
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141984' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS MARIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141984');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE CAPELINHA (CAPELINHA) - INEP: 351032
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351032' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE CAPELINHA' 
      AND UPPER(TRIM(city)) = 'CAPELINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351032');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ALBERTO SANTOS DUMONT (DIVINÓPOLIS) - INEP: 326992
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326992' 
    WHERE UPPER(TRIM(name)) = 'EE ALBERTO SANTOS DUMONT' 
      AND UPPER(TRIM(city)) = 'DIVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326992');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR ALBERTO CORDEIRO DO COUTO (ITAPECERICA) - INEP: 202819
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202819' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ALBERTO CORDEIRO DO COUTO' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202819');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA MARIA MAGALHÃES PINTO (ITAPECERICA) - INEP: 202801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '202801' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA MAGALHÃES PINTO' 
      AND UPPER(TRIM(city)) = 'ITAPECERICA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '202801');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DONA TILOSA (LAGOA DA PRATA) - INEP: 310506
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310506' 
    WHERE UPPER(TRIM(name)) = 'EE DONA TILOSA' 
      AND UPPER(TRIM(city)) = 'LAGOA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310506');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SANDOVAL DE AZEVEDO (LUZ) - INEP: 310514
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310514' 
    WHERE UPPER(TRIM(name)) = 'EE SANDOVAL DE AZEVEDO' 
      AND UPPER(TRIM(city)) = 'LUZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310514');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE NOVA SERRANA (NOVA SERRANA) - INEP: 346195
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346195' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE NOVA SERRANA' 
      AND UPPER(TRIM(city)) = 'NOVA SERRANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346195');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DESEMBARGADOR CONTINENTINO (OLIVEIRA) - INEP: 203289
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203289' 
    WHERE UPPER(TRIM(name)) = 'EE DESEMBARGADOR CONTINENTINO' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203289');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE FRANCISCO FERNANDES (OLIVEIRA) - INEP: 203327
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '203327' 
    WHERE UPPER(TRIM(name)) = 'EE FRANCISCO FERNANDES' 
      AND UPPER(TRIM(city)) = 'OLIVEIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '203327');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC MAESTRO CARLOS RIBEIRO DA SILVA (SÃO GONÇALO DO PARÁ) - INEP: 311871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311871' 
    WHERE UPPER(TRIM(name)) = 'CESEC MAESTRO CARLOS RIBEIRO DA SILVA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO PARÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311871');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SÃO JUDAS TADEU (GOVERNADOR VALADARES) - INEP: 326852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326852' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JUDAS TADEU' 
      AND UPPER(TRIM(city)) = 'GOVERNADOR VALADARES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326852');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE NA RESERVA INDÍGENA DE KRENAK (RESPLENDOR) - INEP: 246387
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246387' 
    WHERE UPPER(TRIM(name)) = 'EE NA RESERVA INDÍGENA DE KRENAK' 
      AND UPPER(TRIM(city)) = 'RESPLENDOR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246387');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE BELCHIOR DE FARIA (CENTRALINA) - INEP: 196436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196436' 
    WHERE UPPER(TRIM(name)) = 'EE BELCHIOR DE FARIA' 
      AND UPPER(TRIM(city)) = 'CENTRALINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196436');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE EDUCAÇÃO ESPECIAL RISOLETA NEVES (ITUIUTABA) - INEP: 196711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196711' 
    WHERE UPPER(TRIM(name)) = 'EE DE EDUCAÇÃO ESPECIAL RISOLETA NEVES' 
      AND UPPER(TRIM(city)) = 'ITUIUTABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196711');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE STA TEREZINHA (ESPINOSA) - INEP: 218294
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218294' 
    WHERE UPPER(TRIM(name)) = 'EE STA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'ESPINOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218294');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA DIVA PINTO (JANAÚBA) - INEP: 218260
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218260' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DIVA PINTO' 
      AND UPPER(TRIM(city)) = 'JANAÚBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218260');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE IRÊNIO PINHEIRO (MATO VERDE) - INEP: 239186
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239186' 
    WHERE UPPER(TRIM(name)) = 'EE IRÊNIO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'MATO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239186');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE ENSINO FUNDAMENTAL E MÉDIO (JUIZ DE FORA) - INEP: 326801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326801' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326801');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE ENSINO FUNDAMENTAL E MÉDIO (JUIZ DE FORA) - INEP: 326810
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326810' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'JUIZ DE FORA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326810');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE FELIPE (BOM JESUS DO AMPARO) - INEP: 102806
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102806' 
    WHERE UPPER(TRIM(name)) = 'EE DE FELIPE' 
      AND UPPER(TRIM(city)) = 'BOM JESUS DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102806');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR PAULO FREIRE (CONTAGEM) - INEP: 326780
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326780' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'CONTAGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326780');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARIA ALVES NAGY VARGA (IBIRITÉ) - INEP: 231657
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231657' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA ALVES NAGY VARGA' 
      AND UPPER(TRIM(city)) = 'IBIRITÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231657');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ANTÔNIO RIBEIRO DA SILVA (SÃO JOAQUIM DE BICAS) - INEP: 326798
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326798' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO RIBEIRO DA SILVA' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326798');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PATROCÍNIA CÂNDIDA DE OLIVEIRA (SÃO JOAQUIM DE BICAS) - INEP: 231291
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231291' 
    WHERE UPPER(TRIM(name)) = 'EE PATROCÍNIA CÂNDIDA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SÃO JOAQUIM DE BICAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231291');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA ADIR ANDRADE ALBANO (BELO HORIZONTE) - INEP: 246425
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246425' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA ADIR ANDRADE ALBANO' 
      AND UPPER(TRIM(city)) = 'BELO HORIZONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246425');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CARDEAL MOTA (MORRO DO PILAR) - INEP: 141305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141305' 
    WHERE UPPER(TRIM(name)) = 'EE CARDEAL MOTA' 
      AND UPPER(TRIM(city)) = 'MORRO DO PILAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141305');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE JUSTINÓPOLIS (RIBEIRÃO DAS NEVES) - INEP: 346365
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346365' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE JUSTINÓPOLIS' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346365');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE ENSINO FUNDAMENTAL E MÉDIO (RIBEIRÃO DAS NEVES) - INEP: 339040
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339040' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339040');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE NOSSA SENHORA DAS GRAÇAS (RIBEIRÃO DAS NEVES) - INEP: 327492
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327492' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'RIBEIRÃO DAS NEVES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327492');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE HERBERT JOSÉ DE SOUZA (VESPASIANO) - INEP: 330353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330353' 
    WHERE UPPER(TRIM(name)) = 'EE HERBERT JOSÉ DE SOUZA' 
      AND UPPER(TRIM(city)) = 'VESPASIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330353');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CLARINDO GOULART (COROMANDEL) - INEP: 200336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200336' 
    WHERE UPPER(TRIM(name)) = 'EE CLARINDO GOULART' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200336');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE JOSÉ EMÍLIO DE AGUIAR (COROMANDEL) - INEP: 200409
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200409' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ EMÍLIO DE AGUIAR' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200409');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE OSÓRIO DE MORAIS (COROMANDEL) - INEP: 200328
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200328' 
    WHERE UPPER(TRIM(name)) = 'EE OSÓRIO DE MORAIS' 
      AND UPPER(TRIM(city)) = 'COROMANDEL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200328');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARIA MOREIRA DE VASCONCELOS (ESTRELA DO SUL) - INEP: 313149
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313149' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA MOREIRA DE VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'ESTRELA DO SUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313149');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL VIRGÍLIO ROSA (MONTE CARMELO) - INEP: 200581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200581' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL VIRGÍLIO ROSA' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200581');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DONA SINDA (MONTE CARMELO) - INEP: 200590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200590' 
    WHERE UPPER(TRIM(name)) = 'EE DONA SINDA' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200590');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE LETÍCIA CHAVES (MONTE CARMELO) - INEP: 200620
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '200620' 
    WHERE UPPER(TRIM(name)) = 'EE LETÍCIA CHAVES' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '200620');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ORDÁLIA ROCHA MUNDIM (MONTE CARMELO) - INEP: 231444
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '231444' 
    WHERE UPPER(TRIM(name)) = 'EE ORDÁLIA ROCHA MUNDIM' 
      AND UPPER(TRIM(city)) = 'MONTE CARMELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '231444');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE JOSÉ MARIA DOS MARES GUIA (CORAÇÃO DE JESUS) - INEP: 239283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239283' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ MARIA DOS MARES GUIA' 
      AND UPPER(TRIM(city)) = 'CORAÇÃO DE JESUS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239283');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SÃO GONÇALO (FRANCISCO SÁ) - INEP: 330639
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330639' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO GONÇALO' 
      AND UPPER(TRIM(city)) = 'FRANCISCO SÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330639');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PRESIDENTE CASTELO BRANCO (JAPONVAR) - INEP: 310565
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310565' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE CASTELO BRANCO' 
      AND UPPER(TRIM(city)) = 'JAPONVAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310565');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE HENRIQUE MUNÁIZ PUIG (MONTES CLAROS) - INEP: 339571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339571' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE HENRIQUE MUNÁIZ PUIG' 
      AND UPPER(TRIM(city)) = 'MONTES CLAROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339571');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC GOVERNADOR BIAS FORTES (MURIAÉ) - INEP: 314129
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314129' 
    WHERE UPPER(TRIM(name)) = 'CESEC GOVERNADOR BIAS FORTES' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314129');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARIA AUXILIADORA FARIA (MURIAÉ) - INEP: 328201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '328201' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA AUXILIADORA FARIA' 
      AND UPPER(TRIM(city)) = 'MURIAÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '328201');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SILVEIRA DRUMOND (FERROS) - INEP: 102962
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102962' 
    WHERE UPPER(TRIM(name)) = 'EE SILVEIRA DRUMOND' 
      AND UPPER(TRIM(city)) = 'FERROS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102962');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ANTÔNIO LOUREIRO SOBRINHO (JOÃO MONLEVADE) - INEP: 103381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103381' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO LOUREIRO SOBRINHO' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103381');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ANTÔNIO PAPINI (JOÃO MONLEVADE) - INEP: 103365
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103365' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO PAPINI' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103365');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DO BAIRRO LARANJEIRAS (JOÃO MONLEVADE) - INEP: 103411
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103411' 
    WHERE UPPER(TRIM(name)) = 'EE DO BAIRRO LARANJEIRAS' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103411');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE JOÃO XXIII (JOÃO MONLEVADE) - INEP: 103462
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103462' 
    WHERE UPPER(TRIM(name)) = 'EE JOÃO XXIII' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103462');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE RUMIA MALUF (JOÃO MONLEVADE) - INEP: 103535
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '103535' 
    WHERE UPPER(TRIM(name)) = 'EE RUMIA MALUF' 
      AND UPPER(TRIM(city)) = 'JOÃO MONLEVADE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '103535');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR GOMES FREIRE (MARIANA) - INEP: 106283
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106283' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR GOMES FREIRE' 
      AND UPPER(TRIM(city)) = 'MARIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106283');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE NOSSA SENHORA AUXILIADORA (OURO PRETO) - INEP: 106658
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '106658' 
    WHERE UPPER(TRIM(name)) = 'EE NOSSA SENHORA AUXILIADORA' 
      AND UPPER(TRIM(city)) = 'OURO PRETO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '106658');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL EGÍDIO BENÍCIO DE ABREU (BOM DESPACHO) - INEP: 311898
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311898' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL EGÍDIO BENÍCIO DE ABREU' 
      AND UPPER(TRIM(city)) = 'BOM DESPACHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311898');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR AGMAR GOMES DO COUTO - PDPC (PARÁ DE MINAS) - INEP: 326691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326691' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR AGMAR GOMES DO COUTO - PDPC' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326691');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE TORQUATO DE ALMEIDA (PARÁ DE MINAS) - INEP: 307408
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '307408' 
    WHERE UPPER(TRIM(name)) = 'EE TORQUATO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'PARÁ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '307408');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARIA JOSÉ DE PAULA (JOÃO PINHEIRO) - INEP: 108570
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108570' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA JOSÉ DE PAULA' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108570');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PRESIDENTE OLEGÁRIO (JOÃO PINHEIRO) - INEP: 108529
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108529' 
    WHERE UPPER(TRIM(name)) = 'EE PRESIDENTE OLEGÁRIO' 
      AND UPPER(TRIM(city)) = 'JOÃO PINHEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108529');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC CÂNDIDA PIMENTEL ULHOA (PARACATU) - INEP: 108928
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108928' 
    WHERE UPPER(TRIM(name)) = 'CESEC CÂNDIDA PIMENTEL ULHOA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108928');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE AFONSO ARINOS (PARACATU) - INEP: 108812
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108812' 
    WHERE UPPER(TRIM(name)) = 'EE AFONSO ARINOS' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108812');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR SÉRGIO ULHOA (PARACATU) - INEP: 108961
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108961' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR SÉRGIO ULHOA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108961');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR JOSINO NEIVA (PARACATU) - INEP: 108804
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108804' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSINO NEIVA' 
      AND UPPER(TRIM(city)) = 'PARACATU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108804');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA MARIA APARECIDA COSTA DE RESENDE (FORMIGA) - INEP: 339091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339091' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MARIA APARECIDA COSTA DE RESENDE' 
      AND UPPER(TRIM(city)) = 'FORMIGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339091');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE GERALDO STARLING SOARES (PASSOS) - INEP: 115509
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115509' 
    WHERE UPPER(TRIM(name)) = 'EE GERALDO STARLING SOARES' 
      AND UPPER(TRIM(city)) = 'PASSOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115509');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR JOSÉ VICENTE (PIUMHI) - INEP: 115711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '115711' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR JOSÉ VICENTE' 
      AND UPPER(TRIM(city)) = 'PIUMHI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '115711');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC PROFESSOR ANTÔNIO DE DEUS VIEIRA NETO (CARMO DO PARANAÍBA) - INEP: 118532
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118532' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSOR ANTÔNIO DE DEUS VIEIRA NETO' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118532');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SIZENANDO AMARAL DE EDUCAÇÃO ESPECIAL (CARMO DO PARANAÍBA) - INEP: 118541
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118541' 
    WHERE UPPER(TRIM(name)) = 'EE SIZENANDO AMARAL DE EDUCAÇÃO ESPECIAL' 
      AND UPPER(TRIM(city)) = 'CARMO DO PARANAÍBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118541');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC ORDALINA VIEIRA RORIZ DA COSTA (PATOS DE MINAS) - INEP: 118851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118851' 
    WHERE UPPER(TRIM(name)) = 'CESEC ORDALINA VIEIRA RORIZ DA COSTA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118851');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CÔNEGO GETÚLIO (PATOS DE MINAS) - INEP: 118842
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118842' 
    WHERE UPPER(TRIM(name)) = 'EE CÔNEGO GETÚLIO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118842');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR SEBASTIÃO SILVÉRIO DE FARIA (PATOS DE MINAS) - INEP: 326640
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326640' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR SEBASTIÃO SILVÉRIO DE FARIA' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326640');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MONSENHOR FLEURY (PATOS DE MINAS) - INEP: 118966
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118966' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR FLEURY' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118966');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR MODESTO (PATOS DE MINAS) - INEP: 118991
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '118991' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MODESTO' 
      AND UPPER(TRIM(city)) = 'PATOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '118991');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DORALICE ALVES RODRIGUES (PATROCÍNIO) - INEP: 199150
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199150' 
    WHERE UPPER(TRIM(name)) = 'CESEC DORALICE ALVES RODRIGUES' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199150');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL JOÃO CÂNDIDO DE AGUIAR (PATROCÍNIO) - INEP: 199087
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199087' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOÃO CÂNDIDO DE AGUIAR' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199087');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE ENSINO FUNDAMENTAL E MÉDIO (PATROCÍNIO) - INEP: 327590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327590' 
    WHERE UPPER(TRIM(name)) = 'EE DE ENSINO FUNDAMENTAL E MÉDIO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327590');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE LÍBIA LASSI LOPES (PATROCÍNIO) - INEP: 218090
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218090' 
    WHERE UPPER(TRIM(name)) = 'EE LÍBIA LASSI LOPES' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218090');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARIANA TAVARES (PATROCÍNIO) - INEP: 199109
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '199109' 
    WHERE UPPER(TRIM(name)) = 'EE MARIANA TAVARES' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '199109');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA CÉLIA LEMOS (PATROCÍNIO) - INEP: 218103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218103' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA CÉLIA LEMOS' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218103');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA IRMA CARVALHO (PATROCÍNIO) - INEP: 238538
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '238538' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA IRMA CARVALHO' 
      AND UPPER(TRIM(city)) = 'PATROCÍNIO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '238538');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE BURITIZEIRO (BURITIZEIRO) - INEP: 346322
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346322' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE BURITIZEIRO' 
      AND UPPER(TRIM(city)) = 'BURITIZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346322');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SÃO JOSÉ (BOTELHOS) - INEP: 123978
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '123978' 
    WHERE UPPER(TRIM(name)) = 'EE SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'BOTELHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '123978');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC PROFESSORA HELOÍSA LACERDA (POÇOS DE CALDAS) - INEP: 124931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '124931' 
    WHERE UPPER(TRIM(name)) = 'CESEC PROFESSORA HELOÍSA LACERDA' 
      AND UPPER(TRIM(city)) = 'POÇOS DE CALDAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '124931');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR JOSÉ GROSSI (ABRE CAMPO) - INEP: 128121
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128121' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR JOSÉ GROSSI' 
      AND UPPER(TRIM(city)) = 'ABRE CAMPO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128121');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE GOVERNADOR BIAS FORTES (ALVINÓPOLIS) - INEP: 322806
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322806' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR BIAS FORTES' 
      AND UPPER(TRIM(city)) = 'ALVINÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322806');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CLAUDIONOR LOPES (BARRA LONGA) - INEP: 128368
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128368' 
    WHERE UPPER(TRIM(name)) = 'EE CLAUDIONOR LOPES' 
      AND UPPER(TRIM(city)) = 'BARRA LONGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128368');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE DIMAS (GUARACIABA) - INEP: 128724
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '128724' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE DIMAS' 
      AND UPPER(TRIM(city)) = 'GUARACIABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '128724');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SOLON ILDEFONSO (PORTO FIRME) - INEP: 129208
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129208' 
    WHERE UPPER(TRIM(name)) = 'EE SOLON ILDEFONSO' 
      AND UPPER(TRIM(city)) = 'PORTO FIRME' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129208');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MADRE SANTA FACE (VIÇOSA) - INEP: 129895
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '129895' 
    WHERE UPPER(TRIM(name)) = 'EE MADRE SANTA FACE' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '129895');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR CID BATISTA - EJA (VIÇOSA) - INEP: 339075
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339075' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR CID BATISTA - EJA' 
      AND UPPER(TRIM(city)) = 'VIÇOSA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339075');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA DELORME DE AVELLAR MUNIZ (OURO FINO) - INEP: 218138
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '218138' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA DELORME DE AVELLAR MUNIZ' 
      AND UPPER(TRIM(city)) = 'OURO FINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '218138');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CONSERVATÓRIO ESTADUAL MÚSICA PADRE JOSÉ MARIA XAVIER (SÃO JOÃO DEL REI) - INEP: 134732
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134732' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO ESTADUAL MÚSICA PADRE JOSÉ MARIA XAVIER' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134732');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE AURELIANO PIMENTEL (SÃO JOÃO DEL REI) - INEP: 134571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134571' 
    WHERE UPPER(TRIM(name)) = 'EE AURELIANO PIMENTEL' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134571');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DEPUTADO MATEUS SALOMÉ (SÃO JOÃO DEL REI) - INEP: 134597
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134597' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO MATEUS SALOMÉ' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134597');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DETETIVE MARCO ANTONIO DE SOUZA (SÃO JOÃO DEL REI) - INEP: 338885
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338885' 
    WHERE UPPER(TRIM(name)) = 'EE DETETIVE MARCO ANTONIO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338885');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE HENRIQUE PEREIRA SANTIAGO (SÃO TIAGO) - INEP: 310786
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310786' 
    WHERE UPPER(TRIM(name)) = 'EE HENRIQUE PEREIRA SANTIAGO' 
      AND UPPER(TRIM(city)) = 'SÃO TIAGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310786');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CARVALHO BRITO (GUARANÉSIA) - INEP: 137090
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137090' 
    WHERE UPPER(TRIM(name)) = 'EE CARVALHO BRITO' 
      AND UPPER(TRIM(city)) = 'GUARANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137090');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR ANTÔNIO CARLOS (IBIRACI) - INEP: 137359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137359' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTÔNIO CARLOS' 
      AND UPPER(TRIM(city)) = 'IBIRACI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137359');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL NECA LEMOS (PRATÁPOLIS) - INEP: 137677
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137677' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL NECA LEMOS' 
      AND UPPER(TRIM(city)) = 'PRATÁPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137677');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE WALDEMAR PEZZINI (MATOZINHOS) - INEP: 310646
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310646' 
    WHERE UPPER(TRIM(name)) = 'EE WALDEMAR PEZZINI' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310646');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE JOAQUINA CÂNDIDA MOREIRA (PARAOPEBA) - INEP: 310654
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310654' 
    WHERE UPPER(TRIM(name)) = 'EE JOAQUINA CÂNDIDA MOREIRA' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310654');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE SETE LAGOAS (SETE LAGOAS) - INEP: 141615
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141615' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141615');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ANTÔNIO FRANCISCO DE OLIVEIRA (SETE LAGOAS) - INEP: 205591
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205591' 
    WHERE UPPER(TRIM(name)) = 'EE ANTÔNIO FRANCISCO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205591');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CAPITÃO JOÃO LÚCIO DO CARMO (SETE LAGOAS) - INEP: 339296
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339296' 
    WHERE UPPER(TRIM(name)) = 'EE CAPITÃO JOÃO LÚCIO DO CARMO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339296');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR ULISSES VASCONCELOS (SETE LAGOAS) - INEP: 141721
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141721' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ULISSES VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141721');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MARIA AMÂNCIO (SETE LAGOAS) - INEP: 310671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310671' 
    WHERE UPPER(TRIM(name)) = 'EE MARIA AMÂNCIO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310671');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE SANTOS AZEREDO (SETE LAGOAS) - INEP: 141909
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141909' 
    WHERE UPPER(TRIM(name)) = 'EE SANTOS AZEREDO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141909');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CARLOS MAGNO REBOUÇAS (ÁGUAS FORMOSAS) - INEP: 145904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145904' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS MAGNO REBOUÇAS' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145904');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CESÁRIO MATIAS DE ALMEIDA (ÁGUAS FORMOSAS) - INEP: 145921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145921' 
    WHERE UPPER(TRIM(name)) = 'EE CESÁRIO MATIAS DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145921');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MAJOR RAIMUNDO FELICÍSSIMO (ÁGUAS FORMOSAS) - INEP: 145963
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145963' 
    WHERE UPPER(TRIM(name)) = 'EE MAJOR RAIMUNDO FELICÍSSIMO' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145963');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR ANTÔNIO OLINTO (ATALÉIA) - INEP: 146315
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146315' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTÔNIO OLINTO' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146315');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR ABGAR RENAULT (CARAÍ) - INEP: 146528
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146528' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ABGAR RENAULT' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146528');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CARLOS PRATES (ITAMBACURI) - INEP: 146811
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146811' 
    WHERE UPPER(TRIM(name)) = 'EE CARLOS PRATES' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146811');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE FREI GASPAR DE MÓDICA (ITAMBACURI) - INEP: 146803
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146803' 
    WHERE UPPER(TRIM(name)) = 'EE FREI GASPAR DE MÓDICA' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146803');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSORA MÍLCIA DE OLIVEIRA ABRANTES (ITAMBACURI) - INEP: 146781
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146781' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSORA MÍLCIA DE OLIVEIRA ABRANTES' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146781');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ENGENHEIRO WENEFREDO PORTELLA (LADAINHA) - INEP: 147087
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147087' 
    WHERE UPPER(TRIM(name)) = 'EE ENGENHEIRO WENEFREDO PORTELLA' 
      AND UPPER(TRIM(city)) = 'LADAINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147087');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DEPUTADO CASTRO PIRES (MALACACHETA) - INEP: 147168
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147168' 
    WHERE UPPER(TRIM(name)) = 'EE DEPUTADO CASTRO PIRES' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147168');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ÁLVARO AMORIM (NANUQUE) - INEP: 147397
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147397' 
    WHERE UPPER(TRIM(name)) = 'EE ÁLVARO AMORIM' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147397');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE GOVERNADOR BIAS FORTES (NANUQUE) - INEP: 147401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147401' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR BIAS FORTES' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147401');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE UNIÃO BENEFICENTE OPERÁRIA (NANUQUE) - INEP: 147478
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147478' 
    WHERE UPPER(TRIM(name)) = 'EE UNIÃO BENEFICENTE OPERÁRIA' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147478');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOM JOSÉ DE HAAS (NOVO CRUZEIRO) - INEP: 147559
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147559' 
    WHERE UPPER(TRIM(name)) = 'EE DOM JOSÉ DE HAAS' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147559');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DA VILA SÃO JOÃO (PADRE PARAÍSO) - INEP: 147681
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147681' 
    WHERE UPPER(TRIM(name)) = 'EE DA VILA SÃO JOÃO' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147681');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE BENJAMIM DA CUNHA (PAVÃO) - INEP: 147729
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147729' 
    WHERE UPPER(TRIM(name)) = 'EE BENJAMIM DA CUNHA' 
      AND UPPER(TRIM(city)) = 'PAVÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147729');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE EUCLIDES SILVEIRA TOLENTINO (SANTA HELENA DE MINAS) - INEP: 146455
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146455' 
    WHERE UPPER(TRIM(name)) = 'EE EUCLIDES SILVEIRA TOLENTINO' 
      AND UPPER(TRIM(city)) = 'SANTA HELENA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146455');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE SERRA DOS AIMORÉS (SERRA DOS AIMORÉS) - INEP: 147893
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147893' 
    WHERE UPPER(TRIM(name)) = 'EE DE SERRA DOS AIMORÉS' 
      AND UPPER(TRIM(city)) = 'SERRA DOS AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147893');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ARTUR BERNARDES (TEÓFILO OTONI) - INEP: 148415
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148415' 
    WHERE UPPER(TRIM(name)) = 'EE ARTUR BERNARDES' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148415');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR ANTÔNIO JACINTO PIMENTA (TEÓFILO OTONI) - INEP: 148300
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148300' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ANTÔNIO JACINTO PIMENTA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148300');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR FELIPE MOREIRA CALDAS (TEÓFILO OTONI) - INEP: 148318
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148318' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR FELIPE MOREIRA CALDAS' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148318');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE FREI ANTELMO KROPMAN (TEÓFILO OTONI) - INEP: 148156
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148156' 
    WHERE UPPER(TRIM(name)) = 'EE FREI ANTELMO KROPMAN' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148156');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE FREI BRÁS BERTEN (TEÓFILO OTONI) - INEP: 148008
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148008' 
    WHERE UPPER(TRIM(name)) = 'EE FREI BRÁS BERTEN' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148008');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PREFEITO GERMANO AUGUSTO DE SOUZA (TEÓFILO OTONI) - INEP: 148369
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148369' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO GERMANO AUGUSTO DE SOUZA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148369');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE RUBEM TOMICH (TEÓFILO OTONI) - INEP: 330582
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330582' 
    WHERE UPPER(TRIM(name)) = 'EE RUBEM TOMICH' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330582');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE GOVERNADOR CLÓVIS SALGADO (PRESIDENTE BERNARDES) - INEP: 181421
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181421' 
    WHERE UPPER(TRIM(name)) = 'EE GOVERNADOR CLÓVIS SALGADO' 
      AND UPPER(TRIM(city)) = 'PRESIDENTE BERNARDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181421');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR ORMINDO DE SOUZA LIMA (SÃO GERALDO) - INEP: 181544
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181544' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR ORMINDO DE SOUZA LIMA' 
      AND UPPER(TRIM(city)) = 'SÃO GERALDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181544');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CAPITAO ANTONIO PINTO DE MIRANDA (TOCANTINS) - INEP: 181731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '181731' 
    WHERE UPPER(TRIM(name)) = 'EE CAPITAO ANTONIO PINTO DE MIRANDA' 
      AND UPPER(TRIM(city)) = 'TOCANTINS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '181731');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CONSERVATÓRIO EST MÚSICA PROF THEODOLINDO JOSÉ SOARES (VISCONDE DO RIO BRANCO) - INEP: 182311
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182311' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO EST MÚSICA PROF THEODOLINDO JOSÉ SOARES' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182311');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DE EDUCAÇÃO ESPECIAL ANTONIO DE GOUVÊA LIMA (VISCONDE DO RIO BRANCO) - INEP: 182176
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182176' 
    WHERE UPPER(TRIM(name)) = 'EE DE EDUCAÇÃO ESPECIAL ANTONIO DE GOUVÊA LIMA' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182176');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DR JOÃO BATISTA DE ALMEIDA (VISCONDE DO RIO BRANCO) - INEP: 182249
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182249' 
    WHERE UPPER(TRIM(name)) = 'EE DR JOÃO BATISTA DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182249');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE LAUDELINA BARANDIER ESMERALDO (VISCONDE DO RIO BRANCO) - INEP: 182290
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182290' 
    WHERE UPPER(TRIM(name)) = 'EE LAUDELINA BARANDIER ESMERALDO' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182290');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE ANTÔNIO CORREA (VISCONDE DO RIO BRANCO) - INEP: 182320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182320' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ANTÔNIO CORREA' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182320');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PREFEITO RUY BOUCHARDET (VISCONDE DO RIO BRANCO) - INEP: 182338
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '182338' 
    WHERE UPPER(TRIM(name)) = 'EE PREFEITO RUY BOUCHARDET' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '182338');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CENTRO INTERESCOLAR ESTADUAL DE LÍNGUAS (UBERABA) - INEP: 210005
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210005' 
    WHERE UPPER(TRIM(name)) = 'CENTRO INTERESCOLAR ESTADUAL DE LÍNGUAS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210005');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CONSERVATÓRIO ESTADUAL DE MÚSICA RENATO FRATESCHI (UBERABA) - INEP: 159921
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159921' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO ESTADUAL DE MÚSICA RENATO FRATESCHI' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159921');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE BRASIL (UBERABA) - INEP: 159867
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159867' 
    WHERE UPPER(TRIM(name)) = 'EE BRASIL' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159867');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOM EDUARDO (UBERABA) - INEP: 159981
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159981' 
    WHERE UPPER(TRIM(name)) = 'EE DOM EDUARDO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159981');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE FIDÉLIS REIS (UBERABA) - INEP: 160008
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160008' 
    WHERE UPPER(TRIM(name)) = 'EE FIDÉLIS REIS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160008');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MIGUEL LATERZA (UBERABA) - INEP: 159719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159719' 
    WHERE UPPER(TRIM(name)) = 'EE MIGUEL LATERZA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159719');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR MINERVINO CESARINO (UBERABA) - INEP: 327280
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327280' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR MINERVINO CESARINO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327280');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE EDUARDO JORDI (ARAGUARI) - INEP: 330779
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330779' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE EDUARDO JORDI' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330779');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE ELÓI (ARAGUARI) - INEP: 166804
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166804' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE ELÓI' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166804');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE BRAULINO MAMEDE (TUPACIGUARA) - INEP: 167185
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167185' 
    WHERE UPPER(TRIM(name)) = 'EE BRAULINO MAMEDE' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167185');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC DE UBERLÂNDIA (UBERLÂNDIA) - INEP: 167835
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167835' 
    WHERE UPPER(TRIM(name)) = 'CESEC DE UBERLÂNDIA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167835');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CONSERVATÓRIO EST MÚSICA CORA PAVAN CAPPARELLI (UBERLÂNDIA) - INEP: 167452
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167452' 
    WHERE UPPER(TRIM(name)) = 'CONSERVATÓRIO EST MÚSICA CORA PAVAN CAPPARELLI' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167452');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE BOM JESUS (UBERLÂNDIA) - INEP: 167525
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167525' 
    WHERE UPPER(TRIM(name)) = 'EE BOM JESUS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167525');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL JOSE TEOFILO CARNEIRO (UBERLÂNDIA) - INEP: 167720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167720' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSE TEOFILO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167720');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DO BAIRRO MARAVILHA (UBERLÂNDIA) - INEP: 167789
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167789' 
    WHERE UPPER(TRIM(name)) = 'EE DO BAIRRO MARAVILHA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167789');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DONA ALEXANDRA PEDREIRO (UBERLÂNDIA) - INEP: 167801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167801' 
    WHERE UPPER(TRIM(name)) = 'EE DONA ALEXANDRA PEDREIRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167801');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ENÉAS DE OLIVEIRA GUIMARÃES (UBERLÂNDIA) - INEP: 167444
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167444' 
    WHERE UPPER(TRIM(name)) = 'EE ENÉAS DE OLIVEIRA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167444');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE JOSÉ ZACHARIAS JUNQUEIRA (UBERLÂNDIA) - INEP: 167355
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167355' 
    WHERE UPPER(TRIM(name)) = 'EE JOSÉ ZACHARIAS JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167355');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MÁRIO QUINTANA (UBERLÂNDIA) - INEP: 327964
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327964' 
    WHERE UPPER(TRIM(name)) = 'EE MÁRIO QUINTANA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327964');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE NOVO HORIZONTE-EDUCAÇÃO ESPECIAL (UBERLÂNDIA) - INEP: 167851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167851' 
    WHERE UPPER(TRIM(name)) = 'EE NOVO HORIZONTE-EDUCAÇÃO ESPECIAL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167851');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE OSVALDO RESENDE (UBERLÂNDIA) - INEP: 167479
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167479' 
    WHERE UPPER(TRIM(name)) = 'EE OSVALDO RESENDE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167479');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR PAULO FREIRE (UBERLÂNDIA) - INEP: 327956
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327956' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR PAULO FREIRE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327956');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE RIO DAS PEDRAS (UBERLÂNDIA) - INEP: 167533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167533' 
    WHERE UPPER(TRIM(name)) = 'EE RIO DAS PEDRAS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167533');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- CESEC JÚLIO MARTINS FERREIRA (UNAÍ) - INEP: 109070
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109070' 
    WHERE UPPER(TRIM(name)) = 'CESEC JÚLIO MARTINS FERREIRA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109070');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE IZABEL CAMPOS MARTINS (UNAÍ) - INEP: 245836
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245836' 
    WHERE UPPER(TRIM(name)) = 'EE IZABEL CAMPOS MARTINS' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245836');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MÚCIO DE CASTRO ALVES (UNAÍ) - INEP: 330698
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330698' 
    WHERE UPPER(TRIM(name)) = 'EE MÚCIO DE CASTRO ALVES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330698');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE CORONEL JOSÉ BENTO (ALFENAS) - INEP: 170755
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170755' 
    WHERE UPPER(TRIM(name)) = 'EE CORONEL JOSÉ BENTO' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170755');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR ARLINDO SILVEIRA FILHO (ALFENAS) - INEP: 170780
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170780' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR ARLINDO SILVEIRA FILHO' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170780');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ACHILLES NAVES (BOA ESPERANÇA) - INEP: 171271
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171271' 
    WHERE UPPER(TRIM(name)) = 'EE ACHILLES NAVES' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171271');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE BELMIRO BRAGA (BOA ESPERANÇA) - INEP: 171107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171107' 
    WHERE UPPER(TRIM(name)) = 'EE BELMIRO BRAGA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171107');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PROFESSOR NESTOR LACERDA (BOA ESPERANÇA) - INEP: 229296
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229296' 
    WHERE UPPER(TRIM(name)) = 'EE PROFESSOR NESTOR LACERDA' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229296');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DONA AGOSTINHA FLOR DE MARIA (GUAPÉ) - INEP: 172715
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172715' 
    WHERE UPPER(TRIM(name)) = 'EE DONA AGOSTINHA FLOR DE MARIA' 
      AND UPPER(TRIM(city)) = 'GUAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172715');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOM PEDRO I (MACHADO) - INEP: 173215
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173215' 
    WHERE UPPER(TRIM(name)) = 'EE DOM PEDRO I' 
      AND UPPER(TRIM(city)) = 'MACHADO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173215');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE DOUTOR LÉLIO DE ALMEIDA (POÇO FUNDO) - INEP: 173851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173851' 
    WHERE UPPER(TRIM(name)) = 'EE DOUTOR LÉLIO DE ALMEIDA' 
      AND UPPER(TRIM(city)) = 'POÇO FUNDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173851');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE PADRE JOSÉ RIBEIRO (SANTANA DA VARGEM) - INEP: 173983
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173983' 
    WHERE UPPER(TRIM(name)) = 'EE PADRE JOSÉ RIBEIRO' 
      AND UPPER(TRIM(city)) = 'SANTANA DA VARGEM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173983');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE ESPERANÇA (SÃO GONÇALO DO SAPUCAÍ) - INEP: 174106
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174106' 
    WHERE UPPER(TRIM(name)) = 'EE ESPERANÇA' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174106');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE HERBERT JOSÉ DE SOUZA (TRÊS CORAÇÕES) - INEP: 328316
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '328316' 
    WHERE UPPER(TRIM(name)) = 'EE HERBERT JOSÉ DE SOUZA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '328316');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;

-- EE MONSENHOR JOSÉ GUIMARÃES FONSECA (TRÊS CORAÇÕES) - INEP: 174459
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174459' 
    WHERE UPPER(TRIM(name)) = 'EE MONSENHOR JOSÉ GUIMARÃES FONSECA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174459');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
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
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;


-- VERIFICAÇÃO FINAL
SELECT COUNT(*) as total_com_inep FROM schools WHERE inep_code IS NOT NULL;
SELECT COUNT(*) as total_sem_inep FROM schools WHERE inep_code IS NULL;

-- Ver escolas que ficaram sem INEP
SELECT name, city FROM schools WHERE inep_code IS NULL ORDER BY city, name LIMIT 50;
