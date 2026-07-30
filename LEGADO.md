# Legado e conteúdo fora da versão oficial 1.0.0

Este arquivo classifica conteúdo preservado que não integra o release oficial `1.0.0`. A
classificação como legado não autoriza exclusão nem publicação.

## Diretório legado

- `legacy-web-legacy/**`: aplicação anterior, mantida somente como referência histórica.

## Alterações locais excluídas deste release

- alterações de Stripe e assinatura;
- `api/auth/signup.ts`;
- funções e webhooks em `infra/supabase/functions/**`;
- migrações e scripts SQL ainda não auditados;
- `supabase/functions/**`;
- `TEMPLATES_INST/**`;
- `product-evidence/**`;
- `STRIPE_CONFIG_PJ.md`;
- alterações do submódulo `docs/blueprint`;
- arquivos de handoff ou evidência não necessários ao release.

Esses itens devem ser avaliados em branches e releases próprios antes de qualquer publicação.

## Regra

Nenhum item listado aqui pode ser apagado, incluído em commit, enviado ou implantado como parte do
release `1.0.0` sem nova autorização explícita e validação específica.
