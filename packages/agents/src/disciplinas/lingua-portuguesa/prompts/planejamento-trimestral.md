# Template de Prompt — Planejamento Trimestral (Língua Portuguesa)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Língua Portuguesa seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Língua Portuguesa
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
    "disciplina": "Língua Portuguesa",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Compreender o funcionamento das diferentes linguagens...",
      "fonte": "BNCC — Área de Linguagens"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo": "Leitura e Interpretação",
      "habilidades_bncc": ["EF67LP28", "EF67LP29"],
      "objetos_conhecimento": [
        "Gênero textual: crônica narrativa",
        "Elementos da narrativa: enredo, personagens, tempo, espaço",
        "Variação linguística: registros formal e informal"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Produção de crônica narrativa (peso 3)"
    },
    "mes_2": {
      "eixo": "Produção Textual e Análise Linguística",
      "habilidades_bncc": ["EF67LP30", "EF67LP31"],
      "objetos_conhecimento": [
        "Planejamento e revisão textual",
        "Coesão referencial: pronomes e sinônimos",
        "Pontuação em textos narrativos"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Reescrita orientada da crônica (peso 3)"
    },
    "mes_3": {
      "eixo": "Oralidade e Literatura",
      "habilidades_bncc": ["EF67LP32", "EF67LP33"],
      "objetos_conhecimento": [
        "Declamação de poemas",
        "Literatura brasileira: autores contemporâneos",
        "Debate regrado sobre tema da atualidade"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Seminário em grupo + prova escrita (peso 4)"
    }
  },
  "estrategias_metodologicas": [
    "Leitura compartilhada com pausa protocolada",
    "Produção textual com revisão por pares",
    "Círculo de leitura com diário de bordo",
    "Uso de tecnologias digitais: Padlet, Google Docs, Mentimeter"
  ],
  "projetos_interdisciplinares": [
    {
      "titulo": "Jornal da Escola",
      "disciplinas_envolvidas": ["Língua Portuguesa", "História", "Artes"],
      "produto_final": "Edição trimestral do jornal escolar"
    }
  ],
  "avaliacao_trimestral": {
    "instrumentos": [
      {"tipo": "Produção Textual", "peso": 3, "descricao": "Crônica narrativa + reescrita"},
      {"tipo": "Prova Escrita", "peso": 3, "descricao": "Interpretação + gramática contextualizada"},
      {"tipo": "Seminário", "peso": 2, "descricao": "Apresentação oral sobre autor contemporâneo"},
      {"tipo": "Participação e Caderno", "peso": 2, "descricao": "Registros, tarefas e engajamento"}
    ],
    "recuperacao_paralela": "Reagendamento de produções textuais com orientação individualizada"
  },
  "recursos_materiais": [
    "Livro didático adotado (PNLD {{ano_pnld}})",
    "Textos complementares (cópias xerox)",
    "Projetor multimídia e caixas de som",
    "Plataforma digital: {{plataforma}} (se disponível)"
  ]
}
```

## OBSERVAÇÕES CRÍTICAS

- **Distribua as habilidades BNCC uniformemente** entre os 3 meses do trimestre
- **Respeite a progressão pedagógica:** leitura → produção → oralidade/literatura
- **NÃO** concentre toda a avaliação no último mês
- **INCLUA** recuperação paralela como estratégia, não como punição
- **RESPEITE** o calendário escolar — considere feriados e recessos
- Se o plano de curso do professor estiver disponível, use-O como fonte primária
- Adapte a complexidade dos textos e atividades à série indicada
