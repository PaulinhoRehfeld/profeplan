import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Credenciais ausentes.")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_integrity():
    print("--- VERIFICACAO DE INTEGRIDADE ---")
    
    # 1. Checar Física (Referência: 192 registros)
    res_fis = supabase.table("curriculos_mg").select("id", count="exact").ilike("metadata->>disciplina", "%Física%").execute()
    count_fis = res_fis.count
    
    # 2. Checar Português (Referência: 153 registros)
    res_port = supabase.table("curriculos_mg").select("id", count="exact").ilike("metadata->>disciplina", "%Língua Portuguesa%").execute()
    count_port = res_port.count
    
    # 3. Checar Total Geral (Referência: ~1000+)
    res_total = supabase.table("curriculos_mg").select("id", count="exact").execute()
    count_total = res_total.count
    
    print(f"FISICA: {count_fis} (Esperado: ~192)")
    print(f"PORTUGUES: {count_port} (Esperado: ~153)")
    print(f"TOTAL: {count_total}")
    
    if count_fis > 180 and count_port > 140:
        print("[STATUS] DADOS PRESERVADOS ✅")
    else:
        print("[STATUS] ALERTA DE PERDA DE DADOS ⚠️")

if __name__ == "__main__":
    check_integrity()
