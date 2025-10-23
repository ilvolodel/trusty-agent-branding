#!/bin/bash

# Script per configurare OpenHands con branding personalizzato
# Mantiene l'immagine Docker ufficiale e sovrascrive solo loghi e colori

set -e

echo "🎨 Setup OpenHands con branding personalizzato"
echo "=============================================="
echo ""

# Directory di lavoro
CUSTOM_DIR="$HOME/openhands-custom"

# Crea struttura cartelle
echo "📁 Creazione struttura cartelle..."
mkdir -p "$CUSTOM_DIR/frontend/assets"
mkdir -p "$CUSTOM_DIR/frontend/styles"
mkdir -p "$CUSTOM_DIR/public"

echo "✅ Cartelle create in: $CUSTOM_DIR"
echo ""

# Estrai i file originali dall'immagine Docker per poterli modificare
echo "📦 Estrazione file originali dall'immagine OpenHands..."

# Crea un container temporaneo per estrarre i file
CONTAINER_ID=$(docker create docker.all-hands.dev/all-hands-ai/openhands:0.59)

# Estrai i file rilevanti
echo "  - Estraendo assets..."
docker cp "$CONTAINER_ID:/app/frontend/build" "$CUSTOM_DIR/frontend/" 2>/dev/null || {
    echo "  ⚠️  Build frontend non trovato, provo con percorso alternativo..."
    docker cp "$CONTAINER_ID:/app/frontend/dist" "$CUSTOM_DIR/frontend/build" 2>/dev/null || {
        echo "  ℹ️  Frontend pre-buildato non disponibile nel container"
    }
}

# Pulisci container temporaneo
docker rm "$CONTAINER_ID" >/dev/null

echo "✅ File estratti"
echo ""

# Crea file di esempio per il logo
echo "🎨 Creazione file placeholder per personalizzazione..."

cat > "$CUSTOM_DIR/frontend/styles/custom-theme.css" << 'EOF'
/* File di personalizzazione colori OpenHands */
/* Modifica questi valori per personalizzare i colori dell'interfaccia */

:root {
  /* Colori primari */
  --color-primary: #3b82f6;           /* Blu principale */
  --color-primary-dark: #2563eb;      /* Blu scuro */
  --color-primary-light: #60a5fa;     /* Blu chiaro */
  
  /* Colori di sfondo */
  --color-bg-primary: #ffffff;        /* Sfondo principale */
  --color-bg-secondary: #f9fafb;      /* Sfondo secondario */
  --color-bg-tertiary: #f3f4f6;       /* Sfondo terziario */
  
  /* Colori del testo */
  --color-text-primary: #111827;      /* Testo principale */
  --color-text-secondary: #6b7280;    /* Testo secondario */
  
  /* Colori accent */
  --color-accent: #10b981;            /* Verde accent */
  --color-warning: #f59e0b;           /* Arancione avviso */
  --color-error: #ef4444;             /* Rosso errore */
  --color-success: #22c55e;           /* Verde successo */
  
  /* Bordi */
  --color-border: #e5e7eb;            /* Colore bordi */
  
  /* Ombre */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

/* Tema scuro (se applicabile) */
[data-theme="dark"] {
  --color-bg-primary: #1f2937;
  --color-bg-secondary: #111827;
  --color-bg-tertiary: #374151;
  --color-text-primary: #f9fafb;
  --color-text-secondary: #d1d5db;
  --color-border: #374151;
}

/* Applica colori personalizzati */
.bg-primary { background-color: var(--color-primary) !important; }
.text-primary { color: var(--color-primary) !important; }
.border-primary { border-color: var(--color-primary) !important; }

/* Personalizza il logo container se necessario */
.logo-container {
  /* Aggiungi qui eventuali stili per il contenitore del logo */
}
EOF

echo "✅ File CSS personalizzato creato"
echo ""

# Crea docker-compose.yml
echo "🐳 Creazione docker-compose.yml..."

cat > "$CUSTOM_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  openhands:
    image: docker.all-hands.dev/all-hands-ai/openhands:0.59
    container_name: openhands-custom
    restart: unless-stopped
    
    volumes:
      # Socket Docker per permettere a OpenHands di creare container
      - /var/run/docker.sock:/var/run/docker.sock
      
      # Directory per dati persistenti
      - ~/.openhands:/.openhands
      
      # ========================================
      # PERSONALIZZAZIONE: Monta i tuoi file custom
      # ========================================
      
      # CSS personalizzato per colori
      - ./frontend/styles/custom-theme.css:/app/frontend/dist/assets/custom-theme.css:ro
      
      # Logo personalizzato (decommentare dopo aver aggiunto il tuo logo)
      # - ./frontend/assets/logo.svg:/app/frontend/dist/assets/logo.svg:ro
      # - ./frontend/assets/logo.png:/app/frontend/dist/assets/logo.png:ro
      
      # Favicon (decommentare dopo aver aggiunto il tuo favicon)
      # - ./public/favicon.ico:/app/frontend/dist/favicon.ico:ro
    
    ports:
      - "3000:3000"
    
    environment:
      # Immagine runtime per i sandbox
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.59-nikolaik
      
      # Logging
      - LOG_ALL_EVENTS=true
      
      # Aggiungi qui altre variabili d'ambiente se necessario
      # - LLM_API_KEY=your-api-key
      # - LLM_MODEL=anthropic/claude-sonnet-4-5-20250929
    
    # Permetti connessione a host Docker
    extra_hosts:
      - "host.docker.internal:host-gateway"

networks:
  default:
    name: openhands-network
EOF

echo "✅ docker-compose.yml creato"
echo ""

# Crea README con istruzioni
cat > "$CUSTOM_DIR/README.md" << 'EOF'
# OpenHands - Configurazione Personalizzata

Questa directory contiene la configurazione per eseguire OpenHands con branding personalizzato.

## 📁 Struttura

```
openhands-custom/
├── docker-compose.yml              # Configurazione Docker Compose
├── frontend/
│   ├── assets/                     # 🎨 Metti qui i tuoi loghi
│   │   ├── logo.svg               # Logo in formato SVG (consigliato)
│   │   └── logo.png               # Logo in formato PNG
│   └── styles/
│       └── custom-theme.css       # 🎨 Modifica i colori qui
└── public/
    └── favicon.ico                 # 🎨 Metti qui il tuo favicon

```

## 🎨 Come Personalizzare

### 1. Modificare i Colori

Apri e modifica il file `frontend/styles/custom-theme.css`:

```bash
nano frontend/styles/custom-theme.css
```

Cambia i valori delle variabili CSS (es. `--color-primary: #TUO_COLORE;`)

### 2. Cambiare il Logo

1. Metti il tuo logo in `frontend/assets/` (consigliato formato SVG o PNG)
   ```bash
   cp /percorso/del/tuo/logo.svg frontend/assets/logo.svg
   ```

2. Decommenta la riga corrispondente in `docker-compose.yml`:
   ```yaml
   # Rimuovi il # davanti a questa riga:
   - ./frontend/assets/logo.svg:/app/frontend/dist/assets/logo.svg:ro
   ```

### 3. Cambiare il Favicon

1. Metti il tuo favicon.ico in `public/`
2. Decommenta la riga in `docker-compose.yml`

## 🚀 Avviare OpenHands

```bash
cd ~/openhands-custom
docker-compose up -d
```

Apri il browser su: http://localhost:3000

## 🔄 Aggiornare OpenHands

Per aggiornare alla nuova versione mantenendo le tue personalizzazioni:

```bash
cd ~/openhands-custom

# 1. Ferma il container
docker-compose down

# 2. Aggiorna l'immagine
docker-compose pull

# 3. Riavvia con le tue personalizzazioni
docker-compose up -d
```

## 📝 Logs

Visualizza i log:
```bash
docker-compose logs -f openhands
```

## 🛑 Fermare OpenHands

```bash
cd ~/openhands-custom
docker-compose down
```

## 🔍 Trovare i Nomi dei File Originali

Se hai bisogno di trovare il percorso esatto di un file nell'immagine originale:

```bash
# Avvia un container temporaneo
docker run -it --rm docker.all-hands.dev/all-hands-ai/openhands:0.59 sh

# All'interno del container, esplora:
find /app -name "*.svg" | grep logo
find /app -name "*.css"
exit
```

## 💡 Tips

- **Formato consigliato per logo**: SVG (scalabile, dimensione piccola)
- **Backup**: Fai backup dei tuoi file custom prima di aggiornare
- **Test**: Prova le modifiche in locale prima di deployare in produzione
- **Performance**: I file montati come volume non impattano le performance

## 🆘 Troubleshooting

**Il logo non cambia?**
- Verifica che il percorso in docker-compose.yml sia corretto
- Pulisci la cache del browser (Ctrl+Shift+R)
- Riavvia il container: `docker-compose restart`

**I colori non cambiano?**
- Il CSS potrebbe dover usare `!important` per sovrascrivere gli stili di Tailwind
- Verifica che il file CSS sia montato correttamente: `docker-compose exec openhands ls -la /app/frontend/dist/assets/`

**Come trovare il nome esatto del file logo?**
```bash
docker run --rm docker.all-hands.dev/all-hands-ai/openhands:0.59 find /app -name "*logo*"
```
EOF

echo "✅ README.md creato con istruzioni dettagliate"
echo ""

# Crea script di utility
cat > "$CUSTOM_DIR/update.sh" << 'EOF'
#!/bin/bash
# Script per aggiornare OpenHands mantenendo le personalizzazioni

echo "🔄 Aggiornamento OpenHands..."
docker-compose down
docker-compose pull
docker-compose up -d
echo "✅ Aggiornamento completato!"
docker-compose ps
EOF

chmod +x "$CUSTOM_DIR/update.sh"

cat > "$CUSTOM_DIR/logs.sh" << 'EOF'
#!/bin/bash
# Visualizza i logs di OpenHands
docker-compose logs -f openhands
EOF

chmod +x "$CUSTOM_DIR/logs.sh"

echo "✅ Script di utility creati"
echo ""

# Crea file di esempio per il logo (placeholder)
cat > "$CUSTOM_DIR/COME_MODIFICARE.txt" << 'EOF'
🎨 GUIDA RAPIDA - PERSONALIZZARE OPENHANDS
==========================================

1. MODIFICARE I COLORI
   → Apri: frontend/styles/custom-theme.css
   → Cambia i valori dei colori (formato: #RRGGBB)
   → Salva e riavvia: docker-compose restart

2. CAMBIARE IL LOGO
   a) Copia il tuo logo in: frontend/assets/logo.svg (o .png)
   b) Apri: docker-compose.yml
   c) Togli il # dalla riga del logo
   d) Riavvia: docker-compose restart

3. CAMBIARE IL FAVICON
   a) Copia il tuo favicon.ico in: public/favicon.ico
   b) Apri: docker-compose.yml
   c) Togli il # dalla riga del favicon
   d) Riavvia: docker-compose restart

4. AVVIARE OPENHANDS
   cd ~/openhands-custom
   docker-compose up -d

5. AGGIORNARE (mantiene le tue modifiche)
   ./update.sh

6. VEDERE I LOG
   ./logs.sh

EOF

echo ""
echo "=============================================="
echo "✅ Setup completato!"
echo "=============================================="
echo ""
echo "📂 Tutti i file sono in: $CUSTOM_DIR"
echo ""
echo "🎨 PROSSIMI PASSI:"
echo ""
echo "1. Vai nella directory:"
echo "   cd $CUSTOM_DIR"
echo ""
echo "2. Leggi le istruzioni:"
echo "   cat README.md"
echo "   # oppure"
echo "   cat COME_MODIFICARE.txt"
echo ""
echo "3. Modifica i colori:"
echo "   nano frontend/styles/custom-theme.css"
echo ""
echo "4. Aggiungi il tuo logo:"
echo "   cp /percorso/tuo/logo.svg frontend/assets/"
echo "   # Poi decommenta la riga in docker-compose.yml"
echo ""
echo "5. Avvia OpenHands:"
echo "   docker-compose up -d"
echo ""
echo "6. Apri il browser su:"
echo "   http://localhost:3000"
echo ""
echo "=============================================="
echo "📖 Per istruzioni dettagliate: cat $CUSTOM_DIR/README.md"
echo "=============================================="
