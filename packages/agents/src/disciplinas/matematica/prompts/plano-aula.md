# Template de Prompt — Plano de Aula (Matemática)

## INSTRUÇÕES PARA O LLM

Gere um plano de aula completo de Matemática seguindo ESTRITAMENTE a
estrutura abaixo. Preencha todos os campos. Se uma informação não estiver
disponível no contexto, indique `[A DEFINIR]` — NUNCA invente dados.

## PARÂMETROS DE ENTRADA

- **Disciplina:** Matemática
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
    "disciplina": "Matemática",
    "ano_serie": "{{ano_serie}}",
    "tema": "{{tema}}",
    "duracao": "{{duracao}}",
    "professor": "{{professor_nome}}"
  },
  "habilidades_bncc": [
    {
      "codigo": "EF06MA03",
      "descricao": "Resolver e elaborar problemas que envolvam cálculos..."
    }
  ],
  "objetivos_aprendizagem": [
    "Resolver problemas envolvendo {{conceito_principal}} utilizando estratégias variadas...",
    "Representar situações-problema por meio de {{representacao_matematica}}...",
    "Validar os resultados encontrados por meio de estimativas e verificação..."
  ],
  "conteudos_programaticos": [
    "{{topico_principal}}: definição e propriedades",
    "Estratégias de resolução: {{estrategia_1}}, {{estrategia_2}}",
    "Aplicações no cotidiano: {{contexto_aplicacao}}"
  ],
  "desenvolvimento": {
    "aquecimento": {
      "duracao_min": 10,
      "descricao": "Situação disparadora ou problema desafiador para engajar os alunos...",
      "estrategia": "Pergunta investigativa / desafio rápido / curiosidade matemática"
    },
    "desenvolvimento": {
      "duracao_min": 30,
      "descricao": "Atividade principal de exploração, investigação e/ou resolução de problemas...",
      "etapas": [
        {
          "titulo": "Exploração do Conceito",
          "descricao": "Apresentação do conceito com exemplos concretos e/ou representações visuais...",
          "recurso": "Quadro branco / GeoGebra / material manipulável"
        },
        {
          "titulo": "Prática Guiada",
          "descricao": "Resolução de problemas em duplas com mediação do professor...",
          "recurso": "Folha de atividades / livro didático p. XX"
        }
      ]
    },
    "fechamento": {
      "duracao_min": 10,
      "descricao": "Sistematização coletiva dos aprendizados e registro no caderno...",
      "estrategia": "Mapa mental / resolução coletiva no quadro / ticket de saída"
    }
  },
  "recursos_didaticos": [
    "Projetor multimídia",
    "Quadro branco e marcadores",
    "Material manipulável: {{material}}",
    "Software GeoGebra (ou similar)",
    "Livro didático, páginas XX-YY"
  ],
  "avaliacao": {
    "tipo": "Formativa",
    "criterios": [
      "Compreensão do conceito matemático trabalhado",
      "Estratégia utilizada na resolução de problemas",
      "Capacidade de comunicar o raciocínio matemático (oral e escrito)",
      "Participação e engajamento nas atividades"
    ],
    "instrumento": "Observação direta com rubrica / atividade escrita / resolução no quadro"
  },
  "adaptacoes_inclusao": {
    "deficiencia_visual": "Material em relevo / áudio-descrição de gráficos e figuras / régua adaptada...",
    "deficiencia_auditiva": "Instruções escritas detalhadas / uso de recursos visuais ampliados...",
    "tdah": "Dividir problemas em etapas curtas com checkpoints visuais...",
    "dislexia": "Enunciados com fonte ampliada e espaçamento maior / leitura compartilhada...",
    "discalculia": "Uso de material concreto / calculadora quando apropriado / mais tempo...",
    "altas_habilidades": "Problemas-desafio adicionais / extensão do conteúdo com aplicações avançadas..."
  },
  "tarefa_casa": "Resolver a lista de problemas de fixação (p. XX do livro) e registrar as estratégias utilizadas no caderno."
}
```

## OBSERVAÇÕES CRÍTICAS

- **NÃO** invente códigos BNCC ou fórmulas — use apenas os fornecidos nos parâmetros
- **SIM** adapte o plano ao ano/série indicado — complexidade progressiva
- **SIM** inclua adaptações para inclusão SEMPRE, incluindo discalculia
- **SIM** especifique os minutos de cada etapa
- **VALORIZE O PROCESSO DE RESOLUÇÃO**, não apenas a resposta correta
- O campo `tarefa_casa` é OBRIGATÓRIO
- Para Ensino Médio, inclua sempre questões no estilo ENEM
