# Continuidade — Implementação do Lote 2

## Status

**Lote 2 tecnicamente concluído, ADR-032 e Pull Request nº 5 aprovados humanamente para merge. Lote 3 permanece bloqueado.**

Data: 7 de agosto de 2026.

## Repositório e branch

- repositório: `PaulinhoRehfeld/profeplan`;
- base: `main` no commit `b57f2330f6f7b119cff202d8ecda0789746e10b1`;
- branch: `feat/knowledge-factory-domain-core`;
- Pull Request nº 5: `feat(knowledge-factory): add domain policies and repository ports`;
- merge autorizado após CI final verde.

## Extensão contratual autorizada

Durante a inspeção inicial foi identificada lacuna no contrato público do Lote 1: o ciclo de vida aprovado para o Lote 2 exigia `rejected`, `superseded` e `suspended`, estados ausentes do contrato 1.0.0.

A alteração foi explicitamente aprovada antes da implementação adicional.

Mudanças autorizadas em `@profeplan/types`:

- `KNOWLEDGE_FACTORY_CONTRACT_VERSION`: `1.0.0` → `1.1.0`;
- estados adicionados: `rejected`, `superseded`, `suspended`;
- estados existentes preservados para compatibilidade.

## Pacote criado

`packages/knowledge-factory/`

Workspace:

`@profeplan/knowledge-factory`

Nenhuma dependência externa nova foi adicionada.

### Relação com `@profeplan/types`

A definição documental previa declarar `@profeplan/types: workspace:*` no manifesto do novo pacote. A primeira execução de CI mostrou que isso exigiria atualizar o importer do novo workspace no `pnpm-lock.yaml`.

A implementação revelou que todos os usos de contratos são exclusivamente `import type`. Por isso, a versão final do PR não declara dependência de runtime/package-manager em `@profeplan/types` e utiliza o alias TypeScript já existente no monorepo para resolução em tempo de compilação.

A ADR-032 foi aprovada humanamente em 7 de agosto de 2026.

Consequências:

- nenhuma biblioteca externa foi adicionada;
- `pnpm-lock.yaml` permaneceu inalterado;
- não há acoplamento de runtime entre os pacotes;
- o typecheck valida os contratos diretamente;
- os imports são apagados na emissão/strip de tipos;
- uso futuro de símbolos de runtime exigirá nova decisão arquitetônica explícita.

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

## Testes do pacote

O CI executou explicitamente:

`packages/knowledge-factory test$ node --experimental-strip-types --test test/*.test.mjs`

Resultado:

- 20 testes;
- 20 aprovados;
- 0 falhas;
- 0 ignorados;
- 0 cancelados.

Cobertura funcional:

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

## CI validado antes da aprovação final

Execução do CI Pipeline nº 149 integralmente verde.

Passaram:

1. instalação de dependências;
2. verificação do lockfile e supply-chain policies;
3. Prettier;
4. ESLint;
5. typecheck do `@profeplan/knowledge-factory`;
6. typecheck dos demais pacotes ativos;
7. build geral aplicável;
8. testes gerais.

Na etapa de testes também passaram:

- `@profeplan/knowledge-factory`: 20/20;
- `@profeplan/types`: 11/11;
- `packages/agents`: 178/178;
- `apps/web`: 87/87.

O aviso preexistente sobre `docs/blueprint`/`.gitmodules` continua separado e não foi alterado.

## Ajustes realizados durante o CI

Falhas introduzidas pelo lote e corrigidas sem ampliar escopo:

1. manifesto inicial com dependência `workspace:*` tornou o lockfile desatualizado — substituído pela relação compile-time-only descrita na ADR-032;
2. formatação Prettier em arquivos novos — corrigida;
3. `tsconfig` inicialmente configurado como projeto `composite` com `rootDir: src`, incompatível com o alias de source do pacote de tipos — removidas apenas essas restrições; `strict` e `noEmit` permanecem herdados do monorepo.

Nenhuma configuração de CI foi relaxada.

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
- nenhum lockfile precisa ser restaurado;
- nenhum dado, migration ou serviço de produção precisa ser restaurado.

## Gate de saída

Concluídos:

- typecheck específico: aprovado;
- testes específicos: 20/20;
- CI geral aplicável: verde;
- escopo: preservado;
- ADR-032: aprovada humanamente;
- Pull Request nº 5: aprovado humanamente para merge.

Gate restante:

- CI do commit documental de aprovação deve permanecer verde antes do merge.

## Próximo lote

Lote 3 — persistência, proveniência e RLS permanece bloqueado.

Após o merge do Lote 2, nenhum trabalho de implementação do Lote 3 poderá iniciar sem nova definição documental, novo checkpoint e aprovação humana explícita.
