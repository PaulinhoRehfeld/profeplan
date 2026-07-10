# Template de Prompt — Plano de Aula (Química)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Química seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
reações químicas ou fórmulas moleculares.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Química
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
    "disciplina": "Química",
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
    "Compreender o conceito de {{conceito_quimico}} e sua representação simbólica (fórmulas, equações)...",
    "Aplicar os princípios da Química na resolução de situações-problema contextualizadas...",
    "Realizar procedimento experimental para investigar {{fenomeno_quimico}} com segurança...",
    "Relacionar o conteúdo com aplicações tecnológicas e o cotidiano..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição, representação (fórmula/equação) e propriedades",
    "Leis e princípios químicos associados: {{leis_quimicas}}",
    "Cálculos e relações quantitativas: {{cálculos}}",
    "Aplicações no cotidiano e na indústria: {{contexto_aplicacao}}"
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora ou demonstração experimental rápida para engajar os alunos...",
      "estrategia": "Pergunta investigativa / experimento demonstrativo / vídeo curto de fenômeno químico"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de investigação, experimentação e/ou resolução de problemas...",
      "etapas": [
        {
          "titulo": "Exploração do Fenômeno",
          "descricao": "Apresentação do conceito com demonstração experimental ou simulação computacional...",
          "recurso": "Simulação PhET/MolView / experimento demonstrativo / quadro branco"
        },
        {
          "titulo": "Modelagem e Prática Guiada",
          "descricao": "Representação do fenômeno (equações, fórmulas) e resolução de problemas em duplas com mediação do professor...",
          "recurso": "Folha de atividades / livro didático p. XX / tabela periódica / calculadora científica"
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
    "objetivo": "Investigar experimentalmente {{fenomeno_quimico}}...",
    "materiais": [
      "{{material_1}} (baixo custo / uso doméstico)",
      "{{material_2}}",
      "{{material_3}}"
    ],
    "procedimento": [
      "1. Organizar os materiais e verificar a segurança do ambiente...",
      "2. Realizar o experimento conforme roteiro, observando {{evidencia_reacao}}...",
      "3. Registrar as observações (cor, liberação de gás, formação de precipitado, variação de temperatura)...",
      "4. Analisar os resultados e comparar com o modelo teórico (equação química)..."
    ],
    "seguranca": "{{orientacoes_seguranca}} — Uso obrigatório de óculos de proteção, luvas e avental. Realizar em local ventilado. Descartar resíduos conforme orientação."
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Quadro branco e marcadores",
    "Tabela Periódica (individual e de parede)",
    "Simulação PhET/MolView: {{simulacao}}",
    "Materiais para experimento (lista acima)",
    "Livro didático, páginas XX-YY",
    "Calculadora científica"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Compreensão do conceito químico e sua representação simbólica",
      "Capacidade de aplicar leis e princípios da Química na resolução de problemas",
      "Habilidade na condução do experimento com segurança e na análise dos dados",
      "Capacidade de comunicar o raciocínio químico (oral e escrito)",
      "Participação e engajamento nas atividades"
    ],
    "instrumento": "Observação direta com rubrica / relatório experimental / resolução de problemas no quadro"
  },
  "adaptacoes_inclusao": {
    "deficiencia_visual": "Descrição verbal detalhada de fórmulas e equações / experimentos com feedback tátil, sonoro e olfativo / modelos moleculares em relevo...",
    "deficiencia_auditiva": "Instruções escritas detalhadas / legendas em vídeos / roteiros de experimento ilustrados...",
    "tdah": "Dividir experimentos em etapas curtas com checkpoints visuais / alternar momentos de atenção focada e prática / rótulos coloridos nos reagentes...",
    "dislexia": "Enunciados com fonte ampliada e espaçamento maior / leitura compartilhada / fórmulas e equações destacadas visualmente...",
    "altas_habilidades": "Problemas-desafio adicionais com maior complexidade / exploração de extensões do tema (Química Verde, aplicações industriais, síntese orgânica)..."
  },
  "conexoes_interdisciplinares": [
    {
      "disciplina": "Matemática",
      "conexao": "Proporções e regra de três nos cálculos estequiométricos / funções e logaritmos no pH e pOH..."
    },
    {
      "disciplina": "Física",
      "conexao": "{{conexao_fisica}}"
    },
    {
      "disciplina": "Biologia",
      "conexao": "{{conexao_biologia}}"
    }
  ],
  "tarefa_casa": "Resolver a lista de problemas de fixação (p. XX do livro) e elaborar um parágrafo relacionando o conteúdo da aula com uma situação do cotidiano (ex.: produto de limpeza, alimento, medicamento)."
}
```

## OBSERVAÇÕES CRÍTICAS

- **NÃO** invente códigos BNCC, reações químicas ou fórmulas moleculares — use apenas os fornecidos nos parâmetros
- **SIM** adapte o plano ao ano/série indicado — complexidade progressiva (1ª série: Estrutura Atômica/Tabela Periódica/Ligações; 2ª: Funções Inorgânicas/Estequiometria/Soluções; 3ª: Orgânica/Termoquímica/Equilíbrio/Eletroquímica)
- **SIM** inclua adaptações para inclusão SEMPRE
- **SIM** especifique os minutos de cada etapa
- **SIM** sugira SEMPRE um experimento prático com materiais de baixo custo e reagentes seguros
- **VALORIZE A EXPERIMENTAÇÃO SEGURA** — a Química é uma ciência experimental, mas a segurança é INEGOCIÁVEL
- O campo `experimento_pratico` é OBRIGATÓRIO
- O campo `tarefa_casa` é OBRIGATÓRIO
- Inclua sempre questões no estilo ENEM, com contextualização e alternativas
- Conecte o conteúdo com aplicações cotidianas: alimentos, medicamentos, produtos de limpeza, combustíveis, plásticos, cosméticos
- **SEMPRE** forneça a equação química balanceada quando relevante (validada pela base RAG)
- **SEMPRE** inclua orientações de segurança e descarte de resíduos nos experimentos
