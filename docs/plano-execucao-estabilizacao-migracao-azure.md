# PROFEPLAN - Plano de Execucao Paralela

Documento mestre para conduzir, em paralelo, a **correcao dos riscos atuais** e a **migracao Azure-first** sem perder continuidade entre conversas.

---

## 1) Objetivo

- Restaurar e manter estabilidade operacional (principalmente login/autenticacao, RLS e fluxos criticos).
- Migrar progressivamente os componentes para Azure com risco controlado.
- Garantir continuidade de execucao quando a conversa precisar ser reiniciada.

---

## 2) Modelo de execucao paralela

Trabalhar sempre com dois trilhos:

- **Trilho A - Estabilizacao/Risco:** corrige fragilidades de producao agora.
- **Trilho B - Migracao Azure:** move arquitetura gradualmente para Azure.

Regra de governanca:

- Cada entrega do Trilho B depende dos gates minimos do Trilho A.
- Se um item do Trilho A ficar vermelho, o Trilho B daquela frente pausa.

---

## 3) Matriz executiva (Atual -> Alvo)

| Componente | Atual | Alvo Azure | Risco | Esforco | Acao imediata |
|---|---|---|---|---|---|
| Auth/Login | Supabase Auth com oscilacao | Entra ID B2C (ou auth central Azure) | Alto | Alto | Retry + telemetria + plano dual-auth |
| IA Gerativa | Azure OpenAI parcialmente no frontend | Azure OpenAI via backend only | Critico | Medio | Remover uso de chave no browser |
| RAG/Busca | Supabase RPC + Azure Search parcial | Azure AI Search padrao unico | Alto | Alto | Definir arquitetura unica e feature flags |
| Banco relacional | Supabase/Postgres com RLS sensivel | Azure PostgreSQL (ou hibrido temporario) | Alto | Alto | Baseline de RLS + testes de autorizacao |
| Segredos | .env distribuido | Azure Key Vault | Critico | Medio | Rotacao + centralizacao em cofre |
| Backend de negocio | Frontend acoplado a RPC/tabelas | BFF/API em Azure Functions/Container Apps | Alto | Alto | Encapsular rotas criticas primeiro |
| Observabilidade | Logs dispersos | App Insights + alertas | Alto | Medio | Instrumentar auth/IA/search imediatamente |
| CI/CD | Push em main sem gates completos | Pipeline com gates + slots | Medio | Medio | Criar gates de teste e rollback |
| Pagamentos | Regras com hardcode | Configuracao parametrizada segura | Medio | Medio | Externalizar catalogo/plano |
| PDI (critico) | Fluxos sensiveis de historico e RLS | Servico dedicado com guardrails | Critico | Alto | Suite de regressao obrigatoria |

---

## 4) Plano de sprints (6x 1 semana)

## Sprint 1 - Estancar sangramento
- **Trilho A**
  - Remover IA no browser (backend-only).
  - Rotacionar segredos.
  - Instrumentar login e erros 5xx.
- **Trilho B**
  - Fechar blueprint Azure alvo.
  - Provisionar Key Vault + App Insights + ambientes.
- **DoD**
  - 0 chave sensivel no frontend.
  - Dashboard basico de autenticacao ativo.

## Sprint 2 - Base segura de execucao
- **Trilho A**
  - Baseline unico de RLS + testes automatizados.
  - Padronizar contrato de sessao.
- **Trilho B**
  - BFF inicial no Azure (auth proxy + IA proxy).
  - CI/CD com secrets do Key Vault.
- **DoD**
  - Testes de permissao verdes.
  - Primeiro endpoint Azure em producao controlada.

## Sprint 3 - RAG Azure piloto
- **Trilho A**
  - Corrigir inconsistencias de busca e parse.
  - Telemetria de latencia/erro de busca.
- **Trilho B**
  - Azure AI Search para curriculo (canario).
  - Query API com percentual de trafego.
- **DoD**
  - Paridade funcional minima.
  - Erro em canario menor que baseline.

## Sprint 4 - PDI protegido
- **Trilho A**
  - Suite de regressao PDI/guardrails.
  - Checagem de privacidade de saida.
- **Trilho B**
  - Mover fluxos PDI criticos para BFF.
  - Feature flag por escola/turma.
- **DoD**
  - Zero perda de historico.
  - Fluxos PDI validando ponta a ponta.

## Sprint 5 - Dados e cutover parcial
- **Trilho A**
  - Reconcilicao de dados e plano de rollback testado.
- **Trilho B**
  - Migracao faseada de dados para Azure PostgreSQL (ou hibrido).
  - Dominios menos criticos 100% Azure.
- **DoD**
  - Reconcilicao >= 99.9%.
  - Rollback ensaiado.

## Sprint 6 - Cutover controlado
- **Trilho A**
  - Testes de caos controlado.
  - Playbook final de incidente.
- **Trilho B**
  - Cutover de fluxos criticos com canario progressivo.
  - Descomissionamento legado nao usado.
- **DoD**
  - SLOs atingidos.
  - MTTR reduzido com alertas confiaveis.

---

## 5) Backlog pronto para Jira/Linear

## Epico A - Estabilizacao
- A1: Hardening de login (retry/circuit breaker/mensagens claras).
- A2: Baseline de RLS com testes de autorizacao.
- A3: Remocao de segredos do frontend.
- A4: Observabilidade de auth/IA/search.
- A5: Playbook de incidente + rollback.

## Epico B - Migracao Azure
- B1: API/BFF Azure para autenticacao e IA.
- B2: Azure AI Search como camada unica de busca.
- B3: Key Vault + governanca de secrets.
- B4: Pipeline de deploy com gates e slots.
- B5: Migracao de dados e cutover por canario.

## Prioridade inicial (ordem)
1. A3
2. A1
3. A2
4. B1
5. B3
6. A4
7. B2
8. B4
9. A5
10. B5

---

## 6) Protocolo de continuidade entre conversas

Quando o contexto passar de 70%, abrir nova conversa e colar o bloco abaixo, sem alterar estrutura.

## Bloco de handoff (copiar e colar)

```
CONTINUIDADE_PROFEPLAN
Documento guia: docs/plano-execucao-estabilizacao-migracao-azure.md
Sprint atual: <S1|S2|S3|S4|S5|S6>
Trilho A status: <verde|amarelo|vermelho>
Trilho B status: <verde|amarelo|vermelho>
Itens concluidos:
- ...
Itens em andamento:
- ...
Bloqueios:
- ...
Proxima acao objetiva (1 item):
- ...
KPIs atuais:
- Login success rate:
- P95 auth:
- Erros 5xx auth:
- P95 IA:
- Erros busca:
Decisao pendente:
- ...
```

Regra de retomada:
- Sempre continuar pela **Proxima acao objetiva (1 item)**.
- Se houver bloqueio vermelho no Trilho A, nao avancar no Trilho B daquela frente.

---

## 7) KPIs obrigatorios semanais

- Login success rate.
- P95 de auth.
- Erros 5xx de auth.
- P95 de IA.
- Taxa de erro de busca.
- Regressao de PDI (pass/fail da suite critica).
- MTTR de incidentes.

---

## 8) Governanca de decisao

- **Ritual semanal:** review tecnico de 30 min (A e B).
- **Semaforo:** vermelho bloqueia migracao daquela trilha.
- **Saida de cada sprint:** atualizar este documento (secao 6 + KPIs + DoD).

---

## 9) Estado inicial registrado

- Documento criado em: 2026-03-23.
- Estrategia: execucao paralela A/B.
- Foco imediato recomendado: **A3 -> A1 -> A2 -> B1**.

---

## 10) Checklist diaria de execucao (D1-D5 por sprint)

Usar este formato em toda sprint para manter ritmo e previsibilidade.

## Sprint 1 - D1 a D5
- **D1**
  - A: inventario de segredos expostos e pontos de IA no frontend.
  - B: validar arquitetura alvo Azure e naming de recursos.
- **D2**
  - A: remover chamadas de IA no browser e ajustar para backend.
  - B: provisionar Key Vault e App Insights.
- **D3**
  - A: instrumentar login (taxa de erro, latencia, 5xx).
  - B: preparar esqueleto do BFF (auth/IA proxy).
- **D4**
  - A: revisar riscos remanescentes de autenticacao e sessoes.
  - B: validar pipeline de deploy com secrets no cofre.
- **D5**
  - A: fechar relatorio de risco Sprint 1 + status semaforo.
  - B: fechar blueprint Azure aprovado para execucao Sprint 2.

## Sprint 2 - D1 a D5
- **D1** A: baseline RLS planejado | B: backlog tecnico BFF detalhado.
- **D2** A: implementar testes de autorizacao | B: implementar auth proxy.
- **D3** A: padronizar contrato de sessao | B: implementar IA proxy.
- **D4** A: rodar regressao auth/RLS | B: plugar CI/CD com Key Vault.
- **D5** A/B: validar DoD e publicar handoff atualizado.

## Sprint 3 - D1 a D5
- **D1** A: corrigir inconsistencias busca/parse | B: definir schema Azure Search.
- **D2** A: validar qualidade de resposta | B: criar indice curriculo.
- **D3** A: instrumentar erro/latencia busca | B: query API canario.
- **D4** A: regressao funcional busca | B: ajustar relevancia no canario.
- **D5** A/B: comparar baseline vs canario e decidir avancar.

## Sprint 4 - D1 a D5
- **D1** A: preparar suite regressao PDI | B: mapear endpoints PDI no BFF.
- **D2** A: validar cadeia escola->turma->aluno->PDI | B: migrar endpoints PDI 1.
- **D3** A: validar privacidade na saida | B: migrar endpoints PDI 2.
- **D4** A: regressao completa PDI | B: ativar feature flags por escola.
- **D5** A/B: validar zero perda de historico e fechar sprint.

## Sprint 5 - D1 a D5
- **D1** A: plano de reconcilicao de dados | B: plano de migracao faseada.
- **D2** A: testes de integridade | B: migracao piloto dominio nao critico.
- **D3** A: rollback drill | B: expandir migracao piloto.
- **D4** A: auditoria de consistencia | B: ajustes de performance.
- **D5** A/B: aprovar readiness para cutover controlado.

## Sprint 6 - D1 a D5
- **D1** A: plano de caos controlado | B: plano de cutover por ondas.
- **D2** A: executar caos auth/search/IA | B: canario onda 1.
- **D3** A: ajustar alertas/MTTR | B: canario onda 2.
- **D4** A: validacao final de resiliencia | B: cutover principal.
- **D5** A/B: descomissionamento legado + retro final.

---

## 11) Handoff inicial preenchido (usar na proxima conversa)

```
CONTINUIDADE_PROFEPLAN
Documento guia: docs/plano-execucao-estabilizacao-migracao-azure.md
Sprint atual: S1
Trilho A status: amarelo
Trilho B status: amarelo
Itens concluidos:
- Login com retry para erros transitorios de auth (502/503/504) implementado em producao.
- Documento mestre de execucao paralela criado.
- Matriz executiva e plano de 6 sprints definidos.
Itens em andamento:
- A3 Remocao de segredos do frontend e centralizacao.
- Planejamento tecnico do BFF Azure (B1).
Bloqueios:
- Instabilidade intermitente no endpoint de auth (/auth/v1/token) do provedor atual.
- Observabilidade ainda parcial para decisoes de corte.
Proxima acao objetiva (1 item):
- Executar A3: eliminar uso de chave de IA no frontend e mover chamadas para backend.
KPIs atuais:
- Login success rate: Nao consolidado (instrumentacao parcial)
- P95 auth: Nao consolidado
- Erros 5xx auth: Incidentes observados (504 intermitente)
- P95 IA: Nao consolidado
- Erros busca: Nao consolidado
Decisao pendente:
- Definir estrategia final de autenticacao alvo (Entra ID B2C vs camada auth Azure intermediaria).
```

---

## 12) Handoff operacional da semana (modelo + versao inicial)

## 12.1 Modelo rapido (copiar e preencher semanalmente)

```
HANDOFF_OPERACIONAL_SEMANA
Semana: <YYYY-Www>
Sprint: <S1|S2|S3|S4|S5|S6>

Trilho A (Estabilizacao)
- Responsavel:
- Objetivo da semana:
- Tarefas:
  - [ ] ...
  - [ ] ...
- Status geral: <0-100%>
- Risco atual: <verde|amarelo|vermelho>

Trilho B (Migracao Azure)
- Responsavel:
- Objetivo da semana:
- Tarefas:
  - [ ] ...
  - [ ] ...
- Status geral: <0-100%>
- Risco atual: <verde|amarelo|vermelho>

Bloqueios da semana:
- ...

Decisoes necessarias:
- ...

Proxima acao objetiva (unica):
- ...
```

## 12.2 Versao inicial preenchida (semana atual)

```
HANDOFF_OPERACIONAL_SEMANA
Semana: 2026-W13
Sprint: S1

Trilho A (Estabilizacao)
- Responsavel: Paulinho + Equipe de Agentes EVO
- Objetivo da semana: reduzir falha de login e fechar risco de segredo no frontend
- Tarefas:
  - [x] Mitigacao de retry para falhas transitorias de auth no login
  - [ ] Remover uso de chave de IA no browser
  - [ ] Instrumentar painel minimo de auth (erro/latencia/5xx)
- Status geral: 35%
- Risco atual: amarelo

Trilho B (Migracao Azure)
- Responsavel: Paulinho + Equipe de Agentes EVO
- Objetivo da semana: fechar base de execucao Azure para Sprint 2
- Tarefas:
  - [ ] Fechar blueprint tecnico alvo (Auth/API/Search/DB/Observabilidade)
  - [ ] Provisionar Key Vault e App Insights
  - [ ] Definir skeleton do BFF Azure
- Status geral: 20%
- Risco atual: amarelo

Bloqueios da semana:
- Instabilidade intermitente no auth provider atual (504 em /auth/v1/token)
- Telemetria ainda parcial para tomada de decisao de corte

Decisoes necessarias:
- Confirmar estrategia de autenticacao alvo (Entra ID B2C vs camada intermediaria Azure)
- Confirmar estrategia de dados na transicao (hibrido temporario vs migracao acelerada)

Proxima acao objetiva (unica):
- Executar A3: remover chave/uso de IA no frontend e mover chamadas para backend.
```

