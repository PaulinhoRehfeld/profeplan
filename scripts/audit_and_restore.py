import os
import glob
import json
import re

# Configuration
INGEST_DATA_DIR = r"c:\Users\Admin\PROFEPLAN\PROFEPLAN\ingest_data"
MD_OUTPUT_DIR = r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\MD"

def normalize_filename(json_filename):
    # Expected format: update_packet_1°ANO_SOCIOLOGIA_ENSINO_MÉDIO_1TRI.json
    # Target format: 1ANO_EM_SOCIOLOGIA.md
    
    name = os.path.basename(json_filename)
    name = name.replace("update_packet_", "").replace(".json", "")
    
    parts = name.split('_')
    
    # Heuristics extraction
    ano_raw = parts[0] # 1°ANO
    
    # Extract Discipline (can be multiple words in middle)
    # We look for where "ENSINO" starts to find the end of discipline
    try:
        idx_ensino = parts.index("ENSINO")
    except ValueError:
        # Fallback if naming varies
        idx_ensino = -2 
        
    disc_parts = parts[1:idx_ensino]
    disciplina_raw = "_".join(disc_parts)
    
    nivel_raw = "EM" if "MÉDIO" in name or "MEDIO" in name else "EF"
    
    # Normalize Ano
    ano = ano_raw.replace("°", "").replace("º", "") # 1ANO
    
    # Normalize Disciplina
    # Remove accents for filename safety if desired, but code handles accents.
    # We want valid matches for the ingestion script which expects CAPS usually?
    # actually ingest_curriculo_rag.py doesn't force caps but title().
    # Let's keep it simple: 1ANO_EM_DISCIPLINA.md
    
    disciplina_clean = disciplina_raw.replace("LÍNGUA_", "").replace("LINGUA_", "") # OPTIONAL simplification
    # Keep it full to avoid collisions
    disciplina_final = disciplina_raw
    
    # Fix for composite names if needed, but underscore is the separator in split
    # ingest_curriculo_rag splits by '_' so we must be careful.
    # It expects: RAIO_NIVEL_MATERIA.md (3 parts)
    
    # Ideally: 1ANO_EM_SOCIOLOGIA.md
    # If discipline has underscores: 1ANO_EM_LINGUA_PORTUGUESA.md
    # The ingestion script:
    # parts = nome_arquivo.replace('.md', '').split('_')
    # if len(parts) >= 3: raw_ano = parts[0], raw_nivel = parts[1], raw_disc = parts[2]
    # discipline = raw_disc.title()
    # It seems it takes ONLY the 3rd part as discipline?
    # "raw_disc = parts[2]" -> Yes. 
    # If the file is 1ANO_EM_LINGUA_PORTUGUESA.md, parts=['1ANO','EM','LINGUA','PORTUGUESA']
    # raw_disc = 'LINGUA'
    # Then logic: if "Lingua" in disciplina: disciplina = raw_disc.replace("LINGUA", "Língua ").title()
    # Wait, raw_disc is JUST 'LINGUA'. The rest is ignored?
    # Let's check ingest_curriculo_rag.py line 109: `raw_disc = parts[2]`
    # line 123: `disciplina = raw_disc.title()`
    # It seems the current ingestion script is naive for multi-word disciplines named with underscores.
    # IT DOES NOT JOIN THE REST.
    # However, for 'SOCIOLOGIA', it works.
    # For 'LÍNGUA_PORTUGUESA', it might just read 'Língua'.
    # But usually these files use a specific map or just one word?
    
    # Let's stick to generating a file that makes sense.
    
    return f"{ano}_{nivel_raw}_{disciplina_final}.md"

def reconstruct_md(json_path, target_md_path):
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        # Extract content
        conteudo_vetorial = data.get("conteudo_vetorial", [])
        if not conteudo_vetorial:
            print(f"Skipping {json_path}: No vector content.")
            return False

        # Metadata
        disciplina = data.get("disciplina", "Unknown")
        nivel = data.get("nivel", "Unknown")
        # Extract Year/Period from filename or content?
        # The JSON usually has 'capitulo': '1° TRIMESTRE'
        
        # We construct a consolidated MD
        md_content = f"# {disciplina}\n"
        
        # Infer Year from filename logic
        basename = os.path.basename(json_path)
        if "1°ANO" in basename: year = "1º Ano EM"
        elif "2°ANO" in basename: year = "2º Ano EM"
        elif "3°ANO" in basename: year = "3º Ano EM"
        else: year = "N/A"
        
        md_content += f"## {year}\n"
        
        # Group by Period (Capitulo)
        # Assuming one packet = one trimester, but let's be safe
        current_period = ""
        
        for item in conteudo_vetorial:
            periodo = item.get("capitulo", "Geral")
            if periodo != current_period:
                md_content += f"### {periodo}\n"
                current_period = periodo
            
            texto = item.get("texto_limpo", "")
            md_content += f"{texto}\n\n"
            
        # Ensure dir exists
        os.makedirs(os.path.dirname(target_md_path), exist_ok=True)
        
        with open(target_md_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
            
        return True
    except Exception as e:
        print(f"Error reading JSON {json_path}: {e}")
        return False

def audit():
    print("--- Starting Audit ---")
    json_files = glob.glob(os.path.join(INGEST_DATA_DIR, "update_packet_*.json"))
    
    missing_count = 0
    restored_count = 0
    
    for json_file in json_files:
        expected_md_name = normalize_filename(json_file)
        expected_md_path = os.path.join(MD_OUTPUT_DIR, expected_md_name)
        
        if not os.path.exists(expected_md_path):
            print(f"MISSING: {expected_md_name}")
            print(f"  -> Restoring from {os.path.basename(json_file)}...")
            if reconstruct_md(json_file, expected_md_path):
                print("  -> RESTORED.")
                restored_count += 1
            else:
                print("  -> FAILED to restore.")
            missing_count += 1
        else:
            # print(f"OK: {expected_md_name}")
            pass
            
    print(f"\nAudit Complete.")
    print(f"Missing Files Found: {missing_count}")
    print(f"Files Restored: {restored_count}")

if __name__ == "__main__":
    audit()
