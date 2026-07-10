# Template de Prompt — Plano de Aula (Língua Inglesa)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Língua Inglesa seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

**ATENÇÃO:** NUNCA invente palavras em inglês. Toda palavra ou expressão em
inglês deve ser real e verificável em dicionários reconhecidos (Oxford,
Cambridge, Merriam-Webster, Collins).

## PARÂMETROS DE ENTRADA

- **Disciplina:** Língua Inglesa
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
    "disciplina": "Língua Inglesa",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF06LI01",
      "descricao": "Interagir em situações de intercâmbio oral, demonstrando iniciativa para utilizar a língua inglesa."
    }
  ],
  "objetivos_aprendizagem": [
    "Identificar o vocabulário relacionado ao tema... em textos orais e escritos.",
    "Utilizar as estruturas gramaticais... em situações comunicativas simples.",
    "Produzir um pequeno texto/diálogo em inglês sobre o tema...",
    "Reconhecer aspectos culturais relacionados ao tema em países anglófonos."
  ],
  "conteudos_programaticos": {
    "vocabulary": [
      "{{topico_vocabulario_1}}",
      "{{topico_vocabulario_2}}"
    ],
    "grammar": [
      "{{estrutura_gramatical}}"
    ],
    "functions": [
      "{{funcao_comunicativa}}"
    ],
    "genre": "{{genero_textual}}"
  },
  "desenvolvimento": {
    "warm_up": {
      "duracao_min": 5,
      "descricao": "Atividade de aquecimento para ativar conhecimentos prévios e engajar os alunos no tema da aula.",
      "estrategia": "Pergunta disparadora / imagem / música / jogo rápido",
      "interacao": "Turma toda / Professor-alunos"
    },
    "presentation": {
      "duracao_min": 15,
      "descricao": "Apresentação do novo conteúdo (vocabulário, estrutura gramatical, gênero textual) de forma contextualizada.",
      "estrategia": "Exposição dialogada com apoio visual / slides / flashcards / vídeo curto",
      "recursos": ["Projetor multimídia", "Slides preparados", "Quadro branco"]
    },
    "practice": {
      "duracao_min": 20,
      "descricao": "Atividades de prática controlada e semi-controlada para fixação do conteúdo.",
      "etapas": [
        {
          "titulo": "Prática Controlada",
          "descricao": "Exercícios de lacuna, associação, ordenação de frases...",
          "interacao": "Individual / Duplas"
        },
        {
          "titulo": "Prática Semi-Controlada",
          "descricao": "Diálogo guiado, entrevista com colegas, jogo comunicativo...",
          "interacao": "Duplas / Pequenos grupos"
        }
      ]
    },
    "production": {
      "duracao_min": 10,
      "descricao": "Atividade de produção livre onde os alunos usam o conteúdo aprendido de forma criativa e pessoal.",
      "estrategia": "Role-play / Produção de texto curto / Apresentação oral / Criação de cartaz",
      "interacao": "Duplas / Grupos / Individual"
    }
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Caixas de som",
    "Quadro branco e marcadores",
    "Folha de atividade impressa",
    "{{recurso_digital}} (Quizlet / Kahoot / Wordwall)"
  ],
  "avaliacao": {
    "criterios": [
      "Compreensão do vocabulário e estruturas trabalhadas.",
      "Participação nas atividades orais.",
      "Uso adequado da língua inglesa na produção final."
    ],
    "instrumentos": [
      "Observação da participação durante a aula.",
      "Correção da atividade escrita.",
      "Rubrica de avaliação da produção oral/escrita."
    ]
  },
  "adaptacoes_inclusao": [
    "Disponibilizar vocabulário com apoio visual (imagens) para alunos com dificuldade de leitura.",
    "Oferecer tempo adicional para realização das atividades escritas.",
    "Permitir resposta oral em vez de escrita para alunos com necessidades específicas.",
    "Utilizar fonte ampliada e alto contraste em materiais impressos."
  ],
  "tarefa_casa": {
    "descricao": "Atividade de fixação ou preparação para a próxima aula.",
    "prazo": "Próxima aula"
  }
}
```

## OBSERVAÇÕES

- O campo `vocabulary` deve conter APENAS palavras e expressões reais da língua
  inglesa, com tradução ou definição em português.
- As estruturas gramaticais (`grammar`) devem ser apresentadas de forma
  contextualizada, NUNCA como regras isoladas.
- O `warm_up` deve ser leve e motivador, criando um ambiente positivo para o
  uso da língua inglesa.
- Para o Ensino Médio, a `production` deve incluir, sempre que possível,
  conexão com o formato de questões do ENEM (interpretação de textos em inglês).
