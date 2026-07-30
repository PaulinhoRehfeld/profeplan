# Resumo executivo

## Avaliação geral: 6,0/10

O frontend entrega um conjunto amplo e valioso de ferramentas, possui lazy loading, organização parcial por domínio, PWA/mobile e testes. Perde pontos por legibilidade crítica (11 px), navegação interna sem URLs, alta densidade visual, componentes gigantes, acessibilidade inconsistente e ausência de design system ativo. A base é recuperável por evolução incremental; não há justificativa para reescrita total.

## 10 principais problemas

1. Fonte-base desktop de 11 px.
2. Modos de `/app` sem rota própria, prejudicando voltar/recarregar/favoritar.
3. Componentes de 600–1.641 linhas com responsabilidades misturadas.
4. Pouca semântica acessível frente ao volume de botões e controles.
5. Linguagem visual excessiva: caixa alta, `font-black`, itálico, sombras e raios grandes.
6. Falta de primitives para botões, campos, modais, cards e estados assíncronos.
7. Menu extenso e taxonomia ambígua, especialmente Arquivos versus Documentos.
8. Loading, erro, vazio e feedback implementados de formas diferentes.
9. Uso elevado de `any` e `console`, com risco de manutenção e privacidade.
10. Coexistência de frontend Vite ativo e árvore Next histórica com design system diferente.

## 10 melhorias de maior impacto

1. Escala tipográfica acessível e hierarquia calma.
2. Tokens semânticos ativos em `src`.
3. Button/IconButton/Field/Dialog/Card/Alert compartilhados.
4. Redesign piloto da Home orientado a tarefas.
5. Shell com título contextual e plano/escola claros.
6. Taxonomia de navegação validada com professores.
7. URLs por funcionalidade sem alterar permissões.
8. Padrão de geração por IA com etapas, progresso, cancelamento e recuperação.
9. Decomposição de Planning/PDI/Turmas por responsabilidade.
10. Gate WCAG 2.2 AA, teclado, mobile e testes automatizados.

## Riscos principais

Autenticação, seleção de escola, permissões, PDI/dados de estudantes, assinatura/créditos, geração de IA, cache PWA e Capacitor. Esses domínios devem ter contratos congelados e validação específica. A árvore Next histórica não deve ser usada como base sem confirmação.

## Ordem recomendada

Baseline e proteções → tokens/primitives → shell → Home piloto → planejamento/avaliações → PDI/inclusão → turmas/documentos → perfil/gestão/admin → acessibilidade e performance finais.

## Tela-piloto

**Home (`/app`, modo HOME)**: importante, representativa, reutilizável e de baixo risco para autenticação, pagamentos e dados. Deve priorizar continuar trabalho, três ações principais e recentes.

## Arquivos que não devem ser alterados

Auth/guards, Supabase, SQL/migrations, APIs/BFF, Stripe/quota/assinatura, `.env`, deploy/PWA/Capacitor, `packages/db`, `packages/auth`, regras de IA e dados. Consultar `09-riscos-e-protecoes.md` para a lista detalhada.

## Decisão recomendada

Prosseguir com a Fase 0 e só depois implementar a fundação visual. Não reescrever a aplicação nem trocar React, Vite, Tailwind ou Lucide. O maior ganho imediato virá de legibilidade, hierarquia e consistência — não de efeitos visuais.
