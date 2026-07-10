# Template de Prompt — Planejamento Trimestral (Geografia)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Geografia seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR DADOS GEOGRÁFICOS OU ESTATÍSTICAS.** Toda informação
factual (dados populacionais, indicadores socioeconômicos, coordenadas,
áreas, índices, taxas) DEVE ser verificável na base documental RAG. Se
não tiver certeza, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Geografia
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
    "disciplina": "Geografia",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Compreender o espaço geográfico como produto das relações entre sociedade e natureza...",
      "fonte": "BNCC — Área de Ciências Humanas"
    }
  ],
  "conceitos_estruturantes_trimestre": [
    {
      "conceito": "{{conceito}}",
      "definicao": "{{definicao}}",
      "referencia": "Milton Santos / BNCC"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo_tematico": "{{eixo_tematico_mes1}}",
      "tema_central": "{{tema_central_mes1}}",
      "habilidades_bncc": ["EF06GE01", "EF06GE02", "EF06GE03"],
      "objetos_conhecimento": [
        "Conceito de lugar e paisagem: o espaço vivido",
        "Alfabetização cartográfica: elementos do mapa (título, legenda, escala, orientação)",
        "Orientação e localização: pontos cardeais, coordenadas geográficas"
      ],
      "mapas_e_dados_sugeridos": [
        "{{mapa_1_mes1}} (fonte: {{fonte}})",
        "{{dado_1_mes1}} (fonte: {{fonte}})"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Atividade prática de leitura e interpretação de mapas (peso 3)"
    },
    "mes_2": {
      "eixo_tematico": "{{eixo_tematico_mes2}}",
      "tema_central": "{{tema_central_mes2}}",
      "habilidades_bncc": ["EF06GE04", "EF06GE05", "EF06GE06"],
      "objetos_conhecimento": [
        "{{objeto_1_mes2}}",
        "{{objeto_2_mes2}}",
        "{{objeto_3_mes2}}"
      ],
      "mapas_e_dados_sugeridos": [
        "{{mapa_1_mes2}} (fonte: {{fonte}})",
        "{{dado_1_mes2}} (fonte: {{fonte}})"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Elaboração de mapa temático + relatório de análise (peso 3)"
    },
    "mes_3": {
      "eixo_tematico": "{{eixo_tematico_mes3}}",
      "tema_central": "{{tema_central_mes3}}",
      "habilidades_bncc": ["EF06GE07", "EF06GE08", "EF06GE09"],
      "objetos_conhecimento": [
        "{{objeto_1_mes3}}",
        "{{objeto_2_mes3}}",
        "{{objeto_3_mes3}}"
      ],
      "mapas_e_dados_sugeridos": [
        "{{mapa_1_mes3}} (fonte: {{fonte}})",
        "{{dado_1_mes3}} (fonte: {{fonte}})"
      ],
      "aulas_previstas": 12,
      "avaliacao_parcial": "Seminário temático + prova escrita com análise cartográfica (peso 4)"
    }
  },
  "estrategias_metodologicas": [
    "Trabalho de campo e estudo do meio (presencial ou virtual)",
    "Leitura e produção de mapas temáticos",
    "Análise de imagens de satélite e fotografias aéreas",
    "Aprendizagem Baseada em Problemas com questões socioambientais",
    "Uso de geotecnologias: Google Earth, OpenStreetMap, QGIS",
    "Maquetes e representações tridimensionais do relevo",
    "Análise de dados estatísticos: tabelas, gráficos, infográficos"
  ],
  "recursos_didaticos_trimestre": [
    "Atlas geográfico escolar",
    "Google Earth / Google Maps (computador ou tablets)",
    "Mapas impressos (IBGE, atlas)",
    "Projetor multimídia",
    "Bússolas (para trabalho de campo)",
    "Livro didático adotado (PNLD)"
  ],
  "projetos_interdisciplinares": [
    {
      "disciplinas_envolvidas": ["História", "Ciências"],
      "tema": "{{tema_projeto}}",
      "descricao": "{{descricao_projeto}}",
      "produto_final": "{{produto}}"
    }
  ],
  "avaliacao_trimestral": {
    "distribuicao_pontos": {
      "avaliacao_parcial_1": {"peso": 3, "descricao": "{{descricao_ap1}}"},
      "avaliacao_parcial_2": {"peso": 3, "descricao": "{{descricao_ap2}}"},
      "avaliacao_parcial_3": {"peso": 4, "descricao": "{{descricao_ap3}}"}
    },
    "criterios_gerais": [
      "Domínio da linguagem cartográfica: leitura e interpretação de mapas",
      "Capacidade de análise multiescalar (local → global)",
      "Uso correto de conceitos geográficos na argumentação",
      "Estabelecimento de relações entre sociedade e natureza",
      "Posicionamento crítico fundamentado em dados e evidências"
    ],
    "recuperacao": {
      "estrategia": "{{estrategia_recuperacao}}",
      "periodo": "{{periodo_recuperacao}}"
    }
  },
  "adaptacoes_curriculares": [
    "Mapas táteis e audiodescrição para alunos com deficiência visual",
    "Glossário ilustrado de conceitos geográficos",
    "Tempo estendido para atividades de análise cartográfica",
    "Material complementar com linguagem simplificada"
  ]
}
```
