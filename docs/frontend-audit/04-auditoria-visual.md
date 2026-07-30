# Auditoria visual

## Diagnóstico

O produto é reconhecível e moderno, porém visualmente carregado e fragmentado. A aplicação interna usa Slate/Blue e superfícies claras; landing e comparação usam tema escuro com muitos gradientes; a árvore Next histórica usa Emerald e tokens próprios. O resultado transmite tecnologia, mas às vezes menos calma, educação e previsibilidade do que o público docente necessita.

## Achados

| Dimensão | Evidência | Impacto | Gravidade | Direção recomendada |
|---|---|---|---|---|
| Tipografia | body 11 px; labels de 9/10 px; uso frequente de caixa alta, itálico e `font-black` | fadiga e hierarquia baseada em “gritar” | crítica | 16 px base, pesos 400/600/700, caixa normal |
| Cores | Slate/Blue/Emerald/Amber + hex locais; design Emerald inativo em `app/globals.css` | significado e marca inconsistentes | alta | paleta semântica única e auditada |
| Espaçamento | paddings variam entre `px-4`, `md:px-20`, painéis full-height | ritmos e larguras mudam abruptamente | média | escala 4/8 e container comum |
| Bordas/raios | muitos `rounded-2xl/3xl` | aparência genérica de SaaS e baixa densidade útil | média | 8/12/16 px conforme componente |
| Sombras | `shadow-xl/2xl` e sombras coloridas | excesso de camadas e ruído | média | 2–3 níveis discretos |
| Botões | estilos locais, pills, caixa alta, icon-only | prioridade de ação instável | alta | variantes Primary/Secondary/Tertiary/Danger/Icon |
| Campos | estilos e mensagens variam por feature | reaprendizado e erros | alta | primitive Field/Input/Select/Textarea |
| Cards | muitas formas e cores por tela | fragmentação | alta | card base com header/body/footer opcionais |
| Cabeçalho | marca/versionamento domina; status pulsante | técnico demais | alta | título e tarefa dominantes; versão fora do shell |
| Menu | fundo escuro sólido, labels longos, vários grupos | denso, mas razoavelmente organizado | média | grupos orientados à tarefa e active state simples |
| Tabelas | estilos locais; risco em telas estreitas | leitura e mobile frágeis | média | tabela responsiva + cards apenas quando necessário |
| Estados | spinners e pulse repetidos | espera sem contexto | alta | skeleton/progresso e mensagens específicas |
| Responsividade | drawer e breakpoints Tailwind; containers de altura fixa | base existe, mas painéis complexos podem cortar conteúdo | alta | teste 320/375/768/1024 e zoom 200% |
| Selecionado/desativado | dependente de classes locais e cor | consistência e acessibilidade baixas | média | estados tokenizados, foco e texto auxiliar |

Foram encontradas 1.152 ocorrências de padrões como textos muito pequenos, caixa alta, `font-black`, itálico, raios grandes, sombras fortes e animações. O número não é defeito isolado, mas confirma que a linguagem enfática está espalhada.

## Personalidade desejada

- **Confiança:** azul profundo e superfícies estáveis, não excesso de efeitos.
- **Acolhimento:** linguagem humana, ilustrações pontuais e espaços respiráveis.
- **Educação:** hierarquia editorial, exemplos e orientação contextual.
- **Inteligência:** IA explicável, progresso e resultados revisáveis.
- **Profissionalismo:** tipografia legível, alinhamento e estados previsíveis.

Evitar glassmorphism, gradientes decorativos recorrentes, pulsos permanentes e animações sem função. Gradiente pode permanecer como acento exclusivo de IA/marketing, nunca como substituto de hierarquia.
