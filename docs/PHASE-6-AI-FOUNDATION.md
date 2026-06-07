# PHASE-6-AI-FOUNDATION

Primeira integração oficial de Inteligência Artificial do PROFEPLAN V2, implementada no pacote monorepo `@profeplan/ai`.

## Objetivo

Implementar um serviço de IA robusto, previsível e altamente tipado para o enriquecimento pedagógico de planejamentos de período letivo (`TermPlan`), persistindo as respostas estruturadas diretamente no banco de dados relacional.

## Arquitetura do Pacote `@profeplan/ai`

O pacote foi isolado e encapsulado em `packages/ai` com a seguinte estrutura interna de arquivos:

- `src/index.ts`: Ponto de entrada oficial exportando as funções públicas e contratos de tipos.
- `src/term-plan.ts`: Implementação do fluxo central `enhanceTermPlan(termPlanId, options)`.
- `src/openai.ts`: Inicialização resiliente do cliente OpenAI.
- `src/env.ts`: Carregamento seguro e validação das variáveis de ambiente (`OPENAI_API_KEY`, `OPENAI_MODEL`).
- `src/types.ts`: Definições estáticas dos payloads de enriquecimento e resultados.
- `src/prompts/term-plan.ts`: Prompt Builder que transforma o registro `TermPlan` em uma entrada estruturada para o modelo de linguagem.
- `src/test-flow.ts`: Script de testes de integração e validação ponta a ponta do fluxo.

## Fluxo de Execução

O método `enhanceTermPlan(termPlanId)` executa o seguinte fluxo determinístico:

```text
  ┌─────────────────┐
  │   Buscar de DB  │  Recupera o TermPlan pelo ID usando Prisma
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Construir Prompt│  Formata dados do TermPlan e restrições pedagógicas no prompt
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │  OpenAI API Call│  Invoca client.responses.create com strict JSON schema
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Parse & Validar │  Enforça a tipagem estática e parses de retorno
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │  Persistir DB   │  Atualiza TermPlan com aiEnhancedContent, aiModel e aiEnhancedAt
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Retornar Objeto │  Retorna resultado tipado para a camada de consumo superior
  └─────────────────┘
```

## Regras Pedagógicas e de IA

Seguindo as premissas de simplicidade e confiabilidade da V2, aplicamos as seguintes restrições arquiteturais:

- **Sem Complexidade Desnecessária**: Sem CrewAI, sem LangGraph, sem frameworks multiagentes e sem motores RAG.
- **Segurança e Privacidade**: O prompt builder impede estritamente a alucinação ou vazamento de dados sensíveis de alunos e restringe o assistente pedagógico a atuar sob o contexto escolar brasileiro.
- **Saída Garantida via JSON Schema**: A chamada utiliza a API de Responses com modo `strict: true` e um esquema JSON estrito, garantindo que o modelo nunca retorne Markdown bruto ou propriedades extras fora da tipagem esperada.

### Contrato de Dados (JSON Schema)

```typescript
export type TermPlanEnhancement = {
  summary: string;
  objectives: string[];
  suggestedSequence: string[];
  assessmentIdeas: string[];
  differentiationStrategies: string[];
  teacherNotes: string;
};
```

## Persistência de Dados

A persistência do enriquecimento ocorre diretamente na tabela `TermPlan` da base PostgreSQL do Supabase utilizando o Prisma Client:

```prisma
model TermPlan {
  id                 String         @id @default(uuid())
  ...
  aiEnhancedContent  Json?          // Payload TermPlanEnhancement completo
  aiEnhancedAt       DateTime?      // Carimbo de data/hora do enriquecimento
  aiModel            String?        // Identificador do modelo LLM utilizado
  ...
}
```

---

## Verificação e Evidências

### 1. Compilação TypeScript

O typecheck foi executado com sucesso nas diretrizes estritas do compilador:

```bash
npx pnpm --filter @profeplan/ai typecheck
# Saída: tsc --noEmit (Sucesso, zero erros de tipo)
```

### 2. Validação do Fluxo de Integração

Um script completo foi executado gerando e removendo dados reais da base relacional por meio do Prisma Client, integrando-se a um cliente mockado que valida o builder e as chamadas da API:

```bash
npx pnpm --filter @profeplan/ai validate-flow
```

**Log de execução bem-sucedida (2026-06-01):**

```text
🚀 Starting PHASE-6-AI-FOUNDATION full-flow validation...

🧹 Cleaning up any leftover test data...
📦 Creating test User and Organization...
🔗 Creating Membership linking User to Organization...
📝 Creating TermPlan to be enriched...

🔮 Executing enhanceTermPlan function with Mock OpenAI Client...

🤖 [Mock OpenAI Client] Received Prompt:
- Model: mock-gpt-4o-mini
- Messages Count: 2
- Strict Schema: true
- Format Name: term_plan_enhancement

✨ Execution completed. Verifying results...
✅ Returned result correctly matches mock payload!

🗄️ Checking persisted DB values:
- aiModel: mock-gpt-4o-mini
- aiEnhancedAt: Mon Jun 01 2026 21:36:01 GMT-0300 (Horário Padrão de Brasília)
- aiEnhancedContent: {
  "summary": "Resumo enriquecido pelo assistente pedagógico IA do PROFEPLAN V2.",
  "objectives": [
    "Desenvolver habilidades de leitura e interpretação de textos literários.",
    "Identificar elementos narrativos estruturais e figuras de linguagem."
  ],
  "teacherNotes": "Recomenda-se reservar os últimos 15 minutos de cada aula para compartilhamento espontâneo de leituras.",
  "assessmentIdeas": [
    "Avaliação formativa baseada na participação nas discussões de crônicas.",
    "Avaliação somativa com a produção e revisão paritária de um texto autoral."
  ],
  "suggestedSequence": [
    "Semana 1-2: Leitura de crônicas brasileiras clássicas.",
    "Semana 3-4: Oficina prática de escrita criativa e estilística."
  ],
  "differentiationStrategies": [
    "Disponibilização de audiobooks dos textos recomendados para acessibilidade.",
    "Roteiros de apoio estruturados para alunos que necessitam de suporte extra."
  ]
}
✅ Database persistence validated perfectly!

🧹 Cleaning up test data from database...
✅ Database cleaned up completely.

🎉 ALL FLOW VALIDATIONS PASSED SUCCESSFULLY!
```
