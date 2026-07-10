# Template de Prompt — Plano de Aula (História)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de História seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR FATOS OU DATAS HISTÓRICAS.** Toda informação factual
deve ser verificável. Se não tiver certeza de um dado, indique
`[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** História
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Fontes Primárias Disponíveis:** {{fontes_primarias}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "História",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF06HI01",
      "descricao": "Identificar diferentes formas de compreensão da noção de tempo..."
    }
  ],
  "objetivos_aprendizagem": [
    "Identificar as principais características do período histórico estudado...",
    "Analisar fontes primárias relacionadas ao tema, distinguindo fato de interpretação...",
    "Relacionar o processo histórico estudado com o contexto atual..."
  ],
  "conteudos_programaticos": [
    "Conceito-chave: {{conceito}}",
    "Contexto histórico: {{periodo}}",
    "Principais acontecimentos e personagens históricos",
    "Fontes históricas: {{tipo_fonte}}"
  ],
  "fontes_historicas_utilizadas": [
    {
      "tipo": "Documento escrito",
      "descricao": "Trecho de {{documento}}...",
      "fonte_verificavel": "{{referencia_completa}}"
    },
    {
      "tipo": "Imagem de época",
      "descricao": "{{descricao_imagem}}...",
      "fonte_verificavel": "{{referencia_completa}}"
    }
  ],
  "desenvolvimento": {
    "introducao": {
      "duracao_min": 10,
      "descricao": "Atividade de sensibilização / levantamento de conhecimentos prévios...",
      "estrategia": "Pergunta disparadora / imagem de época / linha do tempo interativa"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de análise de fontes e construção do conhecimento histórico...",
      "etapas": [
        {
          "titulo": "Análise de Fontes",
          "descricao": "Em grupos, os alunos analisam as fontes primárias fornecidas seguindo o protocolo: observar, questionar, interpretar...",
          "recurso": "Cópias de documentos / projeção de imagens / tablets"
        },
        {
          "titulo": "Sistematização Coletiva",
          "descricao": "Cada grupo compartilha suas conclusões. O professor registra no quadro as principais ideias, organizando-as cronologicamente ou tematicamente...",
          "recurso": "Quadro branco / projetor"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Síntese coletiva conectando o conteúdo da aula com o presente...",
      "estrategia": "Ticket de saída: 'O que você aprendeu hoje que pode relacionar com o mundo atual?'"
    }
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Cópias de fontes primárias (documentos, imagens)",
    "Quadro branco e marcadores",
    "Mapa histórico: {{mapa}}",
    "Livro didático, páginas XX-YY"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação na análise de fontes primárias",
      "Capacidade de estabelecer relações entre passado e presente",
      "Qualidade da argumentação histórica (uso de evidências)",
      "Respeito a diferentes perspectivas durante o debate"
    ],
    "instrumento": "Observação direta / Rubrica de análise de fontes / Ticket de saída"
  },
  "adaptacoes_inclusao": {
    "deficiencia_visual": "Fontes em formato ampliado / audiodescrição de imagens históricas...",
    "deficiencia_auditiva": "Instruções escritas no quadro / legendas em vídeos...",
    "tdah": "Dividir a análise de fontes em etapas menores com checkpoints...",
    "dislexia": "Leitura compartilhada das fontes / tempo adicional para atividades escritas..."
  },
  "tarefa_casa": "Entrevistar um familiar sobre como era a vida na época em que ele/ela tinha a sua idade e trazer um relato escrito para a próxima aula."
}
```

## OBSERVAÇÕES CRÍTICAS

- **NÃO** invente códigos BNCC — use apenas os fornecidos nos parâmetros
- **NÃO** invente fatos, datas, nomes ou eventos históricos
- **SIM** inclua SEMPRE pelo menos uma fonte primária na aula
- **SIM** adapte o plano ao ano/série indicado — complexidade progressiva
  (6º ano: História e tempo; 7º ano: Brasil Colônia; 8º ano: Brasil Império
  e Revoluções; 9º ano: Brasil República e História Contemporânea)
- **SIM** inclua adaptações para inclusão SEMPRE
- **SIM** especifique os minutos de cada etapa
- O campo `tarefa_casa` é OBRIGATÓRIO
- Para EF: evite jargão acadêmico, priorize analogias e exemplos concretos
- Para EM: inclua perspectivas historiográficas e prepare para o ENEM
