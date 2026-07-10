# Template de Prompt — Avaliação (História)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de História seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR FATOS OU DATAS HISTÓRICAS.** Toda informação factual
deve ser verificável. Se não tiver certeza de um dado, indique
`[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** História
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
    "disciplina": "História",
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
      "habilidade_bncc": "EF06HI01",
      "descritor": "Identificar diferentes formas de periodização e representação do tempo histórico",
      "questoes_associadas": [1, 3]
    },
    {
      "habilidade_bncc": "EF06HI02",
      "descritor": "Analisar fontes históricas, distinguindo fato de interpretação",
      "questoes_associadas": [2, 4]
    },
    {
      "habilidade_bncc": "EF06HI03",
      "descritor": "Relacionar processos históricos com transformações sociais, políticas e econômicas",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões e as fontes históricas antes de responder.",
    "As questões discursivas devem ser respondidas à caneta azul ou preta.",
    "Não é permitido o uso de corretivo líquido.",
    "Suas respostas devem ser fundamentadas nas fontes fornecidas e nos conteúdos trabalhados em aula.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06HI01",
      "nivel_taxonomico": "Compreensão",
      "comando": "Com base na linha do tempo fornecida e no texto de apoio, identifique a periodização correta do evento histórico abordado...",
      "fonte_base": {
        "tipo": "Linha do tempo + trecho de documento",
        "descricao": "{{descricao_fonte}}",
        "referencia": "{{referencia_completa}}"
      },
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{letra_correta}}",
      "justificativa_gabarito": "A alternativa correta é {{letra}} porque... (fundamentar com a fonte e o conteúdo trabalhado). Os distratores são incorretos porque..."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06HI02",
      "nivel_taxonomico": "Análise",
      "comando": "Analise a fonte histórica abaixo ({{tipo_fonte}}) e responda: qual é a visão do autor sobre o evento retratado? Que elementos do contexto histórico da época podem explicar essa visão? Fundamente sua resposta com elementos da fonte.",
      "fonte_base": {
        "tipo": "{{tipo_fonte}}",
        "descricao": "{{descricao_fonte}}",
        "trecho": "{{trecho_fonte}}",
        "referencia": "{{referencia_completa}}"
      },
      "criterios_correcao": {
        "nota_maxima": "{{valor_questao}}",
        "rubrica": [
          {"faixa": "Excelente (90-100%)", "descricao": "Identifica a perspectiva do autor, contextualiza historicamente com precisão e fundamenta com elementos específicos da fonte."},
          {"faixa": "Bom (70-89%)", "descricao": "Identifica a perspectiva do autor e contextualiza, mas fundamenta de forma genérica ou parcial."},
          {"faixa": "Regular (50-69%)", "descricao": "Identifica a perspectiva do autor, mas não contextualiza adequadamente ou não usa a fonte como evidência."},
          {"faixa": "Insuficiente (0-49%)", "descricao": "Não identifica a perspectiva do autor ou apresenta análise equivocada do contexto histórico."}
        ]
      },
      "resposta_esperada": "O aluno deve identificar que o autor apresenta uma visão {{perspectiva}} porque... (resumo dos principais pontos esperados, com referência às fontes)."
    }
  ],
  "gabarito_completo": {
    "questoes_objetivas": [
      {"numero": 1, "resposta": "{{letra}}"},
      {"numero": 3, "resposta": "{{letra}}"},
      {"numero": 4, "resposta": "{{letra}}"}
    ],
    "questoes_dissertativas": [
      {"numero": 2, "orientacao_correcao": "Ver rubrica correspondente. Atribuir nota de 0 a {{valor_questao}}. Valorizar o uso de evidências da fonte e a contextualização histórica."},
      {"numero": 5, "orientacao_correcao": "Ver rubrica correspondente. Atribuir nota de 0 a {{valor_questao}}. Valorizar a capacidade de relacionar passado e presente com fundamentação."}
    ]
  },
  "tabela_desempenho": {
    "faixas": [
      {"conceito": "Avançado", "nota_minima": 90, "nota_maxima": 100, "descricao": "Domínio pleno das habilidades históricas avaliadas. Análise crítica e fundamentada de fontes."},
      {"conceito": "Proficiente", "nota_minima": 70, "nota_maxima": 89, "descricao": "Domínio satisfatório; compreende os processos históricos e analisa fontes adequadamente."},
      {"conceito": "Básico", "nota_minima": 50, "nota_maxima": 69, "descricao": "Domínio parcial; identifica informações nas fontes, mas tem dificuldade de contextualização."},
      {"conceito": "Abaixo do Básico", "nota_minima": 0, "nota_maxima": 49, "descricao": "Domínio insuficiente; necessita intervenção pedagógica para desenvolver habilidades de análise histórica."}
    ]
  },
  "plano_recuperacao": {
    "alunos_alvo": "Estudantes com nota abaixo de 60%",
    "estrategias": [
      "Reagendamento de avaliação com novas fontes históricas e questões reformuladas",
      "Plantão de dúvidas com foco em análise de fontes primárias",
      "Roteiro de estudo dirigido com fontes históricas complementares",
      "Atividade de recuperação: análise de fonte histórica com orientação individualizada"
    ]
  }
}
```

## OBSERVAÇÕES CRÍTICAS

- **CADA QUESTÃO** deve estar vinculada a uma habilidade BNCC específica
- **TODA QUESTÃO** deve ter uma fonte histórica como base (documento, imagem,
  mapa, gráfico, linha do tempo) — não existem questões de História sem fontes
- **VÁRIE OS NÍVEIS TAXONÔMICOS:** compreensão, aplicação, análise, síntese,
  avaliação — priorize níveis superiores (análise e avaliação)
- **VÁRIE OS TIPOS DE FONTES:** documentos escritos, imagens de época, mapas
  históricos, gráficos, tabelas, linhas do tempo, charges, fotografias
- **INCLUA** fontes com perspectivas divergentes sobre o mesmo evento para
  questões de comparação (nível de análise/síntese)
- **A rubrica de correção** para questões discursivas é OBRIGATÓRIA
- **O plano de recuperação** deve ser construtivo, não punitivo
- **SEMPRE** inclua a tabela de desempenho com faixas de interpretação pedagógica
- **CONTEMPLE** as Leis 10.639/03 e 11.645/08 na seleção de fontes e temas
- **NÃO** utilize anacronismos — as fontes devem ser coerentes com o período
  histórico estudado
- Para Ensino Médio: siga o padrão ENEM (5 alternativas, textos-base mais longos,
  múltiplas fontes em uma mesma questão, comparação de perspectivas)
- Para Ensino Fundamental: priorize clareza, fontes mais curtas e questões que
  desenvolvam a competência de leitura histórica progressivamente
