# Template de Prompt — Planejamento Trimestral (Ciências/Biologia)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Ciências (EF) ou Biologia (EM)
seguindo ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma
informação não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA
invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR EXPERIMENTOS OU DADOS CIENTÍFICOS.** Toda informação
científica deve ser verificável. Se não tiver certeza de um dado, indique
`[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** {{disciplina}} (Ciências ou Biologia)
- **Ano/Série:** {{ano_serie}}
- **Trimestre:** {{trimestre}} (1º, 2º ou 3º)
- **Ano Letivo:** {{ano_letivo}}
- **Carga Horária Semanal:** {{carga_horaria}} aulas de 50 min
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Calendário Escolar:** {{calendario_escolar}}
- **Infraestrutura de Laboratório:** {{infra_lab}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "{{disciplina}}",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Compreender as Ciências da Natureza como empreendimento humano, e o conhecimento científico como provisório, cultural e histórico...",
      "fonte": "BNCC — Área de Ciências da Natureza"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo_tematico": "{{eixo_tematico_mes1}}",
      "tema_central": "{{tema_mes1}}",
      "habilidades_bncc": ["EF06CI01", "EF06CI02"],
      "objetos_conhecimento": [
        "{{objeto_1_mes1}}",
        "{{objeto_2_mes1}}",
        "{{objeto_3_mes1}}"
      ],
      "atividades_experimentais": [
        {
          "titulo": "{{experimento_1_mes1}}",
          "descricao": "{{descricao_experimento}}",
          "materiais": ["{{material_1}}", "{{material_2}}"],
          "precaucoes": ["{{precaucao_1}}", "{{precaucao_2}}"]
        }
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Relatório de experimento + questionário conceitual (peso 4)"
    },
    "mes_2": {
      "eixo_tematico": "{{eixo_tematico_mes2}}",
      "tema_central": "{{tema_mes2}}",
      "habilidades_bncc": ["EF06CI03", "EF06CI04"],
      "objetos_conhecimento": [
        "{{objeto_1_mes2}}",
        "{{objeto_2_mes2}}",
        "{{objeto_3_mes2}}"
      ],
      "atividades_experimentais": [
        {
          "titulo": "{{experimento_1_mes2}}",
          "descricao": "{{descricao_experimento}}",
          "materiais": ["{{material_1}}", "{{material_2}}"],
          "precaucoes": ["{{precaucao_1}}"]
        }
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Projeto de investigação em grupo + apresentação (peso 4)"
    },
    "mes_3": {
      "eixo_tematico": "{{eixo_tematico_mes3}}",
      "tema_central": "{{tema_mes3}}",
      "habilidades_bncc": ["EF06CI05", "EF06CI06"],
      "objetos_conhecimento": [
        "{{objeto_1_mes3}}",
        "{{objeto_2_mes3}}",
        "{{objeto_3_mes3}}"
      ],
      "atividades_experimentais": [
        {
          "titulo": "{{experimento_1_mes3}}",
          "descricao": "{{descricao_experimento}}",
          "materiais": ["{{material_1}}", "{{material_2}}"],
          "precaucoes": ["{{precaucao_1}}"]
        }
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Prova escrita + fechamento do caderno de ciências (peso 4)"
    }
  },
  "estrategias_metodologicas": [
    "Ensino por Investigação (Inquiry-Based Science Education)",
    "Atividades experimentais investigativas (hands-on, minds-on)",
    "Aprendizagem Baseada em Problemas com questões científicas",
    "Uso de simuladores digitais (PhET Colorado, etc.)",
    "Leitura e análise de textos de divulgação científica",
    "Aulas de campo e estudos do meio (quando viável)"
  ],
  "projetos_interdisciplinares": [
    {
      "titulo": "{{projeto_1}}",
      "disciplinas_envolvidas": ["Matemática", "Geografia", "Língua Portuguesa"],
      "descricao": "{{descricao_projeto_1}}",
      "produto_final": "{{produto_projeto_1}}"
    }
  ],
  "avaliacao_trimestral": {
    "instrumentos": [
      "Avaliações parciais mensais ({{peso_mensais}} pontos)",
      "Prova trimestral integrada ({{peso_prova}} pontos)",
      "Caderno de Ciências / Portfólio de experimentos ({{peso_caderno}} pontos)",
      "Autoavaliação do aluno ({{peso_autoavaliacao}} pontos)"
    ],
    "recuperacao_paralela": "{{estrategia_recuperacao}}",
    "simulado_enem": "{{questoes_enem_integradas}}" 
  },
  "materiais_referencia": [
    {
      "tipo": "Livro didático PNLD",
      "referencia": "{{referencia_pnld}}",
      "capitulos": ["{{cap_mes1}}", "{{cap_mes2}}", "{{cap_mes3}}"]
    },
    {
      "tipo": "Site/Simulador",
      "referencia": "{{referencia_digital}}"
    }
  ]
}
```
