# Template de Prompt — Planejamento Trimestral (Ensino Religioso)

## INSTRUÇÕES PARA O LLM

Gere um planejamento trimestral completo de Ensino Religioso seguindo
ESTRITAMENTE a estrutura abaixo. Preencha todos os campos. Se uma informação
não estiver disponível no contexto, indique `[A DEFINIR]` — NUNCA invente
dados sobre religiões, doutrinas, textos sagrados ou códigos da BNCC.

**REGRA INEGOCIÁVEL:** O planejamento DEVE respeitar a laicidade do Estado.
PROIBIDO proselitismo religioso. PROIBIDO doutrinação. Todas as tradições
religiosas e filosofias de vida não religiosas DEVEM ser tratadas com igual
respeito e dignidade.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Ensino Religioso
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
    "disciplina": "Ensino Religioso",
    "ano_serie": "{{ano_serie}}",
    "trimestre": "{{trimestre}}",
    "ano_letivo": "{{ano_letivo}}",
    "carga_horaria_semanal": "{{carga_horaria}} aulas",
    "total_aulas_trimestre": "{{total_aulas}}"
  },
  "competencias_especificas": [
    {
      "codigo": "CE01",
      "descricao": "Conhecer os aspectos estruturantes das diferentes tradições religiosas e filosofias de vida, a partir de pressupostos científicos, filosóficos, estéticos e éticos.",
      "fonte": "BNCC — Ensino Religioso — Ensino Fundamental"
    },
    {
      "codigo": "CE02",
      "descricao": "Compreender, valorizar e respeitar as manifestações religiosas e filosofias de vida, suas experiências e saberes, em diferentes tempos, espaços e territórios.",
      "fonte": "BNCC — Ensino Religioso — Ensino Fundamental"
    },
    {
      "codigo": "CE04",
      "descricao": "Conviver com a diversidade de crenças, pensamentos, convicções, modos de ser e viver.",
      "fonte": "BNCC — Ensino Religioso — Ensino Fundamental"
    },
    {
      "codigo": "CE06",
      "descricao": "Debater, problematizar e posicionar-se frente aos discursos e práticas de intolerância, discriminação e violência de cunho religioso, de modo a assegurar os direitos humanos no constante exercício da cidadania e da cultura de paz.",
      "fonte": "BNCC — Ensino Religioso — Ensino Fundamental"
    }
  ],
  "eixos_estruturadores": [
    {
      "eixo": "Crenças religiosas e filosofias de vida",
      "descricao": "Estudo das ideias centrais das diferentes tradições religiosas e filosofias de vida, seus textos sagrados, mitos fundantes, doutrinas e concepções de divindade, transcendência e imanência"
    },
    {
      "eixo": "Manifestações religiosas",
      "descricao": "Estudo das práticas, ritos, celebrações, símbolos, espaços sagrados e lideranças religiosas de diferentes tradições"
    },
    {
      "eixo": "Identidades, alteridades e cultura de paz",
      "descricao": "Relações entre religião, identidade, diversidade, diálogo inter-religioso, laicidade, direitos humanos, combate à intolerância religiosa e construção de projetos de vida"
    }
  ],
  "distribuicao_mensal": {
    "mes_1": {
      "unidade_tematica": "{{unidade_tematica_mes_1}}",
      "topico": "{{topico_mes_1}}",
      "tradicoes_abordadas": ["{{tradicao_1}}", "{{tradicao_2}}", "{{tradicao_3}}"],
      "habilidades_bncc": ["EF06ER01", "EF06ER02", "EF06ER03"],
      "objetos_conhecimento": [
        "{{conceito_central}}: definição e importância no estudo das religiões",
        "Textos sagrados da tradição {{tradicao_1}}: origem, estrutura e ensinamentos",
        "Textos sagrados da tradição {{tradicao_2}}: origem, estrutura e ensinamentos",
        "Valores éticos comuns: {{valor_1}}, {{valor_2}}",
        "Respeito à diversidade: conhecendo o diferente sem julgar"
      ],
      "aulas_previstas": 12,
      "textos_e_materiais_mes": [
        {
          "tipo": "texto_sagrado",
          "tradicao": "{{tradicao_1}}",
          "referencia": "{{referencia_confirmada_base_rag}}"
        },
        {
          "tipo": "video_documentario",
          "tema": "{{tema_video}}",
          "fonte": "{{fonte_confirmada_base_rag}}"
        }
      ],
      "atividades_avaliativas": [
        "Participação nas rodas de conversa e debates",
        "Registro no caderno de anotações sobre cada tradição estudada",
        "Pesquisa em grupo sobre uma tradição religiosa local"
      ],
      "temas_transversais": [
        "Diversidade cultural e religiosa no Brasil",
        "Respeito às diferenças",
        "Cultura de paz e diálogo"
      ]
    },
    "mes_2": {
      "unidade_tematica": "{{unidade_tematica_mes_2}}",
      "topico": "{{topico_mes_2}}",
      "tradicoes_abordadas": ["{{tradicao_4}}", "{{tradicao_5}}"],
      "habilidades_bncc": ["EF06ER04", "EF06ER05", "EF06ER06"],
      "objetos_conhecimento": [
        "Símbolos religiosos: significados e importância nas diferentes tradições",
        "Ritos e celebrações: diversidade de práticas religiosas",
        "Espaços sagrados: arquitetura, função e significado",
        "Lideranças religiosas: papéis e contribuições sociais"
      ],
      "aulas_previstas": 12,
      "atividades_avaliativas": [
        "Produção de cartaz ou mural sobre símbolos religiosos",
        "Apresentação em grupo sobre um espaço sagrado",
        "Autoavaliação da participação e do respeito demonstrado"
      ],
      "temas_transversais": [
        "Patrimônio cultural material e imaterial",
        "Liberdade religiosa como direito humano",
        "Intolerância religiosa: identificar e combater"
      ]
    },
    "mes_3": {
      "unidade_tematica": "{{unidade_tematica_mes_3}}",
      "topico": "{{topico_mes_3}}",
      "tradicoes_abordadas": ["{{tradicao_6}}", "Filosofias de vida não religiosas"],
      "habilidades_bncc": ["EF06ER01", "EF06ER02", "EF06ER03"],
      "objetos_conhecimento": [
        "Ética e valores nas tradições religiosas e filosofias de vida",
        "Projetos de vida: como os valores orientam nossas escolhas",
        "Cultura de paz: contribuições das religiões para a convivência harmoniosa",
        "Síntese do trimestre: o que aprendemos sobre diversidade religiosa"
      ],
      "aulas_previstas": 10,
      "atividades_avaliativas": [
        "Produção de texto reflexivo: 'O que aprendi sobre respeito e diversidade'",
        "Roda de conversa final: compartilhando aprendizados",
        "Avaliação do trimestre (prova ou trabalho)"
      ],
      "temas_transversais": [
        "Ética e cidadania",
        "Projeto de vida",
        "Direitos humanos e dignidade da pessoa humana"
      ]
    }
  },
  "metodologia": {
    "principios": [
      "Diálogo inter-religioso respeitoso — todas as tradições têm igual dignidade",
      "Abordagem descritiva e analítica, NUNCA prescritiva ou doutrinária",
      "Respeito à liberdade de consciência e crença de cada estudante",
      "Valorização da diversidade como riqueza cultural",
      "Promoção da cultura de paz e do combate à intolerância religiosa"
    ],
    "estrategias": [
      "Leitura e análise comparativa de textos sagrados",
      "Rodas de conversa e debates estruturados",
      "Pesquisas em grupo sobre tradições religiosas",
      "Visitas pedagógicas a espaços sagrados (com autorização)",
      "Uso de recursos audiovisuais (documentários, filmes, músicas)",
      "Produção de murais, cartazes e exposições sobre diversidade religiosa",
      "Projetos de combate à intolerância religiosa na escola"
    ],
    "recursos": [
      "Trechos de textos sagrados de diferentes tradições (impressos)",
      "Projetor multimídia e acesso à internet",
      "Mapa-múndi e mapa do Brasil para localização geográfica das tradições",
      "Cartolinas, canetas, materiais para produção de cartazes",
      "Livro didático do PNLD"
    ]
  },
  "cronograma_avaliacoes": [
    {
      "tipo": "Formativa — Participação e Caderno",
      "periodo": "Ao longo de todo o trimestre",
      "valor": 30,
      "descricao": "Avaliação contínua da participação respeitosa nas discussões, registro no caderno e realização das atividades propostas."
    },
    {
      "tipo": "Trabalho em Grupo — Pesquisa sobre Tradição Religiosa",
      "periodo": "Final do mês 1",
      "valor": 30,
      "descricao": "Pesquisa e apresentação sobre uma tradição religiosa local, destacando aspectos como textos sagrados, ritos, símbolos e valores éticos."
    },
    {
      "tipo": "Somativa — Prova ou Produção Textual",
      "periodo": "Final do trimestre",
      "valor": 40,
      "descricao": "Avaliação dos conhecimentos adquiridos sobre diversidade religiosa, valores éticos comuns e cultura de paz."
    }
  ],
  "observacoes_importantes": [
    "Este planejamento foi elaborado em conformidade com o princípio constitucional da LAICIDADE DO ESTADO (Art. 19, I, CF/88).",
    "NÃO contém proselitismo religioso nem doutrinação de qualquer natureza.",
    "Todas as tradições religiosas e filosofias de vida não religiosas são tratadas com igual respeito e dignidade.",
    "O Ensino Religioso é disciplina de oferta obrigatória pela escola e de matrícula FACULTATIVA para o estudante (Art. 33 da LDB).",
    "Atividades que envolvam visitas a espaços sagrados DEVEM ter autorização prévia dos responsáveis e caráter estritamente OBSERVACIONAL.",
    "Em caso de objeção de consciência do estudante ou dos responsáveis, a escola DEVE oferecer atividade alternativa.",
    "Datas comemorativas religiosas devem ser abordadas com equilíbrio, contemplando a diversidade de tradições presentes na comunidade escolar."
  ],
  "nota_importante": "Este planejamento trimestral foi elaborado em conformidade com o princípio constitucional da LAICIDADE DO ESTADO (Art. 19, I, CF/88). NÃO contém proselitismo religioso nem doutrinação. Todas as tradições religiosas e filosofias de vida não religiosas são tratadas com igual respeito e dignidade."
}
```
