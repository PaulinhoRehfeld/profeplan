
import json
import os
import re

# Caminhos absolutos ou relativos para os arquivos de dados
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CURRICULO_MG_PATH = os.path.join(BASE_DIR, "plano_curso_mg_estruturado.json")
ENEM_PATH = os.path.join(BASE_DIR, "enem_questions_export.md")

def search_curriculum_mg(term, limit=5):
    """
    Busca termos no currículo estruturado de Minas Gerais.
    Retorna uma lista de itens encontrados.
    """
    print(f"[TOOL] Buscando no Currículo MG por: '{term}'")
    results = []
    
    if not os.path.exists(CURRICULO_MG_PATH):
        return [f"ERRO: Arquivo de currículo não encontrado em {CURRICULO_MG_PATH}"]
    
    try:
        with open(CURRICULO_MG_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        term_lower = term.lower()
        
        for item in data:
            # Concatena campos principais para busca
            content = (
                f"{item.get('disciplina', '')} "
                f"{item.get('habilidade', '')} "
                f"{item.get('objeto_conhecimento', '')} "
                f"{item.get('conteudos_relacionados', '')}"
            ).lower()
            
            if term_lower in content:
                results.append({
                    "disciplina": item.get('disciplina'),
                    "bimestre": item.get('bimestre'),
                    "habilidade": item.get('habilidade'),
                    "objeto": item.get('objeto_conhecimento')
                })
                if len(results) >= limit:
                    break
                    
        if not results:
            return ["Nenhum item encontrado no currículo MG para o termo pesquisado."]
            
        return results
        
    except Exception as e:
        return [f"Erro ao ler currículo MG: {str(e)}"]

def search_enem(term, limit=3):
    """
    Busca questões do ENEM no arquivo markdown exportado.
    Retorna trechos das questões encontradas.
    """
    print(f"[TOOL] Buscando no Banco ENEM por: '{term}'")
    results = []
    
    if not os.path.exists(ENEM_PATH):
        return [f"ERRO: Arquivo ENEM não encontrado em {ENEM_PATH}"]
        
    try:
        term_lower = term.lower()
        current_question = []
        in_question = False
        found_questions = 0
        
        with open(ENEM_PATH, 'r', encoding='utf-8') as f:
            for line in f:
                if line.startswith("# Synced Question"):
                    # Se estavamos lendo uma questão e ela tinha o termo, salva
                    if in_question and any(term_lower in l.lower() for l in current_question):
                        results.append("".join(current_question[:20])) # Retorna primeiros 20 linhas da questão
                        found_questions += 1
                        if found_questions >= limit:
                            break
                    
                    # Começa nova questão
                    current_question = [line]
                    in_question = True
                elif line.startswith("==="):
                    # Fim da questão anterior
                    if in_question and any(term_lower in l.lower() for l in current_question):
                        results.append("".join(current_question[:20]))
                        found_questions += 1
                        if found_questions >= limit:
                            break
                    in_question = False
                    current_question = []
                elif in_question:
                    current_question.append(line)
                    
        return results if results else ["Nenhuma questão do ENEM encontrada com esse termo."]
        
    except Exception as e:
        return [f"Erro ao buscar no ENEM: {str(e)}"]

def search_bncc(code):
    """
    Simulação de busca na BNCC. Retorna se o código parece válido.
    """
    print(f"[TOOL] Validando código BNCC: '{code}'")
    # Padrão básico BNCC: EF/EM + 2 dígitos + Sigla + 2 dígitos
    # Ex: EF05MA01, EM13CHS101
    pattern = r'^(EI|EF|EM)\d{2}[A-Z]{2,4}\d{2,4}[A-Z]?$'
    
    if re.match(pattern, code):
        return f"Código {code} possui formato VÁLIDO de acordo com a BNCC."
    else:
        return f"ALERTA: Código {code} NÃO segue o padrão padrão da BNCC (Ex: EF05MA01)."

if __name__ == "__main__":
    # Teste rápido
    print(search_curriculum_mg("Revolução Industrial", limit=1))
    print(search_enem("industrial", limit=1))
    print(search_bncc("EF09HI01"))
