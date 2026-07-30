# Arquitetura do site público e do aplicativo

## Decisão vigente

O ProfePlan possui dois produtos de interface separados:

| Superfície   | Diretório   | Domínio previsto       | Responsabilidade                                                  |
| ------------ | ----------- | ---------------------- | ----------------------------------------------------------------- |
| Site público | `apps/site` | `www.profeplan.com.br` | apresentação, aquisição, confiança e acesso aos documentos legais |
| Aplicativo   | `apps/web`  | `app.profeplan.com.br` | SaaS autenticado e ferramentas pedagógicas                        |

O design de referência do site público foi criado na branch `site-saas-separation`, commit
`8ae8d64b`. O commit `e610c8f9` complementou sua configuração de instalação na Vercel.

## Referências visuais

As capturas do aplicativo antigo, anteriores ao redesenho de julho de 2026, são somente material
histórico e não devem ser usadas para restaurar componentes.

O aplicativo atual, com navegação simplificada, Home orientada a tarefas e os fluxos redesenhados,
é a referência vigente. Restaurar ou alterar a landing não autoriza mudanças em `apps/web`.

## Regra de isolamento

Uma tarefa de landing deve editar somente:

- `apps/site/**`;
- documentação específica do site;
- configurações de hospedagem exclusivas do site, quando expressamente autorizadas.

Uma tarefa do aplicativo não deve:

- recriar a landing em `apps/web/src/pages/LandingPage.tsx`;
- copiar estilos do site para `apps/web/src/index.css`;
- alterar a Home, o shell ou os fluxos autenticados para combinar visualmente com a landing;
- publicar `apps/site` como parte do mesmo build do SaaS.

O site público não pode importar arquivos de `apps/web`.

## Navegação entre as superfícies

O site usa `https://app.profeplan.com.br` como origem canônica para:

- login;
- criação de conta;
- páginas legais enquanto a Central Legal estiver hospedada junto ao aplicativo.

Os oito links legais obrigatórios devem permanecer visíveis no rodapé do site:

1. Política de Privacidade;
2. Termos de Uso;
3. Política de Cookies;
4. Direitos do Titular;
5. Dados Educacionais;
6. Cancelamento e Reembolso;
7. Transparência em IA;
8. Segurança e LGPD.

## Proteções contra regressão

Antes de publicar o site:

```bash
cd apps/site
npm run typecheck
npm run check:boundaries
npm run build
```

`check:boundaries` falha quando:

- o domínio canônico do aplicativo muda acidentalmente;
- algum link jurídico obrigatório desaparece;
- o site passa a importar código do aplicativo.

## Publicação

Site e aplicativo devem ser projetos de hospedagem diferentes. A restauração local da landing não
autoriza deploy, troca de domínio, commit ou push.

Antes de apontar `www.profeplan.com.br` para `apps/site`, confirmar:

- que `app.profeplan.com.br` está publicado e acessível;
- que login, cadastro e as oito páginas legais abrem sem autenticação;
- que os registros DNS e projetos Vercel pertencem às superfícies corretas;
- que acesso direto e atualização das URLs não resultam em 404;
- que o aplicativo atual foi comparado visualmente e não sofreu alteração.
