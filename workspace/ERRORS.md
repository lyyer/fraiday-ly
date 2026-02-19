# Error Log

Structured log of failures, corrections, and near-misses. Reviewed by coordinator
before major tasks and by weekly consolidation cron. Recurring patterns get
promoted to MEMORY.md as lessons learned.

Format: `[DATE] AREA | what happened | what fixed it | status`
Areas: config, agent, model, tool, git, auth, memory, other

## Active

<!-- New errors go here. Move to Resolved when fixed. -->

## Resolved

[2026-02-18] config | config.patch resolves ${VAR} to plaintext | avoid config.patch for secrets (bug #15932) | permanent workaround
[2026-02-18] git | HTTPS push failed — no credentials cached | needs PAT or SSH key setup | pending user action
[2026-02-17] agent | self-lockout after sandbox misconfiguration | created STABILITY.md with recovery plan requirement | resolved
[2026-02-15] auth | gateway auth failed on first session | edited config file directly | resolved
