# OpenHands Custom UI - Trusty Agent Branding

Questa directory contiene tutti i file relativi alla personalizzazione dell'interfaccia di OpenHands per il branding **Trusty Agent** (Tinexta InfoCert).

---

## 📁 Struttura Directory

```
/workspace/openhands-custom-ui/
├── README.md                                    # Questa guida
├── HANDOVER.md                                  # Handover per AI agent
├── GUIDA_PERSONALIZZAZIONE_OPENHANDS.md        # Guida dettagliata personalizzazione
├── OPENHANDS_MCP_SETUP.md                      # Setup MCP (non correlato)
├── TEST_MCP_OPENHANDS.md                       # Test MCP (non correlato)
├── ANALISI_REPOSITORY_2025_10_21.md            # Analisi repository
├── PRE_RESTART_CHECK.md                        # Check pre-restart
├── RIEPILOGO_INTEGRAZIONE_TRUSTYPA.md          # Riepilogo integrazione
├── setup-openhands-custom.sh                   # Script setup (obsoleto)
├── iris_mcp_config.json                        # Config MCP Iris
├── mcp_config_openhands.json                   # Config MCP OpenHands
└── test_iris_mcp_client.py                     # Test client MCP
```

---

## 🎯 Cosa Contiene

### File Principali Branding
1. **RIEPILOGO_INTEGRAZIONE_TRUSTYPA.md** - Riepilogo completo integrazione Trusty Agent
2. **GUIDA_PERSONALIZZAZIONE_OPENHANDS.md** - Guida step-by-step personalizzazione UI

### File di Sistema
- **ANALISI_REPOSITORY_2025_10_21.md** - Analisi repository effettuata
- **PRE_RESTART_CHECK.md** - Verifiche pre-restart sistema
- **STATUS_DEPLOYMENT.md** - Stato deployment (nella root workspace)

### File MCP (Model Context Protocol)
- File di configurazione e test per integrazione MCP con Iris
- Non direttamente correlati al branding UI

---

## 🚀 Asset su Droplet

I file effettivi del branding sono su:
```
root@161.35.214.46:/opt/swissknife/openhands-custom/
├── Dockerfile
├── build.sh
├── README.md
└── branding/
    ├── favicon.ico
    ├── favicon-16x16.png
    ├── favicon-32x32.png
    ├── apple-touch-icon.png
    ├── android-chrome-192x192.png
    ├── android-chrome-512x512.png
    ├── custom-theme.css              # Tema BIANCO con colori InfoCert
    └── tinexta-infocert-logo.svg
```

---

## 🎨 Branding Implementato

### Visual
- ✅ Favicon "T" blu Tinexta InfoCert (#0072CE)
- ✅ Tema BIANCO (sfondo #FFFFFF invece di nero originale)
- ✅ Colori aziendali InfoCert:
  - Primario: #0072CE (blu InfoCert)
  - Secondario: #005AA3 (blu scuro)
  - Accent: #3399DD (blu chiaro)
- ✅ Header: Gradiente blu con scritta "Trusty Agent"
- ✅ Footer: "Trusty Agent • Powered by Tinexta InfoCert"

### Testo
- ✅ Browser title: "Trusty Agent"
- ✅ Meta description: "AI Agent per progetti esterni - Powered by Tinexta InfoCert"
- ✅ Branding visibile nell'header

---

## 🐳 Docker Image

**Immagine custom buildato:** `trusty-agent:0.59`
- Base: `docker.all-hands.dev/all-hands-ai/openhands:0.59`
- Size: ~1.3GB
- Location: Locale su droplet (non su registry)

---

## 📝 Stato Attuale

### ✅ Completato
1. Favicon personalizzati (tutti i formati)
2. CSS tema bianco con colori InfoCert
3. Dockerfile per build custom
4. Script automatico di build (`build.sh`)
5. Immagine Docker `trusty-agent:0.59` buildata
6. Documentazione completa

### ⏳ Da Fare
1. **Integrazione in SwissKnife** - Modificare `docker-compose.yml` per usare `trusty-agent:0.59`
2. **Deploy in produzione** - Restart container con nuova immagine
3. **Test finale** - Verificare su `https://oh.bitsync.it`

---

## 🔧 Come Deployare

Vedi file **HANDOVER.md** per istruzioni complete per AI agent.

Quick steps:
```bash
# SSH su droplet
ssh root@161.35.214.46

# Modifica docker-compose.yml
cd /opt/swissknife
nano docker-compose.yml
# Cambia: image: trusty-agent:0.59

# Restart
docker-compose stop openhands
docker-compose up -d openhands
```

---

## 🆘 Rollback

Per tornare a OpenHands originale:
```bash
cd /opt/swissknife
nano docker-compose.yml
# Ripristina: image: docker.all-hands.dev/all-hands-ai/openhands:0.59
docker-compose up -d openhands
```

---

## 🔄 Aggiornamenti Futuri

Quando esce OpenHands 0.60+:
```bash
cd /opt/swissknife/openhands-custom
./build.sh 0.60
cd /opt/swissknife
sed -i 's/trusty-agent:0.59/trusty-agent:0.60/g' docker-compose.yml
docker-compose up -d openhands
```

---

## 📧 Credenziali

- **Droplet IP:** 161.35.214.46
- **User:** root
- **Password:** Fr3qu3nc1.
- **Domain:** https://oh.bitsync.it

---

## 🔗 Link Utili

- Repository SwissKnife: `/workspace/swissknife`
- Repository Iris (TrustyPA): `/workspace/iris`
- Documentazione droplet: `/opt/swissknife/README.md`

---

**Last Update:** 2025-10-21  
**Status:** Ready for deployment (waiting for SwissKnife modifications to complete)
