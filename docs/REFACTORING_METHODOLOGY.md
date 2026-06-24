# Metodologia de Refatoração — PROFEPLAN

> Documento vivo. Última atualização: 2026-06-24.
> Objetivo: refatorar os *god files* do projeto **sem quebrar comportamento**, de forma
> **reproduzível e documentada**, substituindo o método empírico (tentativa-e-erro) por um
> protocolo verificável.

---

## 1. Por que este documento existe

Durante a fase de correção de bugs (sessão, créditos, PDI, configurações) trabalhamos no
**modo empírico**: alterar → publicar → observar o console → repetir. Isso aconteceu porque
os arquivos centrais **não têm testes** — não há rede de segurança que diga, em segundos, se
uma mudança quebrou algo.

A medição abaixo (2026-06-24) confirma o problema:

| Métrica | Valor |
|---|---|
| Testes existentes | 10 arquivos / 27 testes (todos verdes, ~11s) |
| Cobertura dos maiores god files | **0%** (`userService`, `PlanningManager`, `PdiDocumentService`, `AiPdiService`, `usePDIManager`) |

**Conclusão:** antes de refatorar, é preciso construir a rede de segurança do arquivo-alvo.
Refatorar sem testes é exatamente o que nos prendeu ao empírico.

---

## 2. Princípios (o "método científico" aplicado a código)

| Etapa científica | Tradução para refatoração |
|---|---|
| **Observação / Medição** | Métricas objetivas do arquivo: LOC, nº de responsabilidades, fan-in (quem importa), fan-out (o que importa), cobertura de testes. |
| **Hipótese** | "Este arquivo mistura N responsabilidades que podem ser separadas **sem mudar o comportamento**." |
| **Controle (invariante)** | *Characterization tests* (testes de caracterização) que fixam o comportamento atual **antes** de qualquer mudança. São a variável de controle do experimento. |
| **Intervenção** | Transformações atômicas e preservadoras de comportamento (extrair função, extrair módulo, mover). **Uma de cada vez.** |
| **Verificação** | `tsc --noEmit` + `vitest run` + `vite build` após **cada** passo atômico. Verde = mantém; vermelho = reverte. |
| **Registro** | Entrada no "caderno de laboratório" (seção 7) por refatoração: hipótese, passos, métricas antes/depois, resultado. |
| **Reprodutibilidade** | Cada passo atômico é um **commit separado**, revertível isoladamente. |

### Regras invioláveis

1. **Nunca** refatorar comportamento e estrutura no mesmo commit. Refatoração = estrutura muda,
   comportamento **idêntico**. Correção de bug é outro commit, com sua própria justificativa.
2. **Nunca** começar a mover código sem antes ter testes de caracterização verdes no alvo.
3. **Sempre** rodar `tsc + vitest + build` antes de commitar. Se algo está vermelho, o passo
   não existiu.
4. **Sempre** um passo atômico por commit, com mensagem no formato `refactor(<módulo>): <verbo> <o quê>`.
5. **Sem** mudança de versão durante refatoração pura (não há mudança funcional a anunciar).

---

## 3. Inventário medido dos god files (2026-06-24)

Fonte: contagem de linhas de `apps/web/src` e `apps/bff/src` (exclui testes e node_modules).

| # | Arquivo | LOC | Responsabilidades aparentes | Fan-in | Churn* | Risco |
|---|---|---|---|---|---|---|
| 1 | `services/pdi/PdiDocumentService.ts` | 1223 | CRUD PDI, timeline, logEvent, logEventForClass, resolução de escola | Alto | Alto | **Alto** |
| 2 | `pages/LandingPage.tsx` | 1222 | Página de marketing (estática) | Baixo | Baixo | Baixo |
| 3 | `features/PDI/usePDIManager.ts` | 788 | Hook de estado do PDI | Médio | Médio | Alto |
| 4 | `services/ai/AiPdiService.ts` | 716 | Geração IA de PDI (várias ações) | Médio | Médio | Alto |
| 5 | `features/Planning/components/PlanningCockpit.tsx` | 713 | UI do cockpit de planejamento | Médio | Médio | Médio |
| 6 | `features/Planning/PlanningManager.tsx` | 700 | UI + chat + save + roteamento | Alto | **Alto** | **Alto** |
| 7 | `services/userService.ts` | 540 | Auth, perfil, créditos, admin, referrals, escola | **Muito alto** | **Alto** | **Alto** |
| 8 | `services/teacherSchoolService.ts` | 495 | Vínculo professor↔escola | Médio | Médio | Médio |
| 9 | `components/PresentationCreator.tsx` | 476 | UI geração de slides | Baixo | Baixo | Médio |
| 10 | `components/School/StudentManagement.tsx` | 453 | UI gestão de alunos | Médio | Médio | Médio |

\* *Churn* = frequência de alterações recentes (estimado pelo histórico desta fase de correções).

**Observação importante:** tamanho **não** é o único critério. `LandingPage.tsx` é o 2º maior, mas
é estático, baixo fan-in e baixo churn → **baixa prioridade**. `userService.ts` é menor, mas é
importado por toda a aplicação e mudou 4× nesta fase → **prioridade máxima**.

### Critério de priorização (score)

```
Prioridade = (Fan-in × Churn × Risco) / Esforço
```

Onde o que paga mais cedo é: **alto acoplamento + muda muito + quebra fácil + barato de testar**.

---

## 4. Roadmap por fases

Cada fase entrega o app **funcionando** e com **mais rede de testes** do que antes.

### Fase 0 — Infraestrutura de segurança (pré-requisito)
- [ ] Garantir `vitest run` no CI/local como gate (já roda local em ~11s).
- [ ] Definir convenção de pastas de teste (`__tests__` colocalizado — já em uso).
- [ ] Helpers de mock do Supabase reutilizáveis (hoje cada teste mocka ad-hoc).

### Fase 1 — Piloto: `userService.ts` (valida a metodologia)
Escolhido por: maior fan-in, alto churn, lógica testável sem renderização React.
1. Caracterizar: testes que fixam `getUserProfile`, `checkUsageQuota`, `updateUserProfile`,
   `incrementUserUsage` (casos: perfil ok, perfil null com sessão, ghost id, créditos).
2. Refatorar em módulos coesos, mantendo `ProfileService.ts` como fachada (re-export) para
   **não quebrar nenhum import existente**:
   - `auth/sessionUser.ts` (getActiveAuthUser, resolução de id)
   - `profile/profileRepository.ts` (CRUD profiles)
   - `credits/quota.ts` (checkUsageQuota, incrementUserUsage)
   - `admin/adminProfiles.ts` (getAllUsers, updateUserProfileAdmin, addUserCredits, role)
   - `referrals/referrals.ts` (addReferral, checkAndRewardReferrer, registerPhone)
3. Verificar verde a cada extração. Commit por extração.

### Fase 2 — `PdiDocumentService.ts` (1223 LOC)
Separar: CRUD documento, timeline/records, logging em lote, resolução de escola.
Fachada preservada. Caracterização do `logEvent`/`logEventForClass` primeiro.

### Fase 3 — `PlanningManager.tsx` (700 LOC)
Extrair lógica não-visual para hooks/serviços testáveis (`usePlanningChat`, save flow),
deixando o componente como casca de apresentação.

### Fase 4+ — Demais (AiPdiService, usePDIManager, PlanningCockpit…)
Mesmo protocolo, na ordem do score de prioridade.

> `LandingPage.tsx` fica por último, ou nem entra: alto custo, baixíssimo retorno.

---

## 5. Protocolo por refatoração (o "procedimento de laboratório")

Para **cada** god file, na ordem:

```
1. MEDIR        → registrar LOC, responsabilidades, fan-in/out, cobertura (antes).
2. CARACTERIZAR → escrever testes que descrevem o comportamento ATUAL (mesmo que feio).
                  Rodar: devem passar (provam que descrevem a realidade).
3. CONGELAR     → commit "test(<módulo>): caracterização antes do refactor".
4. EXTRAIR      → um movimento atômico (extrair 1 função/módulo). Sem mudar lógica.
5. VERIFICAR    → tsc + vitest + build. Verde obrigatório.
6. COMMITAR     → "refactor(<módulo>): extrai X para Y".
7. REPETIR 4–6  → até a hipótese estar cumprida.
8. REGISTRAR    → preencher entrada no caderno (seção 7) com métricas depois.
```

Se em qualquer ponto o passo 5 ficar vermelho e não for trivial: **reverter o passo**, não
"consertar por cima". O experimento falhou; registra-se o porquê e tenta-se um corte diferente.

---

## 6. Ferramentas de verificação (comandos canônicos)

```bash
# Type check (rápido, primeiro filtro)
cd apps/web && npx tsc --noEmit

# Testes (rede de segurança)
cd apps/web && npx vitest run

# Build de produção (último filtro, pega erros de bundling)
cd apps/web && npx vite build
```

Baseline atual (2026-06-24): `tsc` EXIT 0 · `vitest` 27/27 verdes · `vite build` OK (~18s).

---

## 7. Caderno de laboratório (registro por refatoração)

> Uma entrada por arquivo refatorado. Preencher antes/depois.

### Template

```
### [Data] <arquivo>
- Hipótese:
- Responsabilidades identificadas:
- Cobertura antes / depois:
- LOC antes / depois (e arquivos resultantes):
- Passos atômicos (commits):
- Verificação final: tsc [ ] vitest [ ] build [ ]
- Comportamento alterado? (deve ser NÃO):
- Observações / surpresas:
```

### Entradas

_(vazio — primeira entrada será o piloto `userService.ts`)_

---

## 8. O que este processo NÃO é

- Não é reescrita. Não jogamos código fora para "fazer do zero".
- Não é otimização de performance disfarçada. Performance é outro experimento.
- Não é correção de bugs. Se acharmos um bug durante a caracterização, ele é **registrado**
  e corrigido em commit separado, **depois** — para não contaminar o experimento de refatoração.
