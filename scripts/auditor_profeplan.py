
import os
import sys
from dotenv import load_dotenv
from rlm import RLM

# Load environment variables
load_dotenv()

# Tenta carregar a chave também de referências cruzadas se não existir
if not os.getenv("GEMINI_API_KEY") and os.getenv("VITE_GEMINI_API_KEY"):
    os.environ["GEMINI_API_KEY"] = os.getenv("VITE_GEMINI_API_KEY")

class PedagogicalAuditor:
    def __init__(self, model_name="gemini-2.0-flash"):
        self.system_prompt = """
Você é o Auditor Pedagógico Sênior (APS) do sistema PROFEPLAN.
Sua função NÃO é gerar conteúdo, mas sim AUDITAR rigorosamente o conteúdo gerado por outra IA.

Sua mentalidade:
1. Você é cético. Assuma que o plano gerado pode conter erros.
2. Você é preciso. O alinhamento com a BNCC deve ser exato.
3. Você protege o professor. Se um plano for ruim ou genérico, você deve REPROVAR e explicar o porquê.

Você receberá um JSON ou texto contendo um 'Plano de Aula Gerado'.
Sua tarefa é analisar este plano recursivamente, dividindo o trabalho em sub-tarefas para garantir qualidade máxima.

Seus Protocolos de Auditoria (execute-os através de sub-chamadas ou análise detalhada):

Sub-tarefa A: Validação da BNCC
- Extraia os códigos da BNCC citados no plano (ex: EF05MA01).
- Verifique se a descrição da habilidade no plano corresponde exatamente à descrição oficial da BNCC.
- Se houver divergência ou alucinação (inventar códigos), marque como ERRO CRÍTICO.
- Verifique se a atividade proposta realmente desenvolve essa habilidade.

Sub-tarefa B: Auditoria de Metodologia e Tempo
- Analise o 'Cronograma da Aula'.
- Some os tempos estimados de cada atividade. O total ultrapassa o tempo da aula (ex: 50 min)? Se sim, marque como ERRO DE VIABILIDADE.
- A metodologia é adequada para a faixa etária? (Ex: Não permitir textos longos e complexos para o 1º ano do fundamental).
- Os recursos solicitados são realistas para uma escola pública brasileira padrão?

Sub-tarefa C: O Veredito Final
Com base nas análises anteriores, gere um relatório de saída no seguinte formato ESTRITAMENTE:

STATUS: [APROVADO / APROVADO COM RESSALVAS / REPROVADO]
NÍVEL DE CONFIANÇA: (0 a 100%)
PROBLEMAS ENCONTRADOS:
[Lista de erros ou 'Nenhum']
SUGESTÃO DE CORREÇÃO:
[Como melhorar o que está ruim]
"""
        try:
            self.rlm = RLM(
                backend="gemini",
                backend_kwargs={"model_name": model_name},
                custom_system_prompt=self.system_prompt,
                verbose=True # Para ver o pensamento recursivo
            )
            print(f"Auditor iniciado com modelo: {model_name}")
        except Exception as e:
            print(f"Erro ao inicializar RLM: {e}")
            sys.exit(1)

    def auditar_plano(self, plano_conteudo):
        """
        Executa a auditoria do plano fornecido.
        """
        prompt_usuario = f"""
Analise o seguinte Plano de Aula gerado pelo PROFEPLAN:

---
{plano_conteudo}
---

Execute a auditoria completa conforme seus protocolos (BNCC, Metodologia, Tempo).
Seja rigoroso.
"""
        try:
            resultado = self.rlm.completion(prompt_usuario)
            return resultado.response
        except Exception as e:
            return f"Erro durante a auditoria: {e}"

if __name__ == "__main__":
    # Exemplo de uso
    auditor = PedagogicalAuditor()
    
    # Exemplo de plano (propositalmente com possíveis falhas para teste)
    plano_exemplo = """
    Tema: Introdução à Física Quântica
    Público: 1º Ano do Ensino Fundamental
    BNCC: EF01LP01 (Reconhecer que textos são lidos e escritos da esquerda para a direita)
    
    Atividades:
    1. (10 min) Leitura do artigo "Entanglement de Partículas".
    2. (30 min) Debate sobre o Gato de Schrödinger.
    3. (20 min) Recreio dirigido.
    
    Total de tempo: 60 minutos.
    """
    
    print("\n--- Iniciando Auditoria de Teste ---\n")
    veredito = auditor.auditar_plano(plano_exemplo)
    print("\n--- Veredito Final ---\n")
    print(veredito)