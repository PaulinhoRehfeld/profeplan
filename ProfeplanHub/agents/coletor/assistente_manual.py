import os
import time
import json
import re
import shutil
from playwright.sync_api import sync_playwright

# Configurações
PASTA_DESTINO = "./dados/entrada_pdfs"
PASTA_PERFIL_CHROME = "./dados/chrome_profile"
ARQUIVO_MANIFESTO = "./dados/entrada_pdfs/manifesto_downloads.json"
URL_LISTAGEM = "https://www.edocente.com.br/pnld/segmento/ensino-medio/"

# Pasta padrao de downloads do Windows (Onde o Chrome joga se não configurado)
# Tenta pegar a pasta de Downloads do usuario
PASTA_DOWNLOADS_PADRAO = os.path.join(os.path.expanduser("~"), "Downloads")

def limpar_nome_arquivo(texto):
    """Remove caracteres inválidos"""
    if not texto: return "sem_titulo"
    s = re.sub(r'[\\/*?:"<>|]', "", texto).strip()
    return s

def buscar_ultimo_arquivo(pasta):
    """Retorna o arquivo mais recente numa pasta"""
    arquivos = [os.path.join(pasta, f) for f in os.listdir(pasta) if f.endswith(".pdf")]
    if not arquivos: return None
    return max(arquivos, key=os.path.getmtime)

def run():
    print("🤖 INICIANDO ASSISTENTE SEMI-AUTOMATICO")
    print("---------------------------------------------------------")
    print("FUNCIONAMENTO:")
    print("1. O Robô abre a página do livro.")
    print("2. VOCÊ clica no botão de baixar.")
    print("3. O Robô detecta o arquivo novo, renomeia e vai para o próximo.")
    print("---------------------------------------------------------")

    if not os.path.exists(PASTA_DESTINO):
        os.makedirs(PASTA_DESTINO)
    
    # Lista arquivos atuais na pasta de Downloads para ignorar
    arquivos_iniciais = set(os.listdir(PASTA_DOWNLOADS_PADRAO))

    with sync_playwright() as p:
        browser = p.chromium.launch_persistent_context(
            user_data_dir=PASTA_PERFIL_CHROME,
            headless=False,
            # Importante: NÃO define downloads path aqui para cair no padrão do user onde ele vê fácil
            # mas vamos tentar monitorar a pasta padrao.
            accept_downloads=True, 
            args=["--start-maximized"]
        )
        page = browser.pages[0] if browser.pages else browser.new_page()

        # 1. Navega para listagem
        print("➡️ Indo para listagem...")
        page.goto(URL_LISTAGEM)
        
        # input("Pressione ENTER se já estiver vendo a lista de livros...")
        time.sleep(3)

        # 2. Coleta Links
        print("🔍 Coletando links dos livros...")
        
        # Scroll
        page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
        time.sleep(2)
        
        links = page.locator("a[href*='/pnld/obra/']").all()
        urls = list(set([l.get_attribute("href") for l in links]))
        print(f"📚 {len(urls)} livros encontrados.")

        registro = []

        # 3. Loop Interativo
        for i, url_parcial in enumerate(urls):
            full_url = url_parcial if url_parcial.startswith("http") else f"https://www.edocente.com.br{url_parcial}"
            
            # Título provável
            try:
                page.goto(full_url)
                # Tenta pegar titulo limpo
                titulo = "livro_desconhecido"
                try:
                    h1 = page.locator("h1").first.inner_text()
                    titulo = h1
                except:
                    titulo = page.title().split("|")[0].strip()
                
                nome_final = limpar_nome_arquivo(titulo) + ".pdf"
                caminho_final = os.path.join(PASTA_DESTINO, nome_final)
                
                if os.path.exists(caminho_final):
                    # print(f"Skipping: {nome_final}")
                    continue

                print(f"\n📕 ({i+1}/{len(urls)}) ABERTO: {titulo}")
                print(f"👉 AÇÃO: Clique no download desse livro agora!")
                
                # Monitoramento de arquivo
                tempo_espera = 0
                arquivo_detectado = None
                
                while tempo_espera < 60: # Espera até 60s por um clique/download
                    time.sleep(1)
                    tempo_espera += 1
                    
                    # Verifica se surgiu algo novo na main downloads ou na pasta do script se configurado
                    # Como usamos persistent context sem definir downloadPath especifico, 
                    # ele joga na pasta padrao do chrome do perfil.
                    # Mas no launch_persistent_context, se accept_downloads=True, as vezes ele pede path.
                    # Vamos assumir que o "evento de download" do playwright captura.
                    
                    # Melhor: Usar o evento de download do playwright mesmo manual, se funcionar.
                    # Se o site abre aba nova, o evento pode nao vir.
                    # Vamos monitorar a pasta padrao de downloads do Windows.
                    
                    arquivos_agora = set(os.listdir(PASTA_DOWNLOADS_PADRAO))
                    novos = arquivos_agora - arquivos_iniciais
                    
                    candidato = None
                    # Filtra pdfs
                    for n in novos:
                        if n.endswith(".pdf") or n.endswith(".crdownload"):
                            candidato = n
                            break
                    
                    if candidato:
                        # Se ainda for .crdownload, espera
                        if candidato.endswith(".crdownload"):
                            print(".", end="", flush=True)
                            continue
                        
                        # Arquivo pronto!
                        print(f"\n✅ DETECTADO: {candidato}")
                        caminho_origem = os.path.join(PASTA_DOWNLOADS_PADRAO, candidato)
                        
                        # Move e renomeia
                        # Espera estabilizar
                        time.sleep(1)
                        try:
                            shutil.move(caminho_origem, caminho_final)
                            print(f"📦 Movido para: {nome_final}")
                            arquivo_detectado = caminho_final
                            
                            # Atualiza lista de ignorados
                            arquivos_iniciais = set(os.listdir(PASTA_DOWNLOADS_PADRAO))
                            break
                        except Exception as e_move:
                            print(f"Erro ao mover: {e_move}")
                
                if not arquivo_detectado:
                    print("\n⏩ Timeout (nenhum download detectado). Pulando para próximo.")
                    # Opcional: Perguntar se quer continuar
                else:
                    registro.append({"titulo": titulo, "arquivo": caminho_final, "url": full_url})

            except Exception as e:
                print(f"Erro: {e}")

    print("FIM.")
    
if __name__ == "__main__":
    run()
