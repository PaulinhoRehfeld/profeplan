# Template de Prompt — Avaliação (Geografia)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Geografia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR DADOS GEOGRÁFICOS OU ESTATÍSTICAS.** Toda informação
factual (dados populacionais, indicadores socioeconômicos, coordenadas,
áreas, índices, taxas) DEVE ser verificável na base documental RAG. Se
não tiver certeza, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Geografia
- **Ano/Série:** {{ano_serie}}
- **Trimestre/Bimestre:** {{trimestre}}
- **Tipo de Avaliação:** {{tipo_avaliacao}} (Diagnóstica / Formativa / Somativa / Simulado)
- **Habilidades BNCC a Avaliar:** {{habilidades_bncc}}
- **Conteúdos Trabalhados:** {{conteudos}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Número de Questões:** {{num_questoes}}
- **Valor Total:** {{valor_total}} pontos

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Geografia",
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
      "habilidade_bncc": "EF06GE01",
      "descritor": "Comparar modificações das paisagens nos lugares de vivência e usos desses lugares em diferentes tempos",
      "questoes_associadas": [1, 3]
    },
    {
      "habilidade_bncc": "EF06GE02",
      "descritor": "Analisar e comparar diferentes representações cartográficas do espaço geográfico",
      "questoes_associadas": [2, 4]
    },
    {
      "habilidade_bncc": "EF06GE03",
      "descritor": "Identificar e analisar as interações entre sociedade e natureza nos biomas brasileiros",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões e analise os mapas antes de responder.",
    "As respostas das questões discursivas devem ser feitas à caneta azul ou preta.",
    "Não é permitido o uso de corretivo líquido.",
    "Suas respostas devem ser fundamentadas nos mapas, gráficos e dados fornecidos, bem como nos conteúdos trabalhados em aula.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06GE01",
      "nivel_taxonomico": "Compreensão",
      "comando": "Com base no mapa e no texto de apoio fornecidos, identifique a principal transformação na paisagem representada...",
      "fonte_base": {
        "tipo": "Mapa temático + texto",
        "descricao": "{{descricao_fonte}}",
        "fonte": "{{fonte_oficial}}",
        "ano": "{{ano_dado}}"
      },
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{letra_correta}}",
      "justificativa_gabarito": "A alternativa correta é {{letra}} porque... (fundamentar com o mapa e o conteúdo trabalhado). Os distratores são incorretos porque..."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06GE02",
      "nivel_taxonomico": "Análise",
      "comando": "Analise o mapa temático abaixo e responda: quais são os principais padrões espaciais que você identifica? Que fatores (naturais, históricos, econômicos) podem explicar essa distribuição? Fundamente sua resposta com elementos do mapa.",
      "fonte_base": {
        "tipo": "Mapa temático",
        "descricao": "{{descricao_mapa}}",
        "fonte": "{{fonte_oficial}}",
        "ano": "{{ano_dado}}"
      },
      "criterios_correcao": [
        {
          "criterio": "Identificação correta dos padrões espaciais",
          "pontuacao_maxima": 3.0
        },
        {
          "criterio": "Explicação dos fatores (naturais, históricos, econômicos)",
          "pontuacao_maxima": 3.0
        },
        {
          "criterio": "Fundamentação com elementos do mapa e conceitos geográficos",
          "pontuacao_maxima": 3.0
        },
        {
          "criterio": "Clareza, organização e correção gramatical",
          "pontuacao_maxima": 1.0
        }
      ],
      "resposta_esperada": "O aluno deve identificar que... Além disso, espera-se que relacione esse padrão com... Utilizando os conceitos de {{conceitos}}..."
    },
    {
      "numero": 3,
      "tipo": "multipla_escolha_com_grafico",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06GE01",
      "nivel_taxonomico": "Aplicação",
      "comando": "Analise o gráfico abaixo sobre {{tema}}. Com base nos dados apresentados, qual alternativa interpreta corretamente a tendência observada?",
      "fonte_base": {
        "tipo": "Gráfico de {{tipo_grafico}}",
        "descricao": "{{descricao_grafico}}",
        "fonte": "IBGE / {{fonte_oficial}}",
        "periodo": "{{periodo}}"
      },
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{letra_correta}}",
      "justificativa_gabarito": "A alternativa correta é {{letra}} porque os dados do gráfico mostram que... Os distratores são incorretos porque apresentam interpretações que não correspondem aos dados ou invertem tendências."
    },
    {
      "numero": 4,
      "tipo": "verdadeiro_falso_justifique",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06GE03",
      "nivel_taxonomico": "Análise",
      "comando": "Leia as afirmações abaixo sobre {{tema}}. Classifique cada uma como VERDADEIRA (V) ou FALSA (F). Para as afirmações FALSAS, JUSTIFIQUE sua resposta, reescrevendo a afirmação de forma correta.",
      "afirmacoes": [
        {
          "texto": "{{afirmacao_1}}",
          "gabarito": "{{v_ou_f}}",
          "justificativa_para_falso": "{{justificativa}}"
        },
        {
          "texto": "{{afirmacao_2}}",
          "gabarito": "{{v_ou_f}}",
          "justificativa_para_falso": "{{justificativa}}"
        },
        {
          "texto": "{{afirmacao_3}}",
          "gabarito": "{{v_ou_f}}",
          "justificativa_para_falso": "{{justificativa}}"
        }
      ]
    },
    {
      "numero": 5,
      "tipo": "dissertativa_com_mapa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06GE03",
      "nivel_taxonomico": "Síntese",
      "comando": "A partir da análise do mapa e dos dados fornecidos, produza um texto dissertativo de 10 a 15 linhas respondendo à seguinte questão: {{questao_central}}. Em seu texto, utilize pelo menos TRÊS conceitos geográficos trabalhados no trimestre.",
      "fonte_base": {
        "tipo": "Mapa + tabela de dados",
        "descricao": "{{descricao_fonte}}",
        "fonte": "{{fonte_oficial}}",
        "ano": "{{ano_dado}}"
      },
      "conceitos_esperados": ["{{conceito_1}}", "{{conceito_2}}", "{{conceito_3}}"],
      "criterios_correcao": [
        {
          "criterio": "Uso correto de conceitos geográficos (mínimo 3)",
          "pontuacao_maxima": 3.0
        },
        {
          "criterio": "Análise e interpretação dos dados do mapa e da tabela",
          "pontuacao_maxima": 3.0
        },
        {
          "criterio": "Capacidade de síntese e argumentação fundamentada",
          "pontuacao_maxima": 2.0
        },
        {
          "criterio": "Clareza, organização textual e correção gramatical",
          "pontuacao_maxima": 2.0
        }
      ],
      "resposta_esperada": "O aluno deve articular os conceitos de {{conceitos}} para explicar... Espera-se que o texto demonstre compreensão de que..."
    }
  ],
  "gabarito_comentado": {
    "questao_1": "{{gabarito_detalhado_1}}",
    "questao_2": "{{criterios_correcao_detalhados_2}}",
    "questao_3": "{{gabarito_detalhado_3}}",
    "questao_4": "{{gabarito_detalhado_4}}",
    "questao_5": "{{criterios_correcao_detalhados_5}}"
  },
  "tabela_pontuacao": {
    "questao_1": {{valor_q1}},
    "questao_2": {{valor_q2}},
    "questao_3": {{valor_q3}},
    "questao_4": {{valor_q4}},
    "questao_5": {{valor_q5}},
    "total": {{valor_total}}
  },
  "adaptacoes_para_inclusao": [
    "Prova ampliada (fonte Arial 16) para alunos com baixa visão",
    "Mapas com texturas e alto contraste para alunos com deficiência visual",
    "Tempo estendido (50% adicional) para alunos com necessidades específicas",
    "Leitura dos mapas e enunciados por ledor para alunos com deficiência visual ou dislexia",
    "Possibilidade de resposta oral para alunos com dificuldades motoras"
  ]
}
```
