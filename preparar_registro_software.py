#!/usr/bin/env python3
"""
Preparador de Registro de Software INPI - PROFEPLAN
Compila pacote completo (.zip) para depósito no INPI.

Autor: Paulo Roberto Rehfeld
CPF: 758.442.730-87
Data: 2026-02-16
"""

import os
import zipfile
from pathlib import Path
from datetime import datetime

# Configurações
PROJETO_ROOT = Path(__file__).parent
HASH_FILE = PROJETO_ROOT / "REGISTRO_SOFTWARE_INPI.txt"
MEMORIAL_FILE = PROJETO_ROOT / "MEMORIAL_DESCRITIVO_PROFEPLAN.md"
SAIDA_ZIP = PROJETO_ROOT / "DEPOSITO_INPI_SOFTWARE.zip"


def extrair_hash_mestre(hash_file: Path) -> str:
    """Extrai o hash SHA-512 do arquivo de registro."""
    if not hash_file.exists():
        raise FileNotFoundError(f"Arquivo de hash não encontrado: {hash_file}")
    
    with open(hash_file, 'r', encoding='utf-8') as f:
        linhas = f.readlines()
        
    # Procurar linha com "HASH FINAL"
    for i, linha in enumerate(linhas):
        if "HASH FINAL" in linha or "DIGITAL FINGERPRINT" in linha:
            # Hash está na próxima linha
            if i + 1 < len(linhas):
                hash_value = linhas[i + 1].strip()
                return hash_value
    
    raise ValueError("Hash SHA-512 não encontrado no arquivo!")


def gerar_resumo_tecnico() -> str:
    """Gera resumo técnico de 500 caracteres para INPI."""
    resumo = """Sistema SaaS educacional para geração automatizada de planejamentos pedagógicos alinhados à BNCC. Utiliza RAG (Retrieval-Augmented Generation) com Google Gemini 2.0, VectorDB (pgvector) e arquitetura modular "Holding Industrial". Processa currículos estaduais (BNCC/SEEMG), livros PNLD via web scraping (Playwright) e gera planos customizados com validação automática de conformidade. Stack: React 18, TypeScript, Python 3.11+, Supabase, TailwindCSS, Capacitor. Funcionalidades: RAG híbrido educacional, guardrails BNCC, query expansion regionalizada."""
    
    # Garantir que está dentro do limite
    if len(resumo) > 500:
        resumo = resumo[:497] + "..."
    
    return resumo


def gerar_listagem_linguagens() -> str:
    """Gera listagem de linguagens de programação."""
    linguagens = """Linguagens de Programação Utilizadas:

1. TypeScript - Frontend (React, componentes)
2. JavaScript - Scripts e utilities
3. Python - Backend, IA, processamento de dados
4. SQL - Schemas de banco de dados
5. CSS - Estilização (TailwindCSS v4)

Frameworks Principais:
- React 18 (Frontend)
- Vite (Build tool)
- Capacitor (Mobile)
- Google Gemini 2.0 (IA Generativa)
- Supabase (Backend as a Service)
"""
    return linguagens


def criar_pacote_deposito():
    """Cria arquivo .zip para depósito no INPI."""
    
    print("=" * 60)
    print("  PREPARADOR DE REGISTRO DE SOFTWARE - INPI")
    print("  PROFEPLAN")
    print("=" * 60)
    print()
    
    # 1. Verificar hash existente
    print("🔍 Verificando hash SHA-512...")
    try:
        hash_mestre = extrair_hash_mestre(HASH_FILE)
        print(f"✅ Hash encontrado: {hash_mestre[:64]}...")
    except Exception as e:
        print(f"❌ Erro ao extrair hash: {e}")
        print("💡 Execute: python gerar_hash_inpi.py")
        return
    
    # 2. Gerar resumo técnico
    print("\n📝 Gerando resumo técnico...")
    resumo = gerar_resumo_tecnico()
    print(f"✅ Resumo: {len(resumo)} caracteres")
    
    # 3. Gerar listagem de linguagens
    print("\n💻 Listando linguagens...")
    linguagens = gerar_listagem_linguagens()
    print("✅ Linguagens catalogadas")
    
    # 4. Verificar memorial descritivo
    print("\n📄 Verificando memorial descritivo...")
    if not MEMORIAL_FILE.exists():
        print("⚠️  Memorial não encontrado!")
        print("💡 Execute: python gerador_memorial_descritivo.py")
        memorial_incluido = False
    else:
        print(f"✅ Memorial encontrado: {MEMORIAL_FILE.name}")
        memorial_incluido = True
    
    # 5. Criar arquivos temporários
    print("\n📦 Criando arquivos do pacote...")
    
    # Resumo técnico
    resumo_file = PROJETO_ROOT / "RESUMO_TECNICO_INPI.txt"
    with open(resumo_file, 'w', encoding='utf-8') as f:
        f.write("=" * 60 + "\n")
        f.write("RESUMO TÉCNICO - PROFEPLAN\n")
        f.write("Registro de Software - INPI\n")
        f.write("=" * 60 + "\n\n")
        f.write(f"Titular: Paulo Roberto Rehfeld\n")
        f.write(f"CPF: 758.442.730-87\n")
        f.write(f"Data: {datetime.now().strftime('%d/%m/%Y')}\n\n")
        f.write("DESCRIÇÃO (500 caracteres):\n")
        f.write("-" * 60 + "\n")
        f.write(resumo + "\n\n")
        f.write("=" * 60 + "\n")
        f.write(linguagens)
    
    # Hash completo (cópia)
    hash_completo_file = PROJETO_ROOT / "HASH_SHA512_COMPLETO.txt"
    with open(HASH_FILE, 'r', encoding='utf-8') as src:
        conteudo_hash = src.read()
    with open(hash_completo_file, 'w', encoding='utf-8') as dst:
        dst.write(conteudo_hash)
    
    # Manifesto
    manifesto_file = PROJETO_ROOT / "MANIFESTO_DEPOSITO.txt"
    with open(manifesto_file, 'w', encoding='utf-8') as f:
        f.write("=" * 60 + "\n")
        f.write("MANIFESTO DE DEPÓSITO - INPI\n")
        f.write("Registro de Programa de Computador\n")
        f.write("=" * 60 + "\n\n")
        f.write(f"Título: PROFEPLAN - Sistema de Geração de Planejamentos Pedagógicos\n\n")
        f.write(f"Titular:\n")
        f.write(f"  Nome: Paulo Roberto Rehfeld\n")
        f.write(f"  CPF: 758.442.730-87\n\n")
        f.write(f"Data de Criação: 2024-2026\n")
        f.write(f"Data de Depósito: {datetime.now().strftime('%d/%m/%Y')}\n\n")
        f.write("Documentos Inclusos:\n")
        f.write("  1. HASH_SHA512_COMPLETO.txt - Certificado digital de integridade\n")
        f.write("  2. RESUMO_TECNICO_INPI.txt - Descrição técnica (500 chars)\n")
        if memorial_incluido:
            f.write("  3. MEMORIAL_DESCRITIVO_PROFEPLAN.md - Documentação técnica detalhada\n")
        f.write(f"  {4 if memorial_incluido else 3}. MANIFESTO_DEPOSITO.txt - Este arquivo\n\n")
        f.write("Campo de Aplicação:\n")
        f.write("  - Educação\n")
        f.write("  - Software como Serviço (SaaS)\n")
        f.write("  - Inteligência Artificial Aplicada\n\n")
        f.write("Natureza do Programa:\n")
        f.write("  - Aplicativo\n")
        f.write("  - Sistema Web\n")
        f.write("  - Sistema Mobile (Android)\n\n")
        f.write("Linguagens de Programação:\n")
        f.write("  - TypeScript/JavaScript\n")
        f.write("  - Python\n")
        f.write("  - SQL\n\n")
    
    # 6. Criar ZIP
    print(f"\n🗜️  Compactando para {SAIDA_ZIP.name}...")
    
    with zipfile.ZipFile(SAIDA_ZIP, 'w', zipfile.ZIP_DEFLATED) as zipf:
        # Adicionar hash
        zipf.write(hash_completo_file, hash_completo_file.name)
        print(f"   ✅ {hash_completo_file.name}")
        
        # Adicionar resumo
        zipf.write(resumo_file, resumo_file.name)
        print(f"   ✅ {resumo_file.name}")
        
        # Adicionar manifesto
        zipf.write(manifesto_file, manifesto_file.name)
        print(f"   ✅ {manifesto_file.name}")
        
        # Adicionar memorial se existir
        if memorial_incluido:
            zipf.write(MEMORIAL_FILE, MEMORIAL_FILE.name)
            print(f"   ✅ {MEMORIAL_FILE.name}")
    
    # 7. Limpar arquivos temporários
    print("\n🧹 Limpando arquivos temporários...")
    resumo_file.unlink()
    hash_completo_file.unlink()
    manifesto_file.unlink()
    
    # 8. Relatório final
    tamanho_kb = SAIDA_ZIP.stat().st_size / 1024
    
    print("\n" + "=" * 60)
    print("✨ PACOTE DE DEPÓSITO CRIADO COM SUCESSO!")
    print("=" * 60)
    print(f"\n📂 Arquivo: {SAIDA_ZIP.name}")
    print(f"📏 Tamanho: {tamanho_kb:.2f} KB")
    print(f"📦 Documentos: {4 if memorial_incluido else 3}")
    print(f"\n🔑 Hash SHA-512: {hash_mestre[:64]}...")
    print(f"📝 Resumo: {len(resumo)} caracteres")
    
    print("\n" + "-" * 60)
    print("PRÓXIMOS PASSOS:")
    print("-" * 60)
    print("1. Acesse: https://www.gov.br/inpi/pt-br/servicos/programas-de-computador")
    print("2. Faça login com sua conta gov.br")
    print("3. Selecione 'Pedido de Registro de Programa de Computador'")
    print(f"4. Faça upload do arquivo: {SAIDA_ZIP.name}")
    print("5. Preencha formulário online com dados:")
    print(f"   - Título: PROFEPLAN")
    print(f"   - Titular: Paulo Roberto Rehfeld (CPF 758.442.730-87)")
    print(f"   - Campo de Aplicação: Educação")
    print("6. Pague a GRU (taxa de registro)")
    print("7. Aguarde análise (prazo: ~30 dias)")
    print("-" * 60)
    print()


if __name__ == "__main__":
    criar_pacote_deposito()
