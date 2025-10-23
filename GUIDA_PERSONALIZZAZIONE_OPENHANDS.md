# 🎨 Guida Completa: Personalizzare OpenHands (Solo Loghi e Colori)

## 📋 Panoramica

Questa guida ti mostra come personalizzare **solo loghi e colori** di OpenHands sulla tua droplet, mantenendo:
- ✅ L'immagine Docker ufficiale
- ✅ Aggiornamenti automatici semplici
- ✅ Zero compilazione/build richiesta
- ✅ Modifiche reversibili in qualsiasi momento

## 🎯 Approccio: Docker Volumes Overlay

Useremo Docker Compose per montare i tuoi file personalizzati **sopra** l'immagine ufficiale.

## 🚀 Setup Iniziale (Una Volta Sola)

### 1. Prepara lo Script di Setup

Copia lo script `setup-openhands-custom.sh` sulla tua droplet:

```bash
# Sulla tua droplet
cd ~
nano setup-openhands-custom.sh
# Incolla il contenuto dello script (vedi sotto)
# Salva con Ctrl+X, Y, Enter

chmod +x setup-openhands-custom.sh
./setup-openhands-custom.sh
```

### 2. Struttura Creata

Lo script crea questa struttura in `~/openhands-custom/`:

```
~/openhands-custom/
├── docker-compose.yml           # Configurazione principale
├── frontend/
│   ├── assets/                  # 🎨 Metti qui i tuoi loghi
│   └── styles/
│       └── custom-theme.css     # 🎨 Modifica i colori qui
├── public/
│   └── favicon.ico              # 🎨 Metti qui il favicon
├── update.sh                     # Script per aggiornare
├── logs.sh                       # Script per vedere i log
├── README.md                     # Documentazione completa
└── COME_MODIFICARE.txt          # Guida rapida
```

## 🎨 Personalizzazione

### A) Modificare i Colori

```bash
cd ~/openhands-custom
nano frontend/styles/custom-theme.css
```

Modifica i valori che vuoi cambiare:

```css
:root {
  --color-primary: #FF6B6B;        /* Il tuo colore principale */
  --color-primary-dark: #EE5A52;   /* Versione più scura */
  --color-bg-primary: #FFFFFF;     /* Sfondo */
  /* ... altri colori ... */
}
```

**Colori suggeriti da modificare:**
- `--color-primary`: Colore principale dell'app (pulsanti, link, ecc.)
- `--color-bg-primary`: Colore di sfondo principale
- `--color-accent`: Colore per elementi in evidenza

**Formato colori:** Usa formato esadecimale `#RRGGBB` (es. `#3b82f6`)

### B) Cambiare il Logo

**Passo 1:** Carica il tuo logo nella droplet

```bash
# Opzione 1: Usa SCP dalla tua macchina locale
scp /percorso/tuo/logo.svg user@tua-droplet-ip:~/openhands-custom/frontend/assets/

# Opzione 2: Scarica da URL
cd ~/openhands-custom/frontend/assets
wget https://tuosito.com/logo.svg -O logo.svg
# oppure
curl https://tuosito.com/logo.svg -o logo.svg
```

**Passo 2:** Modifica docker-compose.yml

```bash
cd ~/openhands-custom
nano docker-compose.yml
```

Trova questa sezione e **rimuovi il `#`** davanti alla riga del logo:

```yaml
# PRIMA (commentato):
# - ./frontend/assets/logo.svg:/app/frontend/dist/assets/logo.svg:ro

# DOPO (decommentato):
- ./frontend/assets/logo.svg:/app/frontend/dist/assets/logo.svg:ro
```

**Nota:** Potrebbe essere necessario trovare il percorso esatto del logo nell'immagine originale. Vedi sezione "Troubleshooting".

### C) Cambiare il Favicon

```bash
# Carica il tuo favicon
cd ~/openhands-custom/public
# Usa scp o wget come per il logo

# Poi decommenta in docker-compose.yml
nano ../docker-compose.yml
# Rimuovi # da: - ./public/favicon.ico:/app/frontend/dist/favicon.ico:ro
```

## 🎬 Avviare OpenHands Personalizzato

```bash
cd ~/openhands-custom
docker-compose up -d
```

Verifica che sia attivo:
```bash
docker-compose ps
```

Apri nel browser: `http://tua-droplet-ip:3000`

## 🔄 Aggiornare OpenHands (Mantiene Personalizzazioni)

```bash
cd ~/openhands-custom

# Metodo 1: Usa lo script
./update.sh

# Metodo 2: Manuale
docker-compose down
docker-compose pull
docker-compose up -d
```

**Importante:** Le tue modifiche (logo, colori) vengono mantenute perché sono in file separati montati come volumes!

## 🛠️ Comandi Utili

```bash
# Vedere i log in tempo reale
cd ~/openhands-custom
./logs.sh
# oppure
docker-compose logs -f openhands

# Riavviare dopo modifiche
docker-compose restart

# Fermare OpenHands
docker-compose down

# Verificare stato
docker-compose ps

# Accedere al container (debug)
docker-compose exec openhands sh
```

## 🔍 Troubleshooting

### Il logo non cambia?

**1. Verifica il percorso corretto del logo originale:**

```bash
docker run --rm docker.all-hands.dev/all-hands-ai/openhands:0.59 \
  find /app -name "*logo*" -o -name "*.svg" | grep -i logo
```

Questo ti mostrerà dove si trova realmente il logo nell'immagine. Usa quel percorso in docker-compose.yml.

**2. Pulisci cache browser:**
- Chrome/Edge: `Ctrl + Shift + R`
- Firefox: `Ctrl + F5`

**3. Verifica che il file sia montato:**

```bash
docker-compose exec openhands ls -la /app/frontend/dist/assets/
```

**4. Riavvia il container:**

```bash
docker-compose restart
```

### I colori non cambiano?

**1. Verifica che il CSS sia caricato:**

Aggiungi `!important` ai tuoi stili se necessario:

```css
.bg-primary { 
  background-color: var(--color-primary) !important; 
}
```

**2. Verifica il percorso del CSS montato:**

```bash
docker-compose exec openhands ls -la /app/frontend/dist/assets/custom-theme.css
```

**3. Potrebbe essere necessario iniettare il CSS direttamente nell'HTML:**

Se l'overlay non funziona, puoi:
- Montare l'intero file `index.html` modificato
- Oppure usare un reverse proxy (nginx) per iniettare CSS custom

### Percorsi non corretti?

**Esplorare l'immagine Docker originale:**

```bash
# Avvia shell interattiva nel container
docker run -it --rm docker.all-hands.dev/all-hands-ai/openhands:0.59 sh

# All'interno, esplora:
ls -R /app/frontend/
find /app -name "*.css"
find /app -name "index.html"
exit
```

## 📦 Esempio Completo di docker-compose.yml

```yaml
version: '3.8'

services:
  openhands:
    image: docker.all-hands.dev/all-hands-ai/openhands:0.59
    container_name: openhands-custom
    restart: unless-stopped
    
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/.openhands:/.openhands
      
      # PERSONALIZZAZIONI
      - ./frontend/styles/custom-theme.css:/app/frontend/dist/assets/custom-theme.css:ro
      - ./frontend/assets/logo.svg:/app/frontend/dist/assets/logo.svg:ro
      - ./public/favicon.ico:/app/frontend/dist/favicon.ico:ro
    
    ports:
      - "3000:3000"
    
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.59-nikolaik
      - LOG_ALL_EVENTS=true
    
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

## 🎓 Alternative Avanzate

Se l'approccio overlay non funziona perfettamente, considera:

### Opzione B: Reverse Proxy con Nginx

Usa nginx davanti a OpenHands per iniettare CSS custom:

```nginx
# /etc/nginx/sites-available/openhands
server {
    listen 80;
    server_name tuodominio.com;

    location / {
        proxy_pass http://localhost:3000;
        
        # Inietta CSS custom
        sub_filter '</head>' '<link rel="stylesheet" href="/custom/theme.css"></head>';
        sub_filter_once on;
    }
    
    location /custom/ {
        alias /var/www/openhands-custom/;
    }
}
```

### Opzione C: Fork e Build Custom (per modifiche maggiori)

Se in futuro vuoi fare modifiche più profonde, vedi `GUIDA_FORK_BUILD.md` (da creare).

## 📊 Vantaggi di Questo Approccio

| Caratteristica | ✅ Vantaggi |
|----------------|-------------|
| **Aggiornamenti** | Semplicissimi: `docker-compose pull` |
| **Reversibilità** | Rimuovi i volumes e torni all'originale |
| **Performance** | Zero overhead, nessuna build |
| **Manutenzione** | Modifichi solo 2-3 file |
| **Compatibilità** | Funziona con tutte le versioni future |

## 🔐 Sicurezza

**Importante:** Se esponi OpenHands su internet, proteggi l'accesso:

```yaml
# Aggiungi autenticazione con reverse proxy
# Oppure usa solo su localhost e VPN
ports:
  - "127.0.0.1:3000:3000"  # Solo localhost
```

## 📞 Supporto

- **Documentazione Ufficiale:** https://docs.all-hands.dev
- **GitHub Issues:** https://github.com/All-Hands-AI/OpenHands/issues
- **Slack Community:** https://all-hands.dev/joinslack

## 📝 Checklist Finale

- [ ] Script eseguito: `./setup-openhands-custom.sh`
- [ ] Colori modificati in: `frontend/styles/custom-theme.css`
- [ ] Logo caricato in: `frontend/assets/logo.svg`
- [ ] Riga logo decommentata in `docker-compose.yml`
- [ ] Favicon caricato (opzionale)
- [ ] Container avviato: `docker-compose up -d`
- [ ] Testato in browser con cache pulita
- [ ] Backup fatto delle personalizzazioni

## 🎉 Fine

Ora hai OpenHands personalizzato con i tuoi colori e loghi, e puoi aggiornarlo facilmente mantenendo le modifiche!

---

**Autore:** Guida generata per personalizzazione OpenHands  
**Versione:** 1.0  
**Data:** 2025-10-21
