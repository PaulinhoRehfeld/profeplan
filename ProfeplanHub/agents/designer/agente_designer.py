import os
from jinja2 import Template
import webbrowser

# --- CONFIGURAÇÃO DO DESIGN (HTML + CSS) ---
# Aqui a gente define a "cara" do documento. 
# A IA não desenha isso do zero, ela apenas preenche esse modelo.

TEMPLATE_HTML = """
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: 'Helvetica', sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .pagina {
            width: 210mm; min-height: 297mm; /* Tamanho A4 */
            padding: 20mm; margin: 20px auto;
            background: white; box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header { 
            background-color: {{ cor_tema }}; /* A IA escolhe a cor */
            color: white; padding: 20px; border-radius: 8px 8px 0 0;
            display: flex; justify-content: space-between; align-items: center;
        }
        .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
        .tag { background: rgba(255,255,255,0.2); padding: 5px 10px; border-radius: 20px; font-size: 12px;}
        
        .conteudo-principal { display: flex; gap: 20px; margin-top: 30px; }
        .coluna-texto { flex: 2; text-align: justify; line-height: 1.6; color: #333; }
        .coluna-visual { flex: 1; display: flex; flex-direction: column; gap: 15px; }
        
        .box-destaque {
            background-color: #f9f9f9; border-left: 5px solid {{ cor_tema }};
            padding: 15px; font-style: italic; font-size: 0.9em;
        }
        
        .moldura-imagem {
            width: 100%; height: 200px; background-color: #ddd;
            border-radius: 8px; overflow: hidden;
            display: flex; align-items: center; justify-content: center;
            border: 2px dashed {{ cor_tema }};
        }
        .moldura-imagem img { width: 100%; height: 100%; object-fit: cover; }
        .legenda-imagem { font-size: 10px; color: #666; text-align: center; margin-top: 5px; }

        .rodape { 
            margin-top: 40px; border-top: 1px solid #eee; 
            padding-top: 10px; font-size: 10px; color: #888; text-align: center;
        }
    </style>
</head>
<body>

    <div class="pagina">
        <div class="header">
            <div>
                <h1>{{ titulo }}</h1>
                <p style="margin:5px 0 0 0; font-size: 14px;">Planejamento Inteligente | PROFEPLAN</p>
            </div>
            <span class="tag">{{ disciplina }}</span>
        </div>

        <div class="conteudo-principal">
            
            <div class="coluna-texto">
                <h2>O Conceito</h2>
                {{ texto_conceito }}
                
                <h3>Aplicação em Sala</h3>
                {{ texto_pratica }}
            </div>

            <div class="coluna-visual">
                
                <div class="moldura-imagem">
                    {% if url_imagem %}
                        <img src="{{ url_imagem }}" alt="Imagem gerada pela IA">
                    {% else %}
                        <span style="color: #666; padding: 10px; text-align: center;">
                            🤖 A IA desenharia aqui: <br><i>"{{ prompt_imagem }}"</i>
                        </span>
                    {% endif %}
                </div>
                <div class="legenda-imagem">Prompt: {{ prompt_imagem }}</div>

                <div class="box-destaque">
                    <strong>💡 Você Sabia?</strong><br>
                    {{ curiosidade }}
                </div>
            </div>
        </div>

        <div class="rodape">
            Gerado automaticamente pelo Antigravity AI • Baseado na BNCC de Minas Gerais
        </div>
    </div>

</body>
</html>
"""

# --- FUNÇÃO DO AGENTE ---
def gerar_material_design(dados_da_ia):
    print("🎨 Agente Designer: Recebendo dados...")
    print(f"🖌️  Aplicando tema: {dados_da_ia['cor_tema']}")

    # 1. Carrega o Template
    template = Template(TEMPLATE_HTML)

    # 2. Preenche com os dados (Renderização)
    html_pronto = template.render(
        titulo=dados_da_ia['titulo'],
        disciplina=dados_da_ia['disciplina'],
        texto_conceito=dados_da_ia['texto_conceito'],
        texto_pratica=dados_da_ia['texto_pratica'],
        curiosidade=dados_da_ia['curiosidade'],
        cor_tema=dados_da_ia['cor_tema'],
        prompt_imagem=dados_da_ia['prompt_imagem'],
        url_imagem=dados_da_ia.get('url_imagem') # Opcional
    )

    # 3. Salva o Arquivo
    nome_arquivo = f"03_SAIDA_DESIGN/Material_{dados_da_ia['disciplina']}.html"
    
    # Cria a pasta se não existir
    if not os.path.exists('03_SAIDA_DESIGN'):
        os.makedirs('03_SAIDA_DESIGN')

    with open(nome_arquivo, "w", encoding="utf-8") as f:
        f.write(html_pronto)

    print(f"✅ Design Gerado! Abrindo para visualização: {nome_arquivo}")
    
    # 4. Abre automaticamente no navegador para você ver o resultado
    webbrowser.open('file://' + os.path.realpath(nome_arquivo))

# --- SIMULAÇÃO (O que o Profeplan mandaria para o Agente) ---
if __name__ == "__main__":
    
    # Imagine que isso aqui foi o que o AGENTE 1 (Texto) gerou lendo os PDFs
    # e enviou para o AGENTE 2 (Design)
    payload_teste = {
        "disciplina": "História",
        "titulo": "A Revolução Industrial",
        "cor_tema": "#B84438", # Vermelho tijolo
        "texto_conceito": """
            <p>A Revolução Industrial foi um processo de grandes transformações econômicas e sociais que começou na Inglaterra no século XVIII.</p>
            <p>O modo de produção artesanal foi substituído pelo maquinofatura, alterando profundamente as relações de trabalho e a paisagem urbana.</p>
        """,
        "texto_pratica": """
            <p><strong>Dinâmica: A Linha de Montagem</strong></p>
            <p>Divida a turma em grupos. Cada grupo será uma "fábrica" de desenhos. Alguns alunos desenham apenas círculos, outros quadrados, e assim por diante, simulando a divisão do trabalho.</p>
        """,
        "curiosidade": "Você sabia que antes dos relógios se tornarem comuns, as fábricas tinham um 'despertador humano' que batia nas janelas dos trabalhadores para acordá-los?",
        "prompt_imagem": "Ilustração estilo gravura antiga, preto e branco, mostrando uma fábrica de tijolos com chaminés soltando fumaça, Londres século 18."
    }

    gerar_material_design(payload_teste)
