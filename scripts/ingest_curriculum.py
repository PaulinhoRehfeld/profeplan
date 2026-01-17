import pandas as pd
import json
# Supondo que você use langchain ou openai direto para embeddings
# Você precisará instalar: pip install langchain-google-genai google-generativeai
from langchain_google_genai import GoogleGenerativeAIEmbeddings 
import os

class CurriculoProcessor:
    def __init__(self, estado="MG", ano_vigencia=2026):
        self.estado = estado
        self.ano = ano_vigencia
        
        # Tenta pegar a API KEY do ambiente
        api_key = os.getenv("GOOGLE_API_KEY")
        if not api_key:
            print("⚠️ AVISO: GOOGLE_API_KEY não encontrada nas variáveis de ambiente.")
        
        # Configuração do modelo de Embeddings
        # Certifique-se de ter configurado a chave de API corretamente
        self.embeddings = GoogleGenerativeAIEmbeddings(model="models/text-embedding-004", google_api_key=api_key)

    def definir_periodos(self, sistema: str):
        """
        Define as chaves de período baseado no sistema do estado/ano.
        Retorna uma lista de strings que serão salvas na coluna 'periodo'.
        """
        sistema = sistema.lower().strip()
        if sistema == 'trimestral':
            return ["1º Trimestre", "2º Trimestre", "3º Trimestre"]
        elif sistema == 'bimestral':
            return ["1º Bimestre", "2º Bimestre", "3º Bimestre", "4º Bimestre"]
        else:
            raise ValueError(f"Sistema de avaliação desconhecido: '{sistema}'. Use 'trimestral' ou 'bimestral'.")

    def processar_curriculo(self, dados_brutos, sistema_avaliacao='trimestral'):
        """
        Recebe os dados brutos (lista de dicts) e gera os vetores com o metadado correto.
        Normaliza a nomenclatura de tempo para a coluna 'periodo'.
        
        Espera que 'dados_brutos' tenha itens com chaves:
        - 'texto': A habilidade ou conteúdo
        - 'idx_tempo': O índice do período (0=1º, 1=2º...) OU 'nome_tempo' explícito
        - 'disciplina': A matéria
        """
        lista_periodos = self.definir_periodos(sistema_avaliacao)
        registros_processados = []

        print(f"🔄 Processando currículo de {self.estado} no sistema {sistema_avaliacao.upper()}...")

        for item in dados_brutos:
            # Lógica para identificar o período:
            # 1. Tenta pelo índice numérico (idx_tempo)
            # 2. Se não tiver índice, tenta mapear string existente se houver
            
            nome_periodo = "Geral/Anual" # Default
            
            if 'idx_tempo' in item and item['idx_tempo'] is not None:
                idx = int(item['idx_tempo'])
                if 0 <= idx < len(lista_periodos):
                    nome_periodo = lista_periodos[idx]
            elif 'nome_tempo' in item:
                # Se o dado bruto já vier com "1º Bimestre" ou similar, usamos ou validamos
                raw_tempo = item['nome_tempo']
                # Aqui poderia ter uma lógica de validação mais complexa se necessário
                nome_periodo = raw_tempo

            conteudo_para_vetorizar = f"{item.get('disciplina', '')}: {item.get('texto', '')}"
            
            # Gera o embedding
            try:
                vetor = self.embeddings.embed_query(conteudo_para_vetorizar)
            except Exception as e:
                print(f"❌ Erro ao gerar embedding para item: {item.get('texto', '')[:30]}... Erro: {e}")
                continue

            registro = {
                "disciplina": item.get('disciplina'),
                "periodo": nome_periodo,  # O campo 'periodo' unificado no banco
                "sistema_avaliacao": sistema_avaliacao, # Importante para filtrar no front se necessário
                "habilidade": item.get('texto'),
                "embedding": vetor,
                "metadata": {
                    "estado": self.estado,
                    "ano_vigencia": self.ano,
                    "objeto_conhecimento": item.get('objeto_conhecimento', '') # Se houver
                }
            }
            registros_processados.append(registro)

        print(f"✅ {len(registros_processados)} habilidades processadas.")
        return registros_processados

# --- EXEMPLO DE USO ---
if __name__ == "__main__":
    print("--- Script de Ingestão de Currículo ---")
    print("Este script define a classe CurriculoProcessor.")
    print("Para usar, importe a classe e chame processar_curriculo().")
    
    # Exemplo simulado (comentado para não rodar sem API KEY real)
    """
    # 1. Instanciar
    processor = CurriculoProcessor(estado="MG", ano_vigencia=2026)
    
    # 2. Dados de exemplo (simulando extração de PDF)
    dados_exemplo = [
        {'texto': 'Resolver equações do 2º grau', 'idx_tempo': 0, 'disciplina': 'Matemática', 'objeto_conhecimento': 'Álgebra'},
        {'texto': 'Analisar funções exponenciais', 'idx_tempo': 1, 'disciplina': 'Matemática', 'objeto_conhecimento': 'Funções'},
    ]
    
    # 3. Processar para sistema Trimestral
    # O script vai entender idx_tempo=0 -> "1º Trimestre"
    resultado_mg = processor.processar_curriculo(dados_exemplo, sistema_avaliacao='trimestral')
    
    print(f"Primeiro registro pro banco: {resultado_mg[0]['periodo']}") 
    # Saída esperada no print: "1º Trimestre"
    """
