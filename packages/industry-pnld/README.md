# Indústria PNLD 🛢️

## Propósito
A "Refinaria" de livros didáticos. Transforma PDFs caóticos de diferentes editoras em **dados estruturados e normalizados** prontos para consumo.

## O Problema que Resolve

Livros do PNLD (Programa Nacional do Livro e do Material Didático) vêm de:
- 🏢 **Múltiplas editoras** (FTD, Moderna, Ática, etc.)
- 📚 **Formatos diferentes** (layout, estrutura, qualidade de scan)
- 🎨 **Estilos variados** (fontes, tabelas, imagens intercaladas)

Resultado: **Caos de dados não estruturados**.

## O Que Esta Indústria Faz

### 1. Coleta Automatizada
- Scrapers para sites das editoras (Playwright)
- Download organizado de PDFs por disciplina/ano

### 2. Normalização Multi-Editora
```
PDF Sujo (FTD) ──→ LLM Cleaner ──→ JSON Padrão Profeplan
PDF Sujo (Moderna) ──→ LLM Cleaner ──→ JSON Padrão Profeplan  
PDF Sujo (Outras) ──→ LLM Cleaner ──→ JSON Padrão Profeplan
```

### 3. Enriquecimento com Metadados
- Extração de: Título, ISBN, Editora, Coleção
- Identificação automática: Disciplina, Ano/Série, Nível de Ensino
- Tagging automático com códigos BNCC encontrados no conteúdo

### 4. Validação de Qualidade
- Taxa de extração (% de fragmentos válidos vs. ruído OCR)
- Verificação de completude (todos os capítulos extraídos?)
- Sanitização de dados (remoção de caracteres OCR mal lidos)

### 5. Ingestão no Banco
- Populate `pnld_livros` (metadados)
- Populate `pnld_livros_conteudo` (VectorDB - opcional)

## Scripts Principais

| Script | Descrição |
|--------|-----------|
| `export_to_json.py` | Exporta PDF para JSON estruturado |
| `parse_book_metadata.py` | Extrai metadados (ISBN, Editora, etc.) |
| `populate_pnld_livros.py` | Popula tabela no Supabase |
| `integrador_pnld_livros.py` | Integração com AI/Gemini |
| `normalizer_pipeline.py` | **Pipeline principal** (novo) |

## Instalação

```bash
cd packages/industry-pnld
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Uso

```bash
# Colocar PDFs em data/raw_pdfs/
# Processar e normalizar
python src/normalizer_pipeline.py

# Resultado: JSONs normalizados em data/normalized_json/
```

## Formato de Saída (JSON Normalizado)

```json
{
  "titulo": "Matemática: Ciência e Aplicações",
  "isbn": "978-85-16-12345-6",
  "editora": "FTD",
  "colecao": "Ciência e Aplicações",
  "disciplina": "Matemática",
  "ano_serie": "1º Ano EM",
  "nivel_ensino": "Ensino Médio",
  "volume": "Volume 1",
  "capitulos": [
    {
      "numero": 1,
      "titulo": "Conjuntos",
      "resumo": "...",
      "habilidades_bncc": ["EM13MAT101", "EM13MAT102"],
      "topicos": ["Conjuntos numéricos", "Operações"]
    }
  ],
  "qualidade": {
    "taxa_extracao": 95.5,
    "fragmentos_totais": 150,
    "fragmentos_validos": 143
  }
}
```

## Contrato com a Loja

A Loja (`apps/web`) consulta a tabela `pnld_livros` com queries como:

```sql
SELECT * FROM pnld_livros 
WHERE disciplina = 'Matemática' 
  AND ano_serie = '6º Ano EF'
  AND nivel_ensino = 'Ensino Fundamental';
```

Não precisa processar o PDF em runtime. Tudo já está pronto e indexado.

---
**Esta indústria roda offline (noturno/batch) e alimenta o "catálogo" (Supabase) para a loja exibir.**
