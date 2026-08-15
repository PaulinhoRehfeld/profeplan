# Lote 1.3C.4D — PDI: Saves governados

Data: 15 de agosto de 2026.

Base técnica inicial: `886fbcfe9a543d121c599adbe8f585aec5175a05`.

## Objetivo

Migrar os eventos econômicos do PDI para fronteiras server-side especializadas, preservando a geração/preview como NON_BILLABLE quando `VITE_GOVERNED_CREDIT_CONSUMERS=true` e sem ativar a flag em produção neste sublote.

PDI não usa apenas a fronteira genérica de 4A porque uma única validação semântica pode precisar persistir, de forma indivisível, em `pdi_records`, `pdi_documents.block_9_content` e `generated_contents`.

## Eventos econômicos

4D governa dois eventos de domínio, com três RPCs especializados por causa das persistências diferentes:

1. `PDI_ADAPTATION_VALIDATED`
   - ação econômica server-side: `SAVE_PDI_ADAPTATION`;
   - RPC: `credit_validate_pdi_adaptation(...)`.

2. `PDI_REPORT_SAVED`
   - ação econômica server-side: `SAVE_PDI_REPORT`;
   - relatório pedagógico gerado: `credit_save_pdi_generated_report(...)`;
   - relatório final/Bloco 11: `credit_save_pdi_final_report(...)`.

O navegador não fornece `action_key`, custo, débito ou saldo.

## Flag OFF

Enquanto:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=false
```

o comportamento legado é preservado:

- geração PDI continua usando a camada histórica de quota;
- validação continua executando os writes legados do PDI;
- autosaves continuam usando `saveGeneratedContent(...)`;
- Bloco 11 continua usando `PdiDocumentService.updateBlock11ByProgument(...)`.

## Flag ON

Com a flag `true`:

- `checkUsageQuota()` libera geração/preview sem decisão econômica;
- `incrementUserUsage()` torna-se no-op pela camada central de compatibilidade;
- geração e regeneração são NON_BILLABLE;
- somente os Saves governados podem gerar consumo econômico;
- falha de RPC nunca cai silenciosamente para o write legado.

A flag continua OFF em produção em 4D.

## Identidade — adaptação do Bloco 9

Uma geração válida cria um UUID local antes do primeiro Save.

Esse UUID:

- não vem do modelo de IA;
- permanece estável em retry/edição da mesma adaptação gerada;
- muda quando ocorre uma nova geração;
- é usado como `artifact_id` econômico;
- é usado como `pdi_records.id`;
- é usado como `generated_contents.id`;
- é projetado em `pdi_documents.block_9_content[].artifact_id`.

Fluxo:

```text
geração válida
  -> artifactId local
  -> preview/edição
  -> Validar
  -> credit_validate_pdi_adaptation(...)
  -> decisão econômica + pdi_records + block_9_content + generated_contents
```

Primeira validação de um artifact novo pode consumir um crédito. Retry ou edição do mesmo artifact não gera segundo débito.

Uma regeneração recebe nova identidade e, ao ser validada, representa uma nova operação econômica. A projeção corrente do Bloco 9 para a mesma aula deve ser substituída, enquanto os registros históricos em `pdi_records`, `generated_contents` e ledger permanecem preservados.

## Atomicidade — adaptação

`credit_validate_pdi_adaptation(...)` executa na mesma transação:

1. autenticação e validação de domínio;
2. lock do perfil antes do artifact;
3. verificação de escola, aluno e PDI;
4. decisão econômica via `credit_consume_internal(...)`;
5. persistência de `pdi_records`;
6. atualização da projeção `pdi_documents.block_9_content`;
7. persistência de `generated_contents`.

Se a decisão for `REJECTED / INSUFFICIENT_CREDITS`, nenhum artifact PDI é confirmado.

Se qualquer persistência posterior falhar, receipt e débito são revertidos pela mesma transação.

## Relatório pedagógico gerado

O relatório produzido a partir da timeline recebe um UUID local antes do Save governado.

Em caso de erro ou resposta perdida, o mesmo UUID permanece no estado para retry seguro. Após Save confirmado, uma nova solicitação explícita de geração de relatório pode criar uma nova identidade.

`credit_save_pdi_generated_report(...)` torna `generated_contents` a persistência econômica canônica desse relatório.

## Relatório final / Bloco 11

O Bloco 11 já possui uma identidade natural: `pdi_documents.id`.

O servidor deriva o artifact econômico:

```text
pdi-final-report-v1:<pdi_documents.id>
```

Assim:

- primeiro Save do relatório final pode consumir um crédito;
- edição posterior do mesmo PDI é NON_BILLABLE;
- o Save atualiza `pdi_documents.final_report` e sua representação em `generated_contents` na mesma transação;
- aprovação/finalização do PDI permanece um evento administrativo NON_BILLABLE.

A autorização server-side segue os papéis de gestão já usados pela persistência PDI (`manager`, `school_manager`, `school_admin`, `admin`). O rótulo visual histórico `supervisor` não é uma role válida na constraint canônica de `profiles` e não deve ser usado como autoridade econômica server-side.

## Segurança

Os RPCs 4D são `SECURITY DEFINER`, com `search_path` fixo.

- `authenticated`: EXECUTE permitido;
- `PUBLIC`: revogado;
- `anon`: revogado;
- `service_role`: revogado nas fronteiras user-facing.

As funções derivam `auth.uid()` e dados de perfil/escola no servidor. A identidade de aluno/PDI é validada antes da decisão econômica.

## Provas descartáveis

O workflow `Credit Accounting 1.3C.4D PDI CI` monta um Supabase descartável e prova:

- permissions/grants dos RPCs;
- primeira validação = um débito;
- retry/edição = nenhum débito adicional;
- insuficiência = receipt rejeitado sem persistência PDI;
- Gold = persistência sem débito;
- isolamento de ownership/escola;
- falha de persistência = rollback de artifact + receipt + débito;
- relatório pedagógico: primeiro Save + edição idempotente;
- relatório final: primeiro Save + edição idempotente;
- oito validações concorrentes do mesmo artifact convergem para um único débito;
- lint do banco.

Os testes usam somente fixtures sintéticas e nunca um Supabase hospedado.

## Não escopo

4D não autoriza:

- ativação de `VITE_GOVERNED_CREDIT_CONSUMERS` em produção;
- aplicação da migration em Supabase hospedado;
- alteração de saldo ou grant real;
- mudança de Vercel;
- alteração de Edge Function hospedada;
- Stripe;
- revogação final de writes diretos;
- 4E cutover/enforcement final.

Produção permanece bloqueada.
