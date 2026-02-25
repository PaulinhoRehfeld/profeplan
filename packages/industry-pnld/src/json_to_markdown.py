"""
JSON to Markdown Converter - PNLD Books
Converte arquivos JSON de livros PNLD para Markdown legível
Facilita auditoria humana e revisão de qualidade
"""

import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any


class PnldJsonToMarkdownConverter:
    """Conversor de JSON PNLD para Markdown"""
    
    def convert_file(self, json_path: Path, output_dir: Path) -> Path:
        """
        Converte um arquivo JSON para Markdown
        
        Args:
            json_path: Caminho do JSON de entrada
            output_dir: Diretório de saída para MD
            
        Returns:
            Path do arquivo MD criado
        """
        # Carregar JSON
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Gerar Markdown
        md_content = self._generate_markdown(data, json_path.stem)
        
        # Salvar
        output_path = output_dir / f"{json_path.stem}.md"
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
        
        return output_path
    
    def _generate_markdown(self, data: Dict[str, Any], filename: str) -> str:
        """Gera conteúdo Markdown a partir dos dados JSON"""
        
        # Parse metadados do JSON
        metadata = data.get('metadata', {})
        livro_titulo = metadata.get('livro_titulo', 'Título não especificado')
        disciplina = metadata.get('disciplina', 'N/A')
        editora = metadata.get('editora', 'N/A')
        colecao = metadata.get('colecao', 'N/A')
        arquivo_origem = metadata.get('arquivo_origem', filename)
        
        conteudo = data.get('conteudo_vetorial', [])
        total_fragmentos = len(conteudo)
        
        # Calcular estatísticas
        fragmentos_validos = sum(1 for f in conteudo if f.get('texto_limpo', '').strip())
        taxa_validos = (fragmentos_validos / total_fragmentos * 100) if total_fragmentos > 0 else 0
        
        # Começar Markdown
        md = f"""# {livro_titulo}

## 📚 Metadados

| Campo | Valor |
|-------|-------|
| **Disciplina** | {disciplina} |
| **Editora** | {editora} |
| **Coleção** | {colecao} |
| **Arquivo Origem** | `{arquivo_origem}` |
| **Total de Fragmentos** | {total_fragmentos} |
| **Fragmentos Válidos** | {fragmentos_validos} ({taxa_validos:.1f}%) |

---

## 📖 Conteúdo Extraído

"""
        
        # Adicionar fragmentos
        for i, fragmento in enumerate(conteudo, 1):
            pagina = fragmento.get('pagina', 'N/A')
            capitulo = fragmento.get('capitulo', 'Sem capítulo')
            texto = fragmento.get('texto_limpo', '')
            
            # Indicador de qualidade
            status = "✅" if texto.strip() else "⚠️ Vazio"
            
            md += f"""### Fragmento {i} {status}

**Página:** {pagina} | **Capítulo:** {capitulo}

"""
            
            if texto.strip():
                # Limitar tamanho para MD legível (primeiros 500 chars)
                texto_preview = texto[:500]
                if len(texto) > 500:
                    texto_preview += f"\n\n*... ({len(texto) - 500} caracteres restantes)*"
                
                md += f"""```
{texto_preview}
```

"""
            else:
                md += "*[Fragmento sem conteúdo de texto]*\n\n"
            
            md += "---\n\n"
        
        # Rodapé
        md += f"""
## 📊 Estatísticas

- **Total de Fragmentos:** {total_fragmentos}
- **Fragmentos Válidos:** {fragmentos_validos}
- **Fragmentos Vazios:** {total_fragmentos - fragmentos_validos}
- **Taxa de Extração:** {taxa_validos:.1f}%

---

*Gerado em: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*  
*Fonte: `{arquivo_origem}`*
"""
        
        return md
    
    def batch_convert(self, input_dir: Path, output_dir: Path) -> Dict[str, Any]:
        """
        Converte em lote todos os JSONs de um diretório
        
        Args:
            input_dir: Diretório com JSONs
            output_dir: Diretório para MDs
            
        Returns:
            Estatísticas da conversão
        """
        # Criar diretório de saída
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Buscar JSONs
        json_files = list(input_dir.glob('*.json'))
        
        print(f"🔍 Encontrados {len(json_files)} arquivos JSON em {input_dir}\n")
        
        converted = 0
        errors = []
        
        for json_path in json_files:
            try:
                md_path = self.convert_file(json_path, output_dir)
                print(f"✅ {json_path.name} → {md_path.name}")
                converted += 1
            except Exception as e:
                errors.append((json_path.name, str(e)))
                print(f"❌ {json_path.name} - Erro: {e}")
        
        # Resumo
        print(f"\n{'='*60}")
        print(f"📊 RESUMO")
        print(f"{'='*60}")
        print(f"✅ Convertidos: {converted}")
        print(f"❌ Erros: {len(errors)}")
        
        if errors:
            print(f"\n❌ ERROS DETALHADOS:")
            for filename, error in errors[:10]:
                print(f"  - {filename}: {error}")
        
        return {
            'total': len(json_files),
            'converted': converted,
            'errors': len(errors),
            'error_details': errors
        }


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Converte JSONs PNLD para Markdown')
    parser.add_argument('--input', type=str, required=True, help='Diretório com JSONs')
    parser.add_argument('--output', type=str, required=True, help='Diretório para MDs')
    
    args = parser.parse_args()
    
    converter = PnldJsonToMarkdownConverter()
    stats = converter.batch_convert(
        Path(args.input),
        Path(args.output)
    )
    
    print(f"\n✅ Conversão completa!")
    print(f"Taxa de sucesso: {stats['converted']/stats['total']*100:.1f}%")
