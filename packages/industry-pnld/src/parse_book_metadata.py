"""
Parser de Metadados PNLD
Extrai informações estruturadas dos nomes de arquivo seguindo padrão:
DISCIPLINA_EDITORA_COLEÇÃO_NºANO[_UNICO].pdf

Exemplos:
- MATEMATICA_FTD_360_1ANO_UNICO.pdf
- HISTORIA_MODERNA_CONEXOES_2ANO.pdf
- PORTUGUES_ATICA_LINGUAGENS_3SERIE_EF.pdf
"""

import re
from typing import Dict, Optional
from pathlib import Path


class PnldBookMetadataParser:
    """Parser para extrair metadados de nomes de arquivo PNLD"""
    
    # Mapeamento de variações de disciplinas
    DISCIPLINA_MAP = {
        'MATEMATICA': 'Matemática',
        'HISTORIA': 'História',
        'GEOGRAFIA': 'Geografia',
        'PORTUGUES': 'Língua Portuguesa',
        'INGLES': 'Língua Inglesa',
        'FISICA': 'Física',
        'QUIMICA': 'Química',
        'BIOLOGIA': 'Biologia',
        'FILOSOFIA': 'Filosofia',
        'SOCIOLOGIA': 'Sociologia',
        'ARTES': 'Artes',
        'EDFISICA': 'Educação Física',
        'EDUCACAODIGITAL': 'Educação Digital',
        'REDACAO': 'Redação',
    }
    
    def parse_filename(self, filename: str) -> Optional[Dict]:
        """
        Extrai metadados do nome do arquivo
        
        Args:
            filename: Nome do arquivo (com ou sem .pdf)
            
        Returns:
            Dict com metadados ou None se parsing falhar
        """
        # Remove extensão e espaços
        clean_name = filename.replace('.pdf', '').replace('.PDF', '').strip()
        
        # Split por underscore
        parts = clean_name.split('_')
        
        if len(parts) < 4:
            print(f"⚠️ Formato inválido (precisa 4+ partes): {filename}")
            return None
        
        # Extração básica
        disciplina_raw = parts[0].upper()
        editora = parts[1].title()
        colecao = parts[2].title()
        ano_info = parts[3]
        
        # Normalizar disciplina
        disciplina = self.DISCIPLINA_MAP.get(
            disciplina_raw.replace(' ', ''),
            disciplina_raw.title()
        )
        
        # Detectar se é Volume Único
        is_unico = 'UNICO' in [p.upper() for p in parts]
        volume = 'Único' if is_unico else self._extract_volume(parts)
        
        # Extrair ano/série e nível
        ano_serie, nivel_ensino = self._parse_ano_serie(ano_info)
        
        # Montar título
        titulo = self._build_title(colecao, disciplina, ano_serie, volume)
        
        return {
            'titulo': titulo,
            'disciplina': disciplina,
            'editora': editora,
            'colecao': colecao,
            'ano_serie': ano_serie,
            'nivel_ensino': nivel_ensino,
            'volume': volume,
            'arquivo_origem': filename,
        }
    
    def _extract_volume(self, parts: list) -> str:
        """Tenta extrair volume das partes"""
        for part in parts:
            if part.upper().startswith('VOL'):
                return part.title()
            if re.match(r'V\d+', part.upper()):
                num = part[1:]
                return f'Volume {num}'
        return 'N/A'
    
    def _parse_ano_serie(self, ano_info: str) -> tuple:
        """
        Extrai ano/série e nível de ensino
        
        Returns:
            (ano_serie, nivel_ensino)
        """
        ano_upper = ano_info.upper()
        
        # Detectar nível
        if 'EM' in ano_upper or 'MEDIO' in ano_upper:
            nivel = 'Ensino Médio'
            prefix = 'º Ano EM'
        elif 'EF' in ano_upper or 'FUND' in ano_upper or 'SERIE' in ano_upper:
            nivel = 'Ensino Fundamental'
            prefix = 'ª Série EF'
        else:
            # Default para EM se não especificado
            nivel = 'Ensino Médio'
            prefix = 'º Ano EM'
        
        # Extrair número
        num_match = re.search(r'(\d+)', ano_info)
        if num_match:
            num = num_match.group(1)
            if 'SERIE' in ano_upper or nivel == 'Ensino Fundamental':
                ano_serie = f'{num}ª Série EF'
            else:
                ano_serie = f'{num}º Ano EM'
        else:
            ano_serie = f'N/A {prefix}'
        
        return ano_serie, nivel
    
    def _build_title(self, colecao: str, disciplina: str, ano_serie: str, volume: str) -> str:
        """Monta o título legível do livro"""
        parts = [colecao, disciplina]
        
        if ano_serie != 'N/A':
            parts.append(f'({ano_serie})')
        
        if volume and volume not in ['N/A', 'Único']:
            parts.append(f'- {volume}')
        elif volume == 'Único':
            parts.append('- Volume Único')
        
        return ' - '.join(parts)


def test_parser():
    """Testa o parser com exemplos reais"""
    parser = PnldBookMetadataParser()
    
    test_cases = [
        'MATEMATICA_FTD_360_1ANO_UNICO.pdf',
        'HISTORIA_MODERNA_CONEXOES_2ANO.pdf',
        'PORTUGUES_ATICA_LINGUAGENS_3SERIE_EF.pdf',
        'FISICA_FTD_NATUREZA_1ANOEM.pdf',
        'EDUCACAODIGITAL_FTD_DIGITAL_UNICO.pdf',
    ]
    
    print("🧪 TESTANDO PARSER DE METADADOS PNLD\n")
    
    for filename in test_cases:
        result = parser.parse_filename(filename)
        if result:
            print(f"✅ {filename}")
            print(f"   Título: {result['titulo']}")
            print(f"   Disciplina: {result['disciplina']}")
            print(f"   Editora: {result['editora']}")
            print(f"   Ano/Série: {result['ano_serie']}")
            print(f"   Nível: {result['nivel_ensino']}")
            print()
        else:
            print(f"❌ {filename} - FALHOU\n")


if __name__ == '__main__':
    test_parser()
