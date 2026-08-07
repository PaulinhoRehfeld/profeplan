# Mapa de módulos de destino — Knowledge Factory

## Princípio

A Knowledge Factory será integrada modularmente ao monorepo. Nenhum pacote monolítico novo será criado sem evidência de necessidade.

## Destino inicial — primeiro PR

### `packages/types/src/knowledge-factory/`

**Responsabilidade proposta:** contratos puros, enums, tipos versionados e invariantes de domínio.

Estrutura indicativa:

```text
packages/types/src/knowledge-factory/
├── source.ts
├── segment.ts
├── component.ts
├── curriculum.ts
├── agent.ts
├── production-order.ts
├── retrieval.ts
├── validation.ts
├── delivery.ts
├── enums.ts
├── index.ts
└── __tests__/
```

**Justificativa:** `@profeplan/types` já é o pacote compartilhado de contratos e não possui dependências de infraestrutura.

**Limitação atual:** não possui scripts de build, typecheck ou test. Qualquer tooling mínimo deverá ser incluído somente no primeiro PR autorizado e sem refatorar contratos legados.

**Runtime schemas:** Zod existe em `apps/web`, mas não em `packages/types`. Se schemas executáveis exigirem uma dependência nova, o Codex deverá interromper e solicitar aprovação. Não instalar silenciosamente.

## Destinos posteriores

### `packages/industry-pnld`

**Responsabilidade futura:**

- ingestão de fontes;
- procedência;
- checksum;
- licença e autorização;
- extração estrutural;
- evidência de origem.

**Estado atual:** scripts Python, sem validação no CI principal.

**Primeiro PR:** fora do escopo.

### `packages/industry-curriculum`

**Responsabilidade futura:**

- normalização do currículo MG;
- pacote curricular versionado;
- vínculos entre componentes e nós curriculares;
- processos de ingestão curricular.

**Estado atual:** scripts Python para currículo e RAG, sem package.json e sem CI Python identificado.

**Primeiro PR:** fora do escopo.

### `packages/db` e Supabase

**Responsabilidade futura:**

- persistência;
- migrations;
- RLS;
- auditoria;
- versionamento físico;
- acesso protegido ao corpus.

**Estado atual:** pacote Prisma excluído do CI geral e associado a stack legada/inativa. A decisão entre Prisma e SQL Supabase permanece aberta.

**Primeiro PR:** expressamente proibido.

### `packages/ai`

**Responsabilidade futura:**

- ModelPolicy;
- retrieval híbrido;
- montagem de contexto;
- geração autoral;
- política de tokens, retry e fallback.

**Estado atual:** depende de `packages/db`, está excluído do CI geral e não possui suíte de testes declarada.

**Primeiro PR:** fora do escopo.

### `packages/agents`

**Responsabilidade futura:**

- runtime comum;
- roteamento;
- perfil Sócrates 2;
- ferramentas permitidas;
- orquestração;
- quality gates;
- feature flags.

**Estado atual:** estrutura relevante já existe, mas workflow específico está quebrado por conflito de pnpm.

**Primeiro PR:** não alterar.

### `api/`

**Responsabilidade futura provável:**

- superfície HTTP ativa no Vercel;
- criação e consulta de OPP;
- endpoints autorizados de retrieval e entrega;
- autenticação e observabilidade de borda.

**Estado atual:** é a superfície de API associada ao deploy real do Vercel.

**Primeiro PR:** fora do escopo.

### `apps/bff`

**Responsabilidade futura condicionada:** possível BFF Azure, somente se reativado por decisão arquitetônica separada.

**Estado atual:** excluído do CI geral, testes stub e deploy não comprovado.

**Decisão do Lote 0:** não usar como destino primário da Knowledge Factory.

### `apps/web`

**Responsabilidade futura:**

- interface de OPP;
- seleção do componente/ano/currículo;
- entrega estruturada;
- revisão do professor;
- apresentação de insuficiência e findings.

**Primeiro PR:** fora do escopo.

### `packages/logger` e observabilidade existente

**Responsabilidade futura:** correlação por OPP, tokens, custo, latência, eventos e falhas.

**Primeiro PR:** apenas tipos de eventos, se estritamente necessários aos contratos; nenhuma integração operacional.

### `packages/graphics-profeplan`

**Responsabilidade futura:** receber contrato de entrega validado e realizar acabamento editorial.

**Bloqueio:** Gráfica avançada, PDF e PPTX sofisticados permanecem fora do MVP.

## API pública proposta do pacote de tipos

Após autorização, `packages/types/src/index.ts` poderá exportar um namespace ou barrel explícito de `knowledge-factory`, sem substituir exports legados.

Regras:

- sem dependência de banco;
- sem import de SDK de IA;
- sem código de rede;
- sem leitura de ambiente;
- sem efeitos colaterais;
- versionamento explícito;
- compatibilidade aditiva no primeiro PR.

## Decisão do Lote 0

O primeiro PR será concentrado em `packages/types`. Os demais módulos são destinos de lotes posteriores e não podem ser alterados por conveniência durante o PR contract-first.
