# Template de Prompt — Avaliação (Educação Física)

## INSTRUÇÕES PARA O LLM

Gere uma avaliação completa de Educação Física seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR REGRAS ESPORTIVAS OU EXERCÍCIOS SEM BASE.** Toda
referência a regras esportivas, técnicas de execução de exercícios,
fundamentos táticos ou protocolos de treinamento DEVE ser verificável na
base RAG. Se não tiver certeza de uma informação, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Educação Física
- **Ano/Série:** {{ano_serie}}
- **Trimestre/Bimestre:** {{trimestre}}
- **Tipo de Avaliação:** {{tipo_avaliacao}} (Diagnóstica / Formativa / Somativa / Simulado)
- **Unidade Temática:** {{unidade_tematica}} (Brincadeiras e Jogos / Esportes / Ginásticas / Danças / Lutas / Práticas Corporais de Aventura)
- **Habilidades BNCC a Avaliar:** {{habilidades_bncc}}
- **Conteúdos Trabalhados:** {{conteudos}}
- **Materiais de Referência (base RAG):** {{referencias_rag}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Número de Questões:** {{num_questoes}}
- **Valor Total:** {{valor_total}} pontos

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Educação Física",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "tipo_avaliacao": "{{tipo_avaliacao}}",
    "unidade_tematica": "{{unidade_tematica}}",
    "professor": "{{professor_nome}}",
    "data": "{{data}}",
    "valor_total": {{valor_total}},
    "tempo_estimado": "{{tempo_estimado}} minutos"
  },
  "matriz_referencia": [
    {
      "habilidade_bncc": "EF67EF01",
      "descritor": "Experimentar e fruir diferentes brincadeiras e jogos, reconhecendo e respeitando as diferenças individuais de desempenho",
      "questoes_associadas": [1, 2]
    },
    {
      "habilidade_bncc": "EF67EF02",
      "descritor": "Identificar as transformações nas características dos jogos em função dos diferentes contextos históricos e sociais",
      "questoes_associadas": [3, 4]
    }
  ],
  "instrucoes_gerais": [
    "Leia atentamente cada questão antes de responder.",
    "As questões práticas devem ser realizadas no espaço designado pelo professor.",
    "Use roupas e calçados adequados para a realização das atividades práticas.",
    "Respeite os colegas e as regras de segurança durante toda a avaliação.",
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
      "habilidade_bncc": "EF67EF01"
    },
    {
      "numero": 2,
      "tipo": "discursiva",
      "valor": {{valor_questao_2}},
      "texto_base": "{{texto_base_questao2}}",
      "enunciado": "{{enunciado_questao2}}",
      "criterios_correcao": [
        {
          "criterio": "Compreensão das regras e fundamentos do esporte/modalidade",
          "pontuacao_maxima": "{{pontuacao_c1}}"
        },
        {
          "criterio": "Capacidade de relacionar o esporte com seu contexto histórico e social",
          "pontuacao_maxima": "{{pontuacao_c2}}"
        },
        {
          "criterio": "Argumentação e uso de vocabulário técnico adequado",
          "pontuacao_maxima": "{{pontuacao_c3}}"
        }
      ],
      "resposta_esperada": "{{resposta_esperada}}",
      "habilidade_bncc": "EF67EF02"
    },
    {
      "numero": 3,
      "tipo": "pratica",
      "valor": {{valor_questao_3}},
      "enunciado": "{{enunciado_questao3}}",
      "descricao_atividade": "{{descricao_atividade_pratica}}",
      "materiais_necessarios": ["{{material_1}}", "{{material_2}}"],
      "espaco_necessario": "{{espaco_pratica}}",
      "tempo_execucao": "{{tempo_execucao}} minutos",
      "rubrica_avaliacao": {
        "execucao_tecnica": {
          "peso": 25,
          "excelente": "Executa os fundamentos com qualidade técnica e controle motor",
          "satisfatorio": "Executa os fundamentos com correções pontuais",
          "em_desenvolvimento": "Executa parcialmente, necessita de demonstração adicional"
        },
        "compreensao_tatica": {
          "peso": 25,
          "excelente": "Demonstra compreensão tática avançada, toma decisões adequadas no jogo",
          "satisfatorio": "Compreende a tática básica, toma decisões adequadas na maioria das situações",
          "em_desenvolvimento": "Compreensão tática em desenvolvimento, decisões inconsistentes"
        },
        "cooperacao_e_respeito": {
          "peso": 20,
          "excelente": "Coopera ativamente, respeita regras e colegas, demonstra espírito esportivo",
          "satisfatorio": "Coopera e respeita regras e colegas na maioria das situações",
          "em_desenvolvimento": "Cooperação e respeito às regras necessitam de intervenção do professor"
        },
        "evolucao_individual": {
          "peso": 15,
          "excelente": "Demonstra evolução significativa em relação ao ponto de partida",
          "satisfatorio": "Demonstra evolução adequada ao longo do trimestre",
          "em_desenvolvimento": "Evolução abaixo do esperado para o período"
        },
        "atitude_esportiva": {
          "peso": 15,
          "excelente": "Fair play exemplar, incentiva colegas, lida bem com vitória e derrota",
          "satisfatorio": "Demonstra fair play, lida adequadamente com resultados",
          "em_desenvolvimento": "Atitude esportiva em desenvolvimento, necessita de orientação"
        }
      },
      "orientacoes_seguranca": [
        "Realizar aquecimento prévio de 10 minutos",
        "Usar calçado adequado para atividade física",
        "Hidratar-se antes, durante e após a atividade",
        "Comunicar imediatamente qualquer dor ou desconforto ao professor"
      ],
      "habilidade_bncc": "EF67EF03"
    }
  ],
  "tabela_pontuacao": {
    "questao_1": {{valor_questao_1}},
    "questao_2": {{valor_questao_2}},
    "questao_3": {{valor_questao_3}},
    "total": {{valor_total}}
  },
  "adaptacoes_pdi": [
    "{{adaptacao_motora}} — para alunos com deficiência motora (ex.: regras adaptadas, equipamentos modificados)",
    "{{adaptacao_visual}} — para alunos com deficiência visual (ex.: bola com guizo, demarcação tátil)",
    "{{adaptacao_auditiva}} — para alunos com deficiência auditiva (ex.: sinais visuais, demonstração)",
    "{{adaptacao_cognitiva}} — para alunos com deficiência intelectual (ex.: comandos simplificados, demonstração passo a passo)"
  ],
  "autoavaliacao": {
    "descricao": "Espaço para o aluno refletir sobre seu processo de aprendizagem em Educação Física neste trimestre.",
    "perguntas": [
      "O que você aprendeu sobre esportes, jogos e práticas corporais neste trimestre?",
      "Em quais modalidades ou atividades você percebeu maior evolução?",
      "Qual foi sua maior dificuldade? Como você lidou com ela?",
      "Como você avalia sua participação e atitude nas aulas (cooperação, respeito, fair play)?",
      "Como você cuida da sua saúde e condicionamento físico fora da escola?",
      "O que você gostaria de aprender/praticar no próximo trimestre?"
    ]
  }
}
```
