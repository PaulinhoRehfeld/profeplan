# 🔄 Playbook de Rollback — Agentes V5 → V4

> **Sprint 6 | S6-05 | Responsável: Bob (SM)**
> **Objetivo:** Procedimento de emergência para reverter agentes V5 ao fallback V4.

---

## Gatilhos de Rollback

| Gatilho | Severidade | Ação |
|---|---|---|
| Taxa de erro > 5% por 10 min | 🔴 CRÍTICO | Rollback imediato |
| Latência P95 > 30s | 🟠 ALTO | Rollback programado (30 min) |
| Score de qualidade < 0.6 por 1h | 🟡 MÉDIO | Investigar antes de decidir |

## Procedimento de Rollback

### 1. Feature Flag (IMEDIATO — 1 min)
```bash
# Desativar V5 globalmente
# Atualizar FeatureFlags no Supabase ou Azure App Configuration:
use_v5_agents = false
rolloutPercentage = 0
```

### 2. Slot Swap (5 min)
```bash
# Trocar slot de staging (V5) de volta para production (V4)
az functionapp deployment slot swap --name profeplan-bff \
  --resource-group profeplan-rg \
  --slot staging \
  --target-slot production
```

### 3. Verificação Pós-Rollback (5 min)
- [ ] `curl POST /api/aiProxy` — V4 funcionando
- [ ] `curl POST /api/agentProxy` — retorna fallback ou 404
- [ ] Dashboard mostra taxa de erro < 1%

## Volta ao V5 (Re-Rollforward)
Após correção:
1. Deploy da correção no slot `staging`
2. Smoke test no staging
3. `use_v5_agents = true` + `rolloutPercentage = 10`
4. Monitorar 30 min → 50% → 100%

---

> 📋 **Aprovado por:** Bob (SM) | **Data:** 2026-07-09
