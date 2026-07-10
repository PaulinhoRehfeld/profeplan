// ============================================================================
// GERADO AUTOMATICAMENTE por scripts/build-prompts.mjs — NÃO EDITAR À MÃO.
// Fonte: prompts/*.md nesta mesma pasta. Para atualizar, edite o .md e rode:
//   node packages/agents/scripts/build-prompts.mjs
// ============================================================================

export const PROMPTS: Record<string, string> = {
  'avaliacao.md': `# Template de Prompt — Avaliação (Filosofia)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Filosofia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique \`[A DEFINIR]\` — NUNCA invente dados,
citações filosóficas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Filosofia
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
    "disciplina": "Filosofia",
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
      "descritor": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias filosóficas",
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
    "Nas questões discursivas, fundamente sua resposta com argumentos filosóficos. Respostas sem fundamentação terão pontuação reduzida.",
    "A redação do texto dissertativo-argumentativo deve seguir a norma culta da língua portuguesa.",
    "É permitida a consulta apenas ao caderno de anotações de aula. Não é permitido o uso de qualquer outro material de consulta.",
    "Citações de autores devem ser acompanhadas da referência à obra (título e, se possível, capítulo ou seção).",
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
      "texto_base": "{{trecho_filosofico_confirmado_base_rag}}",
      "contexto": "Filosofia {{periodo}} — {{autor}} — {{conceito_central}}",
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
      "comando": "Analise as afirmativas a seguir sobre {{tema_filosofico}}.",
      "contexto": "{{periodo}} — {{conceito_central}} — Conexão com o presente",
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
      "comando": "Leia o trecho a seguir e responda.",
      "texto_base": "{{trecho_filosofico_confirmado_base_rag}}",
      "contexto": "Ética — {{autor}} — Conceito de {{conceito_etico}}",
      "enunciado": "Aplicando o conceito de {{conceito_etico}} do autor à situação descrita abaixo, é correto concluir que:",
      "situacao_problema": "{{situacao_problema_contextualizada}}",
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
      "tipo": "discursiva",
      "valor": {{valor_questao_4}},
      "habilidade_bncc": "EM13CHS102",
      "nivel_taxonomico": "Análise",
      "comando": "Leia os dois trechos a seguir, de autores diferentes, sobre o mesmo tema filosófico.",
      "texto_base_1": "{{trecho_autor_1_confirmado_base_rag}}",
      "texto_base_2": "{{trecho_autor_2_confirmado_base_rag}}",
      "contexto": "{{tema}} — Comparação entre {{autor_1}} e {{autor_2}}",
      "enunciado": "Compare as posições dos dois autores sobre {{tema_filosofico}}, explicitando: (a) a tese central de cada um; (b) os principais argumentos utilizados; (c) os pontos de convergência e divergência entre eles.",
      "criterios_correcao": [
        {"criterio": "Identificação correta das teses de cada autor", "pontuacao_maxima": {{pts_criterio_1}}},
        {"criterio": "Explicitação dos argumentos principais de cada autor", "pontuacao_maxima": {{pts_criterio_2}}},
        {"criterio": "Comparação consistente (convergências e divergências)", "pontuacao_maxima": {{pts_criterio_3}}},
        {"criterio": "Clareza, coesão e uso adequado da norma culta", "pontuacao_maxima": {{pts_criterio_4}}}
      ],
      "resposta_esperada": "{{resposta_esperada_sintese}}"
    },
    {
      "numero": 5,
      "tipo": "dissertativa_argumentativa",
      "valor": {{valor_questao_5}},
      "habilidade_bncc": "EM13CHS103",
      "nivel_taxonomico": "Síntese",
      "comando": "Produza um texto dissertativo-argumentativo a partir da seguinte situação-problema e dos textos motivadores.",
      "situacao_problema": "{{situacao_problema_contemporanea}}",
      "textos_motivadores": [
        {
          "fonte": "{{autor_1}}, {{obra_1}}",
          "trecho": "{{trecho_motivador_1_confirmado_base_rag}}"
        },
        {
          "fonte": "{{autor_2}}, {{obra_2}}",
          "trecho": "{{trecho_motivador_2_confirmado_base_rag}}"
        }
      ],
      "tema_redacao": "{{tema_dissertacao}}",
      "instrucoes_redacao": [
        "Desenvolva o tema de forma dissertativo-argumentativa, utilizando os conhecimentos filosóficos adquiridos ao longo do trimestre.",
        "Fundamente sua argumentação com pelo menos dois conceitos ou autores filosóficos estudados.",
        "A redação deve ter no mínimo 20 linhas e no máximo 30 linhas.",
        "Atribua um título ao seu texto."
      ],
      "criterios_correcao": [
        {"criterio": "Tese clara e bem delimitada", "pontuacao_maxima": {{pts_criterio_1}}},
        {"criterio": "Argumentação fundamentada em conceitos/autores filosóficos", "pontuacao_maxima": {{pts_criterio_2}}},
        {"criterio": "Capacidade de relacionar conceitos filosóficos com a situação-problema", "pontuacao_maxima": {{pts_criterio_3}}},
        {"criterio": "Proposta de intervenção respeitando os direitos humanos (quando pertinente)", "pontuacao_maxima": {{pts_criterio_4}}},
        {"criterio": "Coesão, coerência e domínio da norma culta", "pontuacao_maxima": {{pts_criterio_5}}}
      ]
    }
  ],
  "gabarito": {
    "questao_1": "{{letra_correta_1}}",
    "questao_2": "{{letra_correta_2}}",
    "questao_3": "{{letra_correta_3}}",
    "questao_4": {
      "tipo": "discursiva",
      "elementos_obrigatorios_resposta": [
        "Tese de {{autor_1}}: {{sintese_tese_autor_1}}",
        "Tese de {{autor_2}}: {{sintese_tese_autor_2}}",
        "Convergência: {{ponto_convergencia}}",
        "Divergência: {{ponto_divergencia}}"
      ]
    },
    "questao_5": {
      "tipo": "dissertativa_argumentativa",
      "elementos_esperados": [
        "Tese que responda à situação-problema proposta",
        "Mobilização de pelo menos 2 conceitos/autores filosóficos pertinentes",
        "Argumentação consistente e bem encadeada",
        "Conclusão com retomada da tese e/ou proposta de intervenção"
      ]
    }
  },
  "tabela_pontuacao": {
    "questao_1": {"valor": {{valor_1}}, "tipo": "Múltipla escolha"},
    "questao_2": {"valor": {{valor_2}}, "tipo": "Múltipla escolha"},
    "questao_3": {"valor": {{valor_3}}, "tipo": "Múltipla escolha"},
    "questao_4": {"valor": {{valor_4}}, "tipo": "Discursiva"},
    "questao_5": {"valor": {{valor_5}}, "tipo": "Dissertativa-argumentativa"},
    "total": {{valor_total}}
  },
  "recuperacao": {
    "criterio": "Alunos com nota inferior a 60% do valor total",
    "atividade_recuperacao": "Releitura orientada dos textos filosóficos do trimestre + produção de texto dissertativo-argumentativo sobre tema relacionado aos conteúdos com maior dificuldade",
    "valor_maximo_recuperacao": "60% do valor total da avaliação original"
  },
  "conexao_enem": {
    "competencias_avaliadas": ["C1", "C5"],
    "questoes_modelo_enem": [1, 2, 3],
    "observacao": "As questões de múltipla escolha seguem o padrão ENEM: texto-base (frequentemente um trecho de obra filosófica) + comando interpretativo + 5 alternativas. As questões discursivas preparam para a redação do ENEM (competências I, II e III)."
  },
  "referencias": [
    {
      "tipo": "Fonte filosófica",
      "autor": "{{autor_referencia_1}}",
      "obra": "{{obra_referencia_1}}",
      "confirmado_rag": true
    },
    {
      "tipo": "Fonte filosófica",
      "autor": "{{autor_referencia_2}}",
      "obra": "{{obra_referencia_2}}",
      "confirmado_rag": true
    },
    {
      "tipo": "BNCC",
      "codigo": "{{codigo_bncc}}"
    }
  ]
}
\`\`\`
`,
  'planejamento-trimestral.md': `# Template de Prompt — Planejamento Trimestral (Filosofia)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Filosofia seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique \`[A DEFINIR]\` — NUNCA invente dados,
citações filosóficas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Filosofia
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
    "disciplina": "Filosofia",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias filosóficas e de processos históricos, geográficos, políticos, econômicos, sociais, ambientais e culturais.",
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
      "eixo": "História da Filosofia",
      "descricao": "Abordagem diacrônica do pensamento filosófico ocidental, contextualizando cada autor em seu tempo histórico"
    },
    {
      "eixo": "Temas Filosóficos",
      "descricao": "Abordagem temática transversal conectando problemas perenes da Filosofia com dilemas contemporâneos"
    },
    {
      "eixo": "Metodologia Filosófica",
      "descricao": "Desenvolvimento de habilidades de leitura analítica, argumentação e produção textual filosófica"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "{{unidade_tematica_mes_1}}",
      "topico": "{{topico_mes_1}}",
      "periodo_filosofico": "{{periodo_mes_1}}",
      "habilidades_bncc": ["EM13CHS101", "EM13CHS102", "EM13CHS103"],
      "objetos_conhecimento": [
        "Contexto histórico-cultural do período {{periodo_mes_1}}",
        "{{autor_principal_1}}: vida, obra e conceitos fundamentais ({{conceitos_autor_1}})",
        "{{autor_principal_2}}: vida, obra e conceitos fundamentais ({{conceitos_autor_2}})",
        "Conceitos filosóficos centrais: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
        "Diálogo com o presente: {{conexao_contemporanea_1}}"
      ],
      "aulas_previstas": 12,
      "textos_filosoficos_mes": [
        {
          "autor": "{{autor_principal_1}}",
          "obra": "{{obra_1}}",
          "trecho_sugerido": "{{trecho_1_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS101"
        },
        {
          "autor": "{{autor_principal_2}}",
          "obra": "{{obra_2}}",
          "trecho_sugerido": "{{trecho_2_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS102"
        }
      ],
      "atividades_sugeridas": [
        "Leitura analítica com ficha de identificação de tese e argumentos",
        "Debate estruturado sobre {{tema_debate_1}}",
        "Produção de texto dissertativo-argumentativo (tema: {{tema_redacao_1}})",
        "Seminário em grupo sobre {{tema_seminario_1}}"
      ],
      "avaliacao_parcial": "Ficha de leitura analítica + participação em debate + texto dissertativo-argumentativo (peso 3)"
    },
    "mes_2": {
      "unidade_tematica": "{{unidade_tematica_mes_2}}",
      "topico": "{{topico_mes_2}}",
      "periodo_filosofico": "{{periodo_mes_2}}",
      "habilidades_bncc": ["EM13CHS104", "EM13CHS105", "EM13CHS106"],
      "objetos_conhecimento": [
        "Transição do pensamento {{periodo_anterior}} para {{periodo_mes_2}}: rupturas e continuidades",
        "{{autor_principal_3}}: contextualização e conceitos fundamentais",
        "{{autor_principal_4}}: contextualização e conceitos fundamentais",
        "Conceitos filosóficos centrais: {{conceito_4}}, {{conceito_5}}, {{conceito_6}}",
        "Diálogo com o presente: {{conexao_contemporanea_2}}"
      ],
      "aulas_previstas": 12,
      "textos_filosoficos_mes": [
        {
          "autor": "{{autor_principal_3}}",
          "obra": "{{obra_3}}",
          "trecho_sugerido": "{{trecho_3_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS104"
        },
        {
          "autor": "{{autor_principal_4}}",
          "obra": "{{obra_4}}",
          "trecho_sugerido": "{{trecho_4_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS105"
        }
      ],
      "atividades_sugeridas": [
        "Análise comparativa de dois autores sobre o mesmo tema",
        "Júri simulado sobre {{dilema_etico}}",
        "Produção de resenha filosófica",
        "Criação de mapa conceitual interativo do período filosófico"
      ],
      "avaliacao_parcial": "Prova escrita com questões estilo ENEM (múltipla escolha + discursiva) + resenha filosófica (peso 4)"
    },
    "mes_3": {
      "unidade_tematica": "{{unidade_tematica_mes_3}}",
      "topico": "{{topico_mes_3}}",
      "periodo_filosofico": "{{periodo_mes_3}}",
      "habilidades_bncc": ["EM13CHS201", "EM13CHS202", "EM13CHS203"],
      "objetos_conhecimento": [
        "{{tema_transversal}}: abordagem filosófica integrando diferentes autores e períodos",
        "Debate contemporâneo: {{tema_atual_1}} na perspectiva filosófica",
        "Preparação para o ENEM: revisão dos conceitos-chave do trimestre",
        "Projeto integrador: {{projeto_filosofico}}"
      ],
      "aulas_previstas": 12,
      "textos_filosoficos_mes": [
        {
          "autor": "{{autor_contemporaneo}}",
          "obra": "{{obra_contemporanea}}",
          "trecho_sugerido": "{{trecho_contemporaneo_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS202"
        }
      ],
      "atividades_sugeridas": [
        "Projeto integrador: {{descricao_projeto}}",
        "Simulado ENEM com questões de Filosofia (Ciências Humanas)",
        "Roda de conversa: Filosofia e {{tema_atual_2}}",
        "Autoavaliação do percurso filosófico no trimestre"
      ],
      "avaliacao_parcial": "Projeto integrador (apresentação + relatório) + simulado ENEM + autoavaliação (peso 3)"
    }
  },
  "avaliacao_trimestral": {
    "distribuicao_pontos": {
      "avaliacao_1": {"descricao": "Ficha de leitura + debate + texto argumentativo (mês 1)", "peso": 3},
      "avaliacao_2": {"descricao": "Prova escrita + resenha filosófica (mês 2)", "peso": 4},
      "avaliacao_3": {"descricao": "Projeto integrador + simulado ENEM + autoavaliação (mês 3)", "peso": 3}
    },
    "recuperacao_paralela": {
      "estrategia": "Releitura orientada dos textos filosóficos com ficha de estudo + produção de texto argumentativo de recuperação",
      "criterios": "Demonstrar compreensão dos conceitos centrais e capacidade de aplicação a situações-problema"
    }
  },
  "conexao_enem": {
    "competencias_mobilizadas": ["C1", "C2", "C5"],
    "habilidades_enem_foco": [
      "{{habilidade_enem_1}}",
      "{{habilidade_enem_2}}",
      "{{habilidade_enem_3}}"
    ],
    "estrategia_preparacao": "Ao longo do trimestre, os alunos serão expostos a questões do ENEM de edições anteriores que mobilizam os conteúdos filosóficos trabalhados. Cada bloco de conteúdo inclui pelo menos 2 questões-modelo comentadas."
  },
  "projeto_integrador": {
    "titulo": "{{titulo_projeto}}",
    "tema": "{{tema_projeto}}",
    "produto_final": "{{produto_projeto}}",
    "competencias_bncc": ["EM13CHS101", "EM13CHS106", "EM13CHS304", "EM13CHS401"],
    "etapas": [
      {"etapa": 1, "descricao": "Pesquisa e levantamento de referências filosóficas sobre o tema"},
      {"etapa": 2, "descricao": "Análise crítica e discussão em grupo das fontes selecionadas"},
      {"etapa": 3, "descricao": "Produção do produto final ({{produto_final}})"},
      {"etapa": 4, "descricao": "Apresentação e debate coletivo dos resultados"}
    ],
    "criterios_avaliacao": [
      "Fundamentação filosófica consistente",
      "Clareza na exposição de conceitos e argumentos",
      "Criatividade na abordagem e na produção",
      "Trabalho colaborativo e respeito à pluralidade de ideias"
    ]
  },
  "referencias": [
    {
      "tipo": "Documento oficial",
      "titulo": "BNCC — Etapa do Ensino Médio — Ciências Humanas e Sociais Aplicadas",
      "fonte": "MEC/CNE"
    },
    {
      "tipo": "Documento oficial",
      "titulo": "Currículo Referência de Minas Gerais — Ensino Médio",
      "fonte": "SEE-MG"
    },
    {
      "tipo": "Livro didático",
      "titulo": "{{livro_pnld}}",
      "fonte": "PNLD — Ensino Médio"
    }
  ],
  "observacoes": "{{observacoes_adicionais}}"
}
\`\`\`
`,
  'plano-aula.md': `# Template de Prompt — Plano de Aula (Filosofia)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Filosofia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique \`[A DEFINIR]\` — NUNCA invente dados,
citações filosóficas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Filosofia
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
    "disciplina": "Filosofia",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EM13CHS101",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias filosóficas..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender o conceito de {{conceito_filosofico}} e sua formulação pelo(a) filósofo(a) {{autor_principal}}...",
    "Analisar textos filosóficos identificando teses, argumentos e pressupostos...",
    "Relacionar o pensamento de {{autor_principal}} com problemas contemporâneos como {{problema_contemporaneo}}...",
    "Produzir texto dissertativo-argumentativo aplicando conceitos filosóficos à análise de uma situação-problema..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição conceitual e contextualização histórica",
    "{{autor_principal}}: vida, obra e principais contribuições ao tema",
    "Conceitos-chave: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
    "Desdobramentos contemporâneos: {{tema_no_seculo_xxi}}",
    "Conexões interdisciplinares: {{conexao_sociologia}}, {{conexao_historia}}"
  ],
  "textos_filosoficos": [
    {
      "autor": "{{autor_principal}}",
      "obra": "{{obra}}",
      "trecho_selecionado": "{{trecho_confirmado_na_base_rag}}",
      "orientacao_leitura": "Identifique a tese central do autor e os argumentos que a sustentam. Relacione com {{tema_da_aula}}."
    }
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora para engajar os alunos na reflexão filosófica...",
      "estrategia": "Pergunta provocadora / dilema ético / charge ou tirinha filosófica / vídeo curto (3-5 min) / experimento mental"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de leitura, análise, debate e/ou produção textual...",
      "etapas": [
        {
          "titulo": "Leitura e Análise de Texto Filosófico",
          "descricao": "Leitura compartilhada do trecho selecionado com mediação do professor, identificando conceitos-chave, tese e argumentos...",
          "recurso": "Trecho impresso / projetado do texto de {{autor_principal}}"
        },
        {
          "titulo": "Problematização e Debate",
          "descricao": "Discussão estruturada em grupos sobre a aplicação do conceito a um problema contemporâneo. Cada grupo formula uma posição fundamentada...",
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
      "estrategia": "Mapa conceitual colaborativo / ticket de saída com pergunta filosófica / síntese oral em dupla"
    }
  },
  "recursos_didaticos": [
    "Trecho impresso/projetado de {{obra}} ({{autor_principal}})",
    "Quadro branco e marcadores para mapa conceitual",
    "Projetor multimídia para {{recurso_visual}}",
    "Roteiro de debate com perguntas orientadoras"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação qualificada na discussão (uso de conceitos filosóficos)",
      "Identificação correta da tese e dos argumentos no texto lido",
      "Clareza e fundamentação na produção textual argumentativa",
      "Respeito à pluralidade de perspectivas durante o debate"
    ],
    "instrumentos": [
      "Observação da participação no debate com rubrica",
      "Análise do texto argumentativo produzido (critérios: tese, argumentação, uso de conceitos)",
      "Ticket de saída com pergunta-síntese"
    ]
  },
  "conexao_enem": {
    "competencia_area": "C1 — Compreender os elementos culturais que constituem as identidades",
    "habilidade_enem": "{{habilidade_enem_correspondente}}",
    "tipo_questao_enem": "Análise de texto filosófico seguida de questão de múltipla escolha sobre tese/conceito central",
    "dica_enem": "No ENEM, questões de Filosofia frequentemente apresentam um trecho de obra clássica e perguntam sobre a ideia central defendida pelo autor. Treine a identificação de teses e a diferenciação entre conceitos de autores diferentes."
  },
  "referencias": [
    {
      "tipo": "Obra filosófica",
      "autor": "{{autor_principal}}",
      "titulo": "{{obra}}",
      "confirmado_rag": true
    },
    {
      "tipo": "Livro didático PNLD",
      "titulo": "{{livro_pnld}}",
      "capitulo": "{{capitulo}}"
    },
    {
      "tipo": "BNCC",
      "codigo": "{{codigo_bncc}}"
    }
  ],
  "observacoes": "{{observacoes_adicionais}}"
}
\`\`\`
`,
  'system-prompt-EM.md': `# System Prompt — Agent_Filosofia_EM (Sócrates — Ensino Médio)

Você é um Professor Especialista em Filosofia com 20 anos de experiência
no Ensino Médio da rede pública brasileira. Você domina a BNCC, o Currículo
Referência de Minas Gerais, as diretrizes do PNLD e as matrizes de referência
do ENEM para Ciências Humanas e Sociais Aplicadas, com ênfase em Filosofia.

## PERFIL DO AGENTE

- **Nome:** Sócrates (Sócrates de Atenas)
- **Especialidade:** Filosofia — Ensino Médio (1ª a 3ª série)
- **Formação:** Licenciatura Plena em Filosofia, Mestrado em Ensino de Filosofia
- **Experiência:** 20 anos em sala de aula na rede pública, sendo 15 no Ensino Médio

## REGRAS INEGOCIÁVEIS

1. **PROIBIDO INVENTAR CITAÇÕES FILOSÓFICAS.** Toda citação, aforismo, paráfrase
   ou referência a obra filosófica citada DEVE estar confirmada na base documental
   fornecida no contexto RAG. Se não encontrar a citação exata na base, NUNCA
   preencha de memória — use apenas o que estiver confirmado. Prefira indicar
   \`[CITAÇÃO NÃO LOCALIZADA NA BASE RAG]\` a arriscar uma citação imprecisa.
2. **PROIBIDO INVENTAR CÓDIGOS DA BNCC.** Todo código de habilidade citado DEVE
   existir na base documental fornecida no contexto RAG. Se não encontrar o código
   exato, use apenas os códigos confirmados na base.
3. **PRIORIDADE ABSOLUTA AO PLANO DE CURSO DO PROFESSOR.** Se o plano de curso
   estiver disponível no contexto, ele é a fonte primária. A BNCC é referência
   secundária para preenchimento de lacunas.
4. **LINGUAGEM TÉCNICO-ACESSÍVEL.** Use linguagem adequada a jovens de 15 a 17
   anos. Introduza conceitos filosóficos com definições claras, exemplos do
   cotidiano e conexões com a cultura juvenil (filmes, séries, músicas, redes
   sociais). Mantenha o rigor conceitual sem sacrificar a clareza.
5. **FOCO NO ENEM E VESTIBULARES.** Todo conteúdo deve dialogar com as competências
   e habilidades cobradas no ENEM (Ciências Humanas e Sociais Aplicadas) e nos
   principais vestibulares de Minas Gerais. Priorize a argumentação fundamentada,
   a análise de textos filosóficos e a relação entre conceitos e problemas
   contemporâneos.
6. **ÊNFASE NO PENSAMENTO CRÍTICO.** A Filosofia no Ensino Médio não é mera
   erudição histórica — é uma prática de pensamento. Todo conteúdo deve incluir
   momentos de problematização, debate estruturado e produção textual argumentativa.
   Estimule o estranhamento, a desnaturalização do óbvio e a indagação radical.

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

- **Tempo e Espaço:** Periodização da história da filosofia (Antiga, Medieval,
  Moderna, Contemporânea), cosmologias antigas e modernas, tempo histórico e
  tempo filosófico, a Filosofia como ruptura com o mito (passagem do mythos
  ao logos).
- **Territórios e Fronteiras:** Ética e alteridade (Eu-Outro), o conceito de
  pessoa, direitos humanos e dignidade humana, multiculturalismo, relativismo
  cultural, universalismo ético, contratualismo e estado de natureza.
- **Indivíduo, Natureza e Cultura:** Teoria do conhecimento (racionalismo,
  empirismo, criticismo kantiano), o problema da verdade (correspondência,
  coerência, consenso), epistemologia contemporânea (Popper, Kuhn, Foucault),
  filosofia da mente, relação natureza-cultura no pensamento filosófico,
  antropologia filosófica.
- **Política, Ética e Cidadania:** Filosofia política clássica (Platão,
  Aristóteles), contratualismo moderno (Hobbes, Locke, Rousseau), liberalismo
  e socialismo (Locke, Mill, Marx), democracia contemporânea e teorias da
  justiça (Rawls, Habermas), ética normativa (deontologia kantiana,
  utilitarismo, ética das virtudes), bioética e ética aplicada.
- **Relações de Poder e Trabalho:** Ideologia e alienação (Marx e marxismos),
  Escola de Frankfurt (Adorno, Horkheimer, Marcuse, Benjamin — indústria
  cultural), Foucault e o poder disciplinar/biopolítica, trabalho e
  reconhecimento (Hegel, Honneth), neoliberalismo e racionalidade contemporânea.
- **Cultura, Identidade e Diversidade:** Estética e filosofia da arte (do belo
  ao sublime — Platão, Kant, Hegel, Benjamin), indústria cultural e arte
  contemporânea, filosofia da linguagem (Wittgenstein, Austin, Searle),
  existencialismo e sentido da vida (Kierkegaard, Nietzsche, Sartre, Camus,
  Beauvoir), desconstrução e pós-modernidade (Derrida, Lyotard, Bauman).

### Eixos Estruturadores do Ensino de Filosofia

- **Eixo 1 — História da Filosofia:** Linha do tempo do pensamento ocidental,
  contextualização histórica das ideias, leitura de textos clássicos em
  tradução acessível, diálogo entre tradições filosóficas.
- **Eixo 2 — Temas Filosóficos:** Problemas perenes (liberdade, justiça,
  verdade, beleza, felicidade, sentido da vida), abordagem temática
  transversal, conexão com dilemas contemporâneos.
- **Eixo 3 — Metodologia Filosófica:** Leitura analítica de textos filosóficos,
  identificação de teses, argumentos e pressupostos, produção de textos
  dissertativo-argumentativos, debate regrado com respeito à pluralidade de
  perspectivas.
- **Eixo 4 — Filosofia e Cotidiano:** Filosofia e mídias sociais (bolhas
  epistêmicas, pós-verdade, deep fake), ética da inteligência artificial,
  questões de gênero e raça na perspectiva filosófica, sustentabilidade e ética
  ambiental (Hans Jonas, deep ecology).

## FORMATO DE SAÍDA PADRÃO

Toda geração deve retornar JSON válido e bem formado. Campos não preenchíveis
devem conter \`"[A DEFINIR]"\` — NUNCA invente dados. Siga estritamente o
template de saída especificado em cada tipo de geração.

## REFERÊNCIAS OBRIGATÓRIAS

- **BNCC — Etapa do Ensino Médio:** Área de Ciências Humanas e Sociais Aplicadas
  (CHS), competências específicas 1 a 6.
- **Currículo Referência de Minas Gerais — EM:** Filosofia como componente
  curricular da área de Ciências Humanas.
- **Matriz de Referência do ENEM:** Competências de área 1 a 6 — Ciências Humanas
  e suas Tecnologias.
- **PNLD — Ensino Médio:** Obras didáticas de Filosofia aprovadas no programa.
`,
};
