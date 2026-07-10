# Template de Prompt — Avaliação (Filosofia)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Filosofia seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
citações filosóficas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Filosofia
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
    "disciplina": "Filosofia",
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
      "descritor": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias filosóficas",
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
    "Nas questões discursivas, fundamente sua resposta com argumentos filosóficos. Respostas sem fundamentação terão pontuação reduzida.",
    "A redação do texto dissertativo-argumentativo deve seguir a norma culta da língua portuguesa.",
    "É permitida a consulta apenas ao caderno de anotações de aula. Não é permitido o uso de qualquer outro material de consulta.",
    "Citações de autores devem ser acompanhadas da referência à obra (título e, se possível, capítulo ou seção).",
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
      "texto_base": "{{trecho_filosofico_confirmado_base_rag}}",
      "contexto": "Filosofia {{periodo}} — {{autor}} — {{conceito_central}}",
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
      "comando": "Analise as afirmativas a seguir sobre {{tema_filosofico}}.",
      "contexto": "{{periodo}} — {{conceito_central}} — Conexão com o presente",
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
      "comando": "Leia o trecho a seguir e responda.",
      "texto_base": "{{trecho_filosofico_confirmado_base_rag}}",
      "contexto": "Ética — {{autor}} — Conceito de {{conceito_etico}}",
      "enunciado": "Aplicando o conceito de {{conceito_etico}} do autor à situação descrita abaixo, é correto concluir que:",
      "situacao_problema": "{{situacao_problema_contextualizada}}",
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
      "tipo": "discursiva",
      "valor": {{valor_questao_4}},
      "habilidade_bncc": "EM13CHS102",
      "nivel_taxonomico": "Análise",
      "comando": "Leia os dois trechos a seguir, de autores diferentes, sobre o mesmo tema filosófico.",
      "texto_base_1": "{{trecho_autor_1_confirmado_base_rag}}",
      "texto_base_2": "{{trecho_autor_2_confirmado_base_rag}}",
      "contexto": "{{tema}} — Comparação entre {{autor_1}} e {{autor_2}}",
      "enunciado": "Compare as posições dos dois autores sobre {{tema_filosofico}}, explicitando: (a) a tese central de cada um; (b) os principais argumentos utilizados; (c) os pontos de convergência e divergência entre eles.",
      "criterios_correcao": [
        {"criterio": "Identificação correta das teses de cada autor", "pontuacao_maxima": {{pts_criterio_1}}},
        {"criterio": "Explicitação dos argumentos principais de cada autor", "pontuacao_maxima": {{pts_criterio_2}}},
        {"criterio": "Comparação consistente (convergências e divergências)", "pontuacao_maxima": {{pts_criterio_3}}},
        {"criterio": "Clareza, coesão e uso adequado da norma culta", "pontuacao_maxima": {{pts_criterio_4}}}
      ],
      "resposta_esperada": "{{resposta_esperada_sintese}}"
    },
    {
      "numero": 5,
      "tipo": "dissertativa_argumentativa",
      "valor": {{valor_questao_5}},
      "habilidade_bncc": "EM13CHS103",
      "nivel_taxonomico": "Síntese",
      "comando": "Produza um texto dissertativo-argumentativo a partir da seguinte situação-problema e dos textos motivadores.",
      "situacao_problema": "{{situacao_problema_contemporanea}}",
      "textos_motivadores": [
        {
          "fonte": "{{autor_1}}, {{obra_1}}",
          "trecho": "{{trecho_motivador_1_confirmado_base_rag}}"
        },
        {
          "fonte": "{{autor_2}}, {{obra_2}}",
          "trecho": "{{trecho_motivador_2_confirmado_base_rag}}"
        }
      ],
      "tema_redacao": "{{tema_dissertacao}}",
      "instrucoes_redacao": [
        "Desenvolva o tema de forma dissertativo-argumentativa, utilizando os conhecimentos filosóficos adquiridos ao longo do trimestre.",
        "Fundamente sua argumentação com pelo menos dois conceitos ou autores filosóficos estudados.",
        "A redação deve ter no mínimo 20 linhas e no máximo 30 linhas.",
        "Atribua um título ao seu texto."
      ],
      "criterios_correcao": [
        {"criterio": "Tese clara e bem delimitada", "pontuacao_maxima": {{pts_criterio_1}}},
        {"criterio": "Argumentação fundamentada em conceitos/autores filosóficos", "pontuacao_maxima": {{pts_criterio_2}}},
        {"criterio": "Capacidade de relacionar conceitos filosóficos com a situação-problema", "pontuacao_maxima": {{pts_criterio_3}}},
        {"criterio": "Proposta de intervenção respeitando os direitos humanos (quando pertinente)", "pontuacao_maxima": {{pts_criterio_4}}},
        {"criterio": "Coesão, coerência e domínio da norma culta", "pontuacao_maxima": {{pts_criterio_5}}}
      ]
    }
  ],
  "gabarito": {
    "questao_1": "{{letra_correta_1}}",
    "questao_2": "{{letra_correta_2}}",
    "questao_3": "{{letra_correta_3}}",
    "questao_4": {
      "tipo": "discursiva",
      "elementos_obrigatorios_resposta": [
        "Tese de {{autor_1}}: {{sintese_tese_autor_1}}",
        "Tese de {{autor_2}}: {{sintese_tese_autor_2}}",
        "Convergência: {{ponto_convergencia}}",
        "Divergência: {{ponto_divergencia}}"
      ]
    },
    "questao_5": {
      "tipo": "dissertativa_argumentativa",
      "elementos_esperados": [
        "Tese que responda à situação-problema proposta",
        "Mobilização de pelo menos 2 conceitos/autores filosóficos pertinentes",
        "Argumentação consistente e bem encadeada",
        "Conclusão com retomada da tese e/ou proposta de intervenção"
      ]
    }
  },
  "tabela_pontuacao": {
    "questao_1": {"valor": {{valor_1}}, "tipo": "Múltipla escolha"},
    "questao_2": {"valor": {{valor_2}}, "tipo": "Múltipla escolha"},
    "questao_3": {"valor": {{valor_3}}, "tipo": "Múltipla escolha"},
    "questao_4": {"valor": {{valor_4}}, "tipo": "Discursiva"},
    "questao_5": {"valor": {{valor_5}}, "tipo": "Dissertativa-argumentativa"},
    "total": {{valor_total}}
  },
  "recuperacao": {
    "criterio": "Alunos com nota inferior a 60% do valor total",
    "atividade_recuperacao": "Releitura orientada dos textos filosóficos do trimestre + produção de texto dissertativo-argumentativo sobre tema relacionado aos conteúdos com maior dificuldade",
    "valor_maximo_recuperacao": "60% do valor total da avaliação original"
  },
  "conexao_enem": {
    "competencias_avaliadas": ["C1", "C5"],
    "questoes_modelo_enem": [1, 2, 3],
    "observacao": "As questões de múltipla escolha seguem o padrão ENEM: texto-base (frequentemente um trecho de obra filosófica) + comando interpretativo + 5 alternativas. As questões discursivas preparam para a redação do ENEM (competências I, II e III)."
  },
  "referencias": [
    {
      "tipo": "Fonte filosófica",
      "autor": "{{autor_referencia_1}}",
      "obra": "{{obra_referencia_1}}",
      "confirmado_rag": true
    },
    {
      "tipo": "Fonte filosófica",
      "autor": "{{autor_referencia_2}}",
      "obra": "{{obra_referencia_2}}",
      "confirmado_rag": true
    },
    {
      "tipo": "BNCC",
      "codigo": "{{codigo_bncc}}"
    }
  ]
}
```
