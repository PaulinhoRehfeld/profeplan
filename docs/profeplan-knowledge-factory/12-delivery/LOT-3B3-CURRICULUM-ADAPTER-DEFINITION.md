# Lote 3B.3 — CurriculumRepository

Data: 7 de agosto de 2026.

## Status

**Definição documental proposta para revisão humana. Este documento abre formalmente o ciclo 3B.3, mas não autoriza código antes de sua integração à `main`.**

Base imutável da abertura:

`d7eab04afc7358b344beb8f86c2584ef1437558b`

## Objetivo

Resolver o GAP-3B-01 no contrato da porta curricular e, em um PR de código posterior, implementar o adapter Supabase read-only de `CurriculumRepository`.

A fatia deve permitir localizar um pacote curricular sem misturar etapas, hidratar suas referências de fonte e ler nós curriculares com ordenação determinística.

## Decisão contratual proposta

A assinatura ambígua:

```ts
findActivePackageByState(state: CurriculumState): Promise<CurriculumPackage | null>;
```

será substituída por:

```ts
findActivePackageByStateAndStage(
  state: CurriculumState,
  stage: EducationStage
): Promise<CurriculumPackage | null>;
```

Consequências:

- `EducationStage` passa a ser importado pela porta;
- o método antigo é removido no mesmo PR de código;
- não será mantido alias ou overload que preserve a consulta ambígua;
- `@profeplan/types` não muda e `KNOWLEDGE_FACTORY_CONTRACT_VERSION` não recebe incremento, pois a alteração ocorre na interface privada do pacote de domínio;
- antes da alteração, o PR de código deverá verificar todos os consumidores por busca local e interromper se existir uso produtivo não previsto.

A decisão alinha a porta à unicidade física já aprovada:

`(state, stage) WHERE status = 'active'`.

## Superfície autorizável do adapter

O futuro `SupabaseCurriculumRepository` poderá implementar somente:

- `findPackageById(id)`;
- `findActivePackageByStateAndStage(state, stage)`;
- `findNodeById(id)`;
- `listNodesByPackage(packageId)`.

Mapeamento:

| Método | Tabelas | Comportamento |
|---|---|---|
| `findPackageById` | `kf_curriculum_packages` + `kf_curriculum_package_sources` | Busca por `id`; retorna `null` somente se o pacote não existir; hidrata `sourceVersionIds`. |
| `findActivePackageByStateAndStage` | `kf_curriculum_packages` + `kf_curriculum_package_sources` | Filtra obrigatoriamente `state`, `stage` e `status = active`; hidrata `sourceVersionIds`. |
| `findNodeById` | `kf_curriculum_nodes` | Busca por `id`; retorna `null` somente quando ausente. |
| `listNodesByPackage` | `kf_curriculum_nodes` | Filtra por `curriculum_package_id` e ordena por `code`, `version` e `id`, todos ascendentes. |

A hidratação de fontes usará leitura separada, aceita como consistência eventual nesta fatia read-only. Se a segunda leitura falhar ou retornar shape inválido, o adapter falhará integralmente; nunca devolverá pacote parcialmente hidratado. `sourceVersionIds` será ordenado por `source_version_id` ascendente.

## Contexto e segurança

- client SYSTEM recebido por injeção;
- nenhum `createClient()`;
- nenhuma leitura de `process.env`;
- nenhum import de `api/`;
- listas explícitas de colunas;
- erros provider-neutral;
- telemetria sanitizada e allowlisted;
- nenhuma exposição de título, descrição ou conteúdo curricular em logs;
- nenhuma credencial, URL hospedada ou dado real.

## Testes obrigatórios do futuro PR de código

### Contrato e unitários

- nova assinatura exige `state` e `stage`;
- o método antigo deixa de existir;
- filtros exatos de Estado, etapa e status ativo;
- `null` somente para ausência;
- pacote hidratado com fontes ordenadas;
- falha da hidratação não produz retorno parcial;
- mapeamento de enums, opcionais, arrays e timestamps;
- nós filtrados por pacote e ordenados deterministicamente;
- tradução de erros;
- telemetria sem dados sensíveis;
- superfície do adapter contém apenas os quatro métodos da porta.

### Integração descartável

Fixtures exclusivamente sintéticas devem provar:

- MG pode ter pacotes ativos distintos para Ensino Fundamental II e Ensino Médio;
- a consulta por `(MG, ensino_medio)` não retorna o pacote de `(MG, fundamental_ii)`;
- pacote inexistente retorna `null`;
- `sourceVersionIds` são isolados e ordenados;
- nós de outro pacote não vazam;
- `findNodeById` e `listNodesByPackage` mapeiam corretamente;
- schema, constraints, RLS, rollback, reaplicação e DB lint continuam verdes.

## GAP-3B-01

Este PR documental não fecha o GAP.

O GAP-3B-01 será considerado resolvido somente quando:

1. esta decisão estiver integrada à `main`;
2. a porta tiver a assinatura por Estado e etapa;
3. o adapter read-only estiver implementado;
4. testes unitários e de integração comprovarem a desambiguação;
5. o PR de código for revisado e integrado humanamente.

## Stories

A fatia prepara infraestrutura parcial para:

- US-006.1 — pacote curricular;
- US-006.2 — vínculos curriculares por meio da leitura de nós.

Nenhuma Story recebe `Done` integral. Não há currículo real, ingestão, curadoria ou uso por agente.

## Escopo proibido

- escrita, ativação, aposentadoria ou bloqueio de pacotes;
- gravação de fontes de pacote, nós ou links;
- leitura de `kf_curriculum_links` sem método correspondente na porta;
- migration, RPC ou mudança de RLS;
- conteúdo real de MG ou RS;
- PNLD;
- API, frontend ou wiring de produção;
- retrieval, embeddings, pgvector ou reranking;
- agentes ou Sócrates 2 executável;
- 3B.4, 3B.5, Gráfica, Nexus ou EPIC-018;
- Supabase de produção ou alteração na Vercel.

## Futuro PR de código, após aprovação documental

Branch prevista:

`feat/knowledge-factory-supabase-curriculum-adapter`

Título previsto:

`feat(knowledge-factory): add Supabase curriculum repository adapter`

Arquivos esperados:

- porta curricular e teste contratual mínimo;
- `src/curriculum/curriculum.mapper.ts`;
- `src/curriculum/supabase-curriculum.repository.ts`;
- export do pacote;
- testes unitários;
- testes de integração;
- checkpoint de implementação.

Nenhum código desse PR futuro está autorizado antes do merge humano desta definição.

## Próximo gate

Revisar o PR documental. Seu merge representará:

- aprovação da ADR-048;
- aprovação da correção do GAP-3B-01 na forma definida;
- autorização para criar a branch de código do adapter curricular read-only;
- manutenção de todos os demais GAPs e bloqueios.
