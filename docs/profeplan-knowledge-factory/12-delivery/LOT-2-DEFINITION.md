# Lote 2 — Domínio, ciclo de vida e repositórios abstratos

## Status

**Proposta para aprovação humana. Nenhum código do Lote 2 está autorizado por este documento.**

O PR nº 3 concluiu e integrou o antigo Lote 1 — contratos puros e fixtures — à `main`.

O próximo lote técnico, conforme o plano aprovado no Marco 003, é o **Lote 2 — Domínio, ciclo de vida e repositórios abstratos**.

## Objetivo

Criar uma camada de domínio pura para a ProfePlan Knowledge Factory, responsável por aplicar regras de negócio sobre os contratos já versionados em `@profeplan/types`, sem persistência, banco, APIs, IA, agentes executáveis ou acesso à rede.

A camada de domínio deverá responder perguntas como:

- uma fonte é elegível para determinado uso?
- uma transição de estado de componente é válida?
- um componente pode ser considerado elegível para produção?
- um vínculo curricular é válido no escopo do MVP?
- uma OPP pode avançar para o próximo estado?
- um pedido está dentro do escopo lógico do Sócrates 2?
- quais eventos lógicos precisam ser emitidos para auditoria?
- quais operações um repositório deverá oferecer, independentemente de Supabase, PostgreSQL, Prisma ou qualquer implementação física?

## Decisão arquitetônica proposta

Criar um novo pacote interno:

```text
packages/knowledge-factory/
```

Nome do workspace:

```text
@profeplan/knowledge-factory
```

Dependência permitida:

```text
@profeplan/types
```

Não serão permitidas dependências de:

- `packages/db`;
- `packages/ai`;
- `packages/agents`;
- Supabase;
- Prisma;
- OpenAI;
- Vercel;
- filesystem;
- rede;
- providers externos.

Dependências externas novas ficam proibidas neste lote, salvo nova autorização humana explícita.

## Por que não manter as regras em `packages/types`

`@profeplan/types` deve continuar funcionando como contrato compartilhado e estável.

Misturar nele políticas, ciclo de vida, serviços de domínio e portas de repositório aumentaria o acoplamento e dificultaria reutilização por banco, agentes, APIs e testes.

A separação proposta é:

```text
@profeplan/types
    ↓ contratos e tipos
@profeplan/knowledge-factory
    ↓ regras e portas do domínio
adapters futuros
    ├── db / Supabase
    ├── curriculum
    ├── PNLD
    ├── retrieval
    ├── agents
    └── APIs
```

Assim:

- `types` descreve **o que os objetos são**;
- `knowledge-factory` decide **o que pode acontecer com eles**;
- adapters posteriores decidem **como persistir, recuperar ou executar**.

## Princípios obrigatórios

1. **Domínio puro:** nenhuma função deste pacote acessa banco, rede, arquivos ou provider.
2. **Determinismo:** mesma entrada produz mesma decisão.
3. **Sem estado global:** políticas recebem todo contexto necessário por parâmetro.
4. **Contratos como fonte:** objetos públicos vêm de `@profeplan/types`.
5. **Falha explícita:** regras inválidas retornam resultado tipado ou erro de domínio controlado; não improvisam.
6. **Sem conhecimento real:** testes usam apenas fixtures sintéticas.
7. **Sem expansão:** MG continua sendo o único Estado permitido no MVP; RS permanece bloqueado.
8. **Sem agent runtime:** o Sócrates 2 pode ser validado como escopo, mas não executado.
9. **Sem persistência:** interfaces de repositório são portas; não existem implementações concretas.
10. **Auditabilidade lógica:** decisões relevantes devem produzir evidência lógica rastreável, sem gravá-la ainda.

## Escopo funcional

### 1. Política de elegibilidade de fontes

Responsabilidades:

- validar status da fonte;
- validar classe de licença;
- validar finalidade de uso;
- respeitar bloqueio e revogação;
- impedir geração com fonte incompatível;
- impedir uso produtivo de fonte em revisão;
- produzir motivo tipado de inelegibilidade.

Saída esperada:

```text
eligible: true | false
reasons: DomainReason[]
```

### 2. Política de ciclo de vida de componentes pedagógicos

Deverá controlar transições permitidas entre:

- `draft`;
- `in_review`;
- `approved`;
- `rejected`;
- `superseded`;
- `suspended`.

Regras mínimas:

- somente `approved` é elegível para produção;
- versão rejeitada não volta silenciosamente a aprovada;
- `superseded` permanece auditável;
- suspensão retira elegibilidade sem apagar histórico;
- mudança relevante exige nova versão, não sobrescrita silenciosa.

### 3. Política de elegibilidade de componente

Um componente só poderá ser considerado elegível quando, no mínimo:

- estiver aprovado;
- possuir versão identificável;
- possuir evidência autorizada ou justificativa de material próprio;
- possuir vínculo curricular aplicável quando o produto exigir alinhamento;
- pertencer ao componente, etapa e ano do escopo;
- não depender de fonte bloqueada;
- não estiver suspenso ou substituído.

### 4. Política curricular do MVP

Responsabilidades:

- aceitar apenas pacote ativo;
- aceitar Minas Gerais como Estado curricular do MVP;
- bloquear Rio Grande do Sul;
- bloquear pacote inativo ou expirado;
- validar componente, etapa e ano do piloto;
- validar vínculo componente ↔ nó curricular;
- permitir mais de um vínculo quando explicitamente justificado.

Nenhum documento curricular real será importado neste lote.

### 5. Política de escopo do Sócrates 2

Sem executar o agente, o domínio deverá conseguir validar se um pedido está dentro do escopo lógico:

- Filosofia;
- Ensino Médio;
- 2º ano;
- Minas Gerais;
- produto permitido no MVP.

Pedido fora do escopo deverá produzir decisão de fallback ou rejeição tipada; nunca improvisação.

### 6. Máquina de estados da OPP

O Lote 1 criou o contrato e as transições básicas. O Lote 2 deverá consolidar a regra de domínio para:

- criação válida;
- início;
- recuperação de contexto;
- produção;
- validação;
- aprovação;
- falha;
- insuficiência;
- cancelamento, se já previsto no contrato;
- rejeição de transição impossível.

A regra deve impedir que uma OPP:

- pule gate obrigatório;
- seja aprovada com insuficiência;
- seja entregue com finding Must aberto;
- avance sem os requisitos mínimos da etapa.

### 7. Auditoria lógica e eventos de domínio

Criar eventos lógicos, sem persistência física, para fatos como:

- fonte autorizada ou bloqueada;
- componente submetido, aprovado, rejeitado, suspenso ou substituído;
- vínculo curricular aprovado ou rejeitado;
- OPP criada ou transicionada;
- escopo de agente negado;
- elegibilidade recusada.

Os eventos deverão conter somente identificadores e metadados necessários, sem conteúdo pedagógico sensível.

### 8. Portas de repositório

Criar somente interfaces/ports abstratas.

Portas mínimas propostas:

- `KnowledgeSourceRepository`;
- `PedagogicalComponentRepository`;
- `CurriculumRepository`;
- `ProductionOrderRepository`;
- `AuditRepository`.

As portas deverão expressar operações de domínio, não detalhes de SQL.

Exemplo conceitual:

```text
findById(id)
findCurrentVersion(id)
findEligible(...)
save(...)
appendEvent(...)
```

Não deverão expor:

- SQL;
- Prisma Client;
- Supabase Client;
- nomes de tabela;
- vetores;
- provider específico;
- HTTP.

## Estrutura proposta

```text
packages/knowledge-factory/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── domain/
│   │   ├── result.ts
│   │   ├── reasons.ts
│   │   └── events.ts
│   ├── policies/
│   │   ├── source-eligibility.ts
│   │   ├── component-lifecycle.ts
│   │   ├── component-eligibility.ts
│   │   ├── curriculum-policy.ts
│   │   └── agent-scope-policy.ts
│   ├── opp/
│   │   └── production-order-policy.ts
│   └── repositories/
│       ├── knowledge-source.repository.ts
│       ├── pedagogical-component.repository.ts
│       ├── curriculum.repository.ts
│       ├── production-order.repository.ts
│       └── audit.repository.ts
└── test/
    ├── source-eligibility.test.mjs
    ├── component-lifecycle.test.mjs
    ├── component-eligibility.test.mjs
    ├── curriculum-policy.test.mjs
    ├── agent-scope-policy.test.mjs
    ├── production-order-policy.test.mjs
    └── repository-contracts.test.mjs
```

A árvore é uma referência de organização. Pequenos ajustes de nomes são permitidos desde que não mudem as fronteiras aprovadas.

## Stories incluídas no Lote 2

### Principais

- **US-002.1 — Registrar uma fonte com procedência:** regras de validade e porta abstrata;
- **US-002.2 — Autorizar ou bloquear uso na geração:** política de licença/permissão;
- **US-004.1 — Criar componente canônico:** regras de validade e porta abstrata;
- **US-004.2 — Classificar pela tipologia do piloto:** combinações e tipos permitidos;
- **US-004.3 — Revisar e versionar componente:** apenas ciclo de vida e invariantes;
- **US-010.1 — Criar OPP válida:** regras de domínio;
- **US-010.2 — Acompanhar linha do tempo:** apenas eventos lógicos e porta abstrata.

### Parciais

- **US-006.1:** política do pacote MG, sem importar currículo real;
- **US-006.2:** regra de vínculo curricular, sem persistência;
- **US-009.1:** validação de escopo do Sócrates 2, sem runtime;
- **US-013.2:** lineage/auditoria lógica, sem armazenamento físico.

## Stories explicitamente fora do Lote 2

- ingestão real: US-003.*;
- destilação com fontes: US-005.*;
- retrieval: US-007.*;
- orquestração executável: US-008.*;
- geração: US-009.2 e US-009.3;
- IA: US-011.*;
- quality pipeline executável: US-012.*;
- detecção autoral baseada em corpus: US-013.1;
- inclusão em produto gerado: US-014.2;
- entrega operacional: US-015.* além do contrato já existente;
- custo/modelos: US-016.2;
- piloto: US-017.*;
- expansão: US-018.1.

## Critérios de aceite do Lote 2

O lote será considerado tecnicamente concluído somente se:

1. `@profeplan/knowledge-factory` existir como pacote separado;
2. depender apenas de `@profeplan/types` entre os pacotes ProfePlan;
3. nenhuma dependência externa nova for adicionada;
4. nenhuma importação de DB, IA, agents, API ou frontend existir;
5. políticas forem funções ou serviços puros e determinísticos;
6. transições inválidas de componente forem testadas;
7. elegibilidade de fonte for testada para status e licenças válidas e inválidas;
8. componente inelegível por fonte bloqueada for rejeitado;
9. currículo RS permanecer bloqueado;
10. escopo Sócrates 2 rejeitar outro componente, ano ou Estado;
11. OPP não puder pular gates nem converter insuficiência em sucesso;
12. portas de repositório não expuserem tecnologia de persistência;
13. eventos de domínio não carregarem conteúdo sensível desnecessário;
14. fixtures continuarem sintéticas;
15. typecheck específico do pacote passar;
16. testes específicos do pacote passarem;
17. CI geral aplicável permanecer verde;
18. falhas preexistentes permanecerem registradas separadamente;
19. nenhuma Story posterior for antecipada;
20. rollback continuar sendo um revert sem restauração de dados.

## Definition of Done específica

Além do DoD geral:

- cada política deve ter teste de sucesso e falha;
- cada transição permitida e proibida relevante deve ser coberta;
- cada porta deve declarar claramente responsabilidade e fronteira;
- nenhum adapter concreto será aceito;
- documentação deve mapear políticas às Stories;
- qualquer lacuna descoberta nos contratos do Lote 1 exige parada e autorização, em vez de alteração silenciosa dos contratos públicos.

## Branch de código proposta

Somente após aprovação humana deste documento:

```text
feat/knowledge-factory-domain-core
```

Base:

```text
main
```

## Pull Request proposto

Título:

```text
feat(knowledge-factory): add domain policies and repository ports
```

O PR deverá ser aberto inicialmente como rascunho.

## Dependências e lockfile

A criação do novo workspace poderá adicionar uma dependência interna explícita:

```text
@profeplan/types: workspace:*
```

Isso é permitido somente se este Lote 2 for aprovado.

Nenhuma biblioteca externa adicional está autorizada.

Mudança em `pnpm-lock.yaml` será aceita apenas se for consequência automática e mínima da criação do workspace/dependência interna.

## Rollback

Rollback por revert do PR:

- remover `packages/knowledge-factory`;
- restaurar eventual alteração mínima de workspace/lockfile;
- nenhum dado será perdido;
- nenhuma migration será revertida;
- nenhum serviço de produção será afetado.

## Itens proibidos neste lote

- migrations;
- banco;
- RLS;
- Supabase;
- Prisma;
- APIs;
- jobs;
- OpenAI;
- embeddings;
- pgvector;
- busca lexical ou semântica;
- reranking;
- ingestão de PDF;
- PNLD real;
- documento curricular MG real;
- currículo RS;
- runtime do Sócrates 2;
- frontend;
- Gráfica;
- correções gerais do monorepo.

## Gate de saída

Após conclusão técnica, o PR deverá permanecer sem merge automático e aguardar aprovação humana.

Nenhum trabalho do Lote 3 — persistência, migrations e RLS — poderá começar sem:

1. aprovação e merge do Lote 2;
2. checkpoint de continuidade;
3. modelo físico de dados revisado;
4. plano de migration;
5. plano de rollback;
6. decisão explícita sobre Supabase/PostgreSQL/RLS.

## Fork

O fork seguinte não deve ocorrer antes da aprovação formal desta definição do Lote 2.
