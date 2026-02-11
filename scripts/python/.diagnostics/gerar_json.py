import pdfplumber
import json
import re
import os

# Caminhos configurados conforme seu computador
caminho_pdf = r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\EM_1ANO_CH_PLANO_DE_CURSO_2025.pdf"
arquivo_saida = "plano_curso_mg_estruturado.json"

def extrair():
    print(f"📄 Lendo PDF: {caminho_pdf}")
    dados = []
    disciplina = "Não Identificada"
    bimestre = "Não Identificado"

    with pdfplumber.open(caminho_pdf) as pdf:
        for i, pagina in enumerate(pdf.pages):
            texto = pagina.extract_text() or ""
            
            # Identifica Disciplina e Bimestre
            d = re.search(r"COMPONENTE CURRICULAR:\s+(.*)", texto)
            if d: disciplina = d.group(1).strip()
            
            b = re.search(r"(\dº\s?BIMESTRE)", texto)
            if b: bimestre = b.group(1).strip()

            tabela = pagina.extract_table()
            if tabela:
                for linha in tabela:
                    if not linha or not linha[0] or "UNIDADE" in str(linha[0]).upper():
                        continue
                    
                    dados.append({
                        "disciplina": disciplina,
                        "bimestre": bimestre,
                        "unidade_tematica": str(linha[0]).replace('\n', ' '),
                        "habilidade": str(linha[1]).replace('\n', ' ') if len(linha) > 1 else "",
                        "objeto_conhecimento": str(linha[2]).replace('\n', ' ') if len(linha) > 2 else "",
                        "conteudos_relacionados": str(linha[3]).replace('\n', ' ') if len(linha) > 3 else ""
                    })
            if (i+1) % 10 == 0: print(f"⏳ {i+1} páginas processadas...")

    with open(arquivo_saida, 'w', encoding='utf-8') as f:
        json.dump(dados, f, ensure_ascii=False, indent=4)
    
    print(f"✅ Sucesso! Arquivo criado em: {os.path.abspath(arquivo_saida)}")

if __name__ == "__main__":
    extrair()