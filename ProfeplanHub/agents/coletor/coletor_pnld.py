import os
import time
import json
import re
from playwright.sync_api import sync_playwright

# Configurações
PASTA_DOWNLOADS = "./dados/entrada_pdfs"
PASTA_PERFIL_CHROME = "./dados/chrome_profile"  # Nova pasta para salvar o perfil completo
ARQUIVO_MANIFESTO = "./dados/entrada_pdfs/manifesto_downloads.json"
URL_LISTAGEM = "https://www.edocente.com.br/pnld/segmento/ensino-medio/"

def limpar_nome_arquivo(texto):
    """Remove caracteres inválidos para nomes de arquivo"""
    try:
        if not texto: return "livro_sem_titulo"
        return re.sub(r'[\\/*?:"<>|]', "", texto).strip()
    except:
        return "livro_desconhecido"

def run():
    # Cria as pastas necessárias
    if not os.path.exists(PASTA_DOWNLOADS):
        os.makedirs(PASTA_DOWNLOADS)
    if not os.path.exists(PASTA_PERFIL_CHROME):
        os.makedirs(PASTA_PERFIL_CHROME)

    print("🤖 INICIANDO O AGENTE COLETOR...")
    print(f"📂 Usando perfil de navegador em: {PASTA_PERFIL_CHROME}")

    with sync_playwright() as p:
        # launch_persistent_context salva TUDO (cookies, cache, login) na pasta definida.
        browser = p.chromium.launch_persistent_context(
            user_data_dir=PASTA_PERFIL_CHROME,
            headless=False,
            accept_downloads=True,
            args=["--start-maximized"]
        )
        
        # Em contexto persistente, ele já abre uma página. Pegamos a primeira.
        page = browser.pages[0] if browser.pages else browser.new_page()

        # 1. TENTATIVA DE ACESSO DIRETO
        print("➡️ Acessando página de listagem...")
        try:
            page.goto(URL_LISTAGEM, timeout=60000, wait_until="domcontentloaded")
        except Exception as e:
            print(f"⚠️ Aviso inicial de carregamento: {e}")

        time.sleep(3)

        # 2. VERIFICAÇÃO DE LOGIN INTELIGENTE
        na_url_login = "login" in page.url
        
        # Verifica seletores de forma segura
        tem_botao_login = False
        try:
            if page.locator("a[href*='login']").count() > 0: tem_botao_login = True
            elif page.locator("button:has-text('Entrar')").count() > 0: tem_botao_login = True
        except: pass

        if na_url_login or tem_botao_login:
             print("🔒 Parece que você não está logado.")
             if not na_url_login:
                 print("➡️ Redirecionando para login...")
                 try:
                    page.goto("https://www.edocente.com.br/login")
                 except: pass # Se der erro de navegação aqui, provavelmente o usuario clicou
             
             # INTERVENÇÃO HUMANA
             print("\n" + "="*60)
             print("⚠️  AÇÃO NECESSÁRIA: FAÇA O LOGIN NO NAVEGADOR ABERTO.")
             print("O robô vai salvar essa sessão na pasta './dados/chrome_profile'.")
             print("Nas próximas vezes, você entrará direto!")
             input("✅ QUANDO ESTIVER LOGADO (vendo os livros), PRESSIONE [ENTER] AQUI...")
             print("="*60 + "\n")

        # 3. GARANTIA DE LOCALIZAÇÃO (Com tratamento de erro de navegação)
        print("🔍 Verificando localização...")
        if URL_LISTAGEM not in page.url:
            print(f"➡️ Indo para: {URL_LISTAGEM}")
            try:
                page.goto(URL_LISTAGEM, wait_until="domcontentloaded")
            except Exception as e:
                # Ignorar erros de "interrupted navigation" se, no fim, estivermos na página certa
                print(f"⚠️ Aviso: Navegação conflituosa ({e}). Verificando se deu certo...")
            
            time.sleep(3)

        # 4. VARREDURA DE LIVROS
        print("🔍 Buscando obras na página...")
        
        # Scroll inicial
        try:
            page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
            time.sleep(2)
        except: pass

        links_elementos = page.locator("a[href*='/pnld/obra/']").all()
        urls_obras = list(set([link.get_attribute("href") for link in links_elementos]))
        
        print(f"📚 Encontrados {len(urls_obras)} livros para processar.")
        
        registro_downloads = []

        # 5. LOOP DE DOWNLOAD
        for i, url_parcial in enumerate(urls_obras):
            full_url = url_parcial if url_parcial.startswith("http") else f"https://www.edocente.com.br{url_parcial}"
            
            print(f"Processando ({i+1}/{len(urls_obras)}): {full_url}")
            try:
                # Otimização de Navegação
                try:
                    page.goto(full_url, wait_until="domcontentloaded")
                except:
                    print("   ⚠️ Retry navigation...")
                    time.sleep(1)
                    page.goto(full_url, wait_until="domcontentloaded")
                
                # Tempo para iframes carregarem
                time.sleep(3)
                
                # Título para arquivo
                try:
                    titulo_raw = page.title().split("|")[0].strip()
                    if "e-docente" in titulo_raw.lower() or len(titulo_raw) < 3:
                        h1 = page.locator("h1").first.innerText()
                        if h1: titulo_raw = h1
                    
                    titulo = titulo_raw
                    nome_arquivo = limpar_nome_arquivo(titulo) + ".pdf"
                    caminho_final = os.path.join(PASTA_DOWNLOADS, nome_arquivo)
                except:
                    titulo = f"livro_{i}"
                    nome_arquivo = f"livro_{i}.pdf"
                    caminho_final = os.path.join(PASTA_DOWNLOADS, nome_arquivo)
                
                if os.path.exists(caminho_final):
                    # print(f"   Skipping (Já existe): {nome_arquivo}")
                    pass

                # Lógica de Download Aprimorada (MULTI-FRAME)
                try:
                    baixou = False
                    botao_clicado = None

                    # Procura em TODOS os frames (Principal + Iframes)
                    frames_para_buscar = [page.main_frame] + page.frames
                    
                    for frame in frames_para_buscar:
                        if baixou: break # Se já achou em um frame, para
                        
                        try:
                            # 1. Procura pelo Ícone de Download (Material Design) revelado pelo usuário
                            # <i class="icon notranslate" ...>download</i>
                            # Geralmente clicamos no pai dele (o botão) ou nele mesmo
                            
                            # Opção A: Texto 'download' exato
                            icone = frame.get_by_text("download", exact=True).locator("visible=true")
                             # Opção B: Classe específica + texto
                            if icone.count() == 0:
                                icone = frame.locator("i.icon:has-text('download')")
                            
                            if icone.count() > 0 and icone.first.is_visible():
                                print(f"   🎯 Ícone 'download' encontrado no frame: {frame.url}")
                                botao_clicado = icone.first
                            
                            # Fallback: Se não achar o ícone, tenta os botões de texto antigos
                            if not botao_clicado:
                                candidatos = [
                                    frame.get_by_text("Manual do Professor"),
                                    frame.get_by_role("link", name="PDF"),
                                    frame.locator("a[href$='.pdf']") 
                                ]
                                for loc in candidatos:
                                    if loc.count() > 0 and loc.first.is_visible():
                                        print(f"   🎯 Botão texto encontrado: {loc.first.text_content()}")
                                        botao_clicado = loc.first
                                        break
                            
                            if botao_clicado:
                                try:
                                    # Clica. Como pode ser um JS que gera o link, esperamos download
                                    with page.expect_download(timeout=10000) as download_info:
                                        botao_clicado.click(timeout=3000)
                                    
                                    download = download_info.value
                                    print(f"   ⬇️ Baixando: {download.suggested_filename}")
                                    download.save_as(caminho_final)
                                    print(f"   ✅ Salvo com sucesso")
                                    
                                    registro_downloads.append({
                                        "titulo": titulo,
                                        "arquivo_local": caminho_final,
                                        "url_origem": full_url,
                                        "data_coleta": time.strftime("%Y-%m-%d %H:%M:%S")
                                    })
                                    baixou = True
                                    break # Sai do loop de frames
                                    
                                except Exception as e_click:
                                     print(f"   ⚠️ Encontrou botão mas falhou download: {e_click}")
                                     # Se falhar o clique neste frame, tenta continuar buscando? 
                                     # Geralmente não, mas vamos deixar o loop rodar
                        except:
                            pass # Frame pode ter fechado ou security error
                    
                    if not baixou:
                        print("   ❌ Botão de download não encontrado em nenhum frame.")

                except Exception as e_down:
                     print(f"   ⚠️ Erro loop download: {e_down}")

            except Exception as e:
                print(f"   ⚠️ Erro crítico na página: {e}")
            
            time.sleep(1)

        # 6. ATUALIZA MANIFESTO
        if registro_downloads:
            lista_final = registro_downloads
            if os.path.exists(ARQUIVO_MANIFESTO):
                try:
                    with open(ARQUIVO_MANIFESTO, "r", encoding="utf-8") as fm:
                        antigos = json.load(fm)
                        lista_final = antigos + registro_downloads
                except:
                    pass

            with open(ARQUIVO_MANIFESTO, "w", encoding="utf-8") as f:
                json.dump(lista_final, f, indent=4, ensure_ascii=False)
            print(f"\n📦 Manifesto atualizado.")
        else:
             print("\n📦 Nada novo.")

        browser.close()

if __name__ == "__main__":
    run()
