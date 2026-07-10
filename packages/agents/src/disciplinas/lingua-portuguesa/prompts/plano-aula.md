# Template de Prompt — Plano de Aula (Língua Portuguesa)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Língua Portuguesa seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Língua Portuguesa
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
    "disciplina": "Língua Portuguesa",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF67LP28",
      "descricao": "Ler, de forma autônoma, e compreender..."
    }
  ],
  "objetivos_aprendizagem": [
    "Identificar os elementos constitutivos do gênero textual...",
    "Produzir um texto do gênero... respeitando sua estrutura...",
    "Analisar os recursos linguísticos utilizados no texto..."
  ],
  "conteudos_programaticos": [
    "Gênero textual: {{genero}}",
    "Elementos da narrativa / estrutura do texto",
    "Recursos coesivos: conjunções, pronomes, advérbios"
  ],
  "desenvolvimento": {
    "introducao": {
      "duracao_min": 10,
      "descricao": "Atividade de sensibilização / levantamento de conhecimentos prévios...",
      "estrategia": "Roda de conversa / pergunta disparadora / leitura de imagem"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de leitura, análise e/ou produção textual...",
      "etapas": [
        {
          "titulo": "Leitura e Análise",
          "descricao": "Leitura compartilhada do texto-base. Identificação de...",
          "recurso": "Texto impresso / projetor / livro didático p. XX"
        },
        {
          "titulo": "Atividade Prática",
          "descricao": "Em duplas, os alunos deverão...",
          "recurso": "Caderno / folha de atividade"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Síntese coletiva dos aprendizados da aula...",
      "estrategia": "Compartilhamento de produções / mapa mental coletivo / ticket de saída"
    }
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Texto impresso: {{titulo_texto}}",
    "Quadro branco e marcadores",
    "Livro didático, páginas XX-YY"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Participação nas discussões orais",
      "Compreensão do gênero textual trabalhado",
      "Qualidade da produção textual (adequação ao gênero, coesão, coerência)"
    ],
    "instrumento": "Rubrica de correção da produção textual / observação direta"
  },
  "adaptacoes_inclusao": {
    "deficiencia_visual": "Texto em fonte ampliada / audiodescrição...",
    "deficiencia_auditiva": "Instruções escritas no quadro / legenda em vídeos...",
    "tdah": "Dividir a atividade em etapas menores com checkpoints...",
    "dislexia": "Fonte OpenDyslexic / leitura em voz alta / tempo adicional..."
  },
  "tarefa_casa": "Pesquisar e trazer um exemplo do gênero textual estudado para a próxima aula."
}
```

## OBSERVAÇÕES CRÍTICAS

- **NÃO** invente códigos BNCC — use apenas os fornecidos nos parâmetros
- **SIM** adapte o plano ao ano/série indicado — complexidade progressiva
- **SIM** inclua adaptações para inclusão SEMPRE
- **SIM** especifique os minutos de cada etapa
- O campo `tarefa_casa` é OBRIGATÓRIO
