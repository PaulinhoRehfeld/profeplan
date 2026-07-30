# Design system incremental proposto

## Princípios

Construir primitives locais com React + Tailwind já instalados. Não trocar framework nem adotar uma biblioteca completa nesta fase. Migrar por tela, preservando APIs e regras.

## Tokens

| Categoria | Proposta |
|---|---|
| Marca | `brand-50 #EFF6FF`, `brand-600 #2563EB`, `brand-700 #1D4ED8`, `brand-900 #1E3A8A` |
| Neutros | Slate 25/50/100/200/500/700/900; fundo `#F8FAFC`, surface `#FFFFFF` |
| Sucesso | `#15803D`, fundo `#F0FDF4` |
| Alerta | `#B45309`, fundo `#FFFBEB` |
| Erro | `#B91C1C`, fundo `#FEF2F2` |
| Informação | `#0369A1`, fundo `#F0F9FF` |
| IA | Indigo `#4F46E5`; gradiente opcional apenas em acento não textual |
| Texto | principal Slate 900; secundário 600; muted 500; disabled 400 |

Validar todos os pares em WCAG AA. Cor nunca deve ser o único indicador.

## Tipografia e layout

- Fonte: Inter com carregamento explícito e fallback de sistema.
- Display 32/40 semibold; H1 28/36; H2 22/30; H3 18/26; body 16/24; body-sm 14/20; caption 12/16 apenas auxiliar.
- Espaçamento: escala 4, 8, 12, 16, 24, 32, 40, 48, 64.
- Raios: 6 (controles pequenos), 10 (controles/cards), 16 (modais/painéis especiais).
- Sombras: `sm` para elevação sutil, `md` para popover, `lg` só para modal.
- Conteúdo: 1200 px geral; 760 px para formulários/leitura; gutters 16/24/32.

## Componentes-base

- `Button`: primary, secondary, tertiary, danger; tamanhos 36/44/48; loading sem mudar largura.
- `IconButton`: alvo mínimo 44 px, `aria-label` obrigatório, tooltip opcional.
- `Field`: label visível, hint, erro, required e `aria-describedby`; Input/Select/Textarea/Checkbox.
- `Card`: border discreta; header/body/footer; sem sombra por padrão.
- `Table`: caption, headers semânticos, ordenação anunciada, scroll com indicação.
- `Dialog/Drawer`: foco inicial, trap, Escape, retorno de foco e título obrigatório.
- `Toast/Alert`: semântico, `aria-live`, ação e persistência proporcional.
- `Badge`: texto + cor; variantes neutral/success/warning/error/info/plan.
- `Tooltip`: apenas apoio, nunca informação essencial.
- `EmptyState`: título, explicação e um CTA primário.
- `Skeleton/Progress`: respeitar reduced motion; para IA mostrar etapa e preservação dos dados.
- `PageHeader`: breadcrumb opcional, título, descrição e ações.

## Navegação

Desktop: sidebar de 248 px, grupos por objetivo, ativo com fundo claro/indicador e texto normal. Recolhido apenas se todos os ícones tiverem tooltip/nome. Cabeçalho com página e contexto escolar; plano e conta à direita. Mobile: top bar simples, drawer com foco controlado e, após pesquisa, até quatro destinos frequentes em bottom nav.

## Adoção

Criar tokens em uma camada ativa de `src/index.css` e primitives em `src/components/ui/`. Não copiar os tokens de `app/globals.css` sem revisão, pois essa árvore é histórica. Migrar Shell/Home primeiro, depois componentes compartilhados e fluxos.
