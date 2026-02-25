---
description: Workflow para atualizar registro INPI após mudanças significativas
---

# Atualizar Registro INPI

Este workflow deve ser executado quando houver alterações significativas no sistema PROFEPLAN que justifiquem atualização dos registros no INPI.

---

## Gatilhos (Quando Executar)

Execute este workflow quando ocorrer qualquer um dos seguintes eventos:

1. **Lançamento de Versão Major** (X.0.0)
   - Mudanças arquiteturais significativas
   - Adição de componentes principais
   - Refatoração completa de módulos

2. **Adição de Componente Arquitetural**
   - Nova "Indústria" no ecossistema
   - Novo framework ou tecnologia principal
   - Funcionalidade que altera o core business

3. **Mudança de Titular**
   - Transferência de PF para PJ
   - Alteração de razão social
   - Mudança de sócios/acionistas

4. **Atualização de Marca**
   - Rebranding (mudança de logo)
   - Adição de novas classes NCL
   - Expansão de especificações

---

## Passo 1: Verificar Necessidade de Atualização

**Perguntas-chave:**
- [ ] A mudança afeta a arquitetura geral do sistema?
- [ ] Foram adicionadas tecnologias principais ao stack?
- [ ] O memorial descritivo ficou desatualizado?
- [ ] Houve mudança no titular ou razão social?

**Se SIM para qualquer pergunta acima** → Prossiga para Passo 2  
**Se NÃO para todas** → Atualização não necessária

---

## Passo 2: Gerar Novo Hash SHA-512

```powershell
# Executar na raiz do projeto
python gerar_hash_inpi.py
```

**Verificações:**
- [ ] Hash gerado com sucesso
- [ ] Arquivo `REGISTRO_SOFTWARE_INPI.txt` atualizado
- [ ] Comparar hash antigo vs. novo (devem ser diferentes se código mudou)

**Output esperado:**
```
✅ SUCESSO! Hash gerado.
📂 Arquivo gerado: REGISTRO_SOFTWARE_INPI.txt
🔑 HASH MESTRE: [64 primeiros caracteres]...
```

---

## Passo 3: Atualizar Memorial Descritivo

```powershell
# Gerar nova versão do memorial
python gerador_memorial_descritivo.py
```

**Verificações:**
- [ ] Memorial gerado em `MEMORIAL_DESCRITIVO_PROFEPLAN.md`
- [ ] Revisar seções de componentes técnicos
- [ ] Verificar stack tecnológico atualizado
- [ ] Confirmar estatísticas de código

**Ações Manuais:**
- [ ] Revisar o memorial gerado
- [ ] Ajustar descrições se necessário
- [ ] Converter para PDF (se Pandoc disponível)

---

## Passo 4: Compilar Diff de Mudanças

Criar arquivo `DIFF_ATUALIZACAO_INPI.md` com:

```markdown
# Diff de Atualização INPI - [Data]

## Versão Anterior
- Data do registro original: [data]
- Hash SHA-512 anterior: [hash]
- Versão do sistema: [versão]

## Versão Atual
- Data desta atualização: [data]
- Hash SHA-512 atual: [hash]
- Versão do sistema: [versão]

## Mudanças Principais

### Componentes Adicionados
- [Componente 1]: [descrição]
- [Componente 2]: [descrição]

### Componentes Removidos
- [Componente X]: [motivo]

### Tecnologias Atualizadas
- [Tech 1]: de [versão antiga] para [versão nova]

### Inovações Técnicas
- [Nova inovação]: [breve descrição]

## Impacto no Memorial Descritivo
- Seção X: [mudanças]
- Seção Y: [mudanças]
```

---

## Passo 5: Submeter Atualização ao INPI

### Para SOFTWARE:

**Opção A: Novo Registro (Recomendado para mudanças major)**
1. Acesse: https://www.gov.br/inpi/pt-br/servicos/programas-de-computador
2. Selecione "Novo Pedido de Registro"
3. Mencione registro anterior no campo "Observações"
4. Anexe:
   - Novo hash SHA-512
   - Memorial atualizado
   - DIFF_ATUALIZACAO_INPI.md
5. Pague GRU (R$ 355,00)

**Opção B: Averbação (Para mudanças menores)**
1. Acesse: https://www.gov.br/inpi/pt-br/servicos/programas-de-computador
2. Selecione "Averbação"
3. Tipo: "Atualização de Versão"
4. Anexe DIFF_ATUALIZACAO_INPI.md
5. Pague GRU (R$ 355,00)

### Para MARCA:

**Averbação de Mudança:**
1. Acesse: https://www.gov.br/inpi/pt-br/servicos/marcas
2. Selecione "Averbação"
3. Escolha tipo:
   - Mudança de titular (PF→PJ)
   - Mudança de razão social
   - Atualização de especificações (classes)
4. Anexe documentos pertinentes
5. Pague GRU (R$ 355,00 por classe)

---

## Passo 6: Atualizar Documentação Interna

Atualizar os seguintes arquivos:

### `CATALOGO_INOVACOES.md`
- [ ] Adicionar novas inovações (se aplicável)
- [ ] Atualizar versões de inovações existentes
- [ ] Revisar valuation de P&D

### `POLITICA_SEGREDO_INDUSTRIAL.md`
- [ ] Adicionar novos segredos industriais (se aplicável)
- [ ] Atualizar medidas de proteção
- [ ] Revisar data de última atualização

### `README.md` (Raiz do Projeto)
- [ ] Atualizar versão do sistema
- [ ] Mencionar atualização do registro INPI
- [ ] Adicionar link para novo certificado (quando emitido)

---

## Passo 7: Acompanhamento

**Timeline Esperada:**
```
Dia 0: Submissão da atualização
  ↓
Dia 30-60: Análise formal (INPI)
  ↓
Dia 60: Publicação na RPI (ou exigência)
  ↓
Dia 90: Concessão (ou resposta a exigência)
```

**Acompanhar:**
- [ ] Publicação na RPI semanal
- [ ] Responder exigências em até 60 dias
- [ ] Guardar comprovantes de pagamento

---

## Checklist Final

Antes de concluir o workflow:

- [ ] Hash SHA-512 atualizado
- [ ] Memorial descritivo gerado
- [ ] DIFF de mudanças compilado
- [ ] Submissão INPI realizada
- [ ] Documentação interna atualizada
- [ ] Comprovantes arquivados
- [ ] Acompanhamento agendado (calendário)

---

**Última atualização:** 16/02/2026  
**Próxima revisão:** Quando houver lançamento major
