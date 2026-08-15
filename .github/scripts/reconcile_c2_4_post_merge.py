from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    file = Path(path)
    text = file.read_text(encoding='utf-8')
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{path}: expected exactly one match, found {count}: {old[:120]!r}')
    file.write_text(text.replace(old, new, 1), encoding='utf-8')


# README
README = 'docs/profeplan-knowledge-factory/README.md'
replace_once(
    README,
    '- [Definição C.2.3 — integridade, checksum, duplicidade e vínculo](12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md)\n- [Checkpoint 047 — C.2.3 integrado; C.2.4 bloqueado](00-governance/CONTINUITY-CHECKPOINT-047.md)',
    '- [Definição C.2.3 — integridade, checksum, duplicidade e vínculo](12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md)\n- [Checkpoint 047 — C.2.3 integrado; C.2.4 bloqueado](00-governance/CONTINUITY-CHECKPOINT-047.md)\n- [Definição C.2.4 — idempotência, retomada e falha segura](12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md)\n- [Checkpoint 048 — C.2.4 integrado; C.2.5 bloqueado](00-governance/CONTINUITY-CHECKPOINT-048.md)'
)
replace_once(
    README,
    'Para o estado operacional corrente após a integração técnica de C.2.3, prevalece o [Checkpoint 047](00-governance/CONTINUITY-CHECKPOINT-047.md) sobre marcadores históricos de checkpoints anteriores.',
    'Para o estado operacional corrente após a integração técnica de C.2.4, prevalece o [Checkpoint 048](00-governance/CONTINUITY-CHECKPOINT-048.md) sobre marcadores históricos de checkpoints anteriores.'
)
replace_once(
    README,
    '- C.2.3 — **integrado e revalidado** pelo PR nº 70 no commit `f70312a9936b99e1c131627277ad4c4a65b126a5`, com CI pós-merge nº 430 verde;\n- C.2.4–C.2.6 — bloqueados;',
    '- C.2.3 — **integrado e revalidado** pelo PR nº 70 no commit `f70312a9936b99e1c131627277ad4c4a65b126a5`, com CI pós-merge nº 430 verde;\n- C.2.4 — **integrado e revalidado** pelo PR nº 74 no commit `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`, com CI pós-merge nº 523 verde;\n- C.2.5–C.2.6 — bloqueados;'
)
replace_once(
    README,
    'C.2.3 acrescentou integridade criptográfica sobre readback dos bytes efetivamente armazenados, usando SHA-256 em hexadecimal minúsculo, evidência provider-neutral, classificação explícita de duplicidade binária sem colapso de identidades e materialização técnica de `VERIFIED`. O gate `evaluateIngestionVerificationConfirmation` vincula o `confirm_verified` de C.2.1 à evidência física aprovada sem redefinir a state machine ou antecipar a persistência/recovery de C.2.4.\n\nA menção histórica',
    'C.2.3 acrescentou integridade criptográfica sobre readback dos bytes efetivamente armazenados, usando SHA-256 em hexadecimal minúsculo, evidência provider-neutral, classificação explícita de duplicidade binária sem colapso de identidades e materialização técnica de `VERIFIED`. O gate `evaluateIngestionVerificationConfirmation` vincula o `confirm_verified` de C.2.1 à evidência física aprovada sem redefinir a state machine.\n\nC.2.4 acrescentou persistência durável do lifecycle operacional, receipts/events, idempotência por `commandId + fingerprint` recalculado server-side, CAS por state/version/sequence, recovery PostgreSQL ↔ Storage sem pseudo-transação distribuída, write-intent separado da evidence C.2.3, confirmação atômica de `VERIFIED`, cleanup em duas fases e least privilege por RPCs estreitas. A prova integrada permaneceu inteiramente sintética e descartável.\n\nA menção histórica'
)
replace_once(
    README,
    'O próximo sublote na sequência é **C.2.4 — idempotência, retomada e falha segura**. Ele permanece bloqueado nesta continuidade e deverá começar em contexto próprio, com nova inspeção canônica, sem inferir autorização de persistência nova, storage hospedado, Supabase hospedado, conteúdo real, C.3 ou produção.',
    'O próximo sublote na sequência é **C.2.5 — revisão humana e handoff para C.3**. Ele permanece bloqueado nesta continuidade e deverá começar em contexto próprio, com nova inspeção canônica e autorização humana específica, sem inferir autorização de extração, storage hospedado, Supabase hospedado, conteúdo real, C.3 ou produção.'
)

# BLUEPRINT
BLUEPRINT = 'docs/profeplan-knowledge-factory/BLUEPRINT.md'
replace_once(BLUEPRINT, 'Estado de navegação atualizado em 14 de agosto de 2026.', 'Estado de navegação atualizado em 15 de agosto de 2026.')
replace_once(BLUEPRINT, 'FASE C — C.1 CONCLUÍDO; C.2.1–C.2.3 INTEGRADOS; C.2.4 BLOQUEADO  ← ESTADO ATUAL', 'FASE C — C.1 CONCLUÍDO; C.2.1–C.2.4 INTEGRADOS; C.2.5 BLOQUEADO  ← ESTADO ATUAL')
replace_once(BLUEPRINT, '🔵 C.2 Ingestão controlada — definição integrada; C.2.1–C.2.3 integrados; C.2.4 bloqueado', '🔵 C.2 Ingestão controlada — definição integrada; C.2.1–C.2.4 integrados; C.2.5 bloqueado')
replace_once(
    BLUEPRINT,
    'e o estado pós-merge no Checkpoint 046. C.2.3 foi integrado pelo PR nº 70 no commit `f70312a9936b99e1c131627277ad4c4a65b126a5`, tree `4b47c853a2cb041ca895477abc3c710ca9393b94`, com CI pós-merge nº 430 verde; sua fronteira está em [`12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md). O estado pós-merge passa ao Checkpoint 047. C.2.4–C.2.6 e C.3–C.7 permanecem bloqueados.',
    'e o estado pós-merge no Checkpoint 046. C.2.3 foi integrado pelo PR nº 70 no commit `f70312a9936b99e1c131627277ad4c4a65b126a5`, tree `4b47c853a2cb041ca895477abc3c710ca9393b94`, com CI pós-merge nº 430 verde; sua fronteira está em [`12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md) e o estado pós-merge no Checkpoint 047. C.2.4 foi integrado pelo PR nº 74 no commit `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`, tree `92411aec0c9da3789bb91c87d8f423a3c69f929d`, com CI pós-merge nº 523 verde; sua fronteira está em [`12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md`](12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md). O estado pós-merge passa ao Checkpoint 048. C.2.5–C.2.6 e C.3–C.7 permanecem bloqueados.'
)
replace_once(BLUEPRINT, '| C.2 | Ingestão controlada | EPIC-003; US-003.1 | **C.2.1–C.2.3 integrados; C.2.4 bloqueado** |', '| C.2 | Ingestão controlada | EPIC-003; US-003.1 | **C.2.1–C.2.4 integrados; C.2.5 bloqueado** |')
replace_once(
    BLUEPRINT,
    '**Definição documental integrada pelo PR nº 59. C.2.1 integrado e revalidado pelo PR nº 62. C.2.2 integrado e revalidado pelo PR nº 67. C.2.3 integrado e revalidado pelo PR nº 70. C.2.4–C.2.6 permanecem bloqueados.**',
    '**Definição documental integrada pelo PR nº 59. C.2.1 integrado e revalidado pelo PR nº 62. C.2.2 integrado e revalidado pelo PR nº 67. C.2.3 integrado e revalidado pelo PR nº 70. C.2.4 integrado e revalidado pelo PR nº 74. C.2.5–C.2.6 permanecem bloqueados.**'
)
replace_once(
    BLUEPRINT,
    'a fronteira integrada de C.2.3 está em\n[`LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md)\ne o estado operacional pós-C.2.3 é registrado no Checkpoint 047.',
    'a fronteira integrada de C.2.3 está em\n[`LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md),\na fronteira integrada de C.2.4 está em\n[`LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md`](LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md)\ne o estado operacional pós-C.2.4 é registrado no Checkpoint 048.'
)
replace_once(BLUEPRINT, '- `C.2.4` — idempotência, retomada e falha segura — **bloqueado**;', '- `C.2.4` — idempotência, retomada e falha segura — **concluído**;')

# PHASE C EXECUTION MAP
PHASE = 'docs/profeplan-knowledge-factory/12-delivery/PHASE-C-EXECUTION-MAP.md'
replace_once(
    PHASE,
    'Estado canônico após a integração de C.2.3 verificado em 14 de agosto de 2026: `main` em\n`f70312a9936b99e1c131627277ad4c4a65b126a5` (PR nº 70), tree\n`4b47c853a2cb041ca895477abc3c710ca9393b94`.',
    'Estado canônico após a integração de C.2.4 verificado em 15 de agosto de 2026: `main` em\n`14b7ff30d1b659ed8b2c824f9a943b05cdca93bc` (PR nº 74), tree\n`92411aec0c9da3789bb91c87d8f423a3c69f929d`.'
)
replace_once(
    PHASE,
    'Definição integrada de C.2.3:\n[`LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md).',
    'Definição integrada de C.2.3:\n[`LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md).\n\nDefinição integrada de C.2.4:\n[`LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md`](LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md).'
)
replace_once(
    PHASE,
    'revalidado pelo PR nº 62, C.2.2 pelo PR nº 67 e C.2.3 pelo PR nº 70. C.2.4–C.2.6, C.3–C.7,\ningestão real, fontes reais, wiring, Supabase hospedado, storage hospedado e produção permanecem bloqueados.**',
    'revalidado pelo PR nº 62, C.2.2 pelo PR nº 67, C.2.3 pelo PR nº 70 e C.2.4 pelo PR nº 74. C.2.5–C.2.6, C.3–C.7,\ningestão real, fontes reais, wiring, Supabase hospedado, storage hospedado e produção permanecem bloqueados.**'
)
replace_once(PHASE, 'A visibilidade de C.2.4–C.7 permanece planejamento, não autorização automática.', 'A visibilidade de C.2.5–C.7 permanece planejamento, não autorização automática.')
replace_once(
    PHASE,
    '| C.2 | Entrada controlada de fonte autorizada | EPIC-003; US-003.1 | **C.2.1–C.2.3 integrados; C.2.4 bloqueado** | C.2.3 integrado pelo PR nº 70; Checkpoint 047; C.2.4 exige contexto e DoR próprios |',
    '| C.2 | Entrada controlada de fonte autorizada | EPIC-003; US-003.1 | **C.2.1–C.2.4 integrados; C.2.5 bloqueado** | C.2.4 integrado pelo PR nº 74; Checkpoint 048; C.2.5 exige contexto e DoR próprios |'
)
replace_once(
    PHASE,
    '**Definição documental integrada pelo PR nº 59. C.2.1 integrado e revalidado pelo PR nº 62. C.2.2 integrado e revalidado pelo PR nº 67. C.2.3 integrado e revalidado pelo PR nº 70. C.2.4–C.2.6 permanecem bloqueados.**',
    '**Definição documental integrada pelo PR nº 59. C.2.1 integrado e revalidado pelo PR nº 62. C.2.2 integrado e revalidado pelo PR nº 67. C.2.3 integrado e revalidado pelo PR nº 70. C.2.4 integrado e revalidado pelo PR nº 74. C.2.5–C.2.6 permanecem bloqueados.**'
)
replace_once(
    PHASE,
    'a fronteira integrada de C.2.3 está em\n[`LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md)\ne o estado operacional pós-C.2.3 é registrado no Checkpoint 047.',
    'a fronteira integrada de C.2.3 está em\n[`LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md),\na fronteira integrada de C.2.4 está em\n[`LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md`](LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md)\ne o estado operacional pós-C.2.4 é registrado no Checkpoint 048.'
)
replace_once(PHASE, '- `C.2.4` — idempotência, retomada e falha segura — **bloqueado**;', '- `C.2.4` — idempotência, retomada e falha segura — **concluído**;')

# C.2.4 technical definition
LOT = 'docs/profeplan-knowledge-factory/12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md'
replace_once(
    LOT,
    'Base reconciliada da branch: `main` em `56e125bf72aabb885b0c0bc8b27f64d76ce98106`.\n\nEstado deste documento: **implementação em Draft PR; não integrada**.',
    'Base reconciliada da implementação: `main` em `56e125bf72aabb885b0c0bc8b27f64d76ce98106`.\n\nIntegração canônica: PR nº 74 por squash merge no commit `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`, tree `92411aec0c9da3789bb91c87d8f423a3c69f929d`.\n\nEstado deste documento: **implementação integrada e revalidada; C.2.5 permanece bloqueado**.'
)
replace_once(
    LOT,
    'Enquanto o Draft PR técnico não estiver integralmente verde, revisado e posteriormente integrado por autorização humana específica, C.2.4 permanece **não integrado** e C.2.5 continua bloqueado.',
    'C.2.4 foi integrado pelo PR nº 74 após revisão humana específica e gates verdes no HEAD final. O CI pós-merge nº 523 também terminou `success`. C.2.5 continua bloqueado e exige contexto próprio, inspeção canônica e autorização humana específica.'
)

print('C.2.4 post-merge documentation reconciliation applied successfully.')
