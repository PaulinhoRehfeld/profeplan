# Template de Prompt — Planejamento Trimestral (Educação Física)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Educação Física seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR REGRAS ESPORTIVAS OU EXERCÍCIOS SEM BASE.** Toda
referência a regras esportivas, técnicas de execução de exercícios,
fundamentos táticos ou protocolos de treinamento DEVE ser verificável na
base RAG. Se não tiver certeza de uma informação, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Educação Física
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
    "disciplina": "Educação Física",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Compreender a origem da cultura corporal de movimento e seus vínculos com a organização da vida coletiva e individual...",
      "fonte": "BNCC — Área de Linguagens"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo_tematico": "{{eixo_tematico_mes1}}",
      "unidades_tematicas": ["Esportes", "Brincadeiras e Jogos"],
      "esportes_modalidades": ["{{modalidade_1}}", "{{modalidade_2}}"],
      "habilidades_bncc": ["EF67EF01", "EF67EF02", "EF67EF03"],
      "objetos_conhecimento": [
        "{{objeto_conhecimento_1}}",
        "{{objeto_conhecimento_2}}"
      ],
      "conteudos": [
        {
          "topico": "{{topico_1}}",
          "descricao": "{{descricao_topico_1}}",
          "aulas_previstas": "{{aulas_topico_1}}"
        },
        {
          "topico": "{{topico_2}}",
          "descricao": "{{descricao_topico_2}}",
          "aulas_previstas": "{{aulas_topico_2}}"
        }
      ],
      "atividades_previstas": [
        "Aula prática: {{descricao_pratica_mes1}}",
        "Jogo/competição adaptada: {{descricao_jogo_mes1}}",
        "Roda de conversa: {{descricao_reflexao_mes1}}"
      ],
      "avaliacao": "{{tipo_avaliacao_mes1}}",
      "materiais_necessarios": [
        "{{material_1}}",
        "{{material_2}}"
      ],
      "espaco_necessario": "{{espaco_mes1}}"
    },
    "mes_2": {
      "eixo_tematico": "{{eixo_tematico_mes2}}",
      "unidades_tematicas": ["Ginásticas", "Danças"],
      "esportes_modalidades": ["{{modalidade_3}}"],
      "habilidades_bncc": ["EF67EF04", "EF67EF05", "EF67EF06"],
      "objetos_conhecimento": [
        "{{objeto_conhecimento_3}}",
        "{{objeto_conhecimento_4}}"
      ],
      "conteudos": [
        {
          "topico": "{{topico_3}}",
          "descricao": "{{descricao_topico_3}}",
          "aulas_previstas": "{{aulas_topico_3}}"
        },
        {
          "topico": "{{topico_4}}",
          "descricao": "{{descricao_topico_4}}",
          "aulas_previstas": "{{aulas_topico_4}}"
        }
      ],
      "atividades_previstas": [
        "Aula prática: {{descricao_pratica_mes2}}",
        "Apresentação/coreografia: {{descricao_apresentacao_mes2}}",
        "Reflexão sobre corpo e expressão: {{descricao_reflexao_mes2}}"
      ],
      "avaliacao": "{{tipo_avaliacao_mes2}}",
      "materiais_necessarios": [
        "{{material_3}}",
        "{{material_4}}"
      ],
      "espaco_necessario": "{{espaco_mes2}}"
    },
    "mes_3": {
      "eixo_tematico": "{{eixo_tematico_mes3}}",
      "unidades_tematicas": ["Lutas", "Práticas Corporais de Aventura"],
      "esportes_modalidades": ["{{modalidade_4}}"],
      "habilidades_bncc": ["EF67EF07", "EF67EF08"],
      "objetos_conhecimento": [
        "{{objeto_conhecimento_5}}",
        "{{objeto_conhecimento_6}}"
      ],
      "conteudos": [
        {
          "topico": "{{topico_5}}",
          "descricao": "{{descricao_topico_5}}",
          "aulas_previstas": "{{aulas_topico_5}}"
        },
        {
          "topico": "{{topico_6}}",
          "descricao": "{{descricao_topico_6}}",
          "aulas_previstas": "{{aulas_topico_6}}"
        }
      ],
      "atividades_previstas": [
        "Projeto integrador: {{descricao_projeto_mes3}}",
        "Festival/Torneio: {{descricao_evento_mes3}}",
        "Autoavaliação e encerramento do trimestre"
      ],
      "avaliacao": "{{tipo_avaliacao_mes3}}",
      "materiais_necessarios": [
        "{{material_5}}",
        "{{material_6}}"
      ],
      "espaco_necessario": "{{espaco_mes3}}"
    }
  },
  "projeto_integrador": {
    "tema": "{{tema_projeto}}",
    "descricao": "{{descricao_projeto}}",
    "disciplinas_envolvidas": ["Educação Física", "Ciências/Biologia", "Língua Portuguesa"],
    "produto_final": "{{produto_final}}",
    "criterios_avaliacao": [
      "{{criterio_projeto_1}}",
      "{{criterio_projeto_2}}",
      "{{criterio_projeto_3}}"
    ]
  },
  "adaptacoes_pdi": {
    "deficiencia_motora": "{{adaptacao_motora}}",
    "deficiencia_visual": "{{adaptacao_visual}}",
    "deficiencia_auditiva": "{{adaptacao_auditiva}}",
    "deficiencia_intelectual": "{{adaptacao_cognitiva}}"
  },
  "recursos_multimidia": [
    "{{recurso_1}}",
    "{{recurso_2}}"
  ],
  "cronograma_avaliacoes": [
    {
      "tipo": "Avaliação prática contínua",
      "periodo": "Ao longo de todo o trimestre",
      "peso": 40
    },
    {
      "tipo": "Autoavaliação",
      "periodo": "Final de cada mês",
      "peso": 15
    },
    {
      "tipo": "Avaliação entre pares",
      "periodo": "Mês 3",
      "peso": 10
    },
    {
      "tipo": "Prova teórica / trabalho de pesquisa",
      "periodo": "Final do trimestre",
      "peso": 35
    }
  ]
}
```
