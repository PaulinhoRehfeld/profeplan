# Riscos e proteções

| Risco | Nível | Proteção obrigatória |
|---|---|---|
| quebrar guards de autenticação/seleção de escola | crítico | não alterar `RootLayout`, auth hooks/utilities; testes por estado de sessão |
| expor telas de gestor/admin | crítico | preservar `isAdmin`, roles e guards; matriz de permissões |
| alterar cobrança, plano ou créditos | crítico | UI desacoplada; sandbox; não tocar Stripe/quota |
| perda/corrupção de PDI e dados escolares | crítico | não mudar schemas, repositories ou payloads; fixtures anonimizadas |
| geração de IA diferente após redesign | alto | congelar inputs/outputs; comparar requests e resultados |
| regressão por fonte-base global | alto | aplicar tokens por shell/piloto antes de remover 11 px global |
| confundir Vite ativo com Next legado | alto | fonte de verdade: `src/index.tsx`/Vite; não editar `app/` nesta iniciativa |
| PWA servir assets antigos | alto | versionar cache e testar atualização/rollback em ambiente controlado |
| mobile/Capacitor quebrar por viewport/teclado | alto | dispositivo real, safe areas e teclado virtual |
| logs com dados sensíveis | alto | redaction e logger; não copiar conteúdo real para testes |
| refatoração grande sem cobertura | alto | PRs por primitive/tela, feature flag visual e rollback simples |
| remover modo aparentemente órfão | médio | telemetria e busca de uso antes de remoção |
| acessibilidade parcial dar falsa segurança | médio | testes automáticos + teclado + leitor de tela humano |

## Arquivos/áreas fora do escopo do redesign

- `.env*`, `supabase/**`, `database/**`, migrations e SQL.
- `apps/web/src/services/**` (salvo adaptação estritamente tipada e aprovada em fase futura).
- `apps/web/src/hooks/useProfeplanAuth.ts`, `services/supabaseClient.ts`, auth e guards.
- Stripe, quota/créditos, assinatura, webhooks, APIs/BFF e integrações externas.
- `packages/db`, `packages/auth`, `packages/ai`, regras em `packages/agents`.
- deploy: `vercel.json`, Vite/PWA/Capacitor, CI e produção, exceto tarefa específica.

## Estratégia de proteção

1. Capturar baseline visual e técnico com Node 22.
2. Definir contratos “não alterar” para eventos, props e payloads.
3. Implementar primitives sem dependências novas.
4. Migrar Home atrás de flag visual, se necessário.
5. Validar professor/gestor/admin, online/offline e mobile.
6. Manter rollback por PR e não combinar UI com mudanças de dados.

## Observação sobre estado do repositório

Antes desta auditoria já existiam alterações do usuário em `docs/blueprint` e arquivos não rastreados fora desta pasta. Elas foram preservadas e não fazem parte da entrega.
