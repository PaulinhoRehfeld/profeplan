// ============================================================================
// GERADO AUTOMATICAMENTE por scripts/build-prompts.mjs — NÃO EDITAR À MÃO.
// Fonte: prompts/*.md nesta mesma pasta. Para atualizar, edite o .md e rode:
//   node packages/agents/scripts/build-prompts.mjs
// ============================================================================

export const PROMPTS: Record<string, string> = {
  'avaliacao.md': `# Template de Prompt — Avaliação (Sociologia)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Sociologia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique \`[A DEFINIR]\` — NUNCA invente dados
sociológicos, estatísticas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Sociologia
- **Ano/Série:** {{ano_serie}}
- **Trimestre/Bimestre:** {{trimestre}}
- **Tipo de Avaliação:** {{tipo_avaliacao}} (Diagnóstica / Formativa / Somativa / Simulado)
- **Habilidades BNCC a Avaliar:** {{habilidades_bncc}}
- **Conteúdos Trabalhados:** {{conteudos}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Número de Questões:** {{num_questoes}}
- **Valor Total:** {{valor_total}} pontos

## ESTRUTURA DE SAÍDA (JSON)

\`\`\`json
{
  "cabecalho": {
    "disciplina": "Sociologia",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "tipo_avaliacao": "{{tipo_avaliacao}}",
    "professor": "{{professor_nome}}",
    "data": "{{data}}",
    "valor_total": {{valor_total}},
    "tempo_estimado": "{{tempo_estimado}} minutos"
  },
  "matriz_referencia": [
    {
      "habilidade_bncc": "EM13CHS101",
      "descritor": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias sociológicas",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EM13CHS102",
      "descritor": "Identificar, analisar e discutir as circunstâncias históricas, geográficas, políticas, econômicas, sociais, ambientais e culturais de matrizes conceituais",
      "questoes_associadas": [3, 4]
    },
    {
      "habilidade_bncc": "EM13CHS103",
      "descritor": "Elaborar hipóteses, selecionar evidências e compor argumentos relativos a processos políticos, econômicos, sociais, ambientais, culturais e epistemológicos",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "Nas questões discursivas, fundamente sua resposta com conceitos e teorias sociológicas. Respostas sem fundamentação terão pontuação reduzida.",
    "A redação do texto dissertativo-argumentativo deve seguir a norma culta da língua portuguesa.",
    "Na análise de gráficos e tabelas, identifique a fonte, o período e as variáveis antes de responder.",
    "É permitida a consulta apenas ao caderno de anotações de aula. Não é permitido o uso de qualquer outro material de consulta.",
    "Citações de autores devem ser acompanhadas da referência à obra (título e, se possível, capítulo ou seção).",
    "Dados estatísticos citados na prova foram extraídos de fontes oficiais (IBGE, IPEA, etc.). Utilize-os como evidência em suas argumentações.",
    "Use caneta azul ou preta. Não é permitido o uso de corretivo líquido.",
    "Revise sua prova antes de entregar. Boa avaliação!"
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_1}},
      "habilidade_bncc": "EM13CHS101",
      "nivel_taxonomico": "Compreensão",
      "comando": "Leia o trecho a seguir e responda à questão.",
      "texto_base": "{{trecho_sociologico_confirmado_base_rag}}",
      "contexto": "Sociologia {{tradicao}} — {{autor}} — {{conceito_central}}",
      "enunciado": "Com base no trecho, é correto afirmar que o autor defende a ideia de que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 2,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_2}},
      "habilidade_bncc": "EM13CHS101",
      "nivel_taxonomico": "Análise",
      "comando": "Analise as afirmativas a seguir sobre {{tema_sociologico}}.",
      "contexto": "{{tradicao}} — {{conceito_central}} — Conexão com o presente",
      "enunciado": "Considerando o pensamento de {{autor}} sobre {{tema}}, assinale a alternativa correta:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 3,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_3}},
      "habilidade_bncc": "EM13CHS102",
      "nivel_taxonomico": "Aplicação",
      "comando": "Observe o gráfico a seguir sobre {{indicador_social}} e responda.",
      "imagem_grafico": "{{descricao_grafico_confirmado_base_rag}}",
      "fonte_dado": "{{fonte_confirmada_base_rag}}",
      "contexto": "Indicadores sociais — {{tema}} — Brasil contemporâneo",
      "enunciado": "A partir da análise do gráfico e considerando os conhecimentos sociológicos sobre {{tema}}, é correto afirmar que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 4,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_4}},
      "habilidade_bncc": "EM13CHS102",
      "nivel_taxonomico": "Análise",
      "comando": "Compare as duas perspectivas sociológicas apresentadas nos trechos a seguir.",
      "texto_base_1": "{{trecho_1_confirmado_base_rag}}",
      "texto_base_2": "{{trecho_2_confirmado_base_rag}}",
      "contexto": "{{autor_1}} × {{autor_2}} — {{tema_comparacao}}",
      "enunciado": "Os trechos revelam duas perspectivas sociológicas distintas sobre {{tema}}. Sobre essas abordagens, é correto afirmar que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 5,
      "tipo": "discursiva",
      "valor": {{valor_questao_5}},
      "habilidade_bncc": "EM13CHS103",
      "nivel_taxonomico": "Síntese/Avaliação",
      "comando": "Com base nos textos de apoio e em seus conhecimentos sociológicos, redija um texto dissertativo-argumentativo respondendo à questão proposta.",
      "textos_motivadores": [
        {
          "fonte": "{{fonte_1}}",
          "trecho": "{{texto_1_confirmado_base_rag}}"
        },
        {
          "fonte": "{{fonte_2}}",
          "dado": "{{dado_2_confirmado_base_rag}}"
        }
      ],
      "enunciado": "Considerando que {{contexto_problema}}, discuta como {{conceito_sociologico_1}} e {{conceito_sociologico_2}} podem contribuir para a compreensão desse fenômeno social. Em sua resposta: (a) defina os conceitos citados; (b) relacione-os com os textos motivadores; (c) apresente uma análise crítica fundamentada.",
      "criterios_correcao": [
        {"criterio": "Definição correta dos conceitos sociológicos", "pontuacao_maxima": {{pontos_criterio_1}}},
        {"criterio": "Articulação entre conceitos e textos motivadores", "pontuacao_maxima": {{pontos_criterio_2}}},
        {"criterio": "Argumentação crítica e fundamentada", "pontuacao_maxima": {{pontos_criterio_3}}},
        {"criterio": "Coerência, coesão e norma culta", "pontuacao_maxima": {{pontos_criterio_4}}},
        {"criterio": "Uso de evidências empíricas (dados, indicadores)", "pontuacao_maxima": {{pontos_criterio_5}}}
      ],
      "expectativa_resposta": "Espera-se que o(a) aluno(a) defina corretamente {{conceito_sociologico_1}} e {{conceito_sociologico_2}}, articulando-os com os textos motivadores e com o contexto brasileiro. Deve apresentar argumentos fundamentados que demonstrem compreensão das causas e consequências do fenômeno, utilizando dados ou exemplos concretos. A resposta deve evidenciar pensamento crítico e capacidade de relacionar teoria sociológica com realidade empírica."
    }
  ],
  "gabarito_comentado": {
    "questao_1": "{{letra_correta_q1}}. {{justificativa_detalhada_q1}}",
    "questao_2": "{{letra_correta_q2}}. {{justificativa_detalhada_q2}}",
    "questao_3": "{{letra_correta_q3}}. {{justificativa_detalhada_q3}}",
    "questao_4": "{{letra_correta_q4}}. {{justificativa_detalhada_q4}}",
    "questao_5": "Ver critérios de correção. {{expectativa_resposta_q5}}"
  },
  "tabela_pontuacao": {
    "distribuicao": [
      {"questao": 1, "tipo": "Múltipla escolha", "valor": {{valor_q1}}},
      {"questao": 2, "tipo": "Múltipla escolha", "valor": {{valor_q2}}},
      {"questao": 3, "tipo": "Múltipla escolha (gráfico)", "valor": {{valor_q3}}},
      {"questao": 4, "tipo": "Múltipla escolha (comparação)", "valor": {{valor_q4}}},
      {"questao": 5, "tipo": "Dissertativa", "valor": {{valor_q5}}}
    ],
    "nota_minima_aprovacao": "{{nota_corte}} pontos ({{percentual_corte}}%)"
  },
  "adaptacao_pdi": {
    "ampliacao_fonte": "Disponibilizar prova com fonte Arial 18 e espaçamento 1,5 para alunos com baixa visão",
    "tempo_adicional": "Acréscimo de 40% no tempo para alunos com dislexia, TDAH ou outras necessidades conforme plano individualizado",
    "ledor": "Disponibilizar ledor para alunos com deficiência visual ou dificuldades severas de leitura",
    "glossario": "Incluir glossário com definições dos principais conceitos sociológicos cobrados na prova",
    "simplificacao_enunciados": "Para alunos com deficiência intelectual: versão com enunciados simplificados e vocabulário controlado, mantendo os mesmos conceitos avaliados"
  }
}
\`\`\`
`,
  'planejamento-trimestral.md': `# Template de Prompt — Planejamento Trimestral (Sociologia)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Sociologia seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique \`[A DEFINIR]\` — NUNCA invente dados
sociológicos, estatísticas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Sociologia
- **Ano/Série:** {{ano_serie}}
- **Trimestre:** {{trimestre}} (1º, 2º ou 3º)
- **Ano Letivo:** {{ano_letivo}}
- **Carga Horária Semanal:** {{carga_horaria}} aulas de 50 min
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Calendário Escolar:** {{calendario_escolar}}

## ESTRUTURA DE SAÍDA (JSON)

\`\`\`json
{
  "cabecalho": {
    "disciplina": "Sociologia",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias sociológicas e de processos históricos, geográficos, políticos, econômicos, sociais, ambientais e culturais.",
      "fonte": "BNCC — Área de Ciências Humanas e Sociais Aplicadas"
    },
    {
      "codigo": "CE03",
      "descricao": "Analisar e avaliar criticamente as relações de diferentes grupos, povos e sociedades com a natureza (produção, distribuição e consumo) e seus impactos econômicos e socioambientais, com vistas à proposição de alternativas que respeitem e promovam a consciência, a ética socioambiental e o consumo responsável em âmbito local, regional, nacional e global.",
      "fonte": "BNCC — Área de Ciências Humanas e Sociais Aplicadas"
    },
    {
      "codigo": "CE05",
      "descricao": "Identificar e combater as diversas formas de injustiça, preconceito e violência, adotando princípios éticos, democráticos, inclusivos e solidários, e respeitando os Direitos Humanos.",
      "fonte": "BNCC — Área de Ciências Humanas e Sociais Aplicadas"
    }
  ],
  "eixos_estruturadores": [
    {
      "eixo": "Clássicos da Sociologia",
      "descricao": "Abordagem das três matrizes fundadoras do pensamento sociológico — Durkheim, Weber e Marx — contextualizando cada autor em seu tempo histórico e articulando com temas contemporâneos"
    },
    {
      "eixo": "Temas Sociológicos Contemporâneos",
      "descricao": "Abordagem temática transversal conectando conceitos sociológicos com problemas sociais brasileiros e globais do século XXI"
    },
    {
      "eixo": "Metodologia Científica",
      "descricao": "Desenvolvimento de habilidades de análise de indicadores sociais, leitura de gráficos e tabelas, interpretação de textos sociológicos e produção científica escolar"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "{{unidade_tematica_mes_1}}",
      "topico": "{{topico_mes_1}}",
      "tradicao_sociologica": "{{tradicao_mes_1}}",
      "habilidades_bncc": ["EM13CHS101", "EM13CHS102", "EM13CHS103"],
      "objetos_conhecimento": [
        "Contexto histórico-social do surgimento da Sociologia (século XIX, Revolução Industrial, Revolução Francesa)",
        "{{autor_principal_1}}: vida, obra e conceitos fundamentais ({{conceitos_autor_1}})",
        "{{autor_principal_2}}: vida, obra e conceitos fundamentais ({{conceitos_autor_2}})",
        "Conceitos sociológicos centrais: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
        "Diálogo com o presente: {{conexao_contemporanea_1}}",
        "Dados e indicadores: {{fonte_dados_confirmada_base_rag}}"
      ],
      "aulas_previstas": 12,
      "textos_e_dados_mes": [
        {
          "tipo": "trecho_teorico",
          "autor": "{{autor_principal_1}}",
          "obra": "{{obra_1}}",
          "trecho_sugerido": "{{trecho_1_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS101"
        },
        {
          "tipo": "dado_sociologico",
          "fonte": "{{fonte_confirmada_base_rag}}",
          "dado": "{{dado_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS102"
        }
      ],
      "atividades_sugeridas": [
        "Leitura analítica com ficha de identificação de tese e argumentos sociológicos",
        "Debate estruturado sobre {{tema_debate_1}}",
        "Análise orientada de gráfico/tabela de {{fonte_dados_1}}",
        "Produção de texto dissertativo-argumentativo (tema: {{tema_redacao_1}})",
        "Seminário em grupo sobre {{tema_seminario_1}}"
      ],
      "avaliacao_parcial": "Ficha de leitura analítica + participação em debate + análise de dados + texto dissertativo-argumentativo (peso 3)"
    },
    "mes_2": {
      "unidade_tematica": "{{unidade_tematica_mes_2}}",
      "topico": "{{topico_mes_2}}",
      "tradicao_sociologica": "{{tradicao_mes_2}}",
      "habilidades_bncc": ["EM13CHS104", "EM13CHS105", "EM13CHS106"],
      "objetos_conhecimento": [
        "{{topico_mes_2}}: conceituação e contextualização histórica",
        "{{autor_principal_3}}: vida, obra e conceitos fundamentais",
        "Conceitos sociológicos: {{conceito_4}}, {{conceito_5}}, {{conceito_6}}",
        "Dados e indicadores: {{fonte_dados_confirmada_base_rag_2}}",
        "Diálogo com o presente: {{conexao_contemporanea_2}}",
        "Conexão interdisciplinar: {{conexao_historia_geografia}}"
      ],
      "aulas_previstas": 12,
      "textos_e_dados_mes": [
        {
          "tipo": "trecho_teorico",
          "autor": "{{autor_principal_3}}",
          "obra": "{{obra_3}}",
          "trecho_sugerido": "{{trecho_3_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS104"
        }
      ],
      "atividades_sugeridas": [
        "Pesquisa sociológica escolar: {{tema_pesquisa_1}}",
        "Oficina de leitura e interpretação de gráficos e tabelas",
        "Debate regrado sobre {{tema_debate_2}}",
        "Produção de infográfico com dados sociológicos sobre {{tema_infografico}}",
        "Produção de texto dissertativo-argumentativo (tema: {{tema_redacao_2}})"
      ],
      "avaliacao_parcial": "Pesquisa sociológica + infográfico + participação em debate + texto dissertativo-argumentativo (peso 3)"
    },
    "mes_3": {
      "unidade_tematica": "{{unidade_tematica_mes_3}}",
      "topico": "{{topico_mes_3}}",
      "tradicao_sociologica": "{{tradicao_mes_3}}",
      "habilidades_bncc": ["EM13CHS201", "EM13CHS202", "EM13CHS203", "EM13CHS204"],
      "objetos_conhecimento": [
        "{{topico_mes_3}}: conceituação e contextualização contemporânea",
        "Teorias sociológicas contemporâneas sobre {{tema_contemporaneo}}",
        "Dados e indicadores atualizados: {{fonte_dados_confirmada_base_rag_3}}",
        "Conexão com o ENEM: {{tema_enem_relacionado}}",
        "Diálogo com o presente: {{conexao_contemporanea_3}}",
        "Síntese do trimestre: articulação dos conceitos trabalhados nos meses 1, 2 e 3"
      ],
      "aulas_previstas": 10,
      "textos_e_dados_mes": [
        {
          "tipo": "documento_sociologico",
          "fonte": "{{fonte_confirmada_base_rag_3}}",
          "descricao": "Relatório, documento ou texto contemporâneo sobre {{tema_contemporaneo}}",
          "habilidade_associada": "EM13CHS201"
        }
      ],
      "atividades_sugeridas": [
        "Simulado ENEM — Ciências Humanas (questões de Sociologia)",
        "Projeto de intervenção social: diagnóstico e proposta sobre {{problema_local}}",
        "Mostra sociológica: apresentação dos projetos de pesquisa desenvolvidos no trimestre",
        "Autoavaliação do trimestre com devolutiva coletiva"
      ],
      "avaliacao_parcial": "Simulado ENEM + projeto de intervenção + participação na mostra + autoavaliação (peso 4)"
    }
  },
  "avaliacao_trimestral": {
    "composicao": [
      {"instrumento": "Avaliações parciais (média dos 3 meses)", "peso": 6},
      {"instrumento": "Projeto de intervenção social", "peso": 2},
      {"instrumento": "Autoavaliação e participação", "peso": 2}
    ],
    "recuperacao_paralela": {
      "estrategia": "Roteiro de estudos dirigidos com leituras complementares e exercícios de análise de dados sociológicos",
      "reavaliacao": "Prova escrita com questões abertas e análise de indicadores sociais (substitui a menor nota parcial)"
    }
  },
  "conexao_enem": {
    "competencias_prioritarias": ["C1", "C3", "C5"],
    "temas_provaveis": [
      "Desigualdade social e estratificação",
      "Cidadania, direitos humanos e movimentos sociais",
      "Trabalho e sociedade no capitalismo contemporâneo",
      "Cultura, identidade e diversidade",
      "Violência e segurança pública no Brasil"
    ],
    "estrategia_preparacao": "Ao longo do trimestre, toda atividade de análise de dados e produção textual dialoga diretamente com o formato ENEM. Os simulados reproduzem as condições reais da prova (tempo, tipo de questão, matriz de referência)."
  },
  "adaptacao_pdi": {
    "principios": [
      "Flexibilização de prazos de entrega conforme necessidade individual",
      "Disponibilização de materiais em formatos acessíveis (áudio, braille, fonte ampliada)",
      "Glossário sociológico trimestral com definições simplificadas e exemplos visuais",
      "Mediação de leitura para alunos com dificuldades específicas",
      "Avaliação diferenciada conforme plano individualizado (mesmo conteúdo, formato adaptado)"
    ]
  },
  "recursos_materiais_trimestre": [
    "Livro didático PNLD ({{livro_pnld}})",
    "Trechos selecionados dos clássicos (Durkheim, Weber, Marx) — {{obras_selecionadas}}",
    "Bases de dados: IBGE (Censo, PNAD), IPEA, Datafolha, MEC/INEP (Censo Escolar, IDEB)",
    "Documentários e filmes: {{lista_filmes}}",
    "Infraestrutura: projetor multimídia, acesso à internet (laboratório de informática ou dispositivos móveis)"
  ]
}
\`\`\`
`,
  'plano-aula.md': `# Template de Prompt — Plano de Aula (Sociologia)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Sociologia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique \`[A DEFINIR]\` — NUNCA invente dados
sociológicos, estatísticas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Sociologia
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}

## ESTRUTURA DE SAÍDA (JSON)

\`\`\`json
{
  "cabecalho": {
    "disciplina": "Sociologia",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EM13CHS101",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias sociológicas..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender o conceito sociológico de {{conceito_sociologico}} e sua formulação por {{autor_principal}}...",
    "Analisar dados e indicadores sociais relacionados a {{tema}} identificando tendências e correlações...",
    "Relacionar o pensamento de {{autor_principal}} com problemas sociais contemporâneos como {{problema_contemporaneo}}...",
    "Produzir texto dissertativo-argumentativo aplicando conceitos sociológicos à análise de uma situação-problema..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição conceitual e contextualização histórica",
    "{{autor_principal}}: vida, obra e principais contribuições ao tema",
    "Conceitos-chave: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
    "Dados e indicadores: {{fonte_dados_confirmada_base_rag}}",
    "Desdobramentos contemporâneos: {{tema_no_seculo_xxi}}",
    "Conexões interdisciplinares: {{conexao_historia}}, {{conexao_geografia}}"
  ],
  "textos_e_dados": [
    {
      "tipo": "trecho_teorico",
      "autor": "{{autor_principal}}",
      "obra": "{{obra}}",
      "trecho_selecionado": "{{trecho_confirmado_na_base_rag}}",
      "orientacao_leitura": "Identifique a tese central do autor e os argumentos que a sustentam. Relacione com {{tema_da_aula}}."
    },
    {
      "tipo": "dado_sociologico",
      "fonte": "{{fonte_confirmada_base_rag}}",
      "dado": "{{dado_confirmado_base_rag}}",
      "orientacao_analise": "Interprete este indicador social considerando o contexto brasileiro. O que ele revela sobre {{tema_da_aula}}?"
    }
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora para engajar os alunos na reflexão sociológica...",
      "estrategia": "Pergunta provocadora / dilema social / charge ou tirinha / vídeo curto (3-5 min) / manchete de jornal / meme com conteúdo sociológico"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de leitura, análise de dados, debate e/ou produção textual...",
      "etapas": [
        {
          "titulo": "Leitura e Análise de Texto/Dados Sociológicos",
          "descricao": "Leitura compartilhada do trecho selecionado com mediação do professor, identificando conceitos-chave, tese e argumentos. Ou análise orientada de gráfico/tabela com indicadores sociais...",
          "recurso": "Trecho impresso/projetado de {{obra}} ou gráfico/tabela de {{fonte_dados}}"
        },
        {
          "titulo": "Problematização e Debate",
          "descricao": "Discussão estruturada em grupos sobre a aplicação do conceito a um problema social contemporâneo. Cada grupo formula uma posição fundamentada com argumentos sociológicos...",
          "recurso": "Roteiro de debate com perguntas orientadoras / quadro para registro dos argumentos"
        },
        {
          "titulo": "Produção Textual",
          "descricao": "Produção de parágrafo ou texto dissertativo-argumentativo aplicando o conceito estudado à análise de uma situação-problema fornecida pelo professor...",
          "recurso": "Folha de redação / caderno / ferramenta digital de escrita colaborativa"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Sistematização coletiva dos aprendizados, retomada da pergunta inicial e conexão com a próxima aula...",
      "estrategia": "Mapa conceitual colaborativo / ticket de saída com pergunta sociológica / síntese oral em dupla"
    }
  },
  "recursos_didaticos": [
    "Trecho impresso/projetado de {{obra}} ({{autor_principal}})",
    "Gráfico ou tabela com indicadores de {{fonte_dados_confirmada_base_rag}}",
    "Quadro branco e marcadores para mapa conceitual",
    "Projetor multimídia para {{recurso_visual}}",
    "Roteiro de debate com perguntas orientadoras"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação qualificada na discussão (uso de conceitos sociológicos)",
      "Capacidade de interpretar dados e indicadores sociais",
      "Qualidade da argumentação no texto dissertativo (tese, argumentos, evidências)",
      "Domínio dos conceitos sociológicos trabalhados na aula",
      "Capacidade de relacionar teoria sociológica com problemas contemporâneos"
    ],
    "instrumentos": [
      "Observação da participação no debate (registro em ficha)",
      "Texto dissertativo-argumentativo produzido em aula (correção por rubrica)",
      "Ticket de saída com autoavaliação"
    ]
  },
  "conexao_enem": {
    "competencia": "{{competencia_enem_principal}}",
    "habilidade": "{{habilidade_enem}}",
    "dica_enem": "No ENEM, temas como {{tema_enem_relacionado}} costumam aparecer articulados a conceitos de {{conceitos_chave}}. Fique atento(a) à leitura de gráficos e à interpretação de textos de autores clássicos como {{autores_classicos_enem}}."
  },
  "adaptacao_pdi": {
    "estrategias": [
      "Material impresso com fonte ampliada e espaçamento aumentado para alunos com baixa visão",
      "Glossário de conceitos sociológicos com definições simplificadas para alunos com dificuldades de aprendizagem",
      "Tempo adicional de 20% para produção textual para alunos com dislexia ou TDAH",
      "Leitura oral do texto-base para alunos com deficiência visual ou dificuldades de leitura"
    ]
  }
}
\`\`\`
`,
  'system-prompt-EM.md': `# System Prompt — Agent_Sociologia_EM (Durkheim — Ensino Médio)

Você é um Professor Especialista em Sociologia com 20 anos de experiência
no Ensino Médio da rede pública brasileira. Você domina a BNCC, o Currículo
Referência de Minas Gerais, as diretrizes do PNLD e as matrizes de referência
do ENEM para Ciências Humanas e Sociais Aplicadas, com ênfase em Sociologia.

## PERFIL DO AGENTE

- **Nome:** Durkheim (Émile Durkheim)
- **Especialidade:** Sociologia — Ensino Médio (1ª a 3ª série)
- **Formação:** Licenciatura Plena em Ciências Sociais, Mestrado em Ensino de Sociologia
- **Experiência:** 20 anos em sala de aula na rede pública, sendo 15 no Ensino Médio

## REGRAS INEGOCIÁVEIS

1. **PROIBIDO INVENTAR DADOS SOCIOLÓGICOS/ESTATÍSTICAS.** Toda estatística,
   indicador social, taxa, percentual, dado censitário ou dado de pesquisa
   sociológica citado DEVE estar confirmado na base documental fornecida no
   contexto RAG. Se não encontrar o dado exato na base, NUNCA preencha de
   memória — use apenas o que estiver confirmado. Prefira indicar
   \`[DADO SOCIOLÓGICO NÃO LOCALIZADO NA BASE RAG]\` a arriscar um número
   impreciso. Esta regra aplica-se a: dados do IBGE, IPEA, PNAD, Datafolha,
   OMS, UNESCO, MEC/INEP, e quaisquer outras fontes de dados sociais.
2. **PROIBIDO INVENTAR CÓDIGOS DA BNCC.** Todo código de habilidade citado DEVE
   existir na base documental fornecida no contexto RAG. Se não encontrar o código
   exato, use apenas os códigos confirmados na base.
3. **PRIORIDADE ABSOLUTA AO PLANO DE CURSO DO PROFESSOR.** Se o plano de curso
   estiver disponível no contexto, ele é a fonte primária. A BNCC é referência
   secundária para preenchimento de lacunas.
4. **LINGUAGEM TÉCNICO-ACESSÍVEL.** Use linguagem adequada a jovens de 15 a 17
   anos. Introduza conceitos sociológicos com definições claras, exemplos do
   cotidiano e conexões com a cultura juvenil (filmes, séries, músicas, redes
   sociais, games). Mantenha o rigor conceitual sem sacrificar a clareza.
5. **FOCO NO ENEM E VESTIBULARES.** Todo conteúdo deve dialogar com as competências
   e habilidades cobradas no ENEM (Ciências Humanas e Sociais Aplicadas) e nos
   principais vestibulares de Minas Gerais. Priorize a análise de indicadores
   sociais, a interpretação de gráficos e tabelas, a compreensão de processos
   sociais e a relação entre conceitos sociológicos e problemas contemporâneos.
6. **ÊNFASE NO PENSAMENTO CRÍTICO E NA IMAGINAÇÃO SOCIOLÓGICA.** A Sociologia
   no Ensino Médio não é mera erudição teórica — é uma prática de
   desnaturalização do social. Todo conteúdo deve incluir momentos de
   problematização, exercício do estranhamento sociológico, debate estruturado
   e produção textual argumentativa. Estimule a imaginação sociológica
   (C. Wright Mills): conectar biografia individual com processos históricos
   e estruturas sociais.

## ABORDAGEM PEDAGÓGICA

### Competências do ENEM (Ciências Humanas e Sociais Aplicadas)

- **Competência de área 1 (C1):** Compreender os elementos culturais que
  constituem as identidades.
- **Competência de área 2 (C2):** Compreender as transformações dos espaços
  geográficos como produto das relações socioeconômicas e culturais de poder.
- **Competência de área 3 (C3):** Compreender a produção e o papel histórico das
  instituições sociais, políticas e econômicas, associando-as aos diferentes
  grupos, conflitos e movimentos sociais.
- **Competência de área 4 (C4):** Entender as transformações técnicas e
  tecnológicas e seu impacto nos processos de produção, no desenvolvimento do
  conhecimento e na vida social.
- **Competência de área 5 (C5):** Utilizar os conhecimentos históricos para
  compreender e valorizar os fundamentos da cidadania e da democracia,
  favorecendo uma atuação consciente do indivíduo na sociedade.
- **Competência de área 6 (C6):** Compreender a sociedade e a natureza,
  reconhecendo suas interações no espaço em diferentes contextos históricos
  e geográficos.

### Unidades Temáticas (BNCC — EM — Ciências Humanas e Sociais Aplicadas)

- **Tempo e Espaço:** Processos de formação e transformação das sociedades,
  periodização sociológica (modernidade, pós-modernidade, globalização),
  temporalidades sociais, mudança social e tradição, a Sociologia como
  ciência (ruptura com o senso comum, método sociológico).
- **Territórios e Fronteiras:** Identidade e alteridade (Eu-Outro),
  etnocentrismo e relativismo cultural, multiculturalismo, fluxos migratórios
  e diásporas, segregação socioespacial, fronteiras simbólicas e estigmas
  sociais, globalização e desterritorialização.
- **Indivíduo, Natureza e Cultura:** Processo de socialização (primária e
  secundária), instituições sociais (família, escola, igreja, mídia, Estado),
  controle social e desvio, natureza e cultura no pensamento sociológico,
  construção social da realidade (Berger e Luckmann), interação social e
  papeis sociais (Goffman), habitus e campo (Bourdieu).
- **Política, Ética e Cidadania:** Estado moderno e formação da cidadania
  (Marshall), tipos de dominação (Weber), democracia representativa e
  participativa, movimentos sociais (clássicos e contemporâneos), direitos
  humanos e políticas afirmativas, violência e segurança pública no Brasil,
  cidadania digital e redes sociais.
- **Relações de Poder e Trabalho:** Estratificação social (classes, castas,
  estamentos), desigualdade social no Brasil (indicadores, causas, políticas),
  trabalho e sociedade (divisão social do trabalho — Durkheim; alienação —
  Marx; ética protestante — Weber), mundo do trabalho contemporâneo
  (precarização, uberização, trabalho digital), relações de gênero e
  divisão sexual do trabalho, raça e racismo estrutural no Brasil.
- **Cultura, Identidade e Diversidade:** Cultura e sociedade (relativismo
  cultural, etnocentrismo), indústria cultural (Escola de Frankfurt),
  cultura de massa e cultura popular, identidade nacional e mitos fundadores,
  gênero e sexualidade como construções sociais, questões étnico-raciais
  no Brasil, juventudes e culturas juvenis, mídias digitais e sociabilidade.

### Eixos Estruturadores do Ensino de Sociologia

- **Eixo 1 — Clássicos da Sociologia:** Durkheim (fato social, solidariedade
  mecânica/orgânica, suicídio), Weber (ação social, tipos ideais, ética
  protestante, desencantamento do mundo), Marx (materialismo histórico,
  luta de classes, alienação, mais-valia). Leitura de trechos selecionados
  dos clássicos em tradução acessível.
- **Eixo 2 — Temas Sociológicos Contemporâneos:** Desigualdades (classe,
  raça, gênero, território), violências, juventudes, movimentos sociais,
  trabalho e tecnologia, meio ambiente e sociedade de risco, consumo e
  identidade, democracia e autoritarismo, pandemia e sociedade.
- **Eixo 3 — Metodologia Científica:** A Sociologia como ciência, métodos
  de pesquisa (quantitativo, qualitativo, misto), análise de indicadores
  sociais, leitura e interpretação de gráficos e tabelas, pesquisa
  sociológica escolar (observação, entrevista, questionário).

### Habilidades ENEM Específicas — Foco Sociologia

- **Leitura e interpretação de textos sociológicos:** Identificar tese,
  argumentos e pressupostos teóricos. Diferenciar conceitos de diferentes
  tradições (funcionalismo, marxismo, weberianismo, interacionismo simbólico).
- **Análise de gráficos, tabelas e indicadores sociais:** Interpretar dados
  do IBGE, IPEA, PNAD, Datafolha e outras fontes. Extrair tendências,
  correlações e implicações sociais.
- **Problematização da realidade social:** Desnaturalizar fenômenos sociais
  aparentemente óbvios. Exercitar o estranhamento sociológico diante de
  situações cotidianas.
- **Produção textual argumentativa:** Elaborar textos dissertativos que
  articulem conceitos sociológicos com dados empíricos e análise crítica.
- **Conexão interdisciplinar:** Articular conhecimentos de Sociologia com
  História, Geografia, Filosofia, Biologia e Linguagens.

## TOM E ESTILO

- Linguagem dialógica que aproxima o jovem do pensamento sociológico sem
  infantilizar o conteúdo.
- Uso de exemplos do cotidiano juvenil: redes sociais, cultura pop, esportes,
  games, música, cinema, séries.
- Perguntas provocadoras que estimulam a reflexão e o debate.
- Valorização da diversidade de experiências dos alunos (território, classe,
  raça, gênero, orientação sexual, religião, deficiência).
- Rigor metodológico na apresentação de dados: sempre citar fonte, ano, base
  amostral e ressalvas metodológicas quando aplicável.
`,
};
