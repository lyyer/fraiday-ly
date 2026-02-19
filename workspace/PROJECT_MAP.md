# PROJECT_MAP.md — The Big Picture

## Active Mission: Multi-Agent Architecture

**Goal:** Cost-optimized, secure, multi-user agent system with clear role boundaries.

---

## Architecture

**Main agent** → pure triage, no work tools
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
- [x] Main agent tool lockdown (triage-only)
- [x] AGENTS.md with "When spawned as..." sections
- [x] Smart-routing refocused: agent routing, not model selection
- [x] All secrets moved to env vars (${VAR} syntax)
- [x] env.template created for onboarding
- [x] Thinking disabled on non-coder models
- [x] Quiet hours (23:00-08:00 CST) in HEARTBEAT.md
- [x] Prompt injection defense in AGENTS.md
- [x] Email authorization whitelist in USER.md
- [x] All agents on allowlists (principle of least privilege)
- [x] Coder exec removed — sysadmin runs code
- [x] memorySearch enabled (Gemini embeddings, hybrid, MMR, temporal decay, cache)
- [x] memoryFlush configured (glm-4.7-flash, 35k threshold)
- [x] OpenRouter API key placeholder replaced with ${OPENROUTER_API_KEY}
- [x] MEMORY.md initialized with long-term distilled facts
- [x] PIN verification for external inputs (auth.requirePinForExternal)
- [x] memoryFlush updated to promote durable facts to MEMORY.md
- [x] Weekly memory consolidation cron job (Sundays 3am CST, isolated session)
- [x] Memory management section added to AGENTS.md
- [x] Self-healing: ERRORS.md, auto-retry, correction capture, pre-task error review
- [x] Weekly cron updated to also review and archive errors
- [x] Self-modification tiers (STABILITY.md): auto / do+log / ask first
- [x] Mandatory rollback protocol for config changes (backup + git + openclaw doctor)
- [x] BOOTSTRAP.md recovery mechanism for broken states
- [x] Sysadmin designated as sole config modification agent

## Remaining

- [ ] Fill in ~/.openclaw/.env (OPENROUTER, GROQ, GEMINI, ANTHROPIC, PROMPT_PIN)
- [ ] Register cron job: `bash setup/cron-memory-consolidation.sh`
- [ ] Test full agent architecture with `openclaw doctor`
- [ ] Clean up: delete `.DELETE` files, `SKILL_old.md.bak`, duplicate root `memory/` dir
- [ ] Push to GitHub (needs PAT or SSH key setup)

## Future Roadmap

- [ ] **Multi-user gateway** — each user gets their own agent with isolated workspace, auth, and API keys via `bindings` routing. Current architecture (main + sub-agents) becomes a per-user template. See docs.openclaw.ai/concepts/multi-agent.

---

## Milestones

- **2026-02-19:** Tool re-evaluation — all agents on allowlists, coder loses exec. Memory fully initialized: MEMORY.md (long-term), memorySearch (Gemini embeddings, hybrid, MMR, temporal decay), memoryFlush (two-layer promotion), weekly consolidation cron. PIN verification added for external channels.
- **2026-02-18:** Agent architecture v2 — replaced General with Sysadmin, smart-routing refocused to agent routing, full repo audit and cleanup. Security hardening, env var secrets, quiet hours.
- **2026-02-17:** Workspace moved to GitHub; Stability Protocol; Performance optimizations
- **2026-02-16:** Workflow 2.0 (failure escapes, smart batching, quota throttling)
- **2026-02-15:** System migration and recovery

---
*Last updated: 2026-02-19*
