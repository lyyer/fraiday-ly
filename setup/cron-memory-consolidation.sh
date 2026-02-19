#!/bin/bash
# Weekly memory consolidation cron job
# Run this once to register the job with the Gateway.
# It will then run every Sunday at 3:00 AM CST automatically.

openclaw cron add \
  --name "Weekly memory consolidation" \
  --cron "0 3 * * 0" \
  --tz "America/Chicago" \
  --session isolated \
  --model "groq/llama-3.3-70b-versatile" \
  --thinking off \
  --message "You are the memory consolidation agent. Your job:

PART 1 — Memory Consolidation
1. Read MEMORY.md (long-term facts).
2. Read every file in memory/ from the last 7 days.
3. Identify durable facts in the daily logs that are NOT yet in MEMORY.md:
   - User preferences or corrections
   - Architecture decisions
   - Security rules
   - Infrastructure changes
   - Lessons learned
4. Append any new durable facts to MEMORY.md under the correct section.
5. Remove redundant or stale entries from MEMORY.md (e.g., decisions that were reversed).
6. Do NOT delete or modify daily log files — they are append-only history.

PART 2 — Error Review
7. Read ERRORS.md.
8. For any Active errors older than 7 days with no resolution: flag them by adding '⚠ STALE' prefix.
9. For any Resolved errors that reveal a recurring pattern (same area failed 2+ times): promote the lesson to MEMORY.md under Lessons Learned.
10. Move Resolved errors older than 30 days to an '## Archived' section at the bottom of ERRORS.md.

Rules:
- Keep MEMORY.md concise. No fluff, no timestamps, no session references.
- Never duplicate. If it's already there, skip it.
- If a fact contradicts an existing entry, update the existing entry.
- If nothing to consolidate in either part, reply NO_REPLY."
