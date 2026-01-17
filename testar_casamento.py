import google.generativeai as genai
from supabase import create_client

# --- CONFIGURAÇÕES ---
API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def buscar_casamento_pedagogico(tema_mg):
    print(f"🔍 PROFEPLAN cruzando dados para: {tema_mg}...")
    
    # Gera o vetor do tema do currículo de MG
    res = genai.embed_content(
        model="models/text-embedding-004",
        content=tema_mg,
        task_type="retrieval_query"
    )
    
    # Busca na tabela de questões do ENEM usando a coluna 'content'
    resposta = supabase.rpc('match_questions', {
        'query_embedding': res['embedding'],
        'match_threshold': 0.25,
        'match_count': 3
    }).execute()

    if resposta.data:
        print(f"\n🎯 SUCESSO! Encontrei {len(resposta.data)} questões do ENEM para esta aula:")
        for i, q in enumerate(resposta.data):
            # Usando os nomes reais das suas colunas: 'content' e 'metadata'
            texto_questao = q.get('content', 'Texto não encontrado')
            meta = q.get('metadata', {})
            bncc = meta.get('bncc') or meta.get('classificacao') or "Geral"
            
            print(f"\n--- Sugestão {i+1} (Similaridade: {round(q.get('similarity', 0)*100, 1)}%) ---")
            print(f"📌 Contexto BNCC: {bncc}")
            print(f"📝 Questão: {texto_questao[:350]}...") 
    else:
        print("❌ Nenhuma questão encontrada. Tente ajustar o tema.")

if __name__ == "__main__":
    # Testando com um tema real do Plano de MG que acabamos de subir
    buscar_casamento_pedagogico("Transformação das paisagens naturais e antrópicas e a interação humana com a natureza")