# 🤖 Configurare IRIS MCP Server in OpenHands

## 📝 Metodo 1: Variabile d'Ambiente

### Opzione A: Docker Compose

Aggiungi al tuo `docker-compose.yml`:

```yaml
services:
  openhands:
    image: ghcr.io/all-hands-ai/openhands:latest
    environment:
      - MCP_SERVERS=iris
      - MCP_SERVER_IRIS_URL=https://trustypa.brainaihub.tech/mcp
      - MCP_SERVER_IRIS_TRANSPORT=sse
      - MCP_SERVER_IRIS_AUTH_TYPE=bearer
      - MCP_SERVER_IRIS_AUTH_TOKEN=EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ
```

### Opzione B: CLI

Quando avvii OpenHands:

```bash
docker run \
  -e MCP_SERVERS=iris \
  -e MCP_SERVER_IRIS_URL=https://trustypa.brainaihub.tech/mcp \
  -e MCP_SERVER_IRIS_TRANSPORT=sse \
  -e MCP_SERVER_IRIS_AUTH_TYPE=bearer \
  -e MCP_SERVER_IRIS_AUTH_TOKEN=EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ \
  ghcr.io/all-hands-ai/openhands:latest
```

---

## 📝 Metodo 2: File di Configurazione

### 1. Crea file `config.toml`

```toml
[mcp.servers.iris]
url = "https://trustypa.brainaihub.tech/mcp"
transport = "sse"

[mcp.servers.iris.headers]
Authorization = "Bearer EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ"
```

### 2. Monta il file nel container

```bash
docker run \
  -v $(pwd)/config.toml:/app/config.toml \
  -e OPENHANDS_CONFIG=/app/config.toml \
  ghcr.io/all-hands-ai/openhands:latest
```

---

## 📝 Metodo 3: UI Settings (Web Interface)

Se usi OpenHands via web UI:

1. Vai su **Settings** ⚙️
2. Scorri fino a **MCP Servers**
3. Clicca **Add Server**
4. Compila:
   - **Name**: `iris`
   - **URL**: `https://trustypa.brainaihub.tech/mcp`
   - **Transport**: `SSE`
   - **Auth Type**: `Bearer Token`
   - **Token**: `EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ`
5. Clicca **Save**

---

## 🧪 Verifica Configurazione

Dopo aver configurato, testa con:

```
User: "List available MCP tools"
OpenHands: Shows 15 tools from IRIS (oauth, calendar, email, users, booking)

User: "Check my OAuth status for yyi9910@infocert.it"
OpenHands: Calls oauth_check_status tool via MCP
```

---

## 🛠️ 15 Tools Disponibili

Una volta configurato, OpenHands avrà accesso a:

### OAuth (2 tools)
- `oauth_check_status` - Verifica se utente è loggato
- `oauth_get_login_url` - Ottieni URL per login Microsoft

### Calendar (5 tools)
- `calendar_list_events` - Lista eventi calendario
- `calendar_create_event` - Crea nuovo evento
- `calendar_update_event` - Modifica evento
- `calendar_delete_event` - Elimina evento
- `calendar_find_free_time` - Trova slot liberi

### Email (2 tools)
- `email_list_messages` - Lista messaggi email
- `email_send_message` - Invia email

### Users (2 tools)
- `users_get_profile` - Info profilo utente
- `users_search` - Cerca utenti in directory

### Booking (4 tools)
- `booking_create` - Crea richiesta prenotazione
- `booking_check_status` - Stato prenotazione
- `booking_list` - Lista prenotazioni
- `booking_cancel` - Cancella prenotazione

---

## 💡 Esempi d'Uso

### Esempio 1: Verifica OAuth
```
User: "Am I logged into Microsoft 365?"
OpenHands → oauth_check_status(user_email="yyi9910@infocert.it")
         ← Response: {"logged_in": false}
OpenHands: "You're not logged in. Here's the login URL: [link]"
```

### Esempio 2: Lista Eventi Calendario
```
User: "Show my calendar events for today"
OpenHands → oauth_check_status() → "Not logged in"
OpenHands → oauth_get_login_url() → "https://..."
OpenHands: "Please login first: [link]"

(After user logs in)

User: "Show my calendar events for today"
OpenHands → calendar_list_events(
              user_email="yyi9910@infocert.it",
              start_date="2025-10-21T00:00:00Z",
              end_date="2025-10-21T23:59:59Z"
            )
         ← Response: [list of events]
OpenHands: "You have 3 events today: ..."
```

### Esempio 3: Crea Meeting con Cliente
```
User: "Schedule 30min meeting with john@external.com for tomorrow"
OpenHands → calendar_find_free_time(
              user_email="yyi9910@infocert.it",
              duration_minutes=30,
              start_date="2025-10-22T00:00:00Z"
            )
         ← Response: ["14:00", "15:00", "16:00"]

OpenHands → booking_create(
              organizer_email="yyi9910@infocert.it",
              external_email="john@external.com",
              subject="Meeting",
              duration_minutes=30,
              proposed_times=["2025-10-22T14:00:00Z", "2025-10-22T15:00:00Z"]
            )
         ← Response: {
              "session_id": "abc123",
              "booking_url": "https://trustypa.brainaihub.tech/booking?session=abc123"
            }

OpenHands: "I've sent a booking invitation to john@external.com with 2 time slots.
            They'll receive an email with a link to confirm."
```

---

## 🔒 Sicurezza

**⚠️ IMPORTANTE**: L'API key `EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ` è una chiave di PRODUZIONE.

### Best Practices:

1. **Non commitare la chiave** in repository pubblici
2. **Usa variabili d'ambiente** invece di hardcoding
3. **Crea chiavi separate** per ambienti diversi (dev/staging/prod)
4. **Revoca chiavi** se compromesse:
   ```bash
   ssh root@161.35.214.46
   docker exec -it iris-app python scripts/generate_mcp_key.py list
   docker exec -it iris-app python scripts/generate_mcp_key.py revoke --id 2
   ```

---

## 🐛 Troubleshooting

### Problema: "Connection refused"
**Causa**: URL sbagliato o server offline

**Soluzione**:
```bash
# Verifica che il server sia raggiungibile
curl https://trustypa.brainaihub.tech/mcp/health
```

### Problema: "401 Unauthorized"
**Causa**: API key mancante o invalida

**Soluzione**:
1. Verifica che l'header sia: `Authorization: Bearer <KEY>`
2. Controlla che la chiave sia attiva nel database
3. Genera nuova chiave se necessario

### Problema: "422 Unprocessable Entity"
**Causa**: Formato messaggio JSON-RPC sbagliato

**Soluzione**:
- OpenHands dovrebbe gestire automaticamente il formato
- Verifica che il transport sia `sse` (non `stdio`)

### Problema: Tools non compaiono in OpenHands
**Causa**: Configurazione MCP non caricata

**Soluzione**:
1. Riavvia OpenHands dopo aver modificato la configurazione
2. Controlla i log: `docker logs <container_id>`
3. Verifica che l'endpoint `/mcp/tools` risponda:
   ```bash
   curl -H "Authorization: Bearer EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ" \
     https://trustypa.brainaihub.tech/mcp/tools
   ```

---

## 📚 Risorse

- **IRIS Docs**: `/workspace/iris/MCP_SETUP_GUIDE.md`
- **MCP Spec**: https://modelcontextprotocol.io/
- **OpenHands Docs**: https://docs.all-hands.dev/
- **Production URL**: https://trustypa.brainaihub.tech
- **Test Account**: yyi9910@infocert.it

---

## ✅ Checklist Setup

- [ ] Configurazione MCP aggiunta (env vars o config file)
- [ ] OpenHands riavviato
- [ ] Test connessione: `curl .../mcp/health`
- [ ] Test auth: `curl -H "Authorization: Bearer ..." .../mcp/tools`
- [ ] Verifica tools disponibili in OpenHands
- [ ] Test tool OAuth: `oauth_check_status`
- [ ] User fa login via `/oauth/login`
- [ ] Test tool Calendar: `calendar_list_events`
- [ ] Test tool Booking: `booking_create`

---

🎉 **Setup Completo!** OpenHands può ora gestire email, calendario e prenotazioni tramite IRIS!
