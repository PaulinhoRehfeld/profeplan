import pdfplumber
import json
import re
import os

# --- CONFIGURAÇÕES ---
PASTA_PDFS = r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG"
NOME_SAIDA = "plano_linguagens_auditado_v2.json"

def localizar_pdf():
    for f in os.listdir(PASTA_PDFS):
        if "LINGUAGEM" in f.upper() and "1ANO" in f.upper() and f.lower().endswith(".pdf"):
            return os.path.join(PASTA_PDFS, f)
    return None

def limpar(texto):
    if not texto: return ""
    return re.sub(r'\s+', ' ', str(texto)).strip()

def extrair_dados_auditados():
    caminho_pdf = localizar_pdf()
    if not caminho_pdf: return []

    print(f"🚀 Refazendo extração com limpeza de cabeçalho: {os.path.basename(caminho_pdf)}")
    
    dados_finais = []
    # Dicionário para mapear e validar disciplinas reais
    disciplinas_validas = ["LÍNGUA PORTUGUESA", "ARTE", "EDUCAÇÃO FÍSICA", "LÍNGUA INGLESA"]
    
    contexto = {
        "area": "Linguagens e suas Tecnologias",
        "disciplina": "LÍNGUA PORTUGUESA", # Fallback
        "bimestre": ""
    }

    with pdfplumber.open(caminho_pdf) as pdf:
        for i, pagina in enumerate(pdf.pages):
            texto_topo = pagina.within_bbox((0, 0, pagina.width, 150)).extract_text() or ""
            
            # Busca Rigorosa pela Disciplina
            for d in disciplinas_validas:
                if d in texto_topo.upper():
                    contexto["disciplina"] = d
                    break
            
            # Busca Rigorosa pelo Bimestre
            bim_match = re.search(r"(\dº\s?(?:BIMESTRE|TRIMESTRE))", texto_topo, re.IGNORECASE)
            if bim_match: contexto["bimestre"] = bim_match.group(1)

            tabela = pagina.extract_table()
            if not tabela: continue

            for linha in tabela:
                if not linha or len(linha) < 2: continue
                
                # Ignora cabeçalhos internos da tabela
                primeira_celula = str(linha[0]).upper()
                if any(x in primeira_celula for x in ["UNIDADE", "PRÁTICAS", "COMPONENTE"]): continue
                if not linha[1]: continue # Se não tem habilidade, pula

                registro = {
                    "area": contexto["area"],
                    "disciplina": contexto["disciplina"],
                    "ano": "1º Ano",
                    "periodo": contexto["bimestre"],
                    "unidade_pratica": limpar(linha[0]),
                    "habilidade": limpar(linha[1]),
                    "objeto": limpar(linha[2]) if len(linha) > 2 else "",
                    "conteudos": limpar(linha[3]) if len(linha) > 3 else "",
                    "saeb": ""
                }

                # Nova Regex para SAEB: mais flexível para pegar (D1), (D 1), D1, D01
                full_text = f"{registro['habilidade']} {registro['conteudos']}"
                saeb_matches = re.findall(r"\(?(D\s?\d+)\)?", full_text)
                if saeb_matches:
                    registro["saeb"] = ", ".join(sorted(set([s.replace(" ", "") for s in saeb_matches])))

                dados_finais.append(registro)

    return dados_finais

if __name__ == "__main__":
    lista = extrair_dados_auditados()
    with open(NOME_SAIDA, 'w', encoding='utf-8') as f:
        json.dump(lista, f, ensure_ascii=False, indent=4)
    print(f"✅ Arquivo corrigido: {NOME_SAIDA}")