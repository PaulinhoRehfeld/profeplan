from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup
import time
import json

# Configura o navegador (Chrome)
options = webdriver.ChromeOptions()
# options.add_argument('--headless') # Descomente para rodar sem abrir a janela
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

url = "https://www.edocente.com.br/pnld/obra/leitor/do-seu-jeito-projetos-integradores-ciencias-humanas-e-sociais-aplicadas-pnld-ensino-medio-2026/?obraId=13776"

try:
    driver.get(url)
    time.sleep(5) # Espera o livro carregar

    # O PNLD Digital usa Tags como <article>, <section> ou <div class="page-content">
    # Vamos capturar o HTML da página atual
    html_da_pagina = driver.page_source
    sopa = BeautifulSoup(html_da_pagina, 'html.parser')

    # Busca o conteúdo textual (padrão PNLD costuma usar tags semânticas)
    conteudo = sopa.find_all(['h1', 'h2', 'h3', 'p', 'li'])
    
    livro_dados = []
    for item in conteudo:
        texto = item.get_text().strip()
        if texto:
            livro_dados.append({
                "tag": item.name,
                "texto": texto
            })

    # Salva num arquivo para usarmos depois no Supabase
    with open('conteudo_livro.json', 'w', encoding='utf-8') as f:
        json.dump(livro_dados, f, ensure_ascii=False, indent=4)

    print(f"✅ Sucesso! Capturados {len(livro_dados)} blocos de texto.")

finally:
    driver.quit()