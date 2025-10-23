# 🧪 Test MCP Integration in OpenHands

**Data:** 21 Ottobre 2025  
**Server MCP:** https://trustypa.brainaihub.tech/mcp  
**Status:** ✅ ONLINE

---

## ✅ Pre-Check Completati

### 1. Server MCP Health Check
```bash
curl https://trustypa.brainaihub.tech/mcp/health
```
**Risultato:** ✅ Healthy - 15 tools available

### 2. API Key Authentication
```bash
curl -H "Authorization: Bearer EP31x..." \
  https://trustypa.brainaihub.tech/mcp/tools
```
**Risultato:** ✅ 15 tools returned

### 3. Repository Status
- IRIS: Commit `40af67f` ✅ Pushed
- SwissKnife: Commit `0d4083a` ✅ Pushed

---

## 🚀 Come Testare MCP in OpenHands

### Opzione 1: Configurazione UI OpenHands (Raccomandato)

1. **Accedi a OpenHands:**
   - URL: https://oh.bitsync.it (o http://localhost:51872)
   - Credenziali: admin / SwissKnife2024!

2. **Vai in Settings → MCP Servers**

3. **Aggiungi server TrustyPA:**
   ```json
   {
     "mcpServers": {
       "trustypa": {
         "url": "https://trustypa.brainaihub.tech/mcp",
         "transport": {
           "type": "sse"
         },
         "headers": {
           "Authorization": "Bearer EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ"
         }
       }
     }
   }
   ```

4. **Salva e Riavvia OpenHands** (se necessario)

5. **Verifica i tools caricati:**
   - Dovrebbero apparire 15 nuovi tools nel sistema
   - Lista tools: oauth_check_status, oauth_get_login_url, calendar_*, email_*, users_*, booking_*

---

### Opzione 2: File di Configurazione

Se OpenHands usa un file config:

1. **Trova il file di configurazione:**
   ```bash
   # Possibili posizioni:
   ~/.openhands/config.json
   /opt/openhands-workspace/.openhands/config.json
   ```

2. **Aggiungi la configurazione MCP:**
   ```json
   {
     "mcpServers": {
       "trustypa": {
         "url": "https://trustypa.brainaihub.tech/mcp",
         "transport": {
           "type": "sse"
         },
         "headers": {
           "Authorization": "Bearer EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ"
         }
       }
     }
   }
   ```

3. **Riavvia OpenHands:**
   ```bash
   cd /opt/swissknife
   docker compose -p swissknife restart openhands
   ```

---

## 🧪 Test dei Tools MCP

### Test 1: Check OAuth Status
```
Prompt per OpenHands:
"Usa il tool oauth_check_status per verificare lo stato OAuth dell'utente yyi9910@infocert.it"
```

**Risultato atteso:**
```json
{
  "authenticated": false,
  "message": "User not authenticated. Please use oauth_get_login_url to start authentication."
}
```

---

### Test 2: Get OAuth Login URL
```
Prompt per OpenHands:
"Usa il tool oauth_get_login_url per generare un URL di login OAuth per yyi9910@infocert.it"
```

**Risultato atteso:**
```json
{
  "login_url": "https://trustypa.brainaihub.tech/oauth/login?email=yyi9910@infocert.it&state=...",
  "expires_in": 3600
}
```

---

### Test 3: Workflow Completo OAuth

1. **Check status iniziale:**
   ```
   oauth_check_status(email="yyi9910@infocert.it")
   ```

2. **Get login URL:**
   ```
   oauth_get_login_url(email="yyi9910@infocert.it")
   ```

3. **Apri URL nel browser e completa OAuth flow**

4. **Re-check status dopo autenticazione:**
   ```
   oauth_check_status(email="yyi9910@infocert.it")
   ```
   
   **Dovrebbe ora ritornare:**
   ```json
   {
     "authenticated": true,
     "user": {
       "email": "yyi9910@infocert.it",
       "name": "Test User",
       "expires_at": "2025-10-22T10:00:00Z"
     }
   }
   ```

---

### Test 4: Calendar Tools (dopo OAuth)

```
Prompt per OpenHands:
"Lista gli eventi del calendario per yyi9910@infocert.it per i prossimi 7 giorni"
```

**Tool chiamato:**
```
calendar_list_events(
  user_email="yyi9910@infocert.it",
  start_date="2025-10-21T00:00:00Z",
  end_date="2025-10-28T23:59:59Z"
)
```

---

### Test 5: Booking Tool

```
Prompt per OpenHands:
"Crea una nuova sessione di booking per yyi9910@infocert.it con disponibilità domani dalle 9 alle 17"
```

**Tool chiamato:**
```
booking_create_session(
  user_email="yyi9910@infocert.it",
  availability=[{
    "date": "2025-10-22",
    "time_slots": ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00"]
  }]
)
```

---

## 📊 Checklist Completa

### Pre-requisiti ✅
- [x] Server MCP online (https://trustypa.brainaihub.tech/mcp)
- [x] Health endpoint risponde correttamente
- [x] API Key valida e funzionante
- [x] 15 tools disponibili
- [x] Account test disponibile (yyi9910@infocert.it)

### Configurazione OpenHands
- [ ] Configurazione MCP aggiunta in OpenHands UI
- [ ] OpenHands riavviato (se necessario)
- [ ] Tools MCP caricati e visibili
- [ ] Nessun errore nei log OpenHands

### Test Funzionali
- [ ] Test 1: oauth_check_status funziona
- [ ] Test 2: oauth_get_login_url genera URL valido
- [ ] Test 3: OAuth flow completato con successo
- [ ] Test 4: calendar_list_events ritorna dati
- [ ] Test 5: booking_create_session funziona

---

## 🐛 Troubleshooting

### Problema: OpenHands non vede i tools MCP

**Verifiche:**
1. Check log OpenHands:
   ```bash
   docker logs swissknife-openhands --tail 100 | grep -i mcp
   ```

2. Verifica configurazione:
   ```bash
   # Se config è in file
   cat ~/.openhands/config.json | grep trustypa
   ```

3. Test connessione da container OpenHands:
   ```bash
   docker exec swissknife-openhands curl -s \
     -H "Authorization: Bearer EP31x..." \
     https://trustypa.brainaihub.tech/mcp/health
   ```

---

### Problema: Errore di autenticazione MCP

**Sintomo:** "401 Unauthorized" o "Invalid API Key"

**Soluzione:**
1. Verifica API Key:
   ```bash
   curl -H "Authorization: Bearer EP31xLyrqTRwMlksWwIfxIWFUNN4Ex_uL13z31e2TVQ" \
     https://trustypa.brainaihub.tech/mcp/tools
   ```

2. Se fallisce, genera nuova API key:
   ```bash
   cd /opt/iris
   docker exec iris-app python scripts/generate_mcp_key.py generate --name "OpenHands"
   ```

---

### Problema: Tools ritornano "User not authenticated"

**Normale per tools che richiedono OAuth!**

**Workflow corretto:**
1. Prima usa `oauth_check_status` → ritorna `authenticated: false`
2. Poi usa `oauth_get_login_url` → genera URL
3. Apri URL in browser e completa OAuth
4. Ora puoi usare tutti gli altri tools (calendar, email, ecc.)

---

## 📝 Note Importanti

### Transport Type: SSE (Server-Sent Events)
- OpenHands usa SSE per connessioni long-lived
- Il server IRIS supporta sia HTTP che SSE
- Endpoint SSE: `https://trustypa.brainaihub.tech/mcp/sse`

### Rate Limiting
- Nessun rate limit configurato attualmente
- Tutte le richieste vengono autenticate via Bearer token

### Session Management
- OAuth tokens hanno scadenza (configurabile in IRIS .env)
- Dopo scadenza, l'utente deve ri-autenticarsi
- `oauth_check_status` mostra sempre lo stato corrente

### Security
- API Key deve essere conservata in modo sicuro
- Non committare API key nei repository
- Ogni API key è associata a un nome per auditing

---

## 🎯 Risultato Atteso Finale

Dopo aver completato tutti i test, dovresti avere:

✅ **OpenHands con 15 nuovi tools MCP**
- oauth_check_status
- oauth_get_login_url
- calendar_list_events
- calendar_create_event
- calendar_update_event
- calendar_delete_event
- email_send
- email_list
- email_read
- users_list
- users_get
- booking_create_session
- booking_get_session
- booking_confirm_booking
- booking_cancel_booking

✅ **Workflow OAuth funzionante**
- Check status → Get URL → Complete OAuth → Use tools

✅ **Integrazione testata end-to-end**
- OpenHands → IRIS MCP Server → Microsoft 365 Graph API

---

## 📚 Documentazione Correlata

- **IRIS MCP_SETUP_GUIDE.md**: Guida completa setup MCP
- **IRIS ARCHITECTURE.md**: Architettura sistema
- **SwissKnife TRUSTYPA_INTEGRATION.md**: Integrazione nginx/SSL
- **RIEPILOGO_INTEGRAZIONE_TRUSTYPA.md**: Riepilogo modifiche

---

**Ready to test!** 🚀

Se hai problemi o domande durante i test, consulta il troubleshooting o controlla i log:
```bash
# Log IRIS
docker logs iris-app --tail 100 -f

# Log OpenHands
docker logs swissknife-openhands --tail 100 -f

# Log Nginx
docker logs swissknife-nginx --tail 100 -f
```
