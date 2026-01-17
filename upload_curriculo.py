import json
import os
from supabase import create_client, Client

# --- SUAS CREDENCIAIS ---
# Chave Google (Geralmente usada para gerar textos/embeddings, se necessário no futuro)
API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"

# Credenciais do Banco de Dados Supabase
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

# Nome do arquivo JSON que você gerou com o currículo
ARQUIVO_JSON = "curriculo_mg_completo.json"

# --- INICIALIZAÇÃO DO CLIENTE ---
print("🔌 Conectando ao Supabase...")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def upload_data():
    # Verifica se o arquivo existe antes de tentar abrir
    if not os.path.exists(ARQUIVO_JSON):
        print(f"❌ Erro: O arquivo '{ARQUIVO_JSON}' não foi encontrado na pasta.")
        return

    print(f"⏳ Lendo o arquivo {ARQUIVO_JSON}...")
    
    try:
        with open(ARQUIVO_JSON, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        total_items = len(data)
        print(f"✅ Arquivo lido! Total de itens para enviar: {total_items}")
        
        # Envia em lotes de 50 para evitar timeout ou erro de tamanho
        batch_size = 50
        
        for i in range(0, total_items, batch_size):
            batch = data[i:i + batch_size]
            
            # Tenta enviar o lote atual
            try:
                response = supabase.table("curriculum_mg").insert(batch).execute()
                print(f"🚀 Progresso: {min(i + batch_size, total_items)}/{total_items} itens enviados...")
            except Exception as e_batch:
                print(f"⚠️ Erro ao enviar lote {i}: {e_batch}")
                # Opcional: break para parar se der erro, ou continue para tentar o próximo

        print("\n🏁 Upload concluído com sucesso!")
        print("Agora vá no painel do Supabase e confira a tabela 'curriculum_mg'.")

    except Exception as e:
        print(f"❌ Erro fatal: {e}")

if __name__ == "__main__":
    # Instale a biblioteca antes de rodar: pip install supabase
    upload_data()