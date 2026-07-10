# Template de Prompt — Avaliação (Química)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Química seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
reações químicas ou fórmulas moleculares.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Química
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
    "disciplina": "Química",
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
  "formulario_dados": [
    {"tipo": "constante", "simbolo": "NA", "nome": "Constante de Avogadro", "valor": "6,02 × 10²³", "unidade": "mol⁻¹"},
    {"tipo": "constante", "simbolo": "R", "nome": "Constante dos gases ideais", "valor": "0,082", "unidade": "atm·L·mol⁻¹·K⁻¹"},
    {"tipo": "massa_molar", "elemento": "H", "valor": "1,0", "unidade": "g/mol"},
    {"tipo": "massa_molar", "elemento": "C", "valor": "12,0", "unidade": "g/mol"},
    {"tipo": "massa_molar", "elemento": "O", "valor": "16,0", "unidade": "g/mol"},
    {"tipo": "massa_molar", "elemento": "Na", "valor": "23,0", "unidade": "g/mol"},
    {"tipo": "massa_molar", "elemento": "Cl", "valor": "35,5", "unidade": "g/mol"}
  ],
  "tabela_periodica_resumida": "Fornecer recorte da Tabela Periódica com os elementos necessários para a resolução das questões (número atômico, massa atômica aproximada).",
  "orientacoes_gerais": [
    "Leia atentamente todas as questões antes de responder.",
    "Registre todos os cálculos e o raciocínio utilizado. Respostas sem justificativa terão pontuação reduzida.",
    "Use caneta azul ou preta. Não é permitido o uso de corretivo líquido.",
    "É permitido o uso de calculadora científica.",
    "Consulte a Tabela Periódica e o formulário de dados fornecidos.",
    "Revise sua prova antes de entregar."
  ],
  "questoes": [
    {
      "numero": 1,
      "tipo": "multipla_escolha",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EM13CNT101",
      "nivel_taxonomico": "Aplicação",
      "comando": "O carbonato de cálcio (CaCO₃) é o principal componente do calcário. Quando aquecido, decompõe-se em óxido de cálcio (CaO) e dióxido de carbono (CO₂). A massa de CaO obtida a partir da decomposição térmica de 200 g de CaCO₃, considerando rendimento de 100%, é de aproximadamente:",
      "contexto": "Estequiometria — Cálculo de massa em reações químicas — Indústria do cimento e da cal",
      "dados_fornecidos": "Massas molares: Ca = 40 g/mol; C = 12 g/mol; O = 16 g/mol. Equação: CaCO₃(s) → CaO(s) + CO₂(g)",
      "alternativas": [
        {"letra": "A", "texto": "56 g"},
        {"letra": "B", "texto": "88 g"},
        {"letra": "C", "texto": "112 g"},
        {"letra": "D", "texto": "128 g"},
        {"letra": "E", "texto": "200 g"}
      ],
      "gabarito": "C",
      "resolucao_comentada": "1) Massa molar do CaCO₃: 40 + 12 + (3 × 16) = 100 g/mol. 2) Massa molar do CaO: 40 + 16 = 56 g/mol. 3) Proporção: 100 g CaCO₃ → 56 g CaO. 4) Regra de três: 100 g → 56 g; 200 g → x. x = (200 × 56) / 100 = 112 g de CaO. Alternativa C."
    },
    {
      "numero": 2,
      "tipo": "dissertativa",
      "valor": {{valor_questao}},
      "habilidade_bncc": "EM13CNT101",
      "nivel_taxonomico": "Análise",
      "comando": "Uma solução aquosa de ácido clorídrico (HCl) foi preparada dissolvendo-se 0,73 g do ácido em água suficiente para completar 500 mL de solução. Determine: (a) a concentração em quantidade de matéria (mol/L) da solução; (b) o pH da solução, considerando ionização total do HCl. Dados: massas molares: H = 1,0 g/mol; Cl = 35,5 g/mol. Apresente TODOS os cálculos.",
      "contexto": "Soluções — Concentração molar — pH — Ácidos e bases no cotidiano",
      "criterios_correcao": {
        "nota_maxima": "{{valor_questao}}",
        "rubrica": [
          {"faixa": "Excelente (90-100%)", "descricao": "Calcula corretamente a massa molar do HCl (36,5 g/mol), a quantidade de matéria (0,02 mol), a concentração (0,04 mol/L) e o pH (pH = −log[H⁺] = −log(0,04) ≈ 1,4), considerando ionização total. Todos os passos detalhados e unidades corretas."},
          {"faixa": "Bom (70-89%)", "descricao": "Aplica corretamente as fórmulas, mas omite algum passo intermediário ou comete erro de arredondamento no pH."},
          {"faixa": "Regular (50-69%)", "descricao": "Calcula a concentração corretamente, mas erra no cálculo do pH (confunde fórmula ou interpretação)."},
          {"faixa": "Insuficiente (0-49%)", "descricao": "Não identifica a relação entre concentração e pH ou apresenta resolução totalmente equivocada."}
        ]
      },
      "resolucao_esperada": "(a) Massa molar do HCl: 1,0 + 35,5 = 36,5 g/mol. Quantidade de matéria: n = m / MM = 0,73 / 36,5 = 0,02 mol. Concentração: C = n / V = 0,02 / 0,5 = 0,04 mol/L. (b) HCl é ácido forte, ionização total: [H⁺] = C = 0,04 mol/L. pH = −log[H⁺] = −log(0,04) = −log(4×10⁻²) = 2 − log 4 ≈ 2 − 0,6 = 1,4."
    }
  ],
  "gabarito_completo": {
    "questoes_objetivas": [
      {"numero": 1, "resposta": "C"},
      {"numero": 3, "resposta": "A"},
      {"numero": 4, "resposta": "E"},
      {"numero": 5, "resposta": "B"}
    ],
    "questoes_dissertativas": [
      {"numero": 2, "orientacao_correcao": "Ver rubrica correspondente. Atribuir nota de 0 a {{valor_questao}}. Valorizar a correta aplicação das leis e princípios da Química e a apresentação completa dos cálculos com unidades."}
    ]
  },
  "tabela_desempenho": {
    "faixas": [
      {"conceito": "Avançado", "nota_minima": 90, "nota_maxima": 100, "descricao": "Domínio pleno das habilidades avaliadas. Aplica corretamente leis, princípios e cálculos químicos com raciocínio claro e estruturado."},
      {"conceito": "Proficiente", "nota_minima": 70, "nota_maxima": 89, "descricao": "Domínio satisfatório; pequenas lacunas na aplicação dos conceitos químicos ou nos cálculos estequiométricos."},
      {"conceito": "Básico", "nota_minima": 50, "nota_maxima": 69, "descricao": "Domínio parcial; necessita reforço em habilidades específicas de Química."},
      {"conceito": "Abaixo do Básico", "nota_minima": 0, "nota_maxima": 49, "descricao": "Domínio insuficiente; requer intervenção pedagógica individualizada com foco em conceitos fundamentais e representação simbólica."}
    ]
  },
  "plano_recuperacao": {
    "alunos_alvo": "Estudantes com nota abaixo de 60%",
    "estrategias": [
      "Reagendamento de avaliação com questões reformuladas",
      "Plantão de dúvidas em horário extraclasse com foco em experimentos",
      "Lista de exercícios de reforço com resolução orientada e simulações PhET/MolView",
      "Monitoria entre pares (aluno-monitor)",
      "Recuperação de experimentos práticos não realizados ou com relatório insuficiente"
    ]
  }
}
```

## OBSERVAÇÕES CRÍTICAS

- **CADA QUESTÃO** deve estar vinculada a uma habilidade BNCC específica
- **VÁRIE OS NÍVEIS TAXONÔMICOS:** compreensão, aplicação, análise, síntese
- **INCLUA** resolução comentada passo a passo em TODAS as questões, com equações químicas balanceadas e fundamentação nos princípios da Química
- **INCLUA** um formulário com massas molares, constantes (NA, R) e um recorte da Tabela Periódica com os elementos necessários (forneça apenas os dados que aparecem na base RAG)
- **A rubrica de correção** para questões discursivas deve valorizar o RACIOCÍNIO QUÍMICO, a correta representação simbólica (fórmulas, equações) e os cálculos, não apenas a resposta final
- **O plano de recuperação** deve ser construtivo, não punitivo — inclua recuperação de experimentos
- **SEMPRE** inclua a tabela de desempenho com faixas de interpretação pedagógica
- Siga o padrão ENEM: 5 alternativas, contextualização, enunciados com situações do cotidiano
- Contextualize as questões com aplicações cotidianas: alimentos, medicamentos, produtos de limpeza, processos industriais, meio ambiente, combustíveis
- **NUNCA** invente reações químicas, fórmulas moleculares ou valores de massas molares — valide com o contexto RAG
- Para evitar desvios, forneça a Tabela Periódica resumida e os valores das constantes no formulário da prova, não espere que o aluno os decore
- Inclua PELO MENOS uma questão envolvendo análise de gráfico ou tabela (padrão ENEM)
- Inclua PELO MENOS uma questão interdisciplinar (conexão com Biologia, Física ou Meio Ambiente)
