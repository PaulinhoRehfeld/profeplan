# Template de Prompt — Avaliação (Ciências/Biologia)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Ciências (EF) ou Biologia (EM) seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR EXPERIMENTOS OU DADOS CIENTÍFICOS.** Toda informação
científica deve ser verificável. Se não tiver certeza de um dado, indique
`[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** {{disciplina}} (Ciências ou Biologia)
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
    "disciplina": "{{disciplina}}",
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
      "habilidade_bncc": "EF06CI01",
      "descritor": "Classificar misturas como homogêneas ou heterogêneas com base em observações experimentais",
      "questoes_associadas": [1, 3]
    },
    {
      "habilidade_bncc": "EF06CI02",
      "descritor": "Identificar evidências de transformações químicas a partir de experimentos",
      "questoes_associadas": [2, 4]
    },
    {
      "habilidade_bncc": "EF06CI03",
      "descritor": "Selecionar métodos adequados para separação de misturas com base em propriedades dos materiais",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões e os textos de apoio antes de responder.",
    "As questões discursivas devem ser respondidas à caneta azul ou preta.",
    "Não é permitido o uso de corretivo líquido.",
    "Em questões que envolvem análise de experimentos, descreva suas observações de forma clara e objetiva.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06CI01",
      "nivel_taxonomico": "Compreensão",
      "comando": "Um estudante misturou água e óleo em um copo e observou que os líquidos não se misturaram, formando duas fases visíveis. Com base nessa observação e nos conceitos estudados, essa mistura é classificada como...",
      "contexto_experimental": {
        "descricao": "Experimento de mistura de água e óleo em copo transparente",
        "observacao": "Formação de duas fases distintas após agitação e repouso"
      },
      "alternativas": [
        {"letra": "A", "texto": "{{alternativa_a}}"},
        {"letra": "B", "texto": "{{alternativa_b}}"},
        {"letra": "C", "texto": "{{alternativa_c}}"},
        {"letra": "D", "texto": "{{alternativa_d}}"},
        {"letra": "E", "texto": "{{alternativa_e}}"}
      ],
      "gabarito": "{{letra_correta}}",
      "justificativa_gabarito": "A alternativa correta é {{letra}} porque... (fundamentar com o conceito científico). Os distratores são incorretos porque..."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06CI02",
      "nivel_taxonomico": "Análise",
      "comando": "Analise o experimento descrito abaixo e responda: qual evidência indica que ocorreu uma transformação química? Explique a diferença entre transformação química e física utilizando este experimento como exemplo.",
      "contexto_experimental": {
        "descricao": "{{descricao_experimento}}",
        "observacao_inicial": "{{observacao_inicial}}",
        "observacao_final": "{{observacao_final}}"
      },
      "criterios_correcao": [
        {"criterio": "Identificação correta da evidência de transformação química", "pontos": {{pontos_c1}}},
        {"criterio": "Diferenciação clara entre transformação química e física", "pontos": {{pontos_c2}}},
        {"criterio": "Uso correto da terminologia científica", "pontos": {{pontos_c3}}},
        {"criterio": "Coerência e clareza na argumentação", "pontos": {{pontos_c4}}}
      ],
      "resposta_esperada": "{{resposta_modelo}}"
    },
    {
      "numero": 3,
      "tipo": "pratica_experimental",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06CI03",
      "nivel_taxonomico": "Aplicação",
      "comando": "Você recebeu uma mistura de areia, sal de cozinha e limalha de ferro. Proponha um procedimento experimental para separar completamente os três componentes, indicando: (a) os métodos de separação em cada etapa; (b) a ordem correta das etapas; (c) a propriedade específica de cada material que permite a separação.",
      "materiais_disponiveis": [
        "Água",
        "Ímã",
        "Filtro de papel",
        "Funil",
        "Béquer",
        "Placa de aquecimento (ou lamparina com tela de amianto)",
        "Vidro de relógio"
      ],
      "criterios_correcao": [
        {"criterio": "Sequência lógica correta das etapas de separação", "pontos": {{pontos_c1}}},
        {"criterio": "Identificação correta dos métodos (imantação, filtração, evaporação)", "pontos": {{pontos_c2}}},
        {"criterio": "Justificativa baseada nas propriedades dos materiais", "pontos": {{pontos_c3}}},
        {"criterio": "Indicação de precauções de segurança pertinentes", "pontos": {{pontos_c4}}}
      ],
      "resposta_esperada": "{{resposta_modelo}}"
    }
  ],
  "tabela_pontuacao": {
    "questoes_objetivas": "{{soma_objetivas}} pontos",
    "questoes_dissertativas": "{{soma_dissertativas}} pontos",
    "questao_pratica": "{{soma_pratica}} pontos",
    "total": {{valor_total}}
  },
  "gabarito_resumido": {
    "1": "{{letra_1}}",
    "3": "{{letra_3}}",
    "5": "{{letra_5}}"
  },
  "referencias_cientificas_avaliacao": [
    {
      "tipo": "Livro didático",
      "referencia": "{{referencia_pnld}}"
    },
    {
      "tipo": "BNCC",
      "referencia": "Base Nacional Comum Curricular — Ciências da Natureza, {{ano_serie}}"
    }
  ]
}
```
