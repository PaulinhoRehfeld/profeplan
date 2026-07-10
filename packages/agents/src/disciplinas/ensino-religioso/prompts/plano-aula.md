# Template de Prompt — Plano de Aula (Ensino Religioso)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Ensino Religioso seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados sobre
religiões, doutrinas, textos sagrados ou códigos da BNCC.

**REGRA INEGOCIÁVEL:** O plano de aula DEVE respeitar a laicidade do Estado.
PROIBIDO proselitismo religioso. PROIBIDO doutrinação. Todas as tradições
religiosas e filosofias de vida não religiosas DEVEM ser tratadas com igual
respeito e dignidade.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Ensino Religioso
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Ensino Religioso",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF06ER01",
      "descricao": "Reconhecer o papel da tradição escrita na preservação de ensinamentos e valores..."
    }
  ],
  "objetivos_aprendizagem": [
    "Compreender {{conceito_central}} nas diferentes tradições religiosas e filosofias de vida...",
    "Identificar semelhanças e diferenças entre as abordagens de {{tradicao_1}} e {{tradicao_2}} sobre {{tema}}...",
    "Refletir sobre como {{tema}} se relaciona com valores éticos e a cultura de paz...",
    "Produzir {{tipo_producao}} expressando sua compreensão respeitosa sobre {{tema}}..."
  ],
  "conteudos_programaticos": [
    "{{conceito_central}}: definição e contextualização na área de Ensino Religioso",
    "Perspectiva da tradição {{tradicao_1}}: textos sagrados, ensinamentos e valores sobre {{tema}}",
    "Perspectiva da tradição {{tradicao_2}}: textos sagrados, ensinamentos e valores sobre {{tema}}",
    "Perspectiva de filosofias de vida não religiosas sobre {{tema}}",
    "Valores éticos comuns: {{valor_1}}, {{valor_2}}, {{valor_3}}",
    "Conexões com a cultura de paz, direitos humanos e cidadania"
  ],
  "textos_de_referencia": [
    {
      "tipo": "texto_sagrado",
      "tradicao": "{{tradicao_1}}",
      "fonte": "{{fonte_confirmada_base_rag}}",
      "trecho_selecionado": "{{trecho_confirmado_na_base_rag}}",
      "orientacao_leitura": "Leia com atenção e identifique os valores e ensinamentos presentes no trecho. Compare com a perspectiva de outras tradições."
    },
    {
      "tipo": "texto_reflexivo",
      "tradicao": "{{tradicao_2}}",
      "fonte": "{{fonte_confirmada_base_rag}}",
      "trecho_selecionado": "{{trecho_confirmado_na_base_rag}}",
      "orientacao_leitura": "Reflita sobre como este ensinamento pode ser aplicado no dia a dia, independentemente da crença pessoal."
    }
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora para engajar os alunos na reflexão sobre {{tema}}, respeitando a diversidade de crenças...",
      "estrategia": "Pergunta provocadora / vídeo curto / imagem simbólica / música / dinâmica de grupo"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de leitura, análise, reflexão e diálogo inter-religioso...",
      "etapas": [
        {
          "titulo": "Leitura e Análise de Textos Sagrados",
          "descricao": "Leitura compartilhada dos trechos selecionados com mediação do professor, destacando valores comuns e diferenças entre as tradições...",
          "recurso": "Trechos impressos/projetados de textos sagrados de diferentes tradições"
        },
        {
          "titulo": "Diálogo Inter-religioso em Grupo",
          "descricao": "Discussão em pequenos grupos sobre os valores identificados nos textos, com perguntas norteadoras que promovam o respeito e a escuta ativa...",
          "recurso": "Roteiro de perguntas norteadoras; cartolina para registro"
        },
        {
          "titulo": "Síntese Coletiva",
          "descricao": "Cada grupo compartilha suas reflexões; o professor faz a mediação e constrói coletivamente um quadro comparativo no quadro...",
          "recurso": "Quadro branco ou projetor"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Retomada dos principais aprendizados e reflexão pessoal...",
      "estrategia": "Produção de parágrafo reflexivo / frase-síntese / compromisso pessoal com um valor discutido"
    }
  },
  "recursos_didaticos": [
    "Trechos de textos sagrados impressos ({{fontes_confirmadas_base_rag}})",
    "Projetor multimídia para exibição de imagens e vídeos",
    "Quadro branco e marcadores coloridos",
    "Cartolinas e canetas hidrocor para trabalho em grupo",
    "Mapa-múndi para localização geográfica das tradições estudadas"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação respeitosa nas discussões e no trabalho em grupo",
      "Capacidade de identificar valores comuns entre diferentes tradições",
      "Qualidade da reflexão pessoal apresentada no fechamento",
      "Respeito demonstrado às diferentes crenças dos colegas"
    ],
    "instrumento": "Observação do professor durante as atividades + registro escrito individual no fechamento"
  },
  "adaptacoes": {
    "alunos_com_deficiencia": "{{adaptacoes_pdi}}",
    "diversidade_religiosa": "Garantir que atividades NÃO exponham ou constranjam estudantes. Oferecer alternativas para estudantes que não se sintam confortáveis com determinada atividade. Lembrar que o Ensino Religioso é de matrícula facultativa.",
    "alunos_nao_alfabetizados": "{{adaptacoes_alfabetizacao}}"
  },
  "nota_importante": "Este plano de aula foi elaborado em conformidade com o princípio constitucional da LAICIDADE DO ESTADO (Art. 19, I, CF/88). NÃO contém proselitismo religioso nem doutrinação. Todas as tradições religiosas e filosofias de vida não religiosas são tratadas com igual respeito e dignidade."
}
```
