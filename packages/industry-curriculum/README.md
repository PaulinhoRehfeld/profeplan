# Indústria do Currículo 🏭

## Propósito
Esta "indústria" é responsável por transformar PDFs caóticos do currículo de Minas Gerais e da BNCC em **dados estruturados e validados** prontos para consumo pela aplicação web.

## O Que Ela Faz

### 1. Extração Estruturada
- Lê PDFs do planejamento trimestral da SEEMG
- Identifica: Trimestre → Unidade Temática → Habilidade BNCC → Objeto de Conhecimento
- Converte para JSON rígido e previsível

### 2. Validação com Guardrails
- Garante que as habilidades BNCC extraídas são **códigos reais** (ex: `EF06MA01`)
- Verifica se o conteúdo citado está presente no PDF original (Provenance Check)
- Bloqueia alucinações do LLM antes de salvar no banco

### 3. Alimentação do VectorDB
- Popula a tabela `curriculos_mg` no Supabase
- Cria embeddings vetoriais (768 dimensões) para busca semântica
- Mantém metadados estruturados em JSONB

## Scripts Principais

| Script | Descrição |
|--------|-----------|
| `ingest_curriculo_rag.py` | RAG ingestion para VectorDB |
| `integrador_curriculo.py` | Integração com AI/Gemini |
| `gerador_base_planejamentos.py` | Gerador de planejamentos base |
| `pipeline_mg.py` | **Pipeline principal com Guardrails** (novo) |

## Instalação

```bash
cd packages/industry-curriculum
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Uso

```bash
# Processar PDFs do currículo de MG
python src/pipeline_mg.py --input data/curriculo_mg.pdf --output data/output.json

# Ingerir no Supabase
python src/ingest_curriculo_rag.py
```

## Contrato de Saída

Formato JSON esperado para alimentar o Supabase:

```json
{
  "disciplina": "Matemática",
  "ano": "6º Ano EF",
  "trimestre": "1º Trimestre",
  "unidades": [
    {
      "titulo": "Números e Álgebra",
      "habilidades": ["EF06MA01", "EF06MA02"],
      "objetos_conhecimento": ["Sistema de numeração decimal", "Operações"]
    }
  ]
}
```

---
**Esta indústria roda offline (noturno) e alimenta o "estoque" (Supabase) para a loja consumir.**
