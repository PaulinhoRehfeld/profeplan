import google.generativeai as genai
from supabase import create_client
import json
import os
import argparse
import re
import unicodedata

# --- CONFIGURAÇÕES ---
API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def buscar_curriculo(disciplina, periodo):
    print(f"🔍 Buscando diretrizes: {disciplina} | {periodo}")
    per_num = re.search(r'(\d+)', periodo).group(1) if re.search(r'(\d+)', periodo) else periodo

    try:
        # Busca direta no banco para evitar limites de fetch local
        # Tenta em metadata->disciplina OU na coluna disciplina
        res = supabase.table("curriculos_mg").select("*") \
            .or_(f"disciplina.ilike.%{disciplina}%,metadata->>disciplina.ilike.%{disciplina}%") \
            .limit(10).execute()
        
        matches = res.data
        if not matches:
             print(f"⚠️ Nenhuma correspondência encontrada para '{disciplina}'.")
        
        return matches[:3]
    except Exception as e:
        print(f"⚠️ Erro currículo: {e}")
        return []

def gerar_planejamento(disciplina, ano, trimestre):
    print(f"\n🚀 GERADOR CODEX INICIADO: {disciplina} - {ano}\n")
    
    itens = buscar_curriculo(disciplina, trimestre)
    
    if not itens:
        print("❌ CRÍTICO: Nenhum dado curricular encontrado.")
        return

    for i, item in enumerate(itens):
        meta = item.get('metadata') or {}
        hab = item.get('habilidade') or meta.get('habilidade', '')
        obj = item.get('objeto_conhecimento') or meta.get('objeto_conhecimento', '')
        cod = item.get('codigo_habilidade') or meta.get('codigo_habilidade', 'Geral')

        # Se os campos principais estiverem vazios, tenta usar o 'content' (se existir)
        if not hab and not obj:
            content = item.get('content') or ""
            hab = content[:200]
            obj = "Tópico Integrado"

        print(f"📌 [{i+1}] Processando: {cod}")

        # Busca LIVRO Codex
        emb_livro = genai.embed_content(
            model="models/gemini-embedding-001",
            content=f"{disciplina} {obj} {hab}", 
            task_type="retrieval_query",
            output_dimensionality=768
        )
        
        refs = ""
        try:
            res_livro = supabase.rpc("search_pnld_content", {
                "query_embedding": emb_livro['embedding'],
                "match_threshold": 0.1, # Threshold agressivo para garantir encontro
                "match_count": 3,
                "filter_disciplina": disciplina,
                "filter_livro_titulo": None
            }).execute()
            
            if res_livro.data:
                for r in res_livro.data:
                    rm = r.get('metadata') or {}
                    refs += f"\n📖 LIVRO: {rm.get('livro_titulo')} | PÁG: {rm.get('pagina')}\nCONTEÚDO: {r.get('content')[:400]}...\n"
            else:
                refs = "\n⚠️ NADA ENCONTRADO NO LIVRO PARA ESTE TÓPICO."
        except Exception as e:
            refs = f"\n⚠️ ERRO NA BUSCA DO LIVRO: {e}"

        # Geração Final
        model = genai.GenerativeModel('gemini-2.0-flash')
        prompt = f"""
        Role: Mentor Pedagógico de MG.
        Contexto: BNCC/CRMG + Livro Didático.
        
        DISCIPLINA: {disciplina}
        HABILIDADE: {hab} ({cod})
        OBJETO: {obj}
        REFERÊNCIAS CODEX: {refs}
        
        TAREFA: Gere um Plano de Aula integrado. Mencione as páginas do livro encontradas pelo Codex.
        Responda em Markdown.
        """
        
        try:
            resp = model.generate_content(prompt)
            print("\n" + "="*60)
            print(resp.text)
            print("="*60 + "\n")
        except Exception as e:
            print(f"❌ Erro IA: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--disciplina", default="Educação Digital")
    parser.add_argument("--ano", default="1º Ano")
    parser.add_argument("--trimestre", default="1º Trimestre")
    args = parser.parse_args()
    gerar_planejamento(args.disciplina, args.ano, args.trimestre)
