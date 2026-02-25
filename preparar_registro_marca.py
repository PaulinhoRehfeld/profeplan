#!/usr/bin/env python3
"""
Preparador de Registro de Marca INPI - PROFEPLAN
Gera checklist e especificações para registro de marca.

Autor: Paulo Roberto Rehfeld
CPF: 758.442.730-87
Data: 2026-02-16
"""

import os
from pathlib import Path
from datetime import datetime
import zipfile

# Configurações
PROJETO_ROOT = Path(__file__).parent
SAIDA_DIR = PROJETO_ROOT / "registro_marca_inpi"
SAIDA_ZIP = PROJETO_ROOT / "DEPOSITO_INPI_MARCA.zip"


def criar_especificacao_classe_09():
    """Cria especificação para Classe 09 (Produtos)."""
    especificacao = """CLASSE 09 - PRODUTOS

Marca: PROFEPLAN

Especificação de Produtos:

1. Programas de computador para uso educacional, gravados ou baixáveis

2. Aplicativos móveis para planejamento pedagógico, baixáveis

3. Software para geração automatizada de conteúdo educacional, gravado

4. Bases de dados educacionais eletrônicas, gravadas ou baixáveis

5. Software de gerenciamento de currículos e planejamentos escolares

6. Aplicações de software educacional que utilizam inteligência artificial

7. Plataformas de software para alinhamento curricular à BNCC

8. Programas de computador para gestão de dados pedagógicos

9. Software como serviço (SaaS) educacional, gravado ou baixável

10. Aplicativos para dispositivos móveis educacionais (Android/iOS)
"""
    return especificacao


def criar_especificacao_classe_42():
    """Cria especificação para Classe 42 (Serviços)."""
    especificacao = """CLASSE 42 - SERVIÇOS

Marca: PROFEPLAN

Especificação de Serviços:

1. Serviços de software como serviço (SaaS) relacionados a planejamento educacional

2. Desenvolvimento de software educacional personalizado

3. Consultoria em tecnologia da informação voltada para instituições de ensino

4. Hospedagem de plataformas educacionais online

5. Serviços de computação em nuvem para armazenamento de dados pedagógicos

6. Manutenção e atualização de software educacional

7. Serviços de análise de dados educacionais via inteligência artificial

8. Design e desenvolvimento de aplicativos móveis educacionais

9. Serviços de banco de dados educacionais como serviço (DBaaS)

10. Consultoria em automação de processos pedagógicos via software

11. Desenvolvimento de sistemas de alinhamento curricular à BNCC

12. Serviços de integração de tecnologia educacional
"""
    return especificacao


def criar_checklist_documentos():
    """Cria checklist de documentos necessários."""
    checklist = f"""CHECKLIST DE DOCUMENTOS - REGISTRO DE MARCA INPI

Data: {datetime.now().strftime('%d/%m/%Y')}

MARCA: PROFEPLAN
TITULAR: Paulo Roberto Rehfeld
CPF: 758.442.730-87

═══════════════════════════════════════════════════════════════

DOCUMENTOS OBRIGATÓRIOS:

[ ] 1. LOGOMARCA EM FORMATO VETORIAL
    Formatos aceitos: CDR, AI, EPS, SVG
    Dimensões: Mínimo 5cm x 5cm (300 DPI)
    Cores: Conforme identidade visual
    Arquivo: PROFEPLAN_LOGO_VETOR.<extensão>

[ ] 2. LOGOMARCA EM PNG DE ALTA RESOLUÇÃO
    Formato: PNG (fundo transparente recomendado)
    Dimensões: Mínimo 1000x1000 pixels
    Resolução: 300 DPI ou superior
    Arquivo: PROFEPLAN_LOGO_ALTA.png

[ ] 3. COMPROVANTE DE CPF DO TITULAR
    Documento: CPF válido de Paulo Roberto Rehfeld
    Formato: PDF digitalizado
    Arquivo: CPF_TITULAR.pdf

[ ] 4. PROCURAÇÃO (se aplicável)
    Necessário apenas se usar advogado/agente
    Formato: PDF com firma reconhecida
    Arquivo: PROCURACAO.pdf

[ ] 5. ESPECIFICAÇÃO CLASSE 09
    Arquivo: ESPECIFICACAO_CLASSE_09.txt
    Status: ✅ Gerado automaticamente

[ ] 6. ESPECIFICAÇÃO CLASSE 42
    Arquivo: ESPECIFICACAO_CLASSE_42.txt
    Status: ✅ Gerado automaticamente

═══════════════════════════════════════════════════════════════

INFORMAÇÕES ADICIONAIS NECESSÁRIAS:

Tipo de Marca: ( ) Nominativa  ( ) Figurativa  (X) Mista
Natureza: (X) Produto  (X) Serviço
Apresentação: ( ) Preto e Branco  (X) Cores

Cores da Marca (se colorida):
┌─────────────────────────────────────────┐
│ Especificar cores exatas                │
│ Ex: Pantone, RGB, CMYK                  │
│                                         │
│ ATENÇÃO: Preencher manualmente!        │
└─────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════

CUSTOS ESTIMADOS (valores de 2026):

- Taxa de depósito (pessoa física): R$ 355,00 por classe
- Total para 2 classes (09 e 42): R$ 710,00
- Prazo de análise: 12-36 meses (média)

═══════════════════════════════════════════════════════════════

OBSERVAÇÕES IMPORTANTES:

1. PESQUISA DE ANTERIORIDADE (OBRIGATÓRIA):
   - Antes de depositar, pesquise se "PROFEPLAN" já foi registrado
   - Acesse: https://busca.inpi.gov.br/pePI/
   - Pesquise por: "PROFEPLAN" em Classes 09 e 42

2. REIVINDICAÇÃO DE PRIORIDADE:
   - Se houver pedido de software aprovado, mencionar no formulário
   - Pode fortalecer pedido de marca

3. VIGÊNCIA:
   - Marca válida por 10 anos
   - Prorrogável indefinidamente (a cada 10 anos)

═══════════════════════════════════════════════════════════════

PRÓXIMOS PASSOS:

1. ✅ Verificar este checklist
2. [ ] Preparar logo em formato vetorial
3. [ ] Exportar logo em PNG alta resolução
4. [ ] Fazer pesquisa de anterioridade
5. [ ] Acessar portal INPI: https://www.gov.br/inpi/pt-br/servicos/marcas
6. [ ] Fazer upload dos documentos
7. [ ] Pagar GRU (R$ 710,00)
8. [ ] Acompanhar processo (código fornecido após depósito)

═══════════════════════════════════════════════════════════════
"""
    return checklist


def criar_guia_completo():
    """Cria guia completo para registro de marca."""
    guia = f"""GUIA COMPLETO - REGISTRO DE MARCA "PROFEPLAN" NO INPI

Data: {datetime.now().strftime('%d/%m/%Y')}
Titular: Paulo Roberto Rehfeld (CPF 758.442.730-87)

═══════════════════════════════════════════════════════════════

1. O QUE É O REGISTRO DE MARCA?

O registro de marca no INPI (Instituto Nacional da Propriedade Industrial)
garante ao titular o direito exclusivo de uso da marca "PROFEPLAN" em todo
território nacional para produtos (Classe 09) e serviços (Classe 42) 
relacionados à educação e tecnologia.

═══════════════════════════════════════════════════════════════

2. POR QUE CLASSES 09 E 42?

CLASSE 09 (Produtos):
- Cobre software educacional, aplicativos móveis, bases de dados
- Protege o PROFEPLAN como produto digital
- Impede concorrentes de usar o nome em software similar

CLASSE 42 (Serviços):
- Cobre SaaS, consultoria, hospedagem, desenvolvimento
- Protege o PROFEPLAN como serviço
- Essencial para modelo de negócio B2G/B2B

═══════════════════════════════════════════════════════════════

3. PESQUISA DE ANTERIORIDADE (PASSO CRÍTICO!)

ANTES de depositar, você DEVE verificar se "PROFEPLAN" já existe:

Como fazer:
1. Acesse: https://busca.inpi.gov.br/pePI/
2. Clique em "Pesquisa de Marcas"
3. Digite: PROFEPLAN
4. Selecione Classes: 09 e 42
5. Analise resultados:
   - Se NADA aparecer → Pode prosseguir ✅
   - Se aparecer marca idêntica → Ajustar estratégia ⚠️
   - Se aparecer marca similar → Avaliar risco de conflito ⚠️

═══════════════════════════════════════════════════════════════

4. PREPARAÇÃO DA LOGO

A logo deve estar em 2 formatos:

FORMATO 1 - Vetorial (obrigatório):
- Extensões: CDR, AI, EPS ou SVG
- Software: Adobe Illustrator, CorelDRAW, Inkscape
- Características: Escalável sem perda de qualidade
- Arquivo: PROFEPLAN_LOGO_VETOR.<ext>

FORMATO 2 - PNG Alta Resolução (obrigatório):
- Resolução: Mínimo 1000x1000 pixels (300 DPI)
- Fundo: Transparente (recomendado)
- Cores: Conforme identidade visual
- Arquivo: PROFEPLAN_LOGO_ALTA.png

IMPORTANTE: Se a logo for colorida, especifique as cores EXATAS
usando Pantone, RGB ou CMYK!

═══════════════════════════════════════════════════════════════

5. PROCESSO DE DEPÓSITO NO INPI

PASSO 1: Acesse o Portal
URL: https://www.gov.br/inpi/pt-br/servicos/marcas
Login: Conta gov.br (nível prata ou ouro)

PASSO 2: Selecione "Pedido de Registro de Marca"
Tipo: Marca Mista (texto + imagem)
Natureza: Produto + Serviço
Apresentação: Colorida (ou P&B se for o caso)

PASSO 3: Preencha o Formulário
- Titular: Paulo Roberto Rehfeld
- CPF: 758.442.730-87
- Marca: PROFEPLAN
- Classe 09: Cole especificação de produtos
- Classe 42: Cole especificação de serviços

PASSO 4: Faça Upload da Logo
- Arquivo vetorial (obrigatório)
- Arquivo PNG (obrigatório)

PASSO 5: Pague a GRU
- Valor: R$ 355,00 por classe
- Total: R$ 710,00 (Classes 09 + 42)
- Prazo: Pagar em até 5 dias úteis

PASSO 6: Acompanhamento
- Após pagamento, receberá número de processo
- Ex: BR 40 2026 000001 2
- Acompanhe na Revista da Propriedade Industrial (RPI)
- URL: https://revistas.inpi.gov.br/rpi/

═══════════════════════════════════════════════════════════════

6. PRAZOS E ETAPAS

Depósito → Publicação (1-3 meses)
   ↓
Exame Formal (6-12 meses)
   ↓
Publicação para Oposição (60 dias)
   ↓ (se não houver oposição)
Exame de Mérito (6-12 meses)
   ↓
Concessão ou Indeferimento
   ↓
Pagamento de Emissão do Certificado
   ↓
Certificado de Registro (10 anos de validade)

PRAZO TOTAL: 12 a 36 meses (média: 24 meses)

═══════════════════════════════════════════════════════════════

7. APÓS A CONCESSÃO

- Vigência: 10 anos a partir da concessão
- Renovação: Pode renovar indefinidamente (a cada 10 anos)
- Custo de renovação: ~R$ 1.065,00 (pessoa física, 2 classes)
- Uso obrigatório: Deve usar a marca em até 5 anos

═══════════════════════════════════════════════════════════════

8. DICAS IMPORTANTES

✅ Monitore a RPI semanalmente durante o processo
✅ Responda TODAS as exigências no prazo (geralmente 60 dias)
✅ Guarde TODOS os comprovantes de uso da marca (prints, contratos)
✅ Se houver oposição, responda através de advogado especializado
✅ Considere registrar variações da marca (ex: "Profeplan", "ProféPlan")

═══════════════════════════════════════════════════════════════

REFERÊNCIAS:

- Portal INPI: https://www.gov.br/inpi/pt-br
- Busca de Marcas: https://busca.inpi.gov.br/pePI/
- RPI: https://revistas.inpi.gov.br/rpi/
- Manuais: https://www.gov.br/inpi/pt-br/servicos/marcas/manuais

═══════════════════════════════════════════════════════════════

Gerado automaticamente por: preparar_registro_marca.py
"""
    return guia


def criar_pacote_marca():
    """Cria estrutura de diretórios e arquivos para registro de marca."""
    
    print("=" * 60)
    print("  PREPARADOR DE REGISTRO DE MARCA - INPI")
    print("  PROFEPLAN")
    print("=" * 60)
    print()
    
    # Criar diretório de saída
    SAIDA_DIR.mkdir(exist_ok=True)
    print(f"📁 Diretório criado: {SAIDA_DIR.name}")
    
    # Gerar especificação Classe 09
    print("\n📄 Gerando especificação Classe 09...")
    spec_09 = criar_especificacao_classe_09()
    spec_09_file = SAIDA_DIR / "ESPECIFICACAO_CLASSE_09.txt"
    with open(spec_09_file, 'w', encoding='utf-8') as f:
        f.write(spec_09)
    print(f"✅ {spec_09_file.name}")
    
    # Gerar especificação Classe 42
    print("📄 Gerando especificação Classe 42...")
    spec_42 = criar_especificacao_classe_42()
    spec_42_file = SAIDA_DIR / "ESPECIFICACAO_CLASSE_42.txt"
    with open(spec_42_file, 'w', encoding='utf-8') as f:
        f.write(spec_42)
    print(f"✅ {spec_42_file.name}")
    
    # Gerar checklist
    print("📋 Gerando checklist de documentos...")
    checklist = criar_checklist_documentos()
    checklist_file = SAIDA_DIR / "CHECKLIST_DOCUMENTOS.txt"
    with open(checklist_file, 'w', encoding='utf-8') as f:
        f.write(checklist)
    print(f"✅ {checklist_file.name}")
    
    # Gerar guia completo
    print("📖 Gerando guia completo...")
    guia = criar_guia_completo()
    guia_file = SAIDA_DIR / "GUIA_COMPLETO_REGISTRO_MARCA.txt"
    with open(guia_file, 'w', encoding='utf-8') as f:
        f.write(guia)
    print(f"✅ {guia_file.name}")
    
    # Criar README para completar pacote
    print("📝 Criando README...")
    readme = f"""PACOTE DE REGISTRO DE MARCA INPI - PROFEPLAN
{datetime.now().strftime('%d/%m/%Y')}

Este pacote contém todos os documentos necessários para registro da marca
"PROFEPLAN" nas Classes 09 (Produtos) e 42 (Serviços).

CONTEÚDO:
1. ESPECIFICACAO_CLASSE_09.txt - Especificação de produtos
2. ESPECIFICACAO_CLASSE_42.txt - Especificação de serviços
3. CHECKLIST_DOCUMENTOS.txt - Lista de documentos obrigatórios
4. GUIA_COMPLETO_REGISTRO_MARCA.txt - Guia passo a passo

PRÓXIMOS PASSOS:
1. Leia o GUIA_COMPLETO_REGISTRO_MARCA.txt
2. Confira o CHECKLIST_DOCUMENTOS.txt
3. Prepare a logo nos formatos solicitados
4. Faça pesquisa de anterioridade no INPI
5. Acesse o portal INPI e faça o depósito

IMPORTANTE:
- Este pacote NÃO inclui a logo (deve ser preparada manualmente)
- Faça SEMPRE a pesquisa de anterioridade antes de depositar
- Guarde todos os comprovantes de uso da marca

Boa sorte! 🍀
"""
    readme_file = SAIDA_DIR / "README.txt"
    with open(readme_file, 'w', encoding='utf-8') as f:
        f.write(readme)
    print(f"✅ {readme_file.name}")
    
    # Criar placeholder para logo
    print("\n📸 Criando placeholders para logo...")
    placeholder_vetor = SAIDA_DIR / "PROFEPLAN_LOGO_VETOR_AQUI.txt"
    with open(placeholder_vetor, 'w', encoding='utf-8') as f:
        f.write("Substitua este arquivo pela logo em formato vetorial (CDR, AI, EPS, SVG)\n")
        f.write("Dimensões mínimas: 5cm x 5cm (300 DPI)\n")
    
    placeholder_png = SAIDA_DIR / "PROFEPLAN_LOGO_PNG_AQUI.txt"
    with open(placeholder_png, 'w', encoding='utf-8') as f:
        f.write("Substitua este arquivo pela logo em PNG de alta resolução\n")
        f.write("Dimensões mínimas: 1000x1000 pixels (300 DPI)\n")
        f.write("Fundo transparente recomendado\n")
    
    print(f"✅ Placeholders criados")
    
    # Relatório final
    print("\n" + "=" * 60)
    print("✨ PACOTE DE REGISTRO DE MARCA CRIADO!")
    print("=" * 60)
    print(f"\n📂 Diretório: {SAIDA_DIR}")
    print(f"📦 Arquivos gerados: {len(list(SAIDA_DIR.iterdir()))}")
    
    print("\n" + "-" * 60)
    print("DOCUMENTOS INCLUSOS:")
    print("-" * 60)
    for arquivo in sorted(SAIDA_DIR.iterdir()):
        tamanho_kb = arquivo.stat().st_size / 1024
        print(f"  ✅ {arquivo.name} ({tamanho_kb:.1f} KB)")
    
    print("\n" + "-" * 60)
    print("⚠️  ATENÇÃO - AÇÕES NECESSÁRIAS:")
    print("-" * 60)
    print("1. Preparar logo em formato vetorial")
    print("2. Preparar logo em PNG alta resolução")
    print("3. Substituir os placeholders pelos arquivos reais")
    print("4. Fazer pesquisa de anterioridade no INPI")
    print(f"5. Revisar documentos em: {SAIDA_DIR}")
    print("-" * 60)
    print()
    
    print(f"💡 Próximo passo: Leia {guia_file.name} para instruções detalhadas")
    print()


if __name__ == "__main__":
    criar_pacote_marca()
