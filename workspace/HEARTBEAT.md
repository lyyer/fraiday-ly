# Heartbeat Checks (monitor agent)

Runs every 30m on cheapest model. Keep it fast.

1. Check `tasks/pending.md` for overdue items
2. Run `openclaw status --usage --json > ~/.openclaw/skills/smart-routing/routing-state.json`
3. Scan today's `memory/YYYY-MM-DD.md` for unresolved items
4. If nothing needs attention: **HEARTBEAT_OK**
5. If something needs action: report to coordinator with specifics

## Quiet Hours (23:00–08:00 CST)

- Do NOT message or notify the user
- Still run background checks (steps 1-3)
- Queue anything non-urgent for morning
- Only break quiet hours for: system down, security breach, or data loss
