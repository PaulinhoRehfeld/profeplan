import time
import os
import json
import glob
import sys
from integrador_pnld_livros import processar_livro

WATCH_DIR = "ingest_data"
TRIGGER_FILE = "READY_FOR_PROFEPLAN.trigger"
MANIFESTO_FILE = "manifesto_downloads.json"
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--once", action="store_true", help="Executa apenas um ciclo e encerra")
    args = parser.parse_args()

    print(f"🕵️‍♂️ Manager Agent iniciado. Monitorando pasta: {WATCH_DIR}")
    print(f"Gatilho esperado: {TRIGGER_FILE}")
    print("Pressione Ctrl+C para encerrar.")

    if not os.path.exists(WATCH_DIR):
        print(f"⚠️ Alerta: A pasta {WATCH_DIR} não existe. Aguardando criação...")

    while True:
        try:
            # Verifica se pasta existe antes de tentar ler
            if not os.path.exists(WATCH_DIR):
                time.sleep(5)
                continue

            trigger_path = os.path.join(WATCH_DIR, TRIGGER_FILE)
            
            if os.path.exists(trigger_path):
                print(f"\n🚨 Gatilho detectado! Iniciando protocolo de ingestão...")
                
                # Tenta ler o manifesto
                manifesto_path = os.path.join(WATCH_DIR, MANIFESTO_FILE)
                arquivos_para_processar = []
                
                if os.path.exists(manifesto_path):
                    print(f"📜 Manifesto encontrado: {MANIFESTO_FILE}")
                    try:
                        with open(manifesto_path, 'r', encoding='utf-8') as f:
                            dados_manifesto = json.load(f)
                            
                            # Suporte a lista simples ou objeto com chave 'arquivos'
                            if isinstance(dados_manifesto, list):
                                arquivos_para_processar = dados_manifesto
                            elif isinstance(dados_manifesto, dict) and "arquivos" in dados_manifesto:
                                arquivos_para_processar = dados_manifesto["arquivos"]
                            elif isinstance(dados_manifesto, dict):
                                # Tenta buscar chaves que pareçam listas de arquivos
                                print(f"⚠️ Estrutura exata do manifesto não identificada, mas arquivo carregado.")
                                # Implementar lógica extra se necessário
                    except Exception as e:
                        print(f"❌ Erro ao ler manifesto: {e}")
                
                # Fallback se manifesto não gerou lista
                if not arquivos_para_processar:
                    print(f"⚠️ Sem manifesto ou lista vazia. Buscando todos os 'update_packet_*.json' na pasta...")
                    arquivos_para_processar = glob.glob(os.path.join(WATCH_DIR, "update_packet_*.json"))
                
                # Normaliza caminhos
                caminhos_finais = []
                for arq in arquivos_para_processar:
                    # Se for dict (ex: metadados no manifesto), tenta pegar 'arquivo' ou 'caminho'
                    if isinstance(arq, dict):
                        nome_arq = arq.get("arquivo") or arq.get("caminho") or arq.get("file_name") or arq.get("filename")
                    else:
                        nome_arq = arq
                    
                    if not nome_arq:
                        continue
                        
                    # Remove caminhos absolutos se vierem do glob apenas para garantir consistência ou reconstrói
                    # Mas se vier do manifesto, pode ser só o nome
                    
                    possivel_caminho_absoluto = os.path.abspath(nome_arq) # Caso já seja path completo
                    possivel_caminho_relativo = os.path.join(WATCH_DIR, os.path.basename(nome_arq)) # Caso seja só nome
                    
                    if os.path.exists(nome_arq):
                         caminhos_finais.append(nome_arq)
                    elif os.path.exists(possivel_caminho_relativo):
                        caminhos_finais.append(possivel_caminho_relativo)
                    else:
                        print(f"❌ Arquivo listado não encontrado: {nome_arq}")

                # Processamento
                if caminhos_finais:
                    print(f"🚀 Iniciando processamento de {len(caminhos_finais)} arquivos.")
                    total_sucessos = 0
                    for caminho in caminhos_finais:
                        try:
                            # Chama a função do integrador importado
                            total_sucessos += processar_livro(caminho)
                        except Exception as e:
                            print(f"🔥 Erro crítico ao processar {caminho}: {e}")

                    print(f"✅ Ciclo de ingestão concluído. Total de registros integrados: {total_sucessos}")
                else:
                    print("⚠️ Nenhum arquivo válido encontrado para ingestão.")

                # Remove gatilho
                try:
                    os.remove(trigger_path)
                    print(f"🗑️ Gatilho removido. Aguardando próximo ciclo...")
                except Exception as e:
                    print(f"❌ Erro ao remover gatilho: {e}") 

            if args.once:
                print("🏁 Modo --once ativado. Encerrando.")
                break

            time.sleep(5)
            
        except KeyboardInterrupt:
            print("\n🛑 Encerrando Manager Agent...")
            break
        except Exception as e:
            print(f"\n🔥 Erro inesperado no loop principal: {e}")
            time.sleep(5)

if __name__ == "__main__":
    main()
