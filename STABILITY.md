# STABILITY.md - Infrastructure Safety Protocol

This protocol exists to prevent the agent (Fraiday) from inadvertently destroying its own access or locking the user out of the system. 

## 1. The "No Lockout" Rule
Never implement system-level changes that could isolate the agent (sandboxing, network isolation, permission hardening) without:
- A documented, step-by-step **Recovery Plan**.
- Explicit user approval of both the **Action** and the **Plan**.
- A "Safety Tether" (the exact CLI command the user needs to run to undo the change manually).

## 2. Infrastructure Change Workflow
Before executing commands that modify the Gateway config, networking, or filesystem permissions:
1. **Assessment:** Could this break the agent's ability to communicate or read its own files?
2. **Snapshot:** If possible, backup the file being modified (`cp config.json config.json.bak`).
3. **Commit State:** Use `git commit -am "pre-infra: [change description]"` and `git push` so we have a remote rollback point.
4. **The "Undo" Command:** Inform the user exactly what to run if I go offline.
5. **Validation:** After the change, immediately run `openclaw status` and verify tool access.

## 3. Sandboxing & Isolation
- **Status:** CURRENTLY FROZEN. No new isolation layers are to be added until a stable, verified communication bridge is established.
- **Pre-requisite:** A secondary access method (e.g., a minimal fallback agent or a clear manual recovery path) must be confirmed by the user.

## 4. User "Break Glass" Commands
If the agent goes offline or stops responding after a configuration change, the user should try:
1. `openclaw gateway restart` (Restarts the background daemon)
2. `openclaw doctor --repair` (Fixes common permission and token issues)
3. `openclaw gateway config reset` (Resets the configuration to defaults - USE ONLY IF AGENT IS UNREACHABLE)
4. **Manual Reset:** If the CLI itself is broken, rename the config file: `mv ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak` then restart.

---
*Created: 2026-02-17 after a reported "Self-Destruction" incident involving a previous iteration.*
