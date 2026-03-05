# Modelo Colaborativo — PROFEPLAN

**Data:** 2026-02-28  
**Contexto:** O PROFEPLAN não é uma ferramenta de uso individual; é um **projeto de utilização colaborativa** no contexto escolar.

---

## 1. Vínculos entre Entidades

O sistema possui vínculos bem específicos entre:

```
ESCOLA (schools)
  ├── school_id (código INEP)
  ├── name, city, sre
  │
  ├── PROFESSORES (profiles)
  │     └── profiles.school_id → escola vinculada
  │     └── role: teacher | manager | admin
  │     └── masp (identificador único do professor)
  │
  ├── TURMAS (classes)
  │     └── classes.school_id → escola
  │     └── subject, grade, period
  │     └── teacher_id → professor responsável
  │
  ├── ALUNOS (school_students)
  │     └── school_students.school_id → escola
  │     └── class_id → turma (opcional)
  │     └── Vinculados via PDI por escola
  │
  └── PDI (pdi_documents)
        └── school_id → escola
        └── content_data → dados do documento
```

### Fluxo de Dados

| Entidade | Relacionamento | Uso |
|----------|----------------|-----|
| **Professor** | `profiles.school_id` | Professor vinculado a uma escola |
| **Turma** | `classes.school_id`, `classes.teacher_id` | Turma pertence à escola; professor responsável |
| **Aluno** | `school_students.school_id`, `school_students.class_id` | Aluno na escola; opcionalmente em turma |
| **Disciplina** | `classes.subject` | Cada turma tem disciplina e série |
| **PDI** | `pdi_documents.school_id` | Documentos PDI no âmbito da escola |

---

## 2. Políticas de Acesso (RLS)

- **profiles**: Usuários veem colegas da mesma escola (`get_auth_school_id()`)
- **classes**: Acesso quando `profiles.school_id = classes.school_id`
- **school_students**: Escopo por escola
- **pdi_documents**: Acesso quando usuário pertence à escola do documento

---

## 3. Implicações para Créditos e IA

### Hoje (individual)
- Créditos em `profiles.credits` — por usuário
- Uso de IA (planejamento, chat, adaptações) desconta do professor que executa

### Futuro (colaborativo)
- **Pool de créditos por escola**: A escola pode ter um orçamento de créditos compartilhado
- **Contexto em operações**: Toda operação de IA deve conhecer `(userId, schoolId, classId?, subject?)` para:
  - Auditoria de uso
  - Relatórios por escola
  - Possível billing por rede/secretaria

### CreditManager e contexto escolar

O `CreditManager` está preparado para evoluir:

```typescript
// Hoje
executeWithCreditCheck(userId, fn, taskType)

// Futuro (interface estendida)
executeWithCreditCheck(userId, fn, taskType, { schoolId?: string, classId?: string })
```

- `schoolId`: Resolvido a partir de `profiles.school_id` do usuário
- Permite, no futuro, aplicar regras de quota por escola ou por rede

---

## 4. Fluxos Colaborativos Existentes

| Fluxo | Colaboração |
|-------|-------------|
| **Pending Teachers** | Gestor aprova professores; vínculo automático à escola via MASP + INEP |
| **PDI** | Documentos compartilhados no âmbito da escola; adaptações por aluno/turma |
| **Planejamento** | Professor gera para sua turma/disciplina; pode ser compartilhado no drive da escola |
| **Gestão Escolar** | SchoolDashboard permite coordenação (gestores, professores) |

---

## 5. Referências

- Migrations: `infra/supabase/migrations/` (profiles, classes, school_students, pdi_documents)
- `PROFEPLAN_CONTEXT.md` — Visão B2G e ecossistema
- `product-brief-PROFEPLAN-2026-02-28.md` — Personas (Ana, Carlos) e uso colaborativo
