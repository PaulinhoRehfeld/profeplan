# Template de Prompt — Planejamento Trimestral (Física)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Física seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
fórmulas ou constantes físicas.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Física
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
    "disciplina": "Física",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Analisar fenômenos naturais e processos tecnológicos, com base nas interações e relações entre matéria e energia...",
      "fonte": "BNCC — Área de Ciências da Natureza e suas Tecnologias"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "Matéria e Energia",
      "topico": "{{topico_mes_1}}",
      "habilidades_bncc": ["EM13CNT101", "EM13CNT102", "EM13CNT103"],
      "objetos_conhecimento": [
        "{{conceito_1}}: definição, formulação matemática e aplicações",
        "{{conceito_2}}: leis e princípios físicos",
        "{{conceito_3}}: modelagem matemática e resolução de problemas"
      ],
      "aulas_previstas": 12,
      "experimentos": [
        {
          "titulo": "{{titulo_experimento_1}}",
          "materiais": "{{materiais_baixo_custo}}",
          "habilidade_associada": "EM13CNT101"
        }
      ],
      "avaliacao_parcial": "Relatório experimental + lista de problemas (peso 3)"
    },
    "mes_2": {
      "unidade_tematica": "Matéria e Energia",
      "topico": "{{topico_mes_2}}",
      "habilidades_bncc": ["EM13CNT104", "EM13CNT105", "EM13CNT106"],
      "objetos_conhecimento": [
        "{{conceito_4}}: formulação matemática e aplicações",
        "{{conceito_5}}: leis de conservação e suas implicações",
        "{{conceito_6}}: aplicações tecnológicas no cotidiano"
      ],
      "aulas_previstas": 12,
      "experimentos": [
        {
          "titulo": "{{titulo_experimento_2}}",
          "materiais": "{{materiais_baixo_custo}}",
          "habilidade_associada": "EM13CNT105"
        }
      ],
      "avaliacao_parcial": "Prova escrita com questões estilo ENEM + relatório experimental (peso 4)"
    },
    "mes_3": {
      "unidade_tematica": "Matéria e Energia",
      "topico": "{{topico_mes_3}}",
      "habilidades_bncc": ["EM13CNT107", "EM13CNT201", "EM13CNT202"],
      "objetos_conhecimento": [
        "{{conceito_7}}: princípios fundamentais e aplicações",
        "{{conceito_8}}: relação com outras áreas da Física",
        "{{conceito_9}}: conexão com o ENEM e vestibulares"
      ],
      "aulas_previstas": 12,
      "experimentos": [
        {
          "titulo": "{{titulo_experimento_3}}",
          "materiais": "{{materiais_baixo_custo}}",
          "habilidade_associada": "EM13CNT107"
        }
      ],
      "avaliacao_parcial": "Simulado ENEM (Ciências da Natureza) + projeto de investigação (peso 3)"
    }
  },
  "estrategias_metodologicas": [
    "Ensino por Investigação com experimentos de baixo custo",
    "Modelagem matemática de fenômenos físicos com dados reais",
    "Simulações computacionais (PhET, GeoGebra) para visualização de fenômenos",
    "Resolução de problemas contextualizados no padrão ENEM",
    "Aprendizagem Baseada em Projetos com tema integrador",
    "Sala de Aula Invertida com videoaulas preparatórias"
  ],
  "projetos_interdisciplinares": [
    {
      "titulo": "{{titulo_projeto_integrador}}",
      "disciplinas_envolvidas": ["Física", "Química", "Biologia", "Matemática"],
      "tema_integrador": "{{tema_integrador}}",
      "produto_final": "{{produto_final}}"
    }
  ],
  "avaliacao_trimestral": {
    "instrumentos": [
      {"tipo": "Prova Escrita (Estilo ENEM)", "peso": 3, "descricao": "Questões objetivas e discursivas contextualizadas, com foco em Ciências da Natureza"},
      {"tipo": "Relatórios Experimentais", "peso": 3, "descricao": "Registro de experimentos com análise de dados e conclusão fundamentada"},
      {"tipo": "Participação e Caderno de Laboratório", "peso": 2, "descricao": "Registros, tarefas, engajamento nas aulas práticas e teóricas"},
      {"tipo": "Autoavaliação", "peso": 2, "descricao": "Reflexão do aluno sobre seu processo de aprendizagem em Física"}
    ],
    "recuperacao_paralela": "Lista de exercícios personalizada com correção individualizada, reagendamento de experimentos práticos e plantão de dúvidas"
  },
  "simulados_enem": [
    {
      "mes": "{{mes_simulado}}",
      "foco": "Ciências da Natureza e suas Tecnologias",
      "habilidades_prioritarias": ["EM13CNT101", "EM13CNT102", "EM13CNT104", "EM13CNT105"],
      "estrategia_correcao": "Análise de desempenho por habilidade BNCC com devolutiva individual"
    }
  ],
  "recursos_materiais": [
    "Livro didático adotado (PNLD {{ano_pnld}})",
    "Kit de experimentos de baixo custo (materiais recicláveis e sucata)",
    "Laboratório de informática com acesso a simulações PhET e GeoGebra",
    "Projetor multimídia",
    "Calculadora científica",
    "Plataforma digital: {{plataforma}} (se disponível)"
  ]
}
```

## OBSERVAÇÕES CRÍTICAS

- **Distribua as habilidades BNCC uniformemente** entre os 3 meses do trimestre
- **Respeite a progressão pedagógica:** conceitos fundamentais → leis e princípios → aplicações e modelagem
- **INCLUA** experimentos em CADA mês — Física sem experimentação é fórmula vazia
- **NÃO** concentre toda a avaliação no último mês
- **INCLUA** recuperação paralela como estratégia construtiva
- **RESPEITE** o calendário escolar — considere feriados e recessos
- Se o plano de curso do professor estiver disponível, use-O como fonte primária
- **VALORIZE A MODELAGEM MATEMÁTICA** nos critérios de avaliação
- Distribua simulados ENEM ao longo do trimestre com foco em Ciências da Natureza
- Inclua sempre a conexão com aplicações tecnológicas do cotidiano
- **NUNCA** invente fórmulas ou constantes físicas — valide com o contexto RAG
