---
name: smart-routing
description: Classify task complexity, decide which named agent to spawn, and manage quota-aware throttling. Consult before every spawn.
homepage: https://docs.openclaw.ai/
metadata: {"openclaw":{"emoji":"🧠","requires":{}}}
---

# Smart Routing Skill

**Consult this skill before spawning any sub-agent.**

Model selection per agent is handled by `openclaw.json` agents.list.
This skill decides: **which agent**, **batch or split**, and **quota safety**.

---

## Step 1: Classify Complexity

| Tier | Signs | Route to |
|------|-------|----------|
| **light** | Single-step, counts, status checks, fetches | Main agent handles directly or Gemini CLI |
| **medium** | Multi-step research, summarization, documentation | researcher or sysadmin |
| **heavy** | Architecture, complex debugging, multi-file refactors | coder or sysadmin |
| **heavy-code** | Code reviews, test generation, security audits | coder |
| **critical** | Novel problems, production crises, high-liability | coder (escalate model via override) |

## Step 2: Batch or Decompose?

- **Batch (1 agent):** ≤5 light tasks of the same type. Coordination overhead > speed gain.
- **Decompose (parallel):** Independent medium+ tasks. Spawn separate agents.
- **Sequential:** Dependent tasks. Chain them in one agent or spawn serially.

## Step 3: Quota Check

1. Read `~/.openclaw/skills/smart-routing/routing-state.json`
2. If a provider shows **>90% usage**, note it — the agent's fallback chain will handle it automatically.
3. If ALL providers for an agent's chain are >90%, alert the main agent to defer or use Gemini CLI.

## Step 4: Spawn

```
sessions_spawn({ agentId: "<agent-id>", task: "..." })
```

Include: what to do (2-3 sentences), relevant file paths, success criteria.
The agent's model chain from `agents.list` is used automatically.
Only override `model` for `critical` tier escalation.

## Step 5: Failure Recovery

If a sub-agent fails (rate limit, safety filter, error):
1. Analyze the error.
2. The agent's fallback chain handles model escalation automatically.
3. If the agent itself failed (not just the model), retry once with clearer instructions.
4. After 2 failures, report to user — don't retry infinitely.

---

## Anti-Patterns

- **Don't skip the quota check.** Spawning on a dead quota wastes time.
- **Don't over-parallelize.** 20 agents for 20 tiny tasks = agent bloat.
- **Don't bloat sub-agent prompts.** Send specific lines, not full files.
- **Don't override models unless critical tier.** Trust the agents.list chains.
