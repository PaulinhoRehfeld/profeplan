# Template de Prompt — Avaliação (Ensino Religioso)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Ensino Religioso seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados sobre
religiões, doutrinas, textos sagrados ou códigos da BNCC.

**REGRA INEGOCIÁVEL:** A avaliação DEVE respeitar a laicidade do Estado.
PROIBIDO proselitismo religioso. PROIBIDO doutrinação. As questões NÃO
devem induzir o estudante a adotar ou rejeitar qualquer crença religiosa.
O foco é o CONHECIMENTO SOBRE as religiões, não a ADESÃO a qualquer uma
delas.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Ensino Religioso
- **Ano/Série:** {{ano_serie}}
- **Trimestre/Bimestre:** {{trimestre}}
- **Tipo de Avaliação:** {{tipo_avaliacao}} (Diagnóstica / Formativa / Somativa)
- **Habilidades BNCC a Avaliar:** {{habilidades_bncc}}
- **Conteúdos Trabalhados:** {{conteudos}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Número de Questões:** {{num_questoes}}
- **Valor Total:** {{valor_total}} pontos

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Ensino Religioso",
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
      "habilidade_bncc": "EF06ER01",
      "descritor": "Reconhecer o papel da tradição escrita na preservação de ensinamentos e valores nas diferentes tradições religiosas",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EF06ER02",
      "descritor": "Reconhecer e valorizar a diversidade de textos sagrados das diferentes tradições religiosas",
      "questoes_associadas": [3, 4]
    },
    {
      "habilidade_bncc": "EF06ER03",
      "descritor": "Reconhecer, em textos sagrados, ensinamentos e valores éticos que promovam o respeito à vida e à dignidade humana",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "Esta avaliação NÃO tem caráter religioso, confessional ou doutrinário. O objetivo é verificar seu CONHECIMENTO sobre as diferentes tradições religiosas e filosofias de vida estudadas.",
    "Respeite a diversidade de crenças. Suas respostas devem demonstrar conhecimento e respeito, independentemente de sua crença pessoal.",
    "Nas questões discursivas, fundamente sua resposta com base nos conteúdos estudados em sala de aula e nos textos de referência fornecidos.",
    "Não é necessário declarar sua crença pessoal em nenhuma questão. Avalia-se o conhecimento sobre o tema, não a fé.",
    "Use caneta azul ou preta. Não é permitido o uso de corretivo líquido.",
    "Revise sua prova antes de entregar. Boa avaliação!"
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_1}},
      "habilidade_bncc": "EF06ER01",
      "nivel_taxonomico": "Conhecimento",
      "contexto": "Textos sagrados — {{tradicao_1}}",
      "enunciado": "Os textos sagrados são importantes para as tradições religiosas porque:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{letra_correta}}",
      "justificativa_gabarito": "{{justificativa_confirmada_base_rag}}"
    },
    {
      "numero": 2,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao_2}},
      "habilidade_bncc": "EF06ER01",
      "nivel_taxonomico": "Compreensão",
      "contexto": "Diversidade de tradições religiosas",
      "texto_base": "{{trecho_confirmado_base_rag}}",
      "enunciado": "Com base no trecho, é correto afirmar que:",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{letra_correta}}",
      "justificativa_gabarito": "{{justificativa_confirmada_base_rag}}"
    },
    {
      "numero": 3,
      "tipo": "associacao",
      "valor": {{valor_questao_3}},
      "habilidade_bncc": "EF06ER02",
      "nivel_taxonomico": "Compreensão",
      "contexto": "Textos sagrados das diferentes tradições",
      "enunciado": "Associe cada tradição religiosa ao seu respectivo texto sagrado:",
      "coluna_a": [
        "{{tradicao_1}}",
        "{{tradicao_2}}",
        "{{tradicao_3}}",
        "{{tradicao_4}}"
      ],
      "coluna_b": [
        "{{texto_sagrado_1}}",
        "{{texto_sagrado_2}}",
        "{{texto_sagrado_3}}",
        "{{texto_sagrado_4}}"
      ],
      "gabarito": "{{sequencia_correta}}",
      "justificativa_gabarito": "Cada tradição religiosa possui seus próprios textos sagrados que registram ensinamentos, valores e a história daquela tradição."
    },
    {
      "numero": 4,
      "tipo": "verdadeiro_falso",
      "valor": {{valor_questao_4}},
      "habilidade_bncc": "EF06ER02",
      "nivel_taxonomico": "Análise",
      "contexto": "Respeito à diversidade de textos sagrados",
      "enunciado": "Analise as afirmações abaixo e classifique cada uma como VERDADEIRA (V) ou FALSA (F):",
      "afirmacoes": [
        {"texto": "{{afirmacao_1}}", "gabarito": "V"},
        {"texto": "{{afirmacao_2}}", "gabarito": "F"},
        {"texto": "{{afirmacao_3}}", "gabarito": "V"},
        {"texto": "{{afirmacao_4}}", "gabarito": "F"}
      ],
      "instrucao_extra": "Para as afirmações FALSAS, reescreva-as de forma correta no espaço indicado."
    },
    {
      "numero": 5,
      "tipo": "discursiva",
      "valor": {{valor_questao_5}},
      "habilidade_bncc": "EF06ER03",
      "nivel_taxonomico": "Síntese",
      "contexto": "Valores éticos nas tradições religiosas",
      "texto_base": "{{trecho_confirmado_base_rag}}",
      "enunciado": "A partir da leitura do trecho e dos conteúdos estudados em sala de aula, responda:",
      "itens": [
        {
          "letra": "a",
          "comando": "Identifique DOIS valores éticos presentes no trecho e explique como cada um deles contribui para a promoção do respeito à vida e à dignidade humana."
        },
        {
          "letra": "b",
          "comando": "Compare o ensinamento presente no trecho com um ensinamento semelhante de OUTRA tradição religiosa ou filosofia de vida estudada. Explique a semelhança."
        },
        {
          "letra": "c",
          "comando": "Em sua opinião, por que é importante conhecermos os valores éticos de diferentes tradições religiosas, mesmo que não sigamos nenhuma delas? Justifique."
        }
      ],
      "criterios_correcao": [
        "Identificação correta de dois valores éticos do trecho (1,0 ponto)",
        "Explicação clara de como cada valor contribui para o respeito à vida (1,0 ponto)",
        "Comparação pertinente com outra tradição estudada, demonstrando conhecimento (1,0 ponto)",
        "Reflexão pessoal coerente sobre a importância do conhecimento inter-religioso (1,0 ponto)",
        "Clareza, organização e uso adequado da norma culta (1,0 ponto)"
      ]
    }
  ],
  "gabarito_completo": {
    "questao_1": "{{letra_correta}}",
    "questao_2": "{{letra_correta}}",
    "questao_3": "{{sequencia_correta}}",
    "questao_4": "{{gabarito_vf}}",
    "questao_5": "Ver critérios de correção acima"
  },
  "adaptacoes": {
    "alunos_com_deficiencia": "{{adaptacoes_pdi}}",
    "alunos_com_dislexia": "Fonte ampliada, questões lidas em voz alta pelo professor, tempo adicional de 50%.",
    "diversidade_religiosa": "Nenhuma questão exige que o estudante declare sua crença pessoal. Todas as questões avaliam conhecimento sobre as tradições religiosas, não adesão a qualquer uma delas. Se algum estudante sentir-se constrangido por qualquer questão, deve comunicar ao professor."
  },
  "nota_importante": "Esta avaliação foi elaborada em conformidade com o princípio constitucional da LAICIDADE DO ESTADO (Art. 19, I, CF/88). NÃO contém proselitismo religioso nem doutrinação. Avalia-se o conhecimento sobre as tradições religiosas e filosofias de vida, não a fé ou crença pessoal do estudante."
}
```
