# Template de Prompt — Planejamento Trimestral (Matemática)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Matemática seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Matemática
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
    "disciplina": "Matemática",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Reconhecer que a Matemática é uma ciência humana, fruto das necessidades...",
      "fonte": "BNCC — Área de Matemática"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "Números",
      "habilidades_bncc": ["EF06MA01", "EF06MA02", "EF06MA03"],
      "objetos_conhecimento": [
        "Sistema de numeração decimal: leitura, escrita e ordenação",
        "Operações fundamentais com números naturais",
        "Resolução de problemas com as quatro operações"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Atividade diagnóstica + lista de problemas (peso 3)"
    },
    "mes_2": {
      "unidade_tematica": "Álgebra",
      "habilidades_bncc": ["EF06MA06", "EF06MA07"],
      "objetos_conhecimento": [
        "Propriedades da igualdade",
        "Resolução de equações do 1º grau",
        "Problemas envolvendo equações do 1º grau"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Prova escrita + projeto de modelagem (peso 3)"
    },
    "mes_3": {
      "unidade_tematica": "Geometria",
      "habilidades_bncc": ["EF06MA16", "EF06MA17", "EF06MA18"],
      "objetos_conhecimento": [
        "Figuras geométricas planas: classificação e propriedades",
        "Perímetro de figuras planas",
        "Área de retângulos e quadrados"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Prova escrita + caderno de atividades (peso 4)"
    }
  },
  "estrategias_metodologicas": [
    "Resolução de problemas com diferentes estratégias",
    "Investigação matemática com material concreto",
    "Jogos matemáticos cooperativos",
    "Uso do GeoGebra para exploração de geometria",
    "Modelagem matemática com situações do cotidiano"
  ],
  "projetos_interdisciplinares": [
    {
      "titulo": "Matemática Financeira na Prática",
      "disciplinas_envolvidas": ["Matemática", "Geografia", "Língua Portuguesa"],
      "produto_final": "Relatório de pesquisa de preços e planejamento financeiro"
    }
  ],
  "avaliacao_trimestral": {
    "instrumentos": [
      {"tipo": "Prova Escrita", "peso": 3, "descricao": "Questões objetivas e discursivas com resolução comentada"},
      {"tipo": "Atividades Práticas", "peso": 3, "descricao": "Projetos, investigações e modelagem matemática"},
      {"tipo": "Participação e Caderno", "peso": 2, "descricao": "Registros, tarefas e engajamento nas aulas"},
      {"tipo": "Autoavaliação", "peso": 2, "descricao": "Reflexão do aluno sobre seu processo de aprendizagem"}
    ],
    "recuperacao_paralela": "Lista de exercícios personalizada com correção individualizada e reagendamento"
  },
  "recursos_materiais": [
    "Livro didático adotado (PNLD {{ano_pnld}})",
    "Material concreto: sólidos geométricos, tangram, ábaco",
    "Laboratório de informática com GeoGebra",
    "Projetor multimídia",
    "Plataforma digital: {{plataforma}} (se disponível)"
  ]
}
```

## OBSERVAÇÕES CRÍTICAS

- **Distribua as habilidades BNCC uniformemente** entre os 3 meses do trimestre
- **Respeite a progressão pedagógica:** números → álgebra → geometria
- **NÃO** concentre toda a avaliação no último mês
- **INCLUA** recuperação paralela como estratégia construtiva
- **RESPEITE** o calendário escolar — considere feriados e recessos
- Se o plano de curso do professor estiver disponível, use-O como fonte primária
- **VALORIZE O RACIOCÍNIO** nos critérios de avaliação, não apenas acerto/erro
- Para Ensino Médio, distribua simulados ENEM ao longo do trimestre
- Inclua sempre a conexão com o cotidiano nos objetos de conhecimento
