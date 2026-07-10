# Template de Prompt — Plano de Aula (Geografia)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Geografia seguindo ESTRITAMENTE a
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
- **Tema da Aula:** {{tema}}
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Mapas e Dados Disponíveis:** {{mapas_dados}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Geografia",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF06GE01",
      "descricao": "Comparar modificações das paisagens nos lugares de vivência..."
    }
  ],
  "objetivos_aprendizagem": [
    "Identificar as características geográficas do fenômeno estudado...",
    "Analisar mapas, gráficos e tabelas relacionados ao tema, extraindo informações relevantes...",
    "Relacionar o fenômeno geográfico estudado com o espaço vivido pelos alunos..."
  ],
  "conceitos_geograficos_mobilizados": [
    {
      "conceito": "Paisagem",
      "definicao": "Tudo aquilo que a visão alcança e que é percebido pelos sentidos...",
      "aplicacao_na_aula": "Os alunos observarão imagens de satélite comparando..."
    },
    {
      "conceito": "Lugar",
      "definicao": "Espaço do cotidiano, da vivência e das relações de proximidade...",
      "aplicacao_na_aula": "Relacionar o tema com o bairro/cidade dos alunos..."
    }
  ],
  "conteudos_programaticos": [
    "Conceito-chave: {{conceito}}",
    "Contexto geográfico: {{regiao_pais}}",
    "Principais características e processos geográficos",
    "Representações cartográficas: {{tipo_mapa}}"
  ],
  "mapas_e_dados_utilizados": [
    {
      "tipo": "Mapa temático",
      "descricao": "Mapa de {{tema}} da região {{regiao}}...",
      "fonte_verificavel": "{{fonte_oficial}}",
      "ano_dado": "{{ano}}"
    },
    {
      "tipo": "Tabela/Gráfico",
      "descricao": "Dados de {{indicador}} do período {{periodo}}...",
      "fonte_verificavel": "IBGE / {{fonte_oficial}}",
      "ano_dado": "{{ano}}"
    },
    {
      "tipo": "Imagem de satélite",
      "descricao": "Imagem Landsat/CBERS da área {{local}}...",
      "fonte_verificavel": "INPE / Google Earth",
      "ano_dado": "{{ano}}"
    }
  ],
  "desenvolvimento": {
    "introducao": {
      "duracao_min": 10,
      "descricao": "Atividade de sensibilização / levantamento de conhecimentos prévios...",
      "estrategia": "Pergunta disparadora / imagem de satélite / mapa / notícia de jornal"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de análise geográfica e construção do conhecimento...",
      "etapas": [
        {
          "titulo": "Leitura e Análise Cartográfica",
          "descricao": "Em grupos, os alunos analisam os mapas e dados fornecidos, identificando padrões espaciais e correlações...",
          "recurso": "Mapas impressos / Google Earth / atlas escolar"
        },
        {
          "titulo": "Sistematização e Debate",
          "descricao": "Cada grupo compartilha suas análises. O professor sistematiza no quadro os principais conceitos e relações espaciais identificadas...",
          "recurso": "Quadro branco / projetor"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Síntese conectando o conteúdo da aula com o espaço vivido pelos alunos...",
      "estrategia": "Ticket de saída: 'Como o que aprendemos hoje se manifesta no lugar onde você vive?'"
    }
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Mapas impressos ({{mapas}})",
    "Atlas geográfico escolar",
    "Google Earth / Google Maps",
    "Quadro branco e marcadores",
    "Livro didático, páginas XX-YY"
  ],
  "avaliacao": {
    "criterios": [
      "Capacidade de ler e interpretar mapas e gráficos",
      "Estabelecimento de relações entre fenômenos geográficos em diferentes escalas",
      "Uso correto de conceitos geográficos na argumentação"
    ],
    "instrumentos": [
      "Observação da participação nas atividades em grupo",
      "Registro escrito da análise cartográfica",
      "Ticket de saída (fechamento)"
    ]
  },
  "adaptacoes_inclusao": [
    "Mapas com texturas e relevo tátil para alunos com deficiência visual",
    "Audiodescrição de imagens de satélite e fotografias aéreas",
    "Glossário de conceitos geográficos com linguagem simplificada",
    "Tempo estendido para realização das atividades"
  ],
  "conexao_enem": {
    "competencias_enem": ["C2", "C6"],
    "habilidades_enem": ["H6", "H8", "H12"],
    "exemplo_questao": "{{breve_descricao}}"
  }
}
```
