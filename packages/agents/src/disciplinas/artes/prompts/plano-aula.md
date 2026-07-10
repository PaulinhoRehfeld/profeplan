# Template de Prompt — Plano de Aula (Artes)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Artes seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## REGRA CRÍTICA

**PROIBIDO INVENTAR OBRAS DE ARTE OU ARTISTAS.** Toda referência a obras
de arte, artistas, movimentos artísticos ou datas DEVE ser verificável na
base RAG. Se não tiver certeza de uma informação, indique `[CONSULTAR FONTE]`.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Artes
- **Ano/Série:** {{ano_serie}}
- **Tema da Aula:** {{tema}}
- **Linguagem Artística:** {{linguagem_artistica}} (Artes Visuais / Música / Dança / Teatro)
- **Duração:** {{duracao}} (em minutos ou número de aulas de 50 min)
- **Habilidades BNCC:** {{habilidades_bncc}}
- **Plano de Curso (se disponível):** {{plano_curso}}
- **Livro Didático (PNLD):** {{livro_pnld}}
- **Obras/Artistas de Referência (base RAG):** {{referencias_rag}}

## ESTRUTURA DE SAÍDA (JSON)

```json
{
  "cabecalho": {
    "disciplina": "Artes",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "linguagem_artistica": "{{linguagem_artistica}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF69AR01",
      "descricao": "Pesquisar, apreciar e analisar formas distintas das artes visuais..."
    }
  ],
  "objetivos_aprendizagem": [
    "Identificar as principais características do movimento artístico estudado...",
    "Analisar obras de arte do período, distinguindo elementos formais e contextuais...",
    "Produzir trabalho artístico inspirado nas técnicas e conceitos estudados..."
  ],
  "conteudos_programaticos": [
    "Conceito-chave: {{conceito}}",
    "Movimento artístico: {{movimento}}",
    "Principais artistas e obras: {{artistas_obras}}"
  ],
  "desenvolvimento_aula": {
    "momento_1_apreciacao": {
      "duracao_minutos": 10,
      "descricao": "Apresentação de obras de referência. Projeção de imagens / audição de trechos musicais / vídeos de dança ou teatro.",
      "obras_referencia": [
        {
          "titulo": "{{titulo_obra}}",
          "artista": "{{artista}}",
          "ano": "{{ano_obra}}",
          "fonte_rag": "{{fonte}}"
        }
      ],
      "perguntas_instigadoras": [
        "O que você vê/ouve/sente nesta obra?",
        "Que cores, formas, sons ou movimentos chamam sua atenção?"
      ]
    },
    "momento_2_criacao": {
      "duracao_minutos": 25,
      "descricao": "Atividade prática de criação artística inspirada nas obras estudadas.",
      "materiais_necessarios": [
        "{{material_1}} (alternativa de baixo custo: {{alternativa_1}})",
        "{{material_2}} (alternativa de baixo custo: {{alternativa_2}})"
      ],
      "passo_a_passo": [
        "1. {{passo_1}}",
        "2. {{passo_2}}",
        "3. {{passo_3}}"
      ],
      "adaptacao_pdi": "{{adaptacao_para_alunos_com_deficiencia}}"
    },
    "momento_3_reflexao": {
      "duracao_minutos": 15,
      "descricao": "Roda de conversa, compartilhamento das produções e reflexão crítica.",
      "perguntas_reflexivas": [
        "Como foi o processo de criação?",
        "O que você aprendeu sobre o movimento artístico estudado?",
        "Como sua produção se relaciona com as obras de referência?"
      ]
    }
  },
  "avaliacao": {
    "tipo": "Formativa — observação do processo",
    "criterios": [
      "Participação nas discussões de apreciação",
      "Engajamento no processo criativo",
      "Capacidade de relacionar sua produção com as referências estudadas"
    ],
    "rubrica": {
      "excelente": "Participa ativamente, demonstra compreensão do conceito e cria com autonomia",
      "satisfatorio": "Participa e cria, com necessidade de orientação pontual",
      "em_desenvolvimento": "Participa parcialmente, necessita de mediação constante"
    }
  },
  "recursos_didaticos": [
    "Projetor multimídia ou TV",
    "Impressões coloridas das obras (caso não haja projetor)",
    "{{materiais_especificos}}"
  ],
  "referencias": [
    {
      "tipo": "Obra de arte",
      "titulo": "{{titulo}}",
      "artista": "{{artista}}",
      "fonte_rag": "{{fonte_confirmada}}"
    },
    {
      "tipo": "Livro didático",
      "titulo": "{{livro_pnld}}",
      "paginas": "{{paginas}}"
    }
  ],
  "tarefa_casa": "{{tarefa_casa}}"
}
```
