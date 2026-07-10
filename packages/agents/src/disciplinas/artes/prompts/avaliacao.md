# Template de Prompt — Avaliação (Artes)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Artes seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR OBRAS DE ARTE OU ARTISTAS.** Toda referência a obras
de arte, artistas, movimentos artísticos ou datas DEVE ser verificável na
base RAG. Se não tiver certeza de uma informação, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Artes
- **Ano/Série:** {{ano_serie}}
- **Trimestre/Bimestre:** {{trimestre}}
- **Tipo de Avaliação:** {{tipo_avaliacao}} (Diagnóstica / Formativa / Somativa / Simulado)
- **Linguagem Artística:** {{linguagem_artistica}} (Artes Visuais / Música / Dança / Teatro / Integradas)
- **Habilidades BNCC a Avaliar:** {{habilidades_bncc}}
- **Conteúdos Trabalhados:** {{conteudos}}
- **Obras e Artistas de Referência (base RAG):** {{referencias_rag}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Número de Questões:** {{num_questoes}}
- **Valor Total:** {{valor_total}} pontos

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Artes",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "tipo_avaliacao": "{{tipo_avaliacao}}",
    "linguagem_artistica": "{{linguagem_artistica}}",
    "professor": "{{professor_nome}}",
    "data": "{{data}}",
    "valor_total": {{valor_total}},
    "tempo_estimado": "{{tempo_estimado}} minutos"
  },
  "matriz_referencia": [
    {
      "habilidade_bncc": "EF69AR01",
      "descritor": "Pesquisar, apreciar e analisar formas distintas das artes visuais, cultivando a percepção, o imaginário e a capacidade de simbolizar",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EF69AR02",
      "descritor": "Pesquisar e analisar diferentes estilos visuais, contextualizando-os no tempo e no espaço",
      "questoes_associadas": [3, 4]
    }
  ],
  "instrucoes_gerais": [
    "Leia atentamente cada questão antes de responder.",
    "As questões de análise de obra exigem observação detalhada da imagem fornecida.",
    "Nas questões discursivas, argumente com base nos conteúdos estudados em sala.",
    "Não é permitido o uso de celular ou consulta a materiais não autorizados."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "objetiva",
      "formato": "ENEM",
      "valor": {{valor_questao_1}},
      "texto_base": "{{texto_base_questao1}}",
      "imagem": {
        "descricao": "{{descricao_imagem}}",
        "artista": "{{artista_imagem}}",
        "obra": "{{obra_imagem}}",
        "fonte_rag": "{{fonte_confirmada}}"
      },
      "enunciado": "{{enunciado_questao1}}",
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{gabarito_questao1}}",
      "habilidade_bncc": "EF69AR01"
    },
    {
      "numero": 2,
      "tipo": "discursiva",
      "valor": {{valor_questao_2}},
      "texto_base": "{{texto_base_questao2}}",
      "enunciado": "{{enunciado_questao2}}",
      "criterios_correcao": [
        {
          "criterio": "Identificação dos elementos formais da obra",
          "pontuacao_maxima": "{{pontuacao_c1}}"
        },
        {
          "criterio": "Contextualização histórica do movimento artístico",
          "pontuacao_maxima": "{{pontuacao_c2}}"
        },
        {
          "criterio": "Argumentação e uso de vocabulário técnico adequado",
          "pontuacao_maxima": "{{pontuacao_c3}}"
        }
      ],
      "resposta_esperada": "{{resposta_esperada}}",
      "habilidade_bncc": "EF69AR02"
    },
    {
      "numero": 3,
      "tipo": "pratica",
      "valor": {{valor_questao_3}},
      "enunciado": "{{enunciado_questao3}}",
      "descricao_atividade": "{{descricao_atividade_pratica}}",
      "materiais_permitidos": ["{{material_1}}", "{{material_2}}"],
      "tempo_execucao": "{{tempo_execucao}} minutos",
      "rubrica_avaliacao": {
        "criatividade_e_originalidade": {
          "peso": 30,
          "excelente": "Solução criativa e original, além do esperado",
          "satisfatorio": "Solução adequada, dentro do esperado",
          "em_desenvolvimento": "Solução básica, com necessidade de orientação"
        },
        "tecnica_e_execucao": {
          "peso": 30,
          "excelente": "Domínio técnico evidente, execução cuidadosa",
          "satisfatorio": "Técnica adequada, execução razoável",
          "em_desenvolvimento": "Técnica em desenvolvimento, execução irregular"
        },
        "relacao_com_conteudos_estudados": {
          "peso": 25,
          "excelente": "Estabelece relações profundas com os conteúdos e referências",
          "satisfatorio": "Estabelece relações pertinentes com os conteúdos",
          "em_desenvolvimento": "Relação superficial com os conteúdos"
        },
        "reflexao_critica": {
          "peso": 15,
          "excelente": "Reflexão crítica aprofundada sobre o próprio processo",
          "satisfatorio": "Reflexão adequada sobre o processo",
          "em_desenvolvimento": "Reflexão incipiente sobre o processo"
        }
      },
      "habilidade_bncc": "EF69AR05"
    }
  ],
  "tabela_pontuacao": {
    "questao_1": {{valor_questao_1}},
    "questao_2": {{valor_questao_2}},
    "questao_3": {{valor_questao_3}},
    "total": {{valor_total}}
  },
  "adaptacoes_pdi": [
    "{{adaptacao_visual}} — para alunos com deficiência visual",
    "{{adaptacao_auditiva}} — para alunos com deficiência auditiva",
    "{{adaptacao_motora}} — para alunos com deficiência motora",
    "{{adaptacao_cognitiva}} — para alunos com deficiência intelectual"
  ],
  "autoavaliacao": {
    "descricao": "Espaço para o aluno refletir sobre seu processo de aprendizagem em Artes neste trimestre.",
    "perguntas": [
      "O que você aprendeu sobre Artes neste trimestre?",
      "Qual atividade você mais gostou? Por quê?",
      "Qual foi sua maior dificuldade? Como você lidou com ela?",
      "Como você avalia sua participação nas aulas (apreciação, criação e reflexão)?",
      "O que você gostaria de aprender no próximo trimestre?"
    ]
  }
}
```
