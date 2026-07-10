# Template de Prompt — Avaliação (Língua Inglesa)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Língua Inglesa seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

**ATENÇÃO:** NUNCA invente palavras em inglês. Toda palavra ou expressão em
inglês utilizada nas questões, alternativas, textos-base e gabaritos DEVE ser
real e verificável em dicionários reconhecidos (Oxford, Cambridge,
Merriam-Webster, Collins). Textos-base em inglês devem ser adaptados de fontes
reais ou construídos com vocabulário confirmado.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Língua Inglesa
- **Ano/Série:** {{ano_serie}}
- **Trimestre/Bimestre:** {{trimestre}}
- **Tipo de Avaliação:** {{tipo_avaliacao}} (Diagnóstica / Formativa / Somativa / Simulado)
- **Habilidades BNCC a Avaliar:** {{habilidades_bncc}}
- **Conteúdos Trabalhados:** {{conteudos}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Número de Questões:** {{num_questoes}}
- **Valor Total:** {{valor_total}} pontos

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Língua Inglesa",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "tipo_avaliacao": "{{tipo_avaliacao}}",
    "professor": "{{professor_nome}}",
    "data": "{{data}}",
    "valor_total": {{valor_total}},
    "tempo_estimado": "{{tempo_estimado}} minutos"
  },
  "matriz_referencia": [
    {
      "habilidade_bncc": "EF06LI01",
      "descritor": "Identificar o assunto de um texto em língua inglesa, reconhecendo sua organização textual e palavras cognatas.",
      "questoes_associadas": [1, 3]
    },
    {
      "habilidade_bncc": "EF06LI02",
      "descritor": "Localizar informações específicas em um texto em língua inglesa.",
      "questoes_associadas": [2]
    },
    {
      "habilidade_bncc": "EF06LI03",
      "descritor": "Inferir o sentido de palavras e expressões em língua inglesa com base no contexto.",
      "questoes_associadas": [4, 5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "As questões devem ser respondidas à caneta azul ou preta.",
    "Não é permitido o uso de dicionário ou tradutor eletrônico, salvo indicação expressa.",
    "Não é permitido o uso de corretivo líquido.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06LI01",
      "nivel_taxonomico": "Compreensão",
      "comando_pt": "De acordo com o texto, qual é o assunto principal abordado?",
      "comando_en": "",
      "texto_base_en": "{{texto_base_em_ingles}}",
      "glossario": [
        {"palavra_en": "{{palavra_dificil_1}}", "traducao_pt": "{{traducao_1}}"},
        {"palavra_en": "{{palavra_dificil_2}}", "traducao_pt": "{{traducao_2}}"}
      ],
      "alternativas": [
        {"letra": "A", "texto_pt": "{{alternativa_a}}"},
        {"letra": "B", "texto_pt": "{{alternativa_b}}"},
        {"letra": "C", "texto_pt": "{{alternativa_c}}"},
        {"letra": "D", "texto_pt": "{{alternativa_d}}"},
        {"letra": "E", "texto_pt": "{{alternativa_e}}"}
      ],
      "gabarito": "A",
      "justificativa_gabarito": "O texto aborda... conforme evidenciado no trecho '...'."
    },
    {
      "numero": 2,
      "tipo": "verdadeiro_falso",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06LI02",
      "nivel_taxonomico": "Compreensão",
      "comando_pt": "Com base no texto, classifique as afirmações abaixo como verdadeiras (V) ou falsas (F).",
      "afirmacoes": [
        {
          "texto_pt": "{{afirmacao_1}}",
          "gabarito": "V",
          "justificativa": "O texto afirma que..."
        },
        {
          "texto_pt": "{{afirmacao_2}}",
          "gabarito": "F",
          "justificativa": "O texto afirma o contrário, que..."
        }
      ]
    },
    {
      "numero": 3,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06LI03",
      "nivel_taxonomico": "Análise",
      "comando_pt": "Explique, em português, qual é a mensagem principal do texto e como o autor a transmite. Cite pelo menos uma palavra ou expressão em inglês do texto para justificar sua resposta.",
      "texto_base_en": "{{texto_base_em_ingles}}",
      "criterios_correcao": [
        "Identificação correta da mensagem principal (40%).",
        "Uso de evidências do texto em inglês (30%).",
        "Clareza e organização da resposta (30%)."
      ],
      "resposta_esperada": "A mensagem principal do texto é... O autor utiliza expressões como '...' para transmitir essa ideia."
    }
  ],
  "gabarito": {
    "questao_1": "A",
    "questao_2": ["V", "F"],
    "questao_3": "Ver critérios de correção."
  },
  "tabela_pontuacao": [
    {"questao": 1, "valor": {{valor_q1}}},
    {"questao": 2, "valor": {{valor_q2}}},
    {"questao": 3, "valor": {{valor_q3}}}
  ]
}
```

## OBSERVAÇÕES

- Para o Ensino Fundamental (6º e 7º ano), o comando das questões deve ser em
  português. O texto-base pode ser em inglês com glossário de apoio.
- Para o Ensino Fundamental (8º e 9º ano), o comando pode ser bilingue ou em
  inglês simplificado, com glossário reduzido.
- Para o Ensino Médio, o comando e o texto-base devem ser integralmente em
  inglês, simulando o formato de questões do ENEM.
- O campo `glossario` deve conter APENAS traduções reais e precisas. Não
  invente definições.
- Para provas do tipo "Simulado", incluir 5 questões de múltipla escolha no
  formato ENEM (texto em inglês, alternativas em português).
- As questões devem contemplar diferentes níveis taxonômicos: Compreensão,
  Aplicação, Análise.
- Incluir ao menos uma questão que mobilize a Dimensão Intercultural (reflexão
  sobre aspectos culturais de países anglófonos).
