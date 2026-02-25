#!/usr/bin/env python3
"""
Pipeline MG - Processador de Currículo com Guardrails
=======================================================
Extrai dados estruturados dos PDFs da SEEMG e valida usando Guardrails AI.
"""

import os
import sys
import json
import re
from pathlib import Path
from typing import Dict, List, Any
from dotenv import load_dotenv

# Carregar variáveis de ambiente
load_dotenv()

try:
    import google.generativeai as genai
    from supabase import create_client, Client
except ImportError:
    print("❌ Erro: Instale as dependências com: pip install -r requirements.txt")
    sys.exit(1)

# Configurações
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not all([GEMINI_API_KEY, SUPABASE_URL, SUPABASE_KEY]):
    print("❌ Erro: Configure as variáveis de ambiente no .env")
    sys.exit(1)

# Inicializar clientes
genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-2.0-flash-exp')
embedding_model = 'models/text-embedding-004'
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


class BNCCValidator:
    """Validador de códigos BNCC."""
    
    # Padrão de códigos BNCC: EF06MA01, EM13CHS101, etc.
    BNCC_PATTERN = re.compile(r'^(EF|EM)\d{2}[A-Z]{2,3}\d{2}$')
    
    @classmethod
    def validate_code(cls, code: str) -> bool:
        """Valida se o código segue o padrão BNCC."""
        return bool(cls.BNCC_PATTERN.match(code.strip()))
    
    @classmethod
    def validate_list(cls, codes: List[str]) -> Dict[str, Any]:
        """Valida uma lista de códigos BNCC."""
        valid = []
        invalid = []
        
        for code in codes:
            if cls.validate_code(code):
                valid.append(code)
            else:
                invalid.append(code)
        
        return {
            "valid_codes": valid,
            "invalid_codes": invalid,
            "all_valid": len(invalid) == 0
        }


def extract_curriculum_from_pdf(pdf_path: str) -> Dict[str, Any]:
    """
    Extrai dados estruturados do PDF usando Gemini.
    
    Args:
        pdf_path: Caminho para o PDF do currículo
    
    Returns:
        Dados estruturados do currículo
    """
    print(f"📄 Processando PDF: {pdf_path}")
    
    # Upload do arquivo para Gemini
    uploaded_file = genai.upload_file(pdf_path)
    
    # Prompt estruturado para extração
    prompt = """
Você é um especialista em currículo educacional brasileiro.

Analise este PDF do planejamento trimestral da SEEMG e extraia as seguintes informações em formato JSON:

{
  "disciplina": "Nome da disciplina",
  "ano_serie": "Ano ou série escolar (ex: 6º Ano EF, 1º Ano EM)",
  "nivel_ensino": "Ensino Fundamental ou Ensino Médio",
  "trimestres": [
    {
      "numero": 1,
      "unidades_tematicas": [
        {
          "titulo": "Nome da unidade temática",
          "habilidades_bncc": ["EF06MA01", "EF06MA02"],
          "objetos_conhecimento": ["Objeto 1", "Objeto 2"]
        }
      ]
    }
  ]
}

REGRAS CRÍTICAS:
1. Os códigos BNCC devem seguir EXATAMENTE o padrão: EF ou EM + 2 dígitos + 2-3 letras + 2 dígitos
2. Exemplos válidos: EF06MA01, EM13CHS101, EF67EF01
3. NÃO invente códigos. Se não encontrar, deixe o array vazio.
4. Extraia APENAS informações presentes no documento.

Retorne APENAS o JSON, sem explicações.
"""
    
    # Gerar resposta
    response = model.generate_content([uploaded_file, prompt])
    
    # Limpar resposta (remover markdown se houver)
    json_text = response.text.strip()
    if json_text.startswith("```json"):
        json_text = json_text.split("```json")[1].split("```")[0].strip()
    elif json_text.startswith("```"):
        json_text = json_text.split("```")[1].split("```")[0].strip()
    
    # Parse JSON
    try:
        data = json.loads(json_text)
    except json.JSONDecodeError as e:
        print(f"❌ Erro ao parsear JSON: {e}")
        print(f"Resposta bruta: {json_text[:500]}")
        sys.exit(1)
    
    return data


def validate_with_guardrails(data: Dict[str, Any]) -> Dict[str, Any]:
    """
    Valida os dados extraídos usando regras de negócio.
    
    Args:
        data: Dados extraídos do PDF
    
    Returns:
        Dados validados ou erros
    """
    print("🛡️ Validando dados com Guardrails...")
    
    errors = []
    warnings = []
    
    # Validar estrutura básica
    required_fields = ["disciplina", "ano_serie", "trimestres"]
    for field in required_fields:
        if field not in data:
            errors.append(f"Campo obrigatório ausente: {field}")
    
    if errors:
        return {"valid": False, "errors": errors}
    
    # Validar códigos BNCC em cada trimestre
    for trimestre in data.get("trimestres", []):
        trimestre_num = trimestre.get("numero")
        for unidade in trimestre.get("unidades_tematicas", []):
            habilidades = unidade.get("habilidades_bncc", [])
            validation = BNCCValidator.validate_list(habilidades)
            
            if not validation["all_valid"]:
                warning_msg = (
                    f"Trimestre {trimestre_num}, Unidade '{unidade.get('titulo')}': "
                    f"Códigos BNCC inválidos encontrados: {validation['invalid_codes']}"
                )
                warnings.append(warning_msg)
                # Filtrar apenas códigos válidos
                unidade["habilidades_bncc"] = validation["valid_codes"]
    
    if warnings:
        print("⚠️ Avisos de validação:")
        for warning in warnings:
            print(f"  - {warning}")
    
    return {
        "valid": True,
        "data": data,
        "warnings": warnings
    }


def ingest_to_supabase(data: Dict[str, Any]) -> None:
    """
    Ingere os dados validados no Supabase.
    
    Args:
        data: Dados validados do currículo
    """
    print("📤 Ingerindo dados no Supabase...")
    
    disciplina = data.get("disciplina")
    ano_serie = data.get("ano_serie")
    nivel_ensino = data.get("nivel_ensino")
    
    total_inserted = 0
    
    for trimestre in data.get("trimestres", []):
        trimestre_num = trimestre.get("numero")
        
        for unidade in trimestre.get("unidades_tematicas", []):
            # Criar fragmento de texto para embedding
            content = f"""
Disciplina: {disciplina}
Ano/Série: {ano_serie}
Nível: {nivel_ensino}
Trimestre: {trimestre_num}
Unidade Temática: {unidade.get('titulo')}

Habilidades BNCC:
{', '.join(unidade.get('habilidades_bncc', []))}

Objetos de Conhecimento:
{', '.join(unidade.get('objetos_conhecimento', []))}
""".strip()
            
            # Gerar embedding
            embedding_response = genai.embed_content(
                model=embedding_model,
                content=content,
                task_type="retrieval_document"
            )
            embedding = embedding_response['embedding']
            
            # Metadados estruturados
            metadata = {
                "disciplina": disciplina,
                "ano_serie": ano_serie,
                "nivel_ensino": nivel_ensino,
                "trimestre": trimestre_num,
                "unidade_tematica": unidade.get("titulo"),
                "habilidades_bncc": unidade.get("habilidades_bncc", []),
                "objetos_conhecimento": unidade.get("objetos_conhecimento", [])
            }
            
            # Inserir no Supabase
            try:
                supabase.table("curriculos_mg").insert({
                    "content": content,
                    "metadata": metadata,
                    "embedding": embedding
                }).execute()
                total_inserted += 1
            except Exception as e:
                print(f"❌ Erro ao inserir: {e}")
    
    print(f"✅ {total_inserted} registros inseridos com sucesso!")


def main():
    """Função principal do pipeline."""
    print("🏭 INDÚSTRIA DO CURRÍCULO - Pipeline MG")
    print("=" * 50)
    
    # Definir caminho do PDF (exemplo)
    data_dir = Path(__file__).parent.parent / "data"
    pdf_files = list(data_dir.glob("*.pdf"))
    
    if not pdf_files:
        print(f"❌ Nenhum PDF encontrado em {data_dir}")
        print("   Coloque os PDFs do currículo da SEEMG na pasta 'data/'")
        return
    
    for pdf_path in pdf_files:
        print(f"\n📌 Processando: {pdf_path.name}")
        
        # Passo 1: Extração
        raw_data = extract_curriculum_from_pdf(str(pdf_path))
        
        # Passo 2: Validação
        validation_result = validate_with_guardrails(raw_data)
        
        if not validation_result["valid"]:
            print(f"❌ Validação falhou: {validation_result['errors']}")
            continue
        
        # Passo 3: Ingestão
        validated_data = validation_result["data"]
        ingest_to_supabase(validated_data)
        
        # Salvar JSON de saída
        output_file = data_dir / f"{pdf_path.stem}_output.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(validated_data, f, ensure_ascii=False, indent=2)
        
        print(f"💾 Dados salvos em: {output_file}")
    
    print("\n" + "=" * 50)
    print("✅ Pipeline concluído!")


if __name__ == "__main__":
    main()
