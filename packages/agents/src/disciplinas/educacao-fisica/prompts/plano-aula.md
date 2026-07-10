# Template de Prompt — Plano de Aula (Educação Física)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Educação Física seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR REGRAS ESPORTIVAS OU EXERCÍCIOS SEM BASE.** Toda
referência a regras esportivas, técnicas de execução de exercícios,
fundamentos táticos ou protocolos de treinamento DEVE ser verificável na
base RAG. Se não tiver certeza de uma informação, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Educação Física
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Unidade Temática:** {{unidade_tematica}} (Brincadeiras e Jogos / Esportes / Ginásticas / Danças / Lutas / Práticas Corporais de Aventura)
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Materiais de Referência (base RAG):** {{referencias_rag}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Educação Física",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "unidade_tematica": "{{unidade_tematica}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}",
    "local": "{{local_aula}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF67EF01",
      "descricao": "Experimentar e fruir diferentes brincadeiras e jogos..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender as regras básicas do esporte/modalidade estudada...",
    "Executar os fundamentos técnicos com progressão pedagógica adequada...",
    "Demonstrar atitude cooperativa e respeito às regras durante a prática..."
  ],
  "conteudos_programaticos": [
    "Conceito: {{conceito_principal}}",
    "Regras oficiais (versão simplificada para a faixa etária): {{regras}}",
    "Fundamentos técnicos: {{fundamentos}}",
    "Contexto histórico e cultural: {{contexto}}"
  ],
  "materiais_necessarios": [
    "{{material_1}} (alternativa de baixo custo: {{alternativa_1}})",
    "{{material_2}} (alternativa de baixo custo: {{alternativa_2}})"
  ],
  "preparacao_previa": [
    "Verificar condições de segurança do espaço: piso, obstáculos, iluminação",
    "Separar e conferir materiais: {{lista_materiais}}",
    "Preparar playlist/áudio (se necessário): {{playlist}}"
  ],
  "desenvolvimento_aula": {
    "momento_1_aquecimento": {
      "duracao_minutos": 10,
      "descricao": "Atividades de aquecimento geral e específico para a modalidade.",
      "atividades": [
        "Corrida leve em deslocamento variado (frente, costas, lateral)",
        "Mobilidade articular: rotação de ombros, quadril, tornozelos",
        "Alongamento dinâmico: {{alongamentos_especificos}}",
        "Jogo/brincadeira de ativação: {{jogo_aquecimento}}"
      ],
      "orientacoes_seguranca": [
        "Respeitar o ritmo individual de cada aluno",
        "Alunos com restrições médicas: {{adaptacao_aquecimento}}"
      ]
    },
    "momento_2_parte_principal": {
      "duracao_minutos": 25,
      "descricao": "Vivência prática do conteúdo com progressão pedagógica.",
      "sequencia_didatica": [
        {
          "etapa": 1,
          "nome": "{{etapa1_nome}}",
          "duracao_minutos": 10,
          "descricao": "{{etapa1_descricao}}",
          "comando_professor": "{{comando_professor_etapa1}}",
          "feedback_esperado": "{{feedback_etapa1}}"
        },
        {
          "etapa": 2,
          "nome": "{{etapa2_nome}}",
          "duracao_minutos": 10,
          "descricao": "{{etapa2_descricao}}",
          "comando_professor": "{{comando_professor_etapa2}}",
          "feedback_esperado": "{{feedback_etapa2}}"
        },
        {
          "etapa": 3,
          "nome": "Jogo/Atividade de aplicação",
          "duracao_minutos": 5,
          "descricao": "Situação de jogo adaptado ou atividade integradora.",
          "regras_adaptadas": "{{regras_adaptadas}}",
          "variacao_dificuldade": "{{variacao_para_aumentar_ou_diminuir_dificuldade}}"
        }
      ],
      "adaptacao_pdi": "{{adaptacao_para_alunos_com_deficiencia}}",
      "adaptacao_niveis_habilidade": "{{adaptacao_para_diferentes_niveis}}",
      "orientacoes_seguranca": [
        "Supervisionar execução correta dos movimentos",
        "Interromper atividade se houver risco de lesão",
        "Hidratação: pausa para água a cada 15 min"
      ]
    },
    "momento_3_volta_calma": {
      "duracao_minutos": 15,
      "descricao": "Alongamento, relaxamento e reflexão sobre a aula.",
      "atividades": [
        "Alongamento estático dos principais grupos musculares",
        "Exercício respiratório: inspiração profunda e expiração lenta",
        "Roda de conversa: o que aprendemos hoje?"
      ],
      "perguntas_reflexivas": [
        "Qual foi a parte mais desafiadora da aula?",
        "Como você lidou com as dificuldades encontradas?",
        "O que você aprendeu sobre cooperação e respeito às regras?"
      ]
    }
  },
  "avaliacao": {
    "tipo": "Formativa — observação do processo",
    "criterios": [
      "Participação ativa em todas as etapas da aula",
      "Execução dos fundamentos com progressão adequada",
      "Atitude cooperativa e respeito aos colegas",
      "Compreensão das regras básicas e aplicação no jogo"
    ],
    "rubrica": {
      "excelente": "Participa ativamente, executa os fundamentos com qualidade e coopera com o grupo",
      "satisfatorio": "Participa e executa os fundamentos com necessidade de correções pontuais",
      "em_desenvolvimento": "Participa parcialmente, necessita de incentivo e correções frequentes"
    }
  },
  "referencias": [
    {
      "tipo": "Base RAG",
      "descricao": "Regras oficiais, fundamentos e contexto histórico",
      "fonte_rag": "{{fonte_confirmada}}"
    },
    {
      "tipo": "Livro didático",
      "titulo": "{{livro_pnld}}",
      "paginas": "{{paginas}}"
    }
  ],
  "tarefa_casa": "{{tarefa_casa}}"
}
```
