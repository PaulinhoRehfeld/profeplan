import os
import hashlib
from datetime import datetime

# --- CONFIGURAÇÃO DA BLINDAGEM ---
# Extensões que compõem a "Alma" do PROFEPLAN
EXTENSOES_PERMITIDAS = {'.ts', '.tsx', '.py', '.sql', '.js', '.css', '.html', '.json', '.md'}

# Pastas que NÃO entram no registro (Lixo ou Terceiros)
PASTAS_IGNORADAS = {
    'node_modules', '.git', '.vscode', 'dist', 'build', 
    'coverage', '__pycache__', '.next', 'venv', 'env'
}

# Arquivos sensíveis ou irrelevantes
ARQUIVOS_IGNORADOS = {
    '.env', '.env.local', 'package-lock.json', 'yarn.lock', 
    '.DS_Store', 'Thumbs.db', 'gerar_hash_inpi.py'
}

def calcular_hash_projeto(diretorio_raiz):
    sha512_geral = hashlib.sha512()
    manifesto = []
    total_arquivos = 0
    tamanho_total = 0

    print(f"🔒 Iniciando Varredura Forense em: {diretorio_raiz}")
    print("-" * 50)

    # Caminha por todos os diretórios
    for pasta_atual, subpastas, arquivos in os.walk(diretorio_raiz):
        # Remove pastas ignoradas para não entrar nelas
        subpastas[:] = [d for d in subpastas if d not in PASTAS_IGNORADAS]

        for arquivo in sorted(arquivos): # Ordenar é CRUCIAL para o hash ser sempre igual
            if arquivo in ARQUIVOS_IGNORADOS:
                continue
            
            ext = os.path.splitext(arquivo)[1]
            if ext in EXTENSOES_PERMITIDAS:
                caminho_completo = os.path.join(pasta_atual, arquivo)
                caminho_relativo = os.path.relpath(caminho_completo, diretorio_raiz)

                try:
                    with open(caminho_completo, 'rb') as f:
                        conteudo = f.read()
                        
                        # Atualiza o Hash Geral
                        sha512_geral.update(conteudo)
                        
                        # Adiciona ao manifesto
                        hash_arquivo = hashlib.sha256(conteudo).hexdigest()
                        manifesto.append(f"{hash_arquivo} | {caminho_relativo}")
                        
                        total_arquivos += 1
                        tamanho_total += len(conteudo)
                        
                except Exception as e:
                    print(f"❌ Erro ao ler {caminho_relativo}: {e}")

    # Finalização
    hash_final = sha512_geral.hexdigest()
    
    # Gera o Relatório
    timestamp = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    relatorio = [
        "=== CERTIFICADO DIGITAL DE INTEGRIDADE - PROFEPLAN ===",
        f"Data da Geração: {timestamp}",
        f"Arquivos Processados: {total_arquivos}",
        f"Tamanho Total do Código: {tamanho_total / 1024:.2f} KB",
        f"Algoritmo: SHA-512",
        "-" * 50,
        f"HASH FINAL (DIGITAL FINGERPRINT):",
        f"{hash_final}",
        "-" * 50,
        "MANIFESTO DE ARQUIVOS (SHA-256 Individual):"
    ] + manifesto

    # Salva em arquivo
    nome_saida = "REGISTRO_SOFTWARE_INPI.txt"
    with open(nome_saida, 'w', encoding='utf-8') as f:
        f.write('\n'.join(relatorio))

    print("-" * 50)
    print(f"✅ SUCESSO! Hash gerado.")
    print(f"📂 Arquivo gerado: {nome_saida}")
    print(f"🔑 HASH MESTRE: {hash_final[:64]}... (ver arquivo completo)")
    print("-" * 50)

if __name__ == "__main__":
    calcular_hash_projeto('.')