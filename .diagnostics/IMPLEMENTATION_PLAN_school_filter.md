# 📋 PLANO DE IMPLEMENTAÇÃO - Filtro por Escola Ativa

## 🎯 **Objetivo**

Aplicar filtro por `active_school_id` em **TODAS as funcionalidades** que manipulam dados associados a escolas.

---

## ✅ **Status Atual**

### **Já Implementado:**

1. ✅ **SchoolSwitcher** - Dropdown funcional no header
2. ✅ **Minhas Turmas** - Filtra por `active_school_id`

---

## 🔧 **Componentes a Modificar**

### **1. Planejamento (Planning)**

- **Arquivo:** `src/features/Planning/PlanningManager.tsx`
- **Filtro:** Planos salvos devem ter `school_id`
- **Query:** Buscar apenas planos da escola ativa

### **2. Plano de Aula (Term Planning)**

- **Arquivo:** `src/features/TermPlanning/TermPlanningManager.tsx`
- **Filtro:** Planos trimestrais por escola
- **Query:** `.eq('school_id', active_school_id)`

### **3. PDI (Plano de Desenvolvimento Individual)**

- **Arquivo:** `src/features/PDI/PDIManager.tsx`
- **Filtro:** PDIs vinculados a alunos de turmas da escola ativa
- **Query:** Via join `students → classes → school_id`

### **4. Simulados (Assessment)**

- **Arquivo:** `src/features/Assessment/AssessmentManager.tsx`
- **Filtro:** Avaliações por escola
- **Query:** `.eq('school_id', active_school_id)`

### **5. Slides (Presentations)**

- **Arquivo:** `src/components/PresentationCreator.tsx`
- **Filtro:** Apresentações por escola
- **Query:** `.eq('school_id', active_school_id)`

### **6. Meus Arquivos (Drive)**

- **Arquivo:** `src/components/DriveExplorer.tsx`
- **Filtro:** Arquivos organizados por escola
- **Estrutura:** `/{user_id}/{school_id}/{tipo}/{arquivo}`

---

## 🔄 **Estratégia de Implementação**

### **Fase 1: Modificar Estrutura de Dados (DB)**

Adicionar coluna `school_id` em todas as tabelas que não têm:

```sql
-- 1. Planos de aula (lesson_plans / term_plans)
ALTER TABLE lesson_plans ADD COLUMN school_id TEXT REFERENCES schools(id);
ALTER TABLE term_plans ADD COLUMN school_id TEXT REFERENCES schools(id);

-- 2. Avaliações (assessments)
ALTER TABLE assessments ADD COLUMN school_id TEXT REFERENCES schools(id);

-- 3. Apresentações (presentations)
ALTER TABLE presentations ADD COLUMN school_id TEXT REFERENCES schools(id);

-- 4. Conteúdos gerados (generated_contents)
ALTER TABLE generated_contents ADD COLUMN school_id TEXT REFERENCES schools(id);
```

### **Fase 2: Modificar Services**

Atualizar **TODOS os services** para aceitar `schoolId` opcional:

```typescript
// Exemplo: planningService.ts
export const getPlans = async (userId: string, schoolId?: string) => {
    let query = supabase
        .from('lesson_plans')
        .select('*')
        .eq('user_id', userId);
    
    if (schoolId) {
        query = query.eq('school_id', schoolId);
    }
    
    return await query;
};
```

### **Fase 3: Modificar Componentes**

Padrão para **TODOS os componentes**:

```typescript
interface ComponentProps {
    userId: string;
    userProfile: UserProfile; // ← ADICIONAR
}

const Component: React.FC<ComponentProps> = ({ userId, userProfile }) => {
    const activeSchoolId = userProfile?.active_school_id;
    
    useEffect(() => {
        loadData(userId, activeSchoolId); // ← PASSAR ESCOLA
    }, [userId, activeSchoolId]); // ← REAGIR A MUDANÇAS
};
```

### **Fase 4: Atualizar Saves**

Ao salvar novos registros, **SEMPRE incluir `school_id`**:

```typescript
const handleSave = async (data: any) => {
    await supabase.from('tabela').insert({
        ...data,
        user_id: userId,
        school_id: userProfile.active_school_id // ← OBRIGATÓRIO
    });
};
```

---

## 📊 **Tabelas e seus Filtros**

| Tabela | Tem school_id? | Ação Necessária |
|--------|---------------|-----------------|
| `classes` | ✅ Sim | Já implementado |
| `students` | ❌ Não (via classes) | Join com classes |
| `lesson_plans` | ❓ Verificar | Adicionar coluna |
| `term_plans` | ❓ Verificar | Adicionar coluna |
| `assessments` | ❓ Verificar | Adicionar coluna |
| `presentations` | ❓ Verificar | Adicionar coluna |
| `generated_contents` | ❓ Verificar | Adicionar coluna |
| `pdi_entries` | ❌ Não (via students) | Join com students → classes |

---

## 🧪 **Checklist de Validação**

Para cada funcionalidade, testar:

- [ ] **Criação:** Novos registros incluem `school_id` correto
- [ ] **Listagem:** Apenas dados da escola ativa aparecem
- [ ] **Troca de Escola:** Ao trocar no dropdown, dados atualizam automaticamente
- [ ] **Edição:** Ao editar, `school_id` não muda
- [ ] **Exclusão:** Apenas registros da escola ativa podem ser deletados

---

## 🚀 **Ordem de Implementação Recomendada**

1. ✅ **Minhas Turmas** (CONCLUÍDO)
2. 🔄 **Planejamento** (Mais usado)
3. 🔄 **Plano de Aula** (Frequente)
4. 🔄 **Avaliações** (Importante)
5. 🔄 **PDI** (Complexo - via joins)
6. 🔄 **Slides** (Menos crítico)
7. 🔄 **Meus Arquivos** (Últi)

---

## ⚠️ **Dados Legados**

**Problema:** Registros antigos sem `school_id`

**Solução:**

```sql
-- Script de migração para cada tabela
UPDATE tabela SET school_id = (
    SELECT active_school_id 
    FROM profiles 
    WHERE profiles.id = tabela.user_id
)
WHERE school_id IS NULL;
```

---

## 📝 **Próximos Passos**

1. **Verificar estrutura atual** de cada tabela
2. **Criar migrations SQL** para adicionar `school_id`
3. **Modificar services** um por um
4. **Atualizar componentes** seguindo o padrão
5. **Testar cada funcionalidade** com 2 escolas
6. **Documentar** mudanças

---

**Data de Criação:** 2026-01-31
**Status:** 🟡 Em Planejamento
