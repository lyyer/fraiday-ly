# STABILITY.md — Self-Modification & Recovery Protocol

Created after a self-destruction incident (2026-02-17). This protocol governs what
Fraiday can change on its own, what requires user approval, and how to recover.

---

## 1. Self-Modification Tiers

### Tier 1 — Auto (no approval needed)
Changes that are low-risk and reversible. Do them, log to ERRORS.md or daily memory.

- Swap model fallback order based on error rates
- Update routing-config.json tier mappings
- Adjust heartbeat frequency or quiet hours
- Edit workspace files: AGENTS.md, MEMORY.md, ERRORS.md, TOOLS.md, ESCALATION.md
- Modify cron job prompts or schedules
- Add entries to memory files
- Update PROJECT_MAP.md

### Tier 2 — Do and Log (act, then notify user next session)
Changes that affect agent behavior but are recoverable. Always git commit before and after.

- Disable a model in a fallback chain (if it's consistently failing)
- Add a tool to an agent's allowlist (if a task genuinely requires it)
- Modify compaction or memoryFlush thresholds
- Change smart-routing complexity tier assignments
- Update SOUL.md personality traits
- Modify maxConcurrent or maxSpawnDepth

### Tier 3 — Ask First (always requires user approval)
Changes that could break the system, cost money, or are irreversible.

- Add or remove an agent from agents.list
- Change provider API keys or add new providers
- Modify gateway/auth/PIN settings
- Change sandbox mode or Docker config
- Modify STABILITY.md itself
- Any change to security settings (redaction, injection defense, email whitelist)
- Enable new channels or bindings
- Delete any file (use trash, never rm)
- Git push to remote

---

## 2. Mandatory Rollback Protocol

BEFORE any Tier 2 or Tier 3 change to openclaw.json:

1. **Backup:** `cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.rollback`
2. **Git commit:** `git commit -am "pre-change: [description]"`
3. **Make the change.**
4. **Validate:** Run `openclaw doctor` — if it fails, immediately rollback:
   `cp ~/.openclaw/openclaw.json.rollback ~/.openclaw/openclaw.json`
5. **Git commit:** `git commit -am "post-change: [description]"`
6. **Log:** Record what changed and why in ERRORS.md (if fixing a problem) or daily memory (if improving).

If the agent loses the ability to communicate after a change, BOOTSTRAP.md kicks in.

---

## 3. BOOTSTRAP.md Recovery

If the agent detects it's in a broken state (tools failing, config invalid, model errors
on all fallbacks), it should create `workspace/BOOTSTRAP.md` with recovery steps.

On every session start, the main agent checks: if BOOTSTRAP.md exists, follow it, then delete it.

BOOTSTRAP.md format:
```
# BOOTSTRAP — Auto-Recovery
## Problem: [what broke]
## Steps:
1. [specific recovery command]
2. [validation step]
## Rollback: [if steps fail, do this]
## Created: [timestamp]
```

The main agent can also create BOOTSTRAP.md before attempting a risky change, so if
the change breaks things, the next session knows how to recover.

---

## 4. The "No Lockout" Rule

Never make changes that could isolate the agent from:
- Its own workspace files
- The gateway
- At least one working model in every agent's chain

If a change could break any of these three, it is automatically Tier 3.

---

## 5. Sandboxing & Isolation

**Status:** FROZEN. No new isolation layers without a confirmed secondary access method.
Non-main sessions run in Docker (already configured). Don't change this without user approval.

---

## 6. User "Break Glass" Commands

If the agent goes offline after a config change:
1. `openclaw gateway restart`
2. `openclaw doctor --repair`
3. `cp ~/.openclaw/openclaw.json.rollback ~/.openclaw/openclaw.json && openclaw gateway restart`
4. `openclaw gateway config reset` (nuclear option — resets to defaults)
5. If git is intact: `git log --oneline -5` then `git checkout <pre-change-hash> -- openclaw.json`
