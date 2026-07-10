# Template de Prompt — Planejamento Trimestral (Sociologia)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Sociologia seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados
sociológicos, estatísticas ou códigos da BNCC.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Sociologia
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
    "disciplina": "Sociologia",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Analisar e comparar diferentes fontes e narrativas expressas em diversas linguagens, com vistas à compreensão de ideias sociológicas e de processos históricos, geográficos, políticos, econômicos, sociais, ambientais e culturais.",
      "fonte": "BNCC — Área de Ciências Humanas e Sociais Aplicadas"
    },
    {
      "codigo": "CE03",
      "descricao": "Analisar e avaliar criticamente as relações de diferentes grupos, povos e sociedades com a natureza (produção, distribuição e consumo) e seus impactos econômicos e socioambientais, com vistas à proposição de alternativas que respeitem e promovam a consciência, a ética socioambiental e o consumo responsável em âmbito local, regional, nacional e global.",
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
      "eixo": "Clássicos da Sociologia",
      "descricao": "Abordagem das três matrizes fundadoras do pensamento sociológico — Durkheim, Weber e Marx — contextualizando cada autor em seu tempo histórico e articulando com temas contemporâneos"
    },
    {
      "eixo": "Temas Sociológicos Contemporâneos",
      "descricao": "Abordagem temática transversal conectando conceitos sociológicos com problemas sociais brasileiros e globais do século XXI"
    },
    {
      "eixo": "Metodologia Científica",
      "descricao": "Desenvolvimento de habilidades de análise de indicadores sociais, leitura de gráficos e tabelas, interpretação de textos sociológicos e produção científica escolar"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "{{unidade_tematica_mes_1}}",
      "topico": "{{topico_mes_1}}",
      "tradicao_sociologica": "{{tradicao_mes_1}}",
      "habilidades_bncc": ["EM13CHS101", "EM13CHS102", "EM13CHS103"],
      "objetos_conhecimento": [
        "Contexto histórico-social do surgimento da Sociologia (século XIX, Revolução Industrial, Revolução Francesa)",
        "{{autor_principal_1}}: vida, obra e conceitos fundamentais ({{conceitos_autor_1}})",
        "{{autor_principal_2}}: vida, obra e conceitos fundamentais ({{conceitos_autor_2}})",
        "Conceitos sociológicos centrais: {{conceito_1}}, {{conceito_2}}, {{conceito_3}}",
        "Diálogo com o presente: {{conexao_contemporanea_1}}",
        "Dados e indicadores: {{fonte_dados_confirmada_base_rag}}"
      ],
      "aulas_previstas": 12,
      "textos_e_dados_mes": [
        {
          "tipo": "trecho_teorico",
          "autor": "{{autor_principal_1}}",
          "obra": "{{obra_1}}",
          "trecho_sugerido": "{{trecho_1_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS101"
        },
        {
          "tipo": "dado_sociologico",
          "fonte": "{{fonte_confirmada_base_rag}}",
          "dado": "{{dado_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS102"
        }
      ],
      "atividades_sugeridas": [
        "Leitura analítica com ficha de identificação de tese e argumentos sociológicos",
        "Debate estruturado sobre {{tema_debate_1}}",
        "Análise orientada de gráfico/tabela de {{fonte_dados_1}}",
        "Produção de texto dissertativo-argumentativo (tema: {{tema_redacao_1}})",
        "Seminário em grupo sobre {{tema_seminario_1}}"
      ],
      "avaliacao_parcial": "Ficha de leitura analítica + participação em debate + análise de dados + texto dissertativo-argumentativo (peso 3)"
    },
    "mes_2": {
      "unidade_tematica": "{{unidade_tematica_mes_2}}",
      "topico": "{{topico_mes_2}}",
      "tradicao_sociologica": "{{tradicao_mes_2}}",
      "habilidades_bncc": ["EM13CHS104", "EM13CHS105", "EM13CHS106"],
      "objetos_conhecimento": [
        "{{topico_mes_2}}: conceituação e contextualização histórica",
        "{{autor_principal_3}}: vida, obra e conceitos fundamentais",
        "Conceitos sociológicos: {{conceito_4}}, {{conceito_5}}, {{conceito_6}}",
        "Dados e indicadores: {{fonte_dados_confirmada_base_rag_2}}",
        "Diálogo com o presente: {{conexao_contemporanea_2}}",
        "Conexão interdisciplinar: {{conexao_historia_geografia}}"
      ],
      "aulas_previstas": 12,
      "textos_e_dados_mes": [
        {
          "tipo": "trecho_teorico",
          "autor": "{{autor_principal_3}}",
          "obra": "{{obra_3}}",
          "trecho_sugerido": "{{trecho_3_confirmado_base_rag}}",
          "habilidade_associada": "EM13CHS104"
        }
      ],
      "atividades_sugeridas": [
        "Pesquisa sociológica escolar: {{tema_pesquisa_1}}",
        "Oficina de leitura e interpretação de gráficos e tabelas",
        "Debate regrado sobre {{tema_debate_2}}",
        "Produção de infográfico com dados sociológicos sobre {{tema_infografico}}",
        "Produção de texto dissertativo-argumentativo (tema: {{tema_redacao_2}})"
      ],
      "avaliacao_parcial": "Pesquisa sociológica + infográfico + participação em debate + texto dissertativo-argumentativo (peso 3)"
    },
    "mes_3": {
      "unidade_tematica": "{{unidade_tematica_mes_3}}",
      "topico": "{{topico_mes_3}}",
      "tradicao_sociologica": "{{tradicao_mes_3}}",
      "habilidades_bncc": ["EM13CHS201", "EM13CHS202", "EM13CHS203", "EM13CHS204"],
      "objetos_conhecimento": [
        "{{topico_mes_3}}: conceituação e contextualização contemporânea",
        "Teorias sociológicas contemporâneas sobre {{tema_contemporaneo}}",
        "Dados e indicadores atualizados: {{fonte_dados_confirmada_base_rag_3}}",
        "Conexão com o ENEM: {{tema_enem_relacionado}}",
        "Diálogo com o presente: {{conexao_contemporanea_3}}",
        "Síntese do trimestre: articulação dos conceitos trabalhados nos meses 1, 2 e 3"
      ],
      "aulas_previstas": 10,
      "textos_e_dados_mes": [
        {
          "tipo": "documento_sociologico",
          "fonte": "{{fonte_confirmada_base_rag_3}}",
          "descricao": "Relatório, documento ou texto contemporâneo sobre {{tema_contemporaneo}}",
          "habilidade_associada": "EM13CHS201"
        }
      ],
      "atividades_sugeridas": [
        "Simulado ENEM — Ciências Humanas (questões de Sociologia)",
        "Projeto de intervenção social: diagnóstico e proposta sobre {{problema_local}}",
        "Mostra sociológica: apresentação dos projetos de pesquisa desenvolvidos no trimestre",
        "Autoavaliação do trimestre com devolutiva coletiva"
      ],
      "avaliacao_parcial": "Simulado ENEM + projeto de intervenção + participação na mostra + autoavaliação (peso 4)"
    }
  },
  "avaliacao_trimestral": {
    "composicao": [
      {"instrumento": "Avaliações parciais (média dos 3 meses)", "peso": 6},
      {"instrumento": "Projeto de intervenção social", "peso": 2},
      {"instrumento": "Autoavaliação e participação", "peso": 2}
    ],
    "recuperacao_paralela": {
      "estrategia": "Roteiro de estudos dirigidos com leituras complementares e exercícios de análise de dados sociológicos",
      "reavaliacao": "Prova escrita com questões abertas e análise de indicadores sociais (substitui a menor nota parcial)"
    }
  },
  "conexao_enem": {
    "competencias_prioritarias": ["C1", "C3", "C5"],
    "temas_provaveis": [
      "Desigualdade social e estratificação",
      "Cidadania, direitos humanos e movimentos sociais",
      "Trabalho e sociedade no capitalismo contemporâneo",
      "Cultura, identidade e diversidade",
      "Violência e segurança pública no Brasil"
    ],
    "estrategia_preparacao": "Ao longo do trimestre, toda atividade de análise de dados e produção textual dialoga diretamente com o formato ENEM. Os simulados reproduzem as condições reais da prova (tempo, tipo de questão, matriz de referência)."
  },
  "adaptacao_pdi": {
    "principios": [
      "Flexibilização de prazos de entrega conforme necessidade individual",
      "Disponibilização de materiais em formatos acessíveis (áudio, braille, fonte ampliada)",
      "Glossário sociológico trimestral com definições simplificadas e exemplos visuais",
      "Mediação de leitura para alunos com dificuldades específicas",
      "Avaliação diferenciada conforme plano individualizado (mesmo conteúdo, formato adaptado)"
    ]
  },
  "recursos_materiais_trimestre": [
    "Livro didático PNLD ({{livro_pnld}})",
    "Trechos selecionados dos clássicos (Durkheim, Weber, Marx) — {{obras_selecionadas}}",
    "Bases de dados: IBGE (Censo, PNAD), IPEA, Datafolha, MEC/INEP (Censo Escolar, IDEB)",
    "Documentários e filmes: {{lista_filmes}}",
    "Infraestrutura: projetor multimídia, acesso à internet (laboratório de informática ou dispositivos móveis)"
  ]
}
```
