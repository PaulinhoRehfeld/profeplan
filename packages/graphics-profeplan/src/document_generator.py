#!/usr/bin/env python3
"""
Document Generator Service - Graphics Profeplan
================================================
Geração profissional de documentos DOCX/PDF usando templates.
"""

import os
import sys
import json
from pathlib import Path
from typing import Dict, Any, Literal
from datetime import datetime
from dotenv import load_dotenv

# Carregar variáveis de ambiente
load_dotenv()

try:
    from docxtpl import DocxTemplate
    from docx import Document
except ImportError:
    print("❌ Erro: Instale as dependências com: pip install -r requirements.txt")
    sys.exit(1)


class DocumentGenerator:
    """Gerador principal de documentos."""
    
    def __init__(self, templates_dir: str = None, output_dir: str = None):
        """
        Inicializa o gerador.
        
        Args:
            templates_dir: Diretório dos templates DOCX
            output_dir: Diretório de saída dos documentos
        """
        # Diretórios
        self.base_dir = Path(__file__).parent.parent
        self.templates_dir = Path(templates_dir) if templates_dir else self.base_dir / "templates"
        self.output_dir = Path(output_dir) if output_dir else self.base_dir / "output"
        
        # Criar diretório de saída se não existir
        self.output_dir.mkdir(parents=True, exist_ok=True)
    
    def list_templates(self) -> list[str]:
        """Lista templates disponíveis."""
        if not self.templates_dir.exists():
            return []
        
        templates = []
        for file in self.templates_dir.glob("*.docx"):
            if not file.name.startswith("~"):  # Ignorar arquivos temporários do Word
                templates.append(file.stem)
        
        return templates
    
    def generate_docx(
        self,
        template_name: str,
        data: Dict[str, Any],
        output_filename: str = None
    ) -> Path:
        """
        Gera um documento DOCX a partir de um template.
        
        Args:
            template_name: Nome do template (sem extensão)
            data: Dados para preencher o template
            output_filename: Nome do arquivo de saída (opcional)
        
        Returns:
            Caminho do arquivo gerado
        """
        # Validar template
        template_path = self.templates_dir / f"{template_name}.docx"
        if not template_path.exists():
            raise FileNotFoundError(f"Template não encontrado: {template_path}")
        
        print(f"📄 Gerando documento do template: {template_name}")
        
        # Carregar template
        doc = DocxTemplate(template_path)
        
        # Adicionar metadados extras
        context = {
            **data,
            "data_geracao": datetime.now().strftime("%d/%m/%Y"),
            "hora_geracao": datetime.now().strftime("%H:%M"),
        }
        
        # Renderizar
        doc.render(context)
        
        # Nome do arquivo de saída
        if not output_filename:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_filename = f"{template_name}_{timestamp}.docx"
        
        # Salvar
        output_path = self.output_dir / output_filename
        doc.save(output_path)
        
        print(f"✅ Documento gerado: {output_path}")
        return output_path
    
    def generate_pdf(
        self,
        template_name: str,
        data: Dict[str, Any],
        output_filename: str = None
    ) -> Path:
        """
        Gera um documento PDF a partir de um template.
        
        Args:
            template_name: Nome do template
            data: Dados para preencher
            output_filename: Nome do arquivo de saída
        
        Returns:
            Caminho do arquivo PDF gerado
        """
        # Primeiro, gerar DOCX
        docx_filename = f"temp_{datetime.now().strftime('%Y%m%d_%H%M%S')}.docx"
        docx_path = self.generate_docx(template_name, data, docx_filename)
        
        # Converter para PDF (usando LibreOffice ou outro conversor)
        # Por simplicidade, vamos retornar o DOCX por enquanto
        # Em produção, você usaria: unoconv, LibreOffice CLI, ou WeasyPrint
        
        print("⚠️ Conversão DOCX → PDF requer LibreOffice/unoconv instalado")
        print(f"   DOCX disponível em: {docx_path}")
        
        # Renomear output se necessário
        if output_filename:
            final_path = self.output_dir / output_filename.replace('.pdf', '.docx')
            docx_path.rename(final_path)
            return final_path
        
        return docx_path
    
    def generate(
        self,
        template: str,
        data: Dict[str, Any],
        output_format: Literal["docx", "pdf"] = "docx",
        output_filename: str = None
    ) -> Path:
        """
        Método unificado de geração.
        
        Args:
            template: Nome do template
            data: Dados para preencher
            output_format: Formato de saída ('docx' ou 'pdf')
            output_filename: Nome do arquivo de saída
        
        Returns:
            Caminho do arquivo gerado
        """
        if output_format == "docx":
            return self.generate_docx(template, data, output_filename)
        elif output_format == "pdf":
            return self.generate_pdf(template, data, output_filename)
        else:
            raise ValueError(f"Formato inválido: {output_format}")


def main():
    """Função principal para testes."""
    print("🖨️ GRÁFICA PROFEPLAN - Document Generator")
    print("=" * 50)
    
    # Inicializar
    generator = DocumentGenerator()
    
    # Listar templates disponíveis
    templates = generator.list_templates()
    
    if not templates:
        print("❌ Nenhum template encontrado!")
        print(f"   Adicione templates (.docx) em: {generator.templates_dir}")
        print("\n💡 Exemplo de template:")
        print("   Crie um arquivo Word com: {{ disciplina }}, {{ ano_serie }}, etc.")
        return
    
    print(f"✅ Templates disponíveis: {', '.join(templates)}")
    
    # Dados de exemplo
    sample_data = {
        "escola": "EE Professor João Silva",
        "disciplina": "Matemática",
        "ano_serie": "6º Ano EF",
        "trimestre": "1º Trimestre",
        "professor": "Maria Santos",
        "unidades": [
            {
                "titulo": "Números e Operações",
                "habilidades": ["EF06MA01", "EF06MA02"],
                "objetos": ["Sistema de numeração decimal"]
            }
        ]
    }
    
    # Gerar documento de teste (apenas se template existir)
    if templates:
        try:
            output = generator.generate(
                template=templates[0],
                data=sample_data,
                output_format="docx"
            )
            print(f"\n✅ Documento de teste gerado em: {output}")
        except Exception as e:
            print(f"\n⚠️ Erro ao gerar documento de teste: {e}")
    
    print("\n" + "=" * 50)
    print("✅ Gráfica pronta para uso!")


if __name__ == "__main__":
    main()
