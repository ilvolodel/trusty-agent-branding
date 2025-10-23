# 🚀 Quick Start - Trusty Agent Deployment

**For AI Agents:** Read this first for immediate context.

---

## ⚡ TL;DR

**Goal:** Deploy white-themed "Trusty Agent" branding for OpenHands on SwissKnife.  
**Status:** Ready to deploy, waiting for user to finish other work.  
**Image:** `trusty-agent:0.59` (built and ready on droplet)

---

## 🎯 One-Line Summary

Replace OpenHands dark theme with white Tinexta InfoCert branded "Trusty Agent" theme by changing one line in `docker-compose.yml`.

---

## 📋 3-Step Deploy

```bash
# 1. SSH to droplet
ssh root@161.35.214.46  # password: Fr3qu3nc1.

# 2. Edit docker-compose
cd /opt/swissknife
nano docker-compose.yml
# Change line 72: image: trusty-agent:0.59

# 3. Restart
docker-compose up -d openhands
```

---

## ✅ What's Ready

| Component | Status | Location |
|-----------|--------|----------|
| Favicon (blue "T") | ✅ Ready | `/opt/swissknife/openhands-custom/branding/favicon.*` |
| White theme CSS | ✅ Ready | `/opt/swissknife/openhands-custom/branding/custom-theme.css` |
| Docker image | ✅ Built | `trusty-agent:0.59` (1.3GB) |
| Dockerfile | ✅ Ready | `/opt/swissknife/openhands-custom/Dockerfile` |
| Build script | ✅ Ready | `/opt/swissknife/openhands-custom/build.sh` |
| Documentation | ✅ Complete | `/workspace/openhands-custom-ui/` |

---

## ⏳ What's Pending

- [ ] User to finish other SwissKnife modifications
- [ ] User to explain "deeper integration" requirements
- [ ] Deploy to production
- [ ] Test on `https://oh.bitsync.it`

---

## 🎨 What Changes

| Before | After |
|--------|-------|
| Dark background | **White** background (#FFFFFF) |
| OpenHands logo | **"Trusty Agent"** text |
| Generic footer | **"Trusty Agent • Powered by Tinexta InfoCert"** |
| Default favicon | **Blue "T"** favicon |
| Browser title: "OpenHands" | Browser title: **"Trusty Agent"** |

---

## 📁 Key Files

### On Droplet
```
/opt/swissknife/
├── docker-compose.yml          ← MODIFY THIS (line 72)
└── openhands-custom/           ← Branding system
    ├── Dockerfile
    ├── build.sh
    └── branding/
        ├── custom-theme.css    ← White theme
        └── favicon.*           ← Blue "T" logos
```

### In Workspace
```
/workspace/openhands-custom-ui/
├── HANDOVER.md                 ← Full details for AI agents
├── README.md                   ← Project overview
├── QUICK_START.md              ← This file
└── CHANGELOG.md                ← Version history
```

---

## 🆘 Rollback

```bash
cd /opt/swissknife
nano docker-compose.yml
# Change back to: image: docker.all-hands.dev/all-hands-ai/openhands:0.59
docker-compose up -d openhands
```

---

## 🔍 Verify It Works

After deployment:
1. Open `https://oh.bitsync.it`
2. Should see **white** background
3. Should see **blue "T"** favicon
4. Should see **"Trusty Agent"** in header

---

## 💡 Important Context

**User wants "deeper integration"** - current solution is surface-level (Docker layer with CSS). User will explain deeper approach after finishing other SwissKnife work.

**Current approach:**
- Base image + CSS overlay
- Simple and reversible
- Requires rebuild on OpenHands updates

**Future approach (TBD):**
- User will explain
- Likely more integrated with SwissKnife
- May modify source code

---

## 📚 Full Documentation

For complete details, see:
- **HANDOVER.md** - Full AI agent handover with step-by-step instructions
- **README.md** - Project overview and structure
- **CHANGELOG.md** - Version history and technical details

---

## 🎯 Success Criteria

✅ Deployment successful when:
- White background visible
- "Trusty Agent" branding shows
- All functionality works
- No errors in logs

---

**Last Updated:** 2025-10-21 10:18 UTC  
**Current Phase:** Waiting for user guidance  
**Ready to Deploy:** YES (when user approves)
