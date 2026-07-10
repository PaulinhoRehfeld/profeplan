# Template de Prompt — Plano de Aula (Sociologia)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Sociologia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados
sociológicos, estatísticas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Sociologia
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Sociologia",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EM13CHS101",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias sociológicas..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender o conceito sociológico de {{conceito_sociologico}} e sua formulação por {{autor_principal}}...",
    "Analisar dados e indicadores sociais relacionados a {{tema}} identificando tendências e correlações...",
    "Relacionar o pensamento de {{autor_principal}} com problemas sociais contemporâneos como {{problema_contemporaneo}}...",
    "Produzir texto dissertativo-argumentativo aplicando conceitos sociológicos à análise de uma situação-problema..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição conceitual e contextualização histórica",
    "{{autor_principal}}: vida, obra e principais contribuições ao tema",
    "Conceitos-chave: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
    "Dados e indicadores: {{fonte_dados_confirmada_base_rag}}",
    "Desdobramentos contemporâneos: {{tema_no_seculo_xxi}}",
    "Conexões interdisciplinares: {{conexao_historia}}, {{conexao_geografia}}"
  ],
  "textos_e_dados": [
    {
      "tipo": "trecho_teorico",
      "autor": "{{autor_principal}}",
      "obra": "{{obra}}",
      "trecho_selecionado": "{{trecho_confirmado_na_base_rag}}",
      "orientacao_leitura": "Identifique a tese central do autor e os argumentos que a sustentam. Relacione com {{tema_da_aula}}."
    },
    {
      "tipo": "dado_sociologico",
      "fonte": "{{fonte_confirmada_base_rag}}",
      "dado": "{{dado_confirmado_base_rag}}",
      "orientacao_analise": "Interprete este indicador social considerando o contexto brasileiro. O que ele revela sobre {{tema_da_aula}}?"
    }
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora para engajar os alunos na reflexão sociológica...",
      "estrategia": "Pergunta provocadora / dilema social / charge ou tirinha / vídeo curto (3-5 min) / manchete de jornal / meme com conteúdo sociológico"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de leitura, análise de dados, debate e/ou produção textual...",
      "etapas": [
        {
          "titulo": "Leitura e Análise de Texto/Dados Sociológicos",
          "descricao": "Leitura compartilhada do trecho selecionado com mediação do professor, identificando conceitos-chave, tese e argumentos. Ou análise orientada de gráfico/tabela com indicadores sociais...",
          "recurso": "Trecho impresso/projetado de {{obra}} ou gráfico/tabela de {{fonte_dados}}"
        },
        {
          "titulo": "Problematização e Debate",
          "descricao": "Discussão estruturada em grupos sobre a aplicação do conceito a um problema social contemporâneo. Cada grupo formula uma posição fundamentada com argumentos sociológicos...",
          "recurso": "Roteiro de debate com perguntas orientadoras / quadro para registro dos argumentos"
        },
        {
          "titulo": "Produção Textual",
          "descricao": "Produção de parágrafo ou texto dissertativo-argumentativo aplicando o conceito estudado à análise de uma situação-problema fornecida pelo professor...",
          "recurso": "Folha de redação / caderno / ferramenta digital de escrita colaborativa"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Sistematização coletiva dos aprendizados, retomada da pergunta inicial e conexão com a próxima aula...",
      "estrategia": "Mapa conceitual colaborativo / ticket de saída com pergunta sociológica / síntese oral em dupla"
    }
  },
  "recursos_didaticos": [
    "Trecho impresso/projetado de {{obra}} ({{autor_principal}})",
    "Gráfico ou tabela com indicadores de {{fonte_dados_confirmada_base_rag}}",
    "Quadro branco e marcadores para mapa conceitual",
    "Projetor multimídia para {{recurso_visual}}",
    "Roteiro de debate com perguntas orientadoras"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação qualificada na discussão (uso de conceitos sociológicos)",
      "Capacidade de interpretar dados e indicadores sociais",
      "Qualidade da argumentação no texto dissertativo (tese, argumentos, evidências)",
      "Domínio dos conceitos sociológicos trabalhados na aula",
      "Capacidade de relacionar teoria sociológica com problemas contemporâneos"
    ],
    "instrumentos": [
      "Observação da participação no debate (registro em ficha)",
      "Texto dissertativo-argumentativo produzido em aula (correção por rubrica)",
      "Ticket de saída com autoavaliação"
    ]
  },
  "conexao_enem": {
    "competencia": "{{competencia_enem_principal}}",
    "habilidade": "{{habilidade_enem}}",
    "dica_enem": "No ENEM, temas como {{tema_enem_relacionado}} costumam aparecer articulados a conceitos de {{conceitos_chave}}. Fique atento(a) à leitura de gráficos e à interpretação de textos de autores clássicos como {{autores_classicos_enem}}."
  },
  "adaptacao_pdi": {
    "estrategias": [
      "Material impresso com fonte ampliada e espaçamento aumentado para alunos com baixa visão",
      "Glossário de conceitos sociológicos com definições simplificadas para alunos com dificuldades de aprendizagem",
      "Tempo adicional de 20% para produção textual para alunos com dislexia ou TDAH",
      "Leitura oral do texto-base para alunos com deficiência visual ou dificuldades de leitura"
    ]
  }
}
```
