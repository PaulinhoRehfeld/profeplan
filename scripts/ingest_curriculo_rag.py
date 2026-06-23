"""
ingest_curriculo_rag.py
Ingestão dos MDs do currículo MG → tabela curriculos_mg no Supabase.

Migrado de Gemini → DeepSeek (OpenAI-compatible).
Os embeddings são gerados via prompt engineering (768 dim) igual ao api/ai/embeddings.ts.

Uso:
  python ingest_curriculo_rag.py             # Ingere novos arquivos
  python ingest_curriculo_rag.py --truncate  # Limpa a tabela antes de inserir
"""

import os
import re
import glob
import json
import time
import argparse
from openai import OpenAI
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

# ─── Caminhos ────────────────────────────────────────────────────────────────
# Diretório dos MDs curados (lista com orientações pedagógicas, sem tabelas PDF)
MD_PATH = os.path.join(os.path.dirname(__file__), "..", "curriculo_mg", "PlanosMG", "MD")
MD_PATH = os.path.abspath(MD_PATH)

# ─── Variáveis de ambiente ───────────────────────────────────────────────────
SUPABASE_URL  = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY  = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")
DEEPSEEK_KEY  = os.getenv("DEEPSEEK_API_KEY")
DEEPSEEK_BASE = os.getenv("DEEPSEEK_API_BASE", "https://api.deepseek.com")

VECTOR_DIM = 768

# ─── Lógica de deduplicação ──────────────────────────────────────────────────
# Quando existe o par (sem acento, com acento), o sem acento é a versão curada
# com orientações pedagógicas ricas — o com acento é conversão bruta de tabela PDF.
# Descartamos os arquivos COM acento quando o par SEM acento existe.
PREFER_NO_ACCENT = True  # Altere para False para incluir TODOS os arquivos

def should_skip(filename: str, all_files: list[str]) -> bool:
    """Retorna True se o arquivo for a versão pior de um par duplicado."""
    if not PREFER_NO_ACCENT:
        return False
    # Normaliza: remove acentos e underscores extras para comparação
    def normalize(name):
        n = name.upper()
        n = n.replace("Á","A").replace("Ã","A").replace("É","E").replace("Ê","E")
        n = n.replace("Í","I").replace("Ó","O").replace("Ô","O").replace("Ú","U")
        n = n.replace("Ç","C").replace("_","").replace(" ","").replace("-","")
        return n.replace(".MD", "")

    norm_current = normalize(filename)
    # Verifica se existe outro arquivo com a mesma normalização
    for other in all_files:
        if other == filename:
            continue
        if normalize(other) == norm_current:
            # Tem par — mantém o maior (mais conteúdo)
            current_path = os.path.join(MD_PATH, filename)
            other_path   = os.path.join(MD_PATH, other)
            if os.path.getsize(current_path) < os.path.getsize(other_path):
                return True  # este é o menor → descartar
    return False


# ─── DeepSeek embeddings via prompt ─────────────────────────────────────────
def gerar_embedding(client: OpenAI, text: str) -> list[float] | None:
    system_prompt = (
        "You are a semantic embedding generator. Analyze the following text and output "
        f"exactly {VECTOR_DIM} floating-point numbers between -1 and 1 that represent its "
        "semantic meaning. Output ONLY a valid JSON array of numbers, nothing else."
    )
    for attempt in range(3):
        try:
            resp = client.chat.completions.create(
                model="deepseek-chat",
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user",   "content": text[:6000]},
                ],
                temperature=0.05,
                max_tokens=4096,
            )
            raw = resp.choices[0].message.content or ""
            match = re.search(r"\[[\s\S]*\]", raw)
            if not match:
                raise ValueError("Sem array JSON na resposta")
            vec = json.loads(match.group(0))
            if len(vec) < VECTOR_DIM:
                vec += [0.0] * (VECTOR_DIM - len(vec))
            return vec[:VECTOR_DIM]
        except Exception as e:
            print(f"      [WARN] Tentativa {attempt + 1}/3 de embedding falhou: {e}")
            time.sleep(3 * (attempt + 1))
    return None


# ─── Chunking por cabeçalhos Markdown ────────────────────────────────────────
def chunkar_md(conteudo: str) -> list[dict]:
    """
    Divide o MD em blocos por período (### 1° Bimestre / ### 1° Trimestre).
    Retorna lista de dicts: {text, disciplina, ano_escolar, periodo}.
    """
    linhas = conteudo.split("\n")

    disciplina = ""
    ano_escolar = ""
    periodo = ""
    buffer: list[str] = []
    blocos: list[dict] = []

    def flush():
        content = "\n".join(buffer).strip()
        if content and periodo:
            blocos.append({
                "text": f"Disciplina: {disciplina}. Ano: {ano_escolar}. Período: {periodo}.\n---\n{content}",
                "disciplina": disciplina,
                "ano_escolar": ano_escolar,
                "periodo": periodo,
            })

    for linha in linhas:
        stripped = linha.strip()
        if stripped.startswith("# "):
            flush(); buffer = []
            disciplina = stripped[2:].strip()
        elif stripped.startswith("## "):
            flush(); buffer = []
            ano_escolar = stripped[3:].strip()
        elif stripped.startswith("### "):
            flush(); buffer = []
            periodo = stripped[4:].strip().replace("°", "º")
        else:
            buffer.append(linha)

    flush()
    return blocos


# ─── Normalização do nome do arquivo ─────────────────────────────────────────
def normalizar_metadados(nome_arquivo: str) -> dict:
    """Extrai disciplina, ano e nível a partir do nome do arquivo."""
    base = nome_arquivo.replace(".md", "").replace(".MD", "")
    parts = base.split("_")

    nivel = ""
    ano_num = ""
    disciplina_raw = ""

    if len(parts) >= 3:
        raw_ano   = parts[0]  # ex: 1ANO, 6ANO
        raw_nivel = parts[1]  # ex: EM, EF
        disciplina_raw = "_".join(parts[2:]).title()

        ano_num = ''.join(filter(str.isdigit, raw_ano))
        nivel = "EM" if "EM" in raw_nivel.upper() else "EF"

    ano_formatado = (
        f"{ano_num}º Ano EM" if nivel == "EM"
        else f"{ano_num}º Ano"
    )

    # Ajustes finos na disciplina
    disciplina = disciplina_raw
    for busca, troca in [
        ("Historia", "História"), ("Matematica", "Matemática"),
        ("Fisica", "Física"),     ("Quimica", "Química"),
        ("Biologia", "Biologia"), ("Sociologia", "Sociologia"),
        ("Filosofia", "Filosofia"), ("Geografia", "Geografia"),
        ("Ciencias", "Ciências"), ("Lingua_Portuguesa", "Língua Portuguesa"),
        ("Lingua_Inglesa", "Língua Inglesa"), ("Linguaportuguesa", "Língua Portuguesa"),
        ("Linguainglesa", "Língua Inglesa"), ("Educacaofisica", "Educação Física"),
        ("Educação_Física", "Educação Física"), ("Educação_Digital", "Educação Digital"),
        ("Ensinoreligioso", "Ensino Religioso"),
    ]:
        if busca.lower() in disciplina.lower():
            disciplina = troca
            break

    return {"disciplina": disciplina, "ano_escolar": ano_formatado, "nivel": nivel}


# ─── Main ────────────────────────────────────────────────────────────────────
def processar_arquivos(should_truncate: bool = False):
    if not SUPABASE_URL or not SUPABASE_KEY:
        print("[ERROR] SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY são obrigatórios.")
        exit(1)
    if not DEEPSEEK_KEY:
        print("[ERROR] DEEPSEEK_API_KEY é obrigatório.")
        exit(1)

    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    openai_client = OpenAI(api_key=DEEPSEEK_KEY, base_url=DEEPSEEK_BASE)

    if not os.path.exists(MD_PATH):
        print(f"[ERROR] Diretório não encontrado: {MD_PATH}")
        exit(1)

    if should_truncate:
        print("[INFO] Limpando registros antigos (curriculos_mg)...")
        try:
            supabase.table("curriculos_mg").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
            print("[OK] Tabela limpa.")
        except Exception as e:
            print(f"[WARN] Não foi possível limpar automaticamente: {e}")

    todos_arquivos = [os.path.basename(f) for f in glob.glob(os.path.join(MD_PATH, "*.md"))]
    arquivos_md = sorted(glob.glob(os.path.join(MD_PATH, "*.md")))

    # Filtrar arquivos com typo ou de teste
    arquivos_md = [f for f in arquivos_md if not os.path.basename(f).startswith("test_")]

    print(f"\n[INFO] Diretório: {MD_PATH}")
    print(f"[INFO] Total de arquivos encontrados: {len(arquivos_md)}")

    total_chunks = 0
    total_files  = 0
    skipped      = 0

    for i, arquivo in enumerate(arquivos_md):
        nome = os.path.basename(arquivo)

        if should_skip(nome, todos_arquivos):
            print(f"\n[{i+1}/{len(arquivos_md)}] SKIP (versão inferior): {nome}")
            skipped += 1
            continue

        print(f"\n[{i+1}/{len(arquivos_md)}] Processando: {nome}...")
        meta_arquivo = normalizar_metadados(nome)

        try:
            with open(arquivo, encoding="utf-8") as f:
                conteudo = f.read()

            blocos = chunkar_md(conteudo)

            if not blocos:
                print(f"   [WARN] Nenhum chunk gerado — verifique formatação de cabeçalhos (#).")
                continue

            inseridos = 0
            for bloco in blocos:
                disciplina  = bloco["disciplina"] or meta_arquivo["disciplina"]
                ano_escolar = bloco["ano_escolar"] or meta_arquivo["ano_escolar"]
                periodo     = bloco["periodo"]
                texto       = bloco["text"]

                print(f"   → Chunk: {disciplina} | {ano_escolar} | {periodo} ({len(texto)} chars)")

                embedding = gerar_embedding(openai_client, texto)
                if not embedding:
                    print(f"     [WARN] Embedding falhou — chunk ignorado.")
                    continue

                supabase.table("curriculos_mg").insert({
                    "content": texto,
                    "embedding": embedding,
                    "metadata": {
                        "disciplina": disciplina,
                        "ano_escolar": ano_escolar,
                        "periodo": periodo,
                        "source": nome,
                        "estado": "MG",
                        "nivel": meta_arquivo["nivel"],
                        "ano_base": 2026,
                    }
                }).execute()

                inseridos += 1
                time.sleep(0.5)  # Evita rate-limit

            total_chunks += inseridos
            total_files  += 1
            print(f"   [OK] {inseridos}/{len(blocos)} chunks inseridos.")

        except Exception as e:
            print(f"   [ERROR] {nome}: {e}")

    print(f"\n{'─'*60}")
    print(f"[CONCLUÍDO] {total_files} arquivos | {total_chunks} vetores | {skipped} ignorados (duplicatas)")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Ingestão de Currículos MG → Supabase (DeepSeek)")
    parser.add_argument("--truncate", action="store_true", help="Limpa a tabela antes de inserir")
    args = parser.parse_args()
    processar_arquivos(should_truncate=args.truncate)
