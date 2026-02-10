
import os
import sys
from dotenv import load_dotenv
from rlm import RLM

# Importa as ferramentas criadas
import profeplan_tools

# Load environment variables
load_dotenv()

# Tenta carregar a chave também de referências cruzadas se não existir
if not os.getenv("GEMINI_API_KEY") and os.getenv("VITE_GEMINI_API_KEY"):
    os.environ["GEMINI_API_KEY"] = os.getenv("VITE_GEMINI_API_KEY")

class PedagogicalCoordinator:
    def __init__(self, model_name="gemini-2.0-flash"):
        self.system_prompt = """
Você é o Coordenador Pedagógico (Orquestrador) do sistema PROFEPLAN.
Sua missão é COORDENAR a validação e enriquecimento de planos de aula, buscando ativamente evidências em nossas bases de dados.

Você tem acesso a um ambiente Python onde a biblioteca `profeplan_tools` está disponível.
DENTRO DESTE AMBIENTE, você pode chamar as seguintes funções:
- `profeplan_tools.search_curriculum_mg(termo)`: Busca no Currículo de Minas Gerais.
- `profeplan_tools.search_enem(termo)`: Busca questões oficiais do ENEM.
- `profeplan_tools.search_bncc(codigo)`: Valida formatos de códigos BNCC.

SEU FLUXO DE TRABALHO:
1. Analise o plano de aula recebido.
2. Identifique termos chave, habilidades e códigos BNCC.
3. DECIDA quais buscas são necessárias para validar se o conteúdo é real e adequado.
4. EXECUTE código Python para chamar as ferramentas `profeplan_tools`.
5. Com base nos RETORNOS das ferramentas, emita seu parecer final.

Se o plano citar uma habilidade, BUSQUE ela no currículo de MG para ver se o texto bate.
Se o plano citar um tema (ex: "Revolução Francesa"), busque no ENEM para ver se há questões relevantes para sugerir.

Seu output final deve ser um relatório pedagógico rico, citando as evidências encontradas.
"""
        try:
            self.rlm = RLM(
                backend="gemini",
                backend_kwargs={"model_name": model_name},
                custom_system_prompt=self.system_prompt,
                verbose=True,
                environment="local" 
            )
            print(f"Coordenador iniciado com modelo: {model_name}")
        except Exception as e:
            print(f"Erro ao inicializar RLM: {e}")
            sys.exit(1)

    def coordenar_validacao(self, plano_conteudo):
        """
        Executa a coordenação e validação do plano.
        """
        prompt_usuario = f"""
Aqui está um Plano de Aula que preciso que você coordene a validação:

---
{plano_conteudo}
---

Utilize suas ferramentas (`profeplan_tools`) para verificar a veracidade das habilidades citadas (buscando no currículo de MG) e a relevância do tema (buscando questões no ENEM).
Cruze as informações. O que está no plano condiz com o currículo oficial de MG que você buscou?
"""
        try:
            resultado = self.rlm.completion(prompt_usuario)
            return resultado.response
        except Exception as e:
            return f"Erro durante a coordenação: {e}"

if __name__ == "__main__":
    # Exemplo de uso
    coordenador = PedagogicalCoordinator()
    
    # Exemplo de plano para validação
    plano_exemplo = """
    Tema: "Globalização e seus efeitos"
    Disciplina: Geografia
    Turma: 3º Ano Ensino Médio
    Habilidade BNCC citada: (EM13CHS201) Analisar e caracterizar as dinâmicas das populações...
    
    Objetivo: Entender como a globalização afeta a economia local.
    """
    
    print("\n--- Iniciando Coordenação de Teste ---\n")
    print("O Coordenador irá agora 'pensar' e usar as ferramentas para buscar dados em MG e ENEM...\n")
    
    veredito = coordenador.coordenar_validacao(plano_exemplo)
    
    print("\n--- Relatório Final do Coordenador ---\n")
    print(veredito)
