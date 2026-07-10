# Template de Prompt — Planejamento Trimestral (Filosofia)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Filosofia seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados,
citações filosóficas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Filosofia
- **Ano/Série:** {{ano_serie}}
- **Trimestre:** {{trimestre}} (1º, 2º ou 3º)
- **Ano Letivo:** {{ano_letivo}}
- **Carga Horária Semanal:** {{carga_horaria}} aulas de 50 min
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Calendário Escolar:** {{calendario_escolar}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Filosofia",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias filosóficas e de processos históricos, geográficos, políticos, econômicos, sociais, ambientais e culturais.",
      "fonte": "BNCC — Área de Ciências Humanas e Sociais Aplicadas"
    },
    {
      "codigo": "CE05",
      "descricao": "Identificar e combater as diversas formas de injustiça, preconceito e violência, adotando princípios éticos, democráticos, inclusivos e solidários, e respeitando os Direitos Humanos.",
      "fonte": "BNCC — Área de Ciências Humanas e Sociais Aplicadas"
    }
  ],
  "eixos_estruturadores": [
    {
      "eixo": "História da Filosofia",
      "descricao": "Abordagem diacrônica do pensamento filosófico ocidental, contextualizando cada autor em seu tempo histórico"
    },
    {
      "eixo": "Temas Filosóficos",
      "descricao": "Abordagem temática transversal conectando problemas perenes da Filosofia com dilemas contemporâneos"
    },
    {
      "eixo": "Metodologia Filosófica",
      "descricao": "Desenvolvimento de habilidades de leitura analítica, argumentação e produção textual filosófica"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "{{unidade_tematica_mes_1}}",
      "topico": "{{topico_mes_1}}",
      "periodo_filosofico": "{{periodo_mes_1}}",
      "habilidades_bncc": ["EM13CHS101", "EM13CHS102", "EM13CHS103"],
      "objetos_conhecimento": [
        "Contexto histórico-cultural do período {{periodo_mes_1}}",
        "{{autor_principal_1}}: vida, obra e conceitos fundamentais ({{conceitos_autor_1}})",
        "{{autor_principal_2}}: vida, obra e conceitos fundamentais ({{conceitos_autor_2}})",
        "Conceitos filosóficos centrais: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
        "Diálogo com o presente: {{conexao_contemporanea_1}}"
      ],
      "aulas_previstas": 12,
      "textos_filosoficos_mes": [
        {
          "autor": "{{autor_principal_1}}",
          "obra": "{{obra_1}}",
          "trecho_sugerido": "{{trecho_1_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS101"
        },
        {
          "autor": "{{autor_principal_2}}",
          "obra": "{{obra_2}}",
          "trecho_sugerido": "{{trecho_2_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS102"
        }
      ],
      "atividades_sugeridas": [
        "Leitura analítica com ficha de identificação de tese e argumentos",
        "Debate estruturado sobre {{tema_debate_1}}",
        "Produção de texto dissertativo-argumentativo (tema: {{tema_redacao_1}})",
        "Seminário em grupo sobre {{tema_seminario_1}}"
      ],
      "avaliacao_parcial": "Ficha de leitura analítica + participação em debate + texto dissertativo-argumentativo (peso 3)"
    },
    "mes_2": {
      "unidade_tematica": "{{unidade_tematica_mes_2}}",
      "topico": "{{topico_mes_2}}",
      "periodo_filosofico": "{{periodo_mes_2}}",
      "habilidades_bncc": ["EM13CHS104", "EM13CHS105", "EM13CHS106"],
      "objetos_conhecimento": [
        "Transição do pensamento {{periodo_anterior}} para {{periodo_mes_2}}: rupturas e continuidades",
        "{{autor_principal_3}}: contextualização e conceitos fundamentais",
        "{{autor_principal_4}}: contextualização e conceitos fundamentais",
        "Conceitos filosóficos centrais: {{conceito_4}}, {{conceito_5}}, {{conceito_6}}",
        "Diálogo com o presente: {{conexao_contemporanea_2}}"
      ],
      "aulas_previstas": 12,
      "textos_filosoficos_mes": [
        {
          "autor": "{{autor_principal_3}}",
          "obra": "{{obra_3}}",
          "trecho_sugerido": "{{trecho_3_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS104"
        },
        {
          "autor": "{{autor_principal_4}}",
          "obra": "{{obra_4}}",
          "trecho_sugerido": "{{trecho_4_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS105"
        }
      ],
      "atividades_sugeridas": [
        "Análise comparativa de dois autores sobre o mesmo tema",
        "Júri simulado sobre {{dilema_etico}}",
        "Produção de resenha filosófica",
        "Criação de mapa conceitual interativo do período filosófico"
      ],
      "avaliacao_parcial": "Prova escrita com questões estilo ENEM (múltipla escolha + discursiva) + resenha filosófica (peso 4)"
    },
    "mes_3": {
      "unidade_tematica": "{{unidade_tematica_mes_3}}",
      "topico": "{{topico_mes_3}}",
      "periodo_filosofico": "{{periodo_mes_3}}",
      "habilidades_bncc": ["EM13CHS201", "EM13CHS202", "EM13CHS203"],
      "objetos_conhecimento": [
        "{{tema_transversal}}: abordagem filosófica integrando diferentes autores e períodos",
        "Debate contemporâneo: {{tema_atual_1}} na perspectiva filosófica",
        "Preparação para o ENEM: revisão dos conceitos-chave do trimestre",
        "Projeto integrador: {{projeto_filosofico}}"
      ],
      "aulas_previstas": 12,
      "textos_filosoficos_mes": [
        {
          "autor": "{{autor_contemporaneo}}",
          "obra": "{{obra_contemporanea}}",
          "trecho_sugerido": "{{trecho_contemporaneo_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS202"
        }
      ],
      "atividades_sugeridas": [
        "Projeto integrador: {{descricao_projeto}}",
        "Simulado ENEM com questões de Filosofia (Ciências Humanas)",
        "Roda de conversa: Filosofia e {{tema_atual_2}}",
        "Autoavaliação do percurso filosófico no trimestre"
      ],
      "avaliacao_parcial": "Projeto integrador (apresentação + relatório) + simulado ENEM + autoavaliação (peso 3)"
    }
  },
  "avaliacao_trimestral": {
    "distribuicao_pontos": {
      "avaliacao_1": {"descricao": "Ficha de leitura + debate + texto argumentativo (mês 1)", "peso": 3},
      "avaliacao_2": {"descricao": "Prova escrita + resenha filosófica (mês 2)", "peso": 4},
      "avaliacao_3": {"descricao": "Projeto integrador + simulado ENEM + autoavaliação (mês 3)", "peso": 3}
    },
    "recuperacao_paralela": {
      "estrategia": "Releitura orientada dos textos filosóficos com ficha de estudo + produção de texto argumentativo de recuperação",
      "criterios": "Demonstrar compreensão dos conceitos centrais e capacidade de aplicação a situações-problema"
    }
  },
  "conexao_enem": {
    "competencias_mobilizadas": ["C1", "C2", "C5"],
    "habilidades_enem_foco": [
      "{{habilidade_enem_1}}",
      "{{habilidade_enem_2}}",
      "{{habilidade_enem_3}}"
    ],
    "estrategia_preparacao": "Ao longo do trimestre, os alunos serão expostos a questões do ENEM de edições anteriores que mobilizam os conteúdos filosóficos trabalhados. Cada bloco de conteúdo inclui pelo menos 2 questões-modelo comentadas."
  },
  "projeto_integrador": {
    "titulo": "{{titulo_projeto}}",
    "tema": "{{tema_projeto}}",
    "produto_final": "{{produto_projeto}}",
    "competencias_bncc": ["EM13CHS101", "EM13CHS106", "EM13CHS304", "EM13CHS401"],
    "etapas": [
      {"etapa": 1, "descricao": "Pesquisa e levantamento de referências filosóficas sobre o tema"},
      {"etapa": 2, "descricao": "Análise crítica e discussão em grupo das fontes selecionadas"},
      {"etapa": 3, "descricao": "Produção do produto final ({{produto_final}})"},
      {"etapa": 4, "descricao": "Apresentação e debate coletivo dos resultados"}
    ],
    "criterios_avaliacao": [
      "Fundamentação filosófica consistente",
      "Clareza na exposição de conceitos e argumentos",
      "Criatividade na abordagem e na produção",
      "Trabalho colaborativo e respeito à pluralidade de ideias"
    ]
  },
  "referencias": [
    {
      "tipo": "Documento oficial",
      "titulo": "BNCC — Etapa do Ensino Médio — Ciências Humanas e Sociais Aplicadas",
      "fonte": "MEC/CNE"
    },
    {
      "tipo": "Documento oficial",
      "titulo": "Currículo Referência de Minas Gerais — Ensino Médio",
      "fonte": "SEE-MG"
    },
    {
      "tipo": "Livro didático",
      "titulo": "{{livro_pnld}}",
      "fonte": "PNLD — Ensino Médio"
    }
  ],
  "observacoes": "{{observacoes_adicionais}}"
}
```
