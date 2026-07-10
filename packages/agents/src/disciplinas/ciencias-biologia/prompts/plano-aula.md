# Template de Prompt — Plano de Aula (Ciências/Biologia)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Ciências (EF) ou Biologia (EM) seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR EXPERIMENTOS OU DADOS CIENTÍFICOS.** Toda informação
científica deve ser verificável. Se não tiver certeza de um dado, indique
`[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** {{disciplina}} (Ciências ou Biologia)
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Recursos de Laboratório Disponíveis:** {{recursos_lab}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "{{disciplina}}",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF06CI01",
      "descricao": "Classificar como homogênea ou heterogênea a mistura de dois ou mais materiais..."
    }
  ],
  "objetivos_aprendizagem": [
    "Identificar as principais características do fenômeno/conceito estudado...",
    "Realizar procedimento investigativo para testar hipóteses sobre...",
    "Relacionar o conhecimento científico estudado com situações do cotidiano..."
  ],
  "conteudos_programaticos": [
    "Conceito-chave: {{conceito}}",
    "Fundamentação científica: {{fundamentacao}}",
    "Aplicações no cotidiano: {{aplicacoes}}"
  ],
  "questao_investigativa": "{{pergunta_norteadora}} — questão que desperta a curiosidade e orienta a investigação da aula.",
  "desenvolvimento": {
    "introducao": {
      "duracao_min": 10,
      "descricao": "Atividade de sensibilização / levantamento de conhecimentos prévios / pergunta disparadora...",
      "estrategia": "Demonstração instigante / pergunta problematizadora / imagem ou vídeo curto / fenômeno do cotidiano"
    },
    "investigacao_experimentacao": {
      "duracao_min": 30,
      "descricao": "Atividade principal de investigação científica ou experimentação...",
      "etapas": [
        {
          "titulo": "Levantamento de Hipóteses",
          "descricao": "Os alunos, em grupos, formulam hipóteses sobre o problema investigativo. O professor registra no quadro...",
          "recurso": "Quadro branco / caderno de ciências"
        },
        {
          "titulo": "Experimentação / Investigação",
          "descricao": "Os grupos realizam o experimento ou atividade investigativa seguindo roteiro fornecido. Registram observações sistematicamente...",
          "recurso": "Kit experimental: {{materiais}}. Consultar precauções de segurança.",
          "precaucoes_seguranca": [
            "{{precaucao_1}}",
            "{{precaucao_2}}"
          ]
        },
        {
          "titulo": "Análise e Discussão dos Resultados",
          "descricao": "Cada grupo compartilha suas observações e conclusões. O professor medeia a discussão, confrontando hipóteses iniciais com resultados...",
          "recurso": "Quadro para sistematização coletiva"
        }
      ]
    },
    "sistematizacao": {
      "duracao_min": 10,
      "descricao": "Síntese coletiva conectando o experimento com o conceito científico e com o cotidiano...",
      "estrategia": "Ticket de saída: 'O que você aprendeu hoje que explica algo do seu dia a dia?' / Registro no caderno de ciências com desenho esquemático"
    }
  },
  "recursos_didaticos": [
    "{{recurso_1}}",
    "{{recurso_2}}",
    "{{recurso_3}}"
  ],
  "avaliacao": {
    "criterios": [
      "Formulação de hipóteses coerentes com o problema (peso 2)",
      "Registro sistemático de observações durante o experimento (peso 3)",
      "Participação na discussão coletiva e argumentação fundamentada (peso 2)",
      "Registro final no caderno de ciências com conclusão e desenho esquemático (peso 3)"
    ],
    "instrumento": "Observação + Caderno de Ciências + Rubrica de participação em atividade investigativa"
  },
  "adaptacoes_inclusao": [
    "{{adaptacao_1}}",
    "{{adaptacao_2}}"
  ],
  "referencias_cientificas": [
    {
      "tipo": "Livro didático",
      "referencia": "{{referencia_pnld}}"
    },
    {
      "tipo": "Artigo/Site científico",
      "referencia": "{{referencia_adicional}}"
    }
  ]
}
```
