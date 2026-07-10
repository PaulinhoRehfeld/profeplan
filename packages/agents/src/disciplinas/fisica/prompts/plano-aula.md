# Template de Prompt — Plano de Aula (Física)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Física seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
fórmulas ou constantes físicas.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Física
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
    "disciplina": "Física",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EM13CNT101",
      "descricao": "Analisar e representar, com ou sem o uso de dispositivos e de aplicativos digitais específicos, as transformações e conservações em sistemas que envolvam quantidade de matéria, de energia e de movimento..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender o conceito de {{conceito_fisico}} e sua formulação matemática...",
    "Aplicar as leis da Física na resolução de situações-problema contextualizadas...",
    "Realizar procedimento experimental para investigar {{fenomeno_fisico}}...",
    "Relacionar o conteúdo com aplicações tecnológicas do cotidiano..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição, formulação matemática e unidades de medida",
    "Leis e princípios físicos associados: {{leis_fisicas}}",
    "Modelagem matemática do fenômeno: equações e relações",
    "Aplicações no cotidiano e na tecnologia: {{contexto_aplicacao}}"
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora ou demonstração experimental rápida para engajar os alunos...",
      "estrategia": "Pergunta investigativa / demonstração experimental / vídeo curto de fenômeno físico"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de investigação, experimentação e/ou resolução de problemas...",
      "etapas": [
        {
          "titulo": "Exploração do Fenômeno",
          "descricao": "Apresentação do conceito com demonstração experimental ou simulação computacional...",
          "recurso": "Simulação PhET / experimento demonstrativo / quadro branco"
        },
        {
          "titulo": "Modelagem e Prática Guiada",
          "descricao": "Formulação matemática do fenômeno e resolução de problemas em duplas com mediação do professor...",
          "recurso": "Folha de atividades / livro didático p. XX / calculadora científica"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Sistematização coletiva dos aprendizados, conexão com o cotidiano e registro no caderno...",
      "estrategia": "Mapa conceitual / discussão em grupo / ticket de saída com pergunta-conceito"
    }
  },
  "experimento_pratico": {
    "titulo": "{{titulo_experimento}}",
    "objetivo": "Investigar experimentalmente {{fenomeno_fisico}}...",
    "materiais": [
      "{{material_1}} (baixo custo / sucata)",
      "{{material_2}}",
      "{{material_3}}"
    ],
    "procedimento": [
      "1. Montar o arranjo experimental conforme orientação...",
      "2. Realizar medições de {{grandeza_fisica}}...",
      "3. Registrar os dados em tabela...",
      "4. Analisar os resultados e comparar com o modelo teórico..."
    ],
    "seguranca": "{{orientacoes_seguranca}}"
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Quadro branco e marcadores",
    "Simulação PhET: {{simulacao_phet}}",
    "Materiais para experimento (lista acima)",
    "Livro didático, páginas XX-YY",
    "Calculadora científica"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Compreensão do conceito físico e sua formulação matemática",
      "Capacidade de aplicar leis e princípios da Física na resolução de problemas",
      "Habilidade na condução do experimento e na análise dos dados",
      "Capacidade de comunicar o raciocínio físico (oral e escrito)",
      "Participação e engajamento nas atividades"
    ],
    "instrumento": "Observação direta com rubrica / relatório experimental / resolução de problemas no quadro"
  },
  "adaptacoes_inclusao": {
    "deficiencia_visual": "Descrição verbal detalhada de gráficos e figuras / experimentos com feedback tátil e sonoro / material em relevo para diagramas de forças...",
    "deficiencia_auditiva": "Instruções escritas detalhadas / legendas em vídeos / demonstrações visuais ampliadas...",
    "tdah": "Dividir experimentos em etapas curtas com checkpoints visuais / alternar momentos de atenção focada e prática...",
    "dislexia": "Enunciados com fonte ampliada e espaçamento maior / leitura compartilhada / fórmulas destacadas visualmente...",
    "altas_habilidades": "Problemas-desafio adicionais com maior complexidade matemática / exploração de extensões do tema (Física Moderna, aplicações avançadas)..."
  },
  "conexoes_interdisciplinares": [
    {
      "disciplina": "Matemática",
      "conexao": "Funções e gráficos na análise de movimentos / regra de três e proporções nas leis físicas..."
    },
    {
      "disciplina": "Química",
      "conexao": "{{conexao_quimica}}"
    },
    {
      "disciplina": "Biologia",
      "conexao": "{{conexao_biologia}}"
    }
  ],
  "tarefa_casa": "Resolver a lista de problemas de fixação (p. XX do livro) e elaborar um parágrafo relacionando o conteúdo da aula com uma situação do cotidiano."
}
```

## OBSERVAÇÕES CRÍTICAS

- **NÃO** invente códigos BNCC, fórmulas ou constantes físicas — use apenas os fornecidos nos parâmetros
- **SIM** adapte o plano ao ano/série indicado — complexidade progressiva (1ª série: Cinemática/Dinâmica; 2ª: Termologia/Óptica/Ondulatória; 3ª: Eletromagnetismo/Física Moderna)
- **SIM** inclua adaptações para inclusão SEMPRE
- **SIM** especifique os minutos de cada etapa
- **SIM** sugira SEMPRE um experimento prático com materiais de baixo custo
- **VALORIZE A MODELAGEM MATEMÁTICA** — a Física do EM exige domínio da linguagem matemática
- O campo `experimento_pratico` é OBRIGATÓRIO — a Física é uma ciência experimental
- O campo `tarefa_casa` é OBRIGATÓRIO
- Inclua sempre questões no estilo ENEM, com contextualização e alternativas
- Conecte o conteúdo com aplicações tecnológicas: celular, GPS, tomografia, usinas, veículos, etc.
