# Continuidade — Implementação do Lote 2

## Status

**Lote 2 implementado em branch e aguardando validação de CI e aprovação humana. Lote 3 permanece bloqueado.**

Data: 7 de agosto de 2026.

## Repositório e branch

- repositório: `PaulinhoRehfeld/profeplan`;
- base: `main` no commit `b57f2330f6f7b119cff202d8ecda0789746e10b1`;
- branch: `feat/knowledge-factory-domain-core`;
- PR previsto: `feat(knowledge-factory): add domain policies and repository ports`.

## Extensão contratual autorizada

Durante a inspeção inicial foi identificada lacuna no contrato público do Lote 1: o ciclo de vida aprovado para o Lote 2 exigia `rejected`, `superseded` e `suspended`, estados ausentes do contrato 1.0.0.

A alteração foi explicitamente aprovada antes de qualquer implementação adicional.

Mudanças autorizadas em `@profeplan/types`:

- `KNOWLEDGE_FACTORY_CONTRACT_VERSION`: `1.0.0` → `1.1.0`;
- estados adicionados: `rejected`, `superseded`, `suspended`;
- estados existentes preservados para compatibilidade.

## Pacote criado

`packages/knowledge-factory/`

Workspace:

`@profeplan/knowledge-factory`

Dependência interna única:

`@profeplan/types: workspace:*`

Nenhuma dependência externa nova foi adicionada.

## Capacidades implementadas

- razões tipadas de domínio;
- decisões puras de domínio;
- eventos lógicos sem conteúdo pedagógico sensível;
- elegibilidade de fontes;
- ciclo de vida de componentes pedagógicos;
- elegibilidade de componentes;
- política curricular do MVP;
- validação lógica do escopo do Sócrates 2;
- política de transições e gates da OPP;
- cinco portas abstratas de repositório.

## Portas publicadas

- `KnowledgeSourceRepository`;
- `PedagogicalComponentRepository`;
- `CurriculumRepository`;
- `ProductionOrderRepository`;
- `AuditRepository`.

As portas não expõem Supabase, PostgreSQL, Prisma, SQL, tabelas, HTTP, vetores ou providers.

## Escopo do MVP preservado

- componente: Filosofia;
- etapa: Ensino Médio;
- ano: 2º ano;
- currículo estadual: Minas Gerais;
- Rio Grande do Sul: bloqueado;
- Sócrates 2: apenas validação de escopo, sem runtime.

## Testes adicionados

- fonte aprovada e fonte bloqueada;
- licença incompatível;
- transições permitidas e proibidas de componentes;
- rejeição sem retorno silencioso a aprovado;
- suspensão exigindo nova revisão;
- MG aceito e RS bloqueado;
- escopo correto e incorreto do Sócrates 2;
- componente elegível;
- componente dependente de fonte bloqueada;
- componente sem alinhamento curricular;
- OPP com transição válida;
- salto de gate da OPP;
- insuficiência impedindo montagem;
- finding Must impedindo aprovação;
- conjunto exato das cinco portas abstratas.

## Itens não implementados

Continuam fora do Lote 2:

- banco;
- migrations;
- RLS;
- Supabase;
- Prisma;
- API;
- jobs;
- OpenAI;
- IA executável;
- embeddings;
- pgvector;
- retrieval;
- ingestão;
- PDF/OCR;
- PNLD real;
- currículo MG real;
- currículo RS;
- runtime do Sócrates 2;
- frontend;
- Gráfica;
- EPIC-018;
- correções gerais do monorepo.

## Rollback

Rollback por revert do PR:

- remover `packages/knowledge-factory`;
- restaurar a extensão contratual 1.1.0 se nenhuma dependência posterior existir;
- nenhum dado, migration ou serviço de produção precisa ser restaurado.

## Gate de saída

Antes de merge:

1. typecheck específico do pacote deve passar;
2. testes específicos devem passar;
3. CI geral aplicável deve permanecer verde;
4. alterações devem permanecer restritas ao Lote 2 e extensão contratual autorizada;
5. aprovação humana explícita é obrigatória.

## Próximo lote

Lote 3 — persistência, proveniência e RLS permanece bloqueado.

Nenhum trabalho do Lote 3 poderá iniciar sem nova definição documental, novo checkpoint e aprovação humana explícita.
