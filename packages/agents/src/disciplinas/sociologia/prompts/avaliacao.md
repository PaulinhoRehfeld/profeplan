# Template de Prompt — Avaliação (Sociologia)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Sociologia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados
sociológicos, estatísticas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Sociologia
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
    "disciplina": "Sociologia",
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
      "habilidade_bncc": "EM13CHS101",
      "descritor": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias sociológicas",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EM13CHS102",
      "descritor": "Identificar, analisar e discutir as circunstâncias históricas, geográficas, políticas, econômicas, sociais, ambientais e culturais de matrizes conceituais",
      "questoes_associadas": [3, 4]
    },
    {
      "habilidade_bncc": "EM13CHS103",
      "descritor": "Elaborar hipóteses, selecionar evidências e compor argumentos relativos a processos políticos, econômicos, sociais, ambientais, culturais e epistemológicos",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "Nas questões discursivas, fundamente sua resposta com conceitos e teorias sociológicas. Respostas sem fundamentação terão pontuação reduzida.",
    "A redação do texto dissertativo-argumentativo deve seguir a norma culta da língua portuguesa.",
    "Na análise de gráficos e tabelas, identifique a fonte, o período e as variáveis antes de responder.",
    "É permitida a consulta apenas ao caderno de anotações de aula. Não é permitido o uso de qualquer outro material de consulta.",
    "Citações de autores devem ser acompanhadas da referência à obra (título e, se possível, capítulo ou seção).",
    "Dados estatísticos citados na prova foram extraídos de fontes oficiais (IBGE, IPEA, etc.). Utilize-os como evidência em suas argumentações.",
    "Use caneta azul ou preta. Não é permitido o uso de corretivo líquido.",
    "Revise sua prova antes de entregar. Boa avaliação!"
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_1}},
      "habilidade_bncc": "EM13CHS101",
      "nivel_taxonomico": "Compreensão",
      "comando": "Leia o trecho a seguir e responda à questão.",
      "texto_base": "{{trecho_sociologico_confirmado_base_rag}}",
      "contexto": "Sociologia {{tradicao}} — {{autor}} — {{conceito_central}}",
      "enunciado": "Com base no trecho, é correto afirmar que o autor defende a ideia de que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 2,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_2}},
      "habilidade_bncc": "EM13CHS101",
      "nivel_taxonomico": "Análise",
      "comando": "Analise as afirmativas a seguir sobre {{tema_sociologico}}.",
      "contexto": "{{tradicao}} — {{conceito_central}} — Conexão com o presente",
      "enunciado": "Considerando o pensamento de {{autor}} sobre {{tema}}, assinale a alternativa correta:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 3,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_3}},
      "habilidade_bncc": "EM13CHS102",
      "nivel_taxonomico": "Aplicação",
      "comando": "Observe o gráfico a seguir sobre {{indicador_social}} e responda.",
      "imagem_grafico": "{{descricao_grafico_confirmado_base_rag}}",
      "fonte_dado": "{{fonte_confirmada_base_rag}}",
      "contexto": "Indicadores sociais — {{tema}} — Brasil contemporâneo",
      "enunciado": "A partir da análise do gráfico e considerando os conhecimentos sociológicos sobre {{tema}}, é correto afirmar que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 4,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_4}},
      "habilidade_bncc": "EM13CHS102",
      "nivel_taxonomico": "Análise",
      "comando": "Compare as duas perspectivas sociológicas apresentadas nos trechos a seguir.",
      "texto_base_1": "{{trecho_1_confirmado_base_rag}}",
      "texto_base_2": "{{trecho_2_confirmado_base_rag}}",
      "contexto": "{{autor_1}} × {{autor_2}} — {{tema_comparacao}}",
      "enunciado": "Os trechos revelam duas perspectivas sociológicas distintas sobre {{tema}}. Sobre essas abordagens, é correto afirmar que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "alternativa_correta": "{{letra_correta}}",
      "justificativa": "{{justificativa_gabarito}}"
    },
    {
      "numero": 5,
      "tipo": "discursiva",
      "valor": {{valor_questao_5}},
      "habilidade_bncc": "EM13CHS103",
      "nivel_taxonomico": "Síntese/Avaliação",
      "comando": "Com base nos textos de apoio e em seus conhecimentos sociológicos, redija um texto dissertativo-argumentativo respondendo à questão proposta.",
      "textos_motivadores": [
        {
          "fonte": "{{fonte_1}}",
          "trecho": "{{texto_1_confirmado_base_rag}}"
        },
        {
          "fonte": "{{fonte_2}}",
          "dado": "{{dado_2_confirmado_base_rag}}"
        }
      ],
      "enunciado": "Considerando que {{contexto_problema}}, discuta como {{conceito_sociologico_1}} e {{conceito_sociologico_2}} podem contribuir para a compreensão desse fenômeno social. Em sua resposta: (a) defina os conceitos citados; (b) relacione-os com os textos motivadores; (c) apresente uma análise crítica fundamentada.",
      "criterios_correcao": [
        {"criterio": "Definição correta dos conceitos sociológicos", "pontuacao_maxima": {{pontos_criterio_1}}},
        {"criterio": "Articulação entre conceitos e textos motivadores", "pontuacao_maxima": {{pontos_criterio_2}}},
        {"criterio": "Argumentação crítica e fundamentada", "pontuacao_maxima": {{pontos_criterio_3}}},
        {"criterio": "Coerência, coesão e norma culta", "pontuacao_maxima": {{pontos_criterio_4}}},
        {"criterio": "Uso de evidências empíricas (dados, indicadores)", "pontuacao_maxima": {{pontos_criterio_5}}}
      ],
      "expectativa_resposta": "Espera-se que o(a) aluno(a) defina corretamente {{conceito_sociologico_1}} e {{conceito_sociologico_2}}, articulando-os com os textos motivadores e com o contexto brasileiro. Deve apresentar argumentos fundamentados que demonstrem compreensão das causas e consequências do fenômeno, utilizando dados ou exemplos concretos. A resposta deve evidenciar pensamento crítico e capacidade de relacionar teoria sociológica com realidade empírica."
    }
  ],
  "gabarito_comentado": {
    "questao_1": "{{letra_correta_q1}}. {{justificativa_detalhada_q1}}",
    "questao_2": "{{letra_correta_q2}}. {{justificativa_detalhada_q2}}",
    "questao_3": "{{letra_correta_q3}}. {{justificativa_detalhada_q3}}",
    "questao_4": "{{letra_correta_q4}}. {{justificativa_detalhada_q4}}",
    "questao_5": "Ver critérios de correção. {{expectativa_resposta_q5}}"
  },
  "tabela_pontuacao": {
    "distribuicao": [
      {"questao": 1, "tipo": "Múltipla escolha", "valor": {{valor_q1}}},
      {"questao": 2, "tipo": "Múltipla escolha", "valor": {{valor_q2}}},
      {"questao": 3, "tipo": "Múltipla escolha (gráfico)", "valor": {{valor_q3}}},
      {"questao": 4, "tipo": "Múltipla escolha (comparação)", "valor": {{valor_q4}}},
      {"questao": 5, "tipo": "Dissertativa", "valor": {{valor_q5}}}
    ],
    "nota_minima_aprovacao": "{{nota_corte}} pontos ({{percentual_corte}}%)"
  },
  "adaptacao_pdi": {
    "ampliacao_fonte": "Disponibilizar prova com fonte Arial 18 e espaçamento 1,5 para alunos com baixa visão",
    "tempo_adicional": "Acréscimo de 40% no tempo para alunos com dislexia, TDAH ou outras necessidades conforme plano individualizado",
    "ledor": "Disponibilizar ledor para alunos com deficiência visual ou dificuldades severas de leitura",
    "glossario": "Incluir glossário com definições dos principais conceitos sociológicos cobrados na prova",
    "simplificacao_enunciados": "Para alunos com deficiência intelectual: versão com enunciados simplificados e vocabulário controlado, mantendo os mesmos conceitos avaliados"
  }
}
```
