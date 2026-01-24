-- ============================================================================
-- MIGRATION: Importação de Escolas de Minas Gerais (CORRIGIDO)
-- Date: 2024-01-24
-- Estrutura: id=UUID (auto), inep_code=TEXT, name=TEXT, city=TEXT, sre=TEXT
-- Total: 4014 escolas
-- ============================================================================

BEGIN;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '184381',
        'EE CORONEL JOSÉ VENÂNCIO DE SOUSA',
        'ÁGUAS VERMELHAS',
        'SRE ALMENARA'
    ),
(
        '184462',
        'EE DE ITAMARATI',
        'ÁGUAS VERMELHAS',
        'SRE ALMENARA'
    ),
(
        '184403',
        'EE DE MACHADO MINEIRO',
        'ÁGUAS VERMELHAS',
        'SRE ALMENARA'
    ),
(
        '184420',
        'EE JOAQUIM FERNANDES ABADE',
        'ÁGUAS VERMELHAS',
        'SRE ALMENARA'
    ),
(
        '184578',
        'CESEC QUERUBIM FRÓES OTONI',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '184527',
        'EE CONDE AFONSO CELSO',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '184608',
        'EE DE PEDRA GRANDE',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '246336',
        'EE JOEL MARES',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '184551',
        'EE JOVIANO NAVES',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '184543',
        'EE LAUDELINA DIAS LACERDA',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '184519',
        'EE TANCREDO NEVES',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '184632',
        'EE JOÃO DOS SANTOS AMARAL',
        'BANDEIRA',
        'SRE ALMENARA'
    ),
(
        '184616',
        'EE BARÃO DO RIO BRANCO',
        'CACHOEIRA DE PAJEÚ',
        'SRE ALMENARA'
    ),
(
        '246328',
        'EE DO CARIRI',
        'CACHOEIRA DE PAJEÚ',
        'SRE ALMENARA'
    ),
(
        '205613',
        'EE DO POVOADO DE ÁGUAS ALTAS',
        'CACHOEIRA DE PAJEÚ',
        'SRE ALMENARA'
    ),
(
        '184411',
        'EE DE MARISTELA',
        'CURRAL DE DENTRO',
        'SRE ALMENARA'
    ),
(
        '184446',
        'EE VERÍSSIMO TEIXEIRA COSTA',
        'CURRAL DE DENTRO',
        'SRE ALMENARA'
    ),
(
        '184454',
        'EE DE DIVISA ALEGRE',
        'DIVISA ALEGRE',
        'SRE ALMENARA'
    ),
(
        '184586',
        'EE ALBERTO VICENTE PEREIRA',
        'DIVISÓPOLIS',
        'SRE ALMENARA'
    ),
(
        '184691',
        'EE DE FELISBURGO',
        'FELISBURGO',
        'SRE ALMENARA'
    ),
(
        '184705',
        'EE TRANQUILINO PINTO COELHO',
        'FELISBURGO',
        'SRE ALMENARA'
    ),
(
        '184764',
        'EE ALÍPIO DE MORAES',
        'JACINTO',
        'SRE ALMENARA'
    ),
(
        '184799',
        'EE DO HAVAÍ',
        'JACINTO',
        'SRE ALMENARA'
    ),
(
        '184756',
        'EE PROFESSOR ESTÊVÃO ARAÚJO',
        'JACINTO',
        'SRE ALMENARA'
    ),
(
        '184969',
        'CESEC ZEMARIA DO NORTE',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '184977',
        'EE CORONEL JOÃO DA CUNHA',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '184837',
        'EE CORONEL RAMIRO PEREIRA',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '232084',
        'EE DOUTOR HENRIQUE HEITMANN',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '184942',
        'EE EPAMINONDAS RAMOS',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '185001',
        'EE PREFEITO EPAMINONDAS RAMOS',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '184900',
        'EE PROFESSOR MANUEL DO NORTE',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '184918',
        'EE SÃO MIGUEL',
        'JEQUITINHONHA',
        'SRE ALMENARA'
    ),
(
        '312126',
        'CESEC DE JOAÍMA',
        'JOAÍMA',
        'SRE ALMENARA'
    ),
(
        '185043',
        'EE DE GIRU',
        'JOAÍMA',
        'SRE ALMENARA'
    ),
(
        '185019',
        'EE PROFESSOR ANTÔNIO GOMES MOREIRA',
        'JOAÍMA',
        'SRE ALMENARA'
    ),
(
        '185051',
        'EE PROFESSOR MANOEL DO NORTE',
        'JOAÍMA',
        'SRE ALMENARA'
    ),
(
        '185078',
        'EE DE JORDÂNIA',
        'JORDÂNIA',
        'SRE ALMENARA'
    ),
(
        '185094',
        'EE DOM JOSÉ',
        'JORDÂNIA',
        'SRE ALMENARA'
    ),
(
        '185086',
        'EE FREI HENRIQUE DE COIMBRA',
        'JORDÂNIA',
        'SRE ALMENARA'
    ),
(
        '185116',
        'EE PROFESSOR MANOEL DA ROCHA PINTO',
        'JORDÂNIA',
        'SRE ALMENARA'
    ),
(
        '184594',
        'EE DE MATA VERDE',
        'MATA VERDE',
        'SRE ALMENARA'
    ),
(
        '209643',
        'EE JOSÉ FERREIRA DA ROCHA',
        'MATA VERDE',
        'SRE ALMENARA'
    ),
(
        '185035',
        'EE MANOEL DE SOUZA SANTOS',
        'MONTE FORMOSO',
        'SRE ALMENARA'
    ),
(
        '185329',
        'EE DOIS DE ABRIL',
        'PALMÓPOLIS',
        'SRE ALMENARA'
    ),
(
        '185353',
        'EE GOVERNADOR CLÓVIS SALGADO',
        'PALMÓPOLIS',
        'SRE ALMENARA'
    ),
(
        '311952',
        'CESEC EDIRALVA DE OLIVEIRA ALMEIDA',
        'PEDRA AZUL',
        'SRE ALMENARA'
    ),
(
        '185213',
        'EE ANA FARIA',
        'PEDRA AZUL',
        'SRE ALMENARA'
    ),
(
        '185205',
        'EE CASSIANO MENDES',
        'PEDRA AZUL',
        'SRE ALMENARA'
    ),
(
        '185221',
        'EE CORONEL PACÍFICO FARIA',
        'PEDRA AZUL',
        'SRE ALMENARA'
    ),
(
        '212831',
        'EE DEPUTADO JOÃO DE ALMEIDA',
        'PEDRA AZUL',
        'SRE ALMENARA'
    ),
(
        '353558',
        'EE GENI MARIA DE SOUZA',
        'RIO DO PRADO',
        'SRE ALMENARA'
    ),
(
        '185302',
        'EE PROFESSOR CLEMENTE TRINDADE',
        'RIO DO PRADO',
        'SRE ALMENARA'
    ),
(
        '245160',
        'EE TEREZINHA PORTO FAGUNDES',
        'RIO DO PRADO',
        'SRE ALMENARA'
    ),
(
        '185396',
        'EE LÍDIO ALMEIDA',
        'RUBIM',
        'SRE ALMENARA'
    ),
(
        '185388',
        'EE WALMIR ALMEIDA COSTA',
        'RUBIM',
        'SRE ALMENARA'
    ),
(
        '185400',
        'EE CORONEL ELPÍDIO ALVES FERREIRA',
        'SALTO DA DIVISA',
        'SRE ALMENARA'
    ),
(
        '185418',
        'EE CORONEL TINÔ',
        'SALTO DA DIVISA',
        'SRE ALMENARA'
    ),
(
        '185442',
        'EE JOSÉ JOAQUIM CABRAL',
        'SANTA MARIA DO SALTO',
        'SRE ALMENARA'
    ),
(
        '185451',
        'EE CLEMENTE DA ROCHA BANDEIRA',
        'SANTO ANTÔNIO DO JACINTO',
        'SRE ALMENARA'
    ),
(
        '185469',
        'EE DE CATAJÁS',
        'SANTO ANTÔNIO DO JACINTO',
        'SRE ALMENARA'
    ),
(
        '246301',
        'EE DO POVOADO DE CRISTIANÓPOLIS',
        'SANTO ANTÔNIO DO JACINTO',
        'SRE ALMENARA'
    ),
(
        '218324',
        'EE JOÃO VIEIRA DE SOUZA',
        'SANTO ANTÔNIO DO JACINTO',
        'SRE ALMENARA'
    ),
(
        '146005',
        'EE ARTHUR BERGANHOLI',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146013',
        'EE BOM JESUS DE AGUADA NOVA',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146048',
        'EE DA FAZENDA DIAMANTINO',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146081',
        'EE DOM JOSÉ DE HAAS',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '247707',
        'EE FREI ROGATO',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146161',
        'EE HILÁRIO PINHEIRO JARDIM',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146099',
        'EE INDUSTRIAL SÃO JOSÉ',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146102',
        'EE ISALTINA CAJUBI FULGÊNCIO',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146170',
        'EE JOSÉ DOS SANTOS NEIVA',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '146129',
        'EE PROFESSOR LEOPOLDO PEREIRA',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '145998',
        'EE PROFESSORA APARECIDA DUTRA',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '330809',
        'EE TEREZINHA GONÇALVES DOS SANTOS',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '23230',
        'CESEC SÃO GERALDO',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '330655',
        'EE DE BERILO',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '23132',
        'EE DE LELIVÉLDIA',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '23159',
        'EE HERMANO JOSÉ',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '23124',
        'EE NOSSA SENHORA APARECIDA',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '23167',
        'EE PROFESSOR JASON DE MORAIS',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '23183',
        'EE RIBEIRÃO DO ALTAR',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '23191',
        'EE SANTO ISIDORO',
        'BERILO',
        'SRE ARAÇUAÍ'
    ),
(
        '82899',
        'EE CONRADO VERÍSSIMO DE OLIVEIRA',
        'BERIZAL',
        'SRE ARAÇUAÍ'
    ),
(
        '82902',
        'EE JOÃO ÁLVARO BAHIA',
        'BERIZAL',
        'SRE ARAÇUAÍ'
    ),
(
        '338729',
        'EE ANTÔNIO MARQUES DE ABREU',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23396',
        'EE INHÔ FIGUEIREDO',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23388',
        'EE JOSÉ RODRIGUES FIGUEIREDO',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23434',
        'EE MONSENHOR MENDES',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23442',
        'EE OLÍDIA LEMOS DE OLIVEIRA',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23400',
        'EE PROFESSOR GERALDO WILSON BENÍCIO',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23426',
        'EE PROFESSORA MARIA GOMES DA SILVA',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '23418',
        'EE ZÉ DE CALU',
        'CHAPADA DO NORTE',
        'SRE ARAÇUAÍ'
    ),
(
        '184641',
        'EE ALPHONSUS DE GUIMARÃES',
        'COMERCINHO',
        'SRE ARAÇUAÍ'
    ),
(
        '184667',
        'EE FERNANDO DA COSTA AMARAL',
        'COMERCINHO',
        'SRE ARAÇUAÍ'
    ),
(
        '146676',
        'EE ARTHUR ANTÔNIO FERNANDES',
        'CORONEL MURTA',
        'SRE ARAÇUAÍ'
    ),
(
        '146650',
        'EE CORONEL MARIANO MURTA',
        'CORONEL MURTA',
        'SRE ARAÇUAÍ'
    ),
(
        '24082',
        'CESEC FRANCISCO BORGES DE SOUZA',
        'FRANCISCO BADARÓ',
        'SRE ARAÇUAÍ'
    ),
(
        '24031',
        'EE CÔNEGO FIGUEIRÓ',
        'FRANCISCO BADARÓ',
        'SRE ARAÇUAÍ'
    ),
(
        '24074',
        'EE PRESIDENTE JUSCELINO KUBITSCHEK',
        'FRANCISCO BADARÓ',
        'SRE ARAÇUAÍ'
    ),
(
        '24040',
        'EE SÃO SEBASTIÃO',
        'FRANCISCO BADARÓ',
        'SRE ARAÇUAÍ'
    ),
(
        '82511',
        'EE ANÍBAL GONÇALVES DAS NEVES',
        'FRUTA DE LEITE',
        'SRE ARAÇUAÍ'
    ),
(
        '276898',
        'EE ANTÔNIO MIRANDA',
        'INDAIABIRA',
        'SRE ARAÇUAÍ'
    ),
(
        '82252',
        'EE JOÃO CALDEIRA',
        'INDAIABIRA',
        'SRE ARAÇUAÍ'
    ),
(
        '82261',
        'EE JOAQUIM VIEIRA',
        'INDAIABIRA',
        'SRE ARAÇUAÍ'
    ),
(
        '146889',
        'EE CHAVES RIBEIRO',
        'ITAOBIM',
        'SRE ARAÇUAÍ'
    ),
(
        '146897',
        'EE DE ITAOBIM',
        'ITAOBIM',
        'SRE ARAÇUAÍ'
    ),
(
        '146901',
        'EE IRMÃOS FERNANDES',
        'ITAOBIM',
        'SRE ARAÇUAÍ'
    ),
(
        '310271',
        'EE PROFESSORA DEYS LOPES JARDIM',
        'ITAOBIM',
        'SRE ARAÇUAÍ'
    ),
(
        '146951',
        'EE COMENDADOR MURTA',
        'ITINGA',
        'SRE ARAÇUAÍ'
    ),
(
        '322504',
        'EE DE ITINGA',
        'ITINGA',
        'SRE ARAÇUAÍ'
    ),
(
        '146978',
        'EE DO POVOADO DE TAQUARAL',
        'ITINGA',
        'SRE ARAÇUAÍ'
    ),
(
        '146986',
        'EE MANOEL DA SILVA GUSMÃO',
        'ITINGA',
        'SRE ARAÇUAÍ'
    ),
(
        '330621',
        'EE ANTÔNIO RAMALHO MOTA',
        'JENIPAPO DE MINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '24091',
        'EE NOSSA SENHORA DE FÁTIMA',
        'JENIPAPO DE MINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '330612',
        'EE PADRE WILLY',
        'JENIPAPO DE MINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '23248',
        'EE DOUTOR TANCREDO NEVES',
        'JOSÉ GONÇALVES DE MINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '23094',
        'EE JOÃO MOTOSO FILHO',
        'JOSÉ GONÇALVES DE MINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '311944',
        'CESEC NANETE ANTUNES GUIMARÃES',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '185175',
        'EE ANÍBAL MELO',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '185191',
        'EE DOUTOR MAX MACHADO',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '185183',
        'EE JOÃO FRANCISCO COSTA',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '185159',
        'EE LUIZ TANURE',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '185124',
        'EE MONSENHOR MANOEL',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '185167',
        'EE PROFESSOR QUERUBIM CIRINO DE MATOS',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '349259',
        'EE DAVID FERRAZ DE OLIVEIRA',
        'NINHEIRA',
        'SRE ARAÇUAÍ'
    ),
(
        '82759',
        'EE DE NINHEIRA',
        'NINHEIRA',
        'SRE ARAÇUAÍ'
    ),
(
        '338737',
        'EE PROFESSOR MARCIONILO PEREIRA DUTRA',
        'NINHEIRA',
        'SRE ARAÇUAÍ'
    ),
(
        '82589',
        'EE JOÃO BERNARDINO DE SOUZA',
        'NOVORIZONTE',
        'SRE ARAÇUAÍ'
    ),
(
        '82422',
        'EE DO POVOADO LAGOA DE BAIXO',
        'RUBELITA',
        'SRE ARAÇUAÍ'
    ),
(
        '82414',
        'EE LEÔNIDAS ALVES RIBEIRO',
        'RUBELITA',
        'SRE ARAÇUAÍ'
    ),
(
        '92631',
        'EE RUI BARBOSA',
        'RUBELITA',
        'SRE ARAÇUAÍ'
    ),
(
        '82457',
        'EE CORONEL IDALINO RIBEIRO',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '218189',
        'EE DOUTOR OSVALDO PREDILIANO SANT''ANA',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82562',
        'EE JOÃO JOSÉ FERREIRA',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82554',
        'EE MANOEL PEDRO SILVA',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82503',
        'EE PROFESSOR ELÍDIO DUQUE',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82431',
        'EE PROFESSOR JOSÉ MIRANDA',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82490',
        'EE PROFESSOR LEVINDO LAMBERT',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '342807',
        'EE VICENTE JOSÉ FERREIRA',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '361674',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'SANTA CRUZ DE SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82571',
        'EE TENENTE FELISMINO HENRIQUES DE SOUZA',
        'SANTA CRUZ DE SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82830',
        'EE DONA BETI',
        'TAIOBEIRAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82864',
        'EE DOUTOR JOSÉ AMERICANO MENDES',
        'TAIOBEIRAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82856',
        'EE OSWALDO LUCAS MENDES',
        'TAIOBEIRAS',
        'SRE ARAÇUAÍ'
    ),
(
        '82872',
        'EE PRESIDENTE TANCREDO NEVES',
        'TAIOBEIRAS',
        'SRE ARAÇUAÍ'
    ),
(
        '148474',
        'EE CATULO CEARENSE',
        'VIRGEM DA LAPA',
        'SRE ARAÇUAÍ'
    ),
(
        '148521',
        'EE NOSSA SENHORA DA LAPA',
        'VIRGEM DA LAPA',
        'SRE ARAÇUAÍ'
    ),
(
        '148482',
        'EE OLEGÁRIO MACIEL',
        'VIRGEM DA LAPA',
        'SRE ARAÇUAÍ'
    ),
(
        '148491',
        'EE SÃO DOMINGOS',
        'VIRGEM DA LAPA',
        'SRE ARAÇUAÍ'
    ),
(
        '148504',
        'EE SÃO JOÃO DO VACARIA',
        'VIRGEM DA LAPA',
        'SRE ARAÇUAÍ'
    ),
(
        '148512',
        'EE VALDOMIRO SILVA COSTA',
        'VIRGEM DA LAPA',
        'SRE ARAÇUAÍ'
    ),
(
        '16012',
        'EE NOSSA SENHORA DO ROSÁRIO',
        'ALFREDO VASCONCELOS',
        'SRE BARBACENA'
    ),
(
        '14699',
        'EE ANTONINO TEIXEIRA DE CARVALHO',
        'ALTO RIO DOCE',
        'SRE BARBACENA'
    ),
(
        '14737',
        'EE DOUTOR JOSÉ OTÁVIO COUTO MOTA',
        'ALTO RIO DOCE',
        'SRE BARBACENA'
    ),
(
        '14681',
        'EE SÃO JOSÉ',
        'ALTO RIO DOCE',
        'SRE BARBACENA'
    ),
(
        '14842',
        'EE VISCONDE DE ARANTES',
        'ANDRELÂNDIA',
        'SRE BARBACENA'
    ),
(
        '14923',
        'EE JOSÉ GONÇALVES DE ARAÚJO',
        'ANTÔNIO CARLOS',
        'SRE BARBACENA'
    ),
(
        '239372',
        'EE LIMA DUARTE',
        'ANTÔNIO CARLOS',
        'SRE BARBACENA'
    ),
(
        '14974',
        'EE SENADOR ANTÔNIO CARLOS',
        'ANTÔNIO CARLOS',
        'SRE BARBACENA'
    ),
(
        '14991',
        'EE CORONEL FRANCISCO HOMEM',
        'ARACITABA',
        'SRE BARBACENA'
    ),
(
        '15024',
        'EE ADELAÍDE BIAS FORTES',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15032',
        'EE AMÍLCAR SAVASSI',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15041',
        'EE BIAS FORTES',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '356905',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '273376',
        'EE DEPUTADO JOSÉ BONIFÁCIO LAFAYETTE DE ANDRADA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15067',
        'EE DOUTOR ALBERTO VIEIRA PEREIRA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15091',
        'EE DOUTOR TEOBALDO TOLLENDAL',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15105',
        'EE EMBAIXADOR JOSÉ BONIFÁCIO',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15113',
        'EE GABRIELA RIBEIRO ANDRADA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15121',
        'EE HENRIQUE DINIZ',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15199',
        'EE PADRE MESTRE CORRÊA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15211',
        'EE PIO XI',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15059',
        'EE PROFESSOR JOÃO ANASTÁCIO',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15229',
        'EE PROFESSOR SOARES FERREIRA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15237',
        'EE SÃO MIGUEL',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '302627',
        'EE SENHORA DAS DORES',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '15334',
        'EE CÔNEGO LUIZ GIAROLA CARLOS',
        'BARROSO',
        'SRE BARBACENA'
    ),
(
        '15318',
        'EE FRANCISCO ANTÔNIO PIRES',
        'BARROSO',
        'SRE BARBACENA'
    ),
(
        '15300',
        'EE GENERAL SILVANO ALBERTONI',
        'BARROSO',
        'SRE BARBACENA'
    ),
(
        '15296',
        'EE PREFEITO GERALDO NAPOLEÃO DE SOUZA',
        'BARROSO',
        'SRE BARBACENA'
    ),
(
        '15342',
        'EE CISIPHO CAMPOS',
        'BIAS FORTES',
        'SRE BARBACENA'
    ),
(
        '15377',
        'EE CHIQUINHO DE PAIVA',
        'CAPELA NOVA',
        'SRE BARBACENA'
    ),
(
        '15491',
        'EE DEPUTADO PATRUS DE SOUSA',
        'CARANDAÍ',
        'SRE BARBACENA'
    ),
(
        '15521',
        'EE FRANCISCO DO CARMO',
        'CARANDAÍ',
        'SRE BARBACENA'
    ),
(
        '15571',
        'EE PREFEITO GENTIL PEREIRA LIMA',
        'CARANDAÍ',
        'SRE BARBACENA'
    ),
(
        '15644',
        'EE JOSÉ DIAS PEDROSA',
        'CIPOTÂNEA',
        'SRE BARBACENA'
    ),
(
        '15652',
        'EE PROFESSOR JAIME CALMETO',
        'DESTERRO DO MELO',
        'SRE BARBACENA'
    ),
(
        '15679',
        'EE SANTO ANTONIO',
        'IBERTIOGA',
        'SRE BARBACENA'
    ),
(
        '15725',
        'EE SOUSA LEITE',
        'MADRE DE DEUS DE MINAS',
        'SRE BARBACENA'
    ),
(
        '15822',
        'EE SENA FIGUEIREDO',
        'MERCÊS',
        'SRE BARBACENA'
    ),
(
        '338664',
        'EE RUBEM ESTEVES RUFFO',
        'OLIVEIRA FORTES',
        'SRE BARBACENA'
    ),
(
        '15873',
        'EE SANTA ROSA',
        'PAIVA',
        'SRE BARBACENA'
    ),
(
        '248479',
        'EE DOUTOR ANTÔNIO BATISTA DO NASCIMENTO',
        'PIEDADE DO RIO GRANDE',
        'SRE BARBACENA'
    ),
(
        '15989',
        'EE GALDINO ANANIAS DE SANTANA',
        'RESSAQUINHA',
        'SRE BARBACENA'
    ),
(
        '16039',
        'EE JUSCELINO BENEDITO DE ARAÚJO',
        'SANTA BÁRBARA DO TUGÚRIO',
        'SRE BARBACENA'
    ),
(
        '16098',
        'EE ZEQUINHA DE PAULA',
        'SANTA RITA DE IBITIPOCA',
        'SRE BARBACENA'
    ),
(
        '16063',
        'EE JOSÉ DE OLIVEIRA',
        'SANTANA DO GARAMBÉU',
        'SRE BARBACENA'
    ),
(
        '16209',
        'EE JOSÉ BONIFÁCIO',
        'SÃO VICENTE DE MINAS',
        'SRE BARBACENA'
    ),
(
        '16217',
        'EE GOVERNADOR MAGALHÃES PINTO',
        'SENHORA DOS REMÉDIOS',
        'SRE BARBACENA'
    ),
(
        '255611',
        'EE PADRE EGYDIO REIS',
        'SENHORA DOS REMÉDIOS',
        'SRE BARBACENA'
    ),
(
        '16225',
        'EE PREFEITO JOSÉ PAULO DE ASSIS',
        'SENHORA DOS REMÉDIOS',
        'SRE BARBACENA'
    ),
(
        '16250',
        'EE URQUIZA DINIZ CHAGAS',
        'SENHORA DOS REMÉDIOS',
        'SRE BARBACENA'
    ),
(
        '202134',
        'EE PROFESSOR LEONIDES ALVARENGA',
        'AGUANIL',
        'SRE CAMPO BELO'
    ),
(
        '202177',
        'EE NÉLSON FERNANDES FRIAÇA',
        'CAMACHO',
        'SRE CAMPO BELO'
    ),
(
        '305219',
        'CESEC PROFESSOR JOÃO DE OLIVEIRA  BARBOSA',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202185',
        'EE ABÍLIO NEVES',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202304',
        'EE JARBAS GAMBOGI',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202355',
        'EE MARIA BAUAB GIBRAM',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202321',
        'EE MIGUEL ROGANA',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202193',
        'EE PADRE ALBERTO FUGER',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202339',
        'EE PROFESSOR JOSÉ MONTEIRO',
        'CAMPO BELO',
        'SRE CAMPO BELO'
    ),
(
        '202401',
        'EE DOUTOR JOSÉ ESTEVES DE ANDRADE BOTELHO',
        'CANA VERDE',
        'SRE CAMPO BELO'
    ),
(
        '202487',
        'EE PADRE AMÉRICO',
        'CANDEIAS',
        'SRE CAMPO BELO'
    ),
(
        '202495',
        'EE PRESIDENTE KENNEDY',
        'CANDEIAS',
        'SRE CAMPO BELO'
    ),
(
        '202665',
        'EE DOUTOR OSMAR BICALHO',
        'CRISTAIS',
        'SRE CAMPO BELO'
    ),
(
        '202894',
        'EE AZARIAS RIBEIRO',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '217743',
        'EE CINIRA CARVALHO',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '202908',
        'EE CRISTIANO DE SOUZA',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '202967',
        'EE DORA MATARAZZO',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '202975',
        'EE DOUTOR JOÃO BATISTA HERMETO',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '203009',
        'EE FIRMINO COSTA',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '203106',
        'EE TIRADENTES',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '203483',
        'EE CARMELITA CARVALHO GARCIA',
        'PERDÕES',
        'SRE CAMPO BELO'
    ),
(
        '203491',
        'EE ELVIRA LOPES RESENDE',
        'PERDÕES',
        'SRE CAMPO BELO'
    ),
(
        '203441',
        'EE JOÃO MELO GOMIDE',
        'PERDÕES',
        'SRE CAMPO BELO'
    ),
(
        '203475',
        'EE PROFESSOR GETÚLIO JOSÉ SOARES',
        'PERDÕES',
        'SRE CAMPO BELO'
    ),
(
        '203521',
        'EE ANTÔNIO NOVAIS',
        'RIBEIRÃO VERMELHO',
        'SRE CAMPO BELO'
    ),
(
        '203530',
        'EE CARMELITA CARVALHO GARCIA',
        'SANTANA DO JACARÉ',
        'SRE CAMPO BELO'
    ),
(
        '134473',
        'EE ALBERICO FERREIRA NAVES',
        'SANTO ANTÔNIO DO AMPARO',
        'SRE CAMPO BELO'
    ),
(
        '134490',
        'EE DOUTOR CÍCERO FERREIRA',
        'SANTO ANTÔNIO DO AMPARO',
        'SRE CAMPO BELO'
    ),
(
        '134511',
        'EE NEWTON FERREIRA DE PAIVA',
        'SANTO ANTÔNIO DO AMPARO',
        'SRE CAMPO BELO'
    ),
(
        '203564',
        'EE CORONEL MÁRIO CAMPOS',
        'SÃO FRANCISCO DE PAULA',
        'SRE CAMPO BELO'
    ),
(
        '96792',
        'EE CORONEL AMÉRICO VESPÚCIO CARVALHO',
        'ALTO CAPARAÓ',
        'SRE CARANGOLA'
    ),
(
        '96750',
        'EE PREFEITO JAYME TOLEDO',
        'CAIANA',
        'SRE CARANGOLA'
    ),
(
        '96784',
        'EE PROFESSOR FRANCISCO LENTZ',
        'CAPARAÓ',
        'SRE CARANGOLA'
    ),
(
        '96920',
        'EE BENEDITO VALADARES',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '96806',
        'EE DE EDUCAÇÃO ESPECIAL WALTON BATALHA LIMA',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '96881',
        'EE DO BAIRRO SANTO ONOFRE',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '96890',
        'EE DOUTOR JONAS DE FARIA CASTRO',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '97012',
        'EE EMÍLIA ESTEVES MARQUES',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '96938',
        'EE JOÃO BELO DE OLIVEIRA',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '96971',
        'EE MELO VIANA',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '97039',
        'EE NASCIMENTO LEAL',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '97241',
        'EE PEDRO DE OLIVEIRA',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '96997',
        'EE PROFESSOR AUGUSTO AMARANTE',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '97551',
        'EE DOUTOR PEDRO PAULO NETO',
        'DIVINO',
        'SRE CARANGOLA'
    ),
(
        '97519',
        'EE MARLY DE CASTRO LIMA',
        'DIVINO',
        'SRE CARANGOLA'
    ),
(
        '97578',
        'EE MELO VIANA',
        'DIVINO',
        'SRE CARANGOLA'
    ),
(
        '97632',
        'EE VEREADOR JOSÉ DE SOUZA GOMES',
        'DIVINO',
        'SRE CARANGOLA'
    ),
(
        '97683',
        'EE ALTIVO LEOPOLDINO DE SOUZA',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '97675',
        'EE ERÊNIO DE SOUZA CASTRO',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '97764',
        'EE FAZENDA PARAÍSO',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '97705',
        'EE INTERVENTOR JÚLIO DE CARVALHO',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '97713',
        'EE PEDRO INÁCIO NOGUEIRA',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '97721',
        'EE SÃO SEBASTIÃO',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '98035',
        'EE SÃO MATEUS',
        'FARIA LEMOS',
        'SRE CARANGOLA'
    ),
(
        '97250',
        'EE BOM JESUS DO MADEIRA',
        'FERVEDOURO',
        'SRE CARANGOLA'
    ),
(
        '97179',
        'EE JOAQUIM BARTHOLOMEU PEDROSA',
        'FERVEDOURO',
        'SRE CARANGOLA'
    ),
(
        '351148',
        'EE MARIA ROSA DE FREITAS',
        'FERVEDOURO',
        'SRE CARANGOLA'
    ),
(
        '97292',
        'EE SÃO PEDRO DO GLÓRIA',
        'FERVEDOURO',
        'SRE CARANGOLA'
    ),
(
        '97641',
        'EE DOS DORNELAS',
        'ORIZÂNIA',
        'SRE CARANGOLA'
    ),
(
        '322652',
        'EE MARIA CONCEIÇÃO GONÇALVES CARRARA',
        'PEDRA DOURADA',
        'SRE CARANGOLA'
    ),
(
        '99546',
        'EE ANTÔNIA MARTINS DE BARROS',
        'TOMBOS',
        'SRE CARANGOLA'
    ),
(
        '99503',
        'EE ILKA CAMPOS VARGAS',
        'TOMBOS',
        'SRE CARANGOLA'
    ),
(
        '19046',
        'EE GOVERNADOR BIAS FORTES',
        'ALVARENGA',
        'SRE CARATINGA'
    ),
(
        '19135',
        'EE DONA NHANHÁ',
        'BOM JESUS DO GALHO',
        'SRE CARATINGA'
    ),
(
        '213314',
        'EE JOÃO PAULO II',
        'BOM JESUS DO GALHO',
        'SRE CARATINGA'
    ),
(
        '19101',
        'EE PADRE DIONÍSIO HOMEM DE FARIA',
        'BOM JESUS DO GALHO',
        'SRE CARATINGA'
    ),
(
        '19089',
        'EE PEDRO MARTINS PEREIRA',
        'BOM JESUS DO GALHO',
        'SRE CARATINGA'
    ),
(
        '19143',
        'EE PRESIDENTE ARTUR BERNARDES',
        'BOM JESUS DO GALHO',
        'SRE CARATINGA'
    ),
(
        '20397',
        'EE ANTÔNIO MARQUES',
        'BUGRE',
        'SRE CARATINGA'
    ),
(
        '20362',
        'EE JAIME MAFRA',
        'BUGRE',
        'SRE CARATINGA'
    ),
(
        '19275',
        'CESEC PROFESSOR CELSO SIMÕES CALDEIRA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19828',
        'EE ANTÔNIO PENNA SOBRINHO',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '20028',
        'EE CORONEL FLORENTINO MIRANDA COSTA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19283',
        'EE DEPUTADO AGENOR LUDGERO ALVES',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19321',
        'EE ENGENHEIRO CALDAS',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '353450',
        'EE FELICIANO MIGUEL ABDALLA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19364',
        'EE ISABEL VIEIRA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19941',
        'EE JOÃO MOREIRA FRANCO',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19372',
        'EE JOSÉ AUGUSTO FERREIRA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19526',
        'EE JOSÉ FERREIRA MENDES',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19381',
        'EE JUAREZ CANUTO DE SOUZA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '20176',
        'EE MANOEL CORDEIRO LÚCIO',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19763',
        'EE MARIA ALVES DA SILVEIRA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19151',
        'EE MARIA JÚLIA DE MATTOS',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '20010',
        'EE MARY LUCCA CHAGAS',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19453',
        'EE MAURÍLIO SENRA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '253855',
        'EE MOACYR DE MATTOS',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19178',
        'EE PRINCESA ISABEL',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '218766',
        'EE PROFESSOR JOAQUIM NUNES',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19780',
        'EE PROFESSORA MARIA FONTES',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19216',
        'EE SINFRÔNIO FERNANDES',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '20001',
        'EE SUDÁRIO ALVES PEREIRA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '19291',
        'EE VENCESLAU JOSÉ DA SILVA',
        'CARATINGA',
        'SRE CARATINGA'
    ),
(
        '20265',
        'EE PRESIDENTE TANCREDO DE ALMEIDA NEVES',
        'CÓRREGO NOVO',
        'SRE CARATINGA'
    ),
(
        '20303',
        'EE PROFESSORA ILMA DE LANA E CALDEIRA',
        'DOM CAVATI',
        'SRE CARATINGA'
    ),
(
        '19534',
        'EE DOUTOR JOSÉ AUGUSTO',
        'ENTRE FOLHAS',
        'SRE CARATINGA'
    ),
(
        '20401',
        'EE DURVAL MADALENA',
        'IAPU',
        'SRE CARATINGA'
    ),
(
        '20354',
        'EE FREI MARCELINO DE MILÃO',
        'IAPU',
        'SRE CARATINGA'
    ),
(
        '19615',
        'EE MANOEL JOAQUIM TEODORO',
        'IMBÉ DE MINAS',
        'SRE CARATINGA'
    ),
(
        '20419',
        'EE ALBERTO AZEVEDO',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20567',
        'EE DOUTOR GUILHERMINO DE OLIVEIRA',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20699',
        'EE EUCLIDES PINTO DE OLIVEIRA',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20460',
        'EE JOÃO DE ALMEIDA PIMENTEL',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20486',
        'EE JOAQUIM FRANCISCO XAVIER',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20591',
        'EE JOSÉ CHAGAS',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20613',
        'EE JOSÉ FRANCISCO DE PAIVA CAMPOS',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20621',
        'EE MANOEL GONÇALVES LEITE',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20541',
        'EE PEDRO CARLOS DA CRUZ',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '20494',
        'EE QUEROBINO MARQUES DE OLIVEIRA',
        'INHAPIM',
        'SRE CARATINGA'
    ),
(
        '268879',
        'EE DÊNIO MOREIRA DE CARVALHO',
        'IPABA',
        'SRE CARATINGA'
    ),
(
        '19909',
        'EE EMÍLIA CABRAL MOTA',
        'IPABA',
        'SRE CARATINGA'
    ),
(
        '19674',
        'EE GERSON GOMES DE ALMEIDA',
        'IPABA',
        'SRE CARATINGA'
    ),
(
        '19666',
        'EE JAIDER GOMES DA SILVA',
        'IPABA',
        'SRE CARATINGA'
    ),
(
        '19658',
        'EE MANOEL MACHADO FRANCO',
        'IPABA',
        'SRE CARATINGA'
    ),
(
        '310581',
        'CESEC MARIA CECÍLIA DE MOURA',
        'IPANEMA',
        'SRE CARATINGA'
    ),
(
        '20729',
        'EE CORONEL CALHAU',
        'IPANEMA',
        'SRE CARATINGA'
    ),
(
        '20737',
        'EE NILO MORAIS PINHEIRO',
        'IPANEMA',
        'SRE CARATINGA'
    ),
(
        '19267',
        'EE FREI CARLOS',
        'PIEDADE DE CARATINGA',
        'SRE CARATINGA'
    ),
(
        '213306',
        'EE PROFESSORA DINALVA MARIA DE SOUZA',
        'PINGO-D''ÁGUA',
        'SRE CARATINGA'
    ),
(
        '20770',
        'EE ANITA GARIBALDI',
        'POCRANE',
        'SRE CARATINGA'
    ),
(
        '20796',
        'EE DOMINGOS CARELLOS',
        'POCRANE',
        'SRE CARATINGA'
    ),
(
        '20788',
        'EE EDIR DE OLIVEIRA E SILVA',
        'POCRANE',
        'SRE CARATINGA'
    ),
(
        '20818',
        'EE LEANIR DE ASSIS MAGALHÃES',
        'POCRANE',
        'SRE CARATINGA'
    ),
(
        '19747',
        'EE MONSENHOR ROCHA',
        'SANTA BÁRBARA DO LESTE',
        'SRE CARATINGA'
    ),
(
        '19798',
        'EE JOSEFINA VIEIRA',
        'SANTA RITA DE MINAS',
        'SRE CARATINGA'
    ),
(
        '20656',
        'EE ALAIDE DORNELAS NEPOMUCENO',
        'SÃO DOMINGOS DAS DORES',
        'SRE CARATINGA'
    ),
(
        '20851',
        'EE PADRE FRANCISCO WEBER',
        'SÃO JOÃO DO ORIENTE',
        'SRE CARATINGA'
    ),
(
        '20869',
        'EE VITALINO DE OLIVEIRA RUELA',
        'SÃO JOÃO DO ORIENTE',
        'SRE CARATINGA'
    ),
(
        '20664',
        'EE PROFESSOR ILÍDIO ALVES DE CARVALHO',
        'SÃO SEBASTIÃO DO ANTA',
        'SRE CARATINGA'
    ),
(
        '20753',
        'EE ORLANDO ALVES PEREIRA',
        'TAPARUBA',
        'SRE CARATINGA'
    ),
(
        '20923',
        'EE ALACRINO PEDRO DA COSTA',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '21016',
        'EE BENEDITO QUINTINO DOS SANTOS',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '20974',
        'EE ENGENHEIRO AMARO FERREIRA',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '21083',
        'EE FRANCISCA HILÁRIA DA SILVA',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '20982',
        'EE MANOEL JOAQUIM DE ANDRADE',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '21091',
        'EE OLEGÁRIO MACIEL',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '21105',
        'EE PIMENTA DA VEIGA',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '20907',
        'EE PROFESSORA MARIA TEIXEIRA DA FONSECA',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '20991',
        'EE RUI BARBOSA',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '21008',
        'EE SINFRÔNIO BONFIM',
        'TARUMIRIM',
        'SRE CARATINGA'
    ),
(
        '20052',
        'EE CESARINO ALVES PEREIRA',
        'UBAPORANGA',
        'SRE CARATINGA'
    ),
(
        '20079',
        'EE DOM CAVATI',
        'UBAPORANGA',
        'SRE CARATINGA'
    ),
(
        '20109',
        'EE FRANCISCA RODRIGUES VALENTE',
        'UBAPORANGA',
        'SRE CARATINGA'
    ),
(
        '20117',
        'EE JOSÉ ANTUNES MOREIRA',
        'UBAPORANGA',
        'SRE CARATINGA'
    ),
(
        '20214',
        'EE REVERENDO BOANERGES DE ALMEIDA LEITÃO',
        'VARGEM ALEGRE',
        'SRE CARATINGA'
    ),
(
        '170682',
        'EE CONSELHEIRO FIDÉLIS',
        'AIURUOCA',
        'SRE CAXAMBU'
    ),
(
        '276464',
        'EE MARIA DO CARMO LIMA PINTO',
        'ALAGOA',
        'SRE CAXAMBU'
    ),
(
        '171026',
        'EE ANÍSIO ESAÚ DOS SANTOS',
        'BAEPENDI',
        'SRE CAXAMBU'
    ),
(
        '170984',
        'EE JOAQUIM ALVARENGA MACIEL',
        'BAEPENDI',
        'SRE CAXAMBU'
    ),
(
        '171042',
        'EE NOSSA SENHORA DE MONTSERRAT',
        'BAEPENDI',
        'SRE CAXAMBU'
    ),
(
        '171051',
        'EE VARGEM DA LAGE',
        'BAEPENDI',
        'SRE CAXAMBU'
    ),
(
        '294667',
        'EE CÔNEGO JOÃO SEVERO',
        'BOCAINA DE MINAS',
        'SRE CAXAMBU'
    ),
(
        '68144',
        'EE ANA DANTAS MOTTA',
        'CARVALHOS',
        'SRE CAXAMBU'
    ),
(
        '311880',
        'EE CABO LUIZ DE QUEIROZ',
        'CAXAMBU',
        'SRE CAXAMBU'
    ),
(
        '172073',
        'EE DOMINGOS GONÇALVES DE MELLO MINGOTE',
        'CAXAMBU',
        'SRE CAXAMBU'
    ),
(
        '172081',
        'EE RUTH MARTINS DE ALMEIDA',
        'CAXAMBU',
        'SRE CAXAMBU'
    ),
(
        '172146',
        'EE DOM OTHON MOTTA',
        'CONCEIÇÃO DO RIO VERDE',
        'SRE CAXAMBU'
    ),
(
        '172120',
        'EE PADRE PEDRO RIBEIRO DE CASTRO',
        'CONCEIÇÃO DO RIO VERDE',
        'SRE CAXAMBU'
    ),
(
        '172448',
        'EE DONA LEONINA NUNES MACIEL',
        'CRUZÍLIA',
        'SRE CAXAMBU'
    ),
(
        '172456',
        'EE MONSENHOR JOÃO CÂNCIO',
        'CRUZÍLIA',
        'SRE CAXAMBU'
    ),
(
        '172464',
        'EE SÃO SEBASTIÃO',
        'CRUZÍLIA',
        'SRE CAXAMBU'
    ),
(
        '172847',
        'EE NILO PEÇANHA',
        'ITAMONTE',
        'SRE CAXAMBU'
    ),
(
        '172910',
        'EE DONA SEMIANA',
        'ITANHANDU',
        'SRE CAXAMBU'
    ),
(
        '172936',
        'EE PROFESSOR SOUZA NILO',
        'ITANHANDU',
        'SRE CAXAMBU'
    ),
(
        '172961',
        'EE JOÃO DE ALMEIDA LISBOA',
        'JESUÂNIA',
        'SRE CAXAMBU'
    ),
(
        '68969',
        'EE FREI JOSÉ WULFF',
        'LIBERDADE',
        'SRE CAXAMBU'
    ),
(
        '15857',
        'EE FERNANDO MELO VIANA',
        'MINDURI',
        'SRE CAXAMBU'
    ),
(
        '173487',
        'EE PROFESSORA MARIA ANTONIETA ROMANO SALGADO',
        'OLÍMPIO NORONHA',
        'SRE CAXAMBU'
    ),
(
        '173673',
        'EE CORONEL ARTUR TIBÚRCIO',
        'PASSA QUATRO',
        'SRE CAXAMBU'
    ),
(
        '173762',
        'EE NOSSA SENHORA APARECIDA',
        'PASSA QUATRO',
        'SRE CAXAMBU'
    ),
(
        '173789',
        'EE PRESIDENTE ROOSEVELT',
        'PASSA QUATRO',
        'SRE CAXAMBU'
    ),
(
        '173665',
        'EE PROFESSORA LOURDES CASTILHO FREITAS',
        'PASSA QUATRO',
        'SRE CAXAMBU'
    ),
(
        '69400',
        'EE CORONEL REZENDE',
        'PASSA-VINTE',
        'SRE CAXAMBU'
    ),
(
        '173916',
        'EE FELIZARDA RUSSANO',
        'POUSO ALTO',
        'SRE CAXAMBU'
    ),
(
        '174203',
        'CESEC PROFESSORA NOÊMIA GOULART FERREIRA',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '174149',
        'EE DOUTOR HUMBERTO SANCHES',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '174157',
        'EE EURÍPEDES PRAZERES',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '174190',
        'EE PROFESSOR ANTÔNIO MAGALHÃES ALVES',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '174181',
        'EE PROFESSOR MÁRIO JUNQUEIRA FERRAZ',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '356832',
        'EE PROFESSOR TÚLIO BENTO',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '338710',
        'EE SÃO FRANCISCO DE ASSIS',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '330744',
        'EE JOSÉ RIBEIRO MIRA',
        'SÃO SEBASTIÃO DO RIO VERDE',
        'SRE CAXAMBU'
    ),
(
        '174220',
        'EE DO SOBRADINHO',
        'SÃO THOMÉ DAS LETRAS',
        'SRE CAXAMBU'
    ),
(
        '174246',
        'EE JOSÉ CRISTIANO ALVES',
        'SÃO THOMÉ DAS LETRAS',
        'SRE CAXAMBU'
    ),
(
        '174289',
        'EE MINISTRO CLÓVIS SALGADO',
        'SERITINGA',
        'SRE CAXAMBU'
    ),
(
        '305260',
        'EE NOSSA SENHORA DO BONSUCESSO',
        'SERRANOS',
        'SRE CAXAMBU'
    ),
(
        '174319',
        'EE DONA MARIANA CARVALHAL COSTA',
        'SOLEDADE DE MINAS',
        'SRE CAXAMBU'
    ),
(
        '15415',
        'EE CORONEL CELSO RESENDE',
        'CARANAÍBA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193348',
        'EE SILVESTRE NUNES',
        'CASA GRANDE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193356',
        'EE GUSTAVO AUGUSTO DA SILVA',
        'CATAS ALTAS DA NORUEGA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193399',
        'EE BARÃO DE PARAOPEBA',
        'CONGONHAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193429',
        'EE FELICIANO MENDES',
        'CONGONHAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193453',
        'EE LAMARTINE DE FREITAS',
        'CONGONHAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193704',
        'CESEC PROFESSOR JOSÉ MARTINS SOBRINHO',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193551',
        'EE AUGUSTO JOSÉ VIEIRA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193577',
        'EE DOMINGOS BEBIANO',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193593',
        'EE DOUTOR ANTERO CHAVES',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193801',
        'EE DOUTOR ANTONIO NOGUEIRA DE REZENDE',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193615',
        'EE GENERAL OSWALDO PINTO DA VEIGA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193631',
        'EE GENERAL SYLVIO RAULINO DE OLIVEIRA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193658',
        'EE GERALDO BITTENCOURT',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193691',
        'EE ISAURA FERREIRA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193747',
        'EE LOPES FRANCO',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193755',
        'EE LUIZ DE MELLO VIANNA SOBRINHO',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193763',
        'EE MARECHAL HUMBERTO DE ALENCAR CASTELLO BRANCO',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '219037',
        'EE MOACIR DE SOUZA DIAS',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193682',
        'EE MONSENHOR ANTÔNIO JOSÉ FERREIRA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193666',
        'EE MONSENHOR HORTA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193771',
        'EE NARCISO DE QUEIRÓS',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193780',
        'EE PACÍFICO VIEIRA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193542',
        'EE PROFESSOR ASTOR VIANNA',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193585',
        'EE QUEIROZ JÚNIOR',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193828',
        'EE CORONEL ALCIDES DUTRA',
        'CRISTIANO OTONI',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193879',
        'EE CARMELA DUTRA',
        'DESTERRO DE ENTRE RIOS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193895',
        'EE EVARISTO AUGUSTO DE OLIVEIRA',
        'DESTERRO DE ENTRE RIOS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193852',
        'EE NOSSA SENHORA DE FÁTIMA',
        'DESTERRO DE ENTRE RIOS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '218383',
        'EE DOM RODOLFO',
        'ENTRE RIOS DE MINAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193925',
        'EE EXPEDICIONÁRIO GERALDO BAETA',
        'ENTRE RIOS DE MINAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193950',
        'EE PEDRO DOMINGUES',
        'ENTRE RIOS DE MINAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193968',
        'EE RIBEIRO DE OLIVEIRA',
        'ENTRE RIOS DE MINAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '193992',
        'EE CONSELHEIRO ANTÃO',
        'ITAVERAVA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194000',
        'EE PROFESSORA NOEMI NOGUEIRA',
        'ITAVERAVA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194042',
        'EE SANTOS REIS',
        'JECEABA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194107',
        'EE NAPOLEÃO REIS',
        'LAMIM',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194131',
        'CESEC JOSÉ BRÁS DOS REIS',
        'OURO BRANCO',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194123',
        'EE CÔNEGO LUIZ VIEIRA DA SILVA',
        'OURO BRANCO',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '222208',
        'EE DE EDUCAÇÃO ESPECIAL PROFESSORA MARIA CORRÊA COUTINHO',
        'OURO BRANCO',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194158',
        'EE IRACEMA DE ALMEIDA',
        'OURO BRANCO',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194182',
        'EE LEVINDO COSTA CARVALHO',
        'OURO BRANCO',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194298',
        'EE ANTÔNIO DE PAULA DIAS',
        'PIRANGA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194191',
        'EE CORONEL AMANTINO MACIEL',
        'PIRANGA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194204',
        'EE CORONEL JOSÉ ILDEFONSO',
        'PIRANGA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194263',
        'EE FRANCISCO FERREIRA MACIEL',
        'PIRANGA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194255',
        'EE FRANCISCO SALES FERREIRA',
        'PIRANGA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194328',
        'EE SANTO AMARO',
        'QUELUZITO',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194336',
        'EE MAJOR MIRANDA',
        'RIO ESPERA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '196347',
        'EE MONSENHOR FRANCISCO MIGUEL FERNANDES',
        'RIO ESPERA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194395',
        'EE DR JOÃO NOGUEIRA DE ALMEIDA',
        'SANTANA DOS MONTES',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194425',
        'EE DESEMBARGADOR APRÍGIO RIBEIRO DE OLIVEIRA',
        'SÃO BRÁS DO SUAÇUÍ',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '194468',
        'EE QUINZINHO INÁCIO',
        'SENHORA DE OLIVEIRA',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '190641',
        'EE CORONEL FABRICIANO FELISBERTO DE BRITO',
        'ANTÔNIO DIAS',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190705',
        'EE GERMANO PEDRO DE SOUZA',
        'ANTÔNIO DIAS',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190683',
        'EE PROFESSOR LETRO',
        'ANTÔNIO DIAS',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190659',
        'EE VICENTE INÁCIO BISPO',
        'ANTÔNIO DIAS',
        'SRE CORONEL FABRICIANO'
    ),
(
        '273368',
        'EE JOÃO HEMÉTRIO DE MENEZES',
        'BELO ORIENTE',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190756',
        'EE PRESIDENTE TANCREDO NEVES',
        'BELO ORIENTE',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190772',
        'EE FAGUNDES VARELA',
        'BRAÚNAS',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190799',
        'EE MARIA IZABEL MOREIRA PINTO',
        'BRAÚNAS',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190802',
        'EE ALBERTO GIOVANNINI',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190926',
        'EE CORONEL SILVINO PEREIRA',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '221449',
        'EE DOUTOR GERALDO PERLINGEIRO DE ABREU',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190829',
        'EE DOUTOR JOAQUIM GOMES DA SILVEIRA NETO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190870',
        'EE INTENDENTE CÂMARA',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190934',
        'EE PADRE DEOLINDO COELHO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190942',
        'EE PADRE JOSÉ MARIA DE MAN',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190951',
        'EE PROFESSOR FRANCISCO LETRO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190888',
        'EE PROFESSOR PEDRO CALMON',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190900',
        'EE PROFESSORA CELINA MACHADO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190918',
        'EE RAULINO COTTA PACHECO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190969',
        'EE ROTILDINO AVELINO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190985',
        'EE TANCREDO DE ALMEIDA NEVES',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190977',
        'EE ZACARIAS ROQUE',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '313726',
        'CESEC JOÃO GUIMARÃES ROSA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '190993',
        'EE ALMIRANTE TOYODA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191281',
        'EE CHICO MENDES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191027',
        'EE DOM HELVÉCIO',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191191',
        'EE DONA CAETANA AMÉRICA MENEZES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191221',
        'EE DONA CANUTA ROSA OLIVEIRA BARBOSA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191035',
        'EE DOUTOR OVÍDIO DE ANDRADE',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191183',
        'EE ENGENHEIRO AMARO LANARI JÚNIOR',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191043',
        'EE ENGENHEIRO MÁRCIO AGUIAR DA CUNHA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191205',
        'EE GERALDO GOMES RIBEIRO',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191159',
        'EE HAYDÉE MARIA IMACULADA SCHITTINI',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191078',
        'EE JOÃO WALMICK',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191060',
        'EE JOÃO XXIII',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191001',
        'EE LAURA XAVIER SANTANA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191086',
        'EE MANOEL IZÍDIO',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191264',
        'EE MANOELA SOARES BICALHO',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191124',
        'EE MAURÍLIO ALBANESE NOVAES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191213',
        'EE NACIF SELIM DE SALES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '217310',
        'EE NILZA LUZIA DE SOUZA BUTTA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191299',
        'EE PROFESSORA ELZA DE OLIVEIRA LAGE',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191116',
        'EE PROFESSORA MARIA ANTONIETA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191256',
        'EE SELIM JOSÉ DE SALLES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191302',
        'EE SÔNIA MARIA SILVA GOMES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191248',
        'EE WILSON ALVARENGA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '361453',
        'EE PROFESSORA SEBASTIANA DE ALMEIDA E SILVA',
        'JAGUARAÇU',
        'SRE CORONEL FABRICIANO'
    ),
(
        '205621',
        'EE PROFESSOR ANTÔNIO MARCIANO',
        'JOANÉSIA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191353',
        'EE PROFESSOR MANOEL GONÇALVES FERREIRA',
        'JOANÉSIA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191345',
        'EE PROFESSORA EUNICE DOS SANTOS COSTA',
        'JOANÉSIA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191396',
        'EE HORTO BELÉM',
        'MARLIÉRIA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191361',
        'EE LIBERATO DE CASTRO',
        'MARLIÉRIA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191434',
        'EE CAETANO DIAS',
        'MESQUITA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191418',
        'EE PRUDENTE DE MORAIS',
        'MESQUITA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191442',
        'EE ALBERTINO FERREIRA DRUMOND',
        'SANTANA DO PARAÍSO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191451',
        'EE ANTÔNIO LUIZ',
        'SANTANA DO PARAÍSO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '330540',
        'EE HERBERT JOSÉ DE SOUZA BETINHO',
        'SANTANA DO PARAÍSO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191469',
        'EE JOAQUIM ELIZIÁRIO DA SILVA',
        'SANTANA DO PARAÍSO',
        'SRE CORONEL FABRICIANO'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '191426',
        'EE JOSÉ ROSA DAMASCENO',
        'SANTANA DO PARAÍSO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191477',
        'EE SALVELINO FERNANDES MADEIRA',
        'SANTANA DO PARAÍSO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191540',
        'EE ANTÔNIO SILVA',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191558',
        'EE CAPITÃO EGÍDIO LIMA',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191574',
        'EE GETÚLIO VARGAS',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191663',
        'EE JOÃO COTTA DE FIGUEIREDO BARCELOS',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191655',
        'EE JOSÉ FERREIRA MAIA',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191639',
        'EE LEÔNCIO DE ARAÚJO',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191531',
        'EE PROFESSORA ANA LETRO STAACKS',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '326445',
        'EE PROFESSORA HAYDÉE DE SOUZA ABREU',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191566',
        'EE PROFESSORA HILDA DE ARAÚJO OSÓRIO ZAUZA',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191507',
        'EE SÃO SEBASTIÃO',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '191523',
        'EE TENENTE JOSÉ LUCIANO',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '140309',
        'EE AFONSO SOARES DE FREITAS',
        'AUGUSTO DE LIMA',
        'SRE CURVELO'
    ),
(
        '140384',
        'EE NOSSA SENHORA DO CARMO',
        'BUENÓPOLIS',
        'SRE CURVELO'
    ),
(
        '140392',
        'EE PADRE LAERTE ESPERANÇA OLIVEIRA',
        'BUENÓPOLIS',
        'SRE CURVELO'
    ),
(
        '140597',
        'EE ALENCASTRO GUIMARÃES',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '140601',
        'EE ANTÔNIO VIEIRA MACHADO',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '140627',
        'EE DESEMBARGADOR CANEDO',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '140619',
        'EE JOSÉ BRÍGIDO PEREIRA PEDRA',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '140651',
        'EE MAJOR CLARINDO DE PAIVA',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '140686',
        'EE PROFESSORA MARIA AMÁLIA CAMPOS',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '140694',
        'EE WALDEMAR ARAÚJO',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '346080',
        'CESEC DE CURVELO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140864',
        'EE ANTONINA MASCARENHAS GONZAGA',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140899',
        'EE BASÍLIO FRANCISCO XAVIER',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140716',
        'EE BOLÍVAR DE FREITAS',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140767',
        'EE EURÍPEDES DE PAULA',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140775',
        'EE INTERVENTOR ALCIDES LINS',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140856',
        'EE IRMÃ CLARENTINA',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140848',
        'EE IRMÃ RAIMUNDA MARQUES',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140791',
        'EE MAJOR ANTÔNIO SALVO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140708',
        'EE MINISTRO ADAUTO LÚCIO CARDOSO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140872',
        'EE PADRE AUGUSTO HORTA',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140821',
        'EE SÃO GERALDO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '140830',
        'EE SÃO VICENTE DE PAULO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '253421',
        'EE SÉRGIO EUGÊNIO DA SILVA',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '218685',
        'CESEC HUMBERTO JOSÉ ELIAS',
        'FELIXLÂNDIA',
        'SRE CURVELO'
    ),
(
        '140953',
        'EE PADRE JOSÉ GONÇALVES DE SOUZA',
        'FELIXLÂNDIA',
        'SRE CURVELO'
    ),
(
        '140988',
        'EE SÃO JOSÉ DO BURITI',
        'FELIXLÂNDIA',
        'SRE CURVELO'
    ),
(
        '141119',
        'EE DOUTOR PACÍFICO MASCARENHAS',
        'INIMUTABA',
        'SRE CURVELO'
    ),
(
        '141178',
        'EE NOSSA SENHORA DAS DORES',
        'JOAQUIM FELÍCIO',
        'SRE CURVELO'
    ),
(
        '80802',
        'EE CARLOS CHAGAS',
        'LASSANCE',
        'SRE CURVELO'
    ),
(
        '312070',
        'EE PREFEITO WALTER COELHO DA ROCHA',
        'MORRO DA GARÇA',
        'SRE CURVELO'
    ),
(
        '24619',
        'EE DEPUTADO RENATO AZEREDO',
        'PRESIDENTE JUSCELINO',
        'SRE CURVELO'
    ),
(
        '24741',
        'EE FREI EUSTÁQUIO',
        'SANTO HIPÓLITO',
        'SRE CURVELO'
    ),
(
        '24767',
        'EE PROFESSOR RAIMUNDO DA SILVA MACHADO',
        'SANTO HIPÓLITO',
        'SRE CURVELO'
    ),
(
        '142042',
        'EE CARLOS ALEXANDRE DE OLIVEIRA',
        'TRÊS MARIAS',
        'SRE CURVELO'
    ),
(
        '246417',
        'EE JOÃO GUIMARÃES ROSA',
        'TRÊS MARIAS',
        'SRE CURVELO'
    ),
(
        '141976',
        'EE JOSÉ ERMÍRIO DE MORAIS',
        'TRÊS MARIAS',
        'SRE CURVELO'
    ),
(
        '142026',
        'EE MANOEL PEREIRA DE FREITAS',
        'TRÊS MARIAS',
        'SRE CURVELO'
    ),
(
        '141984',
        'EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA',
        'TRÊS MARIAS',
        'SRE CURVELO'
    ),
(
        '23027',
        'EE JOSÉ DANIEL UTSCH',
        'ALVORADA DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '23019',
        'EE JOSÉ MADUREIRA HORTA',
        'ALVORADA DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '23051',
        'EE SÃO JOSÉ DE JASSÉM',
        'ALVORADA DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '23345',
        'EE AUGUSTO BARBOSA',
        'ANGELÂNDIA',
        'SRE DIAMANTINA'
    ),
(
        '330604',
        'EE IVETA GOMES SANTANA',
        'ANGELÂNDIA',
        'SRE DIAMANTINA'
    ),
(
        '24295',
        'EE TEODOMIRO CALDEIRA LEÃO',
        'ARICANDUVA',
        'SRE DIAMANTINA'
    ),
(
        '351032',
        'CESEC DE CAPELINHA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '319376',
        'EE BENTO ROCHA DE JESUS',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23272',
        'EE CORONEL COELHO',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '205893',
        'EE DOMINGOS PIMENTA DE FIGUEIREDO',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23281',
        'EE DOUTOR JUSCELINO BARBOSA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23299',
        'EE PROFESSOR ANTÔNIO LAGO',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23302',
        'EE PROFESSORA GERALDA OTONI BARBOSA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23329',
        'EE PROFESSORA HERMÍNIA EPONINA DA SILVA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23311',
        'EE PROFESSORA MARIA EDMÉIA PIMENTA DE MEIRA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '217646',
        'EE ROSARINHA PIMENTINHA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '342718',
        'EE SEBASTIÃO PEÇANHA DE OLIVEIRA',
        'CAPELINHA',
        'SRE DIAMANTINA'
    ),
(
        '23353',
        'EE CORONEL COIMBRA',
        'CARBONITA',
        'SRE DIAMANTINA'
    ),
(
        '23361',
        'EE MESTRA AURORA',
        'CARBONITA',
        'SRE DIAMANTINA'
    ),
(
        '23469',
        'EE ARACY PEDRELINA DE LIMA OLIVEIRA',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23531',
        'EE CAROLINA OTONI',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23612',
        'EE JOÃO MARIANO RIBEIRO',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23574',
        'EE LEANDRO PEREIRA MALAQUIAS',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23515',
        'EE MESTRE SEBASTIÃO JORGE',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23604',
        'EE PROFESSORA MARIA AMÉLIA RIBEIRO',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23451',
        'EE SÃO JOAQUIM',
        'CONCEIÇÃO DO MATO DENTRO',
        'SRE DIAMANTINA'
    ),
(
        '23621',
        'EE CAPITÃO MIGUEL JORGE SAFE',
        'CONGONHAS DO NORTE',
        'SRE DIAMANTINA'
    ),
(
        '23655',
        'EE JERÔNIMO PONTELLO',
        'COUTO DE MAGALHÃES DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '23647',
        'EE TANCREDO DE ALMEIDA NEVES',
        'COUTO DE MAGALHÃES DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '23698',
        'EE JOÃO HERMENEGILDO CALDEIRA',
        'DATAS',
        'SRE DIAMANTINA'
    ),
(
        '254355',
        'EE JULIANA CATARINA DA SILVEIRA',
        'DATAS',
        'SRE DIAMANTINA'
    ),
(
        '23850',
        'CESEC JUSCELINO KUBITSCHEK DE OLIVEIRA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23957',
        'EE ARTUR TIBÃES',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23876',
        'EE DOM JOAQUIM SILVÉRIO DE SOUZA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23884',
        'EE DONA GUIDINHA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23931',
        'EE DURVAL CÂNDIDO CRUZ',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23949',
        'EE GOVERNADOR JUSCELINO KUBITSCHEK',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23914',
        'EE JOÃO CÉSAR DE OLIVEIRA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23752',
        'EE JOAQUIM FELÍCIO DOS SANTOS',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23779',
        'EE MARIA AUGUSTA CALDEIRA BRANT',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23787',
        'EE MATTA MACHADO',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23868',
        'EE PROFESSOR AIRES DA MATA MACHADO',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23795',
        'EE PROFESSOR GABRIEL MANDACARU',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23761',
        'EE PROFESSOR JOSÉ AUGUSTO NEVES',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23809',
        'EE PROFESSOR LEOPOLDO MIRANDA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23736',
        'EE PROFESSORA AYNA TORRES',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23817',
        'EE PROFESSORA GABRIELA NEVES',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23825',
        'EE PROFESSORA ISABEL MOTTA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23833',
        'EE PROFESSORA JÚLIA KUBITSCHEK',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '23981',
        'EE FELÍCIO DOS SANTOS',
        'FELÍCIO DOS SANTOS',
        'SRE DIAMANTINA'
    ),
(
        '24104',
        'EE AUGUSTO AIRES DA MATA MACHADO',
        'GOUVEIA',
        'SRE DIAMANTINA'
    ),
(
        '24121',
        'EE AURÉLIO PIRES',
        'GOUVEIA',
        'SRE DIAMANTINA'
    ),
(
        '24163',
        'EE CIRO RIBAS',
        'GOUVEIA',
        'SRE DIAMANTINA'
    ),
(
        '24147',
        'EE JOVIANO DE AGUIAR',
        'GOUVEIA',
        'SRE DIAMANTINA'
    ),
(
        '24244',
        'CESEC DE ITAMARANDIBA',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24392',
        'EE ALFREDO RABELO',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24309',
        'EE BETINA GOMES',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24180',
        'EE CORONEL JONAS CÂMARA',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24317',
        'EE DE PADRE JOÃO AFONSO',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24350',
        'EE MARIA RAIMUNDA ANDRADE NEVES',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '217611',
        'EE MESTRA BEZINHA GANDRA',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24228',
        'EE MESTRE JOÃO SILVÉRIO',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24406',
        'EE PROFESSOR CAMPOS',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24210',
        'EE SÃO JOÃO BATISTA',
        'ITAMARANDIBA',
        'SRE DIAMANTINA'
    ),
(
        '24511',
        'EE DE GOUVEIA',
        'LEME DO PRADO',
        'SRE DIAMANTINA'
    ),
(
        '24554',
        'EE DOM PEDRO II',
        'LEME DO PRADO',
        'SRE DIAMANTINA'
    ),
(
        '24562',
        'EE PROFESSORA FLORA BRASILEIRA PIRES CÉSAR',
        'LEME DO PRADO',
        'SRE DIAMANTINA'
    ),
(
        '24538',
        'EE SANTOS BARROSO',
        'LEME DO PRADO',
        'SRE DIAMANTINA'
    ),
(
        '24503',
        'CESEC PROFESSORA MARIA GERALDA SILVA SANTOS',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24414',
        'EE CORONEL JOÃO ANDRÉ',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24520',
        'EE DE INDAIÁ',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24422',
        'EE DE LAGOA GRANDE',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24465',
        'EE DE RIBEIRÃO DA FOLHA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24473',
        'EE DE RIBEIRÃO DOS SANTOS',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24481',
        'EE DOUTOR AGOSTINHO DA SILVA SILVEIRA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '218448',
        'EE ERNESTO ALVES DE MENDONÇA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24490',
        'EE FRANCISCO SOARES SILVA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '218421',
        'EE JOÃO FERNANDES DE AZEVEDO',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24431',
        'EE JOSÉ BENTO NOGUEIRA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24457',
        'EE PRESIDENTE COSTA E SILVA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24449',
        'EE PROFESSORA ODÍLIA CÂNDIDA DE SOUSA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '29190',
        'EE SANTOS COSTA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '217638',
        'EE SEBASTIÃO GOMES DE ALMEIDA',
        'MINAS NOVAS',
        'SRE DIAMANTINA'
    ),
(
        '24597',
        'EE FORTUNATA VIEIRA RAMOS',
        'MONJOLOS',
        'SRE DIAMANTINA'
    ),
(
        '24571',
        'EE IMACULADA CONCEIÇÃO',
        'MONJOLOS',
        'SRE DIAMANTINA'
    ),
(
        '24635',
        'EE PIO XII',
        'PRESIDENTE KUBITSCHEK',
        'SRE DIAMANTINA'
    ),
(
        '24716',
        'CESEC MESTRA CHIQUINHA CARVALHAES',
        'RIO VERMELHO',
        'SRE DIAMANTINA'
    ),
(
        '24651',
        'EE DOUTOR AFONSO PENA JÚNIOR',
        'RIO VERMELHO',
        'SRE DIAMANTINA'
    ),
(
        '24686',
        'EE EVA DAS DORES SANTOS',
        'RIO VERMELHO',
        'SRE DIAMANTINA'
    ),
(
        '24724',
        'EE FRANCISCO GONÇALVES VIEIRA',
        'RIO VERMELHO',
        'SRE DIAMANTINA'
    ),
(
        '24678',
        'EE SANTOS CARVALHAIS',
        'RIO VERMELHO',
        'SRE DIAMANTINA'
    ),
(
        '24732',
        'EE ALCEBÍADES NUNES',
        'SANTO ANTÔNIO DO ITAMBÉ',
        'SRE DIAMANTINA'
    ),
(
        '24023',
        'EE DOM JOÃO ANTÔNIO DOS SANTOS',
        'SÃO GONÇALO DO RIO PRETO',
        'SRE DIAMANTINA'
    ),
(
        '24783',
        'EE DARCÍLIA GODOY',
        'SENADOR MODESTINO GONÇALVES',
        'SRE DIAMANTINA'
    ),
(
        '24821',
        'EE ÂNGELO DE MIRANDA',
        'SERRA AZUL DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '24953',
        'CESEC TEOTÔNIO MAGALHÃES',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24872',
        'EE DOUTOR JOÃO PINHEIRO',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24961',
        'EE DR ANTÔNIO TOLENTINO',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24902',
        'EE JOÃO NEPOMUCENO KUBITSCHEK',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24911',
        'EE JOAQUIM SALLES',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24929',
        'EE LUIZA DE MARILAC',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24996',
        'EE MESTRA ROSA MADUREIRA FAGUNDES',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '25003',
        'EE MESTRA VIRGÍNIA REIS',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24937',
        'EE MINISTRO EDMUNDO LINS',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '24988',
        'EE PROFESSOR LEOPOLDO PEREIRA',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '218367',
        'CESEC SENHORA DA PIEDADE',
        'TURMALINA',
        'SRE DIAMANTINA'
    ),
(
        '25038',
        'EE AMÉRICO ANTUNES DE OLIVEIRA',
        'TURMALINA',
        'SRE DIAMANTINA'
    ),
(
        '25011',
        'EE BADARÓ JÚNIOR',
        'TURMALINA',
        'SRE DIAMANTINA'
    ),
(
        '25054',
        'EE LAURO MACHADO',
        'TURMALINA',
        'SRE DIAMANTINA'
    ),
(
        '25020',
        'EE MESTRA CELINA',
        'TURMALINA',
        'SRE DIAMANTINA'
    ),
(
        '246344',
        'EE PROFESSORA EDITE GOMES',
        'TURMALINA',
        'SRE DIAMANTINA'
    ),
(
        '25071',
        'EE ANTÔNIO FERNANDES DE OLIVEIRA',
        'VEREDINHA',
        'SRE DIAMANTINA'
    ),
(
        '25062',
        'EE FIDELCINO VIANA',
        'VEREDINHA',
        'SRE DIAMANTINA'
    ),
(
        '31984',
        'EE JOSÉ MANOEL',
        'ARAÚJOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32093',
        'CESEC MONSENHOR GERALDO M VASCONCELOS',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32026',
        'EE DA VILA BOA VISTA',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32051',
        'EE DONA BERENICE DE MAGALHÃES PINTO',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32069',
        'EE DONA MARICOTA PINTO',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32018',
        'EE JOSÉ GERALDO DE MELO',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32077',
        'EE YOLANDA JOVINO VAZ',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32271',
        'CESEC JOÃO APOLINÁRIO DE OLIVEIRA',
        'BAMBUÍ',
        'SRE DIVINÓPOLIS'
    ),
(
        '32212',
        'EE JOÃO BATISTA DE CARVALHO',
        'BAMBUÍ',
        'SRE DIVINÓPOLIS'
    ),
(
        '32221',
        'EE JOSÉ ALZAMORA',
        'BAMBUÍ',
        'SRE DIVINÓPOLIS'
    ),
(
        '32441',
        'EE JOAQUIM AFONSO RODRIGUES',
        'CARMO DA MATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '32531',
        'EE DE BOM JESUS DE ANGICOS',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '32557',
        'EE DE ESTIVA',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '32611',
        'EE MELQUÍADES BATISTA DE MIRANDA',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '32549',
        'EE PADRE JOÃO PARREIRAS VILLAÇA',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '307335',
        'EE SÃO FRANCISCO DE ASSIS',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '32603',
        'EE VIGÁRIO JOSÉ ALEXANDRE',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '32689',
        'EE LÍGIA BEATRIZ AMARAL',
        'CARMÓPOLIS DE MINAS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32701',
        'EE PRESIDENTE TANCREDO NEVES',
        'CARMÓPOLIS DE MINAS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32883',
        'EE CUSTÓDIO COSTA',
        'CLÁUDIO',
        'SRE DIVINÓPOLIS'
    ),
(
        '32875',
        'EE PRESIDENTE TANCREDO DE ALMEIDA NEVES',
        'CLÁUDIO',
        'SRE DIVINÓPOLIS'
    ),
(
        '32751',
        'EE QUINTO ALVES TOLENTINO',
        'CLÁUDIO',
        'SRE DIVINÓPOLIS'
    ),
(
        '32972',
        'EE PROFESSOR FRANCISCO ROCHA',
        'CÓRREGO DANTA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33090',
        'CESEC DOUTOR FÁBIO BOTELHO NOTINI',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '326992',
        'EE ALBERTO SANTOS DUMONT',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33421',
        'EE ANTÔNIO BELARMINO GOMES',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33359',
        'EE ANTÔNIO DA COSTA PEREIRA',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33006',
        'EE ANTÔNIO GONÇALVES DE MATOS',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33022',
        'EE ANTÔNIO OLÍMPIO DE MORAIS',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33014',
        'EE ARMANDO NOGUEIRA SOARES',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33138',
        'EE DE EDUCAÇÃO ESPECIAL HELENA ANTIPOFF',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33391',
        'EE DO BAIRRO BELO VALE',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33154',
        'EE DONA ANTÔNIA VALADARES',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33171',
        'EE ENGENHEIRO PEDRO MAGALHÃES',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33189',
        'EE HALIM SOUKI',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33197',
        'EE HENRIQUE GALVÃO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33405',
        'EE ILÍDIO DA COSTA PEREIRA',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33201',
        'EE JOAQUIM NABUCO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33219',
        'EE JOVELINO RABELO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33227',
        'EE LAURO EPIFÂNIO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33235',
        'EE LUIZ DE MELO VIANA SOBRINHO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33375',
        'EE MANOEL CORREA FILHO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '32999',
        'EE MARTIN CYPRIEN',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33251',
        'EE MIGUEL COUTO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33260',
        'EE MONSENHOR DOMINGOS',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33278',
        'EE NOSSA SENHORA DO SAGRADO CORAÇÃO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33286',
        'EE PADRE MATIAS LOBATO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33294',
        'EE PATRONATO BOM PASTOR',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33341',
        'EE PROFESSOR CHICO DIAS',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33057',
        'EE ROSA VAZ DE ARAÚJO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33031',
        'EE SANTO TOMAZ DE AQUINO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33316',
        'EE SÃO FRANCISCO DE ASSIS',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33332',
        'EE SÃO FRANCISCO DE PAULA',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33324',
        'EE SÃO VICENTE',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33383',
        'EE VICENTE MATEUS',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '33685',
        'EE PAULA CARVALHO',
        'IGUATAMA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33740',
        'EE ALVIM RODRIGUES DO PRADO',
        'ITAGUARA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33715',
        'EE CORONEL FRAZÃO',
        'ITAGUARA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33758',
        'EE PADRE GREGÓRIO',
        'ITAGUARA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202851',
        'EE CARMELO MESQUITA',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202762',
        'EE IMACULADA CONCEIÇÃO',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '342521',
        'EE INDÍGENA PATAXÓ MUÃ MIMATXI',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202843',
        'EE LAMOUNIER GODOFREDO',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202797',
        'EE PADRE HERCULANO PAZ',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202860',
        'EE PEDRO LUIZ',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202819',
        'EE PROFESSOR ALBERTO CORDEIRO DO COUTO',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '202801',
        'EE PROFESSORA MARIA MAGALHÃES PINTO',
        'ITAPECERICA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33774',
        'EE MANOEL DIAS CORREA',
        'ITATIAIUÇU',
        'SRE DIVINÓPOLIS'
    ),
(
        '33871',
        'EE DE ITAÚNA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33901',
        'EE DO BAIRRO SÃO GERALDO',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33910',
        'EE DONA JUDITH GONÇALVES',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33952',
        'EE DOUTOR JOSÉ GONÇALVES',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33782',
        'EE JOSÉ GONÇALVES DE MELO',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33944',
        'EE LEONARDO GONÇALVES NOGUEIRA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33855',
        'EE MANOEL DA COSTA REZENDE',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33928',
        'EE PADRE LUIZ TURKENBURG',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '330841',
        'EE PROFESSORA GERALDA MAGELA LEÃO DE MELO',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '305642',
        'EE PROFESSORA GILKA DRUMOND DE FARIA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33847',
        'EE SANTANA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33880',
        'EE VICTOR GONÇALVES DE SOUZA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '33821',
        'EE ZEZÉ LIMA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34002',
        'EE PADRE PEDRO LAMBERTI',
        'JAPARAÍBA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34045',
        'EE CHICO REZENDE',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34011',
        'EE DE EDUCAÇÃO ESPECIAL HELENA APARECIDA',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '310506',
        'EE DONA TILOSA',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34070',
        'EE DOUTOR ARNALDO DE FARIA TAVARES',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '231746',
        'EE JOSÉ TEOTÔNIO DE CASTRO',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34118',
        'EE MONSENHOR ALFREDO DOHR',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34096',
        'EE NOSSA SENHORA  DE GUADALUPE',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34100',
        'EE VIRGÍNIO PERILLO',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34240',
        'EE CAPITÃO ALEXANDRE DU',
        'LUZ',
        'SRE DIVINÓPOLIS'
    ),
(
        '34185',
        'EE COMENDADOR ZICO TOBIAS',
        'LUZ',
        'SRE DIVINÓPOLIS'
    ),
(
        '218405',
        'EE DONA LICA RAPOSO',
        'LUZ',
        'SRE DIVINÓPOLIS'
    ),
(
        '310514',
        'EE SANDOVAL DE AZEVEDO',
        'LUZ',
        'SRE DIVINÓPOLIS'
    ),
(
        '34495',
        'EE JOSÉ SABINO DA PAIXÃO',
        'MEDEIROS',
        'SRE DIVINÓPOLIS'
    ),
(
        '34533',
        'EE CHICO MARÇAL',
        'MOEMA',
        'SRE DIVINÓPOLIS'
    ),
(
        '346195',
        'CESEC DE NOVA SERRANA',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34665',
        'EE ANTÔNIO MARTINS DO ESPÍRITO SANTO',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34622',
        'EE FREI ANSELMO',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34614',
        'EE MAJOR AGENOR LOPES CANÇADO',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '342530',
        'EE MARIA ZELI DINIZ FONSECA',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '326135',
        'EE PADRE LAURO',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '203289',
        'EE DESEMBARGADOR CONTINENTINO',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '203301',
        'EE DOUTOR JOSÉ MARIA LOBATO',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '203327',
        'EE FRANCISCO FERNANDES',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '203343',
        'EE MÁRIO CAMPOS E SILVA',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '203360',
        'EE PROFESSOR PINHEIRO CAMPOS',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '203408',
        'EE SÃO JOÃO BATISTA',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '34827',
        'EE MARIA LUIZA DAS DORES',
        'PAINS',
        'SRE DIVINÓPOLIS'
    ),
(
        '34797',
        'EE PADRE JOSÉ VENÂNCIO',
        'PAINS',
        'SRE DIVINÓPOLIS'
    ),
(
        '35190',
        'EE CORONEL AMÉRICO AUGUSTO DE OLIVEIRA',
        'PASSA TEMPO',
        'SRE DIVINÓPOLIS'
    ),
(
        '35262',
        'EE PROFESSOR JOÃO ALVES FILGUEIRAS  CAMPOS',
        'PEDRA DO INDAIÁ',
        'SRE DIVINÓPOLIS'
    ),
(
        '35271',
        'EE RIBEIRO PENA',
        'PEDRA DO INDAIÁ',
        'SRE DIVINÓPOLIS'
    ),
(
        '35351',
        'EE PEDRO PRIMO',
        'PERDIGÃO',
        'SRE DIVINÓPOLIS'
    ),
(
        '35386',
        'EE HERMENEGILDO VILAÇA',
        'PIRACEMA',
        'SRE DIVINÓPOLIS'
    ),
(
        '35599',
        'EE DE SÃO JOSÉ DOS ROSAS',
        'SANTO ANTÔNIO DO MONTE',
        'SRE DIVINÓPOLIS'
    ),
(
        '35556',
        'EE DOUTOR ÁLVARO BRANDÃO',
        'SANTO ANTÔNIO DO MONTE',
        'SRE DIVINÓPOLIS'
    ),
(
        '224014',
        'EE PADRE PAULO',
        'SANTO ANTÔNIO DO MONTE',
        'SRE DIVINÓPOLIS'
    ),
(
        '35572',
        'EE SENHORA DE FÁTIMA',
        'SANTO ANTÔNIO DO MONTE',
        'SRE DIVINÓPOLIS'
    ),
(
        '311871',
        'CESEC MAESTRO CARLOS RIBEIRO DA SILVA',
        'SÃO GONÇALO DO PARÁ',
        'SRE DIVINÓPOLIS'
    ),
(
        '35637',
        'EE BENEDITO VALADARES',
        'SÃO GONÇALO DO PARÁ',
        'SRE DIVINÓPOLIS'
    ),
(
        '35661',
        'EE GOVERNADOR MAGALHÃES PINTO',
        'SÃO SEBASTIÃO DO OESTE',
        'SRE DIVINÓPOLIS'
    ),
(
        '307416',
        'EE DE TAPIRAÍ',
        'TAPIRAÍ',
        'SRE DIVINÓPOLIS'
    ),
(
        '41556',
        'EE ANTÔNIO ALTICIANO',
        'AÇUCENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41611',
        'EE CRISTIANO MACHADO',
        'AÇUCENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41637',
        'EE DOM SERAFIM GOMES JARDIM',
        'AÇUCENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41581',
        'EE ODETE VALADARES',
        'AÇUCENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41653',
        'EE TEREZINHA BARBOSA DOS SANTOS',
        'AÇUCENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41769',
        'EE AMÉRICO MARTINS DA COSTA',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41840',
        'EE DR NELSON DARBY DE ASSIS',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41785',
        'EE FREI AFONSO MARIA JORDÁ',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41904',
        'EE JOSÉ HENRIQUE FILHO',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41858',
        'EE JOSÉ TEIXEIRA FRANCO',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41793',
        'EE MACHADO DE ASSIS',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41912',
        'EE MANOEL VICTORINO DE OLIVEIRA',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41866',
        'EE MARIA DE CASTRO PAIVA',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41823',
        'EE REVERENDO RAFAEL LEONOR',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41963',
        'EE TEREZINHA PINTO FERNANDES MAIA',
        'ALPERCATA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43885',
        'EE LEVINDO DIAS',
        'CAPITÃO ANDRADE',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42030',
        'EE JOSÉ PINTO NETO',
        'CENTRAL DE MINAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42021',
        'EE PRESIDENTE TANCREDO NEVES',
        'CENTRAL DE MINAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42081',
        'EE DE CONSELHEIRO PENA',
        'CONSELHEIRO PENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42251',
        'EE JOSÉ RICARDO NEIVA',
        'CONSELHEIRO PENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42129',
        'EE LUIZ GONZAGA BASTOS',
        'CONSELHEIRO PENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42200',
        'EE MARIA GARCIA PINTO',
        'CONSELHEIRO PENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42145',
        'EE MARIA GUILHERMINA PENA',
        'CONSELHEIRO PENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42374',
        'EE BERNARDINO NUNES DA ROCHA',
        'COROACI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42331',
        'EE CHICO TEÓFILO',
        'COROACI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '267228',
        'EE PROFESSORA ELGE RENAN BRAGA',
        'COROACI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42358',
        'EE SINHANINHA GONÇALVES',
        'COROACI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42188',
        'EE JOSÉ FERREIRA JÚNIOR',
        'CUPARAQUE',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42242',
        'EE MOACIR ALBUQUERQUE',
        'CUPARAQUE',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42463',
        'EE CENTRAL DE SANTA HELENA',
        'DIVINO DAS LARANJEIRAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42421',
        'EE DE LINÓPOLIS',
        'DIVINO DAS LARANJEIRAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42439',
        'EE DE MACEDÔNIA',
        'DIVINO DAS LARANJEIRAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42412',
        'EE FRANCISCO DE SOUZA RESENDE',
        'DIVINO DAS LARANJEIRAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42765',
        'EE PROFESSORA ONDINA PINTO DE ALMEIDA',
        'ENGENHEIRO CALDAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42820',
        'EE AGRIPINO VILAS NOVAS',
        'FERNANDES TOURINHO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42901',
        'EE FREI INOCÊNCIO',
        'FREI INOCÊNCIO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42919',
        'EE JOÃO BRASILEIRO PASSOS',
        'FREI INOCÊNCIO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42978',
        'EE DE SAPUCAIA DO NORTE',
        'GALILÉIA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42935',
        'EE LEVINDO VALADARES DA FONSECA',
        'GALILÉIA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42277',
        'EE DE GOIABEIRA',
        'GOIABEIRA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43036',
        'CESEC DE GOVERNADOR VALADARES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43001',
        'EE ABÍLIO RODRIGUES PATTO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43346',
        'EE ALEXANDRE PEIXOTO DA SILVA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43508',
        'EE ANTÔNIO JOB DA CRUZ',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43044',
        'EE BOM PASTOR',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43079',
        'EE CARLOS LUZ',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '354716',
        'EE CECÍLIA MEIRELES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43443',
        'EE DARIO DE OLIVEIRA MEDEIROS',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43559',
        'EE DE SÃO VITOR',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43095',
        'EE DIOCESANO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '205371',
        'EE DO BAIRRO JARDIM DO IPÊ',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43117',
        'EE DONA ADELAIDE MALZONE HUGO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43133',
        'EE DONA ARABELA DE ALMEIDA COSTA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43427',
        'EE DOUTOR ANTÔNIO FERREIRA LISBOA DIAS',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43150',
        'EE EUZÉBIO CABRAL',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43176',
        'EE FREI ANGÉLICO DE CAMPORA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43028',
        'EE ISRAEL PINHEIRO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43061',
        'EE JOÃO WESLEY',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43109',
        'EE JÚLIO SOARES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43125',
        'EE LABOR CLUB',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43141',
        'EE MANOEL BYRRO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43486',
        'EE MARÇAL CIRÍACO DA SILVA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43451',
        'EE MARCOS GEBER SÍRIO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43168',
        'EE NACLE MIGUEL HABIB',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43206',
        'EE PEDRO FARIA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43222',
        'EE PEDRO RIBEIRO CAVALCANTE FILHO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43214',
        'EE PREFEITO JOAQUIM PEDRO NASCIMENTO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43541',
        'EE PRESIDENTE KENNEDY',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43397',
        'EE PRESIDENTE TANCREDO NEVES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '271241',
        'EE PROFESSOR DARCY RIBEIRO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43257',
        'EE PROFESSOR NÉLSON DE SENA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43184',
        'EE PROFESSOR PAULO FREIRE',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43516',
        'EE PROFESSORA JOSEFINA CARMÉLIA REIS',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '354724',
        'EE PROFESSORA MARIA DAMÁZIO DE BARROS MENEZES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43265',
        'EE PROFESSORA THEOLINDA DE SOUZA CARMO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43273',
        'EE QUINTINO BOCAIÚVA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43281',
        'EE ROTARY CLUB',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43419',
        'EE SAGRADA FAMÍLIA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '326861',
        'EE SÃO FRANCISCO DE ASSIS',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43320',
        'EE SÃO JOSÉ',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '326852',
        'EE SÃO JUDAS TADEU',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43338',
        'EE SÃO TARCÍSIO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43303',
        'EE SECRETÁRIO LEVINDO COELHO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43311',
        'EE SINVAL RODRIGUES COELHO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43362',
        'EE VICENTE JOSÉ SOARES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43354',
        'EE VILA ISA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '351423',
        'CESEC DE ITABIRINHA',
        'ITABIRINHA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43737',
        'EE GOVERNADOR LACERDA DE AGUIAR',
        'ITABIRINHA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43818',
        'EE JOÃO AMÂNCIO SOBRINHO',
        'ITABIRINHA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43842',
        'EE CARLOTA DE ANDRADE',
        'ITANHOMI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43834',
        'EE HUMBERTO DE CAMPOS',
        'ITANHOMI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43893',
        'EE PROFESSORA MARIA ASSUNÇÃO',
        'ITANHOMI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43851',
        'EE VEREADOR ANTONIO DUARTE',
        'ITANHOMI',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '43907',
        'EE AMÉRICO VESPÚCIO',
        'ITUETA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44253',
        'CESEC PREFEITO JOSÉ ROMERO DUQUE',
        'MANTENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44270',
        'EE CÂNDIDO ILHÉU',
        'MANTENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44245',
        'EE DONA RAIMUNDA DUQUE',
        'MANTENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44181',
        'EE PROFESSORA ZILDA PINHEIRO DA SILVA',
        'MANTENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44563',
        'EE JOAQUIM MONTEIRO',
        'MARILAC',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45764',
        'EE PAULO LUIZ',
        'MATHIAS LOBATO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44610',
        'EE DA FAZENDA EDUARDO NOGUEIRA',
        'MENDES PIMENTEL',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44598',
        'EE NOSSA SENHORA APARECIDA',
        'MENDES PIMENTEL',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44636',
        'EE CONSTÂNCIO CORREIA DE ALVARENGA',
        'NACIP RAYDAN',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41645',
        'EE DOM HERMÍNIO MALZONE HUGO',
        'NAQUE',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44466',
        'EE PROFESSORA DIOGUINA AUGUSTA SANTANA',
        'NOVA BELÉM',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '147532',
        'EE DOUTOR ALAIR ALVES COSTA',
        'NOVA MÓDICA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41688',
        'EE DEPUTADO HILO ANDRADE',
        'PERIQUITO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44890',
        'EE COMENDADOR NASCIMENTO NUNES LEAL',
        'RESPLENDOR',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44008',
        'EE FLORIANO WITT',
        'RESPLENDOR',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '246387',
        'EE NA RESERVA INDÍGENA DE KRENAK',
        'RESPLENDOR',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45098',
        'EE TITO ALVES PINTO',
        'SANTA EFIGÊNIA DE MINAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45195',
        'EE PADRE ANDRÉ COLLI',
        'SANTA RITA DO ITUETO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45217',
        'EE SÃO JOSÉ',
        'SANTA RITA DO ITUETO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44628',
        'EE FREI JORGE',
        'SÃO FÉLIX DE MINAS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45225',
        'EE SEBASTIÃO GUALBERTO',
        'SÃO GERALDO DA PIEDADE',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '42960',
        'EE SÃO GERALDO DO BAIXIO',
        'SÃO GERALDO DO BAIXIO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44555',
        'EE PROFESSOR JOSÉ JÓRIO',
        'SÃO JOÃO DO MANTENINHA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '44334',
        'EE PROFESSORA NILCE DIAS DOS SANTOS PACHECO',
        'SÃO JOÃO DO MANTENINHA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45357',
        'EE BOM JESUS DO ROSENDO',
        'SÃO JOSÉ DA SAFIRA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45365',
        'EE FERNÃO DIAS',
        'SÃO JOSÉ DA SAFIRA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '147885',
        'EE TRANQUILINO DIAS BRITO',
        'SÃO JOSÉ DO DIVINO',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45632',
        'EE GERALDA PEREIRA DE ALMEIDA',
        'SARDOÁ',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45705',
        'EE JOSÉ SEVERINO',
        'SOBRÁLIA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45756',
        'EE JOSÉ VICENTE BARBOSA',
        'TUMIRITINGA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45730',
        'EE LUIZ DE CAMÕES',
        'TUMIRITINGA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '246379',
        'EE PRIMEIRO DE JUNHO',
        'TUMIRITINGA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45861',
        'EE CAPITÃO PAULO',
        'VIRGOLÂNDIA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45837',
        'EE JOAQUIM ELETO',
        'VIRGOLÂNDIA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '45845',
        'EE JUVENTINO ALVES FERREIRA',
        'VIRGOLÂNDIA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41700',
        'EE ADÃO MARQUES DAS ALELUIAS',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '41726',
        'EE DE RESPLENDOR',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '41734',
        'EE DOUTOR ALFREDO SÁ',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '254045',
        'EE JOSÉ BONIFÁCIO SANTANA',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '41718',
        'EE LAUREANO TEIXEIRA DE SOUZA',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '41751',
        'EE MODESTO ALVES BARROSO',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '41742',
        'EE PROFESSOR JOAQUIM PIMENTA DE ARAÚJO',
        'ÁGUA BOA',
        'SRE GUANHÃES'
    ),
(
        '44776',
        'EE PROFESSORA ESTER SIQUEIRA',
        'CANTAGALO',
        'SRE GUANHÃES'
    ),
(
        '369802',
        'EE INDÍGENA ÃGOHÓ KUÂP PATAXÓ',
        'CARMÉSIA',
        'SRE GUANHÃES'
    ),
(
        '277657',
        'EE INDÍGENA PATAXÓ BACUMUXÁ',
        'CARMÉSIA',
        'SRE GUANHÃES'
    ),
(
        '46884',
        'EE JOSÉ VIEIRA DA SILVA',
        'CARMÉSIA',
        'SRE GUANHÃES'
    ),
(
        '42056',
        'EE DO JAPÃO',
        'COLUNA',
        'SRE GUANHÃES'
    ),
(
        '213969',
        'EE PROFESSORA ALMERINDA AGUIAR',
        'COLUNA',
        'SRE GUANHÃES'
    ),
(
        '42072',
        'EE PROFESSORA HEROÍNA TORRES',
        'COLUNA',
        'SRE GUANHÃES'
    ),
(
        '42480',
        'EE PROFESSOR CARVALHAIS',
        'DIVINOLÂNDIA DE MINAS',
        'SRE GUANHÃES'
    ),
(
        '42609',
        'EE ÂNGELO RIBEIRO MIRANDA',
        'DOM JOAQUIM',
        'SRE GUANHÃES'
    ),
(
        '42528',
        'EE CÔNEGO BENTO RIBEIRO',
        'DOM JOAQUIM',
        'SRE GUANHÃES'
    ),
(
        '42536',
        'EE CRISTIANO MACHADO',
        'DOM JOAQUIM',
        'SRE GUANHÃES'
    ),
(
        '42641',
        'EE CORONEL JOÃO BARRETO',
        'DORES DE GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '322857',
        'EE NADIM NOMAN',
        'DORES DE GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '42668',
        'EE PADRE SÉRGIO RIBEIRO DOS SANTOS',
        'DORES DE GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '45471',
        'EE JOSÉ GONÇALVES DE SOUZA',
        'FREI LAGONEGRO',
        'SRE GUANHÃES'
    ),
(
        '42994',
        'EE OSWALDO RABELO LEITE',
        'GONZAGA',
        'SRE GUANHÃES'
    ),
(
        '42986',
        'EE SÃO SEBASTIÃO',
        'GONZAGA',
        'SRE GUANHÃES'
    ),
(
        '43664',
        'CESEC DURCELINO DA SILVA REIS',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43699',
        'EE ALBERTO CALDEIRA',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43567',
        'EE ALTIVO COELHO',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43591',
        'EE FAZENDA SÃO SEBASTIÃO',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43656',
        'EE NOSSA SENHORA DO CARMO',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43613',
        'EE ODILON BEHRENS',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43702',
        'EE OTÁVIO NUNES LEITE',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43648',
        'EE SENADOR FRANCISCO NUNES COELHO',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '43681',
        'EE TENENTE JOSÉ COELHO DA ROCHA',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '45152',
        'EE CÔNEGO LAFAIETE',
        'JOSÉ RAYDAN',
        'SRE GUANHÃES'
    ),
(
        '45161',
        'EE DA RUA PRINCIPAL',
        'JOSÉ RAYDAN',
        'SRE GUANHÃES'
    ),
(
        '44580',
        'EE RAIMUNDO DECO',
        'MATERLÂNDIA',
        'SRE GUANHÃES'
    ),
(
        '44652',
        'EE PADRE JOÃO CLARIMUNDO',
        'PAULISTAS',
        'SRE GUANHÃES'
    ),
(
        '44695',
        'EE DEPUTADO SADY DA CUNHA',
        'PEÇANHA',
        'SRE GUANHÃES'
    ),
(
        '44661',
        'EE DOUTOR ANTÔNIO DA CUNHA PEREIRA',
        'PEÇANHA',
        'SRE GUANHÃES'
    ),
(
        '44750',
        'EE PROFESSOR ADELARDO DA CUNHA',
        'PEÇANHA',
        'SRE GUANHÃES'
    ),
(
        '44725',
        'EE SENADOR SIMÃO DA CUNHA',
        'PEÇANHA',
        'SRE GUANHÃES'
    ),
(
        '45047',
        'CESEC PROFETA DANIEL',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '45071',
        'EE DO QUILOMBO',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '45055',
        'EE ELPÍDIO DE PINHO TAVARES',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '44989',
        'EE MONSENHOR JOSÉ AMANTINO DOS SANTOS',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '44997',
        'EE PROFESSOR PATRÍCIO PAES DE CARVALHO',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '330680',
        'EE PROFESSORA MARGARET BARROSO PINTO',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '45004',
        'EE SABINO BARROSO',
        'SABINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '45144',
        'CESEC DE SANTA MARIA DE SUAÇUÍ',
        'SANTA MARIA DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45136',
        'EE ANA NUNES HORTA',
        'SANTA MARIA DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45101',
        'EE DEPUTADO NACIP RAYDAN',
        'SANTA MARIA DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45110',
        'EE HAUY PETRUCELI MAYRINK',
        'SANTA MARIA DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45179',
        'EE IMACULADA CONCEIÇÃO',
        'SANTA MARIA DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45128',
        'EE PADRE JOSÉ MARIA',
        'SANTA MARIA DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45349',
        'EE CARMELA DUTRA',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '45241',
        'EE DR LÚCIO VIEIRA DA SILVA',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '45284',
        'EE JOSEFINA PIMENTA',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '45331',
        'EE MAJOR LERMINO PIMENTA',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '45292',
        'EE MONSENHOR PINHEIRO',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '45420',
        'EE DE TABOLEIRO',
        'SÃO JOSÉ DO JACURI',
        'SRE GUANHÃES'
    ),
(
        '45390',
        'EE JOHN KENNEDY',
        'SÃO JOSÉ DO JACURI',
        'SRE GUANHÃES'
    ),
(
        '45519',
        'EE DIM VIEGAS',
        'SÃO PEDRO DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '45527',
        'EE JOÃO PINHEIRO',
        'SÃO PEDRO DO SUAÇUÍ',
        'SRE GUANHÃES'
    ),
(
        '253316',
        'EE ALTAIR ANDRADE GUIMARÃES',
        'SÃO SEBASTIÃO DO MARANHÃO',
        'SRE GUANHÃES'
    ),
(
        '45560',
        'EE DEPUTADO AUGUSTO COSTA',
        'SÃO SEBASTIÃO DO MARANHÃO',
        'SRE GUANHÃES'
    ),
(
        '45608',
        'EE DOUTOR CRISTIANO MACHADO',
        'SÃO SEBASTIÃO DO MARANHÃO',
        'SRE GUANHÃES'
    ),
(
        '45616',
        'EE SANTO ANTÔNIO DOS ARAÚJOS',
        'SÃO SEBASTIÃO DO MARANHÃO',
        'SRE GUANHÃES'
    ),
(
        '45594',
        'EE SÃO SEBASTIÃO DO MARANHÃO',
        'SÃO SEBASTIÃO DO MARANHÃO',
        'SRE GUANHÃES'
    ),
(
        '342548',
        'EE PROFESSORA CIVA SIMÕES FONSECA',
        'SENHORA DO PORTO',
        'SRE GUANHÃES'
    ),
(
        '218146',
        'EE DO POVOADO DE BOM JESUS DA BOA VISTA',
        'VIRGINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '45799',
        'EE NOSSA SENHORA DO PATROCÍNIO',
        'VIRGINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '45802',
        'EE PROFESSOR FRANCISCO DIAS',
        'VIRGINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '54500',
        'EE ALFREDO ALBANO DE OLIVEIRA',
        'BRAZÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '54437',
        'EE DINO AMBRÓSIO PEREIRA',
        'BRAZÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '54453',
        'EE INÁCIO JOÃO DE FARIA',
        'BRAZÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '54470',
        'EE PRESIDENTE  WENCESLAU',
        'BRAZÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '171956',
        'EE GABRIEL RIBEIRO',
        'CARMO DE MINAS',
        'SRE ITAJUBÁ'
    ),
(
        '171964',
        'EE PROFESSOR GUEDES FERNANDES',
        'CARMO DE MINAS',
        'SRE ITAJUBÁ'
    ),
(
        '54810',
        'EE ANTÔNIO CARLOS',
        'CONCEIÇÃO DAS PEDRAS',
        'SRE ITAJUBÁ'
    ),
(
        '54836',
        'EE JOÃO RIBEIRO DE CARVALHO',
        'CONCEIÇÃO DOS OUROS',
        'SRE ITAJUBÁ'
    ),
(
        '54852',
        'EE PROFESSOR FRANCISCO MANOEL DO NASCIMENTO',
        'CONSOLAÇÃO',
        'SRE ITAJUBÁ'
    ),
(
        '54933',
        'EE CÔNEGO ARTÊMIO SCHIAVON',
        'CRISTINA',
        'SRE ITAJUBÁ'
    ),
(
        '54992',
        'EE LUIZ FRANCISCO RIBEIRO',
        'DELFIM MOREIRA',
        'SRE ITAJUBÁ'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '55000',
        'EE MARQUÊS DE SAPUCAÍ',
        'DELFIM MOREIRA',
        'SRE ITAJUBÁ'
    ),
(
        '305375',
        'EE CÔNEGO JOSÉ DIVINO',
        'DOM VIÇOSO',
        'SRE ITAJUBÁ'
    ),
(
        '55182',
        'EE JOÃO RIBEIRO DA SILVA',
        'GONÇALVES',
        'SRE ITAJUBÁ'
    ),
(
        '55565',
        'CESEC PADRE MÁRIO PENOCK',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55298',
        'EE ANA LAURA PEREIRA',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55301',
        'EE BARÃO DO RIO BRANCO',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55344',
        'EE CORONEL CARNEIRO JÚNIOR',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55361',
        'EE CORONEL CASIMIRO OSÓRIO',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55531',
        'EE FLORIVAL XAVIER',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55425',
        'EE JOÃO XXIII',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55433',
        'EE MAJOR JOÃO PEREIRA',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55573',
        'EE NOVO TEMPO- EDUCAÇÃO ESPECIAL',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55441',
        'EE PROFESSOR ANTÔNIO RODRIGUES D'' OLIVEIRA',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55492',
        'EE SILVÉRIO SANCHES',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55514',
        'EE WENCESLAU  BRAZ',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '55697',
        'EE NOSSA SENHORA DE LOURDES',
        'MARIA DA FÉ',
        'SRE ITAJUBÁ'
    ),
(
        '55735',
        'EE RENASCER - EDUCAÇÃO ESPECIAL',
        'MARIA DA FÉ',
        'SRE ITAJUBÁ'
    ),
(
        '55743',
        'EE SÃO JOSÉ',
        'MARIA DA FÉ',
        'SRE ITAJUBÁ'
    ),
(
        '55751',
        'EE ALBANO DE OLIVEIRA',
        'MARMELÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '55867',
        'EE JOÃO GOULART SANTIAGO BRUM',
        'NATÉRCIA',
        'SRE ITAJUBÁ'
    ),
(
        '56006',
        'EE ANTÔNIO EUFRÁSIO DE TOLEDO',
        'PARAISÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '305383',
        'EE EULÁLIA GOMES DE OLIVEIRA',
        'PARAISÓPOLIS',
        'SRE ITAJUBÁ'
    ),
(
        '56081',
        'EE COMENDADOR MÁRIO GOULART SANTIAGO',
        'PEDRALVA',
        'SRE ITAJUBÁ'
    ),
(
        '56201',
        'EE PROFESSOR ARCÁDIO NASCIMENTO MOURA',
        'PEDRALVA',
        'SRE ITAJUBÁ'
    ),
(
        '56235',
        'EE MÁRIO CASASSANTA',
        'PIRANGUÇU',
        'SRE ITAJUBÁ'
    ),
(
        '56294',
        'EE SEBASTIÃO PEREIRA MACHADO',
        'PIRANGUINHO',
        'SRE ITAJUBÁ'
    ),
(
        '56669',
        'EE MARIA LINA DE JESUS',
        'SÃO JOSÉ DO ALEGRE',
        'SRE ITAJUBÁ'
    ),
(
        '56693',
        'EE PROFESSOR FIGUEIREDO BRANDÃO',
        'SAPUCAÍ-MIRIM',
        'SRE ITAJUBÁ'
    ),
(
        '175137',
        'EE DELFIM MOREIRA',
        'VIRGÍNIA',
        'SRE ITAJUBÁ'
    ),
(
        '175153',
        'EE PROFESSOR MANOEL MACHADO',
        'VIRGÍNIA',
        'SRE ITAJUBÁ'
    ),
(
        '56812',
        'EE MAJOR LISBOA DA CUNHA',
        'WENCESLAU BRAZ',
        'SRE ITAJUBÁ'
    ),
(
        '322814',
        'EE JOÃO GONÇALVES DE OLIVEIRA',
        'CACHOEIRA DOURADA',
        'SRE ITUIUTABA'
    ),
(
        '312045',
        'EE JOSÉ EZEQUIEL DE QUEIRÓS',
        'CANÁPOLIS',
        'SRE ITUIUTABA'
    ),
(
        '196380',
        'EE SÃO FRANCISCO DE ASSIS',
        'CANÁPOLIS',
        'SRE ITUIUTABA'
    ),
(
        '196401',
        'EE GOVERNADOR JUSCELINO',
        'CAPINÓPOLIS',
        'SRE ITUIUTABA'
    ),
(
        '196398',
        'EE SÉRGIO DE FREITAS PACHECO',
        'CAPINÓPOLIS',
        'SRE ITUIUTABA'
    ),
(
        '196436',
        'EE BELCHIOR DE FARIA',
        'CENTRALINA',
        'SRE ITUIUTABA'
    ),
(
        '196452',
        'EE WILSON DE MELO',
        'CENTRALINA',
        'SRE ITUIUTABA'
    ),
(
        '196461',
        'EE DE GURINHATÃ',
        'GURINHATÃ',
        'SRE ITUIUTABA'
    ),
(
        '196487',
        'EE HEITOR JOSÉ DE CASTRO',
        'GURINHATÃ',
        'SRE ITUIUTABA'
    ),
(
        '196517',
        'EE BENEDITO WALDEMAR DA SILVA',
        'IPIAÇU',
        'SRE ITUIUTABA'
    ),
(
        '196703',
        'CESEC CLORINDA MARTINS TAVARES',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196631',
        'EE ANTÔNIO SOUZA MARTINS',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196576',
        'EE ARTHUR JUNQUEIRA DE ALMEIDA',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196541',
        'EE CÔNEGO ÂNGELO',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196525',
        'EE CORONEL JOÃO MARTINS',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196533',
        'EE CORONEL TONICO FRANCO',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196711',
        'EE DE EDUCAÇÃO ESPECIAL RISOLETA NEVES',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196550',
        'EE DOUTOR FERNANDO ALEXANDRE',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196568',
        'EE GOVERNADOR BIAS FORTES',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196681',
        'EE GOVERNADOR CLÓVIS SALGADO',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196584',
        'EE GOVERNADOR ISRAEL PINHEIRO',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196606',
        'EE JOÃO PINHEIRO',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196657',
        'EE PROFESSOR ÁLVARO BRANDÃO DE ANDRADE',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196592',
        'EE PROFESSORA MARIA DE BARROS',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196665',
        'EE ROTARY',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196673',
        'EE SENADOR CAMILO CHAVES',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '196738',
        'EE JOSÉ PARANAÍBA',
        'SANTA VITÓRIA',
        'SRE ITUIUTABA'
    ),
(
        '196720',
        'EE PREFEITO JOSÉ FRANCO DE GOUVEIA',
        'SANTA VITÓRIA',
        'SRE ITUIUTABA'
    ),
(
        '338672',
        'EE PROFESSORA DIRCE MARIA DE OLIVEIRA',
        'SANTA VITÓRIA',
        'SRE ITUIUTABA'
    ),
(
        '239194',
        'EE JOAQUIM TEIXEIRA DE BRITO',
        'CATUTI',
        'SRE JANAÚBA'
    ),
(
        '80861',
        'EE JOSÉ BARBOSA DE SOUZA',
        'CATUTI',
        'SRE JANAÚBA'
    ),
(
        '362484',
        'EE ALVACY DE FREITAS',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '212261',
        'EE BETÂNIA TOLENTINO SILVEIRA',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80080',
        'EE COMENDADOR VIANA',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80187',
        'EE DOM LÚCIO',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80195',
        'EE JOAQUIM DE FREITAS',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80101',
        'EE MANOEL DOS SANTOS',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80144',
        'EE PROFESSORA ADALGISA F RIBEIRO',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80217',
        'EE PROFESSORA JOANA PORTO',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '218286',
        'EE SANTOS DUMONT',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '218294',
        'EE STA TEREZINHA',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80209',
        'EE VIRGÍNIO CRUZ',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '80233',
        'EE WASHINGTON XAVIER MENDES',
        'ESPINOSA',
        'SRE JANAÚBA'
    ),
(
        '81035',
        'EE DE BREJO DOS MÁRTIRES',
        'GAMELEIRAS',
        'SRE JANAÚBA'
    ),
(
        '81221',
        'EE DE GAMELEIRA',
        'GAMELEIRAS',
        'SRE JANAÚBA'
    ),
(
        '62812',
        'EE AUGUSTO MARTINS FERREIRA',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '231843',
        'EE DO NÚCLEO HABITACIONAL I',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '62871',
        'EE DO POVOADO FRENTE TRÊS',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '62791',
        'EE DOUTOR CARLOS ANTÔNIO VELLOSO COSTA',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '295086',
        'EE GUIMARÃES ROSA',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '62863',
        'EE JOSÉ SANTOS DA PAIXÃO',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '231835',
        'EE PEQUENOS IRRIGANTES',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '81248',
        'EE PROFESSORA CLARA MENEZES DIAS',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '239208',
        'EE TIMÓTEO LISBOA GUERRA',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '81230',
        'EE VENCESLAU BRÁS',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '62847',
        'EE ZOÉ MACHADO',
        'JAÍBA',
        'SRE JANAÚBA'
    ),
(
        '80578',
        'CESEC PADRE CLETO ALTOÉ',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80560',
        'EE BARÃO DE GORUTUBA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80659',
        'EE BARREIRO DA RAIZ',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '218251',
        'EE CECÍLIA MARIA DE JESUS',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80586',
        'EE DE CANAFÍSTULA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '338680',
        'EE DOUTOR JOSÉ ESTEVES RODRIGUES',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80594',
        'EE EUCLIDES DA CUNHA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '233374',
        'EE JOAQUIM MAURÍCIO DE AZEVEDO',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80535',
        'EE JOSÉ GORUTUBA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '338699',
        'EE JULIÃO MENDES FERREIRA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80641',
        'EE LUZIA MENDES SIQUEIRA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80608',
        'EE MAURÍCIO AUGUSTO DE AZEVEDO',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80616',
        'EE PREFEITO MAURÍCIO DE AZEVEDO',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '218260',
        'EE PROFESSORA DIVA PINTO',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80624',
        'EE PROFESSORA NHA-GUI AZEVEDO',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80632',
        'EE RÔMULO SALES DE AZEVEDO',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '80241',
        'EE ARISTIDES JOSÉ TOLENTINO',
        'MAMONAS',
        'SRE JANAÚBA'
    ),
(
        '80829',
        'EE EDUARDO FRIEIRO',
        'MATO VERDE',
        'SRE JANAÚBA'
    ),
(
        '80870',
        'EE ERÓDIAS ALVES CAMARGO',
        'MATO VERDE',
        'SRE JANAÚBA'
    ),
(
        '80853',
        'EE IONE SILVEIRA MENDES',
        'MATO VERDE',
        'SRE JANAÚBA'
    ),
(
        '239186',
        'EE IRÊNIO PINHEIRO',
        'MATO VERDE',
        'SRE JANAÚBA'
    ),
(
        '80837',
        'EE PROFESSOR JOSÉ AMÉRICO BARBOSA',
        'MATO VERDE',
        'SRE JANAÚBA'
    ),
(
        '81167',
        'EE ANTÔNIO CARDOSO DA SILVA',
        'MONTE AZUL',
        'SRE JANAÚBA'
    ),
(
        '81094',
        'EE DE MONTE AZUL',
        'MONTE AZUL',
        'SRE JANAÚBA'
    ),
(
        '81027',
        'EE DOMINGOS TEIXEIRA DA SILVA',
        'MONTE AZUL',
        'SRE JANAÚBA'
    ),
(
        '81001',
        'EE FLORÊNCIO FERREIRA LIMA',
        'MONTE AZUL',
        'SRE JANAÚBA'
    ),
(
        '81043',
        'EE RODRIGUES ALVES',
        'MONTE AZUL',
        'SRE JANAÚBA'
    ),
(
        '81060',
        'EE TANCREDO NEVES',
        'MONTE AZUL',
        'SRE JANAÚBA'
    ),
(
        '82295',
        'EE EDSON ALVES PEREIRA',
        'MONTEZUMA',
        'SRE JANAÚBA'
    ),
(
        '82309',
        'EE HERCULANO MARTINS',
        'MONTEZUMA',
        'SRE JANAÚBA'
    ),
(
        '205648',
        'EE EREZINHA ANTUNES MARTINS',
        'NOVA PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82104',
        'EE INSPETOR LUIZ PEDRO',
        'NOVA PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '91600',
        'EE RUI BARBOSA',
        'NOVA PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82147',
        'EE SANTOS DUMONT',
        'PAI PEDRO',
        'SRE JANAÚBA'
    ),
(
        '82091',
        'CESEC BELINHA ROSA DE JESUS',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82031',
        'EE ALCIDES MENDES DA SILVA',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82112',
        'EE ANTÔNIO MENDES DA SILVA',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82040',
        'EE ANTÔNIO SANTOS',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82155',
        'EE DOUTOR ROCKERT',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '91243',
        'EE IDALINA ADELAIDE DOS SANTOS',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82058',
        'EE JOÃO ALCÂNTARA',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '91596',
        'EE JOAQUIM MARCELINO DA CONCEIÇÃO',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '338702',
        'EE MESTRE TOMAZ VALERIANO DE ARAÚJO',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82074',
        'EE MIGUEL JOSÉ DA CUNHA',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82023',
        'EE NECO LOPES',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82066',
        'EE ODILON COELHO',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82082',
        'EE PROFESSOR DINOE MENDES',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '82171',
        'EE EDISTON ALVES DE SOUZA',
        'RIACHO DOS MACHADOS',
        'SRE JANAÚBA'
    ),
(
        '82244',
        'EE DA FAZENDA PALMEIRAS',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '349267',
        'EE DE ENSINO MÉDIO',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82236',
        'EE DO POVOADO DE NOVA AURORA',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82201',
        'EE ELESBÃO JOSÉ DOS SANTOS',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82341',
        'EE ELPÍDIO RIBEIRO DOS SANTOS',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82368',
        'EE GERALDINO FRANCISCO DA SILVA',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82228',
        'EE JOSÉ CRISTIANO',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82333',
        'EE NORBERTO DE ALMEIDA ROCHA',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '212253',
        'EE PROFESSORA MARLENE CARMO',
        'RIO PARDO DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '82325',
        'EE PREFEITO ODÍLIO FERNANDES COSTA',
        'SANTO ANTÔNIO DO RETIRO',
        'SRE JANAÚBA'
    ),
(
        '82121',
        'EE ANANIAS ALVES',
        'SERRANÓPOLIS DE MINAS',
        'SRE JANAÚBA'
    ),
(
        '351091',
        'EE ALICE DE JESUS RODRIGUES',
        'VERDELÂNDIA',
        'SRE JANAÚBA'
    ),
(
        '351083',
        'EE ANTONINA FERNANDES SAMPAIO',
        'VERDELÂNDIA',
        'SRE JANAÚBA'
    ),
(
        '63592',
        'EE MARIA MATOS SILVA',
        'VERDELÂNDIA',
        'SRE JANAÚBA'
    ),
(
        '205532',
        'EE CESÁRIO NUNES DOS SANTOS',
        'BONITO DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '205516',
        'EE DE BONFIM',
        'BONITO DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '369810',
        'EE DE ENSINO FUNDAMENTAL ANOS FINAIS E ENSINO MÉDIO',
        'BONITO DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '205451',
        'EE MANOEL PEREIRA MAGALHÃES',
        'BONITO DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '62502',
        'EE PROFESSOR HENRIQUE DE MATOS',
        'BONITO DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '205508',
        'EE SÃO JOSÉ DO GIBÃO',
        'BONITO DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '63410',
        'EE DA FAZENDA SANTA CATARINA',
        'CHAPADA GAÚCHA',
        'SRE JANUÁRIA'
    ),
(
        '205460',
        'EE MOACIR CÂNDIDO',
        'CHAPADA GAÚCHA',
        'SRE JANUÁRIA'
    ),
(
        '63151',
        'EE SERRA DAS ARARAS',
        'CHAPADA GAÚCHA',
        'SRE JANUÁRIA'
    ),
(
        '62545',
        'EE DE CÔNEGO MARINHO',
        'CÔNEGO MARINHO',
        'SRE JANUÁRIA'
    ),
(
        '62561',
        'EE DE CRUZ DOS ARAÚJOS',
        'CÔNEGO MARINHO',
        'SRE JANUÁRIA'
    ),
(
        '369829',
        'EE DE ENSINO FUNDAMENTAL ANOS FINAIS E ENSINO MÉDIO',
        'CÔNEGO MARINHO',
        'SRE JANUÁRIA'
    ),
(
        '62553',
        'EE DE OLHOS D''ÁGUA',
        'CÔNEGO MARINHO',
        'SRE JANUÁRIA'
    ),
(
        '62570',
        'EE PROFESSORA MARIA GIL DE ALMEIDA DOS SANTOS',
        'CÔNEGO MARINHO',
        'SRE JANUÁRIA'
    ),
(
        '63576',
        'EE MARIA BARBOSA LEITE',
        'IBIRACATU',
        'SRE JANUÁRIA'
    ),
(
        '63541',
        'EE ORLANDO AMADOR MELO',
        'IBIRACATU',
        'SRE JANUÁRIA'
    ),
(
        '63550',
        'EE VICENTE MARTINS PEREIRA',
        'IBIRACATU',
        'SRE JANUÁRIA'
    ),
(
        '63258',
        'EE JOSÉ BERNARDINO',
        'ICARAÍ DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '63266',
        'EE LÍDIA VIEIRA GUIMARÃES',
        'ICARAÍ DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '63274',
        'EE MANOEL TIBÉRIO',
        'ICARAÍ DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '63240',
        'EE OLHOS D''ÁGUA',
        'ICARAÍ DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '63282',
        'EE SANTOS REIS',
        'ICARAÍ DE MINAS',
        'SRE JANUÁRIA'
    ),
(
        '62324',
        'EE DA VILA FLORENTINA',
        'ITACARAMBI',
        'SRE JANUÁRIA'
    ),
(
        '62308',
        'EE PROFESSOR JOSEFINO  BARBOSA',
        'ITACARAMBI',
        'SRE JANUÁRIA'
    ),
(
        '62278',
        'EE SATURNINO ÂNGELO DA SILVA',
        'ITACARAMBI',
        'SRE JANUÁRIA'
    ),
(
        '62464',
        'EE ANTÔNIO CORREA E SILVA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '246271',
        'EE ANTÔNIO FERNANDES VIANA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62375',
        'EE BIAS FORTES',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62391',
        'EE CAIO MARTINS',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62511',
        'EE CÔNEGO RAMIRO LEITE',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62693',
        'EE DA FAZENDA BARRA DO REMANSINHO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '212822',
        'EE DE BOA VISTA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '356778',
        'EE DE ENSINO MÉDIO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62600',
        'EE DE FABIÃO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62537',
        'EE DE NOVA ODESSA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62448',
        'EE DOUTOR TANCREDO DE ALMEIDA NEVES',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '253685',
        'EE EULER TUPINÁ BASTOS',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62707',
        'EE FAUSTINO PACHECO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '253677',
        'EE FELIPE DIAS CORRÊA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62677',
        'EE FRANCISCO VIANA DE MATOS',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62669',
        'EE JOSÉ MANOEL CIRINO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62651',
        'EE LINDOLFO CARLOS FERREIRA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '246280',
        'EE MARIA ROSA NUNES',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62642',
        'EE MONSENHOR FLORISVAL MONTALVÃO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62430',
        'EE MONSENHOR JOÃO FLORISVAL MONTALVÃO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62529',
        'EE NARCIZA DAS CHAGAS SANTOS PACHECO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62456',
        'EE NOSSA SENHORA DE FÁTIMA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '253651',
        'EE NOVA ESPERANÇA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62472',
        'EE OLEGÁRIO MACIEL',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62499',
        'EE PIO XII',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62367',
        'EE PRINCESA JANUÁRIA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62421',
        'EE PROFESSOR BATISTINHA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62383',
        'EE PROFESSOR CLAUDEMIRO ALVES FERREIRA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62481',
        'EE PROFESSOR ONÉSIMO BASTOS',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62405',
        'EE PROFESSORA ZINA PORTO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62715',
        'EE SÃO JOSÉ',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62413',
        'EE SIMÃO VIANNA DA CUNHA PEREIRA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '62995',
        'EE ANTÔNIO ORTIGA',
        'JUVENÍLIA',
        'SRE JANUÁRIA'
    ),
(
        '63002',
        'EE CORONEL ALMEIDA',
        'JUVENÍLIA',
        'SRE JANUÁRIA'
    ),
(
        '63011',
        'EE DE MONTE REI',
        'JUVENÍLIA',
        'SRE JANUÁRIA'
    ),
(
        '342726',
        'EE MANOEL FERNANDES DA SILVA',
        'JUVENÍLIA',
        'SRE JANUÁRIA'
    ),
(
        '62731',
        'EE DE BREJO SÃO CAETANO DO JAPURÉ',
        'MANGA',
        'SRE JANUÁRIA'
    ),
(
        '62766',
        'EE MINISTRO PETRÔNIO PORTELA',
        'MANGA',
        'SRE JANUÁRIA'
    ),
(
        '62758',
        'EE PRESIDENTE OLEGÁRIO MACIEL',
        'MANGA',
        'SRE JANUÁRIA'
    ),
(
        '62774',
        'EE PRESIDENTE TANCREDO DE ALMEIDA NEVES',
        'MANGA',
        'SRE JANUÁRIA'
    ),
(
        '62928',
        'EE PROFESSOR JOSÉ RIBEIRO CAMPOS',
        'MANGA',
        'SRE JANUÁRIA'
    ),
(
        '342734',
        'EE DE ENSINO MÉDIO',
        'MATIAS CARDOSO',
        'SRE JANUÁRIA'
    ),
(
        '62910',
        'EE DO POVOADO DE RANCHO GRANDE',
        'MATIAS CARDOSO',
        'SRE JANUÁRIA'
    ),
(
        '62821',
        'EE DOM BOSCO',
        'MATIAS CARDOSO',
        'SRE JANUÁRIA'
    ),
(
        '62901',
        'EE DA FAZENDA CRISTO REI',
        'MIRAVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '62898',
        'EE DONA MARIA CARLOS DA MOTA',
        'MIRAVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '217913',
        'EE DA VILA NOVO HORIZONTE',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '63061',
        'EE DE CACHOEIRA',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '62961',
        'EE DE MONTALVÂNIA',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '63037',
        'EE DO POVOADO SANTA RITA DE CANABRAVA',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '62952',
        'EE GALILEU GALILEI',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '62987',
        'EE INCONFIDENTES',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '63053',
        'EE SÃO SEBASTIÃO DE POÇÕES',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '62626',
        'EE DE PEDRAS DE MARIA DA CRUZ',
        'PEDRAS DE MARIA DA CRUZ',
        'SRE JANUÁRIA'
    ),
(
        '239429',
        'EE DE POÇÃOZINHO',
        'PEDRAS DE MARIA DA CRUZ',
        'SRE JANUÁRIA'
    ),
(
        '239330',
        'EE DONA CILA',
        'PEDRAS DE MARIA DA CRUZ',
        'SRE JANUÁRIA'
    ),
(
        '62685',
        'EE SANTA LUZIA',
        'PEDRAS DE MARIA DA CRUZ',
        'SRE JANUÁRIA'
    ),
(
        '63363',
        'EE ARTUR JOSÉ DOS PASSOS',
        'PINTÓPOLIS',
        'SRE JANUÁRIA'
    ),
(
        '253847',
        'EE PRIMAVERA',
        'PINTÓPOLIS',
        'SRE JANUÁRIA'
    ),
(
        '63401',
        'EE RIACHO FUNDO',
        'PINTÓPOLIS',
        'SRE JANUÁRIA'
    ),
(
        '63185',
        'EE ADÃO VIEIRA DA ROCHA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63347',
        'EE ADEMAR CANGUSSU',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63355',
        'EE BARREIRA DOS ÍNDIOS',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '240222',
        'EE BRASILIANO BRAZ',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63223',
        'EE CLEMÊNCIA RODRIGUES',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63070',
        'EE COELHO NETO',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '239411',
        'EE DA FAZENDA PASSAGEM FUNDA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63096',
        'EE DONA ALICE MENDONÇA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63100',
        'EE DOUTOR TARCÍSIO GENEROSO',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63312',
        'EE ELPÍDIO FONSECA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '253588',
        'EE EPAMINONDAS LEITE',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '239313',
        'EE EVERARDO GONÇALVES BOTELHO',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63126',
        'EE JACINTO DE MAGALHÃES',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63177',
        'EE JOAQUIM VIEIRA DE ARAÚJO',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63231',
        'EE JOSÉ FRANCISCO GUIMARÃES',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63134',
        'EE MESTRA HERCÍLIA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63142',
        'EE PROFESSOR RAUL REGINALDO',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63193',
        'EE SAGRADA FAMÍLIA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '63398',
        'EE SEBASTIANA PEREIRA DA SILVA',
        'SÃO FRANCISCO',
        'SRE JANUÁRIA'
    ),
(
        '338761',
        'EE ALINE DIAS NEVES',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '62316',
        'EE ELIAZAR JOSÉ RODRIGUES',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '269875',
        'EE INDÍGENA BUKIMUJU',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '322571',
        'EE INDÍGENA BUKINUK',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '369837',
        'EE INDÍGENA DE EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '356786',
        'EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL E ENSINO MÉDIO',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '361461',
        'EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL E ENSINO MÉDIO',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '319058',
        'EE INDÍGENA KUHINAN XACRIABÁ',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '338753',
        'EE INDÍGENA MAMBUKA',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '338770',
        'EE INDÍGENA OAYTOMORIM',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '338745',
        'EE INDÍGENA UIKITU KUHINÃ',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '297518',
        'EE INDÍGENA XUKURANK',
        'SÃO JOÃO DAS MISSÕES',
        'SRE JANUÁRIA'
    ),
(
        '213543',
        'EE DA FAZENDA CAMPO LINDO',
        'UBAÍ',
        'SRE JANUÁRIA'
    ),
(
        '63461',
        'EE DOUTOR LUCÍLIO MESQUITA SOBRINHO',
        'UBAÍ',
        'SRE JANUÁRIA'
    ),
(
        '63487',
        'EE GUSTAVO FREIRE',
        'UBAÍ',
        'SRE JANUÁRIA'
    ),
(
        '63452',
        'EE MARIA BATISTA CAVALCANTI',
        'UBAÍ',
        'SRE JANUÁRIA'
    ),
(
        '63479',
        'EE PROFESSORA HILDA BRAGA',
        'UBAÍ',
        'SRE JANUÁRIA'
    ),
(
        '63428',
        'EE ANTÔNIO ESTEVES DOS ANJOS',
        'URUCUIA',
        'SRE JANUÁRIA'
    ),
(
        '253499',
        'EE AMÉLIA CAVALCANTE PIMENTA',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '63517',
        'EE DEPUTADO EDGAR PEREIRA',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '253481',
        'EE DEUSÂNIA DE BRITO SALES',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '253511',
        'EE GILBERTO ALVES COUTINHO',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '217344',
        'EE ISABEL SOARES DE JESUS',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '63568',
        'EE JOÃO ALVES DOS SANTOS',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '63525',
        'EE JOÃO CARDOSO GODINHO',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '213527',
        'EE JOSÉ FERNANDES DE SOUZA',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '223999',
        'EE JUCA VELOSO',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '217352',
        'EE MANOEL ALVES DE ALMEIDA',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '253472',
        'EE NILZA MARIA DOS SANTOS',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '63509',
        'EE PADRE JOSÉ SILVEIRA',
        'VARZELÂNDIA',
        'SRE JANUÁRIA'
    ),
(
        '67881',
        'EE PADRE FRANCISCO REY',
        'ARANTINA',
        'SRE JUIZ DE FORA'
    ),
(
        '67890',
        'EE DE BELMIRO BRAGA',
        'BELMIRO BRAGA',
        'SRE JUIZ DE FORA'
    ),
(
        '68021',
        'EE DEPUTADO OLIVEIRA SOUZA',
        'BICAS',
        'SRE JUIZ DE FORA'
    ),
(
        '68071',
        'EE NOSSA SENHORA APARECIDA',
        'BOM JARDIM DE MINAS',
        'SRE JUIZ DE FORA'
    ),
(
        '68195',
        'EE BARÃO DO RETIRO',
        'CHÁCARA',
        'SRE JUIZ DE FORA'
    ),
(
        '346217',
        'EE SANTO ANTÔNIO',
        'CHIADOR',
        'SRE JUIZ DE FORA'
    ),
(
        '322512',
        'EE PROFESSOR MILTON SANTOS',
        'CORONEL PACHECO',
        'SRE JUIZ DE FORA'
    ),
(
        '68276',
        'EE FRANCISCO MANUEL',
        'DESCOBERTO',
        'SRE JUIZ DE FORA'
    ),
(
        '68292',
        'EE ANTÔNIO MACEDO',
        'EWBANK DA CÂMARA',
        'SRE JUIZ DE FORA'
    ),
(
        '369845',
        'EE CARLOS HENRIQUE RIBEIRO DOS SANTOS',
        'GOIANÁ',
        'SRE JUIZ DE FORA'
    ),
(
        '69574',
        'EE TOLOMEU CASALI',
        'GOIANÁ',
        'SRE JUIZ DE FORA'
    ),
(
        '330558',
        'EE PROFESSOR IRINEU GUIMARÃES',
        'GUARARÁ',
        'SRE JUIZ DE FORA'
    ),
(
        '68349',
        'EE ALI HALFELD',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68381',
        'EE ALMIRANTE BARROSO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68403',
        'EE ANA SALLES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68420',
        'EE ANTÔNIO CARLOS',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68462',
        'EE BATISTA DE OLIVEIRA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68489',
        'EE BERNARDO MASCARENHAS',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68543',
        'EE CLORINDO BURNIER',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68501',
        'EE CORONEL ANTONIO ALVES TEIXEIRA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68527',
        'EE CORONEL MANUEL CARNEIRO DAS NEVES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '326801',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '326810',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68586',
        'EE DELFIM MOREIRA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68608',
        'EE DEPUTADO OLAVO COSTA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68624',
        'EE DILERMANDO COSTA CRUZ',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68667',
        'EE DOUTOR CLEMENTE MARIANI',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68683',
        'EE DUARTE DE ABREU',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68705',
        'EE DUQUE DE CAXIAS',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68331',
        'EE FERNANDO LOBO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68373',
        'EE FRANCISCO BERNARDINO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68411',
        'EE GOVERNADOR JUSCELINO KUBITSCHEK',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68454',
        'EE HENRIQUE BURNIER',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68497',
        'EE HERMENEGILDO VILAÇA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68471',
        'EE MARECHAL MASCARENHAS DE MORAES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68632',
        'EE MARIA DAS DORES DE SOUZA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68691',
        'EE MARIA DE MAGALHÃES PINTO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68675',
        'EE MARIA ELBA BRAGA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68713',
        'EE MARIA ILYDIA RESENDE ANDRADE',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68748',
        'EE MARIANO PROCÓPIO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68721',
        'EE MERCEDES NERY MACHADO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '342637',
        'EE NYRCE VILLA VERDE COELHO DE MAGALHÃES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68756',
        'EE PADRE FREDERICO VIENKEN S V D',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68764',
        'EE PRESIDENTE COSTA E SILVA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68772',
        'EE PROFESSOR CÂNDIDO MOTTA FILHO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68616',
        'EE PROFESSOR FRANCISCO FARIA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68781',
        'EE PROFESSOR JOSÉ EUTRÓPIO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68799',
        'EE PROFESSOR JOSÉ FREIRE',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68802',
        'EE PROFESSOR JOSÉ SAINT CLAIR M ALVES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68811',
        'EE PROFESSOR LINDOLFO GOMES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68829',
        'EE PROFESSOR LOPES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68837',
        'EE PROFESSOR QUESNEL',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68845',
        'EE PROFESSOR TEODORO COELHO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68853',
        'EE SÃO VICENTE DE PAULO',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68861',
        'EE SEBASTIÃO PATRUS DE SOUSA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68519',
        'EE TEODORICO RIBEIRO DE ASSIS',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68535',
        'INSTITUTO ESTADUAL DE EDUCAÇÃO DE JUIZ DE FORA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '68888',
        'INSTITUTO ESTADUAL DE LATÍCINIOS CÂNDIDO TOSTES',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '69108',
        'CESEC DE LIMA DUARTE',
        'LIMA DUARTE',
        'SRE JUIZ DE FORA'
    ),
(
        '69019',
        'EE ADALGISA DE PAULA DUQUE',
        'LIMA DUARTE',
        'SRE JUIZ DE FORA'
    ),
(
        '69094',
        'EE JOAQUIM DELGADO DE PAIVA',
        'LIMA DUARTE',
        'SRE JUIZ DE FORA'
    ),
(
        '69027',
        'EE TIAGO DELGADO',
        'LIMA DUARTE',
        'SRE JUIZ DE FORA'
    ),
(
        '69230',
        'EE DE MAR DE ESPANHA',
        'MAR DE ESPANHA',
        'SRE JUIZ DE FORA'
    ),
(
        '69191',
        'EE ESTÊVÃO PINTO',
        'MAR DE ESPANHA',
        'SRE JUIZ DE FORA'
    ),
(
        '69264',
        'EE MANNARINO LUIGI',
        'MAR DE ESPANHA',
        'SRE JUIZ DE FORA'
    ),
(
        '322539',
        'EE PREFEITO WALTER TREZZA',
        'MARIPÁ DE MINAS',
        'SRE JUIZ DE FORA'
    ),
(
        '69353',
        'EE CÔNEGO JOAQUIM MONTEIRO',
        'MATIAS BARBOSA',
        'SRE JUIZ DE FORA'
    ),
(
        '330566',
        'EE JOAQUIM ALVES DE CARVALHO',
        'OLARIA',
        'SRE JUIZ DE FORA'
    ),
(
        '338788',
        'EE DE ENSINO MÉDIO',
        'PEDRO TEIXEIRA',
        'SRE JUIZ DE FORA'
    ),
(
        '322547',
        'EE PADRE JOÃO BATISTA DE OLIVEIRA',
        'PEQUERI',
        'SRE JUIZ DE FORA'
    ),
(
        '69469',
        'EE SÃO PEDRO',
        'PIAU',
        'SRE JUIZ DE FORA'
    ),
(
        '69507',
        'EE OLYMPIO ARAÚJO',
        'RIO NOVO',
        'SRE JUIZ DE FORA'
    ),
(
        '69523',
        'EE RAULINO PACHECO',
        'RIO NOVO',
        'SRE JUIZ DE FORA'
    ),
(
        '69604',
        'EE DERMEVAL MOURA DE ALMEIDA',
        'RIO PRETO',
        'SRE JUIZ DE FORA'
    ),
(
        '342645',
        'EE DE ENSINO MÉDIO',
        'ROCHEDO DE MINAS',
        'SRE JUIZ DE FORA'
    ),
(
        '342653',
        'EE JOÃO AUGUSTO DA SILVA BARRETO',
        'SANTA BÁRBARA DO MONTE VERDE',
        'SRE JUIZ DE FORA'
    ),
(
        '69850',
        'EE JOSÉ MARINHO DE ARAÚJO',
        'SANTA RITA DE JACUTINGA',
        'SRE JUIZ DE FORA'
    ),
(
        '338796',
        'EE DYRCE JOSÉ  DA SILVA E SOUZA',
        'SANTANA DO DESERTO',
        'SRE JUIZ DE FORA'
    ),
(
        '69906',
        'EE CORNÉLIA FERREIRA LADEIRA',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69914',
        'EE DOUTOR VIEIRA BRAGA',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69931',
        'EE ENGENHEIRO HENRIQUE DUMONT',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69949',
        'EE GOVERNADOR BIAS FORTES',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69957',
        'EE JOÃO GOMES VELHO',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69965',
        'EE PADRE ANTÔNIO VIEIRA',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69973',
        'EE PRESIDENTE JOÃO PINHEIRO',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69981',
        'EE PROFESSORA JOANA CUNHA',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '69990',
        'EE VIEIRA MARQUES',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '70238',
        'EE DR FRANCISCO ZAGARI',
        'SÃO JOÃO NEPOMUCENO',
        'SRE JUIZ DE FORA'
    ),
(
        '70149',
        'EE OSWALDO CRUZ',
        'SÃO JOÃO NEPOMUCENO',
        'SRE JUIZ DE FORA'
    ),
(
        '70157',
        'EE PROFESSOR GABRIEL ARCANJO MENDONÇA',
        'SÃO JOÃO NEPOMUCENO',
        'SRE JUIZ DE FORA'
    ),
(
        '342661',
        'EE PROFESSORA ROMILDA BARBOSA',
        'SENADOR CORTES',
        'SRE JUIZ DE FORA'
    ),
(
        '338800',
        'EE DE ENSINO MÉDIO',
        'SIMÃO PEREIRA',
        'SRE JUIZ DE FORA'
    ),
(
        '96555',
        'EE BARÃO SÃO GERALDO',
        'ALÉM PARAÍBA',
        'SRE LEOPOLDINA'
    ),
(
        '96458',
        'EE DOUTOR ALFREDO CASTELO BRANCO',
        'ALÉM PARAÍBA',
        'SRE LEOPOLDINA'
    ),
(
        '96539',
        'EE SANTA RITA',
        'ALÉM PARAÍBA',
        'SRE LEOPOLDINA'
    ),
(
        '96512',
        'EE SÃO JOSÉ',
        'ALÉM PARAÍBA',
        'SRE LEOPOLDINA'
    ),
(
        '96521',
        'EE SEBASTIÃO CERQUEIRA',
        'ALÉM PARAÍBA',
        'SRE LEOPOLDINA'
    ),
(
        '305316',
        'EE PROFESSOR LUIZ ANTÔNIO PIRES DE SOUZA',
        'ARGIRITA',
        'SRE LEOPOLDINA'
    ),
(
        '97306',
        'EE ASTOLFO DUTRA',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97314',
        'EE CORONEL VIEIRA',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97331',
        'EE DOUTOR NORBERTO CUSTÓDIO FERREIRA',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97322',
        'EE FRANCISCO INÁCIO PEIXOTO',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97357',
        'EE GUIDO MARLIERE',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97365',
        'EE MANUEL INÁCIO PEIXOTO',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97373',
        'EE MARIETA SOARES TEIXEIRA',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97381',
        'EE PROFESSOR CLÓVIS SALGADO',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97403',
        'EE PROFESSOR QUARESMA',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '97799',
        'EE JOSÉ BITTENCOURT DE SOUZA',
        'ESTRELA DALVA',
        'SRE LEOPOLDINA'
    ),
(
        '305324',
        'EE ISA MORAES FREITAS',
        'ITAMARATI DE MINAS',
        'SRE LEOPOLDINA'
    ),
(
        '98175',
        'EE AUGUSTO DOS ANJOS',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98337',
        'EE DOUTOR POMPÍLIO GUIMARÃES',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98221',
        'EE EMÍLIO RAMOS PINTO',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98230',
        'EE ENÉAS FRANÇA',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98370',
        'EE JUSTINIANO FONSECA',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98256',
        'EE LUIZ SALGADO LIMA',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98345',
        'EE MARCO AURÉLIO MONTEIRO DE BARROS',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98264',
        'EE OMAR RESENDE PERES',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98302',
        'EE PROFESSOR BOTELHO REIS',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98353',
        'EE SEBASTIÃO MEDEIROS',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '98311',
        'EE SEBASTIÃO SILVA COUTINHO',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '99171',
        'EE CAPITÃO OVÍDIO LIMA',
        'PIRAPETINGA',
        'SRE LEOPOLDINA'
    ),
(
        '99252',
        'EE OLAVO BILAC',
        'RECREIO',
        'SRE LEOPOLDINA'
    ),
(
        '99295',
        'EE PRESIDENTE CARLOS LUZ',
        'RECREIO',
        'SRE LEOPOLDINA'
    ),
(
        '99376',
        'EE MIRANDA MANSO',
        'SANTO ANTÔNIO DO AVENTUREIRO',
        'SRE LEOPOLDINA'
    ),
(
        '99589',
        'EE CAPITÃO GODOY',
        'VOLTA GRANDE',
        'SRE LEOPOLDINA'
    ),
(
        '75736',
        'EE PADRE JÚLIO MARIA',
        'ALTO JEQUITIBÁ',
        'SRE MANHUAÇU'
    ),
(
        '75710',
        'EE PROFESSORA MARIA DA GLÓRIA VALLE',
        'ALTO JEQUITIBÁ',
        'SRE MANHUAÇU'
    ),
(
        '75728',
        'EE REVERENDO CÍCERO SIQUEIRA',
        'ALTO JEQUITIBÁ',
        'SRE MANHUAÇU'
    ),
(
        '74918',
        'EE PADRE ALFREDO KOBAL',
        'CAPUTIRA',
        'SRE MANHUAÇU'
    ),
(
        '74969',
        'EE GENTIL VASCONCELOS',
        'CHALÉ',
        'SRE MANHUAÇU'
    ),
(
        '74942',
        'EE JOÃO LÚCIO TRINDADE SOBRINHO',
        'CHALÉ',
        'SRE MANHUAÇU'
    ),
(
        '74926',
        'EE MANOEL FELISBERTO PEREIRA ALVIM',
        'CHALÉ',
        'SRE MANHUAÇU'
    ),
(
        '74977',
        'EE PROFESSOR SPERBER',
        'CHALÉ',
        'SRE MANHUAÇU'
    ),
(
        '74985',
        'EE GOVERNADOR JUSCELINO KUBITSCHEK',
        'CONCEIÇÃO DE IPANEMA',
        'SRE MANHUAÇU'
    ),
(
        '319066',
        'EE EMÍLIA MARIA DINIZ',
        'DURANDÉ',
        'SRE MANHUAÇU'
    ),
(
        '75477',
        'EE QUINCA FRANCO',
        'DURANDÉ',
        'SRE MANHUAÇU'
    ),
(
        '74993',
        'EE ANTÔNIO SATHLER',
        'LAJINHA',
        'SRE MANHUAÇU'
    ),
(
        '75035',
        'EE ARNALDO LEITE RIBEIRO',
        'LAJINHA',
        'SRE MANHUAÇU'
    ),
(
        '75001',
        'EE CAPITÃO NESTOR VIEIRA DE GOUVEIA',
        'LAJINHA',
        'SRE MANHUAÇU'
    ),
(
        '75051',
        'EE DOUTOR ADALMÁRIO JOSÉ DOS SANTOS',
        'LAJINHA',
        'SRE MANHUAÇU'
    ),
(
        '75027',
        'EE HERMÍNIA RIBEIRO DE SOUZA',
        'LAJINHA',
        'SRE MANHUAÇU'
    ),
(
        '75248',
        'EE JOAQUIM KNUPP',
        'LUISBURGO',
        'SRE MANHUAÇU'
    ),
(
        '75191',
        'CESEC PROFESSOR HIRAM DE CARVALHO',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75337',
        'EE ANA MENDES PEREIRA DUTRA',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '364940',
        'EE ANTÔNIO SILVA ROCHA',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75124',
        'EE ANTÔNIO WELERSON',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75141',
        'EE CORDOVIL PINTO COELHO',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75175',
        'EE DE EDUCAÇÃO ESPECIAL PEARL WHITE SLAIB FADLALA',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75167',
        'EE DE MANHUAÇU',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75353',
        'EE DE SÃO SEBASTIÃO DO SACRAMENTO',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75329',
        'EE DOUTOR ELÓY WERNER',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75132',
        'EE JOÃO XAVIER DA COSTA',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75159',
        'EE LUDOVINO ALVES FILGUEIRAS',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75345',
        'EE MANOEL AGOSTINHO FERREIRA',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75183',
        'EE MARIA DE LUCCA PINTO COELHO',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75213',
        'EE MONSENHOR GONZALEZ',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75116',
        'EE RENATO GUSMAN',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75221',
        'EE SALIME NACIF',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75094',
        'EE SÃO VICENTE DE PAULO',
        'MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75434',
        'CESEC JURACY BATISTA CORRÊA',
        'MANHUMIRIM',
        'SRE MANHUAÇU'
    ),
(
        '75388',
        'EE ALFREDO LIMA',
        'MANHUMIRIM',
        'SRE MANHUAÇU'
    ),
(
        '75400',
        'EE PROFESSOR JOSÉ VENÂNCIO FERREIRA',
        'MANHUMIRIM',
        'SRE MANHUAÇU'
    ),
(
        '75485',
        'EE DE MARTINS SOARES',
        'MARTINS SOARES',
        'SRE MANHUAÇU'
    ),
(
        '205541',
        'EE DO BAIRRO BOA VISTA',
        'MATIPÓ',
        'SRE MANHUAÇU'
    ),
(
        '75507',
        'EE JOSÉ MENDES MAGALHÃES',
        'MATIPÓ',
        'SRE MANHUAÇU'
    ),
(
        '75531',
        'EE MARIA VICÊNCIA BRANDÃO',
        'MATIPÓ',
        'SRE MANHUAÇU'
    ),
(
        '75523',
        'EE VALDOMIRO MAGALHÃES',
        'MATIPÓ',
        'SRE MANHUAÇU'
    ),
(
        '75493',
        'EE WALDOMIRO MENDES DE ALMEIDA',
        'MATIPÓ',
        'SRE MANHUAÇU'
    ),
(
        '312479',
        'CESEC VALDIR PINHEIRO DE LACERDA',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75621',
        'EE ÁLVARO SCHERRE',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75639',
        'EE ALZIRA FRANCISCA PEREIRA',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75558',
        'EE DIONYSIO COSTA',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75612',
        'EE DO BAIRRO CANTINHO DO CÉU',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75647',
        'EE EROTILDES HUBNER BORGES',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75655',
        'EE FRANCISCO CARLOS HUBNER',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75604',
        'EE LINA MARIA DO CARMO',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75680',
        'EE MARIA LUIZA ALVES VIEIRA',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75582',
        'EE MINISTRO FRANCISCO CAMPOS',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75671',
        'EE PROFESSORA LEVINDA ALVES DA SILVA',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75663',
        'EE PROFESSORA RITA TEIXEIRA DE LACERDA',
        'MUTUM',
        'SRE MANHUAÇU'
    ),
(
        '75256',
        'EE CARLOS NOGUEIRA DA GAMA',
        'REDUTO',
        'SRE MANHUAÇU'
    ),
(
        '75264',
        'EE DE JAGUARAÍ',
        'REDUTO',
        'SRE MANHUAÇU'
    ),
(
        '346381',
        'EE DALILA CERQUEIRA PESSOA',
        'SANTA MARGARIDA',
        'SRE MANHUAÇU'
    ),
(
        '75787',
        'EE DE RIBEIRÃO DE SÃO DOMINGOS',
        'SANTA MARGARIDA',
        'SRE MANHUAÇU'
    ),
(
        '346187',
        'EE VIOLETA MAGESTE PEREIRA',
        'SANTA MARGARIDA',
        'SRE MANHUAÇU'
    ),
(
        '75809',
        'EE CÉLIA PEREIRA MENDES',
        'SANTANA DO MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75825',
        'EE DE SANTA FILOMENA',
        'SANTANA DO MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75817',
        'EE DO POVOADO DE SANTA QUITÉRIA',
        'SANTANA DO MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75299',
        'EE AMÉLIA GOMES',
        'SÃO JOÃO DO MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75281',
        'EE PROFESSOR JUVENTINO NUNES',
        'SÃO JOÃO DO MANHUAÇU',
        'SRE MANHUAÇU'
    ),
(
        '75841',
        'EE OROSIMBO GOMES DE MORAES',
        'SÃO JOSÉ DO MANTIMENTO',
        'SRE MANHUAÇU'
    ),
(
        '75906',
        'EE DO POVOADO DE SÃO VICENTE',
        'SIMONÉSIA',
        'SRE MANHUAÇU'
    ),
(
        '75892',
        'EE JOÃO AUGUSTO DE CARVALHO',
        'SIMONÉSIA',
        'SRE MANHUAÇU'
    ),
(
        '75876',
        'EE JOVELINO DA TERRA PEREIRA',
        'SIMONÉSIA',
        'SRE MANHUAÇU'
    ),
(
        '75884',
        'EE PADRE MIGUEL',
        'SIMONÉSIA',
        'SRE MANHUAÇU'
    ),
(
        '75914',
        'EE SANTO APOLINÁRIO',
        'SIMONÉSIA',
        'SRE MANHUAÇU'
    ),
(
        '218723',
        'EE EFIGÊNIA DE BARROS OLIVEIRA',
        'BARÃO DE COCAIS',
        'SRE METROPOLITANA A'
    ),
(
        '7692',
        'EE JOSÉ MARIA DE MORAIS',
        'BARÃO DE COCAIS',
        'SRE METROPOLITANA A'
    ),
(
        '7706',
        'EE ODILON BEHRENS',
        'BARÃO DE COCAIS',
        'SRE METROPOLITANA A'
    ),
(
        '7714',
        'EE PADRE HEITOR',
        'BARÃO DE COCAIS',
        'SRE METROPOLITANA A'
    ),
(
        '307068',
        'CESEC POETA MURILO MENDES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1911',
        'EE ADALBERTO FERRAZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '264',
        'EE AFONSO PENA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '825',
        'EE ANA DE CARVALHO SILVEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1546',
        'EE ARTUR JOVIANO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1627',
        'EE ASSIS CHATEAUBRIAND',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1783',
        'EE AUGUSTO DE LIMA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1864',
        'EE BARÃO DE MACAÚBAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1945',
        'EE BARÃO DO RIO BRANCO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2003',
        'EE BENJAMIM GUIMARÃES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1384',
        'EE BOLIVAR TINOCO MINEIRO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '35',
        'EE BUENO BRANDÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1651',
        'EE CAMINHO A LUZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '671',
        'EE CARLOS CAMPOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '752',
        'EE CARLOS GÓES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1155',
        'EE CESÁRIO ALVIM',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1317',
        'EE CORAÇÃO EUCARÍSTICO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '1473',
        'EE CORONEL VICENTE TORRES JÚNIOR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '493',
        'EE DEPUTADO ILACIR PEREIRA LIMA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '655',
        'EE DO INSTITUTO AGRONÔMICO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '680',
        'EE DONA ARGENTINA VIANNA CASTELO BRANCO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '761',
        'EE DONA AUGUSTA GONÇALVES NOGUEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '507',
        'EE DULCE PINTO RODRIGUES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1244',
        'EE EFIGÊNIO SALLES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1481',
        'EE ENGENHEIRO PRADO LOPES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1562',
        'EE ENGENHEIRO SÍLVIO FONSECA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1228',
        'EE ESTEVÃO PINTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1805',
        'EE FLÁVIO DOS SANTOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1961',
        'EE FRANCISCO SALES - INSTITUTO DE DEFICIÊNCIA DA FALA E AUDIÇÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2011',
        'EE GERALDINA SOARES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2135',
        'EE GOVERNADOR MILTON CAMPOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '213',
        'EE HELENA PENA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '370',
        'EE HENRIQUE DINIZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2071',
        'EE ISABEL DA SILVA POLCK',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '892',
        'EE JOÃO ALPHONSUS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '973',
        'EE JOSÉ BONIFÁCIO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1058',
        'EE JOSÉ IZIDORO DE MIRANDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '337',
        'EE JOSÉ MENDES JÚNIOR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '322563',
        'EE JOVEM PROTAGONISTA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1171',
        'EE JÚLIA LOPES DE ALMEIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '322555',
        'EE LAR DOS MENINOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1295',
        'EE LAUDIEME VAZ DE MELO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1333',
        'EE LAURA DAS CHAGAS FERREIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1414',
        'EE LUIZ DE BESSA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1490',
        'EE MAESTRO VILLA LOBOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '78',
        'EE MAJOR DELFINO DE PAULA RICARDO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '230',
        'EE MARECHAL DEODORO DA FONSECA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '175',
        'EE MARIA DE LOURDES DE OLIVEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '396',
        'EE MARIANO DE ABREU',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2585',
        'EE MENDES PIMENTEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '876',
        'EE NECÉSIO TAVARES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1198',
        'EE OLEGÁRIO MACIEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1431',
        'EE ONDINA AMARAL BRANDÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1732',
        'EE PANDIÁ CALÓGERAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1813',
        'EE PAULO DAS GRAÇAS DA SILVA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1937',
        'EE PEDRO FRANCA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1970',
        'EE PEDRO II',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '60',
        'EE PERO VAZ DE CAMINHA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1066',
        'EE PESTALOZZI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '221',
        'EE PRESIDENTE ANTÔNIO CARLOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '302',
        'EE PRESIDENTE DUTRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1678',
        'EE PROFESSOR ANTÔNIO JOSÉ RIBEIRO FILHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '787',
        'EE PROFESSOR CAETANO AZEREDO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '698',
        'EE PROFESSOR GUILHERME AZEVEDO LAGE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '86',
        'EE PROFESSOR JOSÉ MESQUITA DE CARVALHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1261',
        'EE PROFESSOR LEOPOLDO DE MIRANDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '342432',
        'EE PROFESSOR NEIDSON RODRIGUES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1589',
        'EE PROFESSOR PEDRO ALEIXO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '342459',
        'EE PROFESSORA ALAÍDE LISBOA DE OLIVEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '342424',
        'EE PROFESSORA HENRIQUETA LISBOA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1821',
        'EE PROFESSORA MARIA AMÉLIA GUIMARÃES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2194',
        'EE PROFESSORA MARIA CECÍLIA DE MELO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2101',
        'EE SAGRADA FAMÍLIA I',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2143',
        'EE SAGRADA FAMÍLIA II',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '2186',
        'EE SANDOVAL DE AZEVEDO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '248',
        'EE SANTO AFONSO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '728',
        'EE SARAH KUBITSCHEK BAIRRO GRAÇA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '809',
        'EE SARAH KUBITSCHEK IPIRANGA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1040',
        'EE SARAH KUBITSCHEK SÃO GERALDO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1121',
        'EE SÉRGIA CALDEIRA ALKIMIN',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '281',
        'EE TÉCNICO INDUSTRIAL PROFESSOR FONTES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1449',
        'EE TITO FULGÊNCIO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1686',
        'EE WALT DISNEY',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '342440',
        'EE ZILDA ARNS NEUMANN',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '1996',
        'INSTITUTO DE EDUCAÇÃO DE MINAS GERAIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '485',
        'INSTITUTO SÃO RAFAEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '106020',
        'EE DOUTOR GAMA CERQUEIRA',
        'BELO VALE',
        'SRE METROPOLITANA A'
    ),
(
        '102806',
        'EE DE FELIPE',
        'BOM JESUS DO AMPARO',
        'SRE METROPOLITANA A'
    ),
(
        '102792',
        'EE EDMUNDO PENA',
        'BOM JESUS DO AMPARO',
        'SRE METROPOLITANA A'
    ),
(
        '8117',
        'EE MELO VIANA',
        'BONFIM',
        'SRE METROPOLITANA A'
    ),
(
        '351075',
        'EE ABELARDO DUARTE PASSOS',
        'BRUMADINHO',
        'SRE METROPOLITANA A'
    ),
(
        '8141',
        'EE PAULINA ALUOTTO FERREIRA',
        'BRUMADINHO',
        'SRE METROPOLITANA A'
    ),
(
        '8192',
        'EE PAULO NETO ALKIMIM',
        'BRUMADINHO',
        'SRE METROPOLITANA A'
    ),
(
        '8427',
        'EE CARLINDO CAETANO PINTO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8419',
        'EE FRANCISCO DE PAULA CASTRO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8338',
        'EE JOSÉ BRANDÃO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8486',
        'EE JOSÉ PEREIRA CANÇADO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8354',
        'EE PAULO PINHEIRO DA SILVA',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8401',
        'EE PRESIDENTE TANCREDO NEVES',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8362',
        'EE SEBASTIÃO RIBEIRO DE BRITO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '8371',
        'EE SENHORA DO BONSUCESSO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '10545',
        'EE ALZIRA AYRES PEREIRA',
        'CATAS ALTAS',
        'SRE METROPOLITANA A'
    ),
(
        '8915',
        'EE DOM SILVÉRIO',
        'CRUCILÂNDIA',
        'SRE METROPOLITANA A'
    ),
(
        '106437',
        'EE SENADOR MELO VIANA',
        'MOEDA',
        'SRE METROPOLITANA A'
    ),
(
        '9539',
        'EE AUGUSTO DE LIMA',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '9571',
        'EE DENIZ VALE',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '9601',
        'EE JOÃO FELIPE DA ROCHA',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '9610',
        'EE JOSEFINA WANDERLEY AZEREDO',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '305014',
        'EE MARIA JOSEFINA SALES WARDI',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '9351',
        'EE CORONEL JOSÉ NUNES MELO JÚNIOR',
        'NOVA UNIÃO',
        'SRE METROPOLITANA A'
    ),
(
        '9385',
        'EE NOVA APARECIDA',
        'NOVA UNIÃO',
        'SRE METROPOLITANA A'
    ),
(
        '9831',
        'EE PADRE PEDRO THYSEN',
        'PIEDADE DOS GERAIS',
        'SRE METROPOLITANA A'
    ),
(
        '9873',
        'EE DOM CIRILO DE PAULA FREITAS',
        'RAPOSOS',
        'SRE METROPOLITANA A'
    ),
(
        '9865',
        'EE DOUTOR CÍCERO CORREA DE ARAÚJO',
        'RAPOSOS',
        'SRE METROPOLITANA A'
    ),
(
        '9857',
        'EE HELENA VIEIRA GONÇALVES',
        'RAPOSOS',
        'SRE METROPOLITANA A'
    ),
(
        '10251',
        'EE SANTO ANTÔNIO',
        'RIO ACIMA',
        'SRE METROPOLITANA A'
    ),
(
        '10260',
        'EE LUIZ BORGES FERREIRA GONZAGA',
        'RIO MANSO',
        'SRE METROPOLITANA A'
    ),
(
        '914',
        'EE CARVALHO BRITO',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10341',
        'EE CHRISTIANO GUIMARÃES',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10359',
        'EE CORONEL ADELINO CASTELO BRANCO',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10324',
        'EE DONA BILU FIGUEIREDO',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10413',
        'EE ELÍSIO CARVALHO DE BRITO',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10421',
        'EE GENERAL CARNEIRO',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10456',
        'EE JOSÉ LUIZ GONZAGA FERREIRA',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '222470',
        'EE JUQUINHA DE ALMEIDA',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10430',
        'EE MARIA FLORIPES NASCIMENTO ALVES',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10375',
        'EE PAULA ROCHA',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '318418',
        'EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '291102',
        'EE PROFESSOR JOÃO DE ARRUDA PINTO',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10316',
        'EE PROFESSOR ZOROASTRO VIANNA PASSOS',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10391',
        'EE PROFESSORA ANGÉLICA MARIA DE ALMEIDA',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10367',
        'EE PROFESSORA MARIA ELIZABETH VIANA',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '10472',
        'EE AFONSO PENA',
        'SANTA BÁRBARA',
        'SRE METROPOLITANA A'
    ),
(
        '10529',
        'EE JOSÉ ÁLVARES DUARTE',
        'SANTA BÁRBARA',
        'SRE METROPOLITANA A'
    ),
(
        '346284',
        'EE PROFESSORA NHANITA',
        'SANTA BÁRBARA',
        'SRE METROPOLITANA A'
    ),
(
        '10511',
        'EE RODRIGO DE CASTRO MOREIRA PENA',
        'SANTA BÁRBARA',
        'SRE METROPOLITANA A'
    ),
(
        '27',
        'EE AARÃO REIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '426',
        'EE ALBERTO DELPINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '591',
        'EE ÁLVARO LAUREANO PIMENTEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '663',
        'EE ALZIRA ALBUQUERQUE MOSQUEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '744',
        'EE AMÉLIA JOSEFINA KEESEN',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1708',
        'EE ASSIS DAS CHAGAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '2089',
        'EE BERNARDO MONTEIRO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '116',
        'EE CABANA DO PAI TOMÁS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '191',
        'EE CAIO NELSON DE SENA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '434',
        'EE CÂNDIDA CABRAL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '515',
        'EE CÂNDIDO PORTINARI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '833',
        'EE CARMO GIFFONI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '990',
        'EE CECÍLIA MEIRELES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1074',
        'EE CELSO MACHADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1554',
        'EE CRISTIANO MACHADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1759',
        'EE DESEMBARGADOR MÁRIO GONÇALVES DE MATOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1791',
        'EE DESEMBARGADOR RODRIGUES CAMPOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1830',
        'EE DIOGO DE VASCONCELOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1872',
        'EE DIVINA PROVIDÊNCIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '442',
        'EE DOM CABRAL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '604',
        'EE DOMINGAS MARIA DE ALMEIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '183',
        'EE DOUTOR AMARO NEVES BARRETO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1848',
        'EE DOUTOR ANTÔNIO AUGUSTO SOARES CANEDO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '841',
        'EE DOUTOR AURINO MORAIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '922',
        'EE DOUTOR EUZÉBIO DIAS BICALHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1767',
        'EE DOUTOR JOSÉ DO PATROCÍNIO DA SILVA PONTES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1082',
        'EE DOUTOR LUCAS MONTEIRO MACHADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1716',
        'EE DOUTOR PAULO DINIZ CHAGAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '124',
        'EE DOUTOR SIMÃO TAMM BIAS FORTES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1163',
        'EE DUQUE DE CAXIAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1325',
        'EE ELISEU LABORNE E VALE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1597',
        'EE ELPÍDIO ARISTIDES DE FREITAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '246433',
        'EE EMÍLIA CERDEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1406',
        'EE ENGENHEIRO FRANCISCO BICALHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1856',
        'EE GENERAL CARLOS LUIZ GUEDES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '2054',
        'EE GERALDO JARDIM LINHARES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1953',
        'EE GERALDO TEIXEIRA DA COSTA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '51',
        'EE GUIA LOPES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '132',
        'EE GUIMARÃES ROSA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '299',
        'EE HERMENEGILDO CHAVES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '451',
        'EE HUGO WERNECK',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1929',
        'EE JOÃO PAULO I',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1091',
        'EE JOSÉ MENDES CORRÊA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '256',
        'EE JOSÉ MIGUEL DO NASCIMENTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1252',
        'EE LAÍCE AGUIAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1376',
        'EE LÚCIO DOS SANTOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '159',
        'EE MANUEL CASASANTA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '311',
        'EE MARGARIDA BROCHADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '477',
        'EE MARIETA BROCHADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '558',
        'EE MÁRIO CASASSANTA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '639',
        'EE MAURÍCIO MURGEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '710',
        'EE MELO VIANA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '795',
        'EE MINISTRO ALFREDO VILHENA VALLADÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '957',
        'EE NOSSA SENHORA APARECIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1031',
        'EE NOSSA SENHORA DO BELO RAMO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1112',
        'EE ODILON BEHRENS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1279',
        'EE OLÍMPIA REZENDE PEREIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1350',
        'EE OLÍVIA PINTO DE CASTRO LEITE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1511',
        'EE ORDEM E PROGRESSO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1571',
        'EE PADRE EUSTÁQUIO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '2151',
        'EE PADRE JOÃO BOSCO PENIDO BURNIER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1619',
        'EE PADRE JOÃO BOTELHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '272',
        'EE PADRE JOÃO MARIA KOOYMAN',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1694',
        'EE PADRE MATIAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1899',
        'EE PEDRO DUTRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '469',
        'EE PRINCESA ISABEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '621',
        'EE PROFESSOR ALCINDO VIEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '582',
        'EE PROFESSOR ALISSON PEREIRA GUIMARÃES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '868',
        'EE PROFESSOR CLÁUDIO BRANDÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '949',
        'EE PROFESSOR CLÓVIS SALGADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1104',
        'EE PROFESSOR FRANCISCO BRANT',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1180',
        'EE PROFESSOR LEON RENAULT',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1422',
        'EE PROFESSOR MAGALHÃES DRUMOND',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1503',
        'EE PROFESSOR MORAIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '2020',
        'EE PROFESSOR RICARDO DE SOUZA CRUZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1741',
        'EE PROFESSORA BENVINDA DE CARVALHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1465',
        'EE PROFESSORA MARIA AUXILIADORA LANNA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1902',
        'EE PROFESSORA MARIA BELMIRA TRINDADE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1309',
        'EE PROFESSORA MARIA DO SOCORRO ANDRADE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1988',
        'EE PROFESSORA NAIR DE OLIVEIRA SANTANA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '108',
        'EE SANDRA RISOLETA DE LIMA HAUCK',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '329',
        'EE SANTOS ANJOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '400',
        'EE SÃO BENTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '566',
        'EE SÃO SALVADOR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1201',
        'EE SILVIANO BRANDÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1520',
        'EE TOMÁS BRANDÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '1601',
        'EE URSULINA DE ANDRADE MELO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '7765',
        'CESEC DE BETIM',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7854',
        'EE AMÉLIA SANTANA BARBOSA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '212598',
        'EE ANTÔNIO AUGUSTO RIBEIRO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7986',
        'EE CÂNDIDO PORTINARI',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '8621',
        'EE CARLOS DRUMOND DE ANDRADE',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7994',
        'EE CECÍLIA MEIRELES',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7811',
        'EE CONSELHEIRO AFONSO PENA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7943',
        'EE DEPUTADO SIMÃO DA CUNHA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '215082',
        'EE DO BAIRRO AMAZONAS',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '8028',
        'EE DO BAIRRO SÃO CAETANO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7871',
        'EE DR ORESTES DINIZ',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7978',
        'EE DR RENATO AZEREDO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '8583',
        'EE ESTUDANTE LÍVIA MARA DE CASTRO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '361445',
        'EE GABRIEL PASSOS',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '8001',
        'EE GRAMONT ALVES GONTIJO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7749',
        'EE JOÃO GUIMARÃES ROSA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7862',
        'EE JOÃO PAULO I',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7901',
        'EE JUSCELINO KUBITSCHEK DE OLIVEIRA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7838',
        'EE NASCIMENTO NUNES LEAL',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7960',
        'EE NEWTON AMARAL',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7927',
        'EE NOSSA SENHORA DO CARMO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7919',
        'EE PROFESSOR CARLOS LÚCIO DE ASSIS',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '212601',
        'EE PROFESSOR OSVALDO FRANCO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7820',
        'EE PROFESSORA LOURDES BERNADETE SILVA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '8044',
        'EE PROFESSORA VERA MARIA REZENDE',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7889',
        'EE SARAH KUBITSCHEK',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7951',
        'EE SENADOR TEOTÔNIO VILELA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7897',
        'EE SÍLVIO LOBO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '7935',
        'EE TITO LÍVIO DE SOUZA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '353787',
        'EE VINÍCIUS DE MORAES',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '8885',
        'CESEC CLEMENTE DE FARIA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8575',
        'EE ADRIANO JOSÉ COSTA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8516',
        'EE BOA VISTA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8826',
        'EE CATARINA JORGE GONÇALVES',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8702',
        'EE CONFRADE ANTÔNIO PEDRO DE CASTRO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '349283',
        'EE DE ENSINO MÉDIO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8711',
        'EE DEPUTADO CLÁUDIO PINHEIRO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8541',
        'EE DEPUTADO RENATO AZEREDO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8508',
        'EE DEPUTADO SIMÃO DA CUNHA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8729',
        'EE DOM BOSCO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8770',
        'EE DOUTOR JOSÉ ROBERTO DE AGUIAR',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8851',
        'EE ELZA MENDONÇA FOULY',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8737',
        'EE FRANCISCO FIRMO DE MATOS',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '9164',
        'EE GOVERNADOR ISRAEL PINHEIRO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8834',
        'EE GUILHERMINO DE OLIVEIRA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8753',
        'EE HELENA GUERRA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8532',
        'EE JOSÉ DA SILVA COUTO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8567',
        'EE JUVENTINA PINTO BRANDÃO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8494',
        'EE LAURITA DE MELLO MOREIRA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8524',
        'EE MANOEL DE MATTOS PINHO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8591',
        'EE MARIA DAS GRAÇAS COSTA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '212644',
        'EE MARIA DE SALLES FERREIRA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8869',
        'EE MÁRIO ELIAS DE CARVALHO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8630',
        'EE MINISTRO MIGUEL MENDONÇA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8559',
        'EE NAIR MENDES MOREIRA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8605',
        'EE NOVA CONTAGEM',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8788',
        'EE PADRE CAMARGOS',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8672',
        'EE PADRE JOSÉ MARIA DE MAN',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8681',
        'EE PRESIDENTE TANCREDO NEVES',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '326780',
        'EE PROFESSOR PAULO FREIRE',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8796',
        'EE PROFESSORA CONCEIÇÃO HILÁRIO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8699',
        'EE PROFESSORA LÍGIA MARIA DE MAGALHÃES',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8664',
        'EE PROFESSORA MARIA COUTINHO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '349275',
        'EE ROBERTO FERNANDES',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8800',
        'EE RUY PIMENTA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '212652',
        'EE VINÍCIUS DE MORAES',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '8974',
        'EE DE LAGOA',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '9041',
        'EE DE MELO VIANA',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '9032',
        'EE JOÃO NAZÁRIO',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '353868',
        'EE MONTE SINAI',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '9008',
        'EE PROFESSOR AUGUSTO LUCAS',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '330647',
        'EE PROFESSOR RAYMUNDO CÂNDIDO',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '8966',
        'EE SANTA QUITÉRIA',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '9024',
        'EE SANTA TEREZA',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '8931',
        'EE SÃO TOMAZ DE AQUINO',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '9059',
        'EE TEÓFILO ALVES DA SILVA',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '8958',
        'EE VISCONDE DE CAETÉ',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '9148',
        'CESEC DE IBIRITÉ',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '231665',
        'EE ANTÔNIO MARINHO CAMPOS',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '322989',
        'EE ANTÔNIO PINHEIRO DINIZ',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '270407',
        'EE CORA CORALINA',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '353507',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9121',
        'EE DOS PALMARES',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9130',
        'EE GYSLAINE DE FREITAS ARAÚJO',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '232483',
        'EE IMPERATRIZ PIMENTA',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9172',
        'EE JOÃO ANTÔNIO SIQUEIRA',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '223590',
        'EE JOÃO FERREIRA DE FREITAS',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '7846',
        'EE JOSÉ RODRIGUES BETIM',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9181',
        'EE JUSCELINO KUBITSCHEK  DE OLIVEIRA',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '231657',
        'EE MARIA ALVES NAGY VARGA',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9113',
        'EE NO PARQUE ELIZABETH',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9091',
        'EE PEDRO EVANGELISTA DINIZ',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '231673',
        'EE PROFESSORA ELZA CARDOSO RANGEL',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9075',
        'EE PROFESSORA YOLANDA MARTINS',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '14362',
        'EE SANDOVAL SOARES DE AZEVEDO',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '254720',
        'EE CRISTIANO CHAVES DE OLIVEIRA',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9253',
        'EE JOAQUIM JOSÉ PEREIRA',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '212466',
        'EE JOELMA ALVES DE OLIVEIRA',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9245',
        'EE JOSÉ AMÂNCIO DOS SANTOS',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9211',
        'EE PROFESSORA MARIA DE MAGALHÃES PINTO',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9229',
        'EE RACHEL IANCU STEURMAN',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '9237',
        'EE SANTA CHIARA',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '34436',
        'EE JOAQUIM CORREA',
        'JUATUBA',
        'SRE METROPOLITANA B'
    ),
(
        '34410',
        'EE MARIA RITA DUARTE',
        'JUATUBA',
        'SRE METROPOLITANA B'
    ),
(
        '9199',
        'EE CONSELHEIRO AFONSO PENA',
        'MÁRIO CAMPOS',
        'SRE METROPOLITANA B'
    ),
(
        '9156',
        'EE DE MÁRIO CAMPOS',
        'MÁRIO CAMPOS',
        'SRE METROPOLITANA B'
    ),
(
        '34444',
        'EE ALVINO ALCÂNTARA FERNANDES',
        'MATEUS LEME',
        'SRE METROPOLITANA B'
    ),
(
        '34363',
        'EE DOMINGOS JUSTINO RIBEIRO',
        'MATEUS LEME',
        'SRE METROPOLITANA B'
    ),
(
        '34380',
        'EE ELIAS SALOMÃO',
        'MATEUS LEME',
        'SRE METROPOLITANA B'
    ),
(
        '34401',
        'EE MANOEL ANTÔNIO DE SOUSA',
        'MATEUS LEME',
        'SRE METROPOLITANA B'
    ),
(
        '326798',
        'EE ANTÔNIO RIBEIRO DA SILVA',
        'SÃO JOAQUIM DE BICAS',
        'SRE METROPOLITANA B'
    ),
(
        '9270',
        'EE NOSSA SENHORA DA PAZ',
        'SÃO JOAQUIM DE BICAS',
        'SRE METROPOLITANA B'
    ),
(
        '309842',
        'EE PADRE CARLOS ROBERTO MARQUES',
        'SÃO JOAQUIM DE BICAS',
        'SRE METROPOLITANA B'
    ),
(
        '231291',
        'EE PATROCÍNIA CÂNDIDA DE OLIVEIRA',
        'SÃO JOAQUIM DE BICAS',
        'SRE METROPOLITANA B'
    ),
(
        '9288',
        'EE PROFESSORA GERALDA EUGÊNIA DA SILVA',
        'SÃO JOAQUIM DE BICAS',
        'SRE METROPOLITANA B'
    ),
(
        '266094',
        'EE JOSÉ PEREIRA DOS SANTOS',
        'SARZEDO',
        'SRE METROPOLITANA B'
    ),
(
        '9202',
        'EE PROFESSOR ERNESTO CARNEIRO SANTIAGO',
        'SARZEDO',
        'SRE METROPOLITANA B'
    ),
(
        '367826',
        'EE PROFESSORA NILZA GOMES BERGMAN',
        'SARZEDO',
        'SRE METROPOLITANA B'
    ),
(
        '2569',
        'CESEC MARIA VIEIRA BARBOSA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2232',
        'EE AFONSO PENA MASCARENHAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2259',
        'EE AFRÂNIO DE MELO FRANCO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '1210',
        'EE ANITA BRINA BRANDÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2216',
        'EE ANTENOR PESSOA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2291',
        'EE ANTÔNIO CLEMENTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2313',
        'EE ARI DA FRANCA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2127',
        'EE BRITALDO SOARES FERREIRA DINIZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2526',
        'EE CARLOS DRUMMOND DE ANDRADE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2372',
        'EE CELMAR BOTELHO DUARTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '1392',
        'EE CORONEL JUCA PINTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2534',
        'EE CORONEL MANOEL SOARES DO COUTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '1007',
        'EE DE EDUCAÇÃO ESPECIAL DOUTOR JOÃO MOREIRA SALLES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2356',
        'EE DEPUTADO ÁLVARO SALLES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2411',
        'EE DEPUTADO MANOEL COSTA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2437',
        'EE DJANIRA RODRIGUES DE OLIVEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2488',
        'EE DONATO WERNECK DE FREITAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '1881',
        'EE FRANCISCO MENEZES FILHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2453',
        'EE GERALDINA ANA GOMES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2542',
        'EE GETÚLIO VARGAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '931',
        'EE JORNALISTA JORGE PAES SARDINHA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2496',
        'EE JOSÉ HEILBUTH GONÇALVES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2518',
        'EE JUSCELINO KUBITSCHEK DE OLIVEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '1457',
        'EE MADRE CARMELITA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2551',
        'EE MARGARIDA DE MELLO PRADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '253413',
        'EE MARIA ANDRADE RESENDE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2429',
        'EE MARIA CAROLINA CAMPOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2500',
        'EE MARIA LUIZA MIRANDA BASTOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2208',
        'EE MENINO JESUS DE PRAGA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2399',
        'EE ORÔNCIO MURGEL DUTRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '322636',
        'EE PADRE JOÃO DE MATTOS ALMEIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2224',
        'EE PADRE LEBRET',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2241',
        'EE PASCHOAL COMANDUCCI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2267',
        'EE PEDRO PAULO PENIDO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '418',
        'EE PRESIDENTE TANCREDO NEVES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '540',
        'EE PROFESSOR AFFONSO NEVES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '317357',
        'EE PROFESSOR AGNELO CORREIA VIANA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2283',
        'EE PROFESSOR ALBERTO MAZONI ANDRADE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '701',
        'EE PROFESSOR BATISTA SANTIAGO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2305',
        'EE PROFESSOR BOLIVAR DE FREITAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '353',
        'EE PROFESSOR HÍLTON ROCHA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2321',
        'EE PROFESSOR JOÃO CÂMARA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '246425',
        'EE PROFESSORA ADIR ANDRADE ALBANO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '205',
        'EE PROFESSORA FRANCISCA MALHEIROS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2348',
        'EE PROFESSORA INÊS GERALDA DE OLIVEIRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2445',
        'EE PROFESSORA MARIA COUTINHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2461',
        'EE PROFESSORA MARIA MUZZI GUASTAFERRO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2364',
        'EE SANTOS DUMONT',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2381',
        'EE SÃO PEDRO E SÃO PAULO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '647',
        'EE SARAH KUBITSCHEK ITAMARATI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2330',
        'EE SÍRIA MARQUES DA SILVA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '2402',
        'EE TRÊS PODERES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '9504',
        'EE SÃO JOSÉ DE CONFINS',
        'CONFINS',
        'SRE METROPOLITANA C'
    ),
(
        '9296',
        'EE CARDEAL ARCOVERDE',
        'JABOTICATUBAS',
        'SRE METROPOLITANA C'
    ),
(
        '9334',
        'EE DOUTOR EDUARDO GÓES FILHO',
        'JABOTICATUBAS',
        'SRE METROPOLITANA C'
    ),
(
        '9300',
        'EE LEÔNIDAS MARQUES AFONSO',
        'JABOTICATUBAS',
        'SRE METROPOLITANA C'
    ),
(
        '9393',
        'EE CECÍLIA DOLABELA PORTELA AZEREDO',
        'LAGOA SANTA',
        'SRE METROPOLITANA C'
    ),
(
        '9407',
        'EE NILO MAURÍCIO TRINDADE FIGUEIREDO',
        'LAGOA SANTA',
        'SRE METROPOLITANA C'
    ),
(
        '9491',
        'EE PADRE MENEZES',
        'LAGOA SANTA',
        'SRE METROPOLITANA C'
    ),
(
        '9482',
        'EE REPARATA DIAS DE OLIVEIRA',
        'LAGOA SANTA',
        'SRE METROPOLITANA C'
    ),
(
        '9466',
        'EE TIRADENTES',
        'LAGOA SANTA',
        'SRE METROPOLITANA C'
    ),
(
        '141305',
        'EE CARDEAL MOTA',
        'MORRO DO PILAR',
        'SRE METROPOLITANA C'
    ),
(
        '141291',
        'EE INTENDENTE CÂMARA',
        'MORRO DO PILAR',
        'SRE METROPOLITANA C'
    ),
(
        '9784',
        'EE DE PEDRO LEOPOLDO',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9661',
        'EE DOUTOR JÚLIO CÉSAR DE VASCONCELOS',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9792',
        'EE DR ROBERTO BELISÁRIO VIANA',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9679',
        'EE IMACULADA CONCEIÇÃO',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9768',
        'EE MAGNO CLARET',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9806',
        'EE ROMERO DE CARVALHO',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9709',
        'EE RUI BARBOSA',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9725',
        'EE SÃO JOSÉ',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '9822',
        'EE VERA CRUZ DE MINAS',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '346365',
        'CESEC DE JUSTINÓPOLIS',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10014',
        'CESEC DE RIBEIRÃO DAS NEVES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '231720',
        'EE ALESSANDRA SALUM CADAR',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '339156',
        'EE ALIZON THEMÓTER COSTA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10049',
        'EE ANTÔNIO MIGUEL CERQUEIRA NETO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '222461',
        'EE ANTÔNIO RIGUEIRA DA FONSECA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '310221',
        'EE CARLOS DRUMMOND DE ANDRADE',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10171',
        'EE CARMÉLIA GONÇALVES LOFF',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9911',
        'EE CÉSAR LOMBROSO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '277037',
        'EE CIDADE DOS MENINOS',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10219',
        'EE CONCEIÇÃO MARTINS DE JESUS',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '317195',
        'EE CUSTÓDIO FÉLIX',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '339040',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '342564',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '317489',
        'EE DJALMA MARQUES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9989',
        'EE DO BAIRRO ROSANEVES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '342491',
        'EE DR REYNALDO MARTINS MARQUES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10162',
        'EE FILOMENA CATIZANI',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10201',
        'EE FRANCISCO CARDOSO ASSUMPÇÃO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '219045',
        'EE GUADALAJARA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '239381',
        'EE HENRIQUE DE SOUZA FILHO - HENFIL',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9946',
        'EE HENRIQUE SAPORI',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10189',
        'EE HUGO VIANA CHAVES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '317349',
        'EE ITÁLIA CAUTIERO FRANCO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '231738',
        'EE JOÃO CORREA ARMOND',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '218758',
        'EE JOÃO DE ALMEIDA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10081',
        'EE JOÃO DE DEUS GOMES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9954',
        'EE JOÃO GONÇALVES NETO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10120',
        'EE JOÃO LOPES GONTIJO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9890',
        'EE JOSÉ BONIFÁCIO NOGUEIRA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10065',
        'EE JOSÉ JOAQUIM LAGES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '218715',
        'EE JOSÉ SOARES DINIZ E SILVA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '218995',
        'EE MANOEL MARTINS DE MELO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '212679',
        'EE MARIA DA GLÓRIA ASSUNÇÃO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '231711',
        'EE MARIA DA PIEDADE SOUZA ROCHA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '322628',
        'EE MARIA PEREIRA DE ARAÚJO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10146',
        'EE NOSSA SENHORA DA CONCEIÇÃO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '327492',
        'EE NOSSA SENHORA DAS GRAÇAS',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '280160',
        'EE NOSSA SENHORA DAS NEVES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9962',
        'EE PEDRO ALCÂNTARA NOGUEIRA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10022',
        'EE PROFESSOR GUERINO CASASSANTA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '9971',
        'EE PROFESSOR HELVÉCIO DAHE',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '310212',
        'EE PROFESSOR PAULO FREIRE',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10031',
        'EE ROMUALDO JOSÉ DA COSTA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '219053',
        'EE SÃO JUDAS TADEU',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10111',
        'EE VEREADOR JOSÉ ROBERTO PEREIRA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '339105',
        'EE WASHINGTON MODESTO GONTIJO DE FARIA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '10723',
        'CESEC CONJUNTO HABITACIONAL CRISTINA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10863',
        'EE AFONSINO ALTIVO DINIZ',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10715',
        'EE ALTAIR DE ALMEIDA VIANA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '351040',
        'EE EPHIGENIA DE JESUS WERNECK',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10740',
        'EE FRANCISCO TIBÚRCIO DE OLIVEIRA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10596',
        'EE GERALDO TEIXEIRA DA COSTA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10821',
        'EE GERVÁSIO LARA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10618',
        'EE JOSÉ MARIA BICALHO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10910',
        'EE LAFAIETE GONÇALVES',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10731',
        'EE LEONINA MOURTHE DE ARAÚJO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10774',
        'EE MURGY HIBRAIM SARAH',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10642',
        'EE PADRE JOÃO DE SANTO ANTÔNIO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '356727',
        'EE PRESIDENTE ITAMAR FRANCO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10669',
        'EE PROFESSOR DOMINGOS ORNELAS',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10791',
        'EE RAUL TEIXEIRA DA COSTA SOBRINHO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10812',
        'EE RENY DE SOUZA LIMA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10677',
        'EE ROSE HAAS KLABIN',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10839',
        'EE SÃO JOÃO DA ESCÓCIA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10693',
        'EE SENADOR BERNARDO MONTEIRO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10855',
        'EE TANCREDO DE ALMEIDA NEVES',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '10804',
        'EE WILSON DINIZ FILHO',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '330761',
        'EE DEPUTADO EMÍLIO DE VASCONCELOS',
        'SANTANA DO RIACHO',
        'SRE METROPOLITANA C'
    ),
(
        '10936',
        'EE DONA FRANCISCA JOSINA',
        'SANTANA DO RIACHO',
        'SRE METROPOLITANA C'
    ),
(
        '224103',
        'EE BEATRIZ MARIA DE JESUS',
        'SÃO JOSÉ DA LAPA',
        'SRE METROPOLITANA C'
    ),
(
        '11096',
        'EE JOSÉ ELIAS ISSA',
        'SÃO JOSÉ DA LAPA',
        'SRE METROPOLITANA C'
    ),
(
        '10952',
        'EE PREFEITO ARISTEU EDUARDO MOREIRA',
        'TAQUARAÇU DE MINAS',
        'SRE METROPOLITANA C'
    ),
(
        '11070',
        'CESEC CONJUNTO HABITACIONAL CAIEIRAS',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '346306',
        'CESEC DE VESPASIANO',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '374270',
        'EE  DE ENSINO FUNDAMENTAL E MÉDIO',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '374288',
        'EE DE ENSINO MÉDIO',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '11053',
        'EE DEPUTADO RENATO AZEREDO',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '10987',
        'EE FRANCISCO VIANA',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '330353',
        'EE HERBERT JOSÉ DE SOUZA',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '218979',
        'EE JOSÉ GABRIEL DE OLIVEIRA',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '11029',
        'EE MACHADO DE ASSIS',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '11037',
        'EE MARIA DA PIEDADE FONSECA',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '218740',
        'EE NILA FARAJ',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '11045',
        'EE PADRE JOSÉ SENABRE',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '11061',
        'EE PROFESSOR GUILHERME HALLAIS FRANÇA',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '200271',
        'EE PEDRO ÁLVARES CABRAL',
        'ABADIA DOS DOURADOS',
        'SRE MONTE CARMELO'
    ),
(
        '200280',
        'EE BENEDITO VALADARES',
        'CASCALHO RICO',
        'SRE MONTE CARMELO'
    ),
(
        '219011',
        'EE ALÍRIO HERVAL',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '200336',
        'EE CLARINDO GOULART',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '200395',
        'EE JOAQUIM BOTELHO',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '200433',
        'EE JOAQUIM JOSÉ DE ASSUNÇÃO',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '200409',
        'EE JOSÉ EMÍLIO DE AGUIAR',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '200328',
        'EE OSÓRIO DE MORAIS',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '219002',
        'EE PADRE LÁZARO MENEZES',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '200344',
        'EE SÃO GERALDO',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '307980',
        'EE ANITA RAMOS',
        'DOURADOQUARA',
        'SRE MONTE CARMELO'
    ),
(
        '200531',
        'EE DE DOLEARINA',
        'ESTRELA DO SUL',
        'SRE MONTE CARMELO'
    ),
(
        '313149',
        'EE MARIA MOREIRA DE VASCONCELOS',
        'ESTRELA DO SUL',
        'SRE MONTE CARMELO'
    ),
(
        '200484',
        'EE ROBERT KENNEDY',
        'ESTRELA DO SUL',
        'SRE MONTE CARMELO'
    ),
(
        '200549',
        'EE CORONEL JOSÉ FALEIROS DE AGUIAR',
        'GRUPIARA',
        'SRE MONTE CARMELO'
    ),
(
        '200671',
        'CESEC ZENITH CAMPOS',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200573',
        'EE CLARA CHAVES',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200581',
        'EE CORONEL VIRGÍLIO ROSA',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '200590',
        'EE DONA SINDA',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200603',
        'EE ELIAS DE MORAES',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200611',
        'EE GREGORIANO CANEDO',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200620',
        'EE LETÍCIA CHAVES',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200638',
        'EE MELO VIANA',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '231444',
        'EE ORDÁLIA ROCHA MUNDIM',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200654',
        'EE PROFESSOR VICENTE LOPES PEREZ',
        'MONTE CARMELO',
        'SRE MONTE CARMELO'
    ),
(
        '200689',
        'EE SANTA MARIA GORETTI',
        'ROMARIA',
        'SRE MONTE CARMELO'
    ),
(
        '79359',
        'EE AMÉRICO CALDEIRA BRANT',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79341',
        'EE ANTÔNIO INÁCIO BRANDÃO',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79367',
        'EE CRISTINA CÂMARA',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79391',
        'EE DOUTOR ODILON LOURES',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79405',
        'EE GENESCO AUGUSTO CALDEIRA BRANT',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79413',
        'EE GILBERTO CALDEIRA BRANT',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79499',
        'EE JOÃO OSÓRIO DE QUEIROZ',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79421',
        'EE MARIA ELISA VALLE DE MENEZES',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79430',
        'EE PROFESSOR ANTONICO SOARES DE SÁ',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79448',
        'EE PROFESSOR GASTÃO VALLE',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79383',
        'EE ZINHA MEIRA',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '79545',
        'EE DE SANTA MARIA',
        'BOTUMIRIM',
        'SRE MONTES CLAROS'
    ),
(
        '79502',
        'EE DOUTOR JOSÉ ESTEVES RODRIGUES',
        'BOTUMIRIM',
        'SRE MONTES CLAROS'
    ),
(
        '79537',
        'EE RENATO AZEREDO',
        'BOTUMIRIM',
        'SRE MONTES CLAROS'
    ),
(
        '79511',
        'EE SÃO FRANCISCO DE ASSIS',
        'BOTUMIRIM',
        'SRE MONTES CLAROS'
    ),
(
        '79626',
        'CESEC DR CASSIANO ALVES DE OLIVEIRA',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79618',
        'EE ADELAIDE MEDEIROS',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '231533',
        'EE CARLOS ANTÔNIO DOS SANTOS',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79561',
        'EE CREMILDA PASSOS',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79634',
        'EE FRANCISCO DE PAULA ANTUNES',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '214981',
        'EE FRANCISCO XAVIER ANTUNES',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79570',
        'EE JOÃO BERALDO',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79651',
        'EE JOSIAS DE MATOS',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79588',
        'EE MESTRA BILA',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79596',
        'EE RUTH ALVES PROENÇA',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79600',
        'EE SANT''ANA',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '79642',
        'EE CIRILO PEREIRA DA FONSECA',
        'CAMPO AZUL',
        'SRE MONTES CLAROS'
    ),
(
        '79804',
        'EE ADOLFO FERREIRA DE BARROS',
        'CAPITÃO ENÉAS',
        'SRE MONTES CLAROS'
    ),
(
        '79812',
        'EE JOSÉ PATRÍCIO DA SILVEIRA',
        'CAPITÃO ENÉAS',
        'SRE MONTES CLAROS'
    ),
(
        '79791',
        'EE NORTE MINEIRA',
        'CAPITÃO ENÉAS',
        'SRE MONTES CLAROS'
    ),
(
        '79782',
        'EE NOSSA SENHORA DA GUIA',
        'CAPITÃO ENÉAS',
        'SRE MONTES CLAROS'
    ),
(
        '79839',
        'EE AMÂNCIO JUVÊNCIO DA FONSECA',
        'CLARO DOS POÇÕES',
        'SRE MONTES CLAROS'
    ),
(
        '79855',
        'EE DONA VALENTINA ALKIMIM',
        'CLARO DOS POÇÕES',
        'SRE MONTES CLAROS'
    ),
(
        '239291',
        'EE BARREIRO DE BAIXO',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79863',
        'EE BENÍCIO PRATES',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79871',
        'EE CORONEL FRANCISCO RIBEIRO',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79944',
        'EE CORONEL LUÍS PIRES DE MINAS',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79952',
        'EE DE PONTE DOS CIGANOS',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239283',
        'EE JOSÉ MARIA DOS MARES GUIA',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79901',
        'EE MAJOR JOSÉ ELIAS TRINDADE',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239275',
        'EE MARIA DA CONCEIÇÃO CHAVES',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239259',
        'EE NOSSA SENHORA DA CONCEIÇÃO',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239267',
        'EE NOSSA SENHORA DAS GRAÇAS',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79880',
        'EE PREFEITO ARISTIDES BATISTA',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79936',
        'EE PRESIDENTE TANCREDO NEVES',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239241',
        'EE SÃO JOSÉ',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239704',
        'EE SÃO LUÍS',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '239232',
        'EE SÃO SEBASTIÃO',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79995',
        'EE SENHORINHA MUNIZ',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '79961',
        'EE WENCESLAU RAMOS DA CRUZ',
        'CORAÇÃO DE JESUS',
        'SRE MONTES CLAROS'
    ),
(
        '351067',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'CRISTÁLIA',
        'SRE MONTES CLAROS'
    ),
(
        '80012',
        'EE PROFESSOR TUTU',
        'CRISTÁLIA',
        'SRE MONTES CLAROS'
    ),
(
        '80047',
        'EE MAMEDE PACÍFICO DE ALMEIDA',
        'ENGENHEIRO NAVARRO',
        'SRE MONTES CLAROS'
    ),
(
        '80268',
        'EE DE FRANCISCO DUMONT',
        'FRANCISCO DUMONT',
        'SRE MONTES CLAROS'
    ),
(
        '80292',
        'EE ADAUTO MARTINS DE OLIVEIRA NETO',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80390',
        'EE CORDIOLINO SOUZA SANTOS',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80314',
        'EE DONATO SANTOS',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80322',
        'EE ELISEU LABORNE',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80357',
        'EE JOÃO DE DEUS DIAS',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '330639',
        'EE SÃO GONÇALO',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80349',
        'EE TIBURTINO PENA',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80373',
        'EE ZECA GUIDA',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '80730',
        'EE ANTÔNIO PIMENTA',
        'GLAUCILÂNDIA',
        'SRE MONTES CLAROS'
    ),
(
        '80748',
        'EE MARIA CARNEIRO DA CRUZ',
        'GLAUCILÂNDIA',
        'SRE MONTES CLAROS'
    ),
(
        '346098',
        'EE DE ENSINO MÉDIO',
        'GRÃO MOGOL',
        'SRE MONTES CLAROS'
    ),
(
        '80411',
        'EE PROFESSOR BICALHO',
        'GRÃO MOGOL',
        'SRE MONTES CLAROS'
    ),
(
        '80420',
        'EE PROFESSOR OSWALDO SIMÕES',
        'GRÃO MOGOL',
        'SRE MONTES CLAROS'
    ),
(
        '80446',
        'EE PROFESSORA NITA NASSAU',
        'GRÃO MOGOL',
        'SRE MONTES CLAROS'
    ),
(
        '79464',
        'EE ANTÔNIO SOARES DA CRUZ',
        'GUARACIAMA',
        'SRE MONTES CLAROS'
    ),
(
        '80527',
        'EE EDMILSON BICALHO NORONHA',
        'ITACAMBIRA',
        'SRE MONTES CLAROS'
    ),
(
        '80519',
        'EE FERNÃO DIAS PAES LEME',
        'ITACAMBIRA',
        'SRE MONTES CLAROS'
    ),
(
        '253430',
        'EE SÃO JOSÉ DO RIO PRETO',
        'ITACAMBIRA',
        'SRE MONTES CLAROS'
    ),
(
        '239054',
        'EE MANOEL PEREIRA DE ARAÚJO',
        'JAPONVAR',
        'SRE MONTES CLAROS'
    ),
(
        '310565',
        'EE PRESIDENTE CASTELO BRANCO',
        'JAPONVAR',
        'SRE MONTES CLAROS'
    ),
(
        '79685',
        'EE PROFESSORA DIVA MEDEIROS',
        'JAPONVAR',
        'SRE MONTES CLAROS'
    ),
(
        '80454',
        'EE JUCA MARIA',
        'JOSENÓPOLIS',
        'SRE MONTES CLAROS'
    ),
(
        '80705',
        'EE FRANCISCO SÁ',
        'JURAMENTO',
        'SRE MONTES CLAROS'
    ),
(
        '82678',
        'EE GUIMARÃES ROSA',
        'LONTRA',
        'SRE MONTES CLAROS'
    ),
(
        '276880',
        'EE SÃO JUDAS TADEU',
        'LUISLÂNDIA',
        'SRE MONTES CLAROS'
    ),
(
        '79677',
        'EE TEÓFILO PIRES',
        'LUISLÂNDIA',
        'SRE MONTES CLAROS'
    ),
(
        '80896',
        'EE MAJOR ALEXANDRE RODRIGUES',
        'MIRABELA',
        'SRE MONTES CLAROS'
    ),
(
        '80900',
        'EE PROFESSORA MARIA MACHADO',
        'MIRABELA',
        'SRE MONTES CLAROS'
    ),
(
        '242217',
        'EE SANTA MARIA',
        'MIRABELA',
        'SRE MONTES CLAROS'
    ),
(
        '81582',
        'CESEC DE MONTES CLAROS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81329',
        'EE AMÉRICO MARTINS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81761',
        'EE ANTÔNIO CANELA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81361',
        'EE ANTÔNIO FIGUEIRA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81400',
        'EE ARMÊNIO VELOSO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81418',
        'EE AUGUSTA VALLE',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81299',
        'EE BEATO JOSÉ DE ANCHIETA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81663',
        'EE BELVINDA RIBEIRO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81311',
        'EE BENJAMIN VERSIANI DOS ANJOS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81523',
        'EE CARLOS VERSIANI',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81566',
        'EE CLÓVIS SALGADO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81604',
        'EE CORONEL FILOMENO RIBEIRO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81817',
        'EE DE APARECIDA DO MUNDO NOVO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '326682',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '346128',
        'EE DE ENSINO MÉDIO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '353833',
        'EE DE ENSINO MÉDIO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '353841',
        'EE DE ENSINO MÉDIO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81850',
        'EE DE SANTA ROSA DE LIMA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81876',
        'EE DE SÃO PEDRO DA GARÇA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81485',
        'EE DELFINO MAGALHÃES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81744',
        'EE DEPUTADO ESTEVES RODRIGUES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81451',
        'EE DO BAIRRO SANTA TEREZINHA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81515',
        'EE DOM ARISTIDES PORTO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81531',
        'EE DOM JOÃO ANTÔNIO PIMENTA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81833',
        'EE DOMINGOS BARBOSA BRAER',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81558',
        'EE DONA QUITA PEREIRA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81370',
        'EE DOUTOR ANTÔNIO AUGUSTO VELOSO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81396',
        'EE DOUTOR CARLOS ALBUQUERQUE',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81337',
        'EE DOUTOR JOÃO ALVES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81591',
        'EE ELOY PEREIRA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81612',
        'EE FELÍCIO PEREIRA DE ARAÚJO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81493',
        'EE FRANCISCO LOPES DA SILVA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81639',
        'EE FRANCISCO PERES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81655',
        'EE FRANCISCO SÁ',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81671',
        'EE GONÇALVES CHAVES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '346110',
        'EE GUTEMBERG TEODORO PENHA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81698',
        'EE IRMÃ BEATA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81736',
        'EE JOÃO DE FREITAS NETO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '369861',
        'EE JOÃO MIGUEL TEIXEIRA DE JESUS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '205664',
        'EE LEVI DURÃES PERES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81434',
        'EE MARIA DA CONCEIÇÃO RODRIGUES AVELAR',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81752',
        'EE MONSENHOR GUSTAVO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81779',
        'EE NEREIDE CARVALHO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '339571',
        'EE PADRE HENRIQUE MUNÁIZ PUIG',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81795',
        'EE PROFESSOR ALCIDES DE CARVALHO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81507',
        'EE PROFESSOR HAMILTON LOPES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81264',
        'EE PROFESSOR PLÍNIO RIBEIRO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81256',
        'EE PROFESSORA CRISTINA GUIMARÃES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81540',
        'EE PROFESSORA DILMA QUADROS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81809',
        'EE PROFESSORA DULCE SARMENTO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '346101',
        'EE PROFESSORA ELIZABETE PEREIRA SOARES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81469',
        'EE PROFESSORA HELENA PRATES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '369853',
        'EE PROFESSORA MARIA EMÍLIA SILVA SANTOS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81841',
        'EE PROFESSORA MARILDA DE OLIVEIRA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81272',
        'EE SALVADOR FILPI',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81345',
        'EE SECUNDINO TAVARES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81388',
        'EE SIMEÃO RIBEIRO DOS SANTOS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81302',
        'EE VEREADOR FRANCISCO TOFANI',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '81477',
        'EE ZINHA PRATES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '79472',
        'EE SEBASTIÃO VIEIRA DIAS',
        'OLHOS-D''ÁGUA',
        'SRE MONTES CLAROS'
    ),
(
        '80462',
        'EE DE PADRE CARVALHO',
        'PADRE CARVALHO',
        'SRE MONTES CLAROS'
    ),
(
        '80403',
        'EE DE VENTANIA',
        'PADRE CARVALHO',
        'SRE MONTES CLAROS'
    ),
(
        '80918',
        'EE FRANCISCO ANDRADE',
        'PATIS',
        'SRE MONTES CLAROS'
    ),
(
        '79979',
        'EE CRISTINO ALVES DE JESUS',
        'SÃO JOÃO DA LAGOA',
        'SRE MONTES CLAROS'
    ),
(
        '82619',
        'EE CORONEL SIMÃO CAMPOS',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '346160',
        'EE DE ENSINO MÉDIO',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '353850',
        'EE DE ENSINO MÉDIO',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '356735',
        'EE LIODORA MARIA DA CONCEIÇÃO',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '82686',
        'EE MARIA BELTRÃO DE ALMEIDA',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '82627',
        'EE PADRE RAFAEL',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '82635',
        'EE PROFESSORA FILOMENA FIALHO',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '82660',
        'EE PROFESSORA MARIA EDUARDA VERSIANE MAIA',
        'SÃO JOÃO DA PONTE',
        'SRE MONTES CLAROS'
    ),
(
        '79987',
        'EE JESUZINHA ARAÚJO MAGALHÃES',
        'SÃO JOÃO DO PACUÍ',
        'SRE MONTES CLAROS'
    ),
(
        '79910',
        'EE MESTRE BRAGA',
        'SÃO JOÃO DO PACUÍ',
        'SRE MONTES CLAROS'
    ),
(
        '254321',
        'EE DIVANE ROCHA DE SÁ',
        'SÃO JOÃO DO PARAÍSO',
        'SRE MONTES CLAROS'
    ),
(
        '319074',
        'EE MÁRIO COELHO',
        'SÃO JOÃO DO PARAÍSO',
        'SRE MONTES CLAROS'
    ),
(
        '82732',
        'EE MENDES DE OLIVEIRA',
        'SÃO JOÃO DO PARAÍSO',
        'SRE MONTES CLAROS'
    ),
(
        '82716',
        'EE PROFESSORA DORA BARBOSA',
        'SÃO JOÃO DO PARAÍSO',
        'SRE MONTES CLAROS'
    ),
(
        '246255',
        'EE SANTO ANTÔNIO',
        'SÃO JOÃO DO PARAÍSO',
        'SRE MONTES CLAROS'
    ),
(
        '254312',
        'EE SÃO TIAGO',
        'SÃO JOÃO DO PARAÍSO',
        'SRE MONTES CLAROS'
    ),
(
        '82384',
        'EE JOÃO DIAS DE AMORIM',
        'VARGEM GRANDE DO RIO PARDO',
        'SRE MONTES CLAROS'
    ),
(
        '305278',
        'EE GERALDO ROCHA',
        'ANTÔNIO PRADO DE MINAS',
        'SRE MURIAÉ'
    ),
(
        '96709',
        'EE DOMICIANO CERQUEIRA',
        'BARÃO DE MONTE ALTO',
        'SRE MURIAÉ'
    ),
(
        '96695',
        'EE PROFESSOR TOMÁS AQUINO PEREIRA',
        'BARÃO DE MONTE ALTO',
        'SRE MURIAÉ'
    ),
(
        '97811',
        'EE AMÉRICO LOPES',
        'EUGENÓPOLIS',
        'SRE MURIAÉ'
    ),
(
        '97969',
        'EE PINHOTIBA',
        'EUGENÓPOLIS',
        'SRE MURIAÉ'
    ),
(
        '98060',
        'EE CORONEL FRANCISCO GAMA',
        'LARANJAL',
        'SRE MURIAÉ'
    ),
(
        '98434',
        'EE PADRE ALFREDO KOBAL',
        'MIRADOURO',
        'SRE MURIAÉ'
    ),
(
        '98515',
        'EE SANTO ANTÔNIO',
        'MIRAÍ',
        'SRE MURIAÉ'
    ),
(
        '314129',
        'CESEC GOVERNADOR BIAS FORTES',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98710',
        'EE ANTÔNIO VIÇOSO MAGALHÃES',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98825',
        'EE CAPITÃO ROBERTO JOSÉ FERREIRA',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98566',
        'EE COLUMBA TEIXEIRA E SILVA',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98884',
        'EE CORONEL FRANCISCO GOMES CAMPOS',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98787',
        'EE DE EDUCAÇÃO ESPECIAL WALTER VASCONCELOS',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98582',
        'EE DESEMBARGADOR CANEDO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98540',
        'EE DOUTOR OLAVO TOSTES',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98647',
        'EE ENGENHEIRO ORLANDO FLORES',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98868',
        'EE JOÃO ALVES BITTENCOURT SOBRINHO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98981',
        'EE JOÃO TEIXEIRA SIQUEIRA',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98752',
        'EE JULIETA DE OLIVEIRA MACEDO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98655',
        'EE MARIA ANTÔNIA MUGLIA',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98663',
        'EE MARIA AUGUSTA SILVA ARAÚJO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '328201',
        'EE MARIA AUXILIADORA FARIA',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98671',
        'EE PADRE MAXIMINO BENASSATI',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98809',
        'EE PEDRO VICENTE DE FREITAS',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98680',
        'EE PROFESSOR GONÇALVES COUTO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98698',
        'EE PROFESSOR MÁRIO MACEDO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98701',
        'EE PROFESSOR ORLANDO DE LIMA FARIA',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98744',
        'EE SILVEIRA BRUM',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98833',
        'EE TEMÍSTOCLES EUTRÓPIO',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '99015',
        'EE ARTUR BERNARDES',
        'PALMA',
        'SRE MURIAÉ'
    ),
(
        '99040',
        'EE SÃO JOSÉ',
        'PALMA',
        'SRE MURIAÉ'
    ),
(
        '99121',
        'EE JOSÉ BONIFÁCIO',
        'PATROCÍNIO DO MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '98965',
        'EE CÔNEGO AMÉRICO DUARTE',
        'ROSÁRIO DA LIMEIRA',
        'SRE MURIAÉ'
    ),
(
        '99317',
        'EE SEVERINO REZENDE',
        'SANTANA DE CATAGUASES',
        'SRE MURIAÉ'
    ),
(
        '99431',
        'EE SANTO AGOSTINHO',
        'SÃO FRANCISCO DO GLÓRIA',
        'SRE MURIAÉ'
    ),
(
        '276901',
        'EE ORMEZINDA ALVES DUARTE',
        'SÃO SEBASTIÃO DA VARGEM ALEGRE',
        'SRE MURIAÉ'
    ),
(
        '99562',
        'EE ASSIS BRASIL',
        'VIEIRAS',
        'SRE MURIAÉ'
    ),
(
        '102750',
        'EE JOSÉ MODESTO ÁVILA',
        'BELA VISTA DE MINAS',
        'SRE NOVA ERA'
    ),
(
        '102733',
        'EE PADRE OSWALDO DE PODESTÁ',
        'BELA VISTA DE MINAS',
        'SRE NOVA ERA'
    ),
(
        '102784',
        'EE PROFESSORA ADELINA DA CONCEIÇÃO MENDES',
        'BELA VISTA DE MINAS',
        'SRE NOVA ERA'
    ),
(
        '102831',
        'EE DONA JACY FRANCISCA GARCIA',
        'DIONÍSIO',
        'SRE NOVA ERA'
    ),
(
        '102873',
        'EE JOSÉ MARTINS DRUMOND',
        'DIONÍSIO',
        'SRE NOVA ERA'
    ),
(
        '102814',
        'EE PROFESSOR BENJAMIM ARAÚJO',
        'DIONÍSIO',
        'SRE NOVA ERA'
    ),
(
        '102971',
        'CESEC PROFESSOR JÚLIO CARVALHO SOARES',
        'FERROS',
        'SRE NOVA ERA'
    ),
(
        '103021',
        'EE LEOPOLDINA BARROS DRUMOND',
        'FERROS',
        'SRE NOVA ERA'
    ),
(
        '103012',
        'EE PONCIANO PEREIRA DA COSTA',
        'FERROS',
        'SRE NOVA ERA'
    ),
(
        '102911',
        'EE PROFESSOR ALCIDES FERNANDES DE ASSUNÇÃO',
        'FERROS',
        'SRE NOVA ERA'
    ),
(
        '102962',
        'EE SILVEIRA DRUMOND',
        'FERROS',
        'SRE NOVA ERA'
    ),
(
        '103284',
        'CESEC PROFESSORA DORINHA FERREIRA',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103098',
        'EE ANTÔNIO LINHARES GUERRA',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103314',
        'EE ANTÔNIO MARTINS PEREIRA',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103179',
        'EE DA FAZENDA DA BETÂNIA',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103101',
        'EE DONA ELEONORA NUNES PEREIRA',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103152',
        'EE JOSÉ RICARDO MARTINS FONSECA',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103144',
        'EE MAJOR LAGE',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103161',
        'EE MESTRE ZECA AMÂNCIO',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103209',
        'EE PROFESSOR EMÍLIO PEREIRA DE MAGALHÃES',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103306',
        'EE PROFESSOR MANOEL SOARES',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103241',
        'EE PROFESSORA MARCIANA MAGALHÃES',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103225',
        'EE PROFESSORA PALMIRA MORAIS',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103187',
        'EE TRAJANO PROCÓPIO DE ALVARENGA SILVA MONTEIRO',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103331',
        'EE EMÍDIO DE SALES',
        'ITAMBÉ DO MATO DENTRO',
        'SRE NOVA ERA'
    ),
(
        '103373',
        'CESEC PROFESSORA ELZA MARIA',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103349',
        'EE ALBERTO PEREIRA LIMA',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103381',
        'EE ANTÔNIO LOUREIRO SOBRINHO',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103365',
        'EE ANTÔNIO PAPINI',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103411',
        'EE DO BAIRRO LARANJEIRAS',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103420',
        'EE DONA JENNY FARIA',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103527',
        'EE DOUTOR GERALDO PARREIRAS',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103462',
        'EE JOÃO XXIII',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103489',
        'EE LUIZ PRISCO DE BRAGA',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103497',
        'EE MANOEL LOUREIRO',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103535',
        'EE RUMIA MALUF',
        'JOÃO MONLEVADE',
        'SRE NOVA ERA'
    ),
(
        '103616',
        'EE DA VILA SANTA ROSA',
        'NOVA ERA',
        'SRE NOVA ERA'
    ),
(
        '103586',
        'EE NOSSA SENHORA DE FÁTIMA',
        'NOVA ERA',
        'SRE NOVA ERA'
    ),
(
        '103594',
        'EE PADRE VIDIGAL',
        'NOVA ERA',
        'SRE NOVA ERA'
    ),
(
        '103641',
        'EE LUIZA DOS SANTOS FERREIRA',
        'PASSABÉM',
        'SRE NOVA ERA'
    ),
(
        '103721',
        'CESEC MARTINHA DE OLIVEIRA ARAÚJO',
        'RIO PIRACICABA',
        'SRE NOVA ERA'
    ),
(
        '103730',
        'EE ANTONINO FERREIRA MENDES',
        'RIO PIRACICABA',
        'SRE NOVA ERA'
    ),
(
        '338656',
        'EE MARINHO SILVA',
        'RIO PIRACICABA',
        'SRE NOVA ERA'
    ),
(
        '103691',
        'EE PROFESSOR ANTÔNIO FERNANDES PINTO',
        'RIO PIRACICABA',
        'SRE NOVA ERA'
    ),
(
        '103802',
        'EE AGENOR GUERRA',
        'SANTA MARIA DE ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103756',
        'EE DOUTOR COSTA',
        'SANTA MARIA DE ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '103829',
        'EE PROFESSOR JOSÉ MADUREIRA DE OLIVEIRA',
        'SANTO ANTÔNIO DO RIO ABAIXO',
        'SRE NOVA ERA'
    ),
(
        '103845',
        'EE CORONEL FRANCISCO ROLLA',
        'SÃO DOMINGOS DO PRATA',
        'SRE NOVA ERA'
    ),
(
        '103900',
        'EE CORONEL JOSÉ GOMES DE ARAÚJO',
        'SÃO DOMINGOS DO PRATA',
        'SRE NOVA ERA'
    ),
(
        '103969',
        'EE CRISTIANO MACHADO',
        'SÃO DOMINGOS DO PRATA',
        'SRE NOVA ERA'
    ),
(
        '103888',
        'EE MARQUES AFONSO',
        'SÃO DOMINGOS DO PRATA',
        'SRE NOVA ERA'
    ),
(
        '103993',
        'EE VICENTE DE PAULA FRAGA',
        'SÃO DOMINGOS DO PRATA',
        'SRE NOVA ERA'
    ),
(
        '104051',
        'EE DESEMBARGADOR MOREIRA SANTOS',
        'SÃO GONÇALO DO RIO ABAIXO',
        'SRE NOVA ERA'
    ),
(
        '104108',
        'EE ROMEU PERDIGÃO',
        'SÃO JOSÉ DO GOIABAL',
        'SRE NOVA ERA'
    ),
(
        '104141',
        'EE ODILON BEHRENS',
        'SÃO SEBASTIÃO DO RIO PRETO',
        'SRE NOVA ERA'
    ),
(
        '106003',
        'EE PADRE SIMIM',
        'ACAIACA',
        'SRE OURO PRETO'
    ),
(
        '330663',
        'EE PROFESSOR MARTINS',
        'ACAIACA',
        'SRE OURO PRETO'
    ),
(
        '106101',
        'EE CORONEL NICOLAU SAMPAIO',
        'DIOGO DE VASCONCELOS',
        'SRE OURO PRETO'
    ),
(
        '106143',
        'EE DOUTOR RAUL SOARES',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '106151',
        'EE ENGENHEIRO QUEIROZ JÚNIOR',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '106160',
        'EE HENRIQUE MICHEL',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '106178',
        'EE INTENDENTE CÂMARA',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '106127',
        'EE PROFESSOR TIBÚRCIO',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '106372',
        'EE CÔNEGO BRAGA',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106348',
        'EE CÔNEGO MAURO DE FARIA',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106399',
        'EE CORONEL BENJAMIM GUIMARÃES',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106275',
        'EE DOM BENEVIDES',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106291',
        'EE DOM SILVÉRIO',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106259',
        'EE DONA REPARATA DIAS DE OLIVEIRA',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106283',
        'EE DOUTOR GOMES FREIRE',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '356808',
        'EE JOÃO RAMOS FILHO',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106364',
        'EE MONSENHOR MORAIS',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106381',
        'EE PADRE VIEGAS',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106321',
        'EE PROFESSOR SOARES FERREIRA',
        'MARIANA',
        'SRE OURO PRETO'
    ),
(
        '106631',
        'EE ANTÔNIO PEREIRA',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106488',
        'EE DE OURO PRETO',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106496',
        'EE DESEMBARGADOR HORÁCIO ANDRADE',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106500',
        'EE DOM PEDRO II',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106470',
        'EE DOM VELLOSO',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106721',
        'EE JOSÉ LEANDRO',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106526',
        'EE MARÍLIA DE DIRCEU',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106658',
        'EE NOSSA SENHORA AUXILIADORA',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '106666',
        'EE PADRE AFONSO DE LEMOS',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '338915',
        'EE PROFESSORA DAURA DE CARVALHO NETO',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '351059',
        'EE PROFESSORA MARIA DO CARMO ALMEIDA',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '31771',
        'EE BARÃO DO INDAIÁ',
        'ABAETÉ',
        'SRE PARÁ DE MINAS'
    ),
(
        '31836',
        'EE DOUTOR EDGARDO DA CUNHA PEREIRA',
        'ABAETÉ',
        'SRE PARÁ DE MINAS'
    ),
(
        '31852',
        'EE FREDERICO ZACARIAS',
        'ABAETÉ',
        'SRE PARÁ DE MINAS'
    ),
(
        '305626',
        'EE SORAMA GERALDA RICHARD XAVIER',
        'BIQUINHAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '32425',
        'CESEC PROFESSORA ZAÍRA BATISTA TEIXEIRA',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32310',
        'EE CHIQUINHA SOARES',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '311898',
        'EE CORONEL EGÍDIO BENÍCIO DE ABREU',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32336',
        'EE CORONEL ROBERTINHO',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32361',
        'EE IRMÃ MARIA',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32387',
        'EE MARTINHO FIDÉLIS',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32395',
        'EE MIGUEL GONTIJO',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32344',
        'EE PROFESSOR WILSON LOPES DO COUTO',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '32433',
        'EE PROFESSORA MARIA GUERRA',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '307343',
        'EE JOSÉ RIBEIRO DE ANDRADE',
        'CEDRO DO ABAETÉ',
        'SRE PARÁ DE MINAS'
    ),
(
        '32891',
        'EE BOM JESUS DO OESTE',
        'CONCEIÇÃO DO PARÁ',
        'SRE PARÁ DE MINAS'
    ),
(
        '32921',
        'EE DOUTOR ISAURO EPIFÂNIO',
        'CONCEIÇÃO DO PARÁ',
        'SRE PARÁ DE MINAS'
    ),
(
        '33464',
        'EE FRANCISCO CAMPOS',
        'DORES DO INDAIÁ',
        'SRE PARÁ DE MINAS'
    ),
(
        '33502',
        'EE PROFESSOR ANTÔNIO RIBEIRO',
        'ESTRELA DO INDAIÁ',
        'SRE PARÁ DE MINAS'
    ),
(
        '33553',
        'EE SERAFIM RIBEIRO DE REZENDE',
        'FLORESTAL',
        'SRE PARÁ DE MINAS'
    ),
(
        '33634',
        'EE DONA AMANDA PINHEIRO SENNA',
        'IGARATINGA',
        'SRE PARÁ DE MINAS'
    ),
(
        '33626',
        'EE JOSÉ ATAÍDE DE ALMEIDA',
        'IGARATINGA',
        'SRE PARÁ DE MINAS'
    ),
(
        '34134',
        'EE CORONEL ANTÔNIO CORRÊA',
        'LEANDRO FERREIRA',
        'SRE PARÁ DE MINAS'
    ),
(
        '34312',
        'EE DOUTOR JOSÉ GONÇALVES',
        'MARTINHO CAMPOS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34339',
        'EE FRANCISCO DIAS',
        'MARTINHO CAMPOS',
        'SRE PARÁ DE MINAS'
    ),
(
        '322865',
        'EE INDÍGENA CAXIXÓ TAOCA SÉRGIA',
        'MARTINHO CAMPOS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34347',
        'EE PADRE NONÔ',
        'MARTINHO CAMPOS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34584',
        'EE FREI ORLANDO',
        'MORADA NOVA DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34711',
        'EE DA JAGUARA',
        'ONÇA DE PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '34720',
        'EE ZICO BARBOSA',
        'ONÇA DE PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '34746',
        'EE CELESTINO NUNES',
        'PAINEIRAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35084',
        'CESEC DONA AFONSINA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35068',
        'EE ADEMAR DE MELO',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34878',
        'EE ÂNGELA MARIA DE OLIVEIRA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '346152',
        'EE AVANY VILLENA DINIZ',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34894',
        'EE CLÓVIS SALGADO',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35076',
        'EE CORONEL JOÃO FERREIRA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35131',
        'EE FERNANDO OTÁVIO',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35050',
        'EE FRANCISCO DE ASSIS VIANA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34886',
        'EE FREI CONCÓRDIO',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34908',
        'EE GOVERNADOR VALADARES',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35149',
        'EE JOAQUIM LUIZ GONZAGA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34924',
        'EE MANOEL BATISTA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '34967',
        'EE NOSSA SENHORA AUXILIADORA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '353477',
        'EE PADRE LIBÉRIO',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '326691',
        'EE PROFESSOR AGMAR GOMES DO COUTO - PDPC',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35009',
        'EE PROFESSOR PEREIRA DA COSTA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '233391',
        'EE PROFESSOR WILSON DE MELO GUIMARÃES',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '307408',
        'EE TORQUATO DE ALMEIDA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35173',
        'EE ZICO FERREIRA',
        'PARÁ DE MINAS',
        'SRE PARÁ DE MINAS'
    ),
(
        '35327',
        'EE VIRIATO MELGAÇO',
        'PEQUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '35441',
        'EE DOUTOR JACINTO ÁLVARES',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '35408',
        'EE FRANCISCA BOTELHO',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '35424',
        'EE FRANCISCA CAMPOS GUIMARÃES',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '310522',
        'EE GUSTAVO CAPANEMA',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '35459',
        'EE MONSENHOR ARTUR DE OLIVEIRA',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '35505',
        'EE PADRE JOAQUIM XAVIER LOPES CANÇADO',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '217905',
        'INSTITUTO TECNOLÓGICO DE AGROPECUÁRIA DE PITANGUI - ITAP',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '305651',
        'EE SEBASTIÃO CAMPOS',
        'QUARTEL GERAL',
        'SRE PARÁ DE MINAS'
    ),
(
        '35653',
        'EE DONA ANTÔNIA VALADARES',
        'SÃO JOSÉ DA VARGINHA',
        'SRE PARÁ DE MINAS'
    ),
(
        '239402',
        'EE ALMINDA ALVES DA SILVA',
        'BRASILÂNDIA DE MINAS',
        'SRE PARACATU'
    ),
(
        '108731',
        'EE CYRO GÓES',
        'BRASILÂNDIA DE MINAS',
        'SRE PARACATU'
    ),
(
        '108669',
        'EE DOUTOR JOSÉ PACHECO PIMENTA',
        'BRASILÂNDIA DE MINAS',
        'SRE PARACATU'
    ),
(
        '108481',
        'EE DOUTOR ANTÔNIO RIBEIRO',
        'GUARDA-MOR',
        'SRE PARACATU'
    ),
(
        '108553',
        'EE ARMINDA MARIA DA COSTA',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108511',
        'EE CAPITÃO SPERIDIÃO',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108596',
        'EE JOÃO GUIMARÃES ROSA',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '220671',
        'EE JOSÉ ROMERO DA SILVEIRA',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108561',
        'EE MARIA GONÇALVES AZEVEDO',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108570',
        'EE MARIA JOSÉ DE PAULA',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108529',
        'EE PRESIDENTE OLEGÁRIO',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108545',
        'EE PROFESSORA ORLINDA SARAIVA SIMÕES',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108537',
        'EE QUINTINO VARGAS',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '256234',
        'EE SEBASTIÃO SIMÃO DE MELO',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108588',
        'EE TANCREDO DE ALMEIDA NEVES',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108766',
        'EE TEOTÔNIO BRANDÃO VILELA',
        'JOÃO PINHEIRO',
        'SRE PARACATU'
    ),
(
        '108928',
        'CESEC CÂNDIDA PIMENTEL ULHOA',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108839',
        'EE AFFONSO ROQUETTE',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108812',
        'EE AFONSO ARINOS',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108863',
        'EE ALTINA DE PAULA GUIMARÃES',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108855',
        'EE ANTÔNIO CARLOS',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108901',
        'EE DA FAZENDA RIACHO LAFERSA',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '220663',
        'EE DELANO BROCHADO ADJUTO',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108952',
        'EE DOM SERAFIM GOMES JARDIM',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108961',
        'EE DOUTOR SÉRGIO ULHOA',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108847',
        'EE DOUTOR VIRGÍLIO DE MELO FRANCO',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108979',
        'EE JÚLIA CAMARGOS',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '353205',
        'EE NEUSA PIMENTEL BARBOSA',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108880',
        'EE OLINDINA LOUREIRO',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108804',
        'EE PROFESSOR JOSINO NEIVA',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '108821',
        'EE TEMÍSTOCLES ROCHA',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '308412',
        'EE CAROLINA SILVA',
        'VAZANTE',
        'SRE PARACATU'
    ),
(
        '109134',
        'EE DEPUTADO CÂNDIDO ULHOA',
        'VAZANTE',
        'SRE PARACATU'
    ),
(
        '109177',
        'EE DONA MARIANA SOLIS ROSA',
        'VAZANTE',
        'SRE PARACATU'
    ),
(
        '109151',
        'EE PEDRO PEREIRA GUIMARÃES',
        'VAZANTE',
        'SRE PARACATU'
    ),
(
        '109169',
        'EE PRESIDENTE JUSCELINO KUBITSCHEK DE OLIVEIRA',
        'VAZANTE',
        'SRE PARACATU'
    ),
(
        '114898',
        'CESEC DOUTOR HÉLIO FERREIRA LOPES',
        'ALPINÓPOLIS',
        'SRE PASSOS'
    ),
(
        '114863',
        'EE DOM JOÃO VI',
        'ALPINÓPOLIS',
        'SRE PASSOS'
    ),
(
        '114855',
        'EE DONA INDÁ',
        'ALPINÓPOLIS',
        'SRE PASSOS'
    ),
(
        '123901',
        'EE CORONEL ANTÔNIO DOMINGOS RIBEIRO',
        'BOM JESUS DA PENHA',
        'SRE PASSOS'
    ),
(
        '317462',
        'EE CORONEL LOURENÇO BELO',
        'CAPITÓLIO',
        'SRE PASSOS'
    ),
(
        '114961',
        'EE MODESTO ANTÔNIO DE OLIVEIRA',
        'CAPITÓLIO',
        'SRE PASSOS'
    ),
(
        '115061',
        'EE GERALDO DE ANDRADE VILELA',
        'CARMO DO RIO CLARO',
        'SRE PASSOS'
    ),
(
        '115088',
        'EE MONSENHOR MÁRIO ARAÚJO GUIMARÃES',
        'CARMO DO RIO CLARO',
        'SRE PASSOS'
    ),
(
        '115347',
        'EE PADRE JOSÉ SANGALI',
        'CÓRREGO FUNDO',
        'SRE PASSOS'
    ),
(
        '115126',
        'EE PROFESSORA NEIVA MARIA LEITE',
        'DELFINÓPOLIS',
        'SRE PASSOS'
    ),
(
        '115177',
        'EE STA TEREZINHA',
        'DORESÓPOLIS',
        'SRE PASSOS'
    ),
(
        '313700',
        'CESEC ÂNGELA MARIA CASSEMIRO CORRÊA',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115258',
        'EE AURELIANO RODRIGUES NUNES',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115282',
        'EE DR ABÍLIO MACHADO',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115266',
        'EE JALCIRA SANTOS VALADÃO',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115304',
        'EE JOSÉ BERNARDES DE FARIA',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115207',
        'EE PROFESSOR JOAQUIM RODARTE',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115223',
        'EE PROFESSOR TONICO LEITE',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '339091',
        'EE PROFESSORA MARIA APARECIDA COSTA DE RESENDE',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115240',
        'EE RODOLFO ALMEIDA',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '115363',
        'EE DOUTOR NORALDINO DE LIMA',
        'FORTALEZA DE MINAS',
        'SRE PASSOS'
    ),
(
        '232653',
        'CESEC DONA EMÍLIA LEAL',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115380',
        'EE ABRAÃO LINCOLN',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115401',
        'EE CAETANO MACHADO DA SILVEIRA',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115428',
        'EE DEUS UNIVERSO E VIRTUDE',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115495',
        'EE DOUTOR TANCREDO DE ALMEIDA NEVES',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115576',
        'EE DULCE FERREIRA DE SOUZA',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115487',
        'EE FRANCISCO DA SILVA MAIA',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115509',
        'EE GERALDO STARLING SOARES',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115533',
        'EE LOURENÇO ANDRADE',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115541',
        'EE LUIZ DE MELLO VIANNA SOBRINHO',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115517',
        'EE NAZLE JABUR',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115550',
        'EE NECA QUIRINO',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115568',
        'EE NOSSA SENHORA DA PENHA',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '218154',
        'EE PROFESSOR JAIR SANTOS',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115398',
        'EE PROFESSORA JÚLIA KUBITSCHEK',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115436',
        'EE SÃO JOSÉ',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '115606',
        'EE PADRE JOSÉ ESPÍNDOLA',
        'PIMENTA',
        'SRE PASSOS'
    ),
(
        '115720',
        'CESEC SEBASTIÃO GONÇALVES DA SILVA',
        'PIUMHI',
        'SRE PASSOS'
    ),
(
        '115690',
        'EE PROFESSOR FRANCISCO DE PAULA REBELO HORTA',
        'PIUMHI',
        'SRE PASSOS'
    ),
(
        '115703',
        'EE PROFESSOR JOÃO MENEZES',
        'PIUMHI',
        'SRE PASSOS'
    ),
(
        '115711',
        'EE PROFESSOR JOSÉ VICENTE',
        'PIUMHI',
        'SRE PASSOS'
    ),
(
        '115762',
        'EE JOSÉ SEVERIANO FILHO',
        'SÃO JOÃO BATISTA DO GLÓRIA',
        'SRE PASSOS'
    ),
(
        '114901',
        'EE DE FURNAS',
        'SÃO JOSÉ DA BARRA',
        'SRE PASSOS'
    ),
(
        '114910',
        'EE DOUTOR JUSCELINO KUBITSCHEK',
        'SÃO JOSÉ DA BARRA',
        'SRE PASSOS'
    ),
(
        '115789',
        'EE GENERAL CARNEIRO',
        'SÃO ROQUE DE MINAS',
        'SRE PASSOS'
    ),
(
        '346136',
        'EE PROFESSORA IZAURA DE OLIVEIRA VILELA',
        'SÃO ROQUE DE MINAS',
        'SRE PASSOS'
    ),
(
        '115843',
        'EE SÃO FRANCISCO',
        'VARGEM BONITA',
        'SRE PASSOS'
    ),
(
        '118419',
        'EE MANOEL GONÇALVES BOAVENTURA',
        'ARAPUÁ',
        'SRE PATOS DE MINAS'
    ),
(
        '118532',
        'CESEC PROFESSOR ANTÔNIO DE DEUS VIEIRA NETO',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '118443',
        'EE AMADEU GONÇALVES BOAVENTURA',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '118559',
        'EE ANTÔNIO ATANÁSIO',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '305341',
        'EE LEÔNCIO FERREIRA DE MELO',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '326631',
        'EE NOSSA SENHORA DO CARMO',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '118494',
        'EE PROFESSOR JOSÉ HUGO GUIMARÃES',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '118541',
        'EE SIZENANDO AMARAL DE EDUCAÇÃO ESPECIAL',
        'CARMO DO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '118648',
        'CESEC AUGUSTA RAQUEL DA SILVEIRA',
        'LAGAMAR',
        'SRE PATOS DE MINAS'
    ),
(
        '118575',
        'EE AFONSO CORRÊA',
        'LAGAMAR',
        'SRE PATOS DE MINAS'
    ),
(
        '118583',
        'EE AMÉRICO ALVES',
        'LAGAMAR',
        'SRE PATOS DE MINAS'
    ),
(
        '118605',
        'EE DOM BOSCO',
        'LAGAMAR',
        'SRE PATOS DE MINAS'
    ),
(
        '118656',
        'EE CORONEL CRISTIANO',
        'LAGOA FORMOSA',
        'SRE PATOS DE MINAS'
    ),
(
        '118672',
        'EE JOSÉ MARCIANO BRANDÃO',
        'LAGOA FORMOSA',
        'SRE PATOS DE MINAS'
    ),
(
        '118664',
        'EE NOSSA SENHORA DA PIEDADE',
        'LAGOA FORMOSA',
        'SRE PATOS DE MINAS'
    ),
(
        '119172',
        'EE SANTA TEREZINHA',
        'LAGOA GRANDE',
        'SRE PATOS DE MINAS'
    ),
(
        '118737',
        'EE ANA ROCHA',
        'MATUTINA',
        'SRE PATOS DE MINAS'
    ),
(
        '118851',
        'CESEC ORDALINA VIEIRA RORIZ DA COSTA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118818',
        'EE ABÍLIO CAIXETA DE QUEIROZ',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118761',
        'EE ABNER AFONSO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118788',
        'EE ADELAIDE MACIEL',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '212229',
        'EE AGROTÉCNICA AFONSO QUEIROZ',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '305367',
        'EE ARLINDO PORTO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118842',
        'EE CÔNEGO GETÚLIO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118800',
        'EE DEIRÓ EUNÁPIO BORGES',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118923',
        'EE DONA GUIOMAR DE MELO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118796',
        'EE DOUTOR PAULO BORGES',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '326640',
        'EE DOUTOR SEBASTIÃO SILVÉRIO DE FARIA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '342483',
        'EE EUSTÁQUIO JOSÉ DA SILVA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118834',
        'EE ILÍDIO CAIXETA DE MELO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '119032',
        'EE JOÃO BARBOSA PORTO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '119083',
        'EE JUCA MANDU',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '119067',
        'EE MAJOR MOTA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118958',
        'EE MARCOLINO DE BARROS',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118966',
        'EE MONSENHOR FLEURY',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '212237',
        'EE PADRE ALMIR NEVES DE MEDEIROS',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118982',
        'EE PROFESSOR ANTÔNIO DIAS MACIEL',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '305359',
        'EE PROFESSOR MANOEL LOPES NOGUEIRA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '118991',
        'EE PROFESSOR MODESTO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '360813',
        'EE PROFESSOR RENÉ DE DEUS VIEIRA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '119024',
        'EE PROFESSOR ZAMA MACIEL',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '353485',
        'EE PROFESSORA PAULINA DE MELO PORTO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '119016',
        'EE SANTA TEREZINHA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '232645',
        'CESEC TANCREDO NEVES',
        'PRESIDENTE OLEGÁRIO',
        'SRE PATOS DE MINAS'
    ),
(
        '375853',
        'EE DE ENSINO FUNDAMENTAL - ANOS INICIAIS E FINAIS',
        'PRESIDENTE OLEGÁRIO',
        'SRE PATOS DE MINAS'
    ),
(
        '119199',
        'EE DE PONTE FIRME',
        'PRESIDENTE OLEGÁRIO',
        'SRE PATOS DE MINAS'
    ),
(
        '119121',
        'EE PADRE JOSÉ ANDRÉ CALDEIRA COIMBRA',
        'PRESIDENTE OLEGÁRIO',
        'SRE PATOS DE MINAS'
    ),
(
        '119164',
        'EE PRESIDENTE VARGAS',
        'PRESIDENTE OLEGÁRIO',
        'SRE PATOS DE MINAS'
    ),
(
        '122629',
        'EE DOUTOR ADIRON GONÇALVES BOAVENTURA',
        'RIO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '119458',
        'EE ANTERO MAGALHÃES DE AGUIAR',
        'SANTA ROSA DA SERRA',
        'SRE PATOS DE MINAS'
    ),
(
        '119504',
        'EE ZICO MENDONÇA',
        'SÃO GONÇALO DO ABAETÉ',
        'SRE PATOS DE MINAS'
    ),
(
        '119601',
        'CESEC MARIA COELI FRANCO',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '318531',
        'EE CONSELHEIRO AFONSO PENA',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '119628',
        'EE CORONEL HERMENEGILDO LADEIRA',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '119539',
        'EE CORONEL OSCAR PRADOS',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '119598',
        'EE JOSÉ CAETANO RIBEIRO',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '119571',
        'EE PADRE SINFRÔNIO BAHIA',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '119563',
        'EE SÃO PIO X',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '119679',
        'EE PADRE JOSÉ COELHO',
        'TIROS',
        'SRE PATOS DE MINAS'
    ),
(
        '119521',
        'EE JOÃO PEREIRA BRANDÃO',
        'VARJÃO DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '278718',
        'EE CÂNDIDA CORTES CORRÊA',
        'CRUZEIRO DA FORTALEZA',
        'SRE PATROCÍNIO'
    ),
(
        '198943',
        'EE IRMÃOS GUIMARÃES',
        'GUIMARÂNIA',
        'SRE PATROCÍNIO'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '159026',
        'EE DOUTOR PEDRO DIAS DOS REIS',
        'IBIÁ',
        'SRE PATROCÍNIO'
    ),
(
        '159069',
        'EE SÃO JOSÉ',
        'IBIÁ',
        'SRE PATROCÍNIO'
    ),
(
        '198960',
        'EE PADRE EUSTÁQUIO',
        'IRAÍ DE MINAS',
        'SRE PATROCÍNIO'
    ),
(
        '198986',
        'EE SÃO JOSÉ DO BARREIRO',
        'IRAÍ DE MINAS',
        'SRE PATROCÍNIO'
    ),
(
        '199150',
        'CESEC DORALICE ALVES RODRIGUES',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '198994',
        'EE AMIR AMARAL',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199214',
        'EE CORONEL ELMIRO ALVES DO NASCIMENTO',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199087',
        'EE CORONEL JOÃO CÂNDIDO DE AGUIAR',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199141',
        'EE DALVA STELA DE QUEIROZ',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '327590',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199010',
        'EE DOM LUSTOSA',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199036',
        'EE DONA COTINHA',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199061',
        'EE IRMÃ GISLENE',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199095',
        'EE JOAQUIM DIAS',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199133',
        'EE JOSÉ EDUARDO AQUINO',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '218090',
        'EE LÍBIA LASSI LOPES',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199109',
        'EE MARIANA TAVARES',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199117',
        'EE NELY AMARAL',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199184',
        'EE ODILON BEHRENS',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '218103',
        'EE PROFESSORA CÉLIA LEMOS',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '238538',
        'EE PROFESSORA IRMA CARVALHO',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '310603',
        'EE PROFESSORA ORMY ARAÚJO AMARAL',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '356794',
        'EE TEREZINHA MOREIRA MARRA',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '199168',
        'EE VENINA TAVARES AMARAL',
        'PATROCÍNIO',
        'SRE PATROCÍNIO'
    ),
(
        '159344',
        'EE HORÁCIO AFONSO',
        'PERDIZES',
        'SRE PATROCÍNIO'
    ),
(
        '159352',
        'EE JOSEFA MARGARIDA TRINDADE',
        'PERDIZES',
        'SRE PATROCÍNIO'
    ),
(
        '159387',
        'EE PADRE JOÃO BALKER',
        'PERDIZES',
        'SRE PATROCÍNIO'
    ),
(
        '326704',
        'EE PREFEITO VIRMONDES AFONSO',
        'PERDIZES',
        'SRE PATROCÍNIO'
    ),
(
        '199303',
        'EE CORNÉLIA REGINA',
        'SERRA DO SALITRE',
        'SRE PATROCÍNIO'
    ),
(
        '199265',
        'EE SERRA DO SALITRE',
        'SERRA DO SALITRE',
        'SRE PATROCÍNIO'
    ),
(
        '361607',
        'EE TEREZA DE CASTRO MARIANO',
        'SERRA DO SALITRE',
        'SRE PATROCÍNIO'
    ),
(
        '346322',
        'CESEC DE BURITIZEIRO',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '79707',
        'EE BENEDITA CONCEIÇÃO ROQUETTE',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '79758',
        'EE CACHOEIRA DO MANTEIGA',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '346233',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '246131',
        'EE PREFEITO JOSÉ MARIA PEREIRA',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '79693',
        'EE PROFESSORA ELISA TEIXEIRA DE CARVALHO',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '79715',
        'EE PROFESSORA MARIETA AMORIM VIEIRA',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '246140',
        'EE PROFESSORA SÍLVIA ALENCAR ZSCHABER',
        'BURITIZEIRO',
        'SRE PIRAPORA'
    ),
(
        '80501',
        'EE BOM JESUS DA VEREDA',
        'IBIAÍ',
        'SRE PIRAPORA'
    ),
(
        '80471',
        'EE CORONEL ARISTIDES BATISTA',
        'IBIAÍ',
        'SRE PIRAPORA'
    ),
(
        '80489',
        'EE SÃO FRANCISCO',
        'IBIAÍ',
        'SRE PIRAPORA'
    ),
(
        '80683',
        'EE CÔNEGO CLEMENTE LAURENS',
        'JEQUITAÍ',
        'SRE PIRAPORA'
    ),
(
        '80675',
        'EE PROFESSOR LUCIANO',
        'JEQUITAÍ',
        'SRE PIRAPORA'
    ),
(
        '80764',
        'EE RAIMUNDO NONATO DA FONSECA',
        'LAGOA DOS PATOS',
        'SRE PIRAPORA'
    ),
(
        '82015',
        'CESEC UMBELINA DINIZ',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '82007',
        'EE ARGELCE CARVALHO SANTOS DA MOTA',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81892',
        'EE CORONEL RAMOS',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81914',
        'EE DEPUTADO QUINTINO VARGAS',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81973',
        'EE DO BAIRRO CIDADE JARDIM',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81922',
        'EE FERNÃO DIAS',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81931',
        'EE JOSÉ NATALINO BOAVENTURA LEITE',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81949',
        'EE LUIZ BALBINO',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '365270',
        'EE PROFESSOR PAULO FREIRE',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81906',
        'EE PROFESSORA ANÉSIA GONÇALVES LONGUINHO',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81957',
        'EE PROFESSORA HELOÍSA PASSOS',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '81965',
        'EE SANTO ANTÔNIO',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '63495',
        'EE PROFESSOR EDILSON BRANDÃO',
        'PONTO CHIQUE',
        'SRE PIRAPORA'
    ),
(
        '82597',
        'EE CARMELA DUTRA',
        'SANTA FÉ DE MINAS',
        'SRE PIRAPORA'
    ),
(
        '82767',
        'EE AFONSO ARINOS',
        'SÃO ROMÃO',
        'SRE PIRAPORA'
    ),
(
        '346225',
        'EE PROFESSORA GEOVANINA FERREIRA DIAS',
        'SÃO ROMÃO',
        'SRE PIRAPORA'
    ),
(
        '82988',
        'CESEC MAXIMILIANO GAIDZINSKI',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '82996',
        'EE DE GUAICUÍ',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '82970',
        'EE EMÍLIA DE PAULA',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '223671',
        'EE GERALDO SANGUINETTE',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '82937',
        'EE JOAQUIM DE PAULA FERREIRA',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '82953',
        'EE JOSEPH HEIN',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '82945',
        'EE PRESIDENTE TANCREDO DE ALMEIDA NEVES',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '123668',
        'EE BOLÍVAR BOANERGES DA SILVEIRA',
        'ALTEROSA',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123684',
        'EE DEPUTADO JALES MACHADO',
        'ALTEROSA',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123773',
        'EE ADOLFO FIRMINO SOUZA MARQUES',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123706',
        'EE CORONEL JOÃO MOSCONI',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123757',
        'EE DANIEL RIBEIRO MOGGI',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123714',
        'EE DOUTOR ALCIDES MOSCONI',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123731',
        'EE PROFESSOR EDMUNDO VIEIRA',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123846',
        'EE JOÃO LOURENÇO',
        'AREADO',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123897',
        'EE JOSÉ BANDEIRA DE CARVALHO',
        'BANDEIRA DO SUL',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124010',
        'EE AFONSO ROMÃO DE SIQUEIRA',
        'BOTELHOS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123951',
        'EE JOÃO DE SOUZA GONÇALVES',
        'BOTELHOS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '123978',
        'EE SÃO JOSÉ',
        'BOTELHOS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124095',
        'EE MAJOR LEONEL',
        'CABO VERDE',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124079',
        'EE PROFESSOR PEDRO SATURNINO DE MAGALHÃES',
        'CABO VERDE',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124214',
        'CESEC PROFESSORA ELVIRA RODRIGUES PEREIRA',
        'CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '377929',
        'EE INDÍGENA DE EDUCAÇÃO INFANTIL ENSINO FUNDAMENTAL - ANOS INICIAIS E FINAIS E ENSINO MÉDIO',
        'CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '322610',
        'EE INDÍGENA XUCURU KARIRI - WARKANÃ DE ARUANÃ',
        'CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124231',
        'EE JOSÉ FRANCO',
        'CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124184',
        'EE SOUZA NOVAIS',
        'CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124192',
        'EE VICENTE LANDI JÚNIOR',
        'CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124290',
        'EE ELIAS JORGE ZENUN',
        'CAMPESTRE',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124303',
        'EE RUI BARBOSA',
        'CAMPESTRE',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124346',
        'EE DONA COTINHA',
        'CONCEIÇÃO DA APARECIDA',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124311',
        'EE PADRE JOSÉ ANTÔNIO PANUCCI',
        'CONCEIÇÃO DA APARECIDA',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124419',
        'EE SECRETÁRIO TRISTÃO DA CUNHA',
        'DIVISA NOVA',
        'SRE POÇOS DE CALDAS'
    ),
(
        '279293',
        'EE CALIMÉRIA SILVEIRA',
        'IBITIÚRA DE MINAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124516',
        'EE FREI LEVINO',
        'MONTE BELO',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124524',
        'EE PRESIDENTE TANCREDO DE ALMEIDA NEVES',
        'MONTE BELO',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124575',
        'EE CESÁRIO COIMBRA',
        'MUZAMBINHO',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124656',
        'EE PROFESSOR SALATIEL DE ALMEIDA',
        'MUZAMBINHO',
        'SRE POÇOS DE CALDAS'
    ),
(
        '312061',
        'EE PADRE LUIZ MORENO',
        'NOVA RESENDE',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124664',
        'EE PROFESSOR CAIO ALBUQUERQUE',
        'NOVA RESENDE',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124931',
        'CESEC PROFESSORA HELOÍSA LACERDA',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124737',
        'EE DAVID CAMPISTA',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '338869',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124745',
        'EE DONA FRANCISCA TAMM BIAS FORTES',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124877',
        'EE DOUTOR EDMUNDO GOUVEA CARDILLO',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124729',
        'EE DOUTOR JOÃO EUGÊNIO DE ALMEIDA',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124761',
        'EE FRANCISCO ESCOBAR',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124818',
        'EE PROFESSOR ARLINDO PEREIRA - CENTRO DE EDUCAÇÃO POLITÉCNICA',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124923',
        'EE PROFESSOR JOSÉ CASTRO DE ARAÚJO',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124826',
        'EE PROFESSORA CLEUSA LOVATO CALIARI',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124974',
        'EE CARLOS MAGNO DE CARVALHO',
        'SANTA RITA DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '124940',
        'EE DONA RITA AMÉLIA DE CARVALHO',
        'SANTA RITA DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '125024',
        'EE DIRETOR NELSON RODRIGUES',
        'SERRANIA',
        'SRE POÇOS DE CALDAS'
    ),
(
        '258971',
        'EE ABRE CAMPO',
        'ABRE CAMPO',
        'SRE PONTE NOVA'
    ),
(
        '128104',
        'EE DOM JOÃO BOSCO',
        'ABRE CAMPO',
        'SRE PONTE NOVA'
    ),
(
        '128121',
        'EE DOUTOR JOSÉ GROSSI',
        'ABRE CAMPO',
        'SRE PONTE NOVA'
    ),
(
        '128139',
        'EE PROFESSOR ERNESTO DE MELO BRANDÃO',
        'ABRE CAMPO',
        'SRE PONTE NOVA'
    ),
(
        '128252',
        'EE ANTÔNIO CARLOS',
        'ALVINÓPOLIS',
        'SRE PONTE NOVA'
    ),
(
        '128261',
        'EE DESEMBARGADOR BARCELOS CORREA',
        'ALVINÓPOLIS',
        'SRE PONTE NOVA'
    ),
(
        '322806',
        'EE GOVERNADOR BIAS FORTES',
        'ALVINÓPOLIS',
        'SRE PONTE NOVA'
    ),
(
        '128244',
        'EE PROFESSOR CÂNDIDO GOMES',
        'ALVINÓPOLIS',
        'SRE PONTE NOVA'
    ),
(
        '128279',
        'EE ALFREDO DO CARMO',
        'AMPARO DO SERRA',
        'SRE PONTE NOVA'
    ),
(
        '128325',
        'EE CÔNEGO JOSÉ ERMELINDO DE SOUZA',
        'ARAPONGA',
        'SRE PONTE NOVA'
    ),
(
        '128341',
        'EE JOSÉ DIAS DO CARMO',
        'ARAPONGA',
        'SRE PONTE NOVA'
    ),
(
        '128368',
        'EE CLAUDIONOR LOPES',
        'BARRA LONGA',
        'SRE PONTE NOVA'
    ),
(
        '128414',
        'EE PADRE JOSÉ EPIFÂNIO GONÇALVES',
        'BARRA LONGA',
        'SRE PONTE NOVA'
    ),
(
        '128449',
        'EE CAPITÃO ARNALDO DIAS ANDRADE',
        'CAJURI',
        'SRE PONTE NOVA'
    ),
(
        '128490',
        'EE ANTÔNIO LOPES SOARES',
        'CANAÃ',
        'SRE PONTE NOVA'
    ),
(
        '233200',
        'EE MARIA APARECIDA DAVID',
        'CANAÃ',
        'SRE PONTE NOVA'
    ),
(
        '128678',
        'EE PRESIDENTE TANCREDO NEVES',
        'DOM SILVÉRIO',
        'SRE PONTE NOVA'
    ),
(
        '128694',
        'EE AGOSTINHO HIPÓLITO DE F FREIRE',
        'GUARACIABA',
        'SRE PONTE NOVA'
    ),
(
        '128732',
        'EE HERMÓGENES FERREIRA DA SILVA',
        'GUARACIABA',
        'SRE PONTE NOVA'
    ),
(
        '128716',
        'EE JOSÉ MATEUS DE VASCONCELOS',
        'GUARACIABA',
        'SRE PONTE NOVA'
    ),
(
        '128724',
        'EE PADRE DIMAS',
        'GUARACIABA',
        'SRE PONTE NOVA'
    ),
(
        '128791',
        'EE DE PISCAMBA',
        'JEQUERI',
        'SRE PONTE NOVA'
    ),
(
        '128775',
        'EE DO GROTA',
        'JEQUERI',
        'SRE PONTE NOVA'
    ),
(
        '128741',
        'EE PADRE BENEVENUTO',
        'JEQUERI',
        'SRE PONTE NOVA'
    ),
(
        '128821',
        'EE SÃO VICENTE DO GRAMA',
        'JEQUERI',
        'SRE PONTE NOVA'
    ),
(
        '128759',
        'EE TENENTE MOL',
        'JEQUERI',
        'SRE PONTE NOVA'
    ),
(
        '129135',
        'EE DOUTOR FRANCISCO VIEIRA MARTINS',
        'ORATÓRIOS',
        'SRE PONTE NOVA'
    ),
(
        '353825',
        'EE ALFENO FRANCISCO DO CARMO',
        'PEDRA BONITA',
        'SRE PONTE NOVA'
    ),
(
        '128147',
        'EE DOM OSCAR DE OLIVEIRA',
        'PEDRA BONITA',
        'SRE PONTE NOVA'
    ),
(
        '128856',
        'EE JOSÉ ALBINO LEAL',
        'PEDRA DO ANTA',
        'SRE PONTE NOVA'
    ),
(
        '128881',
        'EE CORONEL ANTONINHO',
        'PIEDADE DE PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '129127',
        'CESEC PROFESSORA VERA PARENTONI',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '338877',
        'EE ANTÔNIO COELHO',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '128902',
        'EE CAETANO MARINHO',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '128929',
        'EE CARLOS TRIVELLATO',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '128945',
        'EE CORONEL CANTÍDIO DRUMOND',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '129062',
        'EE PROFESSOR ANTÔNIO GONÇALVES LANNA',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '129071',
        'EE PROFESSOR RAYMUNDO MARTINIANO FERREIRA',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '129101',
        'EE SENADOR ANTÔNIO MARTINS',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '310590',
        'EE CORONEL AMANTINO',
        'PORTO FIRME',
        'SRE PONTE NOVA'
    ),
(
        '129194',
        'EE IMACULADA CONCEIÇÃO',
        'PORTO FIRME',
        'SRE PONTE NOVA'
    ),
(
        '129208',
        'EE SOLON ILDEFONSO',
        'PORTO FIRME',
        'SRE PONTE NOVA'
    ),
(
        '129241',
        'CESEC RÉCIO DE SOUZA RIBEIRO',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129283',
        'EE ALBANO PIRES',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129224',
        'EE BENEDITO VALADARES',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129259',
        'EE DOM HELVÉCIO GOMES DE OLIVEIRA',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129305',
        'EE DR LUIZ MARTINS SOARES',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129275',
        'EE JOÃO FELISBERTO DA COSTA',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129267',
        'EE PADRE JÚLIO MARIA',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129313',
        'EE REGINA PACIS',
        'RAUL SOARES',
        'SRE PONTE NOVA'
    ),
(
        '129381',
        'EE IMACULADA CONCEIÇÃO',
        'RIO CASCA',
        'SRE PONTE NOVA'
    ),
(
        '129437',
        'EE MARIA AMÉLIA',
        'RIO DOCE',
        'SRE PONTE NOVA'
    ),
(
        '129461',
        'EE DOUTOR OTÁVIO SOARES',
        'SANTA CRUZ DO ESCALVADO',
        'SRE PONTE NOVA'
    ),
(
        '129534',
        'EE MARIANO GOMES',
        'SANTO ANTÔNIO DO GRAMA',
        'SRE PONTE NOVA'
    ),
(
        '129551',
        'EE JOSÉ DE ASSIS PINTO',
        'SÃO MIGUEL DO ANTA',
        'SRE PONTE NOVA'
    ),
(
        '129585',
        'EE PEDRO LESSA',
        'SÃO MIGUEL DO ANTA',
        'SRE PONTE NOVA'
    ),
(
        '129593',
        'EE DO LAJÃO',
        'SÃO PEDRO DOS FERROS',
        'SRE PONTE NOVA'
    ),
(
        '129666',
        'EE OMAR REZENDE PEREZ',
        'SÃO PEDRO DOS FERROS',
        'SRE PONTE NOVA'
    ),
(
        '129658',
        'EE SENADOR LEVINDO COELHO',
        'SÃO PEDRO DOS FERROS',
        'SRE PONTE NOVA'
    ),
(
        '128686',
        'EE SÃO SEBASTIÃO',
        'SEM-PEIXE',
        'SRE PONTE NOVA'
    ),
(
        '129674',
        'EE CLÉLIA BERNARDES',
        'SERICITA',
        'SRE PONTE NOVA'
    ),
(
        '317420',
        'EE ANTÔNIO MOREIRA DE QUEIROZ',
        'TEIXEIRAS',
        'SRE PONTE NOVA'
    ),
(
        '129763',
        'EE DOUTOR MARIANO DA ROCHA',
        'TEIXEIRAS',
        'SRE PONTE NOVA'
    ),
(
        '129801',
        'EE CUSTÓDIO MARTINS DA SILVA',
        'URUCÂNIA',
        'SRE PONTE NOVA'
    ),
(
        '129828',
        'EE HELDER DE AQUINO',
        'URUCÂNIA',
        'SRE PONTE NOVA'
    ),
(
        '129836',
        'EE PROFESSOR MANUEL RUFINO',
        'URUCÂNIA',
        'SRE PONTE NOVA'
    ),
(
        '129321',
        'EE FARMACÊUTICO SOARES',
        'VERMELHO NOVO',
        'SRE PONTE NOVA'
    ),
(
        '259551',
        'CESEC DOUTOR ALTAMIRO SARAIVA',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '130036',
        'EE ALICE LOUREIRO',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '129992',
        'EE DR RAIMUNDO ALVES TORRES',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '129861',
        'EE EFFIE ROLFS',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '130044',
        'EE JOSÉ LOURENÇO DE FREITAS',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '129895',
        'EE MADRE SANTA FACE',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '129941',
        'EE PADRE ÁLVARO CORREA BORGES',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '339075',
        'EE PROFESSOR CID BATISTA - EJA',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '217778',
        'EE RAUL DE LEONI',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '130001',
        'EE SANTA RITA DE CÁSSIA',
        'VIÇOSA',
        'SRE PONTE NOVA'
    ),
(
        '294705',
        'EE JOSÉ GOMES DE MORAIS FILHO',
        'ALBERTINA',
        'SRE POUSO ALEGRE'
    ),
(
        '54275',
        'EE CORONEL ANANIAS DE ANDRADE',
        'BOM REPOUSO',
        'SRE POUSO ALEGRE'
    ),
(
        '54399',
        'EE DOM OTÁVIO CHAGAS DE MIRANDA',
        'BORDA DA MATA',
        'SRE POUSO ALEGRE'
    ),
(
        '54356',
        'EE LAURO AFONSO MEGALE',
        'BORDA DA MATA',
        'SRE POUSO ALEGRE'
    ),
(
        '54381',
        'EE PIO XII',
        'BORDA DA MATA',
        'SRE POUSO ALEGRE'
    ),
(
        '54542',
        'EE SECRETÁRIO OLINTO ORSINI',
        'BUENO BRANDÃO',
        'SRE POUSO ALEGRE'
    ),
(
        '54607',
        'EE CÔNEGO JOSÉ EUGÊNIO DE FARIA',
        'CACHOEIRA DE MINAS',
        'SRE POUSO ALEGRE'
    ),
(
        '54615',
        'EE PROFESSOR FURTADO DE MENDONÇA',
        'CACHOEIRA DE MINAS',
        'SRE POUSO ALEGRE'
    ),
(
        '54593',
        'EE SENADOR BUENO DE PAIVA',
        'CACHOEIRA DE MINAS',
        'SRE POUSO ALEGRE'
    ),
(
        '54666',
        'CESEC PROFESSOR CLOTARIO GUILHERME DE MACEDO',
        'CAMANDUCAIA',
        'SRE POUSO ALEGRE'
    ),
(
        '342700',
        'EE VERNER GRINBERG',
        'CAMANDUCAIA',
        'SRE POUSO ALEGRE'
    ),
(
        '54640',
        'EE VIRGÍNIA MARCONDES ESCOBAR',
        'CAMANDUCAIA',
        'SRE POUSO ALEGRE'
    ),
(
        '54682',
        'EE ANTÔNIO FELIPE DE SALLES',
        'CAMBUÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '54755',
        'EE JOÃO LOPES',
        'CAMBUÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '54763',
        'EE PROFESSORA MARIA DA CONCEIÇÃO MORAES',
        'CAMBUÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '54780',
        'EE VEREADOR JOAQUIM BORGES DA COSTA',
        'CAREAÇU',
        'SRE POUSO ALEGRE'
    ),
(
        '124389',
        'EE MENDES DE OLIVEIRA',
        'CONGONHAL',
        'SRE POUSO ALEGRE'
    ),
(
        '54879',
        'EE PROFESSOR MAXIMIANO LAMBERT',
        'CÓRREGO DO BOM JESUS',
        'SRE POUSO ALEGRE'
    ),
(
        '55042',
        'EE DOM FRANCISCO SILVA',
        'ESPÍRITO SANTO DO DOURADO',
        'SRE POUSO ALEGRE'
    ),
(
        '55093',
        'EE CÔNEGO FRANCISCO STELLA',
        'ESTIVA',
        'SRE POUSO ALEGRE'
    ),
(
        '55107',
        'EE EDUARDO AMARAL',
        'ESTIVA',
        'SRE POUSO ALEGRE'
    ),
(
        '55166',
        'CESEC DOM JOÃO BOSCO',
        'EXTREMA',
        'SRE POUSO ALEGRE'
    ),
(
        '55123',
        'EE ALFREDO OLIVOTTI',
        'EXTREMA',
        'SRE POUSO ALEGRE'
    ),
(
        '55158',
        'EE ODETE VALADARES',
        'EXTREMA',
        'SRE POUSO ALEGRE'
    ),
(
        '172766',
        'EE PREFEITO CELSO VIEIRA VILELA',
        'HELIODORA',
        'SRE POUSO ALEGRE'
    ),
(
        '55280',
        'EE FELIPE DOS SANTOS',
        'INCONFIDENTES',
        'SRE POUSO ALEGRE'
    ),
(
        '124460',
        'EE CRISTIANO MACHADO',
        'IPUIÚNA',
        'SRE POUSO ALEGRE'
    ),
(
        '55590',
        'EE DOUTOR JOSÉ RODRIGUES SEABRA',
        'ITAPEVA',
        'SRE POUSO ALEGRE'
    ),
(
        '55611',
        'EE FLORIANO SARETTI',
        'JACUTINGA',
        'SRE POUSO ALEGRE'
    ),
(
        '55620',
        'EE JÚLIO BRANDÃO',
        'JACUTINGA',
        'SRE POUSO ALEGRE'
    ),
(
        '55662',
        'EE PROFESSORA MARIA ROBERTO DE LIMA',
        'JACUTINGA',
        'SRE POUSO ALEGRE'
    ),
(
        '55816',
        'EE PROVEDOR THEÓFILO TAVARES PAES',
        'MONTE SIÃO',
        'SRE POUSO ALEGRE'
    ),
(
        '55832',
        'EE EMÍLIO MOURA',
        'MUNHOZ',
        'SRE POUSO ALEGRE'
    ),
(
        '55972',
        'CESEC PROFESSORA PAULITA DE QUEIROZ MIRANDA',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '55891',
        'EE CORONEL PAIVA',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '55981',
        'EE ERNESTO BARBOSA',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '55905',
        'EE FRANCISCO RIBEIRO DA FONSECA',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '55930',
        'EE HORÁCIO NARCISO DE GÓES',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '55948',
        'EE PROFESSOR GUERINO CASASANTA',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '55964',
        'EE PROFESSOR JUVENAL BRANDÃO',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '218138',
        'EE PROFESSORA DELORME DE AVELLAR MUNIZ',
        'OURO FINO',
        'SRE POUSO ALEGRE'
    ),
(
        '56537',
        'CESEC PROFESSORA HERMELINDA TOLEDO',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '372099',
        'EE DE ENSINO MÉDIO',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '372102',
        'EE DE ENSINO MÉDIO',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56367',
        'EE DOM JOÃO REZENDE COSTA',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56383',
        'EE DOUTOR JOSÉ MARQUES DE OLIVEIRA',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56413',
        'EE MONSENHOR JOSÉ PAULINO',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56430',
        'EE PRESIDENTE ARTHUR DA COSTA E SILVA',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56448',
        'EE PRESIDENTE BERNARDES',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56456',
        'EE PROFESSOR JOAQUIM QUEIROZ',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56359',
        'EE PROFESSORA GERALDINA TOSTA',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56545',
        'EE PROFESSORA MARIANA PEREIRA FERNANDES',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56481',
        'EE VINÍCIUS MEYER',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56502',
        'EE VIRGÍLIA PASCHOAL',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '56588',
        'EE DOUTOR DELFIM MOREIRA',
        'SANTA RITA DO SAPUCAÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '56596',
        'EE DOUTOR LUIZ PINTO DE ALMEIDA',
        'SANTA RITA DO SAPUCAÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '56626',
        'EE SANICO TELES',
        'SANTA RITA DO SAPUCAÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '56634',
        'EE SINHÁ MOREIRA',
        'SANTA RITA DO SAPUCAÍ',
        'SRE POUSO ALEGRE'
    ),
(
        '56642',
        'EE CÔNEGO PAULO MONTEIRO',
        'SÃO JOÃO DA MATA',
        'SRE POUSO ALEGRE'
    ),
(
        '56677',
        'EE CORONEL GABRIEL CAPISTRANO',
        'SÃO SEBASTIÃO DA BELA VISTA',
        'SRE POUSO ALEGRE'
    ),
(
        '54771',
        'EE PROFESSORA MARIA VITORINO DE SOUZA',
        'SENADOR AMARAL',
        'SRE POUSO ALEGRE'
    ),
(
        '124982',
        'EE PROFESSOR MENDONÇA',
        'SENADOR JOSÉ BENTO',
        'SRE POUSO ALEGRE'
    ),
(
        '56723',
        'EE MAGALHÃES CARNEIRO',
        'SILVIANÓPOLIS',
        'SRE POUSO ALEGRE'
    ),
(
        '54402',
        'EE JOSÉ TOMÁS CANTUÁRIA JÚNIOR',
        'TOCOS DO MOJI',
        'SRE POUSO ALEGRE'
    ),
(
        '56766',
        'EE DO BAIRRO DOS PEREIRAS',
        'TOLEDO',
        'SRE POUSO ALEGRE'
    ),
(
        '56758',
        'EE RAIMUNDO CORRÊA',
        'TOLEDO',
        'SRE POUSO ALEGRE'
    ),
(
        '133728',
        'EE ANTÔNIO CARLOS DE CARVALHO',
        'BOM SUCESSO',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '133744',
        'EE BENJAMIM GUIMARÃES',
        'BOM SUCESSO',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '133922',
        'EE SARA KUBITSCHEK',
        'CARRANCAS',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '133931',
        'EE ADÍLIO JOSÉ BORGES',
        'CONCEIÇÃO DA BARRA DE MINAS',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '133949',
        'EE CORONEL XAVIER CHAVES',
        'CORONEL XAVIER CHAVES',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '133973',
        'EE DUQUE DE CAXIAS',
        'DORES DE CAMPOS',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134007',
        'EE PROFESSOR JÚLIO BUENO',
        'IBITURUNA',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134040',
        'EE MAURÍCIO ZAKHIA',
        'IJACI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134104',
        'EE RAMIRO DE SOUZA ANDRADE',
        'INGAÍ',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134139',
        'EE CERRADO DO ROSÁRIO',
        'ITUMIRIM',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134147',
        'EE DE MACUCO DE MINAS',
        'ITUMIRIM',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134121',
        'EE DOM DELFIM',
        'ITUMIRIM',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134163',
        'EE JAIME FERREIRA LEITE',
        'ITUTINGA',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '305600',
        'EE ABEILARD PEREIRA',
        'LAGOA DOURADA',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134295',
        'EE PROFESSOR BASÍLIO DE MAGALHÃES',
        'NAZARENO',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134333',
        'EE DOUTOR VIVIANO CALDAS',
        'PRADOS',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134368',
        'EE ASSIS RESENDE',
        'RESENDE COSTA',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134414',
        'EE PADRE CRISPINIANO',
        'RITÁPOLIS',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134911',
        'EE AMÉLIA PASSOS',
        'SANTA CRUZ DE MINAS',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134759',
        'CESEC PROFESSOR JOSÉ AMÉRICO DA COSTA',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134571',
        'EE AURELIANO PIMENTEL',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134546',
        'EE BRIGHENTI CESARE',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134562',
        'EE CÔNEGO OSVALDO LUSTOSA',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134597',
        'EE DEPUTADO MATEUS SALOMÉ',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '338885',
        'EE DETETIVE MARCO ANTONIO DE SOUZA',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134619',
        'EE DOUTOR GARCIA DE LIMA',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134791',
        'EE EVANDRO ÁVILA',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134635',
        'EE GOVERNADOR MILTON CAMPOS',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134643',
        'EE IDALINA HORTA GALVÃO',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134651',
        'EE INÁCIO PASSOS',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134660',
        'EE JOÃO DOS SANTOS',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134694',
        'EE MINISTRO GABRIEL PASSOS',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134805',
        'EE PADRE LOPES',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134716',
        'EE PROFESSOR IAGO PIMENTEL',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134724',
        'EE TOMÉ PORTES DEL REI',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134813',
        'EE AFONSO PENA JÚNIOR',
        'SÃO TIAGO',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134872',
        'EE DE MERCÊS DE ÁGUA LIMPA',
        'SÃO TIAGO',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '310786',
        'EE HENRIQUE PEREIRA SANTIAGO',
        'SÃO TIAGO',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '134881',
        'EE BASÍLIO DA GAMA',
        'TIRADENTES',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '136875',
        'EE CORONEL LUCAS MAGALHÃES',
        'ARCEBURGO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '136891',
        'EE DOUTOR JOSÉ TEODORO DE SOUZA',
        'CAPETINGA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137006',
        'EE MELO VIANA',
        'CÁSSIA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '136948',
        'EE SÃO GABRIEL',
        'CÁSSIA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137065',
        'EE IARBAS RODRIGUES',
        'CLARAVAL',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137073',
        'EE ALICE AUTRAN DOURADO',
        'GUARANÉSIA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137090',
        'EE CARVALHO BRITO',
        'GUARANÉSIA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137146',
        'EE GERALDO RIBEIRO DIAS',
        'GUARANÉSIA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137227',
        'EE DONA QUERIDINHA BIAS FORTES',
        'GUAXUPÉ',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137324',
        'EE DOUTOR ANDRÉ CORTEZ GRANERO',
        'GUAXUPÉ',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137235',
        'EE DOUTOR BENEDITO LEITE RIBEIRO',
        'GUAXUPÉ',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137251',
        'EE MAJOR LUIZ ZERBINI',
        'GUAXUPÉ',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137278',
        'EE NOSSA SENHORA APARECIDA',
        'GUAXUPÉ',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137341',
        'EE DE IBIRACI',
        'IBIRACI',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137359',
        'EE DOUTOR ANTÔNIO CARLOS',
        'IBIRACI',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137413',
        'EE DE ITAMOGI',
        'ITAMOGI',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137456',
        'EE JOSÉ SOARES DE ARAÚJO',
        'ITAMOGI',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '240800',
        'EE ARY PIMENTA BUGELLI',
        'ITAÚ DE MINAS',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137502',
        'EE PROFESSORA MARIA LEONOR NASSER',
        'JACUÍ',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137529',
        'EE EDUARDO SENEDESE',
        'JURUAIA',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137545',
        'EE AMÉRICO DE PAIVA',
        'MONTE SANTO DE MINAS',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137669',
        'EE DE MILAGRE',
        'MONTE SANTO DE MINAS',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137618',
        'EE DOUTOR WENCESLAU BRAZ',
        'MONTE SANTO DE MINAS',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137677',
        'EE CORONEL NECA LEMOS',
        'PRATÁPOLIS',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137707',
        'EE DOUTOR FARID SILVA',
        'PRATÁPOLIS',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137847',
        'EE CORONEL JOÃO FERREIRA BARBOSA',
        'SÃO PEDRO DA UNIÃO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '138011',
        'CESEC ALDA POLASTRE',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137987',
        'EE BENEDITO FERREIRA CALAFIORI',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137880',
        'EE CLÓVIS SALGADO',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137936',
        'EE COMENDADOR JOÃO ALVES DE FIGUEIREDO',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137910',
        'EE COMENDADORA ANA CÂNDIDA DE FIGUEIREDO',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137898',
        'EE CORONEL JOSÉ CÂNDIDO',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137944',
        'EE PARAISENSE',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137928',
        'EE PAULA FRASSINETTI',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '212431',
        'EE PROFESSORA INÊS MIRANDA ALMEIDA',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '137961',
        'EE SÃO JOÃO DA ESCÓCIA',
        'SÃO SEBASTIÃO DO PARAÍSO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '138053',
        'EE DOUTOR TANCREDO DE ALMEIDA NEVES',
        'SÃO TOMÁS DE AQUINO',
        'SRE SÃO SEBASTIÃO DO PARAÍSO'
    ),
(
        '311189',
        'EE PROFESSORA MARIA DA CONCEIÇÃO SILVA',
        'ARAÇAÍ',
        'SRE SETE LAGOAS'
    ),
(
        '140325',
        'EE JOSÉ RIBEIRO DA SILVA',
        'BALDIM',
        'SRE SETE LAGOAS'
    ),
(
        '140376',
        'EE OSCAR ARTUR GUIMARÃES',
        'BALDIM',
        'SRE SETE LAGOAS'
    ),
(
        '267805',
        'EE MARIA ANÁLIA MENDES FERREIRA',
        'CACHOEIRA DA PRATA',
        'SRE SETE LAGOAS'
    ),
(
        '140465',
        'EE PROFESSORA DORA SILVA',
        'CAETANÓPOLIS',
        'SRE SETE LAGOAS'
    ),
(
        '140481',
        'EE FRANCISCO SALES',
        'CAPIM BRANCO',
        'SRE SETE LAGOAS'
    ),
(
        '310611',
        'EE MESTRE CORNÉLIO',
        'CAPIM BRANCO',
        'SRE SETE LAGOAS'
    ),
(
        '140538',
        'EE CLÁUDIO PINHEIRO DE LIMA',
        'CORDISBURGO',
        'SRE SETE LAGOAS'
    ),
(
        '140554',
        'EE MESTRE CANDINHO',
        'CORDISBURGO',
        'SRE SETE LAGOAS'
    ),
(
        '140589',
        'EE PROFESSOR ANÍSIO TEIXEIRA',
        'CORDISBURGO',
        'SRE SETE LAGOAS'
    ),
(
        '141003',
        'EE CORONEL AMÉRICO TEIXEIRA GUIMARÃES',
        'FORTUNA DE MINAS',
        'SRE SETE LAGOAS'
    ),
(
        '141038',
        'EE ALUÍSIO FERREIRA DE SOUZA',
        'FUNILÂNDIA',
        'SRE SETE LAGOAS'
    ),
(
        '141054',
        'EE DIOLINO MOREIRA',
        'FUNILÂNDIA',
        'SRE SETE LAGOAS'
    ),
(
        '141101',
        'EE MESSIAS ANTÔNIO GUIMARÃES',
        'INHAÚMA',
        'SRE SETE LAGOAS'
    ),
(
        '141135',
        'EE PROFESSOR VÍTOR PINTO',
        'JEQUITIBÁ',
        'SRE SETE LAGOAS'
    ),
(
        '34274',
        'EE PROFESSOR FRANCISCO TIBÚRCIO',
        'MARAVILHAS',
        'SRE SETE LAGOAS'
    ),
(
        '141194',
        'EE BENTO GONÇALVES',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '141275',
        'EE FELÍCIA FERNANDES CAMPOS',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '141259',
        'EE HERMELITA SOARES HORTA',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '141186',
        'EE PROFESSORA VITIZA OCTAVIANO VIANA',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '141216',
        'EE VISCONDE DO RIO DAS VELHAS',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '310646',
        'EE WALDEMAR PEZZINI',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '34843',
        'EE DIOGO DE CASTRO',
        'PAPAGAIOS',
        'SRE SETE LAGOAS'
    ),
(
        '34835',
        'EE JACIR LOPES DUARTE',
        'PAPAGAIOS',
        'SRE SETE LAGOAS'
    ),
(
        '34860',
        'EE RENATO FILGUEIRAS',
        'PAPAGAIOS',
        'SRE SETE LAGOAS'
    ),
(
        '230995',
        'EE AGNALDO EDMUNDO SILVA',
        'PARAOPEBA',
        'SRE SETE LAGOAS'
    ),
(
        '141321',
        'EE CONSELHEIRO AFONSO PENA',
        'PARAOPEBA',
        'SRE SETE LAGOAS'
    ),
(
        '310654',
        'EE JOAQUINA CÂNDIDA MOREIRA',
        'PARAOPEBA',
        'SRE SETE LAGOAS'
    ),
(
        '141356',
        'EE PADRE AUGUSTO HORTA',
        'PARAOPEBA',
        'SRE SETE LAGOAS'
    ),
(
        '141437',
        'EE DONA FRANCISCA DE OLIVEIRA',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '141445',
        'EE DR JACINTO CAMPOS',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '141399',
        'EE MINISTRO FRANCISCO CAMPOS',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '231762',
        'EE PAULO CAMPOS GUIMARÃES',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '141470',
        'EE PEDRO ROBERTO DE MENEZES',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '231550',
        'EE ANTÔNIO DELPHINO DOS SANTOS',
        'PRUDENTE DE MORAIS',
        'SRE SETE LAGOAS'
    ),
(
        '141488',
        'EE JOÃO RODRIGUES DA SILVA',
        'PRUDENTE DE MORAIS',
        'SRE SETE LAGOAS'
    ),
(
        '310662',
        'EE VIRGÍLIO DE MELO FRANCO',
        'PRUDENTE DE MORAIS',
        'SRE SETE LAGOAS'
    ),
(
        '141526',
        'EE CORONEL DOMINGOS DINIZ COUTO',
        'SANTANA DE PIRAPAMA',
        'SRE SETE LAGOAS'
    ),
(
        '141585',
        'EE JOÃO MARTINS GUIMARÃES',
        'SANTANA DE PIRAPAMA',
        'SRE SETE LAGOAS'
    ),
(
        '141542',
        'EE JUVELINO VIEIRA DE ÁVILA',
        'SANTANA DE PIRAPAMA',
        'SRE SETE LAGOAS'
    ),
(
        '141615',
        'CESEC DE SETE LAGOAS',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '205591',
        'EE ANTÔNIO FRANCISCO DE OLIVEIRA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '229288',
        'EE ÁPIO SÓLON CARDOSO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141925',
        'EE BERNARDO VALADARES DE VASCONCELLOS',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '339296',
        'EE CAPITÃO JOÃO LÚCIO DO CARMO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '372110',
        'EE DE ENSINO  MÉDIO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141801',
        'EE DEPUTADO RENATO AZEREDO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141593',
        'EE DOUTOR AFONSO VIANA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141887',
        'EE DOUTOR ALONSO MARQUES FERREIRA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141631',
        'EE DOUTOR ARTHUR BERNARDES',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141674',
        'EE DOUTOR AVELAR',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141704',
        'EE DOUTOR OLINTO SÁTYRO ALVIM',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141721',
        'EE DOUTOR ULISSES VASCONCELOS',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141640',
        'EE EDITE FURST',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141682',
        'EE EMÍLIO DE VASCONCELOS COSTA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141658',
        'EE EPONINA SOARES DOS SANTOS',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '310689',
        'EE GOVERNADOR JUSCELINO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141763',
        'EE JOSÉ EVANGELISTA FRANÇA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '213675',
        'EE JÚLIO CÉSAR REIS OLIVEIRA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '310671',
        'EE MARIA AMÂNCIO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141798',
        'EE MAURILO DE JESUS PEIXOTO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '353469',
        'EE MAURO FACCIO GONÇALVES',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141810',
        'EE MODESTINO ANDRADE SOBRINHO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '218944',
        'EE PREFEITO ZICO PAIVA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141844',
        'EE PROFESSOR CÂNDIDO AZEREDO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141852',
        'EE PROFESSOR JOÃO FERNANDINO JÚNIOR',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141861',
        'EE PROFESSOR ROUSSET',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141933',
        'EE PROFESSORA ELZA MOREIRA LOPES',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '349305',
        'EE RUTH BRANDÃO DE AZEREDO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141909',
        'EE SANTOS AZEREDO',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '141895',
        'EE SINHÁ ANDRADE',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '342572',
        'EE VENCESLAU BRÁS',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '145912',
        'EE CAPITÃO INÁCIO SOARES',
        'ÁGUAS FORMOSAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '145904',
        'EE CARLOS MAGNO REBOUÇAS',
        'ÁGUAS FORMOSAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '145921',
        'EE CESÁRIO MATIAS DE ALMEIDA',
        'ÁGUAS FORMOSAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '145947',
        'EE DE ÁGUA QUENTE',
        'ÁGUAS FORMOSAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '145955',
        'EE JOSÉ QUARESMA DA COSTA',
        'ÁGUAS FORMOSAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '145963',
        'EE MAJOR RAIMUNDO FELICÍSSIMO',
        'ÁGUAS FORMOSAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '338818',
        'EE DANIEL PEREIRA OTTONI',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146412',
        'EE DE NOVO HORIZONTE',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146391',
        'EE DE SÃO MIGUEL',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146315',
        'EE DOUTOR ANTÔNIO OLINTO',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146285',
        'EE PREFEITO CLEMENTE ESTEVES FERRAZ',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146331',
        'EE PROFESSORA ALNEDA DE MATOS MACHADO',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146323',
        'EE PROFESSORA HERMÍNIA P DE ALMEIDA',
        'ATALÉIA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146421',
        'EE DE BERTÓPOLIS',
        'BERTÓPOLIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146439',
        'EE DE UMBURANINHA',
        'BERTÓPOLIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '269867',
        'EE INDÍGENA CAPITÃOZINHO MAXAKALI',
        'BERTÓPOLIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146471',
        'EE ANTÔNIO DUARTE SOBRINHO',
        'CAMPANÁRIO',
        'SRE TEÓFILO OTONI'
    ),
(
        '146510',
        'EE DE CARAÍ',
        'CARAÍ',
        'SRE TEÓFILO OTONI'
    ),
(
        '372072',
        'EE DE ENSINO MÉDIO',
        'CARAÍ',
        'SRE TEÓFILO OTONI'
    ),
(
        '146536',
        'EE DOM JOSÉ DE HAAS',
        'CARAÍ',
        'SRE TEÓFILO OTONI'
    ),
(
        '146544',
        'EE ORLANDO TAVARES',
        'CARAÍ',
        'SRE TEÓFILO OTONI'
    ),
(
        '146528',
        'EE PROFESSOR ABGAR RENAULT',
        'CARAÍ',
        'SRE TEÓFILO OTONI'
    ),
(
        '146579',
        'EE DOUTOR JOÃO BERALDO',
        'CARLOS CHAGAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146625',
        'EE EPAMINONDAS OTONI',
        'CARLOS CHAGAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146561',
        'EE GERALDO DE SOUZA NORTE',
        'CARLOS CHAGAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146633',
        'EE OLGA PRATES',
        'CARLOS CHAGAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '346179',
        'EE PROFESSORA ANTÔNIA BERNARDO RODRIGUES',
        'CARLOS CHAGAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146749',
        'EE DOUTOR CIRO MACIEL',
        'CATUJI',
        'SRE TEÓFILO OTONI'
    ),
(
        '330591',
        'EE GEORGINA FERREIRA BATISTA',
        'CATUJI',
        'SRE TEÓFILO OTONI'
    ),
(
        '145980',
        'EE RAUL FERREIRA SOUTO',
        'CRISÓLITA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147222',
        'EE DE ANTÔNIO FERREIRA',
        'FRANCISCÓPOLIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147249',
        'EE MARIA DA SILVA ROCHA',
        'FRANCISCÓPOLIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146706',
        'EE SALMEN BUKZEM',
        'FREI GASPAR',
        'SRE TEÓFILO OTONI'
    ),
(
        '146714',
        'EE DE PAMPÃ',
        'FRONTEIRA DOS VALES',
        'SRE TEÓFILO OTONI'
    ),
(
        '146731',
        'EE CORONEL CLEMENTE LUIZ',
        'ITAIPÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '319082',
        'EE PROFESSORA FRANCISCA MATOS',
        'ITAIPÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '146811',
        'EE CARLOS PRATES',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146757',
        'EE DOUTOR TRISTÃO DA CUNHA',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146803',
        'EE FREI GASPAR DE MÓDICA',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146820',
        'EE MADRE SERAFINA DE JESUS',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146781',
        'EE PROFESSORA MÍLCIA DE OLIVEIRA ABRANTES',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146871',
        'EE RAMIRO SOUZA E SILVA',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146862',
        'EE VEREADOR JÚLIO LAGES',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '146501',
        'EE CASSIMIRO DE ABREU',
        'JAMPRUCA',
        'SRE TEÓFILO OTONI'
    ),
(
        '146480',
        'EE CORONEL ANTÔNIO LOPES',
        'JAMPRUCA',
        'SRE TEÓFILO OTONI'
    ),
(
        '369870',
        'EE DE ENSINO FUNDAMENTAL',
        'JAMPRUCA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147109',
        'EE DE CONCÓRDIA DO MUCURI',
        'LADAINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147052',
        'EE DE LADAINHA',
        'LADAINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147087',
        'EE ENGENHEIRO WENEFREDO PORTELLA',
        'LADAINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '338826',
        'EE INDÍGENA IZABEL DA SILVA MAXAKALI',
        'LADAINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147095',
        'EE NOSSA SENHORA DO ROSÁRIO',
        'LADAINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '253839',
        'EE ANTÔNIO DIAS DOS SANTOS',
        'MACHACALIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147133',
        'EE JOSÉ DE ALENCAR',
        'MACHACALIS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147281',
        'EE DE JAGUARITIRA',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147311',
        'EE DE SANTO ANTÔNIO DO MUCURI',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147168',
        'EE DEPUTADO CASTRO PIRES',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147290',
        'EE GERALDO DOS SANTOS COIMBRA',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147206',
        'EE MESTRA ZULMIRA',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147141',
        'EE MONSENHOR CLÓVIS VIEIRA DA FONSECA',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147192',
        'EE STELLA ABRANTES',
        'MALACACHETA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147397',
        'EE ÁLVARO AMORIM',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147419',
        'EE ÁLVARO ROMANO',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147451',
        'EE ANTÔNIO BATISTA DA MOTA',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147401',
        'EE GOVERNADOR BIAS FORTES',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147486',
        'EE JOSEPH STALIM ROMANO',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147494',
        'EE PASTOR PAULO NOBRE NASCIMENTO',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147508',
        'EE PÉRICLES COELHO',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147460',
        'EE STELLA MATUTINA',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147478',
        'EE UNIÃO BENEFICENTE OPERÁRIA',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147389',
        'EE VALE DO MUCURI',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '147575',
        'EE ANTÔNIO RAMOS DE SOUZA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '326119',
        'EE AUGUSTO SOARES',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '218430',
        'EE DA FAZENDA ARUEGA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147583',
        'EE DE LAMBARI',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147648',
        'EE DE SANTA BÁRBARA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147621',
        'EE DO LUFA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147559',
        'EE DOM JOSÉ DE HAAS',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147541',
        'EE EDUARDO MILTON DA SILVA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147567',
        'EE INÁCIO MURTA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147656',
        'EE JOSÉ MENDES BARBOSA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147664',
        'EE MARIA CÂNDIDA REIS',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147613',
        'EE SUL AMÉRICA',
        'NOVO CRUZEIRO',
        'SRE TEÓFILO OTONI'
    ),
(
        '346144',
        'EE ADOLFO TEIXEIRA DE SOUZA',
        'NOVO ORIENTE DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '148393',
        'EE DE FREI GONZAGA',
        'NOVO ORIENTE DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '148385',
        'EE PAULO PINHEIRO CHAGAS',
        'NOVO ORIENTE DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '254487',
        'EE ELISA LEAL',
        'OURO VERDE DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147672',
        'EE VEREADOR LUZO FREITAS DE ARAÚJO',
        'OURO VERDE DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147681',
        'EE DA VILA SÃO JOÃO',
        'PADRE PARAÍSO',
        'SRE TEÓFILO OTONI'
    ),
(
        '330574',
        'EE DE ENSINO MÉDIO',
        'PADRE PARAÍSO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147699',
        'EE DOUTOR CÂNDIDO ULHOA',
        'PADRE PARAÍSO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147702',
        'EE PRESIDENTE JOÃO PINHEIRO',
        'PADRE PARAÍSO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147711',
        'EE PROFESSOR JOSÉ MONTEIRO FONSECA',
        'PADRE PARAÍSO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147729',
        'EE BENJAMIM DA CUNHA',
        'PAVÃO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147737',
        'EE CAIO NÉLSON DE SENA',
        'PAVÃO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147753',
        'EE DO POVOADO DE LIMEIRA',
        'PAVÃO',
        'SRE TEÓFILO OTONI'
    ),
(
        '147788',
        'EE DOUTOR TRISTÃO DA CUNHA',
        'PESCADOR',
        'SRE TEÓFILO OTONI'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '147010',
        'EE ALONZO BARBUDA',
        'PONTO DOS VOLANTES',
        'SRE TEÓFILO OTONI'
    ),
(
        '372080',
        'EE DE ENSINO MÉDIO',
        'PONTO DOS VOLANTES',
        'SRE TEÓFILO OTONI'
    ),
(
        '147028',
        'EE SANTANA DO ARAÇUAÍ',
        'PONTO DOS VOLANTES',
        'SRE TEÓFILO OTONI'
    ),
(
        '147796',
        'EE CLÁUDIO MANOEL',
        'POTÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '147818',
        'EE JOÃO FERREIRA DE OLIVEIRA',
        'POTÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '147834',
        'EE JOSÉ ARAUJO FONSECA',
        'POTÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '147826',
        'EE RIBEIRÃO DE SANTA CRUZ',
        'POTÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '147869',
        'EE VEREADOR SEBASTIÃO MAGALHÃES',
        'POTÉ',
        'SRE TEÓFILO OTONI'
    ),
(
        '146455',
        'EE EUCLIDES SILVEIRA TOLENTINO',
        'SANTA HELENA DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '269859',
        'EE INDÍGENA MAXAKALI',
        'SANTA HELENA DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '146447',
        'EE RAUL RODRIGUES SALOMÃO',
        'SANTA HELENA DE MINAS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147893',
        'EE DE SERRA DOS AIMORÉS',
        'SERRA DOS AIMORÉS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147923',
        'EE PEDRO GONZAGA',
        'SERRA DOS AIMORÉS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147931',
        'EE VANDA REUTER',
        'SERRA DOS AIMORÉS',
        'SRE TEÓFILO OTONI'
    ),
(
        '147354',
        'EE DE SETÚBAL',
        'SETUBINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147320',
        'EE GENTIL BARBOSA SENA',
        'SETUBINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '326101',
        'EE MADALENA PEREIRA JORGE',
        'SETUBINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147362',
        'EE NAGIB MAHMUD NÉDIR',
        'SETUBINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '147338',
        'EE PROFESSORA LEONOR ESTEVES LIMA',
        'SETUBINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '240818',
        'EE SOTURNO DA MATA',
        'SETUBINHA',
        'SRE TEÓFILO OTONI'
    ),
(
        '148199',
        'CESEC  DE TEÓFILO OTONI',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '147940',
        'EE ALBERTO BARREIROS',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '147966',
        'EE ALFREDO SÁ',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '147982',
        'EE ALTINO BARBOSA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148415',
        'EE ARTUR BERNARDES',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148059',
        'EE CLOTILDE ONOFRI DE CAMPOS',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148164',
        'EE DA CABECEIRA DE SÃO PEDRO',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148121',
        'EE DE BARRA DO CEDRO',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '326828',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148229',
        'EE DE LIBERDADE',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148431',
        'EE DE MUCURI',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148407',
        'EE DE PEDRO VERSIANI',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148288',
        'EE DEPUTADO GERALDO LANDI',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148300',
        'EE DOUTOR ANTÔNIO JACINTO PIMENTA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148318',
        'EE DOUTOR FELIPE MOREIRA CALDAS',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148334',
        'EE DOUTOR MANOEL ESTEVES OTONI',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148113',
        'EE DOUTOR WALDEMAR NEVES DA ROCHA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148156',
        'EE FREI ANTELMO KROPMAN',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148008',
        'EE FREI BRÁS BERTEN',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148041',
        'EE GLÓRIA PENCHEL',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148075',
        'EE IONE LEWICK CUNHA MELO',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148130',
        'EE IRMÃ ARCÂNGELA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148440',
        'EE JOSÉ EXPEDITO SOUZA CAMPOS',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148261',
        'EE MAGID LAUAR',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148342',
        'EE NOSSA SENHORA DE FÁTIMA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148024',
        'EE PASTOR HOLLERBACH',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148369',
        'EE PREFEITO GERMANO AUGUSTO DE SOUZA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148351',
        'EE PRESIDENTE TANCREDO NEVES',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '147958',
        'EE PROFESSOR PATRÍCIO FERREIRA GOMES',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '338834',
        'EE PROFESSORA MARIA LÚCIA GOMES RIBEIRO',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '330582',
        'EE RUBEM TOMICH',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148016',
        'EE SÃO SEBASTIÃO',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '349330',
        'EE SEBASTIÃO ALVES DA CRUZ',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148032',
        'EE SEBASTIÃO RAMOS',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148091',
        'EE TRISTÃO DA CUNHA',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '148458',
        'EE APARÍCIO ALVES MURTA',
        'UMBURATIBA',
        'SRE TEÓFILO OTONI'
    ),
(
        '180769',
        'EE DEPUTADO EDSON RESENDE',
        'ASTOLFO DUTRA',
        'SRE UBÁ'
    ),
(
        '180751',
        'EE OLINTO ALMADA',
        'ASTOLFO DUTRA',
        'SRE UBÁ'
    ),
(
        '180742',
        'EE PROFESSOR SOUZA PRIMO',
        'ASTOLFO DUTRA',
        'SRE UBÁ'
    ),
(
        '180785',
        'EE JOSÉ ALVES DE MAGALHÃES',
        'BRÁS PIRES',
        'SRE UBÁ'
    ),
(
        '180793',
        'EE SÃO LUÍS',
        'BRÁS PIRES',
        'SRE UBÁ'
    ),
(
        '128635',
        'EE EMÍLIO JARDIM',
        'COIMBRA',
        'SRE UBÁ'
    ),
(
        '180807',
        'EE PROFESSOR BIOLKINO DE ANDRADE',
        'DIVINÉSIA',
        'SRE UBÁ'
    ),
(
        '180831',
        'EE CORINA VIEIRA HENRIQUES',
        'DONA EUSÉBIA',
        'SRE UBÁ'
    ),
(
        '180815',
        'EE DOMICIANO ESTEVES',
        'DONA EUSÉBIA',
        'SRE UBÁ'
    ),
(
        '180858',
        'EE TEREZINHA PEREIRA',
        'DORES DO TURVO',
        'SRE UBÁ'
    ),
(
        '180904',
        'EE DOM FRANCISCO DAS CHAGAS',
        'ERVÁLIA',
        'SRE UBÁ'
    ),
(
        '180912',
        'EE MONSENHOR RODOLFO',
        'ERVÁLIA',
        'SRE UBÁ'
    ),
(
        '180891',
        'EE PROFESSOR DAVID PROCÓPIO',
        'ERVÁLIA',
        'SRE UBÁ'
    ),
(
        '215384',
        'EE JOSÉ ALVAREZ FILHO',
        'GUARANI',
        'SRE UBÁ'
    ),
(
        '181030',
        'EE PROFESSOR ALBERTO PACHECO',
        'GUARANI',
        'SRE UBÁ'
    ),
(
        '181102',
        'EE CORONEL JOAQUIM MARTINS',
        'GUIDOVAL',
        'SRE UBÁ'
    ),
(
        '181137',
        'EE MARIANA DE PAIVA',
        'GUIDOVAL',
        'SRE UBÁ'
    ),
(
        '181200',
        'EE CASTORINA GOMES SOARES',
        'GUIRICEMA',
        'SRE UBÁ'
    ),
(
        '181234',
        'EE GALDINO LEOCÁDIO',
        'GUIRICEMA',
        'SRE UBÁ'
    ),
(
        '181188',
        'EE PREFEITO ANTÔNIO ARRUDA',
        'GUIRICEMA',
        'SRE UBÁ'
    ),
(
        '181251',
        'EE JOSÉ MAURÍLIO VALENTE',
        'PAULA CÂNDIDO',
        'SRE UBÁ'
    ),
(
        '181277',
        'EE PROFESSOR SAMUEL JOÃO DE DEUS',
        'PAULA CÂNDIDO',
        'SRE UBÁ'
    ),
(
        '181307',
        'EE AURÉLIO BENTO SALGADO',
        'PIRAÚBA',
        'SRE UBÁ'
    ),
(
        '181366',
        'EE LAFAYETE MAURÍCIO LOPES',
        'PIRAÚBA',
        'SRE UBÁ'
    ),
(
        '181382',
        'EE PROFESSORA FRANCISCA PEREIRA RODRIGUES',
        'PIRAÚBA',
        'SRE UBÁ'
    ),
(
        '181404',
        'EE ANTÔNIO LUCAS MARTINS',
        'PRESIDENTE BERNARDES',
        'SRE UBÁ'
    ),
(
        '181421',
        'EE GOVERNADOR CLÓVIS SALGADO',
        'PRESIDENTE BERNARDES',
        'SRE UBÁ'
    ),
(
        '181412',
        'EE PADRE VICENTE CARVALHO',
        'PRESIDENTE BERNARDES',
        'SRE UBÁ'
    ),
(
        '181498',
        'EE PROFESSOR JOSÉ BORGES DE MORAIS',
        'RIO POMBA',
        'SRE UBÁ'
    ),
(
        '181528',
        'EE MÁRCIO NICOLATO',
        'RODEIRO',
        'SRE UBÁ'
    ),
(
        '181536',
        'EE ÁLVARO GIESTA',
        'SÃO GERALDO',
        'SRE UBÁ'
    ),
(
        '181579',
        'EE MINISTRO ALOÍSIO COSTA',
        'SÃO GERALDO',
        'SRE UBÁ'
    ),
(
        '181544',
        'EE PROFESSOR ORMINDO DE SOUZA LIMA',
        'SÃO GERALDO',
        'SRE UBÁ'
    ),
(
        '181609',
        'EE PROFESSOR CÍCERO TORRES GALINDO',
        'SENADOR FIRMINO',
        'SRE UBÁ'
    ),
(
        '181641',
        'EE SANTO ANTÔNIO',
        'SILVEIRÂNIA',
        'SRE UBÁ'
    ),
(
        '181692',
        'EE MENELICK DE CARVALHO',
        'TABULEIRO',
        'SRE UBÁ'
    ),
(
        '181731',
        'EE CAPITAO ANTONIO PINTO DE MIRANDA',
        'TOCANTINS',
        'SRE UBÁ'
    ),
(
        '181854',
        'EE DR JOÃO PINTO',
        'TOCANTINS',
        'SRE UBÁ'
    ),
(
        '181757',
        'EE PROFESSOR JOÃO LOYOLA',
        'TOCANTINS',
        'SRE UBÁ'
    ),
(
        '182028',
        'CESEC PROFESSOR JOSÉ CARNEIRO DE CASTRO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182109',
        'EE BARÃO DO RIO BRANCO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181919',
        'EE CESÁRIO ALVIM',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181935',
        'EE CORONEL CAMILO SOARES',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182095',
        'EE CORONEL JOÃO FERREIRA DE ANDRADE',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182087',
        'EE CORONEL TEIXEIRA ERVILHA',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181951',
        'EE DEPUTADO CARLOS PEIXOTO FILHO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181978',
        'EE DOUTOR JOSÉ JANUÁRIO CARNEIRO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181994',
        'EE DOUTOR LEVINDO COELHO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181820',
        'EE EUNICE WEAVER',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182036',
        'EE GOVERNADOR VALADARES',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182001',
        'EE PADRE JOÃOZINHO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181943',
        'EE PROFESSOR LÍVIO DE CASTRO CARNEIRO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182052',
        'EE RAUL SOARES',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182079',
        'EE SÃO JOSÉ',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '181862',
        'EE SENADOR LEVINDO COELHO',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '182214',
        'CESEC PROFESSOR PAULO ROBERTO REIS DE ALMEIDA',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182184',
        'EE CORONEL AVELINO CARDOSO',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182176',
        'EE DE EDUCAÇÃO ESPECIAL ANTONIO DE GOUVÊA LIMA',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182222',
        'EE DOUTOR CELSO MACHADO',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182249',
        'EE DR JOÃO BATISTA DE ALMEIDA',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182290',
        'EE LAUDELINA BARANDIER ESMERALDO',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182320',
        'EE PADRE ANTÔNIO CORREA',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182338',
        'EE PREFEITO RUY BOUCHARDET',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '182150',
        'EE TENENTE ROBERTO SOARES DE SOUZA LIMA',
        'VISCONDE DO RIO BRANCO',
        'SRE UBÁ'
    ),
(
        '311863',
        'EE JOSÉ ACÁCIO DA SILVA',
        'ÁGUA COMPRIDA',
        'SRE UBERABA'
    ),
(
        '158178',
        'EE ARMANDO SANTOS',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158186',
        'EE CORONEL JOSÉ ADOLFO AGUIAR',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158224',
        'EE DOM JOSÉ GASPAR',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158330',
        'EE LOREN RIOS FERES',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158267',
        'EE LUIZA DE OLIVEIRA FARIA',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158275',
        'EE MARIA DE MAGALHÃES',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158216',
        'EE PADRE ANACLETO GIRALDI',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158194',
        'EE PROFESSOR LUIZ ANTÔNIO CORRÊA OLIVEIRA',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '218502',
        'EE ROTARY',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '158313',
        'EE VASCO SANTOS',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '278904',
        'EE PADRE HENRIQUE PEETERS',
        'CAMPO FLORIDO',
        'SRE UBERABA'
    ),
(
        '158534',
        'EE DOUTOR JOSÉ CORDEIRO DE CAMPOS',
        'CAMPOS ALTOS',
        'SRE UBERABA'
    ),
(
        '158569',
        'EE PADRE CLEMENTE DE MALETO',
        'CAMPOS ALTOS',
        'SRE UBERABA'
    ),
(
        '159255',
        'EE BOM SUCESSO',
        'CARNEIRINHO',
        'SRE UBERABA'
    ),
(
        '159271',
        'EE MARECHAL HERMES',
        'CARNEIRINHO',
        'SRE UBERABA'
    ),
(
        '159301',
        'EE PROFESSOR ANTÔNIO DA SILVA',
        'CARNEIRINHO',
        'SRE UBERABA'
    ),
(
        '330671',
        'EE COMENDADOR GOMES',
        'COMENDADOR GOMES',
        'SRE UBERABA'
    ),
(
        '316041',
        'EE HERCULÉGIO ANTÔNIO BORGES',
        'CONCEIÇÃO DAS ALAGOAS',
        'SRE UBERABA'
    ),
(
        '158674',
        'EE JOSÉ ALEXANDRE MIZIARA',
        'CONCEIÇÃO DAS ALAGOAS',
        'SRE UBERABA'
    ),
(
        '310883',
        'EE DR LINDOLFO BERNARDES',
        'CONQUISTA',
        'SRE UBERABA'
    ),
(
        '322644',
        'EE IVAN MATTAR SOUKEF',
        'DELTA',
        'SRE UBERABA'
    ),
(
        '158801',
        'EE JOÃO KOPKE',
        'FRONTEIRA',
        'SRE UBERABA'
    ),
(
        '361356',
        'EE PROFESSORA MARIA DO CARMO PIRES ROSA',
        'FRONTEIRA',
        'SRE UBERABA'
    ),
(
        '158909',
        'EE LAURISTON SOUZA',
        'FRUTAL',
        'SRE UBERABA'
    ),
(
        '158879',
        'EE MAESTRO JOSINO DE OLIVEIRA',
        'FRUTAL',
        'SRE UBERABA'
    ),
(
        '319201',
        'EE PRESIDENTE TANCREDO NEVES',
        'FRUTAL',
        'SRE UBERABA'
    ),
(
        '319104',
        'EE PROFESSOR BANDEIRA',
        'FRUTAL',
        'SRE UBERABA'
    ),
(
        '158941',
        'EE VICENTE MACEDO',
        'FRUTAL',
        'SRE UBERABA'
    ),
(
        '159131',
        'EE ALONSO DE MORAIS ANDRADE',
        'ITAPAGIPE',
        'SRE UBERABA'
    ),
(
        '159158',
        'EE SANTO ANTÔNIO',
        'ITAPAGIPE',
        'SRE UBERABA'
    ),
(
        '159140',
        'EE SERRA DA MOEDA',
        'ITAPAGIPE',
        'SRE UBERABA'
    ),
(
        '159166',
        'EE ANTÔNIO FERREIRA BARBOSA',
        'ITURAMA',
        'SRE UBERABA'
    ),
(
        '159247',
        'EE DOM ALEXANDRE',
        'ITURAMA',
        'SRE UBERABA'
    ),
(
        '205605',
        'EE JOAQUIM TIAGO DE QUEIROZ',
        'ITURAMA',
        'SRE UBERABA'
    ),
(
        '159182',
        'EE NOSSA SENHORA DE LOURDES',
        'ITURAMA',
        'SRE UBERABA'
    ),
(
        '159212',
        'EE TIRADENTES',
        'ITURAMA',
        'SRE UBERABA'
    ),
(
        '159280',
        'EE IZOLDINO SOARES DE FREITAS',
        'LIMEIRA DO OESTE',
        'SRE UBERABA'
    ),
(
        '159328',
        'EE PROFESSOR LEÃO COELHO DE ALMEIDA',
        'PEDRINÓPOLIS',
        'SRE UBERABA'
    ),
(
        '311855',
        'EE CORONEL OSCAR DE CASTRO',
        'PIRAJUBA',
        'SRE UBERABA'
    ),
(
        '159417',
        'EE ALYSSON ROBERTO BRUNO',
        'PLANURA',
        'SRE UBERABA'
    ),
(
        '319112',
        'EE MARLENE MARTINS REIS',
        'PRATINHA',
        'SRE UBERABA'
    ),
(
        '159484',
        'EE BARÃO DA RIFAINA',
        'SACRAMENTO',
        'SRE UBERABA'
    ),
(
        '159506',
        'EE CORONEL JOSÉ AFONSO DE ALMEIDA',
        'SACRAMENTO',
        'SRE UBERABA'
    ),
(
        '361224',
        'EE ESCRITORA CAROLINA MARIA DE JESUS',
        'SACRAMENTO',
        'SRE UBERABA'
    ),
(
        '159565',
        'EE SINHANA BORGES',
        'SACRAMENTO',
        'SRE UBERABA'
    ),
(
        '159611',
        'EE SANTA JULIANA',
        'SANTA JULIANA',
        'SRE UBERABA'
    ),
(
        '159646',
        'EE SÃO FRANCISCO DE SALES',
        'SÃO FRANCISCO DE SALES',
        'SRE UBERABA'
    ),
(
        '310166',
        'EE PROFESSORA CECÍLIA MARIA DE REZENDE NEVES',
        'TAPIRA',
        'SRE UBERABA'
    ),
(
        '313751',
        'CESEC PROFESSORA MARIA EMÍLIA DA ROCHA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '342556',
        'EE ALOÍZIO CASTANHEIRA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159735',
        'EE AMÉRICA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159662',
        'EE AURÉLIO LUIZ DA COSTA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159786',
        'EE BERNARDO VASCONCELOS',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159841',
        'EE BOULANGER PUCCI',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159867',
        'EE BRASIL',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160261',
        'EE CARMELITA CARVALHO GARCIA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159981',
        'EE DOM EDUARDO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160024',
        'EE DOUTOR JOSÉ MENDONÇA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160067',
        'EE FELÍCIO DE PAIVA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160008',
        'EE FIDÉLIS REIS',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '349321',
        'EE FRANCISCO CÂNDIDO XAVIER',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160083',
        'EE FREI LEOPOLDO DE CASTELNUOVO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160105',
        'EE GABRIEL TOTI',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160237',
        'EE GERALDINO RODRIGUES CUNHA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160121',
        'EE HENRIQUE KRUGER',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160148',
        'EE HORIZONTA LEMOS',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160164',
        'EE IRMÃO AFONSO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160172',
        'EE LAURO FONTOURA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160245',
        'EE LEANDRO ANTÔNIO DE VITO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159671',
        'EE MARECHAL HUMBERTO ALENCAR CASTELO BRANCO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159719',
        'EE MIGUEL LATERZA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159751',
        'EE MINAS GERAIS',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159794',
        'EE NOSSA SENHORA DA ABADIA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159891',
        'EE PAULO JOSÉ DERENUSSON',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159956',
        'EE PRESIDENTE JOÃO PINHEIRO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159999',
        'EE PROFESSOR ALCEU NOVAES',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160016',
        'EE PROFESSOR CHAVES',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160059',
        'EE PROFESSOR HILDEBRANDO PONTES',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '327280',
        'EE PROFESSOR MINERVINO CESARINO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159972',
        'EE PROFESSORA CORINA DE OLIVEIRA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '349313',
        'EE PROFESSORA NEIDE OLIVEIRA GOMES',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160075',
        'EE QUINTILIANO JARDIM',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160091',
        'EE ROTARY',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160130',
        'EE SANTA TEREZINHA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '160156',
        'EE SÃO BENEDITO',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '159310',
        'EE DOM PEDRO II',
        'UNIÃO DE MINAS',
        'SRE UBERABA'
    ),
(
        '160326',
        'EE GERALDINO RODRIGUES DA CUNHA',
        'VERÍSSIMO',
        'SRE UBERABA'
    ),
(
        '166821',
        'CESEC JK',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166618',
        'EE ANTÔNIO NUNES CARVALHO FILHO',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166839',
        'EE ARTUR BERNARDES',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166855',
        'EE CORONEL LINDOLFO RODRIGUES CUNHA',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166626',
        'EE COSTA SENA',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166634',
        'EE DONA ELEONORA PIERUCCETTI',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166651',
        'EE ISOLINA FRANÇA SOARES TORRES',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166812',
        'EE JOSÉ CARNEIRO DA CUNHA',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166685',
        'EE MADRE MARIA BLANDINA',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166693',
        'EE PADRE DAMIÃO',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '330779',
        'EE PADRE EDUARDO JORDI',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166804',
        'EE PADRE ELÓI',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166715',
        'EE PAES DE ALMEIDA',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166731',
        'EE PROFESSOR ANTÔNIO MARQUES',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166782',
        'EE PROFESSORA KATY BELEM',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166740',
        'EE RAUL SOARES',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '166766',
        'EE SÃO JUDAS TADEU',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '167207',
        'EE MÁRIO SIDNEY FRANCESCHI',
        'ARAPORÃ',
        'SRE UBERLÂNDIA'
    ),
(
        '158429',
        'CESEC PROFESSORA ROMILDA DINIZ',
        'CAMPINA VERDE',
        'SRE UBERLÂNDIA'
    ),
(
        '158356',
        'EE ANA CHAVES',
        'CAMPINA VERDE',
        'SRE UBERLÂNDIA'
    ),
(
        '319147',
        'EE DOUTOR NICODEMUS DE MACEDO',
        'CAMPINA VERDE',
        'SRE UBERLÂNDIA'
    ),
(
        '158399',
        'EE NOSSA SENHORA DAS GRAÇAS',
        'CAMPINA VERDE',
        'SRE UBERLÂNDIA'
    ),
(
        '158437',
        'EE OLINDA CORREA BORGES',
        'CAMPINA VERDE',
        'SRE UBERLÂNDIA'
    ),
(
        '166871',
        'EE NÉLSON SOARES DE OLIVEIRA',
        'INDIANÓPOLIS',
        'SRE UBERLÂNDIA'
    ),
(
        '166961',
        'EE EUFRAUSINA DA COSTA ARAÚJO',
        'MONTE ALEGRE DE MINAS',
        'SRE UBERLÂNDIA'
    ),
(
        '166936',
        'EE MONTE ALEGRE DE MINAS',
        'MONTE ALEGRE DE MINAS',
        'SRE UBERLÂNDIA'
    ),
(
        '166952',
        'EE TANCREDO MARTINS',
        'MONTE ALEGRE DE MINAS',
        'SRE UBERLÂNDIA'
    ),
(
        '166979',
        'EE JOSIAS PINTO',
        'NOVA PONTE',
        'SRE UBERLÂNDIA'
    ),
(
        '319163',
        'EE CORONEL PEDRO NERY',
        'PRATA',
        'SRE UBERLÂNDIA'
    ),
(
        '167045',
        'EE DO PRATA',
        'PRATA',
        'SRE UBERLÂNDIA'
    ),
(
        '319171',
        'EE NORALDINO LIMA',
        'PRATA',
        'SRE UBERLÂNDIA'
    ),
(
        '167053',
        'EE PROFESSOR VALENTIN',
        'PRATA',
        'SRE UBERLÂNDIA'
    ),
(
        '167118',
        'EE ANA ESTERLITA ALVES',
        'TUPACIGUARA',
        'SRE UBERLÂNDIA'
    ),
(
        '167185',
        'EE BRAULINO MAMEDE',
        'TUPACIGUARA',
        'SRE UBERLÂNDIA'
    ),
(
        '167169',
        'EE CLERTAN MOREIRA DO VALE',
        'TUPACIGUARA',
        'SRE UBERLÂNDIA'
    ),
(
        '361305',
        'EE DE ENSINO MÉDIO',
        'TUPACIGUARA',
        'SRE UBERLÂNDIA'
    ),
(
        '167193',
        'EE SEBASTIÃO DIAS FERRAZ',
        'TUPACIGUARA',
        'SRE UBERLÂNDIA'
    ),
(
        '167835',
        'CESEC DE UBERLÂNDIA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167657',
        'EE 13 DE MAIO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167240',
        'EE AFONSO ARINOS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167282',
        'EE ALDA MOTA BATISTA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167363',
        'EE AMADOR NAVES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167321',
        'EE AMÉRICO RENÉ GIANNETTI',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167401',
        'EE ÂNGELA TEIXEIRA DA SILVA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167461',
        'EE ANGELINO PAVAN',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167487',
        'EE ANTÔNIO LUIS BASTOS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167771',
        'EE ANTÔNIO THOMAZ FERREIRA DE REZENDE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167525',
        'EE BOM JESUS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167568',
        'EE BUENO BRANDÃO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167681',
        'EE CLARIMUNDO CARNEIRO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167720',
        'EE CORONEL JOSE TEOFILO CARNEIRO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167223',
        'EE CUSTÓDIO DA COSTA PEREIRA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167649',
        'EE DA CIDADE INDUSTRIAL',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '338893',
        'EE DE ENSINO FUNDAMENTAL E MÉDIO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167690',
        'EE DE UBERLÂNDIA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167665',
        'EE DO BAIRRO JARDIM DAS PALMEIRAS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167789',
        'EE DO BAIRRO MARAVILHA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167797',
        'EE DO PARQUE SÃO JORGE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167801',
        'EE DONA ALEXANDRA PEDREIRO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167827',
        'EE DR DUARTE PIMENTEL DE ULHOA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167444',
        'EE ENÉAS DE OLIVEIRA GUIMARÃES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167215',
        'EE ENÉIAS VASCONCELOS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167231',
        'EE FELISBERTO ALVES CARREJO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167584',
        'EE FREI EGÍDIO PARISI',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167258',
        'EE GUIOMAR DE FREITAS COSTA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167703',
        'EE HERCÍLIA MARTINS REZENDE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167274',
        'EE HONÓRIO GUIMARÃES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167266',
        'EE HORTÊNCIO DINIZ',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167291',
        'EE IGNÁCIO PAES LEME',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167878',
        'EE JARDIM IPANEMA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167606',
        'EE JERÔNIMO ARANTES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167622',
        'EE JOÃO REZENDE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167312',
        'EE JOAQUIM SARAIVA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '207403',
        'EE JOSÉ GOMES JUNQUEIRA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167355',
        'EE JOSÉ ZACHARIAS JUNQUEIRA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167509',
        'EE LOURDES DE CARVALHO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167371',
        'EE MARECHAL CASTELO BRANCO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167410',
        'EE MARIA DA CONCEIÇÃO BARBOSA DE SOUZA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167398',
        'EE MÁRIO PORTO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '327964',
        'EE MÁRIO QUINTANA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167436',
        'EE MESSIAS PEDREIRO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167746',
        'EE NEUZA REZENDE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167347',
        'EE NO CONJUNTO HABITACIONAL CRUZEIRO DO SUL',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167851',
        'EE NOVO HORIZONTE-EDUCAÇÃO ESPECIAL',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167479',
        'EE OSVALDO RESENDE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167495',
        'EE PADRE MARIO FORESTAN',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167754',
        'EE PRESIDENTE JUSCELINO KUBITSCHEK',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167711',
        'EE PRESIDENTE TANCREDO NEVES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167843',
        'EE PROFESSOR EDERLINDO LANNES BERNARDES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167541',
        'EE PROFESSOR INÁCIO CASTILHO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167339',
        'EE PROFESSOR JOSÉ IGNÁCIO DE SOUSA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167380',
        'EE PROFESSOR LEÔNIDAS DE CASTRO SERRA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167428',
        'EE PROFESSOR NELSON CUPERTINO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '327956',
        'EE PROFESSOR PAULO FREIRE',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167517',
        'EE PROFESSORA ALICE PAES',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167304',
        'EE PROFESSORA JUVENÍLIA  FERREIRA DOS SANTOS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167533',
        'EE RIO DAS PEDRAS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167550',
        'EE ROTARY',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167614',
        'EE SEGISMUNDO PEREIRA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167576',
        'EE SEIS DE JUNHO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167592',
        'EE SÉRGIO DE FREITAS PACHECO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167631',
        'EE SETE DE SETEMBRO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167738',
        'EE TEOTÔNIO VILELA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '167673',
        'EE TUBAL VILELA DA SILVA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '346268',
        'CESEC AFONSO ARINOS',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '108227',
        'EE CARMOSINA DURÃES MARTINS',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '349291',
        'EE CHICO MENDES',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '108219',
        'EE GARIBALDINA FERNANDES VALADARES',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '108197',
        'EE MAJOR SAINT CLAIR FERNANDES VALADARES',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '231860',
        'EE PROFESSOR BENEVIDES',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '108367',
        'CESEC ESMÉRIA MARIA DO CARMO',
        'BONFINÓPOLIS DE MINAS',
        'SRE UNAÍ'
    ),
(
        '108243',
        'EE CÂNDIDO ULHÔA',
        'BONFINÓPOLIS DE MINAS',
        'SRE UNAÍ'
    ),
(
        '246204',
        'EE ANÁLIA CARNEIRO DOS SANTOS',
        'BURITIS',
        'SRE UNAÍ'
    ),
(
        '108413',
        'EE ARGEMIRO ANTÔNIO PRADO',
        'BURITIS',
        'SRE UNAÍ'
    ),
(
        '108430',
        'EE JOSÉ GOMES PIMENTEL',
        'BURITIS',
        'SRE UNAÍ'
    ),
(
        '108421',
        'EE SÃO DOMINGOS',
        'BURITIS',
        'SRE UNAÍ'
    ),
(
        '109100',
        'EE DEPUTADO EDUARDO LUCAS',
        'CABECEIRA GRANDE',
        'SRE UNAÍ'
    ),
(
        '322598',
        'EE JUVENAL DIOGO PIRES',
        'CABECEIRA GRANDE',
        'SRE UNAÍ'
    ),
(
        '108375',
        'EE DOM BOSCO',
        'DOM BOSCO',
        'SRE UNAÍ'
    ),
(
        '108456',
        'EE MARTINHO ANTÔNIO ORNELAS',
        'FORMOSO',
        'SRE UNAÍ'
    ),
(
        '205559',
        'EE NOSSA SENHORA DE ABADIA',
        'FORMOSO',
        'SRE UNAÍ'
    ),
(
        '108383',
        'EE ALVARENGA PEIXOTO',
        'NATALÂNDIA',
        'SRE UNAÍ'
    ),
(
        '82821',
        'EE CORONEL MANOEL JOSÉ DE ALMEIDA',
        'RIACHINHO',
        'SRE UNAÍ'
    ),
(
        '82791',
        'EE JOSÉ DE ALENCAR',
        'RIACHINHO',
        'SRE UNAÍ'
    ),
(
        '82783',
        'EE NÚCLEO COLONIAL VALE URUCUIA',
        'RIACHINHO',
        'SRE UNAÍ'
    ),
(
        '109070',
        'CESEC JÚLIO MARTINS FERREIRA',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '213292',
        'EE DELVITO ALVES DA SILVA',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '108987',
        'EE DOM ELISEU',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '108995',
        'EE DOMINGOS PINTO BROCHADO',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '342475',
        'EE ELISA DE OLIVEIRA CAMPOS',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '245836',
        'EE IZABEL CAMPOS MARTINS',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '239399',
        'EE JUVÊNCIO MARTINS FERREIRA',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '109037',
        'EE MANOELA FARIA SOARES',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '109045',
        'EE MARIA ASSUNES GONÇALVES',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '330698',
        'EE MÚCIO DE CASTRO ALVES',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '109053',
        'EE TANCREDO DE ALMEIDA NEVES',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '109002',
        'EE TEÓFILO MARTINS FERREIRA',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '109011',
        'EE VIGÁRIO TORRES',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '109029',
        'EE VIRGÍLIO DE MELO FRANCO',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '322601',
        'EE DARCI RIBEIRO',
        'URUANA DE MINAS',
        'SRE UNAÍ'
    ),
(
        '170755',
        'EE CORONEL JOSÉ BENTO',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170828',
        'EE DIRCE MOURA LEITE',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170780',
        'EE DOUTOR ARLINDO SILVEIRA FILHO',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170798',
        'EE DOUTOR EMÍLIO SILVEIRA',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170887',
        'EE DOUTOR NAPOLEÃO SALLES',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170810',
        'EE JUDITH VIANNA',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170895',
        'EE PADRE JOSÉ GRIMMINCK',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170844',
        'EE PREFEITO ISMAEL BRASIL CORRÊA',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170852',
        'EE PROFESSOR LEVINDO LAMBERT',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170861',
        'EE PROFESSOR VIANA',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '170879',
        'EE SAMUEL ENGEL',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '171280',
        'CESEC PROFESSORA SINHÁ LEITE',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171271',
        'EE ACHILLES NAVES',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171107',
        'EE BELMIRO BRAGA',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171123',
        'EE CASIMIRO SILVA',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171174',
        'EE DOUTOR JOAQUIM VILELA',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171191',
        'EE DOUTOR SÁ BRITO',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171212',
        'EE PADRE JOÃO VIEIRA DA FONSECA',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '229296',
        'EE PROFESSOR NESTOR LACERDA',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171255',
        'EE PROFESSORA SÍLVIA MESQUITA',
        'BOA ESPERANÇA',
        'SRE VARGINHA'
    ),
(
        '171301',
        'EE CLÓVIS SALGADO',
        'CAMBUQUIRA',
        'SRE VARGINHA'
    ),
(
        '171361',
        'EE MARIA UMBELINA DE ANDRADE GOMES',
        'CAMBUQUIRA',
        'SRE VARGINHA'
    ),
(
        '171468',
        'EE DOM INOCÊNCIO',
        'CAMPANHA',
        'SRE VARGINHA'
    ),
(
        '171484',
        'EE VITAL BRASIL',
        'CAMPANHA',
        'SRE VARGINHA'
    ),
(
        '171492',
        'EE ZOROASTRO DE OLIVEIRA',
        'CAMPANHA',
        'SRE VARGINHA'
    ),
(
        '171581',
        'EE DR JOSÉ MESQUITA NETTO',
        'CAMPO DO MEIO',
        'SRE VARGINHA'
    ),
(
        '171549',
        'EE PADRE CHICO',
        'CAMPO DO MEIO',
        'SRE VARGINHA'
    ),
(
        '239143',
        'EE MONSENHOR TEÓFILO SAEZ',
        'CAMPOS GERAIS',
        'SRE VARGINHA'
    ),
(
        '171701',
        'EE PADRE ANTÔNIO VIEIRA',
        'CAMPOS GERAIS',
        'SRE VARGINHA'
    ),
(
        '171646',
        'EE PROFESSOR EDUARDO DANIEL FERREIRA DIAS',
        'CAMPOS GERAIS',
        'SRE VARGINHA'
    ),
(
        '171689',
        'EE PROFESSOR JOAQUIM JOSÉ DE OLIVEIRA',
        'CAMPOS GERAIS',
        'SRE VARGINHA'
    ),
(
        '171824',
        'EE PEDRO MESTRE',
        'CARMO DA CACHOEIRA',
        'SRE VARGINHA'
    ),
(
        '171786',
        'EE PROFESSOR WANDERLEY FERREIRA DE REZENDE',
        'CARMO DA CACHOEIRA',
        'SRE VARGINHA'
    ),
(
        '171999',
        'EE JOÃO DE PAULA CAPRONI',
        'CARVALHÓPOLIS',
        'SRE VARGINHA'
    ),
(
        '172316',
        'EE PADRE ANCHIETA',
        'COQUEIRAL',
        'SRE VARGINHA'
    ),
(
        '172375',
        'EE PROFESSORA CELINA DE REZENDE VILELA',
        'CORDISLÂNDIA',
        'SRE VARGINHA'
    ),
(
        '172499',
        'EE BRASILINO ALVES PEREIRA',
        'ELÓI MENDES',
        'SRE VARGINHA'
    ),
(
        '172618',
        'EE PROFESSORA NORMA DE BRITO PIEDADE MARTINS',
        'ELÓI MENDES',
        'SRE VARGINHA'
    ),
(
        '319198',
        'EE SÃO LUIZ GONZAGA',
        'ELÓI MENDES',
        'SRE VARGINHA'
    ),
(
        '172600',
        'EE TARGINO NOGUEIRA',
        'ELÓI MENDES',
        'SRE VARGINHA'
    ),
(
        '305006',
        'EE PROFESSORA MARIA OLÍMPIA OLIVEIRA',
        'FAMA',
        'SRE VARGINHA'
    ),
(
        '172715',
        'EE DONA AGOSTINHA FLOR DE MARIA',
        'GUAPÉ',
        'SRE VARGINHA'
    ),
(
        '172693',
        'EE DR LAURO CORREA DO AMARAL',
        'GUAPÉ',
        'SRE VARGINHA'
    ),
(
        '229326',
        'EE PROFESSOR ANTÔNIO PASSOS SILVA',
        'GUAPÉ',
        'SRE VARGINHA'
    ),
(
        '172804',
        'EE NOSSA SENHORA APARECIDA',
        'ILICÍNEA',
        'SRE VARGINHA'
    ),
(
        '173011',
        'EE JOÃO DE ALMEIDA LISBOA',
        'LAMBARI',
        'SRE VARGINHA'
    ),
(
        '173029',
        'EE JOÃO NUNES FERREIRA',
        'LAMBARI',
        'SRE VARGINHA'
    ),
(
        '172987',
        'EE PROFESSORA MARIA RITA LISBOA PEREIRA SANTORO',
        'LAMBARI',
        'SRE VARGINHA'
    ),
(
        '134287',
        'EE PROFESSOR FABREGAS',
        'LUMINÁRIAS',
        'SRE VARGINHA'
    ),
(
        '173100',
        'CESEC DOUTOR TANCREDO DE ALMEIDA NEVES',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173223',
        'EE DE DOURADINHO',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173215',
        'EE DOM PEDRO I',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173045',
        'EE GABRIEL ODORICO',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173061',
        'EE IRACEMA RODRIGUES',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173088',
        'EE PAULINA RIGOTTI DE CASTRO',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173169',
        'EE RUBENS GARCIA',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '173266',
        'EE PADRE ROGÉRIO ABDALA',
        'MONSENHOR PAULO',
        'SRE VARGINHA'
    ),
(
        '173282',
        'EE CORONEL JOAQUIM RIBEIRO',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '173291',
        'EE DA FAZENDA BELA VISTA',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '173428',
        'EE DE NAZARÉ DE MINAS',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '173436',
        'EE DE SANTO ANTÔNIO DO CRUZEIRO',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '173371',
        'EE DOUTOR ERNANE VILELA LIMA',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '173380',
        'EE LICAS DE LIMA',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '173533',
        'EE PADRE PICCININI',
        'PARAGUAÇU',
        'SRE VARGINHA'
    ),
(
        '173622',
        'EE PEDRO LEITE',
        'PARAGUAÇU',
        'SRE VARGINHA'
    ),
(
        '173631',
        'EE PROFESSOR ALFREDO GALDINO',
        'PARAGUAÇU',
        'SRE VARGINHA'
    ),
(
        '173851',
        'EE DOUTOR LÉLIO DE ALMEIDA',
        'POÇO FUNDO',
        'SRE VARGINHA'
    ),
(
        '173860',
        'EE JOSÉ BONIFÁCIO',
        'POÇO FUNDO',
        'SRE VARGINHA'
    ),
(
        '173878',
        'EE SÃO MARCOS',
        'POÇO FUNDO',
        'SRE VARGINHA'
    ),
(
        '174009',
        'EE DONA AUGUSTA',
        'SANTANA DA VARGEM',
        'SRE VARGINHA'
    ),
(
        '173975',
        'EE PADRE JOÃO NEIVA',
        'SANTANA DA VARGEM',
        'SRE VARGINHA'
    ),
(
        '173983',
        'EE PADRE JOSÉ RIBEIRO',
        'SANTANA DA VARGEM',
        'SRE VARGINHA'
    ),
(
        '174017',
        'EE PROFESSORA ALDA DE MOURA CARVALHO',
        'SÃO BENTO ABADE',
        'SRE VARGINHA'
    ),
(
        '174033',
        'EE BÁRBARA HELIODORA',
        'SÃO GONÇALO DO SAPUCAÍ',
        'SRE VARGINHA'
    ),
(
        '174025',
        'EE DOUTOR JOÃO PINHEIRO',
        'SÃO GONÇALO DO SAPUCAÍ',
        'SRE VARGINHA'
    ),
(
        '174106',
        'EE ESPERANÇA',
        'SÃO GONÇALO DO SAPUCAÍ',
        'SRE VARGINHA'
    ),
(
        '174084',
        'EE MINISTRO LUCIO DE MENDONÇA',
        'SÃO GONÇALO DO SAPUCAÍ',
        'SRE VARGINHA'
    ),
(
        '174416',
        'EE AMÉRICO DIAS PEREIRA',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174386',
        'EE BUENO BRANDÃO',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174475',
        'EE GODOFREDO RANGEL',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '328316',
        'EE HERBERT JOSÉ DE SOUZA',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174432',
        'EE LUIZA GOMES LEMOS',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174459',
        'EE MONSENHOR JOSÉ GUIMARÃES FONSECA',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174467',
        'EE OLÍMPIA DE BRITO',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174394',
        'EE PROFESSOR  CLÓVIS SALGADO',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174483',
        'EE PROFESSOR FRANCO DA ROSA',
        'TRÊS CORAÇÕES',
        'SRE VARGINHA'
    ),
(
        '174530',
        'EE CÔNEGO JOSÉ MARIA',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174688',
        'EE DEPUTADO TEODÓSIO BANDEIRA',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174785',
        'EE MONSENHOR JOÃO BATISTA DA SILVEIRA',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174700',
        'EE PREFEITO JACY JUNQUEIRA GAZOLA',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174831',
        'EE PRESIDENTE TANCREDO NEVES',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174769',
        'EE PROFESSORA MARIA AUGUSTA VIEIRA CORREA',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174718',
        'EE PROFESSORA MARIETA CASTRO',
        'TRÊS PONTAS',
        'SRE VARGINHA'
    ),
(
        '174858',
        'EE NOSSA SENHORA DA PIEDADE',
        'TURVOLÂNDIA',
        'SRE VARGINHA'
    ),
(
        '174882',
        'EE AFONSO PENA',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '174921',
        'EE BRASIL',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175099',
        'EE CORAÇÃO DE JESUS',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '174912',
        'EE CORONEL GABRIEL PENHA DE PAIVA',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175013',
        'EE DEPUTADO DOMINGOS DE FIGUEIREDO',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175030',
        'EE DOUTOR WLADIMIR DE REZENDE PINTO',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175048',
        'EE IRMÃO MÁRIO ESDRAS',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175064',
        'EE PEDRO DE ALCÂNTARA',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '217719',
        'EE PROFESSOR ANTÔNIO CORREA CARVALHO',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175072',
        'EE PROFESSOR ANTÔNIO DOMINGUES CHAVES',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '174904',
        'EE PROFESSOR FÁBIO SALLES',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175102',
        'EE PROFESSORA ARACY MIRANDA',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '356719',
        'EE PROFESSORA SELMA BASTOS',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '175081',
        'EE SÃO SEBASTIÃO',
        'VARGINHA',
        'SRE VARGINHA'
    ),
(
        '349658',
        'INSTITUTO FEDERAL DE EDUCAÇÃO DO NORTE DE MINAS - CAMPUS ALMENARA',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '347272',
        'INSTITUTO FEDERA DE EDUCAÇÃO, CIÊNCIA E  TECNOLOGIA DO NORTE DE MINAS GERIAS- CAMPUS ARAÇUAÍ',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '233269',
        'INSTITUTO FEDERAL DE EDUCAÇÃO TENCOLOGICA DO NORTE DE MINAS-CAMPUS SALINAS',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '14621',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS CAMPUS BARBACENA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '345385',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS-CAMPUS CONGONHAS',
        'CONGONHAS',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '365890',
        'INSTITUTO FEDERAL DE MINAS GERIAS-CAMPUS AVANÇADO  DE CONSELHEIRO LAFAIETE',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '359017',
        'INSTITUTO FEDERAL DE EDUCAÇÃO - CAMPUS AVANÇADO DE IPATINGA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '366765',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS GERAIS - CAMPUS DIAMANTINA',
        'DIAMANTINA',
        'SRE DIAMANTINA'
    ),
(
        '31755',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS BAMBUI',
        'BAMBUÍ',
        'SRE DIVINÓPOLIS'
    ),
(
        '347701',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS GOVERNADOR VALADARES',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '41548',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS SÃO JOÃO EVANGELISTA',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '345407',
        'INSTITUTO FEDERAL DO TRIANGULO MINEIRO - CAMPUS ITUIUTABA',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '62260',
        'INSTITUTO FEDERAL DO NORTE MINAS GERAIS CAMPUS JANUÁRIA',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '67873',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS - CAMPUS JUIZ DE FORA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '355402',
        'INSTITUTO FEDERAL DE MINAS GERAIS - CAMPUS SABARÁ',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '358150',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS- CAMPUS SANTA LUZIA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '349607',
        'INSTITUTO FEDERAL DO NORTE DE MINAS - CAMPUS MONTES CLAROS',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '347914',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE  DE MINAS GERAIS-CAMPUS MURIAÉ',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '253227',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS OURO PRETO',
        'OURO PRETO',
        'SRE OURO PRETO'
    ),
(
        '344664',
        'INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DE MINAS GERAIS - CAMPUS FORMIGA',
        'FORMIGA',
        'SRE PASSOS'
    ),
(
        '349410',
        'INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO NORTE DE MINAS- CAMPUS PIRAPORA',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '242624',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA SUL DE MINAS- CAMPUS MUZAMBINHO',
        'MUZAMBINHO',
        'SRE POÇOS DE CALDAS'
    ),
(
        '54267',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUL DE MINAS - CAMPUS INCONFIDENTES',
        'INCONFIDENTES',
        'SRE POUSO ALEGRE'
    ),
(
        '355291',
        'INSTITUTO FEDERAL DO SUL DE MINAS GERAIS-CAMPUS POUSO ALEGRE',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '348031',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIÊNCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS CAMPUS SÃO JOÃO DEL RE',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '180696',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUDESTE DE MINAS GERAIS - CAMPUS RIO POMBA',
        'RIO POMBA',
        'SRE UBÁ'
    ),
(
        '158151',
        'INSTITUTO FEDERAL DE EDUCAÇÃO TECNOLÓGICA DO TRIANGULO MINEIRO - CAMPUS UBERABA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '166553',
        'INSTITUTO FEDERAL DE EDUCAÇÃO TECNOLOGICA DO TRIANGULO MINEIRO CAMPUS UBERLANDIA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '345440',
        'INSTITUTO FEDERAL DE EDUC CIÊNCIAS E TEC DO NORTE DE MINAS GERAIS - CAMPUS ARINOS',
        'ARINOS',
        'SRE UNAÍ'
    ),
(
        '170674',
        'INSTITUTO FEDERAL DE EDUCAÇÃO CIENCIA E TECNOLOGIA DO SUL DE MINAS GERAIS - CAMPUS MACHADO',
        'MACHADO',
        'SRE VARGINHA'
    ),
(
        '255777',
        'INSTITUTO EDUCACIONAL MUNICIPAL DENY MARTINS TERRA',
        'MERCÊS',
        'SRE BARBACENA'
    ),
(
        '368806',
        'CAEE - CENTRO MUNICIPAL DE ATENDIMENTO EDUCACIONAL ESPECIALIZADO',
        'CARANGOLA',
        'SRE CARANGOLA'
    ),
(
        '215376',
        'INSTITUTO MUNICIPAL DE EDUCAÇÃO TÉCNICA DE TIMÓTEO',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '355305',
        'INSTITUTO EDUCACIONAL MUNICIPAL MARIA VERA PIMENTA',
        'CORINTO',
        'SRE CURVELO'
    ),
(
        '317080',
        'INSTITUTO  EDUCACIONAL INFANTIL MUNICIPAL PEQUENO PRÍNCIPE',
        'VEREDINHA',
        'SRE DIAMANTINA'
    ),
(
        '317276',
        'INSTITUTO EDUCACIONAL INFANTIL MUNICIPAL BONEQUINHO DOCE',
        'VEREDINHA',
        'SRE DIAMANTINA'
    ),
(
        '347906',
        'CMAEE - CENTRO MUNICIPAL DE APOIO EDUCACIONAL ESPECIALIZADO',
        'CARMO DO CAJURU',
        'SRE DIVINÓPOLIS'
    ),
(
        '381349',
        'EE QUINCAS LACERDA',
        'MOEMA',
        'SRE DIVINÓPOLIS'
    ),
(
        '14184',
        'INSTITUTO EDUCACIONAL DE CONTAGEM - IEC - UNIDADE RESSACA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '375780',
        'CAEE - CENTRO DE ATENDIMENTO EDUCACIONAL ESPECIALIZADO',
        'JUATUBA',
        'SRE METROPOLITANA B'
    ),
(
        '232173',
        'EM PEDREIRA DO INSTITUTO',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '287903',
        'CRECHE MUNICIPAL INSTITUTO CRESCER',
        'BALDIM',
        'SRE SETE LAGOAS'
    ),
(
        '369179',
        'CAEE PROFESSORA MARIA APARECIDA CONDÉ - AEE',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '306533',
        'CENTRO MUNICIPAL DE EDUCAÇÃO INFANTIL  PADREE ALBERTO ARTS',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '311961',
        'INSTITUTO EDUCACIONAL PINGO DE GENTE',
        'ALMENARA',
        'SRE ALMENARA'
    ),
(
        '351555',
        'INSTITUTO EDUCACIONAL JOÃO E MARIA',
        'JACINTO',
        'SRE ALMENARA'
    ),
(
        '279412',
        'INSTITUTO EDUCACIONAL CONHECER CONSTRUIR E VIVER',
        'JOAÍMA',
        'SRE ALMENARA'
    ),
(
        '339512',
        'INSTITUTO EDUCACIONAL GAMLIEL',
        'JORDÂNIA',
        'SRE ALMENARA'
    ),
(
        '329096',
        'INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE PEDRA AZUL-ITEP',
        'PEDRA AZUL',
        'SRE ALMENARA'
    ),
(
        '279943',
        'INSTITUTO EDUCACIONAL ANTÔNIO COSENZA LEITE',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '342106',
        'ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE ARAÇUAÍ',
        'ARAÇUAÍ',
        'SRE ARAÇUAÍ'
    ),
(
        '363120',
        'ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE DE ITAOBIM',
        'ITAOBIM',
        'SRE ARAÇUAÍ'
    ),
(
        '379972',
        'ITEP - INSTITUTO TÉCNICO EDUCACIONAL POLIVALENTE',
        'MEDINA',
        'SRE ARAÇUAÍ'
    ),
(
        '277509',
        'INSTITUTO EDUCACIONAL NOSSA SENHORA APARECIDA-IENSA',
        'SALINAS',
        'SRE ARAÇUAÍ'
    ),
(
        '305120',
        'INSTITUTO APRENDIZ SOLIDÁRIO',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '380598',
        'INSTITUTO APRENDIZ SOLIDÁRIO',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '18821',
        'INSTITUTO MARIA IMACULADA',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '367176',
        'INSTITUTO PREMIUM',
        'BARBACENA',
        'SRE BARBACENA'
    ),
(
        '277860',
        'INSTITUTO EDUCACIONAL LISBOA',
        'CARANDAÍ',
        'SRE BARBACENA'
    ),
(
        '361194',
        'INSTITUTO DE EDUCAÇÃO SABER',
        'MERCÊS',
        'SRE BARBACENA'
    ),
(
        '380237',
        'INSTITUTO EDUCACIONAL MASTER',
        'CANA VERDE',
        'SRE CAMPO BELO'
    ),
(
        '205265',
        'INSTITUTO PRESBITERIANO GAMMON',
        'LAVRAS',
        'SRE CAMPO BELO'
    ),
(
        '278793',
        'INSTITUTO EDUCACIONAL ARCO',
        'SANTO ANTÔNIO DO AMPARO',
        'SRE CAMPO BELO'
    ),
(
        '380989',
        'INSTITUTO EDUCAR',
        'DIVINO',
        'SRE CARANGOLA'
    ),
(
        '351849',
        'INSTITUTO DE EDUCAÇÃO MORIÁ',
        'ESPERA FELIZ',
        'SRE CARANGOLA'
    ),
(
        '374407',
        'INSTITUTO PRESBITERIANO DE EDUCAÇÃO LOGOS',
        'IPANEMA',
        'SRE CARATINGA'
    ),
(
        '364460',
        'EDUCANDÁRIO FRANCISCANO NHÁ CHICA',
        'BAEPENDI',
        'SRE CAXAMBU'
    ),
(
        '324507',
        'INSTITUTO SÃO JOSÉ',
        'CONCEIÇÃO DO RIO VERDE',
        'SRE CAXAMBU'
    ),
(
        '278815',
        'EDUCANDÁRIO SÃO FRANCISCO DE ASSIS',
        'ITAMONTE',
        'SRE CAXAMBU'
    ),
(
        '293881',
        'INSTITUTO GÊNESIS DE EDUCAÇÃO E CULTURA',
        'SÃO LOURENÇO',
        'SRE CAXAMBU'
    ),
(
        '339989',
        'INSTITUTO EDUCACIONAL MARGARIDA REZENDE',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '371084',
        'INSTITUTO EDUCACIONAL PIUÍ-CHÁ-CHÁ - UNIDADE III',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '344230',
        'INSTITUTO EDUCACIONAL PIUÍI-CHÁ-CHÁ - UNIDADE II',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '352756',
        'INSTITUTO PEDAGÓGICO ARCA DE NOÉ - EDUCAÇÃO INFANTIL',
        'CONSELHEIRO LAFAIETE',
        'SRE CONSELHEIRO LAFAIETE'
    ),
(
        '326305',
        'AMPLIAR INSTITUTO DE EDUCAÇÃO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '254096',
        'ETHOS INSTITUTO DE EDUCAÇAO',
        'CORONEL FABRICIANO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '287261',
        'EDUCANDÁRIO FAMÍLIA NAZARÉ',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '332917',
        'INSTITUTO DE EDUCAÇÃO DOCE INFÂNCIA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '343285',
        'INSTITUTO EDUCACIONAL BATISTA SHALLOM',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '312894',
        'INSTITUTO EDUCACIONAL GENTE INOCENTE',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '343137',
        'INSTITUTO EDUCACIONAL GOTINHA D''ÁGUA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '326291',
        'INSTITUTO EDUCACIONAL MARTINS VELOSO',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '193160',
        'INSTITUTO EDUCACIONAL MAYRINK VIEIRA',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '193178',
        'INSTITUTO EDUCACIONAL MAYRINK VIEIRA - UNIDADE II',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '340618',
        'INSTITUTO EDUCACIONAL MONTE SINAI CANAÃ',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '343145',
        'INSTITUTO EDUCACIONAL PEQUENOS GIGANTES',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '269549',
        'INSTITUTO EDUCACIONAL PILAR',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '255149',
        'SABERES INSTITUTO DE EDUCAÇÃO',
        'IPATINGA',
        'SRE CORONEL FABRICIANO'
    ),
(
        '300993',
        'EDUCANDÁRIO AMÉLIE GABRIELLE BOUDET',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '318469',
        'IEPG INSTITUTO DE EDUCAÇÃO  PINGO DE GENTE',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '316008',
        'INSTITUTO DE EDUCAÇÃO PAULO ANTÔNIO SILVA - IEPAS',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '294284',
        'INSTITUTO EDUCACIONAL RAIMUNDO MARTINS FRAGA',
        'TIMÓTEO',
        'SRE CORONEL FABRICIANO'
    ),
(
        '325520',
        'INSTITUTO EDUCACIONAL RAIO DE SOL',
        'BUENÓPOLIS',
        'SRE CURVELO'
    ),
(
        '233838',
        'INSTITUTO CARROSSEL',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '350370',
        'INSTITUTO EDUCACIONAL EDIFICAR',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '294756',
        'INSTITUTO EDUCACIONAL IMACULADA CONCEIÇÃO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '283371',
        'INSTITUTO EDUCAR',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '280585',
        'INSTITUTO PALACINHO DOS CARNEIRINHOS',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '210498',
        'INSTITUTO PEQUENO PRÍNCIPE EXPANSÃO',
        'CURVELO',
        'SRE CURVELO'
    ),
(
        '233862',
        'INSTITUTO MARIA IMACULADA',
        'FELIXLÂNDIA',
        'SRE CURVELO'
    ),
(
        '145891',
        'INSTITUTO EDUCACIONAL BARREIRO GRANDE',
        'TRÊS MARIAS',
        'SRE CURVELO'
    ),
(
        '308331',
        'APAE INSTITUTO EDUCACIONAL CRESCER',
        'RIO VERMELHO',
        'SRE DIAMANTINA'
    ),
(
        '347833',
        'APAE INSTITUTO EDUCACIONAL RAIO DE LUZ LUCIANA APARECIDA SANTOS',
        'SERRA AZUL DE MINAS',
        'SRE DIAMANTINA'
    ),
(
        '342076',
        'INSTITUTO EDUCACIONAL NOSSA SENHORA DA CONCEIÇÃO',
        'SERRO',
        'SRE DIAMANTINA'
    ),
(
        '260797',
        'INPA - INSTITUTO PEDAGÓGICO ARCOENSE',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '312835',
        'INSTITUTO EDUCACIONAL MARIA APARECIDA RIBEIRO',
        'ARCOS',
        'SRE DIVINÓPOLIS'
    ),
(
        '306657',
        'APAE INSTITUTO HELENA ANTIPOFF',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '306339',
        'INSTITUTO EDUCACIONAL CRIANÇARTE',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '41190',
        'INSTITUTO NOSSA SENHORA DO SAGRADO CORAÇÃO',
        'DIVINÓPOLIS',
        'SRE DIVINÓPOLIS'
    ),
(
        '293792',
        'INSTITUTO EDUCACIONAL DE IGUATAMA',
        'IGUATAMA',
        'SRE DIVINÓPOLIS'
    ),
(
        '248720',
        'INSTITUTO SANTA MÔNICA - APAE DE ITAÚNA',
        'ITAÚNA',
        'SRE DIVINÓPOLIS'
    ),
(
        '246166',
        'IMAM- INSTITUTO MARIA AUGUSTA MACHADO',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '376507',
        'INSTITUTO TUTORES DA EDUCAÇÃO',
        'LAGOA DA PRATA',
        'SRE DIVINÓPOLIS'
    ),
(
        '342122',
        'INSTITUTO EDUCACIONAL SABER',
        'NOVA SERRANA',
        'SRE DIVINÓPOLIS'
    ),
(
        '253391',
        'INSTITUTO EDUCACIONAL APOGEU',
        'OLIVEIRA',
        'SRE DIVINÓPOLIS'
    ),
(
        '292770',
        'IMAC- INSTITUTO MARIA ANGÉLICA DE CASTRO',
        'SANTO ANTÔNIO DO MONTE',
        'SRE DIVINÓPOLIS'
    ),
(
        '374890',
        'INSTITUTO EDUCACIONAL CASTELINHO ENCANTADO',
        'AIMORÉS',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '345792',
        'INSTITUTO EDUCACIONAL CASA DO SABER',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '330710',
        'INSTITUTO EDUCACIONAL CONSTRUINDO O SABER',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '303071',
        'INSTITUTO EDUCACIONAL DULCE QUINTÃO',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '303101',
        'INSTITUTO EDUCACIONAL ILHA ENCANTADA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '280259',
        'INSTITUTO EDUCACIONAL LÉLIA ALCÂNTARA',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '302961',
        'INSTITUTO EDUCACIONAL MILLENIUM',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '302937',
        'INSTITUTO PEDAGÓGICO NOVO APRENDER',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '280313',
        'INSTITUTO PEQUENO PRÍNCIPE',
        'GOVERNADOR VALADARES',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '257354',
        'PRÉ ESCOLAR DO INSTITUTO NOSSA SENHORA DE FÁTIMA',
        'MANTENA',
        'SRE GOVERNADOR VALADARES'
    ),
(
        '354872',
        'IESGE - INSTITUTO DE ENSINO E GESTÃO EDUCACIONAL',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '254673',
        'INSTITUTO PRESBITERIANO GAMMON',
        'GUANHÃES',
        'SRE GUANHÃES'
    ),
(
        '295256',
        'INSTITUTO EDUCACIONAL BRAVIEIRA',
        'PEÇANHA',
        'SRE GUANHÃES'
    ),
(
        '369284',
        'INSTITUTO EDUCACIONAL BRAVIEIRA - UNIDADE II',
        'SÃO JOÃO EVANGELISTA',
        'SRE GUANHÃES'
    ),
(
        '376604',
        'INSTITUTO CONEXÃO DE VIRGINÓPOLIS',
        'VIRGINÓPOLIS',
        'SRE GUANHÃES'
    ),
(
        '377627',
        'INSTITUTO MÁRIO BRAGANÇA',
        'ITAJUBÁ',
        'SRE ITAJUBÁ'
    ),
(
        '374857',
        'INSTITUTO AXIOMA - UNIDADE II',
        'CAPINÓPOLIS',
        'SRE ITUIUTABA'
    ),
(
        '370649',
        'INSTITUTO AXIOMA',
        'ITUIUTABA',
        'SRE ITUIUTABA'
    ),
(
        '376795',
        'INSTITUTO AXIOMA - UNIDADE III',
        'SANTA VITÓRIA',
        'SRE ITUIUTABA'
    ),
(
        '363740',
        'INSTITUTO EDUCACIONAL NOVA CIDADANIA',
        'JANAÚBA',
        'SRE JANAÚBA'
    ),
(
        '322474',
        'INSTITUTO PEDAGÓGICO CRESCER',
        'PORTEIRINHA',
        'SRE JANAÚBA'
    ),
(
        '354074',
        'INSTITUTO EDUCACIONAL HAPPY KIDS',
        'ITACARAMBI',
        'SRE JANUÁRIA'
    ),
(
        '67831',
        'INSTITUTO BETEL DE EDUCAÇÃO',
        'JANUÁRIA',
        'SRE JANUÁRIA'
    ),
(
        '366110',
        'INSTITUTO POLIVALENTE DE FORMAÇÃO TÉCNICA',
        'JUVENÍLIA',
        'SRE JANUÁRIA'
    ),
(
        '337846',
        'INSTITUTO EDUCACIONAL PINGO DE GENTE',
        'MONTALVÂNIA',
        'SRE JANUÁRIA'
    ),
(
        '375616',
        'IEB - INSTITUTO EDUCACIONAL BETHEL',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '74519',
        'INSTITUTO MARIA',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '356506',
        'IRMEP INSTITUTO REGINA MATER DE EDUCAÇÃO PROFISSIONAL',
        'JUIZ DE FORA',
        'SRE JUIZ DE FORA'
    ),
(
        '304981',
        'INSTITUTO PIAGET DE ENSINO',
        'LIMA DUARTE',
        'SRE JUIZ DE FORA'
    ),
(
        '352640',
        'INSTITUTO PROMOVE',
        'SANTOS DUMONT',
        'SRE JUIZ DE FORA'
    ),
(
        '102415',
        'INSTITUTO NOSSA SENHORA DO CARMO',
        'CATAGUASES',
        'SRE LEOPOLDINA'
    ),
(
        '254801',
        'IMAN- INSTITUTO METODISTA ARCA DE NOÉ',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '377813',
        'INSTITUTO METODISTA DE EDUCAÇÃO INFANTIL SUZANA WESLEY',
        'LEOPOLDINA',
        'SRE LEOPOLDINA'
    ),
(
        '313351',
        'INSTITUTO CARINHA DE ANJO',
        'MANHUMIRIM',
        'SRE MANHUAÇU'
    ),
(
        '345237',
        'DOCE MENTE INSTITUTO EDUCACIONAL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '282294',
        'EDUCANDÁRIO E CRECHE MENINO JESUS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '306703',
        'IMAM INSTITUTO MINEIRO DE ACUPUNTURA E MASSAGENS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '274666',
        'INAP- INSTITUTO DE ARTE E PROJETO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '345814',
        'INSTITUTO ARCANJO GABRIEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '360708',
        'INSTITUTO BENEFICENTE  FILADÉLFIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '5738',
        'INSTITUTO CECÍLIA MEIRELES - SANTO AGOSTINHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '380504',
        'INSTITUTO CECÍLIA MEIRELES - SANTO AGOSTINHO II',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '5819',
        'INSTITUTO CHARLES PERRAULT',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '377988',
        'INSTITUTO CRESCER ESTRELA DA MANHÃ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '6050',
        'INSTITUTO DA CRIANÇA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '304115',
        'INSTITUTO EDUCACIOANL FLORES SER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '320552',
        'INSTITUTO EDUCACIONAL ÁGAPE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '267040',
        'INSTITUTO EDUCACIONAL ANJINHO DOURADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '323462',
        'INSTITUTO EDUCACIONAL ANJOS DA TERRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '303691',
        'INSTITUTO EDUCACIONAL ANNI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '296732',
        'INSTITUTO EDUCACIONAL ARCA DOS SONHOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '296759',
        'INSTITUTO EDUCACIONAL CANTINHO ENCANTADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '315265',
        'INSTITUTO EDUCACIONAL CASTELINHO DOURADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '356441',
        'INSTITUTO EDUCACIONAL COMUNITÁRIO RECOMEÇAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '381365',
        'INSTITUTO EDUCACIONAL CRESCER E APRENDER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '4014',
        'INSTITUTO EDUCACIONAL DOM BOSCO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '350273',
        'INSTITUTO EDUCACIONAL ESTRELINHA CINTILANTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '315290',
        'INSTITUTO EDUCACIONAL FUTUROS BRILHANTES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '296481',
        'INSTITUTO EDUCACIONAL LAPIDAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '327051',
        'INSTITUTO EDUCACIONAL PIMENTINHA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '257567',
        'INSTITUTO EDUCACIONAL RISQUE E RABISQUE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '298026',
        'INSTITUTO EDUCACIONAL SALADA DE FRUTAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '360740',
        'INSTITUTO EDUCACIONAL SANT''ANA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '354511',
        'INSTITUTO EDUCACIONAL SÃO CAMILO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '244104',
        'INSTITUTO EDUCACIONAL SÃO JOÃO BATISTA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '332259',
        'INSTITUTO EDUCACIONAL SERRA DOURADA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '298468',
        'INSTITUTO EDUCACIONAL SONHO INFANTIL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '297585',
        'INSTITUTO EDUCACIONAL VALÉRIA AGUIAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '315354',
        'INSTITUTO EDUCACIONAL VERDE VIDA - SERRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '373346',
        'INSTITUTO FLÁVIA ALVES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '298794',
        'INSTITUTO INFANTIL CONSTRUINDO A VIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '296767',
        'INSTITUTO INFANTIL MACHADO CINELLI I',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '7013',
        'INSTITUTO INFANTIL PIRUNELLO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '374490',
        'INSTITUTO MONITOR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '4987',
        'INSTITUTO MONTEIRO LOBATO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '347043',
        'INSTITUTO PEDAGÓGICO CRISTÃO INTEGRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '345091',
        'INSTITUTO PEDAGÓGICO DO RE MI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '355925',
        'INSTITUTO PEDAGÓGICO ILUMINAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '217174',
        'INSTITUTO PEDAGÓGICO SANTA TEREZA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '297330',
        'INSTITUTO PEDAGÓGICO SANTA TEREZA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '343480',
        'INSTITUTO PEGAGÓGICO VALÉRIA MARINHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '298123',
        'INSTITUTO PINGO DE LUZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '5321',
        'INSTITUTO PSICOPEDAGÓGICO FONTE DE VIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '331872',
        'INSTITUTO SÃO FRANCISCO DE ASSIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '331040',
        'INSTITUTO TARCÍSIO BISINOTTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '257834',
        'IPEMIG- INSTITUTO PRESBITERIANO DE EDUCAÇÃO DE MINAS GERAIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA A'
    ),
(
        '278530',
        'INSTITUTO EDUCACIONAL E PSICOPEDAGÓGICO SENA FIGUEIREDO',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '317381',
        'INSTITUTO EDUCACIONAL LÁPIS DE COR',
        'CAETÉ',
        'SRE METROPOLITANA A'
    ),
(
        '369543',
        'ARTE E ALEGRIA INSTITUTO EDUCACIONAL',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '266655',
        'INSTITUTO CÁSSIO MAGNANI',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '378453',
        'INSTITUTO CÁSSIO MAGNANI - UNIDADE II',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '324353',
        'INSTITUTO EDUCACIONAL SANTA RITA DE CÁSSIA',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '366137',
        'INSTITUTO EDUCACIONAL SANTA RITA DE CÁSSIA - UNIDADE II',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '249483',
        'INSTITUTO ÍTALO BRASILEIRO BICULTURAL',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '356700',
        'INSTITUTO OURO VERDE',
        'NOVA LIMA',
        'SRE METROPOLITANA A'
    ),
(
        '229784',
        'INSTITUTO CLUBE DO MICKEY',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '312231',
        'INSTITUTO DE EDUCAÇÃO BATISTA DE SABARÁ',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '327531',
        'INSTITUTO EDUCACIONAL IRMÃS CANISIANAS',
        'SABARÁ',
        'SRE METROPOLITANA A'
    ),
(
        '273244',
        'EDUCANDÁRIO ESTRELAS DO FUTURO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '281859',
        'EDUCANDÁRIO PRESBITERIANO RENOVADO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '337765',
        'IEB INSTITUTO EDUCACIONAL BELO HORIZONTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '5312',
        'INSTITUTO AMÉLIA BRAGA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '329517',
        'INSTITUTO BALÃO AZUL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '5495',
        'INSTITUTO BEM ME QUER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '350974',
        'INSTITUTO BETÂNIA DE EDUCAÇÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '5975',
        'INSTITUTO CORAÇÃO DE JESUS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '371556',
        'INSTITUTO CORAÇÃO DE JESUS - UNIDADE II',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '308731',
        'INSTITUTO CRISTÃO ÁGAPE UNIDADE BONFIM',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '331724',
        'INSTITUTO CRISTÃO ARCA DA ALIANÇA- UNIDADE ARAGUAIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '364762',
        'INSTITUTO CRISTÃO ARCA DA ALIANÇA- UNIDADE MILIONÁRIOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '315249',
        'INSTITUTO DE EDUCAÇÃO ARCA DE NOÉ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '370894',
        'INSTITUTO DE EDUCAÇÃO ARCA DE NOÉ - UNIDADE SERRANO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '6459',
        'INSTITUTO DE EDUCAÇÃO BAMBAM E PEDRITA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '356867',
        'INSTITUTO DE EDUCAÇÃO CRIANÇA FELIZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '297445',
        'INSTITUTO DE EDUCAÇÃO INFANTIL CANTINHO MÁGICO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '377236',
        'INSTITUTO DE EDUCAÇÃO INFANTIL CANTINHO MÁGICO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '357235',
        'INSTITUTO DE EDUCAÇÃO TEMPO DE DESCOBRIR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '304034',
        'INSTITUTO EDUCACIONAL APRENDER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '296708',
        'INSTITUTO EDUCACIONAL AQUARELA MÁGICA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '375624',
        'INSTITUTO EDUCACIONAL ARAÚJO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '374067',
        'INSTITUTO EDUCACIONAL ARTE DE APRENDER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '210102',
        'INSTITUTO EDUCACIONAL BAIÃO SANTOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '362859',
        'INSTITUTO EDUCACIONAL CAMINHAR UNIDADE VALE DO JATOBÁ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '373443',
        'INSTITUTO EDUCACIONAL CANTINHO DO SABER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '346462',
        'INSTITUTO EDUCACIONAL CASTELINHO DO BEBÊ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '349151',
        'INSTITUTO EDUCACIONAL CIDADÃO DOS CÉUS IECC',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '352217',
        'INSTITUTO EDUCACIONAL COLORIR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '273791',
        'INSTITUTO EDUCACIONAL DO SABER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '229750',
        'INSTITUTO EDUCACIONAL E CRECHE EVANGÉLICA ABRIGO DE PAZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '299791',
        'INSTITUTO EDUCACIONAL EDEL QUINN',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '369012',
        'INSTITUTO EDUCACIONAL ESCUDO DA VERDADE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '332054',
        'INSTITUTO EDUCACIONAL FACULDADE DA CRIANÇA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '345202',
        'INSTITUTO EDUCACIONAL GABRIEL FERNANDES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '217166',
        'INSTITUTO EDUCACIONAL GABRIELA LEOPOLDINA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '304123',
        'INSTITUTO EDUCACIONAL GASPARZINHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '374083',
        'INSTITUTO EDUCACIONAL INFANTIL EMANUEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '371335',
        'INSTITUTO EDUCACIONAL IPÊ AMARELO - UNIDADE BURITIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '344800',
        'INSTITUTO EDUCACIONAL LETÍCIA CAMARGOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '303682',
        'INSTITUTO EDUCACIONAL MARIA MORATO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '376981',
        'INSTITUTO EDUCACIONAL MEU QUINTAL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '4782',
        'INSTITUTO EDUCACIONAL MÔNICA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '331686',
        'INSTITUTO EDUCACIONAL MUNDO DA IMAGINAÇÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '278327',
        'INSTITUTO EDUCACIONAL PERNALONGA_ CEDEF',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '4260',
        'INSTITUTO EDUCACIONAL PETER PAN',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '347051',
        'INSTITUTO EDUCACIONAL PRIMEIROS PASSOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '368504',
        'INSTITUTO EDUCACIONAL RAIO DE LUZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '257435',
        'INSTITUTO EDUCACIONAL RECANTO DO SABER I',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '372684',
        'INSTITUTO EDUCACIONAL TIA BETH',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '368997',
        'INSTITUTO EDUCACIONAL VILA DOS SONHOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '217239',
        'INSTITUTO ELIZABETH TEIXEIRA DIAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '281972',
        'INSTITUTO ESPÍRITA EURÍPEDES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '367419',
        'INSTITUTO FRE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '375594',
        'INSTITUTO GAMA DE ENSINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '331074',
        'INSTITUTO INFANTIL RECREAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '348325',
        'INSTITUTO INFANTIL SEMENTINHA DO FUTURO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '292753',
        'INSTITUTO MODAL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '374113',
        'INSTITUTO MONTESSORI GENTE MIÚDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '315257',
        'INSTITUTO MÚLTIPLO DE ENSINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '331945',
        'INSTITUTO NAIMA GRAZZIANE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '347965',
        'INSTITUTO PEDAGÓGICO COMECINHO DE VIDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '331694',
        'INSTITUTO PEDAGÓGICO CRIAR CRIANÇA FELIZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '267058',
        'INSTITUTO PEDAGÓGICO LÁPIS DE COR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '304301',
        'INSTITUTO PEDAGÓGICO O PEQUENO PRÍNCIPE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '321788',
        'INSTITUTO PEDAGÓGICO OFICINA DO SABER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '377961',
        'INSTITUTO QUINTINO DE ENSINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '368431',
        'INSTITUTO ROUSSEAU DE BELO HORIZONTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '262251',
        'INSTITUTO SANTA PAULA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '261696',
        'INSTITUTO TÉCNICO INOVAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '355941',
        'INSTITUTO TIA LÚCIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '344672',
        'INSTITUTO ZIP ZAP I',
        'BELO HORIZONTE',
        'SRE METROPOLITANA B'
    ),
(
        '358568',
        'INSTITUTO  EDUCACIONAL CRUZEIRO DO SUL',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334723',
        'INSTITUTO  EDUCACIONAL EBENEZER UNID IV',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '380601',
        'INSTITUTO ARCO DOURADO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '335991',
        'INSTITUTO BATISTA MINEIRO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '336017',
        'INSTITUTO EDUCACIONAL  DIDÁTICA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '355020',
        'INSTITUTO EDUCACIONAL ALIANÇA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '317993',
        'INSTITUTO EDUCACIONAL AMAR',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '336076',
        'INSTITUTO EDUCACIONAL ARARAJUBA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '302597',
        'INSTITUTO EDUCACIONAL BEM TE VI',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '335916',
        'INSTITUTO EDUCACIONAL COLIBRIS',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '324761',
        'INSTITUTO EDUCACIONAL DÉBORA ROCHA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334235',
        'INSTITUTO EDUCACIONAL EBENEZER UNID II',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '323764',
        'INSTITUTO EDUCACIONAL GESTALD',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '360228',
        'INSTITUTO EDUCACIONAL GUARÁ',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '365980',
        'INSTITUTO EDUCACIONAL INFANTIL ALFABETO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334715',
        'INSTITUTO EDUCACIONAL INFANTIL EBENEZER -UNIDADE I',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '369551',
        'INSTITUTO EDUCACIONAL JOÃO BOLINHA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '223123',
        'INSTITUTO EDUCACIONAL MARRIAN',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '338613',
        'INSTITUTO EDUCACIONAL MONTEIRO LOBATO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '362603',
        'INSTITUTO EDUCACIONAL NASCER',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '237027',
        'INSTITUTO EDUCACIONAL NOSSA SENHORA APARECIDA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334650',
        'INSTITUTO EDUCACIONAL NOVA GERAÇÃO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '375900',
        'INSTITUTO EDUCACIONAL PALNETA AZUL BETIM',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '377112',
        'INSTITUTO EDUCACIONAL PINTANDO O SABER',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334642',
        'INSTITUTO EDUCACIONAL PRIMEIROS PASSOS',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '349615',
        'INSTITUTO EDUCACIONAL RAQUEL MENEZES',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '343307',
        'INSTITUTO EDUCACIONAL SUDELI',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334626',
        'INSTITUTO EDUCACIONAL TIA DULCE',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '334537',
        'INSTITUTO INFANTIL CANTINHO DA VILA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '373559',
        'INSTITUTO INFANTIL DE MÃOS DADAS PARA O FUTURO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '328014',
        'INSTITUTO OLIVEIRA LARA - UNIDADE CRESCER DE ENSINO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '374970',
        'INSTITUTO PEDAGÓGICO ANJINHOS',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '350621',
        'INSTITUTO PEDAGÓGICO GABRIEL SIMPLÍCIO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '336041',
        'INSTITUTO PEDAGÓGICO MAURIVAR ROSA',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '324396',
        'INSTITUTO RAIO DE SOL',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '348589',
        'INSTITUTO SONHO MIRIM',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '294241',
        'IPAC- INSTITUTO PATRÍCIA CARVALHO',
        'BETIM',
        'SRE METROPOLITANA B'
    ),
(
        '330213',
        'IEMAB - INSTITUTO EDUCACIONAL MÁRIO BRAGA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '370363',
        'INSTITUTO CEIP',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '274208',
        'INSTITUTO EDUCACIOANL UMBERTO CORRÊA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '244724',
        'INSTITUTO EDUCACIONAL AQUARELA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '223204',
        'INSTITUTO EDUCACIONAL EBENEZER',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '345067',
        'INSTITUTO EDUCACIONAL EMANUEL',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '327077',
        'INSTITUTO EDUCACIONAL LIBERTAS',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '294161',
        'INSTITUTO EDUCACIONAL LUA DE CRISTAL',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '261131',
        'INSTITUTO EDUCACIONAL MEU CANTINHO FELIZ',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '291811',
        'INSTITUTO EDUCACIONAL MONTEIRO LOBATO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '269913',
        'INSTITUTO EDUCACIONAL NÍDIA ZENHA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '313980',
        'INSTITUTO EDUCACIONAL SARA CAMILO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '331198',
        'INSTITUTO EDUCACIONAL SONHO MEU',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '318965',
        'INSTITUTO EDUCACIONAL TIA MARIA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '368024',
        'INSTITUTO EDUCACIONAL VIVENDO E APRENDENDO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '14206',
        'INSTITUTO ELIZABETH KALIL',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '236934',
        'INSTITUTO EROS GUSTAVO',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '329452',
        'INSTITUTO HELENA FERNANDES',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '14036',
        'INSTITUTO JOANA D''ARC',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '262552',
        'INSTITUTO KELLY',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '14290',
        'INSTITUTO MARIA MONTESSORI',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '261190',
        'INSTITUTO PEDAGÓGICO O PEQUENO PRÍNCIPE',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '229857',
        'INSTITUTO PEDAGÓGICO TEREZA CRISTINA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '365637',
        'INSTITUTO PETILANDIA',
        'CONTAGEM',
        'SRE METROPOLITANA B'
    ),
(
        '375934',
        'INSTITUTO EDUCACIONAL INFANTIL PINGUINHO DE GENTE',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '333115',
        'INSTITUTO PEDAGÓGICO PEQUENO PRINCIPE',
        'ESMERALDAS',
        'SRE METROPOLITANA B'
    ),
(
        '293202',
        'INSTITUTO CULTURAL SEMPRE JATOBÁ',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '340847',
        'INSTITUTO EDUCACIONAL ANA CATARINA',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '237043',
        'INSTITUTO EDUCACIONAL CASTRO ALVES',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '367567',
        'INSTITUTO INFANTIL CANTINHO DOS SONHOS',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '330086',
        'INSTITUTO OÁSIS',
        'IBIRITÉ',
        'SRE METROPOLITANA B'
    ),
(
        '323403',
        'INSTITUTO DE EDUCAÇÃO RAÍZES',
        'IGARAPÉ',
        'SRE METROPOLITANA B'
    ),
(
        '41394',
        'EDUCANDÁRIO SÃO JOSÉ',
        'MATEUS LEME',
        'SRE METROPOLITANA B'
    ),
(
        '320773',
        'CRECHE EDUCANDÁRIO MEIMEI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '364851',
        'IEMP-INSTITUTO EDUCACIONAL MANOEL PINHEIRO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '378046',
        'IEPM - INSTITUTO EDUCACIONAL PADRINHO E MADRINHA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '315371',
        'INSTITUTO ÁGAPE DE ENSINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '258113',
        'INSTITUTO BARQUINHO AMARELO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '367087',
        'INSTITUTO BATISTA ITATIAIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '376175',
        'INSTITUTO BETANIA PRIMEIROS PASSOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '377007',
        'INSTITUTO BETÂNIA PRIMEIROS PASSOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '372455',
        'INSTITUTO CECÍLIA MEIRELES - UNIDADE CASTELO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '380512',
        'INSTITUTO CECÍLIA MEIRELES - UNIDADE CASTELO II',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '351768',
        'INSTITUTO CRISTÃO CALVÁRIO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '372668',
        'INSTITUTO DE EDUCAÇÃO ARCA DE NOÉ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '374059',
        'INSTITUTO DE EDUCAÇÃO INFANTIL CLUBE DO MICKEY',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '344788',
        'INSTITUTO DE EDUCAÇÃO MONTEIRO LOBATO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '371998',
        'INSTITUTO DINAMUS DE ENSINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '344796',
        'INSTITUTO EDUCACIONAL ARCO ÍRIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '307033',
        'INSTITUTO EDUCACIONAL CAMPO ALEGRE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '298760',
        'INSTITUTO EDUCACIONAL CARROSSEL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '4448',
        'INSTITUTO EDUCACIONAL CÉU AZUL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '351750',
        'INSTITUTO EDUCACIONAL COPACABANA(GENTE INOCENTE)',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '372633',
        'INSTITUTO EDUCACIONAL CRESCERE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '331023',
        'INSTITUTO EDUCACIONAL CRISTAL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '356280',
        'INSTITUTO EDUCACIONAL CRISTÃO PEQUENOS BRILHANTES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '372870',
        'INSTITUTO EDUCACIONAL CRISTÃO SEMEAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '375217',
        'INSTITUTO EDUCACIONAL CRISTÃO SEMEAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '343498',
        'INSTITUTO EDUCACIONAL DA MÔNICA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '315281',
        'INSTITUTO EDUCACIONAL D''PAULAS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '371599',
        'INSTITUTO EDUCACIONAL E ROUXINOLZINHO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '298697',
        'INSTITUTO EDUCACIONAL ESPAÇO CRIATIVO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '372609',
        'INSTITUTO EDUCACIONAL ESTRELINHA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '246077',
        'INSTITUTO EDUCACIONAL EVANGÉLICO MONTE SIÃO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '374075',
        'INSTITUTO EDUCACIONAL EVANGÉLICO SAL DA TERRA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '373389',
        'INSTITUTO EDUCACIONAL GETSÊMANI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '344591',
        'INSTITUTO EDUCACIONAL GIRASSOL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '297771',
        'INSTITUTO EDUCACIONAL HELIÓPOLIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '297721',
        'INSTITUTO EDUCACIONAL IPÊ AMARELO - UNIDADE JARDIM ATLÂNTICO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '375497',
        'INSTITUTO EDUCACIONAL JABUTI JABUTICABA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '374091',
        'INSTITUTO EDUCACIONAL JACKSON DE LIMA CRUZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '348317',
        'INSTITUTO EDUCACIONAL JAQUELINE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '217263',
        'INSTITUTO EDUCACIONAL MANOEL PINHEIRO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '363936',
        'INSTITUTO EDUCACIONAL MEI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '340391',
        'INSTITUTO EDUCACIONAL MISSÃO PAZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '338435',
        'INSTITUTO EDUCACIONAL PEQUENA VIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '347116',
        'INSTITUTO EDUCACIONAL PEQUENINOS DO REI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '324566',
        'INSTITUTO EDUCACIONAL PING PONG',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '367109',
        'INSTITUTO EDUCACIONAL PLANALTO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '355763',
        'INSTITUTO EDUCACIONAL RAIO DE SOL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '298204',
        'INSTITUTO EDUCACIONAL RECANTO DOS ANJOS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '374105',
        'INSTITUTO EDUCACIONAL RENOVO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '270024',
        'INSTITUTO EDUCACIONAL RIO BRANCO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '304174',
        'INSTITUTO EDUCACIONAL SÃO LUIZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '327581',
        'INSTITUTO EDUCACIONAL SARAMENHA IESA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '217212',
        'INSTITUTO EDUCACIONAL SETE ANÕES',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '377880',
        'INSTITUTO EDUCACIONAL SHALOM',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '351741',
        'INSTITUTO EDUCACIONAL TIC-TAC',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '356034',
        'INSTITUTO EDUCACIONAL TREM DA ALEGRIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '351580',
        'INSTITUTO EDUCACIONAL YELLOW',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '294039',
        'INSTITUTO EMÍLIA FERREIRO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '378461',
        'INSTITUTO GABRIELA LEOPOLDINA - UNIDADE 2',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '289825',
        'INSTITUTO INFANTIL SÃO JOSÉ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '4481',
        'INSTITUTO ITAPOÃ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '356255',
        'INSTITUTO LÍDER DE ENSINO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '358444',
        'INSTITUTO NACIONAL DE EDUCAÇÃO TECNOLÓGICA HEILER ALVES DA ROCHA-INET-HAR',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '380520',
        'INSTITUTO ONCINHA PINTADA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '210285',
        'INSTITUTO PE ANGÉLICO LIPÁNI',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '371645',
        'INSTITUTO PEDAGÓCIGO EDUCARTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '315397',
        'INSTITUTO PEDAGÓGICO CENÁRIO INFANTIL',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '329151',
        'INSTITUTO PEDAGÓGICO GÊNESIS',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '345652',
        'INSTITUTO PEDAGÓGICO MIRANTE',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '329771',
        'INSTITUTO PEDAGÓGICO PAULO LACERDA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '355674',
        'INSTITUTO PEDAGÓGICO PEQUENO APRENDIZ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '344273',
        'INSTITUTO PEDAGÓGICO PIU PIU',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '360775',
        'INSTITUTO PEDAGÓGICO PIU PIU',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '372145',
        'INSTITUTO PEDAGÓGICO SONHO DA VOVÓ',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '365610',
        'INSTITUTO PEGAGÓGICO JANELINHA DO SABER',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '304166',
        'INSTITUTO SANTA AMÉLIA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '355984',
        'INSTITUTO SANTA MÔNICA',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '373036',
        'INSTITUTO SONHO DA VOVÓ II',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '281565',
        'INSTITUTO ZILAH SPÓSITO',
        'BELO HORIZONTE',
        'SRE METROPOLITANA C'
    ),
(
        '362409',
        'INSTITUTO EDUCACIONAL BRINCANDO E APRENDENDO',
        'CONFINS',
        'SRE METROPOLITANA C'
    ),
(
        '332852',
        'INSTITUTO PEDAGÓGICO PINTANDO O SETE',
        'LAGOA SANTA',
        'SRE METROPOLITANA C'
    ),
(
        '293407',
        'INSTITUTO EDUCACIONAL VIDA PLENA',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '14460',
        'INSTITUTO LACOAN',
        'PEDRO LEOPOLDO',
        'SRE METROPOLITANA C'
    ),
(
        '215813',
        'INSTITUTO EDUCACIONAL DOM BOSCO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '326194',
        'INSTITUTO EDUCACIONAL EL SHADAI',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '350591',
        'INSTITUTO EDUCACIONAL ELOHIM',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '351784',
        'INSTITUTO EDUCACIONAL FLORISVALDO RAMOS',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '366102',
        'INSTITUTO EDUCACIONAL LAR DAS CRIANÇAS',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '345717',
        'INSTITUTO EDUCACIONAL PARAÍSO INFANTIL',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '369713',
        'INSTITUTO EDUCACIONAL PASSOS FIRMES',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '369241',
        'INSTITUTO EDUCACIONAL PICURRUCHO',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '369926',
        'INSTITUTO EDUCACIONAL RUY BARBOSA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '317799',
        'INSTITUTO EDUCACIONAL SOSSEGO DA MAMÃE',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '362727',
        'INSTITUTO EDUCACIONAL TIA ALCI & CIA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '372757',
        'INSTITUTO EDUCACIONAL TURMA DA MÔNICA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '323021',
        'INSTITUTO METHA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '372749',
        'INSTITUTO PEDAGÓGICO CRISTO REY',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '365149',
        'INSTITUTO PEDAGÓGICO EDUCAR',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '372730',
        'INSTITUTO PEDAGÓGICO TEMPO DE CRIANÇA',
        'RIBEIRÃO DAS NEVES',
        'SRE METROPOLITANA C'
    ),
(
        '261327',
        'INSTITUTO EDUCACIONAL LONDRINA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '211958',
        'INSTITUTO EDUCACIONAL RACIONAL',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '215830',
        'INSTITUTO EDUCACIONAL SANTA AMÉLIA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '375748',
        'INSTITUTO EDUCACIONAL VEREDA',
        'SANTA LUZIA',
        'SRE METROPOLITANA C'
    ),
(
        '379824',
        'INSTITUTO EDUCACIONAL CRISTÃO KAIRÓS',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '328022',
        'INSTITUTO EDUCACIONAL VESPANITO',
        'VESPASIANO',
        'SRE METROPOLITANA C'
    ),
(
        '317764',
        'INSTITUTO EDUCACIONAL DE COROMANDEL INEC',
        'COROMANDEL',
        'SRE MONTE CARMELO'
    ),
(
        '344761',
        'INSTITUTO DE EDUCAÇÃO E CULTURA DE BOCAIÚVA',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '301256',
        'INSTITUTO EDUCACIONAL CONTOS DE FADAS',
        'BOCAIÚVA',
        'SRE MONTES CLAROS'
    ),
(
        '347604',
        'INSTITUTO GÊNESIS',
        'BRASÍLIA DE MINAS',
        'SRE MONTES CLAROS'
    ),
(
        '320951',
        'INSTITUTO EDUCACIONAL MÚSICO ECOLÓGICO CIRANDA BREJEIRA',
        'FRANCISCO SÁ',
        'SRE MONTES CLAROS'
    ),
(
        '348473',
        'IESC INSTITUTO EDUCACIONAL SANTA CRUZ',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '289183',
        'INSTITUTO DE DESENVOLVIMENTO EDUCACIONAL ÁGAPE',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '358070',
        'INSTITUTO DE EDUCAÇÃO QUALIFICAR',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '300560',
        'INSTITUTO EDUC PETER PAN',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '344265',
        'INSTITUTO EDUCACIONAL CASINHA MÁGICA',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '274259',
        'INSTITUTO EDUCACIONAL MÁGICO DE OZ',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '342360',
        'INSTITUTO EDUCACIONAL PEQUENOS PENSADORES',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '372331',
        'INSTITUTO MONTESCLARENSE DE EDUCAÇÃO E DESENVOLVIMENTO',
        'MONTES CLAROS',
        'SRE MONTES CLAROS'
    ),
(
        '346390',
        'INSTITUTO EDUCACIONAL MARIA ALICE',
        'OLHOS-D''ÁGUA',
        'SRE MONTES CLAROS'
    ),
(
        '324086',
        'EDUCANDÁRIO FAVO DE MEL',
        'MURIAÉ',
        'SRE MURIAÉ'
    ),
(
        '349240',
        'INSTITUTO BRASILEIRO DE INOVAÇÃO E SUSTENTABILIDADE - IBIS',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '301370',
        'INSTITUTO EDUCACIONAL INFANTIL BOLHAS DE SABÃO',
        'ITABIRA',
        'SRE NOVA ERA'
    ),
(
        '299855',
        'INSTITUTO EDUCACIONAL PINGO DE GENTE',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '107981',
        'INSTITUTO SANTO ANTÔNIO DE PÁDUA',
        'ITABIRITO',
        'SRE OURO PRETO'
    ),
(
        '277584',
        'INSTITUTO EDUCACIONAL CRIATIVO DE ABAETÉ',
        'ABAETÉ',
        'SRE PARÁ DE MINAS'
    ),
(
        '372048',
        'INSTITUTO PRIMEIROS PASSOS',
        'BOM DESPACHO',
        'SRE PARÁ DE MINAS'
    ),
(
        '279382',
        'INSTITUTO ESTHER VALÉRIO',
        'PITANGUI',
        'SRE PARÁ DE MINAS'
    ),
(
        '317861',
        'EDUCANDÁRIO AQUARELA',
        'BRASILÂNDIA DE MINAS',
        'SRE PARACATU'
    ),
(
        '262358',
        'APAE EDUCANDÁRIO CÉSAR BROCHADO ADJUTO',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '317241',
        'EDUCANDÁRIO ESPÍRITA LÚCIO ABREU',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '249211',
        'INSTITUTO PRIMÍCIAS',
        'PARACATU',
        'SRE PARACATU'
    ),
(
        '254291',
        'INSTITUTO EDUCACIONAL PADRE UBIRAJARA CABRAL',
        'ALPINÓPOLIS',
        'SRE PASSOS'
    ),
(
        '374199',
        'INSTITUTO EDUCACIONAL FIT - MG',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '311553',
        'INSTITUTO EDUCACIONAL MÁRIS CÉLIS',
        'PASSOS',
        'SRE PASSOS'
    ),
(
        '241776',
        'INSTITUTO PERFIL DE EDUCAÇÃO',
        'PIUMHI',
        'SRE PASSOS'
    ),
(
        '295345',
        'INSTITUTO ELLOS DE EDUCAÇÃO',
        'SÃO ROQUE DE MINAS',
        'SRE PASSOS'
    ),
(
        '252263',
        'INSTITUTO EDUCACIONAL ALEGRIA DE SABER',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '380199',
        'INSTITUTO EDUCACIONAL BRINCANDO E APRENDENDO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '306355',
        'INSTITUTO EDUCACIONAL FAZENDO ARTE',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '380164',
        'INSTITUTO EDUCACIONAL INFANTIL SEMEAR',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '215589',
        'INSTITUTO PEDAGÓGICO VÓ MARIA',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '281174',
        'INSTITUTO PRESBITERIANO DE EDUCAÇÃO',
        'PATOS DE MINAS',
        'SRE PATOS DE MINAS'
    ),
(
        '369187',
        'INSTITUTO EDUCACIONAL ORDERICO BATISTA DE ARAÚJO',
        'RIO PARANAÍBA',
        'SRE PATOS DE MINAS'
    ),
(
        '369390',
        'INSTITUTO EDUCACIONAL EQUIPE SG - ALEGRIA DE SABER',
        'SÃO GOTARDO',
        'SRE PATOS DE MINAS'
    ),
(
        '350362',
        'INSTITUTO EDUCACIONAL BETEL',
        'PIRAPORA',
        'SRE PIRAPORA'
    ),
(
        '362506',
        'INSTITUTO EDUCACIONAL ESPÍRITA EURÍPEDES BARSANULFO',
        'VÁRZEA DA PALMA',
        'SRE PIRAPORA'
    ),
(
        '127841',
        'INSTITUTO DE EDUCAÇÃO ALFA',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '355356',
        'INSTITUTO DE EDUCAÇÃO ALFA I',
        'ANDRADAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '128058',
        'INSTITUTO EDUCACIONAL SÃO JOÃO DA ESCÓCIA',
        'POÇOS DE CALDAS',
        'SRE POÇOS DE CALDAS'
    ),
(
        '133621',
        'INSTITUTO MONTESSORI',
        'PONTE NOVA',
        'SRE PONTE NOVA'
    ),
(
        '375918',
        'EDUCANDÁRIO BRINCANDO E APRENDENDO',
        'EXTREMA',
        'SRE POUSO ALEGRE'
    ),
(
        '62235',
        'INSTITUTO DE EDUCAÇÃO E ENSINO DE POUSO ALEGRE',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '313181',
        'INSTITUTO EDUCACIONAL INFANTIL ABELHINHA MÁGICA',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '248053',
        'INSTITUTO FELLIPPO SMALDONE',
        'POUSO ALEGRE',
        'SRE POUSO ALEGRE'
    ),
(
        '136751',
        'INSTITUTO AUXILIADORA',
        'SÃO JOÃO DEL REI',
        'SRE SÃO JOÃO DEL REI'
    ),
(
        '271641',
        'INSTITUTO EDUCACIONAL PEQUENA SEREIA',
        'CAPIM BRANCO',
        'SRE SETE LAGOAS'
    ),
(
        '367257',
        'INSTITUTO AMAE',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '359831',
        'INSTITUTO DE EDUCAÇÃO MENINADA CRESCER',
        'MATOZINHOS',
        'SRE SETE LAGOAS'
    ),
(
        '254118',
        'EDUCANDÁRIO CECÍLIA MEIRELES',
        'PAPAGAIOS',
        'SRE SETE LAGOAS'
    ),
(
        '260291',
        'INSTITUTO DE EDUCAÇÃO O TIJOLINHO',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '259764',
        'INSTITUTO DE EDUCAÇÃO SANTA MARIA',
        'POMPÉU',
        'SRE SETE LAGOAS'
    ),
(
        '145700',
        'INSTITUTO ALICE MACIEL',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '233421',
        'INSTITUTO EDUCACIONAL CARROSSEL',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '230707',
        'INSTITUTO EDUCACIONAL PETER PAN',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '298450',
        'INSTITUTO EDUCACIONAL SEMENTES DO SABER',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '232955',
        'INSTITUTO INFANTIL LAGOA ENCANTADA',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '214078',
        'INSTITUTO INFANTIL VIVACOR',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '325830',
        'INSTITUTO PÁSSARO AZUL',
        'SETE LAGOAS',
        'SRE SETE LAGOAS'
    ),
(
        '266060',
        'INSTITUTO EDUCACIONAL SÃO FRANCISCO DE ASSIS - IESFA',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '375390',
        'INSTITUTO TÉCNICO PROFISSIONAL DE ITAMBACURI',
        'ITAMBACURI',
        'SRE TEÓFILO OTONI'
    ),
(
        '157953',
        'EDUCANDÁRIO CARLOS DRUMOND DE ANDRADE',
        'NANUQUE',
        'SRE TEÓFILO OTONI'
    ),
(
        '365157',
        'INSTITUTO EDUCACIONAL PEQUENO POLEGAR',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '323365',
        'INSTITUTO EDUCACIONAL RISQUE E RABISQUE',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '323373',
        'INSTITUTO EDUCIONAL CARROSSEL',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '367052',
        'INSTITUTO LÁPIS DE COR',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '347426',
        'INSTITUTO SEMEAR',
        'TEÓFILO OTONI',
        'SRE TEÓFILO OTONI'
    ),
(
        '369322',
        'CENTRO DE EDUCAÇÃO INFANTIL - INSTITUTO EDUCARTE',
        'DONA EUSÉBIA',
        'SRE UBÁ'
    ),
(
        '356492',
        'IEB - INSTITUTO EDUCACIONAL BETHEL',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '238082',
        'INSTITUTO DE APLICAÇÃO EDUCACIONAL',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '264466',
        'INSTITUTO EDUCACIONAL SEMEAR DE UBÁ',
        'UBÁ',
        'SRE UBÁ'
    ),
(
        '291609',
        'INSTITUTO DE EDUCAÇÃO INFANTIL PINTANDO O SETE',
        'ARAXÁ',
        'SRE UBERABA'
    ),
(
        '320871',
        'INSTITUTO EDUCACIONAL PROFISSIONALIZANTE DE ITURAMA',
        'ITURAMA',
        'SRE UBERABA'
    ),
(
        '341533',
        'EDUCANDÁRIO MENINO JESUS DE PRAGA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '330299',
        'ESCOLA DO INSTITUTO DE CEGOS DO BRASIL CENTRAL',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '366684',
        'INSTITUTO DE EDUCAÇÃO INTERATIVA',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '310395',
        'INSTITUTO EDUCACIONAL FERREIRA GOMES',
        'UBERABA',
        'SRE UBERABA'
    ),
(
        '170232',
        'INSTITUTO FRANCISCO SAVÉRIO PETANHA',
        'ARAGUARI',
        'SRE UBERLÂNDIA'
    ),
(
        '352993',
        'CASTELA INSTITUTO DE ENSINO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

INSERT INTO schools (inep_code, name, city, sre)
VALUES
(
        '346845',
        'INSTITUTO DE ESTUDOS INTEGRADOS',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '377104',
        'INSTITUTO EDUCACIONAL CLUBINHO DA CRIANÇA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '210510',
        'INSTITUTO EDUCACIONAL SANTA MÔNICA',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '230758',
        'INSTITUTO EDUCACIONAL SHALOM',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '318108',
        'INSTITUTO PENIEL DE ENSINO',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '375268',
        'INSTITUTO PROPÉ',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '170607',
        'INSTITUTO TERESA VALSÉ',
        'UBERLÂNDIA',
        'SRE UBERLÂNDIA'
    ),
(
        '278963',
        'APAE EDUCANDÁRIO SENHOR DO BONFIM',
        'BONFINÓPOLIS DE MINAS',
        'SRE UNAÍ'
    ),
(
        '376671',
        'IEL - INSTITUTO EDUCACIONAL LATTES',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '114804',
        'INSTITUTO ATHOS',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '379913',
        'INSTITUTO ELTA LANIA EDUCA  MAIS - IEL EDUCA MAIS',
        'UNAÍ',
        'SRE UNAÍ'
    ),
(
        '381756',
        'ESCOLA INSTITUTO AQUARELA DO BRASIL',
        'ALFENAS',
        'SRE VARGINHA'
    ),
(
        '305723',
        'INSTITUTO EDUCACIONAL APROVA',
        'NEPOMUCENO',
        'SRE VARGINHA'
    ),
(
        '358177',
        'SOLLARE INSTITUTO EDUCACIONAL',
        'VARGINHA',
        'SRE VARGINHA'
    )
ON CONFLICT (inep_code) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

COMMIT;

-- Verificação
SELECT 
    COUNT(*) as total_escolas,
    COUNT(DISTINCT city) as total_cidades,
    COUNT(DISTINCT sre) as total_sres
FROM schools;

SELECT inep_code, name, city, sre FROM schools LIMIT 10;
