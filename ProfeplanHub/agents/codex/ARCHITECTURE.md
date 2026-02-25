# CODEX - Architecture & Standards

## Visão Geral

Este documento define a arquitetura do **CODEX**, o "Cérebro de Inteligência" do Profeplan.
O CODEX é responsável por processar documentos oficiais e livros do PNLD para gerar índices inteligentes e mapas de conhecimento.

## Estrutura de Pastas

```
c:/Users/Admin/PROFEPLAN/CODEX/ (Operando em CONV_PDF_MD)
├── inputs/                # [FONTE] Arquivos PDF originais
│   └── pnld/              # Livros do PNLD para indexação
├── outputs/               # [DESTINO] 
│   ├── md/                # Markdown bruto (Legado/Suporte)
│   ├── codex_maps/        # [NOVO] Mapas de Conhecimento JSON (PNLD)
│   └── ingest_packets/    # Pacotes JSON para o Supabase
├── scripts/               # Lógica de negócio e Agentes
├── codex_indexer.py       # [CÉREBRO] Agente Indexador de Livros
├── tech_lead.py           # Agente Gestor (RLM)
└── ARCHITECTURE.md        # Este documento
```

## Padrões de Código e Fluxo de Dados

### 1. Convenção de Nomes

- **PDFs de Entrada**: `NºANO_DISCIPLINE_ENSINO_MÉDIO_1TRI.PDF`
- **MDs de Saída**: Mesmo nome do arquivo de entrada, extensão `.md`.
- **Scripts**: Snake_case (ex: `convert_pdfs.py`).

### 2. Regras de Processamento (Pipeline)

1. **Ingestão**: O script varre a pasta `inputs/` buscando arquivos `.pdf`.
2. **Filtragem**:
    - Ignore as **3 primeiras páginas** (índices 0, 1, 2) de cada PDF.
    - Processe da página 4 em diante (índice 3+).
3. **Conversão**:
    - Utiliza a biblioteca `pymupdf4llm` para extração de texto e tabelas em Markdown.
    - Utiliza `pymupdf` (fitz) para manipulação de baixo nível (contagem de páginas).
4. **Persistência**:
    - Salva o resultado em `outputs/` com encoding `utf-8`.

### 3. Stack Tecnológica

- **Linguagem**: Python 3.x
- **Bibliotecas Principais**:
  - `pymupdf4llm`: Conversão PDF -> MD Otimizada para LLMs.
  - `rlm`: Gestão de Contexto e Agente Tech Lead.

## Protocolo de Evolução (Tech Lead)

Para qualquer nova feature:

1. Execute `tech_lead.py` ou consulte este documento.
2. **Não** altere nomes de pastas padrão (`inputs`/`outputs`).
3. **Não** altere a lógica de exclusão de páginas sem validação prévia.
4. Mantenha o `requirements.txt` atualizado.
