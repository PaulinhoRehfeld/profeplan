-- Lote 6 de 9
-- Escolas 2501 a 3000

-- EM OSVALDO DE OLIVEIRA (EXTREMA) - INEP: 311413
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311413' 
    WHERE UPPER(TRIM(name)) = 'EM OSVALDO DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311413');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR JOÃO ORSI DE MORAIS (EXTREMA) - INEP: 321982
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321982' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR JOÃO ORSI DE MORAIS' 
      AND UPPER(TRIM(city)) = 'EXTREMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321982');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BENEDITO DORTA DE SOUZA (MONTE SIÃO) - INEP: 381535
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381535' 
    WHERE UPPER(TRIM(name)) = 'EM BENEDITO DORTA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'MONTE SIÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381535');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM OTÁVIO CHAGAS (MONTE SIÃO) - INEP: 375250
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '375250' 
    WHERE UPPER(TRIM(name)) = 'EM DOM OTÁVIO CHAGAS' 
      AND UPPER(TRIM(city)) = 'MONTE SIÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '375250');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE REINALDO (MONTE SIÃO) - INEP: 264334
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '264334' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE REINALDO' 
      AND UPPER(TRIM(city)) = 'MONTE SIÃO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '264334');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANATHÁLIA LOURDES CAMANDUCAIA (POUSO ALEGRE) - INEP: 258407
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '258407' 
    WHERE UPPER(TRIM(name)) = 'EM ANATHÁLIA LOURDES CAMANDUCAIA' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '258407');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANITA FARIA AMARAL (POUSO ALEGRE) - INEP: 233404
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233404' 
    WHERE UPPER(TRIM(name)) = 'EM ANITA FARIA AMARAL' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233404');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR ÂNGELO CÔNSOLI (POUSO ALEGRE) - INEP: 233412
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233412' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR ÂNGELO CÔNSOLI' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233412');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JANDYRA TOSTA DE SOUZA (POUSO ALEGRE) - INEP: 215490
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '215490' 
    WHERE UPPER(TRIM(name)) = 'EM JANDYRA TOSTA DE SOUZA' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '215490');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA CLARISSE TOLEDO (POUSO ALEGRE) - INEP: 269956
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269956' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA CLARISSE TOLEDO' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269956');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ISABEL COUTINHO GALVÃO (POUSO ALEGRE) - INEP: 242497
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '242497' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ISABEL COUTINHO GALVÃO' 
      AND UPPER(TRIM(city)) = 'POUSO ALEGRE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '242497');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ALMERINDA SILVA MOSTI (SÃO SEBASTIÃO DA BELA VISTA) - INEP: 269964
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269964' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ALMERINDA SILVA MOSTI' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DA BELA VISTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269964');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA DA COSTA FERREIRA (SENADOR JOSÉ BENTO) - INEP: 127710
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '127710' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA DA COSTA FERREIRA' 
      AND UPPER(TRIM(city)) = 'SENADOR JOSÉ BENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '127710');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANGELINA MEDRADO (LAGOA DOURADA) - INEP: 134180
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134180' 
    WHERE UPPER(TRIM(name)) = 'EM ANGELINA MEDRADO' 
      AND UPPER(TRIM(city)) = 'LAGOA DOURADA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134180');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA MARCÍLIA REZENDE (LAGOA DOURADA) - INEP: 134228
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134228' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA MARCÍLIA REZENDE' 
      AND UPPER(TRIM(city)) = 'LAGOA DOURADA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134228');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULA ASSIS (RESENDE COSTA) - INEP: 135968
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '135968' 
    WHERE UPPER(TRIM(name)) = 'EM PAULA ASSIS' 
      AND UPPER(TRIM(city)) = 'RESENDE COSTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '135968');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA LUZIA FERREIRA (SANTA CRUZ DE MINAS) - INEP: 265128
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '265128' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA LUZIA FERREIRA' 
      AND UPPER(TRIM(city)) = 'SANTA CRUZ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '265128');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS DAMIANO FUZATTO (SÃO JOÃO DEL REI) - INEP: 136310
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '136310' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS DAMIANO FUZATTO' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '136310');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CELSO RAIMUNDO DA SILVA (SÃO JOÃO DEL REI) - INEP: 312738
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312738' 
    WHERE UPPER(TRIM(name)) = 'EM CELSO RAIMUNDO DA SILVA' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312738');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE EMBOABAS (SÃO JOÃO DEL REI) - INEP: 134783
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '134783' 
    WHERE UPPER(TRIM(name)) = 'EM DE EMBOABAS' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '134783');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE MIGUEL AFONSO A LEITE (SÃO JOÃO DEL REI) - INEP: 324051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324051' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE MIGUEL AFONSO A LEITE' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PIO XII (SÃO JOÃO DEL REI) - INEP: 234834
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234834' 
    WHERE UPPER(TRIM(name)) = 'EM PIO XII' 
      AND UPPER(TRIM(city)) = 'SÃO JOÃO DEL REI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234834');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ARCEBURGUENSE (ARCEBURGO) - INEP: 138061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '138061' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ARCEBURGUENSE' 
      AND UPPER(TRIM(city)) = 'ARCEBURGO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '138061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM INÁCIO JOÃO DAL MONTE (GUARANÉSIA) - INEP: 137103
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137103' 
    WHERE UPPER(TRIM(name)) = 'EM DOM INÁCIO JOÃO DAL MONTE' 
      AND UPPER(TRIM(city)) = 'GUARANÉSIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137103');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ENGENHEIRO JORGE OLIVA (ITAÚ DE MINAS) - INEP: 137782
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137782' 
    WHERE UPPER(TRIM(name)) = 'EM ENGENHEIRO JORGE OLIVA' 
      AND UPPER(TRIM(city)) = 'ITAÚ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137782');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONSENHOR ERNESTO CAVICCHIOLI (ITAÚ DE MINAS) - INEP: 305430
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305430' 
    WHERE UPPER(TRIM(name)) = 'EM MONSENHOR ERNESTO CAVICCHIOLI' 
      AND UPPER(TRIM(city)) = 'ITAÚ DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305430');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE TERMÓPOLIS DE ENSINO FUNDAMENTAL (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 137979
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '137979' 
    WHERE UPPER(TRIM(name)) = 'EM DE TERMÓPOLIS DE ENSINO FUNDAMENTAL' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '137979');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO DANIEL (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 138037
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '138037' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO DANIEL' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '138037');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IBRANTINA AMARAL (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 139904
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '139904' 
    WHERE UPPER(TRIM(name)) = 'EM IBRANTINA AMARAL' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '139904');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NAPOLEÃO VOLPE (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 139718
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '139718' 
    WHERE UPPER(TRIM(name)) = 'EM NAPOLEÃO VOLPE' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '139718');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROQUE SCARANO (SÃO SEBASTIÃO DO PARAÍSO) - INEP: 139858
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '139858' 
    WHERE UPPER(TRIM(name)) = 'EM ROQUE SCARANO' 
      AND UPPER(TRIM(city)) = 'SÃO SEBASTIÃO DO PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '139858');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JORGE MASCARENHAS (ARAÇAÍ) - INEP: 140287
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140287' 
    WHERE UPPER(TRIM(name)) = 'EM JORGE MASCARENHAS' 
      AND UPPER(TRIM(city)) = 'ARAÇAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140287');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CEL AMÉRICO TEIXEIRA (CACHOEIRA DA PRATA) - INEP: 140431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140431' 
    WHERE UPPER(TRIM(name)) = 'EM CEL AMÉRICO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'CACHOEIRA DA PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EMÍLIO DE VASCONCELOS COSTA (CAETANÓPOLIS) - INEP: 142611
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '142611' 
    WHERE UPPER(TRIM(name)) = 'EM EMÍLIO DE VASCONCELOS COSTA' 
      AND UPPER(TRIM(city)) = 'CAETANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '142611');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLÍVIA DALLE MASCARENHAS (CAETANÓPOLIS) - INEP: 140457
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '140457' 
    WHERE UPPER(TRIM(name)) = 'EM OLÍVIA DALLE MASCARENHAS' 
      AND UPPER(TRIM(city)) = 'CAETANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '140457');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MÁRIO DINIZ PONTES (FORTUNA DE MINAS) - INEP: 268844
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '268844' 
    WHERE UPPER(TRIM(name)) = 'EM MÁRIO DINIZ PONTES' 
      AND UPPER(TRIM(city)) = 'FORTUNA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '268844');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LOURISMAR PALHARES MACHADO (JEQUITIBÁ) - INEP: 141143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141143' 
    WHERE UPPER(TRIM(name)) = 'EM LOURISMAR PALHARES MACHADO' 
      AND UPPER(TRIM(city)) = 'JEQUITIBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA VINA (MARAVILHAS) - INEP: 219061
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219061' 
    WHERE UPPER(TRIM(name)) = 'EM DONA VINA' 
      AND UPPER(TRIM(city)) = 'MARAVILHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219061');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL PROFESSOR EURICO VIANA (MATOZINHOS) - INEP: 221431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '221431' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL PROFESSOR EURICO VIANA' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '221431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA ELZA ALVES OLIVEIRA (MATOZINHOS) - INEP: 246557
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246557' 
    WHERE UPPER(TRIM(name)) = 'EM DONA ELZA ALVES OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246557');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA JOVINA DE MELLO VEADO (MATOZINHOS) - INEP: 246549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246549' 
    WHERE UPPER(TRIM(name)) = 'EM DONA JOVINA DE MELLO VEADO' 
      AND UPPER(TRIM(city)) = 'MATOZINHOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AMÉRICO VAZ DA SILVA (PARAOPEBA) - INEP: 229610
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '229610' 
    WHERE UPPER(TRIM(name)) = 'EM AMÉRICO VAZ DA SILVA' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '229610');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR TEÓFILO NASCIMENTO (PARAOPEBA) - INEP: 144533
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '144533' 
    WHERE UPPER(TRIM(name)) = 'EM DR TEÓFILO NASCIMENTO' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '144533');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ LUCAS DE FIGUEIREDO (PARAOPEBA) - INEP: 141330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141330' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ LUCAS DE FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'PARAOPEBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ÂNGELA MARIA R CAMPOS (POMPÉU) - INEP: 144754
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '144754' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ÂNGELA MARIA R CAMPOS' 
      AND UPPER(TRIM(city)) = 'POMPÉU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '144754');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JELIOMAR BRANDÃO (PRUDENTE DE MORAIS) - INEP: 219436
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219436' 
    WHERE UPPER(TRIM(name)) = 'EM JELIOMAR BRANDÃO' 
      AND UPPER(TRIM(city)) = 'PRUDENTE DE MORAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219436');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA DA FONSECA (SANTANA DE PIRAPAMA) - INEP: 314510
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '314510' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'SANTANA DE PIRAPAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '314510');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALÍPIO MACIEL DE OLIVEIRA (SETE LAGOAS) - INEP: 219070
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219070' 
    WHERE UPPER(TRIM(name)) = 'EM ALÍPIO MACIEL DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219070');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AURETE PONTES FONSECA (SETE LAGOAS) - INEP: 145181
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145181' 
    WHERE UPPER(TRIM(name)) = 'EM AURETE PONTES FONSECA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145181');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DALVA FERREIRA DINIZ (SETE LAGOAS) - INEP: 233323
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233323' 
    WHERE UPPER(TRIM(name)) = 'EM DALVA FERREIRA DINIZ' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233323');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR MÁRCIO PAULINO (SETE LAGOAS) - INEP: 141712
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '141712' 
    WHERE UPPER(TRIM(name)) = 'EM DR MÁRCIO PAULINO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '141712');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCA FERREIRA DE AVELAR (SETE LAGOAS) - INEP: 145220
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145220' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCA FERREIRA DE AVELAR' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145220');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HILÁRIO PEREIRA DA FONSECA (SETE LAGOAS) - INEP: 343633
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343633' 
    WHERE UPPER(TRIM(name)) = 'EM HILÁRIO PEREIRA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343633');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ JACINTO MARTINS GODOY - PROFESSOR GODOY (SETE LAGOAS) - INEP: 371076
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371076' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ JACINTO MARTINS GODOY - PROFESSOR GODOY' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371076');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARILZA FLEURY COSTA FIGUEIREDO (SETE LAGOAS) - INEP: 363847
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363847' 
    WHERE UPPER(TRIM(name)) = 'EM MARILZA FLEURY COSTA FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363847');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF EDSON ABREU (SETE LAGOAS) - INEP: 233315
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233315' 
    WHERE UPPER(TRIM(name)) = 'EM PROF EDSON ABREU' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233315');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF GALVÃO (SETE LAGOAS) - INEP: 233307
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233307' 
    WHERE UPPER(TRIM(name)) = 'EM PROF GALVÃO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233307');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF MARCOS VALENTINO (SETE LAGOAS) - INEP: 250341
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250341' 
    WHERE UPPER(TRIM(name)) = 'EM PROF MARCOS VALENTINO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250341');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF VASCO DAMIÃO (SETE LAGOAS) - INEP: 210722
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210722' 
    WHERE UPPER(TRIM(name)) = 'EM PROF VASCO DAMIÃO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210722');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAIMUNDO GRAVITO - PROFESSOR GRAVITO (SETE LAGOAS) - INEP: 373168
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373168' 
    WHERE UPPER(TRIM(name)) = 'EM RAIMUNDO GRAVITO - PROFESSOR GRAVITO' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373168');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TEC MUNICIPAL DE SETE LAGOAS (SETE LAGOAS) - INEP: 145670
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145670' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TEC MUNICIPAL DE SETE LAGOAS' 
      AND UPPER(TRIM(city)) = 'SETE LAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145670');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO LIMA FILHO (ÁGUAS FORMOSAS) - INEP: 312169
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312169' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO LIMA FILHO' 
      AND UPPER(TRIM(city)) = 'ÁGUAS FORMOSAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312169');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DUQUE DE CAXIAS (ATALÉIA) - INEP: 213080
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213080' 
    WHERE UPPER(TRIM(name)) = 'EM DUQUE DE CAXIAS' 
      AND UPPER(TRIM(city)) = 'ATALÉIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213080');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARÃO REIS (CARAÍ) - INEP: 150398
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '150398' 
    WHERE UPPER(TRIM(name)) = 'EM ARÃO REIS' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '150398');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLEGÁRIO MACIEL (CARAÍ) - INEP: 150444
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '150444' 
    WHERE UPPER(TRIM(name)) = 'EM OLEGÁRIO MACIEL' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '150444');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRIMEIRO DE MAIO (CARAÍ) - INEP: 150711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '150711' 
    WHERE UPPER(TRIM(name)) = 'EM PRIMEIRO DE MAIO' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '150711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM QUINZE DE NOVEMBRO (CARAÍ) - INEP: 150720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '150720' 
    WHERE UPPER(TRIM(name)) = 'EM QUINZE DE NOVEMBRO' 
      AND UPPER(TRIM(city)) = 'CARAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '150720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BRAZILINO RODRIGUES DE SOUZA (CARLOS CHAGAS) - INEP: 150924
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '150924' 
    WHERE UPPER(TRIM(name)) = 'EM BRAZILINO RODRIGUES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '150924');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR MANOEL ESTEVES OTONI (CARLOS CHAGAS) - INEP: 146587
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146587' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR MANOEL ESTEVES OTONI' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146587');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSCAR JOÃO KRETLI (CARLOS CHAGAS) - INEP: 151025
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '151025' 
    WHERE UPPER(TRIM(name)) = 'EM OSCAR JOÃO KRETLI' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '151025');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRESIDENTE TANCREDO NEVES (CARLOS CHAGAS) - INEP: 146617
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146617' 
    WHERE UPPER(TRIM(name)) = 'EM PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'CARLOS CHAGAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146617');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DA FAZENDA AVENIDA (CRISÓLITA) - INEP: 145971
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '145971' 
    WHERE UPPER(TRIM(name)) = 'EM DA FAZENDA AVENIDA' 
      AND UPPER(TRIM(city)) = 'CRISÓLITA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '145971');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ESTÊVÃO MONTEIRO (FREI GASPAR) - INEP: 151556
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '151556' 
    WHERE UPPER(TRIM(name)) = 'EM ESTÊVÃO MONTEIRO' 
      AND UPPER(TRIM(city)) = 'FREI GASPAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '151556');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZELITA CARLOS DE OLIVEIRA (FREI GASPAR) - INEP: 151599
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '151599' 
    WHERE UPPER(TRIM(name)) = 'EM ZELITA CARLOS DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'FREI GASPAR' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '151599');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM DIAS ALMEIDA (FRONTEIRA DOS VALES) - INEP: 146722
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '146722' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM DIAS ALMEIDA' 
      AND UPPER(TRIM(city)) = 'FRONTEIRA DOS VALES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '146722');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DE FÁTIMA BATISTA MATIAS (ITAIPÉ) - INEP: 338478
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338478' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DE FÁTIMA BATISTA MATIAS' 
      AND UPPER(TRIM(city)) = 'ITAIPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338478');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR EDSON LAGO PINHEIRO (ITAMBACURI) - INEP: 152412
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '152412' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR EDSON LAGO PINHEIRO' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '152412');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HERMÍNIA LOPES (ITAMBACURI) - INEP: 152463
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '152463' 
    WHERE UPPER(TRIM(name)) = 'EM HERMÍNIA LOPES' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '152463');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO CHAVES (ITAMBACURI) - INEP: 152480
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '152480' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO CHAVES' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '152480');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RUI BARBOSA (ITAMBACURI) - INEP: 152579
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '152579' 
    WHERE UPPER(TRIM(name)) = 'EM RUI BARBOSA' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '152579');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZÉLIA DE CAMPOS NEVES (ITAMBACURI) - INEP: 236039
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '236039' 
    WHERE UPPER(TRIM(name)) = 'EM ZÉLIA DE CAMPOS NEVES' 
      AND UPPER(TRIM(city)) = 'ITAMBACURI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '236039');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO PEREIRA CAMPOS (LADAINHA) - INEP: 153711
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '153711' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO PEREIRA CAMPOS' 
      AND UPPER(TRIM(city)) = 'LADAINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '153711');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARISTIDES GOMES PEREIRA (MALACACHETA) - INEP: 222151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222151' 
    WHERE UPPER(TRIM(name)) = 'EM ARISTIDES GOMES PEREIRA' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL GOMES DE PAULA (MALACACHETA) - INEP: 154059
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '154059' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL GOMES DE PAULA' 
      AND UPPER(TRIM(city)) = 'MALACACHETA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '154059');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AMÉRICO MACHADO (NANUQUE) - INEP: 347795
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347795' 
    WHERE UPPER(TRIM(name)) = 'EM AMÉRICO MACHADO' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347795');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MIGUEL VIANA DE OLIVEIRA (NANUQUE) - INEP: 154733
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '154733' 
    WHERE UPPER(TRIM(name)) = 'EM MIGUEL VIANA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '154733');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SERAFIM MACHADO NAYA (NANUQUE) - INEP: 154717
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '154717' 
    WHERE UPPER(TRIM(name)) = 'EM SERAFIM MACHADO NAYA' 
      AND UPPER(TRIM(city)) = 'NANUQUE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '154717');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ DE ANCHIETA (NOVO CRUZEIRO) - INEP: 155144
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '155144' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ DE ANCHIETA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '155144');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LEONÍDIA COSTA FREIRE (NOVO CRUZEIRO) - INEP: 351687
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351687' 
    WHERE UPPER(TRIM(name)) = 'EM LEONÍDIA COSTA FREIRE' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351687');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA DAS DORES GOMES DE SOUZA (NOVO CRUZEIRO) - INEP: 349976
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349976' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA DAS DORES GOMES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'NOVO CRUZEIRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349976');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOMÍCIO PINTO MIRANDA (NOVO ORIENTE DE MINAS) - INEP: 157279
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157279' 
    WHERE UPPER(TRIM(name)) = 'EM DOMÍCIO PINTO MIRANDA' 
      AND UPPER(TRIM(city)) = 'NOVO ORIENTE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157279');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MANOEL GONÇALVES SOARES (NOVO ORIENTE DE MINAS) - INEP: 156892
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '156892' 
    WHERE UPPER(TRIM(name)) = 'EM MANOEL GONÇALVES SOARES' 
      AND UPPER(TRIM(city)) = 'NOVO ORIENTE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '156892');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LOURIVALDO FRANCISCO DA PAZ (OURO VERDE DE MINAS) - INEP: 155543
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '155543' 
    WHERE UPPER(TRIM(name)) = 'EM LOURIVALDO FRANCISCO DA PAZ' 
      AND UPPER(TRIM(city)) = 'OURO VERDE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '155543');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM JOSÉ DE HAAS (PADRE PARAÍSO) - INEP: 155748
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '155748' 
    WHERE UPPER(TRIM(name)) = 'EM DOM JOSÉ DE HAAS' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '155748');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RAMIRO LOPES (PADRE PARAÍSO) - INEP: 155667
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '155667' 
    WHERE UPPER(TRIM(name)) = 'EM RAMIRO LOPES' 
      AND UPPER(TRIM(city)) = 'PADRE PARAÍSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '155667');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE VIRGEM DAS GRAÇAS (PONTO DOS VOLANTES) - INEP: 147036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147036' 
    WHERE UPPER(TRIM(name)) = 'EM DE VIRGEM DAS GRAÇAS' 
      AND UPPER(TRIM(city)) = 'PONTO DOS VOLANTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA GERALDA MIRANDA BRITO SALOMÃO (PONTO DOS VOLANTES) - INEP: 353426
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353426' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA GERALDA MIRANDA BRITO SALOMÃO' 
      AND UPPER(TRIM(city)) = 'PONTO DOS VOLANTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353426');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MODESTO DA COSTA (PONTO DOS VOLANTES) - INEP: 153036
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '153036' 
    WHERE UPPER(TRIM(name)) = 'EM MODESTO DA COSTA' 
      AND UPPER(TRIM(city)) = 'PONTO DOS VOLANTES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '153036');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FREI GASPAR (POTÉ) - INEP: 156299
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '156299' 
    WHERE UPPER(TRIM(name)) = 'EM FREI GASPAR' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '156299');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREFEITO OMAR AFFONSO DA SILVA (POTÉ) - INEP: 347396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347396' 
    WHERE UPPER(TRIM(name)) = 'EM PREFEITO OMAR AFFONSO DA SILVA' 
      AND UPPER(TRIM(city)) = 'POTÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BARÃO DO RIO BRANCO (SANTA HELENA DE MINAS) - INEP: 150037
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '150037' 
    WHERE UPPER(TRIM(name)) = 'EM BARÃO DO RIO BRANCO' 
      AND UPPER(TRIM(city)) = 'SANTA HELENA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '150037');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANGELIM SAÚDE (SERRA DOS AIMORÉS) - INEP: 156671
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '156671' 
    WHERE UPPER(TRIM(name)) = 'EM ANGELIM SAÚDE' 
      AND UPPER(TRIM(city)) = 'SERRA DOS AIMORÉS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '156671');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE PAI DOMINGOS (SETUBINHA) - INEP: 147346
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '147346' 
    WHERE UPPER(TRIM(name)) = 'EM DE PAI DOMINGOS' 
      AND UPPER(TRIM(city)) = 'SETUBINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '147346');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AGRÍCOLA GERALDO LEÃO LOPES (TEÓFILO OTONI) - INEP: 156868
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '156868' 
    WHERE UPPER(TRIM(name)) = 'EM AGRÍCOLA GERALDO LEÃO LOPES' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '156868');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AGRÍCOLA INÁCIO PEREIRA GUIMARÃES (TEÓFILO OTONI) - INEP: 157163
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157163' 
    WHERE UPPER(TRIM(name)) = 'EM AGRÍCOLA INÁCIO PEREIRA GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157163');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM IRMÃ MARIA AMÁLIA (TEÓFILO OTONI) - INEP: 228591
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '228591' 
    WHERE UPPER(TRIM(name)) = 'EM IRMÃ MARIA AMÁLIA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '228591');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NOSSA SENHORA APARECIDA (TEÓFILO OTONI) - INEP: 305669
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305669' 
    WHERE UPPER(TRIM(name)) = 'EM NOSSA SENHORA APARECIDA' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305669');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SIDÔNIO OTTONI (TEÓFILO OTONI) - INEP: 157155
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157155' 
    WHERE UPPER(TRIM(name)) = 'EM SIDÔNIO OTTONI' 
      AND UPPER(TRIM(city)) = 'TEÓFILO OTONI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157155');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM COLATINA GONÇALVES DE SOUZA (UMBURATIBA) - INEP: 148466
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '148466' 
    WHERE UPPER(TRIM(name)) = 'EM COLATINA GONÇALVES DE SOUZA' 
      AND UPPER(TRIM(city)) = 'UMBURATIBA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '148466');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARLY MONTEIRO (SÃO GERALDO) - INEP: 183628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '183628' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARLY MONTEIRO' 
      AND UPPER(TRIM(city)) = 'SÃO GERALDO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '183628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR TANUS FERES DE ANDRADE (UBÁ) - INEP: 293041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293041' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR TANUS FERES DE ANDRADE' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR MANOEL ARTHIDORO DE CASTRO (UBÁ) - INEP: 330281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '330281' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR MANOEL ARTHIDORO DE CASTRO' 
      AND UPPER(TRIM(city)) = 'UBÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '330281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MUNICIPAL RIO BRANCO (VISCONDE DO RIO BRANCO) - INEP: 184152
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '184152' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MUNICIPAL RIO BRANCO' 
      AND UPPER(TRIM(city)) = 'VISCONDE DO RIO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '184152');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO AUGUSTO DE PAIVA (ARAXÁ) - INEP: 160466
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160466' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO AUGUSTO DE PAIVA' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160466');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AZIZ J CHAER (ARAXÁ) - INEP: 160521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160521' 
    WHERE UPPER(TRIM(name)) = 'EM AZIZ J CHAER' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EUNICE WEAWER (ARAXÁ) - INEP: 158241
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158241' 
    WHERE UPPER(TRIM(name)) = 'EM EUNICE WEAWER' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158241');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO PRIMO DE MELO (ARAXÁ) - INEP: 160504
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160504' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO PRIMO DE MELO' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160504');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ BENTO (ARAXÁ) - INEP: 160431
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160431' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ BENTO' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160431');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MÚSICA MAESTRO ELIAS PORFÍRIO AZEVEDO (ARAXÁ) - INEP: 321931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321931' 
    WHERE UPPER(TRIM(name)) = 'EM MÚSICA MAESTRO ELIAS PORFÍRIO AZEVEDO' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE INÁCIO (ARAXÁ) - INEP: 160512
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160512' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE INÁCIO' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160512');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA AUXILIADORA PAIVA (ARAXÁ) - INEP: 277452
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277452' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA AUXILIADORA PAIVA' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277452');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA LEONILDA MONTANDON (ARAXÁ) - INEP: 241041
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '241041' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA LEONILDA MONTANDON' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '241041');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ROMÁLIA PORFÍRIO DE AZEVEDO LEITE (ARAXÁ) - INEP: 368555
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368555' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ROMÁLIA PORFÍRIO DE AZEVEDO LEITE' 
      AND UPPER(TRIM(city)) = 'ARAXÁ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368555');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AMÉLIA FRANCO (CAMPOS ALTOS) - INEP: 213802
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '213802' 
    WHERE UPPER(TRIM(name)) = 'EM AMÉLIA FRANCO' 
      AND UPPER(TRIM(city)) = 'CAMPOS ALTOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '213802');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM DOMINGOS DA SILVA (CAMPOS ALTOS) - INEP: 158551
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158551' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM DOMINGOS DA SILVA' 
      AND UPPER(TRIM(city)) = 'CAMPOS ALTOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158551');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LINDOLFO DE ALMEIDA FERREIRA (COMENDADOR GOMES) - INEP: 158607
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158607' 
    WHERE UPPER(TRIM(name)) = 'EM LINDOLFO DE ALMEIDA FERREIRA' 
      AND UPPER(TRIM(city)) = 'COMENDADOR GOMES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158607');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS LUZ (CONCEIÇÃO DAS ALAGOAS) - INEP: 158623
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158623' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS LUZ' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DAS ALAGOAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158623');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR PRADO LOPES (CONQUISTA) - INEP: 158704
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158704' 
    WHERE UPPER(TRIM(name)) = 'EM DR PRADO LOPES' 
      AND UPPER(TRIM(city)) = 'CONQUISTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158704');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANA DE CASTRO CANÇADO (DELTA) - INEP: 159778
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159778' 
    WHERE UPPER(TRIM(name)) = 'EM ANA DE CASTRO CANÇADO' 
      AND UPPER(TRIM(city)) = 'DELTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159778');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLAVO DE OLIVEIRA FERREIRA (DELTA) - INEP: 165662
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165662' 
    WHERE UPPER(TRIM(name)) = 'EM OLAVO DE OLIVEIRA FERREIRA' 
      AND UPPER(TRIM(city)) = 'DELTA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165662');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ÂNGELO RICARDO (FRUTAL) - INEP: 311731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '311731' 
    WHERE UPPER(TRIM(name)) = 'EM ÂNGELO RICARDO' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '311731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO PRADO (FRUTAL) - INEP: 162264
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '162264' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO PRADO' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '162264');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BELMIRO BATISTA MIRANDA (FRUTAL) - INEP: 255009
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '255009' 
    WHERE UPPER(TRIM(name)) = 'EM BELMIRO BATISTA MIRANDA' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '255009');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM BARROSO (FRUTAL) - INEP: 158933
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158933' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM BARROSO' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158933');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ODÍLIO FERNANDES (FRUTAL) - INEP: 255017
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '255017' 
    WHERE UPPER(TRIM(name)) = 'EM ODÍLIO FERNANDES' 
      AND UPPER(TRIM(city)) = 'FRUTAL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '255017');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALONSO DE MORAIS ANDRADE (ITAPAGIPE) - INEP: 162680
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '162680' 
    WHERE UPPER(TRIM(name)) = 'EM ALONSO DE MORAIS ANDRADE' 
      AND UPPER(TRIM(city)) = 'ITAPAGIPE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '162680');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AGRÍCOLA ALÍPIO SOARES BARBOSA (ITURAMA) - INEP: 254991
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254991' 
    WHERE UPPER(TRIM(name)) = 'EM AGRÍCOLA ALÍPIO SOARES BARBOSA' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254991');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO RIBEIRO ROSA (ITURAMA) - INEP: 271128
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271128' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO RIBEIRO ROSA' 
      AND UPPER(TRIM(city)) = 'ITURAMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271128');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CORONEL JÚLIO BORGES (SACRAMENTO) - INEP: 164593
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '164593' 
    WHERE UPPER(TRIM(name)) = 'EM CORONEL JÚLIO BORGES' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '164593');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIA SANT'ANA (SACRAMENTO) - INEP: 159590
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159590' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIA SANT''ANA' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159590');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR AFONSO PENA JÚNIOR (SACRAMENTO) - INEP: 377031
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377031' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR AFONSO PENA JÚNIOR' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377031');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR DJALMA AFONSO DO PRADO (SACRAMENTO) - INEP: 164372
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '164372' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR DJALMA AFONSO DO PRADO' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '164372');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR JOÃO CORDEIRO (SACRAMENTO) - INEP: 164399
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '164399' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR JOÃO CORDEIRO' 
      AND UPPER(TRIM(city)) = 'SACRAMENTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '164399');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TARCILA NEVES DA COSTA (SANTA JULIANA) - INEP: 159638
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159638' 
    WHERE UPPER(TRIM(name)) = 'EM TARCILA NEVES DA COSTA' 
      AND UPPER(TRIM(city)) = 'SANTA JULIANA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159638');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM STA TEREZINHA (SÃO FRANCISCO DE SALES) - INEP: 165051
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165051' 
    WHERE UPPER(TRIM(name)) = 'EM STA TEREZINHA' 
      AND UPPER(TRIM(city)) = 'SÃO FRANCISCO DE SALES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165051');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ALVINA ALVES DE REZENDE (TAPIRA) - INEP: 159654
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159654' 
    WHERE UPPER(TRIM(name)) = 'EM ALVINA ALVES DE REZENDE' 
      AND UPPER(TRIM(city)) = 'TAPIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159654');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAOLLA CAROLINA DE MELO (TAPIRA) - INEP: 378364
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '378364' 
    WHERE UPPER(TRIM(name)) = 'EM PAOLLA CAROLINA DE MELO' 
      AND UPPER(TRIM(city)) = 'TAPIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '378364');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VICENTE PEREIRA FERNANDES (TAPIRA) - INEP: 165174
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165174' 
    WHERE UPPER(TRIM(name)) = 'EM VICENTE PEREIRA FERNANDES' 
      AND UPPER(TRIM(city)) = 'TAPIRA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165174');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADOLFO BEZERRA DE MENEZES (UBERABA) - INEP: 165212
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165212' 
    WHERE UPPER(TRIM(name)) = 'EM ADOLFO BEZERRA DE MENEZES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165212');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ARTUR DE MELO TEIXEIRA (UBERABA) - INEP: 165336
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165336' 
    WHERE UPPER(TRIM(name)) = 'EM ARTUR DE MELO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165336');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BOA VISTA (UBERABA) - INEP: 165395
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165395' 
    WHERE UPPER(TRIM(name)) = 'EM BOA VISTA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165395');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CELINA SOARES DE PAIVA (UBERABA) - INEP: 165450
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165450' 
    WHERE UPPER(TRIM(name)) = 'EM CELINA SOARES DE PAIVA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165450');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FREDERICO PEIRÓ (UBERABA) - INEP: 165701
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165701' 
    WHERE UPPER(TRIM(name)) = 'EM FREDERICO PEIRÓ' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165701');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GASTÃO MESQUITA FILHO (UBERABA) - INEP: 165930
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165930' 
    WHERE UPPER(TRIM(name)) = 'EM GASTÃO MESQUITA FILHO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165930');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARCUS CHEREM (UBERABA) - INEP: 165778
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165778' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARCUS CHEREM' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165778');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOUBERT DE CARVALHO (UBERABA) - INEP: 234699
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234699' 
    WHERE UPPER(TRIM(name)) = 'EM JOUBERT DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234699');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MADRE MARIA GEORGINA (UBERABA) - INEP: 165841
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165841' 
    WHERE UPPER(TRIM(name)) = 'EM MADRE MARIA GEORGINA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165841');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA CAROLINA MENDES (UBERABA) - INEP: 165328
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165328' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA CAROLINA MENDES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165328');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MONTEIRO LOBATO (UBERABA) - INEP: 165441
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165441' 
    WHERE UPPER(TRIM(name)) = 'EM MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165441');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NORMA SUELY BORGES (UBERABA) - INEP: 165263
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165263' 
    WHERE UPPER(TRIM(name)) = 'EM NORMA SUELY BORGES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165263');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE EDDIE BERNARDES (UBERABA) - INEP: 165514
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165514' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE EDDIE BERNARDES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165514');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA ESTER LIMIRIO BRIGAGAO (UBERABA) - INEP: 331562
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '331562' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA ESTER LIMIRIO BRIGAGAO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '331562');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR ANÍSIO TEIXEIRA (UBERABA) - INEP: 159832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '159832' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR ANÍSIO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '159832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR JOSÉ GERALDO GUIMARÃES (UBERABA) - INEP: 165727
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165727' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR JOSÉ GERALDO GUIMARÃES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165727');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR JOSÉ MACCIOTTI (UBERABA) - INEP: 165484
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165484' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR JOSÉ MACCIOTTI' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165484');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA GENI CHAVES (UBERABA) - INEP: 165859
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165859' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA GENI CHAVES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165859');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA LOURENCINA PALMERIO (UBERABA) - INEP: 241083
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '241083' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA LOURENCINA PALMERIO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '241083');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA NIZA MARQUEZ GUARITA (UBERABA) - INEP: 260347
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260347' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA NIZA MARQUEZ GUARITA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260347');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA OLGA DE OLIVEIRA (UBERABA) - INEP: 165760
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165760' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA OLGA DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165760');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA STELA CHAVES (UBERABA) - INEP: 165344
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165344' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA STELA CHAVES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165344');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA TEREZINHA HUEB MENEZES (UBERABA) - INEP: 380296
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380296' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA TEREZINHA HUEB MENEZES' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380296');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM REIS JÚNIOR (UBERABA) - INEP: 241091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '241091' 
    WHERE UPPER(TRIM(name)) = 'EM REIS JÚNIOR' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '241091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA MARIA (UBERABA) - INEP: 165875
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165875' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA MARIA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165875');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO ANTÔNIO LEAL (UBERABA) - INEP: 165620
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165620' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO ANTÔNIO LEAL' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165620');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TOTONHO DE MORAIS (UBERABA) - INEP: 165221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165221' 
    WHERE UPPER(TRIM(name)) = 'EM TOTONHO DE MORAIS' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM UBERABA (UBERABA) - INEP: 160199
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160199' 
    WHERE UPPER(TRIM(name)) = 'EM UBERABA' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160199');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM URBANA FREI EUGÊNIO (UBERABA) - INEP: 165301
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165301' 
    WHERE UPPER(TRIM(name)) = 'EM URBANA FREI EUGÊNIO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165301');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VICENTE ALVES TRINDADE (UBERABA) - INEP: 165549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '165549' 
    WHERE UPPER(TRIM(name)) = 'EM VICENTE ALVES TRINDADE' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '165549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA MUNICIPAL DE ENSINO TÉCNICO PROFISSIONALIZANTE PROFESSOR FRANCISCO SALES JERÔNIMO - CHICÃO (UBERABA) - INEP: 380059
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380059' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA MUNICIPAL DE ENSINO TÉCNICO PROFISSIONALIZANTE PROFESSOR FRANCISCO SALES JERÔNIMO - CHICÃO' 
      AND UPPER(TRIM(city)) = 'UBERABA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380059');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM DR ARCINO SANTOS LAUREANO (ARAGUARI) - INEP: 250601
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '250601' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM DR ARCINO SANTOS LAUREANO' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '250601');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEM MÁRIO DA SILVA PEREIRA (ARAGUARI) - INEP: 276626
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276626' 
    WHERE UPPER(TRIM(name)) = 'CEM MÁRIO DA SILVA PEREIRA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276626');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEM OZÓRIO VIEIRA CARRIJO (ARAGUARI) - INEP: 168335
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168335' 
    WHERE UPPER(TRIM(name)) = 'CEM OZÓRIO VIEIRA CARRIJO' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168335');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEM PROF HERMENEGILDO M VELOSO (ARAGUARI) - INEP: 262498
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262498' 
    WHERE UPPER(TRIM(name)) = 'CEM PROF HERMENEGILDO M VELOSO' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262498');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNICIPAL  PAPA JOÃO XXIII (ARAGUARI) - INEP: 168114
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168114' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNICIPAL PAPA JOÃO XXIII' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168114');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MUNICIPAL TENENTE CORONEL VILAGRAN CABRITA (ARAGUARI) - INEP: 168173
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168173' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MUNICIPAL TENENTE CORONEL VILAGRAN CABRITA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168173');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ INÁCIO (ARAGUARI) - INEP: 167941
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167941' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ INÁCIO' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167941');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JUSTINO RODRIGUES DA CUNHA (ARAGUARI) - INEP: 248215
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248215' 
    WHERE UPPER(TRIM(name)) = 'EM JUSTINO RODRIGUES DA CUNHA' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248215');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROSA MAMERI RADE (ARAGUARI) - INEP: 166588
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166588' 
    WHERE UPPER(TRIM(name)) = 'EM ROSA MAMERI RADE' 
      AND UPPER(TRIM(city)) = 'ARAGUARI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166588');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE FORMAÇÃO TÉCNICA PROFISSIONAL JOSÉ INÁCIO FERREIRA (ARAPORÃ) - INEP: 327221
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '327221' 
    WHERE UPPER(TRIM(name)) = 'EM DE FORMAÇÃO TÉCNICA PROFISSIONAL JOSÉ INÁCIO FERREIRA' 
      AND UPPER(TRIM(city)) = 'ARAPORÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '327221');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLINTHA DE OLIVEIRA VALE (ARAPORÃ) - INEP: 269638
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269638' 
    WHERE UPPER(TRIM(name)) = 'EM OLINTHA DE OLIVEIRA VALE' 
      AND UPPER(TRIM(city)) = 'ARAPORÃ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269638');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FELICIANO ANTÔNIO DE FARIA (CAMPINA VERDE) - INEP: 348570
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348570' 
    WHERE UPPER(TRIM(name)) = 'EM FELICIANO ANTÔNIO DE FARIA' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348570');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OTÁVIO SEVERINO DA SILVA (CAMPINA VERDE) - INEP: 160989
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '160989' 
    WHERE UPPER(TRIM(name)) = 'EM OTÁVIO SEVERINO DA SILVA' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '160989');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO VICENTE DE PAULO (CAMPINA VERDE) - INEP: 158411
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '158411' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO VICENTE DE PAULO' 
      AND UPPER(TRIM(city)) = 'CAMPINA VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '158411');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CMNER JOSÉ BARBOSA DE MIRANDA (INDIANÓPOLIS) - INEP: 168467
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168467' 
    WHERE UPPER(TRIM(name)) = 'CMNER JOSÉ BARBOSA DE MIRANDA' 
      AND UPPER(TRIM(city)) = 'INDIANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168467');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE INDIANÓPOLIS (INDIANÓPOLIS) - INEP: 269514
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269514' 
    WHERE UPPER(TRIM(name)) = 'EM DE INDIANÓPOLIS' 
      AND UPPER(TRIM(city)) = 'INDIANÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269514');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FERNANDO VILELA (MONTE ALEGRE DE MINAS) - INEP: 168602
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168602' 
    WHERE UPPER(TRIM(name)) = 'EM FERNANDO VILELA' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168602');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ CABRAL VIEIRA (MONTE ALEGRE DE MINAS) - INEP: 166928
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166928' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ CABRAL VIEIRA' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166928');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MÁRCIA CAETANO ALVES (MONTE ALEGRE DE MINAS) - INEP: 219304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219304' 
    WHERE UPPER(TRIM(name)) = 'EM MÁRCIA CAETANO ALVES' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM NICANOR PARREIRA (MONTE ALEGRE DE MINAS) - INEP: 166944
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166944' 
    WHERE UPPER(TRIM(name)) = 'EM NICANOR PARREIRA' 
      AND UPPER(TRIM(city)) = 'MONTE ALEGRE DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166944');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRESIDENTE VARGAS (NOVA PONTE) - INEP: 168874
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168874' 
    WHERE UPPER(TRIM(name)) = 'EM PRESIDENTE VARGAS' 
      AND UPPER(TRIM(city)) = 'NOVA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168874');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA NEUZA LOPES PINTO (NOVA PONTE) - INEP: 347728
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '347728' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA NEUZA LOPES PINTO' 
      AND UPPER(TRIM(city)) = 'NOVA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '347728');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO MIGUEL (NOVA PONTE) - INEP: 166987
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '166987' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO MIGUEL' 
      AND UPPER(TRIM(city)) = 'NOVA PONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '166987');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AFONSINA MARIA DE JESUS (PRATA) - INEP: 167100
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167100' 
    WHERE UPPER(TRIM(name)) = 'EM AFONSINA MARIA DE JESUS' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167100');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM PEDRO II (PRATA) - INEP: 168955
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '168955' 
    WHERE UPPER(TRIM(name)) = 'EM DOM PEDRO II' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '168955');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIANA CLARA GOUVEIA (PRATA) - INEP: 167096
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '167096' 
    WHERE UPPER(TRIM(name)) = 'EM MARIANA CLARA GOUVEIA' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '167096');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PADRE JOÃO ANESI (PRATA) - INEP: 169129
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169129' 
    WHERE UPPER(TRIM(name)) = 'EM PADRE JOÃO ANESI' 
      AND UPPER(TRIM(city)) = 'PRATA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169129');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA CONCEIÇÃO BORGES (TUPACIGUARA) - INEP: 233731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '233731' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA CONCEIÇÃO BORGES' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '233731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAZ E AMOR (TUPACIGUARA) - INEP: 169439
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169439' 
    WHERE UPPER(TRIM(name)) = 'EM PAZ E AMOR' 
      AND UPPER(TRIM(city)) = 'TUPACIGUARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169439');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM AFRÂNIO RODRIGUES DA CUNHA (UBERLÂNDIA) - INEP: 169528
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169528' 
    WHERE UPPER(TRIM(name)) = 'EM AFRÂNIO RODRIGUES DA CUNHA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169528');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTONINO MARTINS DA SILVA (UBERLÂNDIA) - INEP: 170143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170143' 
    WHERE UPPER(TRIM(name)) = 'EM ANTONINO MARTINS DA SILVA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CARLOS TUCCI (UBERLÂNDIA) - INEP: 169561
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169561' 
    WHERE UPPER(TRIM(name)) = 'EM CARLOS TUCCI' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169561');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE SOBRADINHO (UBERLÂNDIA) - INEP: 228699
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '228699' 
    WHERE UPPER(TRIM(name)) = 'EM DE SOBRADINHO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '228699');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO BAIRRO SHOPPING PARK (UBERLÂNDIA) - INEP: 319651
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319651' 
    WHERE UPPER(TRIM(name)) = 'EM DO BAIRRO SHOPPING PARK' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319651');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DO MORENO (UBERLÂNDIA) - INEP: 169676
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169676' 
    WHERE UPPER(TRIM(name)) = 'EM DO MORENO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169676');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOM BOSCO (UBERLÂNDIA) - INEP: 214141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '214141' 
    WHERE UPPER(TRIM(name)) = 'EM DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '214141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOMINGAS CAMIN (UBERLÂNDIA) - INEP: 170151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170151' 
    WHERE UPPER(TRIM(name)) = 'EM DOMINGAS CAMIN' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR GLADSEN GUERRA DE REZENDE (UBERLÂNDIA) - INEP: 271578
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '271578' 
    WHERE UPPER(TRIM(name)) = 'EM DR GLADSEN GUERRA DE REZENDE' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '271578');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR JOEL CUPERTINO RODRIGUES (UBERLÂNDIA) - INEP: 245917
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245917' 
    WHERE UPPER(TRIM(name)) = 'EM DR JOEL CUPERTINO RODRIGUES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245917');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EMÍLIO RIBAS (UBERLÂNDIA) - INEP: 169820
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169820' 
    WHERE UPPER(TRIM(name)) = 'EM EMÍLIO RIBAS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169820');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FREITAS AZEVEDO (UBERLÂNDIA) - INEP: 169889
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '169889' 
    WHERE UPPER(TRIM(name)) = 'EM FREITAS AZEVEDO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '169889');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM HILDA LEÃO CARNEIRO (UBERLÂNDIA) - INEP: 246743
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246743' 
    WHERE UPPER(TRIM(name)) = 'EM HILDA LEÃO CARNEIRO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246743');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARRA DA FONSECA (UBERLÂNDIA) - INEP: 170135
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170135' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARRA DA FONSECA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170135');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LEANDRO JOSÉ DE OLIVEIRA (UBERLÂNDIA) - INEP: 214175
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '214175' 
    WHERE UPPER(TRIM(name)) = 'EM LEANDRO JOSÉ DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '214175');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ODILON CUSTÓDIO PEREIRA (UBERLÂNDIA) - INEP: 319716
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '319716' 
    WHERE UPPER(TRIM(name)) = 'EM ODILON CUSTÓDIO PEREIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '319716');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLHOS D'ÁGUA (UBERLÂNDIA) - INEP: 170054
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170054' 
    WHERE UPPER(TRIM(name)) = 'EM OLHOS D''ÁGUA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170054');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA MARIA REGINA ARANTES LEMES (UBERLÂNDIA) - INEP: 170089
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170089' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA MARIA REGINA ARANTES LEMES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170089');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA STELLA SARAIVA PEANO (UBERLÂNDIA) - INEP: 249238
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249238' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA STELLA SARAIVA PEANO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249238');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR DOMINGOS PIMENTEL ULHOA (UBERLÂNDIA) - INEP: 245909
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '245909' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR DOMINGOS PIMENTEL ULHOA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '245909');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR EURICO SILVA (UBERLÂNDIA) - INEP: 228745
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '228745' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR EURICO SILVA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '228745');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR JACY DE ASSIS (UBERLÂNDIA) - INEP: 269832
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269832' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR JACY DE ASSIS' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269832');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR LADÁRIO TEIXEIRA (UBERLÂNDIA) - INEP: 247499
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247499' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR LADÁRIO TEIXEIRA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247499');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR LEÔNCIO DO CARMO CHAVES (UBERLÂNDIA) - INEP: 228761
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '228761' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR LEÔNCIO DO CARMO CHAVES' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '228761');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR MÁRIO GODOY CASTANHO (UBERLÂNDIA) - INEP: 239631
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239631' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR MÁRIO GODOY CASTANHO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239631');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR OTÁVIO BATISTA COELHO FILHO (UBERLÂNDIA) - INEP: 240371
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240371' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR OTÁVIO BATISTA COELHO FILHO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240371');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR SÉRGIO DE OLIVEIRA MARQUEZ (UBERLÂNDIA) - INEP: 228753
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '228753' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR SÉRGIO DE OLIVEIRA MARQUEZ' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '228753');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA CARLOTA DE ANDRADE MARQUEZ (UBERLÂNDIA) - INEP: 354210
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354210' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA CARLOTA DE ANDRADE MARQUEZ' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354210');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA CECY CARDOSO PORFÍRIO (UBERLÂNDIA) - INEP: 239623
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '239623' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA CECY CARDOSO PORFÍRIO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '239623');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA JOSIANY FRANÇA (UBERLÂNDIA) - INEP: 338400
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '338400' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA JOSIANY FRANÇA' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '338400');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA OLGA DEL FÁVERO (UBERLÂNDIA) - INEP: 249190
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249190' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA OLGA DEL FÁVERO' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249190');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ORLANDA NEVES STRACK (UBERLÂNDIA) - INEP: 325473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325473' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ORLANDA NEVES STRACK' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SEBASTIÃO RANGEL (UBERLÂNDIA) - INEP: 170160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170160' 
    WHERE UPPER(TRIM(name)) = 'EM SEBASTIÃO RANGEL' 
      AND UPPER(TRIM(city)) = 'UBERLÂNDIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO FERNANDES PITANGUI (ARINOS) - INEP: 109762
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109762' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO FERNANDES PITANGUI' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109762');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO GONTIJO FERREIRA (ARINOS) - INEP: 272558
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '272558' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO GONTIJO FERREIRA' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '272558');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRINCESA ISABEL (ARINOS) - INEP: 109690
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109690' 
    WHERE UPPER(TRIM(name)) = 'EM PRINCESA ISABEL' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109690');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RIVALINO ÁLVARO DURÃES (ARINOS) - INEP: 109851
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109851' 
    WHERE UPPER(TRIM(name)) = 'EM RIVALINO ÁLVARO DURÃES' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109851');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTOS REIS (ARINOS) - INEP: 109967
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109967' 
    WHERE UPPER(TRIM(name)) = 'EM SANTOS REIS' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109967');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM VASCO BERNARDES DE OLIVEIRA (ARINOS) - INEP: 108201
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108201' 
    WHERE UPPER(TRIM(name)) = 'EM VASCO BERNARDES DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'ARINOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108201');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DERCÍLIO DUARTE MELGAÇO (BONFINÓPOLIS DE MINAS) - INEP: 108359
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108359' 
    WHERE UPPER(TRIM(name)) = 'EM DERCÍLIO DUARTE MELGAÇO' 
      AND UPPER(TRIM(city)) = 'BONFINÓPOLIS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108359');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÃO ALVES DA SILVA (BURITIS) - INEP: 214493
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '214493' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÃO ALVES DA SILVA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '214493');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTONINO CÂNDIDO LOPES (BURITIS) - INEP: 334332
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '334332' 
    WHERE UPPER(TRIM(name)) = 'EM ANTONINO CÂNDIDO LOPES' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '334332');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CÂNDIDO JOSÉ LOPES (BURITIS) - INEP: 108405
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108405' 
    WHERE UPPER(TRIM(name)) = 'EM CÂNDIDO JOSÉ LOPES' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108405');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EÇA DE QUEIROZ (BURITIS) - INEP: 110353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110353' 
    WHERE UPPER(TRIM(name)) = 'EM EÇA DE QUEIROZ' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110353');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FRANCISCO FERNANDES PITANGUI (BURITIS) - INEP: 110418
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110418' 
    WHERE UPPER(TRIM(name)) = 'EM FRANCISCO FERNANDES PITANGUI' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110418');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO FARIAS PINHO (BURITIS) - INEP: 110744
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110744' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO FARIAS PINHO' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110744');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ MARIA DE ALKIMIN (BURITIS) - INEP: 110493
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110493' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ MARIA DE ALKIMIN' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110493');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OLEGÁRIO BATISTA DA SILVA (BURITIS) - INEP: 110710
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110710' 
    WHERE UPPER(TRIM(name)) = 'EM OLEGÁRIO BATISTA DA SILVA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110710');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PHILOMENA CAMPOS LOPES (BURITIS) - INEP: 366790
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366790' 
    WHERE UPPER(TRIM(name)) = 'EM PHILOMENA CAMPOS LOPES' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366790');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR ANATÓLIO (BURITIS) - INEP: 110396
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110396' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR ANATÓLIO' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110396');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA LUZIA (BURITIS) - INEP: 108448
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108448' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA LUZIA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108448');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA MARTA (BURITIS) - INEP: 110914
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110914' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA MARTA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110914');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SANTA TEÓFILA (BURITIS) - INEP: 110931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '110931' 
    WHERE UPPER(TRIM(name)) = 'EM SANTA TEÓFILA' 
      AND UPPER(TRIM(city)) = 'BURITIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '110931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOAQUIM DE MENDONÇA (CABECEIRA GRANDE) - INEP: 113875
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '113875' 
    WHERE UPPER(TRIM(name)) = 'EM JOAQUIM DE MENDONÇA' 
      AND UPPER(TRIM(city)) = 'CABECEIRA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '113875');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARGARIDA GOMES FERREIRA (CABECEIRA GRANDE) - INEP: 367044
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367044' 
    WHERE UPPER(TRIM(name)) = 'EM MARGARIDA GOMES FERREIRA' 
      AND UPPER(TRIM(city)) = 'CABECEIRA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367044');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA HOZANA (CABECEIRA GRANDE) - INEP: 312185
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312185' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA HOZANA' 
      AND UPPER(TRIM(city)) = 'CABECEIRA GRANDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312185');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM STO ANTÔNIO (DOM BOSCO) - INEP: 108324
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108324' 
    WHERE UPPER(TRIM(name)) = 'EM STO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'DOM BOSCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108324');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM LÁZARO XAVIER PIRES (FORMOSO) - INEP: 111112
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '111112' 
    WHERE UPPER(TRIM(name)) = 'EM LÁZARO XAVIER PIRES' 
      AND UPPER(TRIM(city)) = 'FORMOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '111112');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM STO ANTÔNIO (FORMOSO) - INEP: 108472
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '108472' 
    WHERE UPPER(TRIM(name)) = 'EM STO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'FORMOSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '108472');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ADÉLIA RODRIGUES MARQUES (UNAÍ) - INEP: 112909
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '112909' 
    WHERE UPPER(TRIM(name)) = 'EM ADÉLIA RODRIGUES MARQUES' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '112909');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR ISRAEL PINHEIRO (UNAÍ) - INEP: 224006
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224006' 
    WHERE UPPER(TRIM(name)) = 'EM DR ISRAEL PINHEIRO' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224006');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EUCLIDES DA CUNHA (UNAÍ) - INEP: 113557
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '113557' 
    WHERE UPPER(TRIM(name)) = 'EM EUCLIDES DA CUNHA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '113557');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM EVA MARIA VIEIRA (UNAÍ) - INEP: 113964
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '113964' 
    WHERE UPPER(TRIM(name)) = 'EM EVA MARIA VIEIRA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '113964');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM N SRA DE FÁTIMA (UNAÍ) - INEP: 113689
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '113689' 
    WHERE UPPER(TRIM(name)) = 'EM N SRA DE FÁTIMA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '113689');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PE JOSÉ DE ANCHIETA (UNAÍ) - INEP: 324531
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324531' 
    WHERE UPPER(TRIM(name)) = 'EM PE JOSÉ DE ANCHIETA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324531');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA GLÓRIA MOREIRA (UNAÍ) - INEP: 292141
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292141' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA GLÓRIA MOREIRA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292141');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA JOVELMIRA J VASCONCELOS (UNAÍ) - INEP: 312274
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '312274' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA JOVELMIRA J VASCONCELOS' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '312274');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM STO ANTÔNIO (UNAÍ) - INEP: 114367
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114367' 
    WHERE UPPER(TRIM(name)) = 'EM STO ANTÔNIO' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114367');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TEODORO CAMPOS (UNAÍ) - INEP: 109126
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '109126' 
    WHERE UPPER(TRIM(name)) = 'EM TEODORO CAMPOS' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '109126');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TEREZINHA REZENDE (UNAÍ) - INEP: 114235
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114235' 
    WHERE UPPER(TRIM(name)) = 'EM TEREZINHA REZENDE' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114235');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM TOMAZ PINTO DA SILVA (UNAÍ) - INEP: 113441
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '113441' 
    WHERE UPPER(TRIM(name)) = 'EM TOMAZ PINTO DA SILVA' 
      AND UPPER(TRIM(city)) = 'UNAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '113441');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM FLORIANO PEIXOTO (URUANA DE MINAS) - INEP: 114111
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114111' 
    WHERE UPPER(TRIM(name)) = 'EM FLORIANO PEIXOTO' 
      AND UPPER(TRIM(city)) = 'URUANA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114111');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM GUSTAVO CAPANEMA (URUANA DE MINAS) - INEP: 114197
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '114197' 
    WHERE UPPER(TRIM(name)) = 'EM GUSTAVO CAPANEMA' 
      AND UPPER(TRIM(city)) = 'URUANA DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '114197');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ABRÃO ADOLPHO ENGEL (ALFENAS) - INEP: 170917
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170917' 
    WHERE UPPER(TRIM(name)) = 'EM ABRÃO ADOLPHO ENGEL' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170917');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ANTÔNIO JOAQUIM VIEIRA (ALFENAS) - INEP: 170747
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170747' 
    WHERE UPPER(TRIM(name)) = 'EM ANTÔNIO JOAQUIM VIEIRA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170747');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOUTOR FAUSTO MONTEIRO (ALFENAS) - INEP: 170801
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170801' 
    WHERE UPPER(TRIM(name)) = 'EM DOUTOR FAUSTO MONTEIRO' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170801');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ORLANDO PAULINO DA COSTA (ALFENAS) - INEP: 175323
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175323' 
    WHERE UPPER(TRIM(name)) = 'EM ORLANDO PAULINO DA COSTA' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175323');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PRESIDENTE TANCREDO NEVES (ALFENAS) - INEP: 170909
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '170909' 
    WHERE UPPER(TRIM(name)) = 'EM PRESIDENTE TANCREDO NEVES' 
      AND UPPER(TRIM(city)) = 'ALFENAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '170909');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DA FAZENDA ÁGUAS VERDES (BOA ESPERANÇA) - INEP: 171166
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171166' 
    WHERE UPPER(TRIM(name)) = 'EM DA FAZENDA ÁGUAS VERDES' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171166');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE BARRO PRETO (BOA ESPERANÇA) - INEP: 171131
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171131' 
    WHERE UPPER(TRIM(name)) = 'EM DE BARRO PRETO' 
      AND UPPER(TRIM(city)) = 'BOA ESPERANÇA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171131');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOÃO BARBALHO (CAMPOS GERAIS) - INEP: 171654
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '171654' 
    WHERE UPPER(TRIM(name)) = 'EM JOÃO BARBALHO' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '171654');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RURAL JOÃO CÂNDIDO DE FARIA (CAMPOS GERAIS) - INEP: 176354
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '176354' 
    WHERE UPPER(TRIM(name)) = 'EM RURAL JOÃO CÂNDIDO DE FARIA' 
      AND UPPER(TRIM(city)) = 'CAMPOS GERAIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '176354');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA CAPRONI DE OLIVEIRA (CARVALHÓPOLIS) - INEP: 269719
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269719' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA CAPRONI DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CARVALHÓPOLIS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269719');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ASTOLFO MOREIRA DE CARVALHO (ELÓI MENDES) - INEP: 249408
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '249408' 
    WHERE UPPER(TRIM(name)) = 'EM ASTOLFO MOREIRA DE CARVALHO' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '249408');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DA FAZENDA SANTA CRUZ (ELÓI MENDES) - INEP: 172545
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172545' 
    WHERE UPPER(TRIM(name)) = 'EM DA FAZENDA SANTA CRUZ' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172545');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA DO CARMO MENDES (ELÓI MENDES) - INEP: 224685
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224685' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA DO CARMO MENDES' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224685');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARTA MARTINS MACHADO (ELÓI MENDES) - INEP: 224693
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '224693' 
    WHERE UPPER(TRIM(name)) = 'EM MARTA MARTINS MACHADO' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '224693');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM OSCAR ARAÚJO (ELÓI MENDES) - INEP: 176940
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '176940' 
    WHERE UPPER(TRIM(name)) = 'EM OSCAR ARAÚJO' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '176940');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA JÚLIA CAMÕES VIEITO (ELÓI MENDES) - INEP: 172596
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172596' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA JÚLIA CAMÕES VIEITO' 
      AND UPPER(TRIM(city)) = 'ELÓI MENDES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172596');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE APARECIDA DO SUL (GUAPÉ) - INEP: 172685
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172685' 
    WHERE UPPER(TRIM(name)) = 'EM DE APARECIDA DO SUL' 
      AND UPPER(TRIM(city)) = 'GUAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172685');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DEPUTADO JOAQUIM DE MELO FREIRE (GUAPÉ) - INEP: 177083
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '177083' 
    WHERE UPPER(TRIM(name)) = 'EM DEPUTADO JOAQUIM DE MELO FREIRE' 
      AND UPPER(TRIM(city)) = 'GUAPÉ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '177083');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROF ISMAEL SILVA (ILICÍNEA) - INEP: 172839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '172839' 
    WHERE UPPER(TRIM(name)) = 'EM PROF ISMAEL SILVA' 
      AND UPPER(TRIM(city)) = 'ILICÍNEA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '172839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PAULO SINÉSIO BELATO (MONSENHOR PAULO) - INEP: 217735
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '217735' 
    WHERE UPPER(TRIM(name)) = 'EM PAULO SINÉSIO BELATO' 
      AND UPPER(TRIM(city)) = 'MONSENHOR PAULO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '217735');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE GUAIPAVA (PARAGUAÇU) - INEP: 173657
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '173657' 
    WHERE UPPER(TRIM(name)) = 'EM DE GUAIPAVA' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '173657');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MARIA ANTONIETA ALVARENGA (PARAGUAÇU) - INEP: 234630
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234630' 
    WHERE UPPER(TRIM(name)) = 'EM MARIA ANTONIETA ALVARENGA' 
      AND UPPER(TRIM(city)) = 'PARAGUAÇU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234630');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM BENTO GONÇALVES FILHO (SÃO GONÇALO DO SAPUCAÍ) - INEP: 178845
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '178845' 
    WHERE UPPER(TRIM(name)) = 'EM BENTO GONÇALVES FILHO' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '178845');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DE FERREIRAS (SÃO GONÇALO DO SAPUCAÍ) - INEP: 377473
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377473' 
    WHERE UPPER(TRIM(name)) = 'EM DE FERREIRAS' 
      AND UPPER(TRIM(city)) = 'SÃO GONÇALO DO SAPUCAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377473');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CAIC EM PROFA CÂNDIDA JUNQUEIRA (TRÊS CORAÇÕES) - INEP: 254746
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254746' 
    WHERE UPPER(TRIM(name)) = 'CAIC EM PROFA CÂNDIDA JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254746');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CAPITÃO MORBELLO VENDRAMINI (TRÊS CORAÇÕES) - INEP: 346888
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346888' 
    WHERE UPPER(TRIM(name)) = 'EM CAPITÃO MORBELLO VENDRAMINI' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346888');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DONA MARIA LAURA (TRÊS CORAÇÕES) - INEP: 262099
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '262099' 
    WHERE UPPER(TRIM(name)) = 'EM DONA MARIA LAURA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '262099');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ JOAQUIM ALVES PEREIRA (TRÊS CORAÇÕES) - INEP: 179485
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179485' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ JOAQUIM ALVES PEREIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179485');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PREF CELSO BANDA (TRÊS CORAÇÕES) - INEP: 234958
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234958' 
    WHERE UPPER(TRIM(name)) = 'EM PREF CELSO BANDA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234958');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFA MARIA EVANI GOMES TELES (TRÊS CORAÇÕES) - INEP: 346950
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346950' 
    WHERE UPPER(TRIM(name)) = 'EM PROFA MARIA EVANI GOMES TELES' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346950');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA HENRIQUETA GOMES (TRÊS CORAÇÕES) - INEP: 254738
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254738' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA HENRIQUETA GOMES' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254738');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA ONEIDA JUNQUEIRA (TRÊS CORAÇÕES) - INEP: 179353
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179353' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA ONEIDA JUNQUEIRA' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179353');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM RIO DO PEIXE II (TRÊS CORAÇÕES) - INEP: 179434
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179434' 
    WHERE UPPER(TRIM(name)) = 'EM RIO DO PEIXE II' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179434');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ROTARY (TRÊS CORAÇÕES) - INEP: 179451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179451' 
    WHERE UPPER(TRIM(name)) = 'EM ROTARY' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SAGRADO CORAÇÃO DE JESUS (TRÊS CORAÇÕES) - INEP: 179515
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179515' 
    WHERE UPPER(TRIM(name)) = 'EM SAGRADO CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179515');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM ZILAH REZENDE PINTO (TRÊS CORAÇÕES) - INEP: 174505
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174505' 
    WHERE UPPER(TRIM(name)) = 'EM ZILAH REZENDE PINTO' 
      AND UPPER(TRIM(city)) = 'TRÊS CORAÇÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174505');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ VIEIRA MENDONÇA (TRÊS PONTAS) - INEP: 222445
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '222445' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ VIEIRA MENDONÇA' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '222445');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSOR JOÃO DE ABREU SALGADO (TRÊS PONTAS) - INEP: 174807
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '174807' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSOR JOÃO DE ABREU SALGADO' 
      AND UPPER(TRIM(city)) = 'TRÊS PONTAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '174807');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM CLAUDIO FIGUEIREDO NOGUEIRA (VARGINHA) - INEP: 348457
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '348457' 
    WHERE UPPER(TRIM(name)) = 'EM CLAUDIO FIGUEIREDO NOGUEIRA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '348457');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DOMINGOS RIBEIRO DE REZENDE (VARGINHA) - INEP: 175021
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '175021' 
    WHERE UPPER(TRIM(name)) = 'EM DOMINGOS RIBEIRO DE REZENDE' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '175021');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM DR JACY DE FIGUEIREDO (VARGINHA) - INEP: 234672
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '234672' 
    WHERE UPPER(TRIM(name)) = 'EM DR JACY DE FIGUEIREDO' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '234672');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ AUGUSTO PAIVA (VARGINHA) - INEP: 179914
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179914' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ AUGUSTO PAIVA' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179914');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM JOSÉ CAMILO TAVARES (VARGINHA) - INEP: 179931
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '179931' 
    WHERE UPPER(TRIM(name)) = 'EM JOSÉ CAMILO TAVARES' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '179931');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM MATHEUS TAVARES (VARGINHA) - INEP: 180017
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180017' 
    WHERE UPPER(TRIM(name)) = 'EM MATHEUS TAVARES' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180017');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA HELENA REIS (VARGINHA) - INEP: 251160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251160' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA HELENA REIS' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM PROFESSORA MARIA APARECIDA ABREU (VARGINHA) - INEP: 306975
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '306975' 
    WHERE UPPER(TRIM(name)) = 'EM PROFESSORA MARIA APARECIDA ABREU' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '306975');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EM SÃO JOSÉ (VARGINHA) - INEP: 180092
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180092' 
    WHERE UPPER(TRIM(name)) = 'EM SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'VARGINHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180092');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL JOÃO E MARIA (ALMENARA) - INEP: 353965
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '353965' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL JOÃO E MARIA' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '353965');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO COMUNITÁRIO DOUTOR FERNANDO MAGALHÃES (ALMENARA) - INEP: 247731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '247731' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO COMUNITÁRIO DOUTOR FERNANDO MAGALHÃES' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '247731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIAGET ALMENARA (ALMENARA) - INEP: 299146
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299146' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIAGET ALMENARA' 
      AND UPPER(TRIM(city)) = 'ALMENARA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299146');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL JOÃO E MARIA (JACINTO) - INEP: 351555
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351555' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL JOÃO E MARIA' 
      AND UPPER(TRIM(city)) = 'JACINTO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351555');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL MEU CAMINHO (JEQUITINHONHA) - INEP: 297747
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '297747' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL MEU CAMINHO' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '297747');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIRÂMIDE (JEQUITINHONHA) - INEP: 278751
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278751' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIRÂMIDE' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278751');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA RENASCER (JEQUITINHONHA) - INEP: 366200
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '366200' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA RENASCER' 
      AND UPPER(TRIM(city)) = 'JEQUITINHONHA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '366200');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL CONHECER CONSTRUIR E VIVER (JOAÍMA) - INEP: 279412
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279412' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL CONHECER CONSTRUIR E VIVER' 
      AND UPPER(TRIM(city)) = 'JOAÍMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279412');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL UNIVERSO - CEU (PEDRA AZUL) - INEP: 340405
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340405' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL UNIVERSO - CEU' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340405');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE PEDRA AZUL-ITEP (PEDRA AZUL) - INEP: 329096
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329096' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE PEDRA AZUL-ITEP' 
      AND UPPER(TRIM(city)) = 'PEDRA AZUL' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329096');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NAZARETH (ARAÇUAÍ) - INEP: 157864
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '157864' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NAZARETH' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '157864');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGROECOLÓGICA DE ARAÇUAÍ (ARAÇUAÍ) - INEP: 343323
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343323' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGROECOLÓGICA DE ARAÇUAÍ' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343323');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL ANTÔNIO COSENZA LEITE (ARAÇUAÍ) - INEP: 279943
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '279943' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL ANTÔNIO COSENZA LEITE' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '279943');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE ARAÇUAÍ (ARAÇUAÍ) - INEP: 342106
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '342106' 
    WHERE UPPER(TRIM(name)) = 'ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE ARAÇUAÍ' 
      AND UPPER(TRIM(city)) = 'ARAÇUAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '342106');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA VIDA COMUNITÁRIA (COMERCINHO) - INEP: 321265
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321265' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA VIDA COMUNITÁRIA' 
      AND UPPER(TRIM(city)) = 'COMERCINHO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321265');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CRESCER FELIZ LTDA - ME (ITAOBIM) - INEP: 361240
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361240' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CRESCER FELIZ LTDA - ME' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361240');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA BONTEMPO (ITAOBIM) - INEP: 313793
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313793' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA BONTEMPO' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313793');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE ITAOBIM (ITAOBIM) - INEP: 363120
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363120' 
    WHERE UPPER(TRIM(name)) = 'ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE ITAOBIM' 
      AND UPPER(TRIM(city)) = 'ITAOBIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363120');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA COMUNITÁRIA DA FAMÍLIA AGRÍCOLA JACARÉ (ITINGA) - INEP: 260401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '260401' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA COMUNITÁRIA DA FAMÍLIA AGRÍCOLA JACARÉ' 
      AND UPPER(TRIM(city)) = 'ITINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '260401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE (MEDINA) - INEP: 379972
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379972' 
    WHERE UPPER(TRIM(name)) = 'ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE' 
      AND UPPER(TRIM(city)) = 'MEDINA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379972');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL EQUILÍBRIO SALINAS (SALINAS) - INEP: 357073
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357073' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL EQUILÍBRIO SALINAS' 
      AND UPPER(TRIM(city)) = 'SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357073');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRESBITERIANO DE SALINAS (SALINAS) - INEP: 230456
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230456' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRESBITERIANO DE SALINAS' 
      AND UPPER(TRIM(city)) = 'SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230456');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL NOSSA SENHORA APARECIDA-IENSA (SALINAS) - INEP: 277509
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277509' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL NOSSA SENHORA APARECIDA-IENSA' 
      AND UPPER(TRIM(city)) = 'SALINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277509');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL BELIZA CORRÊA (TAIOBEIRAS) - INEP: 280879
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280879' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL BELIZA CORRÊA' 
      AND UPPER(TRIM(city)) = 'TAIOBEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280879');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CESP - CENTRO EDUCACIONAL SILVEIRA E PINHEIRO (TAIOBEIRAS) - INEP: 356158
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356158' 
    WHERE UPPER(TRIM(name)) = 'CESP - CENTRO EDUCACIONAL SILVEIRA E PINHEIRO' 
      AND UPPER(TRIM(city)) = 'TAIOBEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356158');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRESBITERIANO DE TAIOBEIRAS (TAIOBEIRAS) - INEP: 325309
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325309' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRESBITERIANO DE TAIOBEIRAS' 
      AND UPPER(TRIM(city)) = 'TAIOBEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325309');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA NOVA ESPERANÇA (TAIOBEIRAS) - INEP: 352829
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '352829' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA NOVA ESPERANÇA' 
      AND UPPER(TRIM(city)) = 'TAIOBEIRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '352829');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA FAMÍLIA AGRÍCOLA (VIRGEM DA LAPA) - INEP: 237850
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '237850' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA FAMÍLIA AGRÍCOLA' 
      AND UPPER(TRIM(city)) = 'VIRGEM DA LAPA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '237850');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL UNIPAC (ANTÔNIO CARLOS) - INEP: 379840
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379840' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL UNIPAC' 
      AND UPPER(TRIM(city)) = 'ANTÔNIO CARLOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379840');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- APRENDIZ COLÉGIO E CURSOS TÉCNICOS (BARBACENA) - INEP: 324850
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324850' 
    WHERE UPPER(TRIM(name)) = 'APRENDIZ COLÉGIO E CURSOS TÉCNICOS' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324850');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CECON BARBACENA (BARBACENA) - INEP: 350230
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '350230' 
    WHERE UPPER(TRIM(name)) = 'CECON BARBACENA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '350230');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL APRENDIZ UNIDADE II (BARBACENA) - INEP: 337331
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '337331' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL APRENDIZ UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '337331');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL DESAFIO (BARBACENA) - INEP: 376850
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '376850' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL DESAFIO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '376850');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO FORMAÇÃO PROFISSIONAL DE BARBACENA - SENAI (BARBACENA) - INEP: 280003
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280003' 
    WHERE UPPER(TRIM(name)) = 'CENTRO FORMAÇÃO PROFISSIONAL DE BARBACENA - SENAI' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280003');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE BARBACENA (BARBACENA) - INEP: 367281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367281' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE BARBACENA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO APLICAÇÃO (BARBACENA) - INEP: 371769
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '371769' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO APLICAÇÃO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '371769');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ARCA (BARBACENA) - INEP: 293172
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293172' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ARCA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293172');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DESAFIO DE BARBACENA (BARBACENA) - INEP: 344834
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344834' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DESAFIO DE BARBACENA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344834');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO POLITÉCNICO (BARBACENA) - INEP: 364142
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364142' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO POLITÉCNICO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364142');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO POLITÉCNICO BARBACENA (BARBACENA) - INEP: 358487
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358487' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO POLITÉCNICO BARBACENA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358487');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO FRANCISCO DE ASSIS (BARBACENA) - INEP: 368032
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '368032' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '368032');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SOBERANA (BARBACENA) - INEP: 377600
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377600' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SOBERANA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377600');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- DESAFIO PRIMEIRO PASSO (BARBACENA) - INEP: 361410
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361410' 
    WHERE UPPER(TRIM(name)) = 'DESAFIO PRIMEIRO PASSO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361410');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA NETWARE (BARBACENA) - INEP: 363731
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363731' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA NETWARE' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363731');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI OSCAR MAGALHÃES FERREIRA (BARBACENA) - INEP: 304875
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '304875' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI OSCAR MAGALHÃES FERREIRA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '304875');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI OSCAR MAGALHÃES FERREIRA - UNIDADE II (BARBACENA) - INEP: 379794
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '379794' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI OSCAR MAGALHÃES FERREIRA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '379794');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMPPACTO CURSOS PROFISSIONALIZANTES (BARBACENA) - INEP: 339580
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339580' 
    WHERE UPPER(TRIM(name)) = 'IMPPACTO CURSOS PROFISSIONALIZANTES' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339580');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO APRENDIZ SOLIDÁRIO (BARBACENA) - INEP: 305120
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305120' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO APRENDIZ SOLIDÁRIO' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305120');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PREMIUM (BARBACENA) - INEP: 367176
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '367176' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PREMIUM' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '367176');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDIDADE ENSINO XI- CENTRO DE FORMAÇÃO PROFISSIONAL DE BARBACENA (BARBACENA) - INEP: 313734
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '313734' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDIDADE ENSINO XI- CENTRO DE FORMAÇÃO PROFISSIONAL DE BARBACENA' 
      AND UPPER(TRIM(city)) = 'BARBACENA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '313734');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SOL NASCENTE (BARROSO) - INEP: 294381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '294381' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SOL NASCENTE' 
      AND UPPER(TRIM(city)) = 'BARROSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '294381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INVICTUS CENTRO DE ENSINO (BARROSO) - INEP: 280691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '280691' 
    WHERE UPPER(TRIM(name)) = 'INVICTUS CENTRO DE ENSINO' 
      AND UPPER(TRIM(city)) = 'BARROSO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '280691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL LISBOA (CARANDAÍ) - INEP: 277860
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '277860' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL LISBOA' 
      AND UPPER(TRIM(city)) = 'CARANDAÍ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '277860');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO SABER (MERCÊS) - INEP: 361194
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '361194' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO SABER' 
      AND UPPER(TRIM(city)) = 'MERCÊS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '361194');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO MINEIRO TÉCNICO PROFISSIONAL DE CAMPO BELO (CAMPO BELO) - INEP: 370606
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '370606' 
    WHERE UPPER(TRIM(name)) = 'CENTRO MINEIRO TÉCNICO PROFISSIONAL DE CAMPO BELO' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '370606');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO AQUARELA (CAMPO BELO) - INEP: 356930
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '356930' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO AQUARELA' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '356930');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM CABRAL (CAMPO BELO) - INEP: 205150
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205150' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM CABRAL' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205150');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO DE CAMPO BELO (CAMPO BELO) - INEP: 329576
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329576' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO DE CAMPO BELO' 
      AND UPPER(TRIM(city)) = 'CAMPO BELO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329576');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CAMBALHOTA (CANDEIAS) - INEP: 288209
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '288209' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CAMBALHOTA' 
      AND UPPER(TRIM(city)) = 'CANDEIAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '288209');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE ENSINO ADMISSÃO (LAVRAS) - INEP: 374628
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374628' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE ENSINO ADMISSÃO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374628');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TECNOLÓGICO DE LAVRAS - CETEC (LAVRAS) - INEP: 341371
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '341371' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TECNOLÓGICO DE LAVRAS - CETEC' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '341371');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADVENTISTA -  FADMINAS (LAVRAS) - INEP: 246018
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246018' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADVENTISTA - FADMINAS' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246018');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CENECISTA JUVENTINO DIAS (LAVRAS) - INEP: 205249
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205249' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CENECISTA JUVENTINO DIAS' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205249');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCA (LAVRAS) - INEP: 310573
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310573' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCA' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310573');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMP (LAVRAS) - INEP: 346314
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '346314' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMP' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '346314');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LOSANGO DE LAVRAS (LAVRAS) - INEP: 354848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '354848' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LOSANGO DE LAVRAS' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '354848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DE LOURDES (LAVRAS) - INEP: 205231
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205231' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DE LOURDES' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205231');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO UNIVERSITÁRIO PROFESSOR CANÍSIO IGNÁCIO LUNKES (LAVRAS) - INEP: 328294
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '328294' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO UNIVERSITÁRIO PROFESSOR CANÍSIO IGNÁCIO LUNKES' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '328294');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ECEI ESCOLA COOPERATIVA DE ENSINO E INTEGRAÇÃO (LAVRAS) - INEP: 292451
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292451' 
    WHERE UPPER(TRIM(name)) = 'ECEI ESCOLA COOPERATIVA DE ENSINO E INTEGRAÇÃO' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292451');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA COOPERATIVA GRALHA AZUL (LAVRAS) - INEP: 210609
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210609' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA COOPERATIVA GRALHA AZUL' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210609');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMPACTO ESCOLA DE SAÚDE (LAVRAS) - INEP: 326160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326160' 
    WHERE UPPER(TRIM(name)) = 'IMPACTO ESCOLA DE SAÚDE' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PRESBITERIANO GAMMON (LAVRAS) - INEP: 205265
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205265' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PRESBITERIANO GAMMON' 
      AND UPPER(TRIM(city)) = 'LAVRAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205265');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CENECISTA DULCE OLIVEIRA (PERDÕES) - INEP: 205281
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '205281' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CENECISTA DULCE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '205281');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- NÚCLEO DE APRENDIZAGEM INTEGRAL (PERDÕES) - INEP: 278602
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278602' 
    WHERE UPPER(TRIM(name)) = 'NÚCLEO DE APRENDIZAGEM INTEGRAL' 
      AND UPPER(TRIM(city)) = 'PERDÕES' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278602');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO  EDUCACIONAL FAUSTO AVELLAR-CEFA (SANTO ANTÔNIO DO AMPARO) - INEP: 322253
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '322253' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL FAUSTO AVELLAR-CEFA' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '322253');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL ARCO (SANTO ANTÔNIO DO AMPARO) - INEP: 278793
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278793' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL ARCO' 
      AND UPPER(TRIM(city)) = 'SANTO ANTÔNIO DO AMPARO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278793');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CONCEITO (CARANGOLA) - INEP: 326143
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326143' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CONCEITO' 
      AND UPPER(TRIM(city)) = 'CARANGOLA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326143');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ENF-CIÊNCIA (CARANGOLA) - INEP: 309800
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '309800' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ENF-CIÊNCIA' 
      AND UPPER(TRIM(city)) = 'CARANGOLA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '309800');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA OFFICINA DO SABER (CARANGOLA) - INEP: 276006
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '276006' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA OFFICINA DO SABER' 
      AND UPPER(TRIM(city)) = 'CARANGOLA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '276006');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SERVITA REGINA PACIS (CARANGOLA) - INEP: 102385
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '102385' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SERVITA REGINA PACIS' 
      AND UPPER(TRIM(city)) = 'CARANGOLA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '102385');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- IMEC DE CARANGOLA (CARANGOLA) - INEP: 329886
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '329886' 
    WHERE UPPER(TRIM(name)) = 'IMEC DE CARANGOLA' 
      AND UPPER(TRIM(city)) = 'CARANGOLA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '329886');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCAR (DIVINO) - INEP: 380989
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '380989' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCAR' 
      AND UPPER(TRIM(city)) = 'DIVINO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '380989');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA REOBOTE (ESPERA FELIZ) - INEP: 281808
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281808' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA REOBOTE' 
      AND UPPER(TRIM(city)) = 'ESPERA FELIZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281808');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PORTAL DO SABER (ESPERA FELIZ) - INEP: 299880
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '299880' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PORTAL DO SABER' 
      AND UPPER(TRIM(city)) = 'ESPERA FELIZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '299880');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO DE EDUCAÇÃO MORIÁ (ESPERA FELIZ) - INEP: 351849
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351849' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO DE EDUCAÇÃO MORIÁ' 
      AND UPPER(TRIM(city)) = 'ESPERA FELIZ' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351849');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO DE EXTENSÃO E FORMAÇÃO OFICINA DO CORPO - CEFOC (TOMBOS) - INEP: 369896
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '369896' 
    WHERE UPPER(TRIM(name)) = 'CENTRO DE EXTENSÃO E FORMAÇÃO OFICINA DO CORPO - CEFOC' 
      AND UPPER(TRIM(city)) = 'TOMBOS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '369896');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOCTUM (CARATINGA) - INEP: 345865
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345865' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOCTUM' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345865');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GENOMA (CARATINGA) - INEP: 360147
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '360147' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GENOMA' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '360147');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PROFESSOR JAIRO GROSSI (CARATINGA) - INEP: 219126
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '219126' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PROFESSOR JAIRO GROSSI' 
      AND UPPER(TRIM(city)) = 'CARATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '219126');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA LÁPIS DE COR (INHAPIM) - INEP: 281107
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '281107' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA LÁPIS DE COR' 
      AND UPPER(TRIM(city)) = 'INHAPIM' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '281107');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO PRESBITERIANO DE EDUCAÇÃO LOGOS (IPANEMA) - INEP: 374407
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374407' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO PRESBITERIANO DE EDUCAÇÃO LOGOS' 
      AND UPPER(TRIM(city)) = 'IPANEMA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374407');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE BAEPENDI (BAEPENDI) - INEP: 381012
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381012' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE BAEPENDI' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381012');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO FRANCISCANO SANTO INÁCIO (BAEPENDI) - INEP: 180262
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180262' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO FRANCISCANO SANTO INÁCIO' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180262');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCANDÁRIO FRANCISCANO NHÁ CHICA (BAEPENDI) - INEP: 364460
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364460' 
    WHERE UPPER(TRIM(name)) = 'EDUCANDÁRIO FRANCISCANO NHÁ CHICA' 
      AND UPPER(TRIM(city)) = 'BAEPENDI' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364460');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL GENNY GOMES (CAXAMBU) - INEP: 274691
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274691' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL GENNY GOMES' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274691');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM FERRAZ (CAXAMBU) - INEP: 248401
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '248401' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM FERRAZ' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '248401');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ÊXITO (CAXAMBU) - INEP: 372030
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372030' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ÊXITO' 
      AND UPPER(TRIM(city)) = 'CAXAMBU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372030');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO SÃO JOSÉ (CONCEIÇÃO DO RIO VERDE) - INEP: 324507
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '324507' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO SÃO JOSÉ' 
      AND UPPER(TRIM(city)) = 'CONCEIÇÃO DO RIO VERDE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '324507');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JOÃO PAULO II (CRUZÍLIA) - INEP: 349127
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349127' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JOÃO PAULO II' 
      AND UPPER(TRIM(city)) = 'CRUZÍLIA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349127');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO CULTURAL CLOTILDE FRAMIL (ITAMONTE) - INEP: 273091
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273091' 
    WHERE UPPER(TRIM(name)) = 'CENTRO CULTURAL CLOTILDE FRAMIL' 
      AND UPPER(TRIM(city)) = 'ITAMONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273091');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EDUCANDÁRIO SÃO FRANCISCO DE ASSIS (ITAMONTE) - INEP: 278815
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '278815' 
    WHERE UPPER(TRIM(name)) = 'EDUCANDÁRIO SÃO FRANCISCO DE ASSIS' 
      AND UPPER(TRIM(city)) = 'ITAMONTE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '278815');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL AQUARELA (ITANHANDU) - INEP: 273848
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '273848' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL AQUARELA' 
      AND UPPER(TRIM(city)) = 'ITANHANDU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '273848');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MINAS AUSTRAL (ITANHANDU) - INEP: 223778
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '223778' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MINAS AUSTRAL' 
      AND UPPER(TRIM(city)) = 'ITANHANDU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '223778');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PRIMAR (ITANHANDU) - INEP: 345571
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '345571' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PRIMAR' 
      AND UPPER(TRIM(city)) = 'ITANHANDU' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '345571');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BALBINA RIBEIRO SOARES (PASSA QUATRO) - INEP: 180475
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180475' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BALBINA RIBEIRO SOARES' 
      AND UPPER(TRIM(city)) = 'PASSA QUATRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180475');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO MIGUEL (PASSA QUATRO) - INEP: 180483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180483' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO MIGUEL' 
      AND UPPER(TRIM(city)) = 'PASSA QUATRO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ALERE (SÃO LOURENÇO) - INEP: 377481
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '377481' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ALERE' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '377481');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM BOSCO (SÃO LOURENÇO) - INEP: 323071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '323071' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM BOSCO' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '323071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO DOM FERRAZ SOLAR (SÃO LOURENÇO) - INEP: 274852
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '274852' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO DOM FERRAZ SOLAR' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '274852');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO IMACULADO CORAÇÃO DE MARIA (SÃO LOURENÇO) - INEP: 180521
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180521' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO IMACULADO CORAÇÃO DE MARIA' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180521');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO INTEGRADO DE SÃO LOURENÇO (SÃO LOURENÇO) - INEP: 246182
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '246182' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO INTEGRADO DE SÃO LOURENÇO' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '246182');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO LASER (SÃO LOURENÇO) - INEP: 180530
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '180530' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO LASER' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '180530');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO GÊNESIS DE EDUCAÇÃO E CULTURA (SÃO LOURENÇO) - INEP: 293881
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '293881' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO GÊNESIS DE EDUCAÇÃO E CULTURA' 
      AND UPPER(TRIM(city)) = 'SÃO LOURENÇO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '293881');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CET - CENTRO DE EDUCACÃO TECNOLÓGICA GENERAL EDMUNDO DE MACEDO SOARES E SILVA (CONGONHAS) - INEP: 196142
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196142' 
    WHERE UPPER(TRIM(name)) = 'CET - CENTRO DE EDUCACÃO TECNOLÓGICA GENERAL EDMUNDO DE MACEDO SOARES E SILVA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196142');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ARCEBISPO DOM OSCAR DE OLIVEIRA (CONGONHAS) - INEP: 292826
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '292826' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ARCEBISPO DOM OSCAR DE OLIVEIRA' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '292826');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DA PIEDADE (CONGONHAS) - INEP: 196134
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196134' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DA PIEDADE' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196134');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SAGRADO CORAÇÃO DE JESUS (CONGONHAS) - INEP: 344249
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344249' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SAGRADO CORAÇÃO DE JESUS' 
      AND UPPER(TRIM(city)) = 'CONGONHAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344249');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE CONSELHEIRO LAFAIETE (CONSELHEIRO LAFAIETE) - INEP: 381330
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '381330' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE CONSELHEIRO LAFAIETE' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '381330');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO EDUCAR (CONSELHEIRO LAFAIETE) - INEP: 351997
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '351997' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO EDUCAR' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '351997');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO MONTEIRO LOBATO (CONSELHEIRO LAFAIETE) - INEP: 256919
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '256919' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO MONTEIRO LOBATO' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '256919');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO NOSSA SENHORA DE NAZARÉ (CONSELHEIRO LAFAIETE) - INEP: 196177
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196177' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO NOSSA SENHORA DE NAZARÉ' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196177');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO POTÊNCIA (CONSELHEIRO LAFAIETE) - INEP: 305235
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305235' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO POTÊNCIA' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305235');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PROFESSORA ELI MARQUES (CONSELHEIRO LAFAIETE) - INEP: 196185
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196185' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PROFESSORA ELI MARQUES' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196185');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO QUELUZ DE MINAS (CONSELHEIRO LAFAIETE) - INEP: 210595
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '210595' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO QUELUZ DE MINAS' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '210595');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SANTA RITA-FASAR (CONSELHEIRO LAFAIETE) - INEP: 321745
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '321745' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SANTA RITA-FASAR' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '321745');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA DE SAÚDE (CONSELHEIRO LAFAIETE) - INEP: 318035
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '318035' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA DE SAÚDE' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '318035');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MARGARIDA REZENDE (CONSELHEIRO LAFAIETE) - INEP: 339989
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339989' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MARGARIDA REZENDE' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339989');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP DE CONSELHEIRO LAFAIETE (CONSELHEIRO LAFAIETE) - INEP: 359823
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '359823' 
    WHERE UPPER(TRIM(name)) = 'SENAC - UNIDADE DE ENSINO TÉCNICO DO CEP DE CONSELHEIRO LAFAIETE' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '359823');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- UNIDADE DE ENSINO MORAIS (CONSELHEIRO LAFAIETE) - INEP: 365483
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '365483' 
    WHERE UPPER(TRIM(name)) = 'UNIDADE DE ENSINO MORAIS' 
      AND UPPER(TRIM(city)) = 'CONSELHEIRO LAFAIETE' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '365483');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO TÉCNICO PROFISSIONAL DE ENTRE RIOS DE MINAS (ENTRE RIOS DE MINAS) - INEP: 372404
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372404' 
    WHERE UPPER(TRIM(name)) = 'CENTRO TÉCNICO PROFISSIONAL DE ENTRE RIOS DE MINAS' 
      AND UPPER(TRIM(city)) = 'ENTRE RIOS DE MINAS' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372404');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ARQUIDIOCESANO (OURO BRANCO) - INEP: 230871
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230871' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ARQUIDIOCESANO' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230871');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA MINEIRO (OURO BRANCO) - INEP: 196312
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '196312' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA MINEIRO' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '196312');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO PIO XII COOPPED UNIDADE I (OURO BRANCO) - INEP: 305987
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '305987' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO PIO XII COOPPED UNIDADE I' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '305987');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI OURO BRANCO CENTRO DE FORMAÇÃO PROFISSIONAL (OURO BRANCO) - INEP: 358118
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '358118' 
    WHERE UPPER(TRIM(name)) = 'SENAI OURO BRANCO CENTRO DE FORMAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'OURO BRANCO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '358118');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- AMPLIAR INSTITUTO DE EDUCAÇÃO (CORONEL FABRICIANO) - INEP: 326305
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '326305' 
    WHERE UPPER(TRIM(name)) = 'AMPLIAR INSTITUTO DE EDUCAÇÃO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '326305');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- C EDUC ANJO DA GUARDA (CORONEL FABRICIANO) - INEP: 266701
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '266701' 
    WHERE UPPER(TRIM(name)) = 'C EDUC ANJO DA GUARDA' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '266701');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- C EDUC SOUZA RIBEIRO (CORONEL FABRICIANO) - INEP: 240320
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '240320' 
    WHERE UPPER(TRIM(name)) = 'C EDUC SOUZA RIBEIRO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '240320');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEPSMA- COLÉGIO E CENTRO DE PESQUISA SOUZA MARTINS (CORONEL FABRICIANO) - INEP: 238180
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '238180' 
    WHERE UPPER(TRIM(name)) = 'CEPSMA- COLÉGIO E CENTRO DE PESQUISA SOUZA MARTINS' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '238180');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ANGÉLICA (CORONEL FABRICIANO) - INEP: 192996
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '192996' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ANGÉLICA' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '192996');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO CATÓLICA PADRE DE MAN (CORONEL FABRICIANO) - INEP: 193038
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193038' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO CATÓLICA PADRE DE MAN' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193038');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JOÃO CALVINO (CORONEL FABRICIANO) - INEP: 193020
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193020' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JOÃO CALVINO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193020');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLMINAS - COLÉGIO TÉCNICO DO LESTE MINEIRO (CORONEL FABRICIANO) - INEP: 339415
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '339415' 
    WHERE UPPER(TRIM(name)) = 'COLMINAS - COLÉGIO TÉCNICO DO LESTE MINEIRO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '339415');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ETHOS INSTITUTO DE EDUCAÇAO (CORONEL FABRICIANO) - INEP: 254096
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254096' 
    WHERE UPPER(TRIM(name)) = 'ETHOS INSTITUTO DE EDUCAÇAO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254096');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC- UNIDADE DE ENSINO TÉCNICO - CFP VALE DO AÇO (CORONEL FABRICIANO) - INEP: 325279
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '325279' 
    WHERE UPPER(TRIM(name)) = 'SENAC- UNIDADE DE ENSINO TÉCNICO - CFP VALE DO AÇO' 
      AND UPPER(TRIM(city)) = 'CORONEL FABRICIANO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '325279');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


--  FIBONACCI COLÉGIO (IPATINGA) - INEP: 349720
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '349720' 
    WHERE UPPER(TRIM(name)) = 'FIBONACCI COLÉGIO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '349720');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CEST - COLÉGIO EDUCACIONAL DE SUPLÊNCIA E TÉCNICO (IPATINGA) - INEP: 261581
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261581' 
    WHERE UPPER(TRIM(name)) = 'CEST - COLÉGIO EDUCACIONAL DE SUPLÊNCIA E TÉCNICO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261581');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO ADVENTISTA DE IPATINGA (IPATINGA) - INEP: 261564
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '261564' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO ADVENTISTA DE IPATINGA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '261564');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO BATISTA DE IPATINGA (IPATINGA) - INEP: 251763
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '251763' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO BATISTA DE IPATINGA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '251763');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO JOHN WESLEY (IPATINGA) - INEP: 193071
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193071' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO JOHN WESLEY' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193071');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO FRANCISCO XAVIER (IPATINGA) - INEP: 193097
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193097' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO FRANCISCO XAVIER' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193097');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SÃO FRANCISCO XAVIER - UNIDADE II (IPATINGA) - INEP: 220159
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '220159' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SÃO FRANCISCO XAVIER - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '220159');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO SEMEAR (IPATINGA) - INEP: 310018
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310018' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO SEMEAR' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310018');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EICA ESCOLA CANTINHO DA ALEGRIA (IPATINGA) - INEP: 344125
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '344125' 
    WHERE UPPER(TRIM(name)) = 'EICA ESCOLA CANTINHO DA ALEGRIA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '344125');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA CRIAR E APRENDER (IPATINGA) - INEP: 303381
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '303381' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA CRIAR E APRENDER' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '303381');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA EDUCAÇÃO CRIATIVA (IPATINGA) - INEP: 193216
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193216' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA EDUCAÇÃO CRIATIVA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193216');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA ÉRICO VERÍSSIMO (IPATINGA) - INEP: 193151
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193151' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA ÉRICO VERÍSSIMO' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193151');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA PRÓ IMAGEM EDUCAÇÃO PROFISSIONAL (IPATINGA) - INEP: 310034
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '310034' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA PRÓ IMAGEM EDUCAÇÃO PROFISSIONAL' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '310034');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI RINALDO CAMPOS SOARES (IPATINGA) - INEP: 357081
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '357081' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI RINALDO CAMPOS SOARES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '357081');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA SESI SANTA RITA DE CÁSSIA (IPATINGA) - INEP: 230839
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '230839' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA SESI SANTA RITA DE CÁSSIA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '230839');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA TÉCNICA JUSCELINO KUBITSCHEK (IPATINGA) - INEP: 193089
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193089' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA TÉCNICA JUSCELINO KUBITSCHEK' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193089');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL MAYRINK VIEIRA (IPATINGA) - INEP: 193160
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193160' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL MAYRINK VIEIRA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193160');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL PEQUENOS GIGANTES (IPATINGA) - INEP: 343145
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '343145' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL PEQUENOS GIGANTES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '343145');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- INSTITUTO EDUCACIONAL PILAR (IPATINGA) - INEP: 269549
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '269549' 
    WHERE UPPER(TRIM(name)) = 'INSTITUTO EDUCACIONAL PILAR' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '269549');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- MONTESSORI SCHOOL (IPATINGA) - INEP: 374636
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '374636' 
    WHERE UPPER(TRIM(name)) = 'MONTESSORI SCHOOL' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '374636');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- READ - REDE DE ENSINO ASSEMBLEIA DE DEUS (IPATINGA) - INEP: 363316
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '363316' 
    WHERE UPPER(TRIM(name)) = 'READ - REDE DE ENSINO ASSEMBLEIA DE DEUS' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '363316');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAC UNIDADE DE ENSINO TÉCNICO- CFP IPATINGA (IPATINGA) - INEP: 341304
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '341304' 
    WHERE UPPER(TRIM(name)) = 'SENAC UNIDADE DE ENSINO TÉCNICO- CFP IPATINGA' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '341304');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- SENAI - CENTRO DE FORMAÇÃO PROFISSIONAL RINALDO CAMPOS SOARES (IPATINGA) - INEP: 340332
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '340332' 
    WHERE UPPER(TRIM(name)) = 'SENAI - CENTRO DE FORMAÇÃO PROFISSIONAL RINALDO CAMPOS SOARES' 
      AND UPPER(TRIM(city)) = 'IPATINGA' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '340332');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- CENTRO EDUCACIONAL CATÓLICA DO LESTE DE MINAS GERAIS - CECMG (TIMÓTEO) - INEP: 193313
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '193313' 
    WHERE UPPER(TRIM(name)) = 'CENTRO EDUCACIONAL CATÓLICA DO LESTE DE MINAS GERAIS - CECMG' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '193313');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GENOMA (TIMÓTEO) - INEP: 364517
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '364517' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GENOMA' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '364517');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- COLÉGIO GENOMA I (TIMÓTEO) - INEP: 372277
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '372277' 
    WHERE UPPER(TRIM(name)) = 'COLÉGIO GENOMA I' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '372277');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- EBA - ESCOLA BATISTA DE ACESITA - UNIDADE I (TIMÓTEO) - INEP: 254363
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '254363' 
    WHERE UPPER(TRIM(name)) = 'EBA - ESCOLA BATISTA DE ACESITA - UNIDADE I' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '254363');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


-- ESCOLA BATISTA DE ACESITA - EBA - UNIDADE II (TIMÓTEO) - INEP: 373796
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '373796' 
    WHERE UPPER(TRIM(name)) = 'ESCOLA BATISTA DE ACESITA - EBA - UNIDADE II' 
      AND UPPER(TRIM(city)) = 'TIMÓTEO' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '373796');
EXCEPTION 
    WHEN unique_violation THEN
        NULL;
END $$;


