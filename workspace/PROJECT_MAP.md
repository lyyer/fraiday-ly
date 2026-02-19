# PROJECT_MAP.md — The Big Picture

## Active Mission: Multi-Agent Architecture

**Goal:** Cost-optimized, secure, multi-user agent system with clear role boundaries.

---

## Architecture

**Coordinator** (main) → pure triage, no work tools
- **researcher** → web lookups, multi-source research (read-only)
- **coder** → code gen, debugging, refactoring (no web, no messaging)
- **sysadmin** → file management, configs, maintenance (no web, no messaging)
- **communicator** → emails, messages, drafts (no code, no file writes)
- **monitor** → heartbeat health checks (read-only, auto-spawned)

Model chains: free tiers first (Google, Groq) → cheap OpenRouter → Anthropic escalation.
Smart-routing skill classifies complexity → picks agent. agents.list handles model selection.

---

## Completed

- [x] Stability Protocol (STABILITY.md) — prevents self-lockouts
- [x] Docker sandboxing for non-main sessions
- [x] Git versioning with GitHub remote (lyyer/fraidy-ly)
- [x] Smart-routing skill with quota-aware throttling
- [x] Daily memory logs (memory/YYYY-MM-DD.md)
- [x] Memory flush on compaction (35k token threshold)
- [x] Context pruning (cache-ttl, 4h window)
- [x] Named agent architecture with tool lockdowns
- [x] OpenRouter provider for specialist models (Qwen, DeepSeek, Kimi, GLM)
- [x] Coordinator tool lockdown (triage-only)
- [x] AGENTS.md with "When spawned as..." sections
- [x] Smart-routing refocused: agent routing, not model selection

## Remaining

- [ ] Replace `<OPENROUTER_API_KEY>` placeholder in openclaw.json
- [ ] Initialize MEMORY.md for long-term distilled wisdom
- [ ] Enable memorySearch in openclaw.json
- [ ] Test full agent architecture with `openclaw doctor`
- [ ] Clean up: delete `.DELETE` files, `SKILL_old.md.bak`, duplicate root `memory/` dir
- [ ] Add PIN verification for external inputs (auth.requirePinForExternal)

---

## Milestones

- **2026-02-18:** Agent architecture v2 — replaced General with Sysadmin, smart-routing refocused to agent routing, full repo audit and cleanup
- **2026-02-17:** Workspace moved to GitHub; Stability Protocol; Performance optimizations
- **2026-02-16:** Workflow 2.0 (failure escapes, smart batching, quota throttling)
- **2026-02-15:** System migration and recovery

---
*Last updated: 2026-02-18*
