# Template de Prompt — Avaliação (Física)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Física seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
fórmulas ou constantes físicas.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Física
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
    "disciplina": "Física",
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
      "habilidade_bncc": "EM13CNT101",
      "descritor": "Analisar e representar transformações e conservações em sistemas que envolvam quantidade de matéria, de energia e de movimento",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EM13CNT102",
      "descritor": "Realizar previsões qualitativas e quantitativas sobre o funcionamento de geradores, motores elétricos e seus componentes",
      "questoes_associadas": [3, 4]
    },
    {
      "habilidade_bncc": "EM13CNT104",
      "descritor": "Avaliar os benefícios e os riscos à saúde e ao ambiente, considerando a composição, a toxicidade e a reatividade de diferentes materiais e produtos",
      "questoes_associadas": [5]
    }
  ],
  "formulario_constantes": [
    {"simbolo": "g", "nome": "Aceleração da gravidade", "valor": "10 m/s²", "unidade": "m/s²"},
    {"simbolo": "c", "nome": "Velocidade da luz no vácuo", "valor": "3,0 × 10⁸", "unidade": "m/s"}
  ],
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "Registre todos os cálculos e o raciocínio utilizado. Respostas sem justificativa terão pontuação reduzida.",
    "Use caneta azul ou preta. Não é permitido o uso de corretivo líquido.",
    "É permitido o uso de calculadora científica.",
    "Quando necessário, utilize as constantes fornecidas no formulário.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EM13CNT101",
      "nivel_taxonomico": "Aplicação",
      "comando": "Um automóvel parte do repouso e atinge a velocidade de 72 km/h em 10 segundos, em uma trajetória retilínea. A aceleração escalar média do automóvel nesse intervalo de tempo é de:",
      "contexto": "Cinemática — MRUV — Cálculo de aceleração média",
      "dados_fornecidos": "v₀ = 0; v = 72 km/h; Δt = 10 s",
      "alternativas": [
        {"letra": "A", "texto": "2,0 m/s²"},
        {"letra": "B", "texto": "7,2 m/s²"},
        {"letra": "C", "texto": "3,6 m/s²"},
        {"letra": "D", "texto": "1,0 m/s²"},
        {"letra": "E", "texto": "4,0 m/s²"}
      ],
      "gabarito": "A",
      "resolucao_comentada": "Converter a velocidade: 72 km/h ÷ 3,6 = 20 m/s. Aplicar a equação da aceleração média: a = Δv/Δt = (20 - 0)/10 = 2,0 m/s². Alternativa A."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EM13CNT101",
      "nivel_taxonomico": "Análise",
      "comando": "Um bloco de massa 2,0 kg está inicialmente em repouso sobre uma superfície horizontal sem atrito. Uma força horizontal constante de 10 N é aplicada ao bloco durante 4,0 segundos. Determine: (a) a aceleração do bloco; (b) a velocidade final do bloco; (c) a distância percorrida pelo bloco nesse intervalo. Apresente TODOS os cálculos.",
      "contexto": "Dinâmica — Leis de Newton e Cinemática",
      "criterios_correcao": {
        "nota_maxima": "{{valor_questao}}",
        "rubrica": [
          {"faixa": "Excelente (90-100%)", "descricao": "Identifica corretamente a 2ª Lei de Newton, calcula a aceleração (a = F/m = 5,0 m/s²), determina v (v = v₀ + at = 20 m/s) e Δs (Δs = v₀t + ½at² = 40 m) com todos os passos detalhados."},
          {"faixa": "Bom (70-89%)", "descricao": "Aplica corretamente as leis e equações, mas omite algum passo intermediário ou não apresenta todas as unidades."},
          {"faixa": "Regular (50-69%)", "descricao": "Identifica a lei de Newton, mas comete erros nos cálculos ou na aplicação das equações da cinemática."},
          {"faixa": "Insuficiente (0-49%)", "descricao": "Não identifica a relação entre força e aceleração ou apresenta resolução totalmente equivocada."}
        ]
      },
      "resolucao_esperada": "(a) Pela 2ª Lei de Newton: F = m·a → a = F/m = 10/2,0 = 5,0 m/s². (b) Como a aceleração é constante (MRUV): v = v₀ + a·t = 0 + 5,0·4,0 = 20 m/s. (c) Δs = v₀·t + ½·a·t² = 0·4,0 + ½·5,0·(4,0)² = ½·5,0·16 = 40 m. Ou por Torricelli: v² = v₀² + 2·a·Δs → 20² = 0 + 2·5·Δs → 400 = 10·Δs → Δs = 40 m."
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
      {"numero": 2, "orientacao_correcao": "Ver rubrica correspondente. Atribuir nota de 0 a {{valor_questao}}. Valorizar a correta aplicação das leis da Física e a apresentação completa dos cálculos."}
    ]
  },
  "tabela_desempenho": {
    "faixas": [
      {"conceito": "Avançado", "nota_minima": 90, "nota_maxima": 100, "descricao": "Domínio pleno das habilidades avaliadas. Aplica corretamente leis e princípios da Física com raciocínio claro e estruturado."},
      {"conceito": "Proficiente", "nota_minima": 70, "nota_maxima": 89, "descricao": "Domínio satisfatório; pequenas lacunas na aplicação das leis físicas ou na modelagem matemática."},
      {"conceito": "Básico", "nota_minima": 50, "nota_maxima": 69, "descricao": "Domínio parcial; necessita reforço em habilidades específicas de Física."},
      {"conceito": "Abaixo do Básico", "nota_minima": 0, "nota_maxima": 49, "descricao": "Domínio insuficiente; requer intervenção pedagógica individualizada com foco em conceitos fundamentais."}
    ]
  },
  "plano_recuperacao": {
    "alunos_alvo": "Estudantes com nota abaixo de 60%",
    "estrategias": [
      "Reagendamento de avaliação com questões reformuladas",
      "Plantão de dúvidas em horário extraclasse com foco em experimentos",
      "Lista de exercícios de reforço com resolução orientada e simulações PhET",
      "Monitoria entre pares (aluno-monitor)",
      "Recuperação de experimentos práticos não realizados ou com relatório insuficiente"
    ]
  }
}
```

## OBSERVAÇÕES CRÍTICAS

- **CADA QUESTÃO** deve estar vinculada a uma habilidade BNCC específica
- **VÁRIE OS NÍVEIS TAXONÔMICOS:** compreensão, aplicação, análise, síntese
- **INCLUA** resolução comentada passo a passo em TODAS as questões, com fundamentação nas leis da Física
- **INCLUA** um formulário com as constantes físicas necessárias para a resolução (forneça apenas as que aparecem na base RAG)
- **A rubrica de correção** para questões discursivas deve valorizar o RACIOCÍNIO FÍSICO, não apenas a resposta final
- **O plano de recuperação** deve ser construtivo, não punitivo — inclua recuperação de experimentos
- **SEMPRE** inclua a tabela de desempenho com faixas de interpretação pedagógica
- Siga o padrão ENEM: 5 alternativas, contextualização, enunciados com situações do cotidiano
- Contextualize as questões com aplicações tecnológicas: veículos, eletrodomésticos, celulares, usinas, fenômenos naturais
- **NUNCA** invente fórmulas, leis físicas ou constantes — valide com o contexto RAG
- Para evitar desvios, forneça os valores das constantes no formulário da prova, não espere que o aluno as decore
