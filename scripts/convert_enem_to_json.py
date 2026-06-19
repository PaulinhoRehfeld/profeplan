"""
Converte enem_questions_export.md → public/enem_questions.json
Formato de saída: array de objetos com id, ano, disciplina, conteudo, alternativas, gabarito
"""
import json
import re
import sys
from pathlib import Path

INPUT = Path("enem_questions_export.md")
OUTPUT = Path("apps/web/public/enem_questions.json")

def parse_questions(text: str) -> list[dict]:
    questions = []
    # Split by the separator
    blocks = re.split(r'={3,}\s*\n', text)
    
    for block in blocks:
        block = block.strip()
        if not block or not block.startswith('# Synced Question'):
            continue
        
        # Extract header
        header_match = re.match(r'# Synced Question (\d+)', block)
        if not header_match:
            continue
        qid = int(header_match.group(1))
        
        # Extract metadata
        ano_match = re.search(r'\*\*Ano:\*\*\s*(\d+)', block)
        disc_match = re.search(r'\*\*Disciplina:\*\*\s*([\w-]+)', block)
        
        ano = int(ano_match.group(1)) if ano_match else 0
        disciplina = disc_match.group(1) if disc_match else ''
        
        # Remove header lines and separator
        body = re.sub(r'^# Synced Question \d+\s*\n', '', block)
        body = re.sub(r'\*\*Ano:\*\*\s*\d+\s*\n', '', body)
        body = re.sub(r'\*\*Disciplina:\*\*\s*[\w-]+\s*\n', '', body)
        body = re.sub(r'^---\s*\n', '', body)
        body = body.strip()
        
        # Extract alternatives and correct answer
        alternativas = []
        gabarito = ''
        
        alt_pattern = re.findall(r'^([A-E])\)\s*(.+?)(?:\s*(?:✅|✓|\(CORRET[AO]\)))?\s*$', body, re.MULTILINE)
        correct_pattern = re.findall(r'^([A-E])\)\s*.+?\s*[✅✓]', body, re.MULTILINE)
        
        if correct_pattern:
            gabarito = correct_pattern[-1][0] if isinstance(correct_pattern[-1], tuple) else correct_pattern[-1]
        else:
            # Try (CORRETA) pattern
            correct_match = re.search(r'([A-E])\)\s*.+?\s*\(CORRET[AO]\)', body, re.IGNORECASE)
            if correct_match:
                gabarito = correct_match.group(1)
        
        # Clean up alternatives from body
        for match in re.finditer(r'^([A-E])\)\s*(.+?)$', body, re.MULTILINE):
            letter = match.group(1)
            text_alt = match.group(2).strip()
            # Remove checkmarks
            text_alt = re.sub(r'\s*[✅✓]\s*$', '', text_alt)
            text_alt = re.sub(r'\s*\(CORRET[AO]\)\s*$', '', text_alt, flags=re.IGNORECASE)
            alternativas.append({"letra": letter, "texto": text_alt})
        
        # Remove alternatives from content to get pure question text
        conteudo = body
        for alt in alternativas:
            conteudo = conteudo.replace(f"{alt['letra']}) {alt['texto']}", "")
        conteudo = re.sub(r'\n\s*\n\s*\n', '\n\n', conteudo).strip()
        
        questions.append({
            "id": qid,
            "ano": ano,
            "disciplina": disciplina,
            "conteudo": conteudo,
            "alternativas": alternativas,
            "gabarito": gabarito,
            # Search index fields (pre-computed for fast client-side search)
            "_searchText": (conteudo + ' ' + ' '.join(a['texto'] for a in alternativas)).lower()
        })
    
    return questions

def main():
    if not INPUT.exists():
        print(f"ERRO: {INPUT} não encontrado")
        sys.exit(1)
    
    text = INPUT.read_text(encoding='utf-8')
    questions = parse_questions(text)
    
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(questions, ensure_ascii=False), encoding='utf-8')
    
    size_kb = OUTPUT.stat().st_size / 1024
    print(f"✅ {len(questions)} questões convertidas → {OUTPUT} ({size_kb:.0f} KB)")

if __name__ == '__main__':
    main()
