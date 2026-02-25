"""
AgentePedagogo - Sistema RAG para Geração de Roteiros de Aula

Versão refatorada que usa Supabase VectorDB ao invés de ChromaDB local.
Compatible com Gemini text-embedding-004 (768 dimensões).
"""

import os
import json
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client, Client
from google import genai
from google.genai import types

# Carregar configurações
config_path = Path(__file__).parent.parent.parent / "config" / ".env"
load_dotenv(config_path)


class AgentePedagogo:
    def __init__(self):
        """Inicializa o Agente Pedagogo com Supabase e Gemini"""
        print("🧠 [PEDAGOGO] Inicializando com Supabase VectorDB...")
        
        # Supabase client
        supabase_url = os.getenv("SUPABASE_URL")
        supabase_key = os.getenv("SUPABASE_KEY")
        
        if not supabase_url or not supabase_key:
            raise ValueError("SUPABASE_URL e SUPABASE_KEY devem estar configurados no .env")
        
        self.supabase: Client = create_client(supabase_url, supabase_key)
        
        # Gemini client para embeddings e geração
        api_key = os.getenv("API_KEY_GOOGLE") or os.getenv("GEMINI_API_KEY")
        if not api_key:
            raise ValueError("API_KEY_GOOGLE ou GEMINI_API_KEY deve estar configurado no .env")
        
        self.gemini_client = genai.Client(api_key=api_key)
        
        # Configuração do modelo de embedding
        self.embedding_model = os.getenv("GEMINI_EMBEDDING_MODEL", "embedding-001")
        
        print("✅ [PEDAGOGO] Inicializado com sucesso!")
        print(f"   - Supabase: {supabase_url}")
        print(f"   - Embedding Model: {self.embedding_model}")
    
    def recuperar_conhecimento(self, tema: str, match_count: int = 3, match_threshold: float = 0.5) -> str:
        """
        Busca semântica no Supabase usando pgvector
        
        Args:
            tema: Tema ou pergunta para buscar
            match_count: Número de resultados a retornar
            match_threshold: Threshold de similaridade (0.0 a 1.0)
        
        Returns:
            Contexto consolidado dos livros PNLD relevantes
        """
        print(f"🔍 [PEDAGOGO] Pesquisando na biblioteca sobre: '{tema}'...")
        
        # 1. Gerar embedding da query com Gemini text-embedding-004
        embedding_result = self.gemini_client.models.embed_content(
            model=self.embedding_model,
            contents=tema
        )
        query_embedding = embedding_result.embeddings[0].values
        
        print(f"   - Embedding gerado: {len(query_embedding)} dimensões")
        
        # 2. Buscar no Supabase usando RPC search_pnld_livros
        try:
            result = self.supabase.rpc(
                'search_pnld_livros',
                {
                    'query_embedding': query_embedding,
                    'match_threshold': match_threshold,
                    'match_count': match_count
                }
            ).execute()
            
            if not result.data:
                print("   ⚠️ Nenhum conteúdo relevante encontrado")
                return ""
            
            print(f"   ✅ Encontrados {len(result.data)} trechos relevantes")
            
            # 3. Consolidar contexto
            contexto = "\n\n---\n\n".join([
                f"**Livro:** {row.get('livro_id', 'Desconhecido')}\\n"
                f"**Similaridade:** {row.get('similarity', 0):.2f}\\n"
                f"**Conteúdo:**\\n{row.get('content', '')}"
                for row in result.data
            ])
            
            return contexto
            
        except Exception as e:
            print(f"   ❌ Erro na busca: {e}")
            return ""
    
    def criar_roteiro_aula(self, tema: str, disciplina: str, ano_serie: str = None) -> dict:
        """
        Gera roteiro de aula com RAG (Retrieval Augmented Generation)
        
        Args:
            tema: Tema da aula
            disciplina: Disciplina (ex: História, Matemática)
            ano_serie: Ano/série (opcional)
        
        Returns:
            Dicionário com roteiro estruturado
        """
        print(f"💡 [PEDAGOGO] Gerando roteiro de aula...")
        print(f"   - Tema: {tema}")
        print(f"   - Disciplina: {disciplina}")
        print(f"   - Série: {ano_serie or 'Não especificado'}")
        
        # Recupera conhecimento relevante dos livros PNLD
        contexto = self.recuperar_conhecimento(tema, match_count=5)
        
        # Prompt para Gemini
        serie_info = f" para o {ano_serie}" if ano_serie else ""
        
        prompt = f"""
Você é um Especialista em Design Instrucional Sênior que cria roteiros de aula de alta qualidade.

TEMA: {tema}
DISCIPLINA: {disciplina}
SÉRIE: {ano_serie or 'Não especificado'}

CONTEXTO DOS LIVROS DO MEC (PNLD):
{contexto if contexto else "Não há contexto disponível dos livros PNLD."}

INSTRUÇÕES:
1. Crie um roteiro de aula COMPLETO e ESTRUTURADO{serie_info}
2. Baseie-se no contexto fornecido dos livros PNLD
3. Seja moderno, dialógico e engajador
4. Inclua atividades práticas e dinâmicas
5. Adicione curiosidades interdisciplinares

FORMATO DE SAÍDA (JSON):
{{
    "disciplina": "{disciplina}",
    "tema": "{tema}",
    "ano_serie": "{ano_serie or 'Geral'}",
    "objetivos": ["objetivo1", "objetivo2", ...],
    "duracao_minutos": 50,
    "conceito": "Explicação clara e acessível do conceito principal",
    "desenvolvimento": [
        {{"etapa": "Introdução", "atividade": "...", "tempo_min": 10}},
        {{"etapa": "Desenvolvimento", "atividade": "...", "tempo_min": 25}},
        {{"etapa": "Conclusão", "atividade": "...", "tempo_min": 15}}
    ],
    "atividade_pratica": "Descrição detalhada de uma atividade hands-on",
    "recursos": ["recurso1", "recurso2"],
    "curiosidade": "Fato interessante ou conexão interdisciplinar",
    "avaliacao": "Como avaliar o aprendizado",
    "referencias_pnld": ["livro1", "livro2"]
}}

Retorne APENAS o JSON, sem markdown.
"""
        
        try:
            # Gerar resposta com Gemini
            response = self.gemini_client.models.generate_content(
                model="gemini-2.0-flash",
                contents=[prompt],
                config=types.GenerateContentConfig(
                    temperature=0.7,
                    top_p=0.95
                )
            )
            
            # Limpar resposta (remover markdown se houver)
            resposta_texto = response.text.strip()
            
            if "```json" in resposta_texto:
                resposta_texto = resposta_texto.split("```json")[1].split("```")[0]
            elif "```" in resposta_texto:
                resposta_texto = resposta_texto.split("```")[1].split("```")[0]
            
            # Parse JSON
            roteiro = json.loads(resposta_texto)
            
            print("✅ [PEDAGOGO] Roteiro gerado com sucesso!")
            return roteiro
            
        except json.JSONDecodeError as e:
            print(f"❌ [PEDAGOGO] Erro ao decodificar JSON: {e}")
            print(f"Resposta bruta:\n{resposta_texto[:500]}...")
            return None
        except Exception as e:
            print(f"❌ [PEDAGOGO] Erro ao gerar roteiro: {e}")
            return None


if __name__ == "__main__":
    # Teste rápido
    print("\n" + "="*60)
    print(" TESTE DO AGENTE PEDAGOGO ")
    print("="*60 + "\n")
    
    try:
        pedagogo = AgentePedagogo()
        
        # Teste de busca
        print("\n🧪 Testando recuperação de conhecimento...")
        contexto = pedagogo.recuperar_conhecimento("Revolução Industrial", match_count=2)
        if contexto:
            print(f"\nContexto recuperado ({len(contexto)} caracteres):\n{contexto[:300]}...\n")
        
        # Teste de geração de roteiro
        print("\n🧪 Testando geração de roteiro...")
        roteiro = pedagogo.criar_roteiro_aula(
            tema="Revolução Industrial",
            disciplina="História",
            ano_serie="9º ano"
        )
        
        if roteiro:
            print("\n" + "="*60)
            print(" ROTEIRO GERADO ")
            print("="*60)
            print(json.dumps(roteiro, indent=2, ensure_ascii=False))
            
            # Opcional: Integrar com Designer
            print("\n💡 Para gerar material visual, use:")
            print("   from agents.designer import agente_designer")
            print("   agente_designer.gerar_material_design(roteiro)")
        
    except Exception as e:
        print(f"\n❌ Erro no teste: {e}")
        import traceback
        traceback.print_exc()
