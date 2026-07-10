# Template de Prompt — Planejamento Trimestral (Língua Inglesa)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Língua Inglesa seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

**ATENÇÃO:** NUNCA invente palavras em inglês. Toda palavra ou expressão em
inglês deve ser real e verificável em dicionários reconhecidos (Oxford,
Cambridge, Merriam-Webster, Collins).

## PARÂMETROS DE ENTRADA

- **Disciplina:** Língua Inglesa
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
    "disciplina": "Língua Inglesa",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Compreender o funcionamento das diferentes linguagens e práticas culturais...",
      "fonte": "BNCC — Área de Linguagens"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "eixo": "Oralidade e Vocabulário",
      "habilidades_bncc": ["EF06LI01", "EF06LI02"],
      "objetos_conhecimento": {
        "functions": "{{funcao_comunicativa_mes1}}",
        "vocabulary": [
          "{{topico_vocabulario_1}}",
          "{{topico_vocabulario_2}}"
        ],
        "grammar": "{{estrutura_gramatical_mes1}}",
        "genre": "{{genero_textual_mes1}}"
      },
      "aulas_previstas": 12,
      "avaliacao_parcial": "{{instrumento_avaliativo_mes1}} (peso 3)"
    },
    "mes_2": {
      "eixo": "Leitura e Conhecimentos Linguísticos",
      "habilidades_bncc": ["EF06LI03", "EF06LI04"],
      "objetos_conhecimento": {
        "functions": "{{funcao_comunicativa_mes2}}",
        "vocabulary": [
          "{{topico_vocabulario_3}}",
          "{{topico_vocabulario_4}}"
        ],
        "grammar": "{{estrutura_gramatical_mes2}}",
        "genre": "{{genero_textual_mes2}}"
      },
      "aulas_previstas": 12,
      "avaliacao_parcial": "{{instrumento_avaliativo_mes2}} (peso 3)"
    },
    "mes_3": {
      "eixo": "Escrita e Dimensão Intercultural",
      "habilidades_bncc": ["EF06LI05", "EF06LI06"],
      "objetos_conhecimento": {
        "functions": "{{funcao_comunicativa_mes3}}",
        "vocabulary": [
          "{{topico_vocabulario_5}}",
          "{{topico_vocabulario_6}}"
        ],
        "grammar": "{{estrutura_gramatical_mes3}}",
        "genre": "{{genero_textual_mes3}}"
      },
      "aulas_previstas": 12,
      "avaliacao_parcial": "{{instrumento_avaliativo_mes3}} + prova escrita (peso 4)"
    }
  },
  "estrategias_metodologicas": [
    "Abordagem comunicativa com situações reais de uso da língua.",
    "Uso de músicas e vídeos autênticos como input linguístico.",
    "Jogos e atividades lúdicas para prática de vocabulário (Quizlet, Kahoot).",
    "Leitura de textos adaptados com estratégias de skimming e scanning.",
    "Role-plays e simulações de situações comunicativas."
  ],
  "projetos_interdisciplinares": [
    {
      "tema": "{{tema_projeto}}",
      "disciplinas_envolvidas": ["{{disciplina_1}}", "{{disciplina_2}}"],
      "produto_final": "{{produto_final}}",
      "descricao": "{{descricao_projeto}}"
    }
  ],
  "recursos_necessarios": [
    "Livro didático do PNLD",
    "Projetor multimídia e caixas de som",
    "Dicionários bilíngues (impressos ou digitais)",
    "Acesso à internet para atividades online",
    "Materiais impressos complementares"
  ],
  "cronograma_avaliacoes": {
    "avaliacao_diagnostica": {
      "periodo": "Início do trimestre",
      "descricao": "Sondagem do nível de proficiência dos alunos."
    },
    "avaliacao_formativa": {
      "periodo": "Ao longo do trimestre",
      "descricao": "Observação contínua, atividades em sala, tarefas de casa."
    },
    "avaliacao_somativa": {
      "periodo": "Final do trimestre",
      "descricao": "Prova escrita + projeto oral/escrito.",
      "valor": "{{valor_total}} pontos"
    }
  },
  "observacoes": [
    "As habilidades BNCC listadas devem ser verificadas na base documental fornecida.",
    "O vocabulário e as estruturas gramaticais devem ser apresentados de forma espiralada, retomando conteúdos anteriores.",
    "Para turmas de EM, incluir seção de estratégias de preparação para o ENEM."
  ]
}
```

## OBSERVAÇÕES

- O eixo "Dimensão Intercultural" deve estar presente em todos os meses, de
  forma transversal, e não concentrado apenas no terceiro mês.
- As funções comunicativas (`functions`) devem seguir progressão do mais
  simples para o mais complexo ao longo do trimestre.
- Para o Ensino Médio, substituir o terceiro eixo por "Interpretação de Textos
  e Preparação ENEM" e utilizar habilidades EM13LGG.
