---
description: Como atualizar o banco de dados de questões do ENEM fazendo upload de arquivos PDF.
---

# Atualização do Banco de Questões ENEM (Upload PDF)

Esta skill permite adicionar novas questões ao banco de dados `enem_questions` do ProfePlan a partir de arquivos PDF (provas ou simulados). O processo utiliza IA (Gemini) para ler o arquivo, extrair as questões, gerar embeddings e salvar no Supabase.

## Pré-requisitos

1. **Arquivos PDF/Imagem**: Tenha os arquivos das provas prontos.
2. **Credenciais**: Certifique-se de que o arquivo `.env` na raiz do projeto contém:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
   - `VITE_GEMINI_API_KEY`

## Passos

1. **Colocar Arquivos na Pasta de Ingestão**
   - Copie seus arquivos PDF para a pasta:
     `c:\Users\Admin\PROFEPLAN\PROFEPLAN\ingest_data`
   - Se a pasta não existir, ela será criada automaticamente na primeira execução.

2. **Executar o Script de Ingestão**
   - Abra o terminal no diretório do projeto (`c:\Users\Admin\PROFEPLAN\PROFEPLAN`).
   - Execute o seguinte comando:

     ```bash
     node scripts/ingest_enem_pdf_to_db.js
     ```

## O que o Script Faz

1. **Leitura**: Identifica arquivos PDF na pasta `ingest_data`.
2. **OCR Inteligente**: Envia o arquivo para o modelo `gemini-2.0-flash`, que extrai o texto estruturado (Enunciado, Alternativas, Gabarito, Ano, Disciplina).
3. **Embeddings**: Gera vetores semânticos para indexação com `text-embedding-004`.
4. **Inserção**: Salva os dados na tabela `enem_questions` do Supabase.

// turbo
3. **Limpeza (Opcional)**

- Após a confirmação de "Sucesso", você pode remover os arquivos da pasta `ingest_data` para evitar duplicidade em execuções futuras.
