# Template de Prompt — Avaliação (Matemática)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Matemática seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Matemática
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
    "disciplina": "Matemática",
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
      "habilidade_bncc": "EF06MA03",
      "descritor": "Resolver problemas envolvendo as quatro operações com números naturais",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EF06MA06",
      "descritor": "Resolver equações do 1º grau com uma incógnita",
      "questoes_associadas": [3, 4]
    },
    {
      "habilidade_bncc": "EF06MA17",
      "descritor": "Calcular perímetro de figuras planas",
      "questoes_associadas": [5]
    }
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "Registre todos os cálculos e o raciocínio utilizado. Respostas sem justificativa terão pontuação reduzida.",
    "Use caneta azul ou preta. Não é permitido o uso de corretivo líquido.",
    "É permitido o uso de calculadora científica (se aplicável ao ano/série).",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06MA03",
      "nivel_taxonomico": "Aplicação",
      "comando": "Em uma loja, Paulo comprou 3 camisetas a R$ 25,00 cada e 2 bermudas a R$ 40,00 cada. Quanto Paulo gastou no total?",
      "contexto": "Matemática financeira — operações com números naturais",
      "alternativas": [
        {"letra": "A", "texto": "R$ 115,00"},
        {"letra": "B", "texto": "R$ 155,00"},
        {"letra": "C", "texto": "R$ 145,00"},
        {"letra": "D", "texto": "R$ 175,00"},
        {"letra": "E", "texto": "R$ 135,00"}
      ],
      "gabarito": "B",
      "resolucao_comentada": "3 camisetas × R$ 25,00 = R$ 75,00. 2 bermudas × R$ 40,00 = R$ 80,00. Total = R$ 75,00 + R$ 80,00 = R$ 155,00. Alternativa B."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EF06MA07",
      "nivel_taxonomico": "Análise",
      "comando": "Resolva o seguinte problema, registrando TODOS os passos do seu raciocínio: 'Um número somado ao seu dobro é igual a 36. Qual é esse número?'",
      "contexto": "Equações do 1º grau",
      "criterios_correcao": {
        "nota_maxima": "{{valor_questao}}",
        "rubrica": [
          {"faixa": "Excelente (90-100%)", "descricao": "Monta a equação corretamente (x + 2x = 36), resolve passo a passo (3x = 36, x = 12) e valida a resposta (12 + 24 = 36)."},
          {"faixa": "Bom (70-89%)", "descricao": "Monta e resolve a equação corretamente, mas não valida a resposta ou omite algum passo."},
          {"faixa": "Regular (50-69%)", "descricao": "Monta a equação parcialmente correta ou resolve com erro de conta."},
          {"faixa": "Insuficiente (0-49%)", "descricao": "Não monta a equação ou apresenta resolução completamente equivocada."}
        ]
      },
      "resolucao_esperada": "Seja x o número procurado. O dobro do número é 2x. A equação que representa o problema é: x + 2x = 36. Resolvendo: 3x = 36, portanto x = 12. Verificação: 12 + 2×12 = 12 + 24 = 36. Resposta: o número é 12."
    }
  ],
  "gabarito_completo": {
    "questoes_objetivas": [
      {"numero": 1, "resposta": "B"},
      {"numero": 3, "resposta": "C"},
      {"numero": 4, "resposta": "A"},
      {"numero": 5, "resposta": "E"}
    ],
    "questoes_dissertativas": [
      {"numero": 2, "orientacao_correcao": "Ver rubrica correspondente. Atribuir nota de 0 a {{valor_questao}}. Valorizar o raciocínio, não apenas a resposta final."}
    ]
  },
  "tabela_desempenho": {
    "faixas": [
      {"conceito": "Avançado", "nota_minima": 90, "nota_maxima": 100, "descricao": "Domínio pleno das habilidades avaliadas. Raciocínio claro e estruturado."},
      {"conceito": "Proficiente", "nota_minima": 70, "nota_maxima": 89, "descricao": "Domínio satisfatório; pequenas lacunas no raciocínio ou nos cálculos."},
      {"conceito": "Básico", "nota_minima": 50, "nota_maxima": 69, "descricao": "Domínio parcial; necessita reforço em habilidades específicas."},
      {"conceito": "Abaixo do Básico", "nota_minima": 0, "nota_maxima": 49, "descricao": "Domínio insuficiente; requer intervenção pedagógica individualizada."}
    ]
  },
  "plano_recuperacao": {
    "alunos_alvo": "Estudantes com nota abaixo de 60%",
    "estrategias": [
      "Reagendamento de avaliação com questões reformuladas",
      "Plantão de dúvidas em horário extraclasse",
      "Lista de exercícios de reforço com resolução orientada",
      "Monitoria entre pares (aluno-monitor)"
    ]
  }
}
```

## OBSERVAÇÕES CRÍTICAS

- **CADA QUESTÃO** deve estar vinculada a uma habilidade BNCC específica
- **VÁRIE OS NÍVEIS TAXONÔMICOS:** compreensão, aplicação, análise, síntese
- **INCLUA** resolução comentada passo a passo em TODAS as questões
- **A rubrica de correção** para questões discursivas deve valorizar o RACIOCÍNIO, não apenas a resposta final
- **O plano de recuperação** deve ser construtivo, não punitivo
- **SEMPRE** inclua a tabela de desempenho com faixas de interpretação pedagógica
- Para Ensino Médio, siga o padrão ENEM (5 alternativas, contextualização, competências C1-C5)
- Para Ensino Fundamental, priorize clareza, contexto do cotidiano e resoluções passo a passo
- **NUNCA** invente fórmulas ou propriedades matemáticas — valide com o contexto RAG
