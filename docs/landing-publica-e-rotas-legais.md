# Contrato da landing pública e das páginas legais

## Objetivo

Este documento protege a landing e a Central Legal contra alterações parciais. Links públicos,
rotas do React Router e regras de autenticação precisam ser tratados como um único contrato.

Uma mudança no aplicativo autenticado (`/app`) não autoriza alterações na landing, nos textos
legais ou nas rotas públicas.

## Fonte única das rotas públicas

O catálogo canônico está em:

- `apps/web/src/router/publicRoutes.ts`

`PUBLIC_LEGAL_LINKS` alimenta:

- o rodapé da landing;
- a navegação da Central Legal;
- a lista de caminhos permitidos sem autenticação.

`RootLayout.tsx` deve consultar `isPublicPath()`. Não deve manter uma segunda lista manual de
rotas públicas.

## Páginas legais obrigatórias

| Documento                | Rota pública                |
| ------------------------ | --------------------------- |
| Política de Privacidade  | `/politica-de-privacidade`  |
| Termos de Uso            | `/termos-de-uso`            |
| Política de Cookies      | `/politica-de-cookies`      |
| Direitos do Titular      | `/direitos-do-titular`      |
| Dados Educacionais       | `/dados-educacionais`       |
| Cancelamento e Reembolso | `/cancelamento-e-reembolso` |
| Transparência em IA      | `/transparencia-em-ia`      |
| Segurança e LGPD         | `/seguranca-e-lgpd`         |

Essas páginas devem abrir em janela anônima, sem sessão e sem redirecionamento para `/login`.
Os endereços antigos definidos em `PUBLIC_LEGACY_ROUTE_PATHS` também devem continuar públicos
e redirecionar para os documentos atuais.

## Causa da regressão de julho de 2026

O rodapé e o roteador receberam as novas URLs, mas o guard de autenticação em `RootLayout.tsx`
continuou reconhecendo somente `/privacy` e `/terms`. Para visitantes sem sessão, todas as novas
URLs eram interceptadas e redirecionadas para `/login`.

Além disso, os arquivos das páginas legais estavam separados das alterações que os referenciavam.
Publicar somente parte desse conjunto produz links visíveis sem conteúdo correspondente.

## Regras para futuras alterações

1. Não editar a landing como efeito colateral de uma tarefa do aplicativo autenticado.
2. Não inserir links legais diretamente em arrays locais; usar `PUBLIC_LEGAL_LINKS`.
3. Ao adicionar ou renomear um documento:
   - criar ou atualizar a página;
   - registrar a rota no `AppRouter.tsx`;
   - atualizar `PUBLIC_LEGAL_LINKS`;
   - preservar a URL antiga em `PUBLIC_LEGACY_ROUTE_PATHS`;
   - atualizar este documento;
   - executar os testes de rotas públicas.
4. Páginas legais, layout legal, catálogo de rotas e testes devem ser publicados juntos.
5. Não remover textos legais nem alterar dados empresariais sem revisão responsável.
6. Não considerar o build suficiente: testar acesso direto às URLs sem autenticação.

## Checklist antes de publicar

- [ ] A landing mantém o design aprovado e suas seções esperadas.
- [ ] Os oito links legais aparecem no rodapé.
- [ ] Cada URL abre diretamente em janela anônima.
- [ ] Atualizar a página no navegador não resulta em 404.
- [ ] Nenhuma URL legal redireciona para `/login`.
- [ ] `/app`, `/admin`, `/profile-setup` e `/select-school` continuam protegidas.
- [ ] Links antigos redirecionam para os documentos atuais.
- [ ] `npm run build`, `npm run lint`, `npm run typecheck` e `npm run test` passam em `apps/web`.

## Teste automatizado

O arquivo `apps/web/src/router/__tests__/publicRoutes.test.ts` garante que:

- todos os documentos obrigatórios sejam públicos;
- os aliases antigos continuem públicos;
- rotas do aplicativo autenticado não sejam liberadas por engano.
