
import os
import re
import time
import argparse
import logging
import sys
from pathlib import Path
from dotenv import load_dotenv
from playwright.sync_api import sync_playwright

# Carregar configuração do ProfeplanHub
config_dir = Path(__file__).parent.parent.parent / "config"
load_dotenv(config_dir / ".env")

# Configuração de Logging
sys.stdout.reconfigure(encoding='utf-8')
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

# Configurações
START_URLS = [
    "https://moderna.com.br/escola-publica/pnld/ensino-medio/obras-didaticas/",
    "https://moderna.com.br/escola-publica/pnld/colecao/",
    "https://moderna.com.br/escola-publica/pnld/ensino-medio/"
]
OUTPUT_BASE_DIR = "pnld"

def clean_filename(text):
    if not text: return "desconhecido"
    text = re.sub(r'[\\/*?:"<>|]', "", text)
    return text.upper().strip().replace(" ", "_")

def normalize_discipline(text):
    mapping = {
        "MATEMATICA": ["MATEMATICA", "MATEMÁTICA", "MATEMTICA"],
        "LINGUA_PORTUGUESA": ["PORTUGUES", "PORTUGUÊS", "LÍNGUA PORTUGUESA", "LINGUA PORTUGUESA", "LINGUAGENS"],
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
        "CIENCIAS_NATUREZA": ["CIENCIAS DA NATUREZA", "CIÊNCIAS DA NATUREZA", "CIENCIAS_NATUREZA"],
        "CIENCIAS_HUMANAS": ["CIENCIAS HUMANAS", "CIÊNCIAS HUMANAS", "CIENCIAS_HUMANAS"]
    }
    text_upper = text.upper()
    for disc_norm, keywords in mapping.items():
        for kw in keywords:
            if kw in text_upper:
                return disc_norm
    return "GERAL"

def determine_collection(text):
    text = text.upper()
    if "PLUS" in text: return "PLUS"
    if "EM AÇÃO" in text or "EM ACAO" in text: return "EM_ACAO"
    if "SUPERAÇÃO" in text or "SUPERACAO" in text: return "SUPERACAO"
    if "PROJETOS" in text: return "PROJETOS"
    if "AMIGOS" in text: return "AMIGOS"
    return "MODERNA"

def determine_year(text, url=""):
    text = text.upper()
    url = url.upper()
    
    # Check text first
    if "1º" in text or "1 ANO" in text or "PRIMEIRO" in text or "VOLUME 1" in text or "VOL. 1" in text: return "1ANO"
    if "2º" in text or "2 ANO" in text or "SEGUNDO" in text or "VOLUME 2" in text or "VOL. 2" in text: return "2ANO"
    if "3º" in text or "3 ANO" in text or "TERCEIRO" in text or "VOLUME 3" in text or "VOL. 3" in text: return "3ANO"
    
    # Check URL patterns (e.g. -1-1.pdf, -2-1.pdf)
    # Common FTD/Moderna pattern: name-1.pdf or name-1-1.pdf
    if re.search(r'[-_]1[-_]1\.PDF', url) or re.search(r'[-_]1\.PDF', url): return "1ANO"
    if re.search(r'[-_]2[-_]1\.PDF', url) or re.search(r'[-_]2\.PDF', url): return "2ANO"
    if re.search(r'[-_]3[-_]1\.PDF', url) or re.search(r'[-_]3\.PDF', url): return "3ANO"
    
    return "UNICO"

def discover_works(page):
    all_hrefs = []
    
    for url in START_URLS:
        logger.info(f"Discovery: {url}")
        try:
            page.goto(url, wait_until="domcontentloaded")
            # Wait for any links
            try:
                page.wait_for_selector("a[href*='/pnld/']", timeout=5000)
            except:
                logger.warning(f"Timeout waiting for links on {url}")
            
            # Extract links
            hrefs = page.evaluate("""() => {
                return Array.from(document.querySelectorAll("a[href*='/pnld/']"))
                    .map(a => a.href)
            }""")
            all_hrefs.extend(hrefs)
            
        except Exception as e:
            logger.error(f"Failed to discover on {url}: {e}")

    # Deduplicate
    unique_links = list(set(all_hrefs))
    book_links = []
    
    for l in unique_links:
        # Check standard path depth
        parts = l.split("/")
        # https://moderna.com.br/escola-publica/pnld/matematica/moderna-plus-matematica/
        # https://moderna.com.br/escola-publica/pnld/colecao/lingua-inglesa-moderna-em-acao/
        
        if "/pnld/" in l:
            # Exclude listing pages
            if "obras-didaticas" in l and l.endswith("obras-didaticas/"): continue
            # if "projetos-integradores" in l and l.endswith("projetos-integradores/"): continue
            if "colecao" in l and l.endswith("colecao/"): continue
            
            # Exclude other segments
            if "fundamental" in l: continue
            if "anos-iniciais" in l: continue
            if "anos-finais" in l: continue
            # if "eja" in l: continue # User requested /colecao/ which has EJA
            if "#" in l: continue # Exclude anchors
            
            # Avoid landing page
            if l.endswith("/ensino-medio") or l.endswith("/ensino-medio/"): continue
            
            # Exclude pagination
            # if "/page/" in l: continue

            # Additional safety: URL must have sufficient depth
            if len(parts) >= 6:
                book_links.append(l)
    
    logger.info(f"Encontradas {len(book_links)} obras potenciais (Filtradas).")
    return book_links

def scrape_and_download_page(page, url, dry_run=False):
    logger.info(f"Processando: {url}")
    try:
        page.goto(url, wait_until="domcontentloaded")
        
        try:
            # Scroll to bottom to trigger lazy loading
            page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
            time.sleep(2)
            
            # Wait for at least one PDF link which is what we want
            # ...
            page.wait_for_selector("a[href*='.pdf']", timeout=10000)
        except:
            logger.warning("Tempo limite de espera por links PDF excedido.")
        
        time.sleep(2) # Extra buffer for JS rendering
    except Exception as e:
        logger.error(f"Erro ao carregar {url}: {e}")
        return

    # Metadata extraction
    title = page.title()
    logger.info(f"   Título da página: {title}")
    
    try:
        h1 = page.locator("h1").first.inner_text()
        if h1: title = h1
    except: pass
    
    context_text = title.upper()
    
    disciplina = normalize_discipline(context_text)
    colecao = determine_collection(context_text)

    # Find download links (S3 + PDF)
    items = page.evaluate("""() => {
        const results = [];
        const links = document.querySelectorAll("a"); // Relaxed selector
        links.forEach(a => {
            const href = a.href;
            const text = a.innerText.toUpperCase();
            
            // Avoid generic footer docs
            if (text.includes("ETICA") || text.includes("FORNECEDOR") || text.includes("CONDUTA")) return;
            
            // Moderna S3 Bucket commonly used or just check for .pdf
            // Check specifically for book-related patterns in URL if possible, or just ignore known bad ones
            if (href.toLowerCase().includes(".pdf")) {
                 if (href.includes("codigo_etica") || href.includes("manual-codigo")) return;
                 
                 let context = text;
                 
                 // Add parent info for better Volume/Year detection
                 let parent = a.parentElement;
                 if (parent) {
                    context += " " + parent.innerText.toUpperCase();
                    if (parent.previousElementSibling && parent.previousElementSibling.tagName.startsWith('H')) {
                        context += " " + parent.previousElementSibling.innerText.toUpperCase();
                    }
                 }
                 
                 results.push({href: href, context: context});
            }
        });
        return results;
    }""")

    # Debug: Log all found links count
    logger.info(f"   Links totais encontrados via 'a': {len(items)}")
    if len(items) == 0:
         logger.info("   Nenhum link PDF encontrado via 'a'.")

    processed_urls = set()

    for item in items:
        dl_url = item['href']
        # Logger debug first 5 links
        if len(processed_urls) < 5:
            logger.info(f"   Link encontrado: {dl_url} (PDF? {'pdf' in dl_url.lower()})")

        if dl_url in processed_urls: continue
        
        # Determine Year from link context
        ano = determine_year(item['context'], dl_url)
        
        filename = f"{disciplina}_MODERNA_{colecao}_{ano}.pdf"
        output_dir = os.path.join(OUTPUT_BASE_DIR, disciplina)
        filepath = os.path.join(output_dir, filename)

        if os.path.exists(filepath):
            # If same name exists, maybe append hash if different URL? 
            # For now, skip to avoid re-downloading
            continue

        processed_urls.add(dl_url)
        
        if dry_run:
            logger.info(f"[DRY-RUN] Baixaria: {dl_url} -> {filepath}")
            continue

        logger.info(f"Baixando: {filename}...")
        try:
            os.makedirs(output_dir, exist_ok=True)
            
            # Use Playwright download handler if it triggers a download event, 
            # OR requests if it opens in a new tab/direct link.
            # S3 links usually are direct. request.get might be faster and easier if no auth required.
            # But let's try consistency with Playwright first just in case of weird headers.
            
            # Actually, standard logic for direct links:
            with page.expect_download(timeout=60000) as download_info:
                # Trigger download. If it's a direct link to a PDF, 
                # we might need to click it via JS or navigation.
                # Attempt to click a link with this href
                
                # Setup specific locator
                safe_href = dl_url.replace('"', '\\"')
                # We can try navigating to it (which triggers download for PDFs usually if 'download' attribute is present or headers set)
                # Or invoke click. Finding the exact element again might be tricky if evaluate returned text.
                # Let's try navigating to the URL in a way that catches download
                
                # Hack: create a temporary link and click it? Or just goto.
                # goto might try to view it in PDF viewer.
                
                # Verify if we can find the element to click
                # It's safer to just Click if we can find it.
                loc = page.locator(f"a[href='{dl_url}']").first
                if loc.count() > 0:
                     loc.click()
                else:
                     # Fallback: Navigate
                     page.evaluate(f"window.location.href = '{dl_url}'")

            download = download_info.value
            download.save_as(filepath)
            logger.info(f"   Sucesso: {filepath}")

        except Exception as e:
            logger.error(f"   Falha no download: {e}")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--limit", type=int, default=0)
    args = parser.parse_args()

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        context = browser.new_context(accept_downloads=True)
        page = context.new_page()

        links = discover_works(page)
        # FORCE DEBUG LINK
        # links = ["https://moderna.com.br/escola-publica/pnld/matematica/moderna-plus-matematica/"]
        
        count = 0
        for link in links:
            if args.limit > 0 and count >= args.limit:
                break
            
            scrape_and_download_page(page, link, dry_run=args.dry_run)
            count += 1
        
        browser.close()

if __name__ == "__main__":
    main()
