# Template de Prompt — Planejamento Trimestral (Artes)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Artes seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR OBRAS DE ARTE OU ARTISTAS.** Toda referência a obras
de arte, artistas, movimentos artísticos ou datas DEVE ser verificável na
base RAG. Se não tiver certeza de uma informação, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Artes
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
    "disciplina": "Artes",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Explorar, conhecer, fruir e analisar criticamente práticas e produções artísticas...",
      "fonte": "BNCC — Área de Linguagens"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo_tematico": "{{eixo_tematico_mes1}}",
      "linguagens_artisticas": ["Artes Visuais", "Música"],
      "movimentos_artisticos": ["{{movimento_1}}"],
      "habilidades_bncc": ["EF69AR01", "EF69AR02"],
      "objetos_conhecimento": [
        "{{objeto_conhecimento_1}}",
        "{{objeto_conhecimento_2}}"
      ],
      "artistas_obras_referencia": [
        {
          "artista": "{{artista_1}}",
          "obra": "{{obra_1}}",
          "fonte_rag": "{{fonte}}"
        }
      ],
      "atividades_previstas": [
        "Apreciação de obras: {{descricao_apreciacao}}",
        "Atividade prática: {{descricao_criacao}}",
        "Roda de conversa e reflexão: {{descricao_reflexao}}"
      ],
      "avaliacao": "{{tipo_avaliacao_mes1}}",
      "materiais_necessarios": [
        "{{material_1}}",
        "{{material_2}}"
      ]
    },
    "mes_2": {
      "eixo_tematico": "{{eixo_tematico_mes2}}",
      "linguagens_artisticas": ["Dança", "Teatro"],
      "movimentos_artisticos": ["{{movimento_2}}"],
      "habilidades_bncc": ["EF69AR03", "EF69AR04"],
      "objetos_conhecimento": [
        "{{objeto_conhecimento_3}}",
        "{{objeto_conhecimento_4}}"
      ],
      "artistas_obras_referencia": [
        {
          "artista": "{{artista_2}}",
          "obra": "{{obra_2}}",
          "fonte_rag": "{{fonte}}"
        }
      ],
      "atividades_previstas": [
        "{{atividade_mes2_1}}",
        "{{atividade_mes2_2}}",
        "{{atividade_mes2_3}}"
      ],
      "avaliacao": "{{tipo_avaliacao_mes2}}",
      "materiais_necessarios": [
        "{{material_3}}",
        "{{material_4}}"
      ]
    },
    "mes_3": {
      "eixo_tematico": "{{eixo_tematico_mes3}}",
      "linguagens_artisticas": ["Artes Integradas"],
      "movimentos_artisticos": ["{{movimento_3}}"],
      "habilidades_bncc": ["EF69AR05", "EF69AR06", "EF69AR07", "EF69AR08"],
      "objetos_conhecimento": [
        "{{objeto_conhecimento_5}}",
        "{{objeto_conhecimento_6}}"
      ],
      "artistas_obras_referencia": [
        {
          "artista": "{{artista_3}}",
          "obra": "{{obra_3}}",
          "fonte_rag": "{{fonte}}"
        }
      ],
      "atividades_previstas": [
        "Projeto integrador: {{descricao_projeto}}",
        "Mostra cultural / exposição: {{descricao_mostra}}",
        "Autoavaliação e encerramento do trimestre"
      ],
      "avaliacao": "{{tipo_avaliacao_mes3}}",
      "materiais_necessarios": [
        "{{material_5}}",
        "{{material_6}}"
      ]
    }
  },
  "projeto_integrador_trimestral": {
    "titulo": "{{titulo_projeto}}",
    "descricao": "{{descricao_projeto}}",
    "linguagens_integradas": ["Artes Visuais", "Música", "Dança", "Teatro"],
    "produto_final": "{{produto_final}}",
    "culminancia": "{{evento_culminancia}}"
  },
  "cronograma_aulas": [
    {
      "semana": 1,
      "aula": 1,
      "tema": "{{tema_aula1}}",
      "habilidade_bncc": "EF69AR01",
      "linguagem_artistica": "Artes Visuais"
    }
  ],
  "instrumentos_avaliacao": [
    {
      "tipo": "Formativa — Portfólio",
      "peso": 40,
      "descricao": "Registro do processo criativo ao longo do trimestre: esboços, anotações, fotos das produções, reflexões escritas."
    },
    {
      "tipo": "Formativa — Participação",
      "peso": 30,
      "descricao": "Engajamento nas atividades de apreciação, criação e reflexão. Trabalho em grupo, respeito aos colegas e ao espaço."
    },
    {
      "tipo": "Somativa — Projeto Integrador",
      "peso": 30,
      "descricao": "Produto final do projeto integrador do trimestre. Avaliado por rubrica com critérios de criatividade, técnica, expressão e reflexão crítica."
    }
  ],
  "adaptacoes_pdi": [
    "{{adaptacao_visual}} — para alunos com deficiência visual",
    "{{adaptacao_auditiva}} — para alunos com deficiência auditiva",
    "{{adaptacao_motora}} — para alunos com deficiência motora",
    "{{adaptacao_cognitiva}} — para alunos com deficiência intelectual"
  ],
  "recursos_multimidia": [
    {
      "tipo": "Vídeo",
      "titulo": "{{titulo_video}}",
      "link": "{{link_video}}",
      "fonte_rag": "{{fonte}}"
    }
  ],
  "referencias_bibliograficas": [
    {
      "tipo": "Livro didático",
      "titulo": "{{livro_pnld}}",
      "capitulos": "{{capitulos}}"
    }
  ]
}
```
