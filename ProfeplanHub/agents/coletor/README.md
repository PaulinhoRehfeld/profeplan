# COLETOR - Web Scrapers Melhorados (Fase 4)

## Novidades na Versão Melhorada

### ✅ Modo Headless Configurável

Todos os scrapers agora suportam modo headless (sem UI):

```bash
# Modo com UI (padrão)
python coletor_ftd.py

# Modo headless
python coletor_ftd.py --headless

# Configurar padrão no .env
PLAYWRIGHT_HEADLESS=true
```

### ✅ Configuração Unificada

Os scrapers leem configurações de `ProfeplanHub/config/.env`:

```env
# Scrapers
PLAYWRIGHT_HEADLESS=false
DOWNLOAD_TIMEOUT_MS=30000
MAX_CONCURRENT_DOWNLOADS=3
```

### ✅ Paths Unificados

Output automático para `ProfeplanHub/data/raw_pdfs/`:

```
data/raw_pdfs/
├── ARTE/
├── BIOLOGIA/
├── GEOGRAFIA/
└── ...
```

## Uso

### Coletor FTD

```bash
cd agents/coletor
python coletor_ftd.py --headless --limit 10
```

**Argumentos:**
- `--dry-run` - Simular sem baixar
- `--limit N` - Limitar a N livros
- `--headless` - Modo sem UI

### Coletor Moderna

```bash
python coletor_moderna.py --headless
```

### Coletor PNLD Genérico

```bash
python coletor_pnld.py
# Login manual ainda necessário (CAPTCHA)
```

## Melhorias Implementadas

| Melhoria | Status | Benefício |
|----------|--------|-----------|
| Modo headless | ✅ | Rodar em servidor sem UI |
| Config do .env | ✅ | Centralizado |
| Paths unificados | ✅ | Integração com CODEX |
| Timeout configurável | ✅ | Adaptável por site |

## Próximas Melhorias (Futuro)

- [ ] Versionamento de livros (detectar atualizações)
- [ ] Retry logic para downloads
- [ ] Scheduler para atualizações periódicas
- [ ] Suporte a proxy/rate limiting
