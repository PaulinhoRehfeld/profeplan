# 🐛 CORREÇÃO: Suporte a Múltiplas Escolas

## Problema Identificado

Professores que trabalham em 2 escolas (ex: Antônio Lago + Domingos Pimenta)
perdiam o vínculo com a primeira escola ao salvar a segunda.

### Causa Raiz

- O campo `profiles.active_school_id` era SOBRESCRITO a cada salvamento
- Não havia lógica para preservar vínculos anteriores
- O `userService.updateUserProfile()` também atualizava `school_id`

## Correções Aplicadas

### 1. `teacherSchoolService.ts` - Função `reconcileTeacherByInep()`

**ANTES:**

```typescript
// Sempre sobrescrevia active_school_id
.update({ active_school_id: school.id })
```

**DEPOIS:**

```typescript
// Verifica se já existe escola ativa antes de atualizar
const { data: currentProfile } = await supabase
    .from('profiles')
    .select('active_school_id')
    .eq('id', teacherId)
    .single();

if (!currentProfile?.active_school_id) {
    // Só define se for a PRIMEIRA escola
    .update({ active_school_id: school.id })
} else {
    // Não sobrescreve se já existir
    console.log('active_school_id already set, not overwriting');
}
```

### 2. `userService.ts` - Função `updateUserProfile()`

**ANTES:**

```typescript
// Atualizava school_id diretamente
if (school) {
    updates.school_id = school.id;
}
```

**DEPOIS:**

```typescript
// Não atualiza mais school_id
// O linkamento é feito exclusivamente via teacher_schools
console.log('School linking is handled by teacherSchoolService');
```

## Nova Arquitetura de Dados

### Fonte de Verdade: `teacher_schools`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | UUID | Identificador do vínculo |
| teacher_id | UUID | FK para profiles.id |
| school_id | TEXT | ID da escola (INEP ou UUID) |
| started_at | TIMESTAMP | Início do vínculo |
| ended_at | TIMESTAMP | Fim do vínculo (NULL = ativo) |
| role | TEXT | 'teacher', 'coordinator', 'principal' |

### Campos Legacy em `profiles` (NÃO usar para lógica de negócio)

- `school_id` - Mantido para compatibilidade, não atualizado mais
- `active_school_id` - Escola "ativa" atual (para UI singletons)

## Fluxo Correto de Linkamento

```
Professor salva perfil com INEP "23299"
    ↓
ProfileTab → reconcileTeacherByInep("23299")
    ↓
Cria registro em teacher_schools (NÃO sobrescreve active_school_id se já existe)
    ↓
Professor salva perfil com INEP "31205893" (segunda escola)
    ↓
ProfileTab → reconcileTeacherByInep("31205893")
    ↓
Cria NOVO registro em teacher_schools
    ↓
active_school_id PERMANECE como "23299" (primeira escola)
    ↓
✅ Professor agora tem 2 vínculos ativos
```

## Consulta para Verificar Vínculos

```sql
SELECT 
    ts.id,
    p.full_name,
    s.name as escola,
    s.inep_code,
    ts.started_at,
    ts.ended_at
FROM teacher_schools ts
JOIN profiles p ON ts.teacher_id = p.id
LEFT JOIN schools s ON ts.school_id = s.id
WHERE ts.ended_at IS NULL
ORDER BY ts.started_at;
```

## Próximos Passos Opcionais

1. **Adicionar UI para trocar escola ativa** - Dropdown no header
2. **Migrar dados legacy** - Copiar school_id existente para teacher_schools
3. **Remover campos school_id de profiles** - Após migração completa
4. **Adicionar tabela school_supervisors** - Para gestores (managers)

---
*Documento gerado em: 2026-01-31*
