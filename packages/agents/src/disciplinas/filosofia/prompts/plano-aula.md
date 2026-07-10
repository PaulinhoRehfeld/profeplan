# Template de Prompt — Plano de Aula (Filosofia)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Filosofia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
citações filosóficas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Filosofia
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
    "disciplina": "Filosofia",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EM13CHS101",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias filosóficas..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender o conceito de {{conceito_filosofico}} e sua formulação pelo(a) filósofo(a) {{autor_principal}}...",
    "Analisar textos filosóficos identificando teses, argumentos e pressupostos...",
    "Relacionar o pensamento de {{autor_principal}} com problemas contemporâneos como {{problema_contemporaneo}}...",
    "Produzir texto dissertativo-argumentativo aplicando conceitos filosóficos à análise de uma situação-problema..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição conceitual e contextualização histórica",
    "{{autor_principal}}: vida, obra e principais contribuições ao tema",
    "Conceitos-chave: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
    "Desdobramentos contemporâneos: {{tema_no_seculo_xxi}}",
    "Conexões interdisciplinares: {{conexao_sociologia}}, {{conexao_historia}}"
  ],
  "textos_filosoficos": [
    {
      "autor": "{{autor_principal}}",
      "obra": "{{obra}}",
      "trecho_selecionado": "{{trecho_confirmado_na_base_rag}}",
      "orientacao_leitura": "Identifique a tese central do autor e os argumentos que a sustentam. Relacione com {{tema_da_aula}}."
    }
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora para engajar os alunos na reflexão filosófica...",
      "estrategia": "Pergunta provocadora / dilema ético / charge ou tirinha filosófica / vídeo curto (3-5 min) / experimento mental"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de leitura, análise, debate e/ou produção textual...",
      "etapas": [
        {
          "titulo": "Leitura e Análise de Texto Filosófico",
          "descricao": "Leitura compartilhada do trecho selecionado com mediação do professor, identificando conceitos-chave, tese e argumentos...",
          "recurso": "Trecho impresso / projetado do texto de {{autor_principal}}"
        },
        {
          "titulo": "Problematização e Debate",
          "descricao": "Discussão estruturada em grupos sobre a aplicação do conceito a um problema contemporâneo. Cada grupo formula uma posição fundamentada...",
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
      "estrategia": "Mapa conceitual colaborativo / ticket de saída com pergunta filosófica / síntese oral em dupla"
    }
  },
  "recursos_didaticos": [
    "Trecho impresso/projetado de {{obra}} ({{autor_principal}})",
    "Quadro branco e marcadores para mapa conceitual",
    "Projetor multimídia para {{recurso_visual}}",
    "Roteiro de debate com perguntas orientadoras"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação qualificada na discussão (uso de conceitos filosóficos)",
      "Identificação correta da tese e dos argumentos no texto lido",
      "Clareza e fundamentação na produção textual argumentativa",
      "Respeito à pluralidade de perspectivas durante o debate"
    ],
    "instrumentos": [
      "Observação da participação no debate com rubrica",
      "Análise do texto argumentativo produzido (critérios: tese, argumentação, uso de conceitos)",
      "Ticket de saída com pergunta-síntese"
    ]
  },
  "conexao_enem": {
    "competencia_area": "C1 — Compreender os elementos culturais que constituem as identidades",
    "habilidade_enem": "{{habilidade_enem_correspondente}}",
    "tipo_questao_enem": "Análise de texto filosófico seguida de questão de múltipla escolha sobre tese/conceito central",
    "dica_enem": "No ENEM, questões de Filosofia frequentemente apresentam um trecho de obra clássica e perguntam sobre a ideia central defendida pelo autor. Treine a identificação de teses e a diferenciação entre conceitos de autores diferentes."
  },
  "referencias": [
    {
      "tipo": "Obra filosófica",
      "autor": "{{autor_principal}}",
      "titulo": "{{obra}}",
      "confirmado_rag": true
    },
    {
      "tipo": "Livro didático PNLD",
      "titulo": "{{livro_pnld}}",
      "capitulo": "{{capitulo}}"
    },
    {
      "tipo": "BNCC",
      "codigo": "{{codigo_bncc}}"
    }
  ],
  "observacoes": "{{observacoes_adicionais}}"
}
```
