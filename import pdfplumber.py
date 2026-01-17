import pdfplumber
import json
import re
import os

def processar_plano_mg(caminho_pdf):
    # Verifica se o arquivo realmente existe antes de começar
    if not os.path.exists(caminho_pdf):
        print(f"❌ Erro: O arquivo não foi encontrado em: {caminho_pdf}")
        return

    dados_finais = []
    disciplina_atual = "Não Identificada"
    bimestre_atual = "Não Identificado"
    
    print(f"📄 Analisando arquivo em: {caminho_pdf}")
    
    with pdfplumber.open(caminho_pdf) as pdf:
        for i, pagina in enumerate(pdf.pages):
            texto_pag = pagina.extract_text()
            
            # Identifica Disciplina
            match_disc = re.search(r"COMPONENTE CURRICULAR:\s+(.*)", texto_pag)
            if match_disc:
                disciplina_atual = match_disc.group(1).strip()
            
            # Identifica Bimestre
            match_bim = re.search(r"(\dº\s?BIMESTRE)", texto_pag)
            if match_bim:
                bimestre_atual = match_bim.group(1).strip()

            tabela = pagina.extract_table()
            
            if tabela:
                for linha in tabela:
                    # Filtra linhas vazias ou cabeçalhos de tabela
                    if not linha or not any(linha) or "UNIDADE" in str(linha[0]).upper():
                        continue
                    
                    # Normaliza o tamanho da linha para evitar erros de índice
                    # Algumas páginas podem ter 4 ou 5 colunas dependendo da formatação
                    registro = {
                        "ano": "2025",
                        "serie": "1º Ano - Ensino Médio",
                        "disciplina": disciplina_atual,
                        "bimestre": bimestre_atual,
                        "unidade_tematica": str(linha[0]).replace('\n', ' ') if len(linha) > 0 else "",
                        "habilidade": str(linha[1]).replace('\n', ' ') if len(linha) > 1 else "",
                        "objeto_conhecimento": str(linha[2]).replace('\n', ' ') if len(linha) > 2 else "",
                        "conteudos_relacionados": str(linha[3]).replace('\n', ' ') if len(linha) > 3 else ""
                    }
                    dados_finais.append(registro)
            
            if (i + 1) % 5 == 0: # Feedback a cada 5 páginas
                print(f"⏳ Processadas {i+1} páginas...")

    # Salva o JSON na mesma pasta do script
    nome_saida = 'plano_curso_mg_estruturado.json'
    with open(nome_saida, 'w', encoding='utf-8') as f:
        json.dump(dados_finais, f, ensure_ascii=False, indent=4)
    
    print(f"\n🏆 Finalizado! {len(dados_finais)} registros salvos em '{nome_saida}'.")

if __name__ == "__main__":
    # CAMINHO COMPLETO DO SEU PDF
    caminho_real = r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\EM_1ANO_CH_PLANO_DE_CURSO_2025.pdf"
    processar_plano_mg(caminho_real)