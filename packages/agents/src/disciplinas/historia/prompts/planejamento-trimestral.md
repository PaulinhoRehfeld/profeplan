# Template de Prompt — Planejamento Trimestral (História)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de História seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR FATOS OU DATAS HISTÓRICAS.** Toda informação factual
deve ser verificável. Se não tiver certeza de um dado, indique
`[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** História
- **Ano/Série:** {{ano_serie}}
- **Trimestre:** {{trimestre}} (1º, 2º ou 3º)
- **Ano Letivo:** {{ano_letivo}}
- **Carga Horária Semanal:** {{carga_horaria}} aulas de 50 min
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Calendário Escolar:** {{calendario_escolar}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "História",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Compreender acontecimentos históricos, relações de poder e processos...",
      "fonte": "BNCC — Área de Ciências Humanas"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo_tematico": "{{eixo_tematico_mes1}}",
      "periodo_historico": "{{periodo_mes1}}",
      "habilidades_bncc": ["EF06HI01", "EF06HI02"],
      "objetos_conhecimento": [
        "Conceito de tempo histórico: periodização, calendários, linhas do tempo",
        "Fontes históricas: tipos e classificação (escritas, visuais, orais, materiais)",
        "O ofício do historiador: como se constrói o conhecimento histórico"
      ],
      "fontes_primarias_sugeridas": [
        "{{fonte_1_mes1}}",
        "{{fonte_2_mes1}}"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Atividade de análise de fontes históricas (peso 3)"
    },
    "mes_2": {
      "eixo_tematico": "{{eixo_tematico_mes2}}",
      "periodo_historico": "{{periodo_mes2}}",
      "habilidades_bncc": ["EF06HI03", "EF06HI04"],
      "objetos_conhecimento": [
        "{{objeto_1_mes2}}",
        "{{objeto_2_mes2}}",
        "{{objeto_3_mes2}}"
      ],
      "fontes_primarias_sugeridas": [
        "{{fonte_1_mes2}}",
        "{{fonte_2_mes2}}"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Produção de linha do tempo comentada (peso 3)"
    },
    "mes_3": {
      "eixo_tematico": "{{eixo_tematico_mes3}}",
      "periodo_historico": "{{periodo_mes3}}",
      "habilidades_bncc": ["EF06HI05", "EF06HI06"],
      "objetos_conhecimento": [
        "{{objeto_1_mes3}}",
        "{{objeto_2_mes3}}",
        "{{objeto_3_mes3}}"
      ],
      "fontes_primarias_sugeridas": [
        "{{fonte_1_mes3}}",
        "{{fonte_2_mes3}}"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Debate historiográfico + prova escrita (peso 4)"
    }
  },
  "estrategias_metodologicas": [
    "Análise de fontes primárias com protocolo de leitura histórica",
    "Linha do tempo interativa e mapas conceituais",
    "Aprendizagem Baseada em Problemas com questões históricas",
    "Roda de debate com diferentes perspectivas historiográficas",
    "Uso de tecnologias digitais: Google Earth, Timeline JS, acervos virtuais de museus"
  ],
  "projetos_interdisciplinares": [
    {
      "titulo": "{{titulo_projeto}}",
      "disciplinas_envolvidas": ["História", "Geografia", "Língua Portuguesa", "Artes"],
      "produto_final": "{{produto_final}}",
      "descricao": "{{descricao_projeto}}"
    }
  ],
  "avaliacao_trimestral": {
    "instrumentos": [
      {"tipo": "Análise de Fontes Históricas", "peso": 3, "descricao": "Atividade prática de análise documental com protocolo"},
      {"tipo": "Prova Escrita", "peso": 3, "descricao": "Questões objetivas e discursivas com fontes históricas"},
      {"tipo": "Seminário Temático", "peso": 2, "descricao": "Apresentação em grupo sobre tema histórico com fontes"},
      {"tipo": "Participação e Caderno", "peso": 2, "descricao": "Registros, tarefas, participação em debates e engajamento"}
    ],
    "recuperacao_paralela": "Reagendamento de atividades com orientação individualizada e novas fontes de apoio"
  },
  "recursos_materiais": [
    "Livro didático adotado (PNLD {{ano_pnld}})",
    "Mapas históricos (físicos e digitais)",
    "Kit de fontes primárias (cópias de documentos, imagens de época)",
    "Projetor multimídia e caixas de som",
    "Acesso à internet para acervos digitais de museus e hemerotecas",
    "Plataforma digital: {{plataforma}} (se disponível)"
  ]
}
```

## OBSERVAÇÕES CRÍTICAS

- **Distribua as habilidades BNCC uniformemente** entre os 3 meses do trimestre
- **Respeite a progressão histórica:** cronológica e temática
- **Inclua fontes primárias em TODOS os meses** — não existe aula de História
  sem fontes
- **NÃO** concentre toda a avaliação no último mês
- **INCLUA** recuperação paralela como estratégia, não como punição
- **RESPEITE** o calendário escolar — considere feriados e recessos
- **CONTEMPLE** as Leis 10.639/03 e 11.645/08 (História e Cultura Afro-Brasileira
  e Indígena) em todos os anos/séries, não apenas em datas comemorativas
- Se o plano de curso do professor estiver disponível, use-O como fonte primária
- Para EF: priorize a construção da noção de tempo histórico e o contato com
  fontes variadas
- Para EM: inclua múltiplas perspectivas historiográficas e preparação para o
  ENEM (Ciências Humanas)
