# Template de Prompt — Avaliação (Língua Portuguesa)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Língua Portuguesa seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Língua Portuguesa
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
    "disciplina": "Língua Portuguesa",
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
      "habilidade_bncc": "EF67LP28",
      "descritor": "Localizar informações explícitas em um texto",
      "questoes_associadas": [1, 3]
    },
    {
      "habilidade_bncc": "EF67LP29",
      "descritor": "Inferir o sentido de uma palavra ou expressão no contexto",
      "questoes_associadas": [2]
    },
    {
      "habilidade_bncc": "EF67LP30",
      "descritor": "Reconhecer o efeito de sentido decorrente do uso de recursos gráfico-visuais",
      "questoes_associadas": [4, 5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "As questões discursivas devem ser respondidas à caneta azul ou preta.",
    "Não é permitido o uso de corretivo líquido.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF67LP28",
      "nivel_taxonomico": "Compreensão",
      "comando": "De acordo com o texto, o personagem principal decidiu viajar porque...",
      "texto_base": "{{texto_base_ou_trecho}}",
      "alternativas": [
        {"letra": "A", "texto": "estava cansado da rotina da cidade pequena."},
        {"letra": "B", "texto": "recebeu uma proposta de emprego irrecusável."},
        {"letra": "C", "texto": "queria reencontrar um antigo amigo de infância."},
        {"letra": "D", "texto": "precisava cuidar de um familiar doente."},
        {"letra": "E", "texto": "foi obrigado pela família a se mudar."}
      ],
      "gabarito": "A",
      "justificativa_gabarito": "O texto afirma, no segundo parágrafo, que o personagem 'já não suportava mais a monotonia dos dias iguais', o que indica cansaço com a rotina."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF67LP30",
      "nivel_taxonomico": "Análise",
      "comando": "Explique como o autor utiliza o recurso da ironia no trecho destacado para construir sua crítica social. Justifique sua resposta com elementos do texto.",
      "texto_base": "{{texto_base_ou_trecho}}",
      "criterios_correcao": {
        "nota_maxima": "{{valor_questao}}",
        "rubrica": [
          {"faixa": "Excelente (90-100%)", "descricao": "Identifica a ironia, explica seu funcionamento e relaciona com a crítica social, citando trechos do texto."},
          {"faixa": "Bom (70-89%)", "descricao": "Identifica a ironia e explica seu funcionamento, mas não relaciona totalmente com a crítica social."},
          {"faixa": "Regular (50-69%)", "descricao": "Identifica a ironia, mas explica de forma superficial ou genérica."},
          {"faixa": "Insuficiente (0-49%)", "descricao": "Não identifica a ironia ou apresenta explicação equivocada."}
        ]
      },
      "resposta_esperada": "O aluno deve identificar que o autor utiliza a ironia ao... (resumo dos principais pontos esperados)."
    }
  ],
  "gabarito_completo": {
    "questoes_objetivas": [
      {"numero": 1, "resposta": "A"},
      {"numero": 3, "resposta": "C"},
      {"numero": 4, "resposta": "E"},
      {"numero": 5, "resposta": "B"}
    ],
    "questoes_dissertativas": [
      {"numero": 2, "orientacao_correcao": "Ver rubrica correspondente. Atribuir nota de 0 a {{valor_questao}}."}
    ]
  },
  "tabela_desempenho": {
    "faixas": [
      {"conceito": "Avançado", "nota_minima": 90, "nota_maxima": 100, "descricao": "Domínio pleno das habilidades avaliadas."},
      {"conceito": "Proficiente", "nota_minima": 70, "nota_maxima": 89, "descricao": "Domínio satisfatório; pequenas lacunas."},
      {"conceito": "Básico", "nota_minima": 50, "nota_maxima": 69, "descricao": "Domínio parcial; necessita reforço."},
      {"conceito": "Abaixo do Básico", "nota_minima": 0, "nota_maxima": 49, "descricao": "Domínio insuficiente; requer intervenção pedagógica."}
    ]
  },
  "plano_recuperacao": {
    "alunos_alvo": "Estudantes com nota abaixo de 60%",
    "estrategias": [
      "Reagendamento de avaliação com questões reformuladas",
      "Plantão de dúvidas em horário extraclasse",
      "Lista de exercícios de reforço com correção individualizada"
    ]
  }
}
```

## OBSERVAÇÕES CRÍTICAS

- **CADA QUESTÃO** deve estar vinculada a uma habilidade BNCC específica
- **VÁRIE OS NÍVEIS TAXONÔMICOS:** compreensão, aplicação, análise, síntese
- **INCLUA** textos-base reais ou verossímeis (não invente autores)
- **A rubrica de correção** para questões discursivas é OBRIGATÓRIA
- **O plano de recuperação** deve ser construtivo, não punitivo
- **SEMPRE** inclua a tabela de desempenho com faixas de interpretação pedagógica
- Para Ensino Médio, siga o padrão ENEM (5 alternativas, textos-base mais longos)
- Para Ensino Fundamental, priorize clareza e textos mais curtos
