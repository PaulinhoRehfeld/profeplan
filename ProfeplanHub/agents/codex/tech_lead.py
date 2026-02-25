import os
import sys
from rlm import RLM
from dotenv import load_dotenv

# Carregar variáveis de ambiente (.env) se existirem
load_dotenv()

# System Prompt Definido pelo Usuário (Tech Lead)
SYSTEM_PROMPT = """
VOCÊ É: O Tech Lead Sênior (Arquiteto de Software) deste projeto.
SUA MISSÃO: Gerenciar a evolução do código sem quebrar o que já foi feito.

SEUS PODERES (USE VIA CÓDIGO):
1. Você PODE e DEVE ler qualquer arquivo .py, .sql ou .json da pasta atual antes de propor mudanças.
2. Você JAMAIS deve supor o nome de uma variável ou tabela. Verifique no arquivo de origem.
3. Você tem acesso a um ambiente Python local onde pode executar código para listar arquivos, ler conteúdo e ESCREVER arquivos.

PROTOCOLO DE ATUAÇÃO (RECURSIVO):
1. Recebeu uma tarefa? -> Liste os arquivos do projeto para entender a estrutura.
2. Identifique quais arquivos são relevantes para a arquitetura (scripts, requirements, pastas).
3. LEIA esses arquivos para carregar o contexto atual.
4. CRIE (escreva via código python) o arquivo ARCHITECTURE.md descrevendo:
   - Estrutura de pastas (inputs, outputs, scripts)
   - Fluxo de dados (PDF -> MD) e convenções (ignorar 3 páginas)
   - Ferramentas utilizadas (pymupdf4llm)
   - Regras para futuras implementações.

SEU OBJETIVO: Deixar o arquivo ARCHITECTURE.md salvo no disco.
"""

def main():
    print(">>> Iniciando RLM Tech Lead para análise arquitetural...")

    # Recuperar API KEY do ambiente (definida via .env ou export)
    # Usuário forneceu API_KEY_GOOGLE, mas rlm/gemini espera GEMINI_API_KEY ou api_key param.
    api_key = os.getenv("API_KEY_GOOGLE")
    if not api_key:
       # Fallback para o nome padrão se o usuário mudar de ideia
       api_key = os.getenv("GEMINI_API_KEY")

    if not api_key:
        print("[AVISO] API Key não encontrada nas variáveis de ambiente. Tentando argumentos hardcoded se necessário ou falhando.")

    try:
        # Inicializa o agente RLM usando Backend Google (Gemini)
        agent = RLM(
            backend="gemini",
            backend_kwargs={
                "api_key": api_key,
                "model_name": "gemini-2.0-flash" 
            },
            custom_system_prompt=SYSTEM_PROMPT,
            environment="local",
            verbose=True
        )

        task = "Analise a estrutura atual do projeto e crie o arquivo ARCHITECTURE.md com as regras e padrões."
        
        print(f">>> Tarefa: {task}")
        result = agent.completion(task)
        
        print(">>> Concluído. Resposta do agente:")
        print(result.response)

    except Exception as e:
        print(f"\n[ERRO] Falha ao executar o RLM: {e}")
        try:
            print("\n>>> Tentando listar modelos disponíveis...")
            from google import genai
            client = genai.Client(api_key=api_key)
            # Listar apenas alguns para não poluir demais
            for m in client.models.list(config={"page_size": 10}):
                print(f" - {m.name}")
        except Exception as list_err:
             print(f"Falha ao listar modelos: {list_err}")
             
        sys.exit(1)

if __name__ == "__main__":
    main()
