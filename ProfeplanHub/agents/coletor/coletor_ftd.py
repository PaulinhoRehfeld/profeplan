
import os
import re
import time
import argparse
import logging
from pathlib import Path
from dotenv import load_dotenv
from playwright.sync_api import sync_playwright

# Carregar configuração do ProfeplanHub
config_dir = Path(__file__).parent.parent.parent / "config"
load_dotenv(config_dir / ".env")

# Configuração de Logging
import sys
sys.stdout.reconfigure(encoding='utf-8')
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

# Configurações
BASE_URL = "https://pnld.ftd.com.br"
START_URL = "https://pnld.ftd.com.br/guia-digital/ensino-medio-2026/"

# Output relativo ao ProfeplanHub
hub_dir = Path(__file__).parent.parent.parent
OUTPUT_BASE_DIR = hub_dir / "data" / "raw_pdfs"

# Configurações do .env
DOWNLOAD_TIMEOUT = int(os.getenv("DOWNLOAD_TIMEOUT_MS", "30000"))
HEADLESS_DEFAULT = os.getenv("PLAYWRIGHT_HEADLESS", "false").lower() == "true"

def clean_filename(text):
    if not text: return "desconhecido"
    text = re.sub(r'[\\/*?:"<>|]', "", text)
    return text.upper().strip().replace(" ", "_")

def normalize_discipline(text):
    mapping = {
        "MATEMATICA": ["MATEMATICA", "MATEMÁTICA"],
        "LINGUA_PORTUGUESA": ["PORTUGUES", "PORTUGUÊS", "LÍNGUA PORTUGUESA", "LINGUA PORTUGUESA"],
        "HISTORIA": ["HISTORIA", "HISTÓRIA"],
        "GEOGRAFIA": ["GEOGRAFIA"],
        "BIOLOGIA": ["BIOLOGIA"],
        "FISICA": ["FISICA", "FÍSICA"],
        "QUIMICA": ["QUIMICA", "QUÍMICA"],
        "FILOSOFIA": ["FILOSOFIA"],
        "SOCIOLOGIA": ["SOCIOLOGIA"],
        "ARTE": ["ARTE"],
        "LINGUA_INGLESA": ["INGLES", "INGLÊS", "LINGUA INGLESA"],
        "LINGUA_ESPANHOLA": ["ESPANHOL", "LINGUA ESPANHOLA"],
        "EDUCACAO_FISICA": ["EDUCACAO FISICA", "EDUCAÇÃO FÍSICA"],
        "PROJETO_DE_VIDA": ["PROJETO DE VIDA"],
        "CIENCIAS_NATUREZA": ["CIENCIAS DA NATUREZA", "CIÊNCIAS DA NATUREZA"],
        "CIENCIAS_HUMANAS": ["CIENCIAS HUMANAS", "CIÊNCIAS HUMANAS"]
    }
    text_upper = text.upper()
    for disc_norm, keywords in mapping.items():
        for kw in keywords:
            if kw in text_upper:
                return disc_norm
    return "GERAL"

def determine_collection(text):
    text = text.upper()
    if "360" in text: return "360"
    if "POR TODA PARTE" in text: return "POR_TODA_PARTE"
    if "HORIZONTES" in text: return "HORIZONTES"
    if "ENTRELAC" in text: return "ENTRELACOS"
    if "PRISMA" in text: return "PRISMA"
    return "FTD"

def determine_year(text):
    text = text.upper()
    if "1º" in text or "1 ANO" in text or "PRIMEIRO" in text: return "1ANO"
    if "2º" in text or "2 ANO" in text or "SEGUNDO" in text: return "2ANO"
    if "3º" in text or "3 ANO" in text or "TERCEIRO" in text: return "3ANO"
    return "UNICO"

def discover_works(page):
    logger.info(f"Discovery Phase 1: Finding Categories at {BASE_URL}")
    page.goto(BASE_URL, wait_until="domcontentloaded")
    
    # 1. Find all "Ensino Médio" category links
    # excluding "EJA"
    category_links = page.evaluate("""() => {
        const anchors = Array.from(document.querySelectorAll('a'));
        return anchors
            .filter(a => {
                const text = a.innerText.toUpperCase();
                return text.includes('ENSINO MÉDIO') && !text.includes('EJA');
            })
            .map(a => a.href);
    }""")
    
    unique_categories = sorted(list(set(category_links)))
    logger.info(f"Categorias encontradas ({len(unique_categories)}):")
    for cat in unique_categories:
        logger.info(f" - {cat}")

    all_works = set()
    visited_urls = set()
    urls_to_scan = list(unique_categories)

    # We will scan the initial categories, and likely find more specific "sub-category" links
    # so we extend the list. We'll use a simple loop index to simulate a queue.
    i = 0
    # Limit recursion/expansion to avoid infinite loops, though distinct set helps
    # We might expect ~10-20 pages max.
    
    while i < len(urls_to_scan):
        url = urls_to_scan[i]
        i += 1
        
        if url in visited_urls:
            continue
        visited_urls.add(url)

        logger.info(f"Scanning ({i}/{len(urls_to_scan)}): {url}")
        
        try:
            page.goto(url, wait_until="domcontentloaded")
            time.sleep(2) 

            # 1. Scrape Books (Obras) on this page
            try:
                page.wait_for_selector("a[href*='/obras/']", timeout=2000)
            except:
                pass # expected if it's a menu page

            new_books = page.evaluate("""() => {
                return Array.from(document.querySelectorAll("a[href*='/obras/']"))
                    .map(a => a.href)
            }""")
            
            books_added = 0
            for b_url in new_books:
                if b_url not in all_works:
                    all_works.add(b_url)
                    books_added += 1
            
            if books_added > 0:
                logger.info(f"  + Encontradas {books_added} obras.")

            # 2. Scrape Sub-Links (Recursion)
            # Look for internal links that might be sub-collections, guides, etc.
            # Criteria: Contains "ENSINO", "MEDIO", "202", "COLECAO", "GUIA", "PROJETO"
            # Exclude: "EJA", "JOVENS", anchors
            sub_links = page.evaluate("""() => {
                return Array.from(document.querySelectorAll("a"))
                    .map(a => a.href)
                    .filter(href => {
                         if (!href.includes('ftd.com.br')) return false;
                         if (href.includes('#')) return false;
                         const h = href.toUpperCase();
                         
                         // Exclusions
                         if (h.includes('EJA') || h.includes('JOVENS-E-ADULTOS')) return false;
                         if (h.includes('INFANTIL') || h.includes('FUNDAMENTAL')) return false;
                         if (h.includes('ANOS-INICIAIS') || h.includes('ANOS-FINAIS')) return false;
                         
                         // Must resemble a content page for Ensino Medio
                         // 'MEDIO' is the strongest signal in the slug/url
                         if (h.includes('MEDIO')) {
                             return true;
                         }
                         
                         // Specific checks for "Coleção" or "Projetos" if they don't explicitly say Medio but are relevant?
                         // Usually "pnld-2026-ensino-medio-conheca-..." has 'MEDIO'.
                         // If we want to be safe, we just trust 'MEDIO'.
                         return false;
                    });
            }""")

            added_subs = 0
            for sl in sub_links:
                if sl not in visited_urls and sl not in urls_to_scan:
                    urls_to_scan.append(sl)
                    added_subs += 1
            
            if added_subs > 0:
                logger.info(f"  + Encontrados {added_subs} novos links para verificar.")

        except Exception as e:
            logger.error(f"Erro ao processar {url}: {e}")

    unique_links = sorted(list(all_works))
    logger.info(f"Total de {len(unique_links)} obras únicas encontradas após scan completo.")
    return unique_links

def scrape_and_download_page(page, url, dry_run=False):
    logger.info(f"Processando: {url}")
    try:
        page.goto(url, wait_until="domcontentloaded")
        time.sleep(2) # Wait for dynamic content
    except Exception as e:
        logger.error(f"Erro ao carregar {url}: {e}")
        return

    # Metadata extraction
    title = page.title()
    try:
        h1 = page.locator("h1").first.inner_text()
        if h1: title = h1
    except: pass
    
    # Context text (breadcrumbs + title)
    context_text = title.upper()
    try:
        bread = page.locator(".breadcrumb").first.inner_text()
        context_text += " " + bread.upper()
    except: pass

    disciplina = normalize_discipline(context_text)
    colecao = determine_collection(context_text)

    # Find download buttons
    # Strategy: Look for "Baixar" or "Manual" links
    # Then resolve properties
    
    # We'll use Playwright locators to find potential download links
    # Matches 'a' tag with text 'Baixar' or 'Manual' or href containing '.pdf'
    
    # Using evaluate to get elements is often easier for complex filtering
    items = page.evaluate("""() => {
        const results = [];
        const links = document.querySelectorAll("a");
        links.forEach(a => {
            const text = a.innerText.toUpperCase();
            const href = a.href;
            const isDownload = text.includes("BAIXAR") || text.includes("MANUAL DO PROFESSOR") || href.toLowerCase().includes(".pdf");
            
            if (isDownload && (href.includes("ftd.com.br") || href.includes("cloudinary"))) {
                 // Context Logic (Simple parent traversal)
                 let context = text;
                 let parent = a.parentElement;
                 for(let i=0; i<4; i++) {
                     if(parent) {
                        context += " " + parent.innerText.toUpperCase();
                        parent = parent.parentElement;
                     }
                 }
                 results.push({href: href, context: context});
            }
        });
        return results;
    }""")

    processed_urls = set()

    for item in items:
        dl_url = item['href']
        if dl_url in processed_urls: continue
        if dl_url.endswith("/"): continue
        if "termos-de-uso" in dl_url.lower(): continue
        
        # Determine Year
        ano = determine_year(item['context'])
        suffix = ""
        if "PARTE 1" in item['context'] or "VOLUME 1" in item['context']: suffix = "_V1"
        if "PARTE 2" in item['context'] or "VOLUME 2" in item['context']: suffix = "_V2"

        final_ano = ano + suffix
        filename = f"{disciplina}_FTD_{colecao}_{final_ano}.pdf"
        output_dir = os.path.join(OUTPUT_BASE_DIR, disciplina)
        filepath = os.path.join(output_dir, filename)

        if os.path.exists(filepath) and not dry_run:
            continue

        processed_urls.add(dl_url)
        
        if dry_run:
            logger.info(f"[DRY-RUN] Baixaria: {dl_url} -> {filepath}")
            continue

        # DOWNLOAD LOGIC
        # Handle Interstitial (Asset Share)
        logger.info(f"Iniciando download de {filename}...")
        
        try:
            # We open a NEW PAGE for the download to not lose the list context
            new_page = page.context.new_page()
            new_page.goto(dl_url, wait_until="domcontentloaded")
            
            # Check if it is a direct PDF (browser would try to view/download)
            # Or if it is the Asset Share page.
            
            # If it's Asset Share, we look for a download button
            # Class 'btn-download' or similar?
            # Or text 'Download'
            
            # Wait a bit to see if download starts automatically or page loads
            time.sleep(2)
            
            # If the page title is "Asset Share | Cloudinary", we need to click
            page_title = new_page.title()
            
            
            if "Asset Share" in page_title or "Cloudinary" in page_title or "cloudinary.com" in dl_url:
                logger.info(f"   Detectado Cloudinary (Title: {page_title}). Buscando botão...")
                try:
                    # Generic button finder
                    with new_page.expect_download(timeout=15000) as download_info:
                        # Try finding a button
                        btn = new_page.locator("button:has-text('Download')").first
                        if not btn.is_visible():
                            btn = new_page.locator("a:has-text('Download')").first
                        
                        if btn.is_visible():
                            logger.info("   Botão encontrado. Clicando...")
                            btn.click()
                        else:
                            logger.info("   Botão texto não encontrado. Tentando ícone SVG...")
                            new_page.locator("svg").first.click() # Risky but fallback
                            
                except Exception as e:
                    logger.warning(f"   Falha ao clicar no Asset Share: {e}")
                    new_page.close()
                    return # Stop for this file
            else:
                 # Direct download assumption
                 logger.info(f"   Tentando download direto (Title: {page_title})...")
                 new_page.close()
                 
                 dummy_page = page.context.new_page()
                 try:
                     with dummy_page.expect_download(timeout=30000) as download_info:
                         dummy_page.goto(dl_url)
                 except:
                     logger.error("   Falha no download direto.")
                     dummy_page.close()
                     return
                 
            # Handling the download object (Common for both if/else if succeeded)
            download = download_info.value
            os.makedirs(output_dir, exist_ok=True)
            download.save_as(filepath)
            logger.info(f"   Sucesso: {filepath}")
            
            if new_page and not new_page.is_closed(): new_page.close()
            try: dummy_page.close() 
            except: pass

        except Exception as e:
            logger.error(f"   Falha no download: {e}")
            try: new_page.close() 
            except: pass

def main():
    parser = argparse.ArgumentParser(description="Coletor FTD - Web scraper para livros PNLD FTD")
    parser.add_argument("--dry-run", action="store_true", help="Simular downloads sem baixar")
    parser.add_argument("--limit", type=int, default=0, help="Limitar número de livros")
    parser.add_argument("--headless", action="store_true", default=HEADLESS_DEFAULT,
                        help="Executar em modo headless (sem UI)")
    args = parser.parse_args()
    
    logger.info(f"Modo headless: {args.headless}")
    logger.info(f"Output: {OUTPUT_BASE_DIR}")

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=args.headless)
        context = browser.new_context(accept_downloads=True)
        page = context.new_page()

        links = discover_works(page)
        
        count = 0
        for link in links:
            if args.limit > 0 and count >= args.limit:
                break
            
            scrape_and_download_page(page, link, dry_run=args.dry_run)
            count += 1
        
        browser.close()

if __name__ == "__main__":
    main()
