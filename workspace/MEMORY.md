# Long-Term Memory

Durable facts, preferences, and decisions. Daily logs go in memory/YYYY-MM-DD.md.
Auto-updated by: memoryFlush (per-session) and weekly consolidation cron (Sundays 3am CST).
Last manual consolidation: 2026-02-19.

## Yer (User)

- Timezone: America/Chicago (CST)
- Email: yer.lys@gmail.com
- Communication style: direct, no fluff
- Cost-conscious — minimize API spend, free tiers first
- Wants backups before editing config/important files
- GitHub: lyyer/fraidy-ly (HTTPS remote, credentials pending)

## Architecture Decisions

- 5 sub-agents: researcher, coder, sysadmin, communicator, monitor
- Coordinator is triage-only — no work tools
- Coder writes code but does NOT execute it — sysadmin runs code (separation of concerns)
- All agents use allowlists (principle of least privilege)
- Model chains: free tiers first (Google Antigravity, Groq) → cheap OpenRouter → Anthropic escalation
- Gemini CLI reserved for coordinator one-shot commands only — no other agent shares that pool
- Thinking enabled only on coder models (Qwen3-coder-next, DeepSeek-v3.2, Kimi-k2.5, Claude Sonnet 4.5)
- Smart-routing classifies complexity tier → picks agent (not model). agents.list handles model selection.
- sessions_spawn syntax: `sessions_spawn({ agentId: "<id>", task: "..." })`
- allowAgents required in subagents config or named agent spawning is blocked

## Security

- All secrets in env vars (${VAR} syntax in openclaw.json, keys in ~/.openclaw/.env)
- Prompt injection defense loaded every session via AGENTS.md
- Email whitelist: fraiday.ly@gmail.com and yer.lys@gmail.com is authorized
- Quiet hours: 23:00-08:00 CST — no notifications unless system down, security breach, or data loss
- Logging redaction enabled for tool outputs
- Never use config.patch for secrets (bug #15932 resolves ${VAR} to plaintext)

## Infrastructure

- Memory: Gemini embeddings (gemini-embedding-001), hybrid search (70% vector / 30% BM25), MMR diversity reranking, 30-day temporal decay, embedding cache
- Memory flush: glm-4.7-flash on OpenRouter, fires at 35k token compaction threshold
- Heartbeat: monitor agent every 30m on cheapest model
- Sandbox: non-main sessions run in Docker
- Stability protocol: STABILITY.md prevents self-lockouts, requires recovery plan for infra changes

## Lessons Learned

- "General" agent with broad access undermines specialist architecture — replaced with scoped Sysadmin
- Deny lists are risky (implicit allow) — switched everything to allowlists
- Researcher on CLI pool competes with coordinator — give it its own provider pool
- Don't assume permission from ambiguous user responses — ask explicitly
- rm blocked in some sandboxes — use rename-to-.DELETE as workaround

## Self-Healing & Self-Modification

- ERRORS.md tracks failures, corrections, and near-misses in structured format
- Coordinator auto-retries failed agent spawns once (fallback model), then logs and escalates
- Corrections from user are captured in ERRORS.md and promoted to Lessons Learned if durable
- Pre-task review: coordinator checks ERRORS.md before spawning agents to avoid repeating mistakes
- Weekly cron flags stale errors, promotes recurring patterns to MEMORY.md, archives old resolved entries
- Self-modification tiers in STABILITY.md: Tier 1 (workspace files) auto, Tier 2 (config tweaks) do+log, Tier 3 (security/providers/agents) ask first
- Mandatory rollback: backup openclaw.json before any Tier 2/3 change, git commit before and after, openclaw doctor to validate
- BOOTSTRAP.md recovery: if agent detects broken state, writes recovery steps for next session
- Only sysadmin modifies openclaw.json — it's the sole config modification agent

## Future Plans

- Multi-user gateway: each user gets their own agent with isolated workspace, auth, and API keys via bindings routing. Current architecture becomes a per-user template.
