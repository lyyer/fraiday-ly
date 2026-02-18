---
name: smart-routing
description: Intelligently route sub-agent tasks to optimal models based on complexity and quota availability. Always consult this skill before spawning sub-agents.
homepage: https://docs.openclaw.ai/
metadata: {"openclaw":{"emoji":"🧠","requires":{}}}
---

# Smart Model Routing Skill

**IMPORTANT: Use this skill EVERY time you spawn a sub-agent to select the optimal model.**

This skill implements a tier-based routing pattern with self-healing, surgical context, and quota awareness.

---

## Configuration & State

- **Config:** `~/.openclaw/skills/smart-routing/routing-config.json` (Static priorities)
- **State:** `~/.openclaw/skills/smart-routing/routing-state.json` (Live quota data from Heartbeat)

---

## Tiers

| Tier | Use For |
|------|---------|
| **light** | Single-step ops: counts, lists, fetches, status checks |
| **light-fast** | Same as light but speed-critical, latency-sensitive |
| **medium** | Multi-step: research, summarization, documentation, explanations |
| **medium-fast** | Same as medium but time-sensitive |
| **heavy** | Deep reasoning: architecture, complex debugging, strategic decisions |
| **heavy-code** | Complex code: reviews, test gen, refactoring, security audits |
| **critical** | Highest stakes: novel problems, production crises, high-liability |

---

## Routing Decision Process

### Step 1: Batch or Decompose? (Smart Batching)
**Decide if multiple tasks should be parallelized or bundled.**

- **Batch (1 Agent) if:** Tasks are `light` tier, simple (e.g., check 5 file sizes), and the coordination overhead of 5 agents exceeds the speed gain.
- **Decompose (Parallel Agents) if:** Tasks are `medium` or higher, or if they are independent and speed is critical.
- **Threshold:** Max 5-10 `light` tasks per agent.

### Step 2: Classify Complexity & Context Needs
Read the task and match against tier definitions. Assess if the sub-agent needs persona context (Surgical Context).

### Step 3: Quota-Aware Throttling
**Before resolving the model, check the fuel gauge.**

1. Read `routing-state.json`.
2. **Throttle Rule:** If a model's current usage is **>90%** of its quota, treat it as "unavailable."
3. **Shift:** Automatically skip to the next model in the `routing-config.json` array.
4. **Goal:** Preserve the last 10% of premium quotas for manual/critical tasks.

### Step 4: Resolve & Spawn
1. Pick the first available (non-throttled) model from the tier.
2. Prepend harvested context snippets (if needed).
3. `sessions_spawn(task, label, model)`

### Step 5: Failure Recovery (Self-Healing)
If a sub-agent fails (rate limit, safety, or error):
1. **Analyze** the error.
2. **Escalate** to the next available model in the fallback array.
3. **Retry** automatically (Max 1 retry per task).

### Step 6: Automated Synthesis (The "General" Step)
Decide whether to synthesize results in the main chat or spawn a specialized agent.
- **Main Chat:** Small volume, simple synthesis.
- **Specialized Agent:** High volume, complex cross-referencing, or reasoning "upgrade" needed.

---

## Anti-Patterns
- **Don't: Skip the quota check.** Spawning an agent on a dead quota is a waste of time.
- **Don't: Over-parallelize.** Spawning 20 agents for 20 tiny tasks creates "agent bloat."
- **Don't: Bloat sub-agents with full files.** Only send the specific lines needed.
