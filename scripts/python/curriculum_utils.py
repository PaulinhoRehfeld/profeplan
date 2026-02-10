import re

def extrair_codigo(texto: str) -> str:
    """Extrai codigos de habilidades como (EM13CHS101) ou (EF01HI01)."""
    if not texto:
        return "CURRICULO_BASE"
    match = re.search(r"\(([A-Z]{2}\d+[A-Z\d]+)\)", texto)
    return match.group(1) if match else "CURRICULO_BASE"
