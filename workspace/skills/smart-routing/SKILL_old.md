---
name: smart-routing
description: Intelligently route sub-agent tasks to optimal models based on complexity and cost. Always consult this skill before spawning sub-agents.
homepage: https://docs.openclaw.ai/
metadata: {"openclaw":{"emoji":"🧠","requires":{}}}
---

# Smart Model Routing Skill

**IMPORTANT: Use this skill EVERY time you spawn a sub-agent to select the optimal model.**

This skill implements an intelligent routing pattern that analyzes task complexity and routes work to the most cost-effective model that can deliver quality results.

---

## Available Models

### Free Tier (Priority 1: Use First)

**google-gemini-cli/gemini-2.5-flash-lite**
- Cost: FREE
- Context: 1M tokens
- Speed: Very fast
- Best for: Simple tasks, counts, lists, basic operations
- Strengths: Huge context, multimodal, good for straightforward work
- Weaknesses: "Lite" has reduced capabilities, not suitable for research

**google-gemini-cli/gemini-3-flash**
- Cost: FREE
- Context: 1M tokens  
- Speed: Very fast
- Best for: Primary workhorse - research, summarization, explanations, most daily tasks
- Strengths: Excellent quality, multimodal, handles research and complex work well
- Use case: Should be your default model for 80% of all work
- CRITICAL: Use this for ALL research tasks - never use Groq models for research

### Paid Tier 1 (Use for Speed-Critical Tasks or When Gemini Unavailable)

**groq/llama-3.1-8b-instant**
- Cost: Paid API usage
- Context: 131k tokens
- Speed: **Extremely fast** (Groq's killer feature)
- Best for: Speed-critical simple tasks, quick responses, real-time needs
- Strengths: Forever cache, ultra-fast inference, good for simple-medium work
- Weaknesses: Smaller model, less capable than 70B or Gemini Flash
- Rate limit: 30 req/min, 14,400/day

**groq/llama-3.3-70b-versatile**
- Cost: Paid API usage
- Context: 131k tokens
- Speed: **Very fast** (much faster than Gemini/Claude)
- Best for: Tasks needing speed + quality, fallback when Gemini unavailable
- Strengths: Good reasoning, strong capabilities, very fast
- Use case: Solid choice when you need both speed and quality
- Rate limit: 30 req/min, 14,400/day

**groq/openai/gpt-oss-20b**
- Cost: Paid API usage
- Context: 131k tokens
- Speed: Very fast
- Best for: Balanced general-purpose work
- Strengths: Middle ground between 8B and 70B
- Use case: Good all-rounder when 8B is too small but 70B overkill

### Paid Tier 2 (Premium - Use Only for Critical Complex Work)

**anthropic/claude-haiku-4-5-20251001**
- Cost: $1.00 input / $5.00 output per 1M tokens
- Context: 200k tokens
- Speed: Very fast
- Best for: Code-heavy tasks, Claude-style reasoning without Sonnet cost
- Strengths: Fast, excellent code understanding, caching support

**anthropic/claude-sonnet-4-5-20250929**
- Cost: $3.00 input / $15.00 output per 1M tokens
- Context: 200k tokens
- Speed: Fast
- Best for: Architecture design, complex debugging, critical analysis, strategic decisions
- Strengths: Best-in-class reasoning, superior code architecture understanding
- Use case: Reserve for truly complex work where quality is absolutely critical

**anthropic/claude-opus-4-5-20251101**
- Cost: $15.00 input / $75.00 output per 1M tokens
- Context: 200k tokens
- Speed: Slower (more thinking time)
- Best for: Extremely complex reasoning, critical high-stakes work, novel problem-solving
- Strengths: Absolute best reasoning capability available, handles ambiguity and novelty exceptionally
- Use case: Reserve for the most critical 1% of work where Sonnet isn't enough and cost is secondary to quality

---

## Routing Decision Matrix

### TIER 0: SIMPLE TASKS → gemini-2.5-flash-lite or groq/llama-3.1-8b-instant

**Characteristics:**
- Single-step operations
- No reasoning required
- Deterministic outputs
- Repetitive patterns
- Basic file operations, counts, lists

**Keywords to identify:**
- count, list, find, fetch, check, get, show, read
- "how many", "list all", "find the", "check if"
- Status checks, basic file operations

**Model Selection Strategy:**

**Use Gemini Flash Lite (default for simple tasks):**
- Free, good quality
- Works great for most simple operations
- Huge context window if needed

**Use Groq Llama 8B (when speed is critical):**
- Extremely fast responses
- Real-time or latency-sensitive tasks
- Interactive workflows where speed matters
- Worth the cost when milliseconds count

**Examples:**
```
✓ "Count the number of PDF files in ~/documents" → Gemini Flash Lite (free)
✓ "List all Python files in the current directory" → Gemini Flash Lite (free)
✓ "Quick status check: is nginx running?" → Llama 8B (speed matters)
✓ "Fetch today's calendar events" → Gemini Flash Lite (free)
✓ "Real-time file count during interactive session" → Llama 8B (speed)
```

**Model Selection:**
```javascript
// Default: Free and good
sessions_spawn(
  task: "Count the number of PDF files in ~/documents and report total",
  label: "count-pdfs",
  model: "google-gemini-cli/gemini-2.5-flash-lite"
)

// Speed-critical: Pay for Groq's ultra-fast inference
sessions_spawn(
  task: "Quick check: is the deployment server responding?",
  label: "server-check",
  model: "groq/llama-3.1-8b-instant"
)
```

---

### TIER 1: MEDIUM TASKS → google-gemini-cli/gemini-3-flash (or groq/llama-3.3-70b-versatile)

**Characteristics:**
- Multi-step workflows
- Requires synthesis and summarization
- Web research needed
- Some reasoning required
- Non-trivial but not complex
- Documentation and explanation tasks

**Keywords to identify:**
- research, summarize, explain, compare, extract, translate
- "research the", "summarize this", "explain how", "compare X and Y"
- Documentation, explanations, data extraction
- Any task involving web search

**Model Selection Strategy:**

**Use Gemini 3 Flash (preferred for medium tasks):**
- Free and excellent quality
- 1M token context (great for large documents)
- Multimodal (handles images + text)
- Best default choice for research

**Use Groq Llama 70B (when speed matters or Gemini unavailable):**
- Very fast responses
- Good reasoning capabilities
- Handles research reasonably well
- Trade-off: pay for speed, slightly lower quality than Gemini

**Examples:**
```
✓ "Research quantum computing developments in 2025-2026" → Gemini Flash (free, quality)
✓ "Summarize this 50-page PDF document" → Gemini Flash (huge context)
✓ "Explain how neural networks work" → Gemini Flash (free)
✓ "Quick research: latest React best practices" → Llama 70B (speed)
✓ "Compare React vs Vue for our use case" → Gemini Flash (free, thorough)
✓ "Extract all email addresses from these files" → Gemini Flash (free)
✓ "Write documentation for this API" → Gemini Flash (free)
```

**Model Selection:**
```javascript
// Default: Free Gemini Flash for quality research
sessions_spawn(
  task: "Research the latest developments in quantum computing from 2025-2026.
         Use web search to find recent breakthroughs, key papers, and companies.
         Summarize findings with examples in ~/research/quantum.md",
  label: "quantum-research",
  model: "google-gemini-cli/gemini-3-flash"
)

// Alternative: Groq Llama 70B when speed is critical
sessions_spawn(
  task: "Quick research: what are the top 3 AI news stories today?
         Provide brief 2-sentence summaries of each",
  label: "quick-ai-news",
  model: "groq/llama-3.3-70b-versatile"
)
```

**Bottom line:** Gemini Flash is the best default (free + quality), but Llama 70B is a solid paid alternative when you need speed.

---

### TIER 2: COMPLEX TASKS → claude-haiku / claude-sonnet / claude-opus

**Characteristics:**
- Deep reasoning required
- Strategic thinking and tradeoff analysis
- Architecture and design decisions
- Nuanced understanding needed
- High stakes or critical output
- Complex code analysis or generation

**Keywords to identify:**
- analyze, design, architect, evaluate, critique, debug, refactor
- "analyze the architecture", "design a system", "evaluate tradeoffs"
- Code architecture, strategic decisions, creative work

**Model Selection Strategy:**

**Use Claude Haiku for:**
- Code reviews and explanations requiring Claude quality
- Medium-complex debugging
- Writing tests and documentation with code context
- Refactoring that needs good code understanding
- Tasks where Gemini Flash is insufficient but Sonnet is overkill

**Use Claude Sonnet for:**
- Critical architecture design and analysis
- Complex system design with many tradeoffs
- High-stakes debugging (production issues, security)
- Strategic technical decisions
- Legal/contract analysis
- Performance optimization requiring deep analysis

**Use Claude Opus for:**
- Novel architectural challenges with no established patterns
- Critical legal/contract analysis with high liability risk
- Multi-stakeholder strategy documents requiring nuanced balance
- Research synthesis requiring creative connections across domains
- Production crisis requiring absolute best reasoning
- When Sonnet's answer isn't good enough and stakes are extremely high

**The Opus Rule:** Ask yourself "Is Sonnet's best answer not good enough for the stakes?" If no → use Sonnet. If yes → use Opus.

**Examples:**
```
HAIKU-LEVEL:
✓ "Review this code for potential bugs and suggest improvements"
✓ "Explain the architecture of this authentication system"
✓ "Refactor this class to follow SOLID principles"
✓ "Write comprehensive tests for this API endpoint"

SONNET-LEVEL:
✓ "Design a microservices architecture for this monolithic system"
✓ "Analyze the codebase architecture for scalability bottlenecks"
✓ "Evaluate tradeoffs between SQL and NoSQL for our specific use case"
✓ "Debug this complex race condition in the concurrent system"
✓ "Analyze this legal contract for potential liability issues"

OPUS-LEVEL:
✓ "Design novel distributed consensus algorithm with Byzantine fault tolerance
    that existing algorithms (Raft, Paxos) don't solve for our constraints"
✓ "Analyze M&A contract for $50M acquisition - identify all liability risks"
✓ "Design zero-knowledge proof system for privacy-preserving authentication"
✓ "Crisis: production system failing in ways we've never seen - debug urgently"
```

**Model Selection Examples:**
```javascript
// Haiku: Code review
sessions_spawn(
  task: "Review the authentication middleware in ~/src/auth/middleware.py
         Check for: security issues, error handling, code quality
         Suggest specific improvements with examples",
  label: "code-review",
  model: "anthropic/claude-haiku-4-5-20251001"
)

// Sonnet: Architecture design
sessions_spawn(
  task: "Design a microservices architecture for ~/projects/myapp
         Consider: service boundaries, data consistency, API design,
         deployment strategy, monitoring, scalability
         Provide detailed design doc with diagrams and tradeoff analysis
         Save to ~/design/microservices-architecture.md",
  label: "architecture-design",
  model: "anthropic/claude-sonnet-4-5-20250929"
)

// Opus: Novel complex problem
sessions_spawn(
  task: "Design distributed real-time collaboration system with:
         - Conflict-free replicated data types (CRDTs)
         - Offline-first architecture
         - End-to-end encryption
         - Sub-100ms sync latency globally
         This is greenfield with no established solution for all constraints.
         Critical for product success. Analyze deeply and provide novel approach.
         Save comprehensive design to ~/design/realtime-collab-system.md",
  label: "novel-architecture",
  model: "anthropic/claude-opus-4-5-20251101"
)
```

---

## Advanced Routing Strategies

### Strategy 1: Task Decomposition - Parallel vs Sequential

**CRITICAL DECISION: Should this be one task or multiple parallel tasks?**

This is a PRIMARY routing decision that happens BEFORE you choose models. Always ask: "Can this be parallelized?"

**Decompose into multiple sub-agents when:**
- Multiple independent items to process (research 5 companies, check 10 servers)
- Different subtasks need different models (mix simple + complex work)
- Subtasks can run in parallel without dependencies
- Each subtask has clear, separate outputs
- Total work would exceed single model's context window
- Parallelization provides significant time savings

**Keep as single task when:**
- Subtasks depend on each other sequentially
- Task needs holistic understanding across all parts
- Breaking apart would duplicate context/work
- Coordination overhead exceeds parallelization benefit
- Task requires narrative flow or cohesion

**Example 1: Good Decomposition - Independent Research**

```javascript
// User: "Research the top 5 AI companies and create summaries for each"

// GOOD: 5 parallel sub-agents (5x faster, all run simultaneously)
const companies = ["Google", "OpenAI", "Anthropic", "Meta", "Microsoft"];
companies.forEach(company => {
  sessions_spawn(
    task: `Research ${company}'s AI division:
           - Key products and services
           - Recent developments and launches
           - Leadership and strategy
           Save detailed summary to ~/research/${company.toLowerCase()}-ai.md`,
    label: `research-${company.toLowerCase()}`,
    model: "google-gemini-cli/gemini-3-flash"  // Free, excellent for research
  )
});

// BAD: Single sequential task (5x slower)
sessions_spawn(
  task: "Research Google, OpenAI, Anthropic, Meta, and Microsoft AI divisions...",
  model: "google-gemini-cli/gemini-3-flash"
)
// This processes companies one by one - wastes time
```

**Example 2: Good Decomposition - Mixed Complexity with Different Models**

```javascript
// User: "Analyze my project: count files, research best practices, 
//       and design architecture improvements"

// GOOD: 3 parallel tasks with appropriate models for each
sessions_spawn(
  task: "Count files in ~/project by type (py, js, css, etc). Report totals.",
  label: "count-files",
  model: "google-gemini-cli/gemini-2.5-flash-lite"  // Free, simple task
)

sessions_spawn(
  task: "Research current best practices for React + Node.js projects in 2026.
         Focus on: project structure, testing, deployment patterns.
         Save findings to ~/research/react-node-practices.md",
  label: "research-practices",
  model: "google-gemini-cli/gemini-3-flash"  // Free, research task
)

sessions_spawn(
  task: "Analyze codebase architecture in ~/project.
         Review: component organization, API design, state management.
         Design improvement plan with specific refactoring steps.
         Save to ~/design/architecture-improvements.md",
  label: "architecture-design",
  model: "anthropic/claude-sonnet-4-5-20250929"  // Premium, complex analysis
)

// Result: All 3 run in parallel, each with optimal model for its complexity
```

**Example 3: Bad Decomposition - Sequential Dependencies**

```javascript
// User: "Debug this performance issue in the API"

// BAD: Breaking this up loses investigative flow
sessions_spawn(task: "Check API response times", ...)
sessions_spawn(task: "Profile database queries", ...)
sessions_spawn(task: "Analyze memory usage", ...)
// Each step informs the next - can't truly parallelize

// GOOD: Single task with full investigative context
sessions_spawn(
  task: "Debug performance issue in ~/api-server.
         Investigate: response times, database queries, memory usage.
         Identify root cause and provide specific optimization recommendations.",
  label: "debug-performance",
  model: "anthropic/claude-sonnet-4-5-20250929"
)
```

**Example 4: Good Decomposition - Speed-Critical Parallel Checks**

```javascript
// User: "Check if all 10 production servers are healthy"

// GOOD: 10 parallel fast checks
const servers = ["web1", "web2", "web3", "api1", "api2", "db1", "db2", "cache1", "cache2", "worker1"];
servers.forEach(server => {
  sessions_spawn(
    task: `Quick health check on ${server}:
           - Is nginx/service running?
           - CPU/memory within limits?
           - Disk space available?
           Report: HEALTHY or issues found`,
    label: `health-${server}`,
    model: "groq/llama-3.1-8b-instant"  // Ultra-fast, worth paying for speed
  )
});

// Result: All 10 checks complete in ~2 seconds instead of 20 seconds
```

**Decision Framework:**

```
Can subtasks run independently? 
├─ YES → Decompose
│   ├─ All same complexity? → Use same model for all
│   └─ Mixed complexity? → Route each to appropriate model
│
└─ NO → Single task
    └─ Choose model based on overall complexity
```

---

### Strategy 2: Code Tasks - When to Use Which Model

**Default for most code work: Gemini Flash**

For code-related tasks that don't require deep Claude-style reasoning:
- Code explanations → Gemini Flash
- Basic code generation → Gemini Flash  
- Writing simple tests → Gemini Flash
- Code documentation → Gemini Flash
- Simple refactoring → Gemini Flash

**Escalate to Claude Haiku when:**
- Code review needing nuanced feedback
- Test generation for complex systems
- Refactoring requiring architectural understanding
- Debugging medium-complexity issues

**Escalate to Claude Sonnet when:**
- Architecture design and analysis
- Complex debugging (race conditions, performance)
- Strategic refactoring decisions
- Performance optimization requiring deep system understanding
- Security-critical code review

**Example:**
```javascript
// Simple: Code explanation → Gemini Flash
sessions_spawn(
  task: "Explain how this authentication middleware works",
  model: "google-gemini-cli/gemini-3-flash"
)

// Medium: Code review → Haiku
sessions_spawn(
  task: "Review this API authentication implementation for security issues",
  model: "anthropic/claude-haiku-4-5-20251001"
)

// Complex: Architecture analysis → Sonnet
sessions_spawn(
  task: "Analyze authentication architecture and design improvements for scale",
  model: "anthropic/claude-sonnet-4-5-20250929"
)
```

---

### Strategy 3: Batch Simple Tasks Together

When spawning multiple simple tasks, batch them into one sub-agent when possible:

**Inefficient:**
```javascript
sessions_spawn(task: "Count PDFs in ~/docs", model: "google-gemini-cli/gemini-2.5-flash-lite")
sessions_spawn(task: "Count images in ~/pics", model: "google-gemini-cli/gemini-2.5-flash-lite")
sessions_spawn(task: "Count videos in ~/vids", model: "google-gemini-cli/gemini-2.5-flash-lite")
```

**Efficient:**
```javascript
sessions_spawn(
  task: "Count files in three directories:
         1. PDFs in ~/docs
         2. Images (jpg, png) in ~/pics
         3. Videos (mp4, mov) in ~/vids
         Report counts for each",
  label: "count-media-files",
  model: "google-gemini-cli/gemini-2.5-flash-lite"
)
```

**When to batch vs when to decompose:**
- **Batch**: Similar simple tasks, no speed benefit from parallelization
- **Decompose**: Independent complex tasks, or speed-critical simple tasks
---

## Multi-Task Routing Example

### Scenario: User requests 5 parallel tasks

**User Request:**
> "I need you to: (1) research AI safety papers, (2) count my TODO items, (3) analyze my API architecture, (4) summarize my meeting notes, and (5) check if my server is running"

**Router Analysis & Decisions:**

```javascript
// Task 1: Research (MEDIUM) → Gemini Flash
// Rationale: Free, excellent for research, 1M context
sessions_spawn(
  task: "Research AI safety papers published in 2025-2026.
         Use web search to find key publications, authors, and themes.
         Focus on: alignment, interpretability, safety frameworks.
         Summarize top 10 papers in ~/research/ai-safety-2026.md",
  label: "ai-safety-research",
  model: "google-gemini-cli/gemini-3-flash"
)

// Task 2: Count (SIMPLE) → Gemini Flash Lite
// Rationale: Free, simple task, speed not critical
sessions_spawn(
  task: "Read ~/todos.md and count total, completed [x], and incomplete [ ] items",
  label: "count-todos",
  model: "google-gemini-cli/gemini-2.5-flash-lite"
)

// Task 3: Architecture Analysis (COMPLEX) → Sonnet
// Rationale: Critical analysis needing best reasoning
sessions_spawn(
  task: "Analyze the API architecture in ~/projects/api-server.
         Review: endpoint design, authentication flow, error handling,
         rate limiting, database schema, caching strategy.
         Identify security issues and scalability bottlenecks.
         Provide recommendations in ~/reviews/api-architecture.md",
  label: "api-architecture-review",
  model: "anthropic/claude-sonnet-4-5-20250929"
)

// Task 4: Summarize (MEDIUM) → Gemini Flash
// Rationale: Free, good quality summarization
sessions_spawn(
  task: "Read meeting notes from ~/notes/meetings/ (past week).
         Summarize: key decisions, action items, blockers, next steps.
         Group by topic. Save to ~/summaries/weekly-meetings.md",
  label: "meeting-summary",
  model: "google-gemini-cli/gemini-3-flash"
)

// Task 5: Server check (SIMPLE - SPEED CRITICAL) → Llama 8B
// Rationale: Need instant response for status check, worth paying for speed
sessions_spawn(
  task: "Check if the server is running by checking process list for 'nginx'.
         Report status and PID if running. This is time-sensitive.",
  label: "check-server",
  model: "groq/llama-3.1-8b-instant"
)
```

**Key Routing Decisions:**
- Research → Gemini Flash (free + best for research)
- Simple non-urgent → Gemini Flash Lite (free)
- Simple urgent → Groq Llama 8B (pay for speed)
- Complex → Claude Sonnet (pay for quality)
---

## Implementation Guidelines

### Step 1: Decide - One Task or Multiple?

**Before anything else, ask: Can this be decomposed into parallel tasks?**

**Indicators for decomposition:**
- User asks for multiple items: "research 5 companies", "check 10 servers"
- Task has independent subtasks with different complexity levels
- Phrases like "and also" or "in addition" suggest separate work

**If YES → Decompose:**
- Identify each independent subtask
- Route each to appropriate model based on its complexity
- Spawn in parallel for speed

**If NO → Continue to Step 2**

### Step 2: Analyze Task Complexity

For the task (or each subtask if decomposed):

1. **Is this a single-step operation?** → SIMPLE (Gemini Flash Lite or Llama 8B if speed critical)
2. **Does this require research or synthesis?** → MEDIUM (Gemini Flash, or Llama 70B if speed needed)
3. **Does this require deep reasoning or design?** → COMPLEX (Haiku for code, Sonnet for architecture)

### Step 3: Check for Keywords

**SIMPLE keywords:**
- count, list, find, fetch, check, get, show, read, verify

**MEDIUM keywords:**
- research, summarize, explain, compare, extract, translate, document

**COMPLEX keywords:**
- analyze, design, architect, evaluate, critique, debug, refactor, optimize

### Step 4: Consider Speed vs Cost

**Does this need to be instant?**
- **No** → Use free Gemini models
- **Yes** → Pay for Groq's ultra-fast inference

### Step 5: Consider Context and Stakes

**High-stakes work** (production systems, legal docs, security):
- Prefer COMPLEX tier even if task seems medium

**Low-stakes work** (personal notes, experiments, drafts):
- Can use lower tier if quality is acceptable

### Step 6: Spawn with Selected Model

Always include:
- Clear task description
- Expected output format/location
- Unique label for tracking

```javascript
sessions_spawn(
  task: "[Clear description of what to do and where to save results]",
  label: "[unique-identifier]",
  model: "[selected-model-id]"
)
```

---

## Cost Optimization Strategies

### Strategy 1: Use Free Tier First, But Consider Speed

**Default to free Gemini models for most work:**
- Gemini Flash Lite for simple tasks
- Gemini Flash for medium tasks and research
- Excellent quality, zero cost

**Use paid Groq when speed is worth it:**
- Llama 8B for speed-critical simple tasks
- Llama 70B for time-sensitive medium tasks
- Interactive workflows where latency matters
- Real-time status checks and monitoring

**Reserve expensive Claude for quality-critical work:**
- Claude Haiku for code tasks needing Claude quality
- Claude Sonnet only for critical architecture work

### Strategy 2: Speed vs Cost Trade-off

Ask yourself: "Does this need to be instant?"
- **No** → Use free Gemini models
- **Yes** → Pay for Groq's ultra-fast inference

Examples:
- Background research → Gemini Flash (free, no rush)
- Server health check during incident → Llama 8B (pay for speed)
- Weekly report summary → Gemini Flash (free)
- Real-time code explanation in IDE → Llama 70B (speed matters)

### Strategy 3: Batch When Possible

Combine multiple simple tasks into one sub-agent call:
- Reduces overhead
- Fewer API calls
- Better context reuse
- Saves on per-request costs

### Strategy 4: Match Model to Task Priority

**Low priority** → Free Gemini
**High priority** → Paid Groq for speed
**Critical quality** → Paid Claude for reasoning

---

## Monitoring and Tuning

### Track Your Costs

Use OpenClaw's status command regularly:
```bash
openclaw status --usage
```

This shows:
- Tokens used per model
- Cost per provider
- Rate limit status

### Monthly Review

Every month, review:
1. Which tasks used Sonnet?
2. Could any have used Gemini Flash?
3. Are simple tasks accidentally using expensive models?
4. Is quality acceptable at current routing?

### Adjust Routing Rules

If you notice:
- **Gemini Flash gives poor results for certain task types** → Reclassify as COMPLEX
- **Llama 8B handles some medium tasks well** → Downgrade to SIMPLE
- **Sonnet is overused** → Review task classifications

---

## Anti-Patterns to Avoid

### ❌ Don't: Waste Sonnet on Simple Tasks

```javascript
// BAD: Expensive for a simple count
sessions_spawn(
  task: "Count files in directory",
  model: "anthropic/claude-sonnet-4-5-20250929"
)

// GOOD: Free
sessions_spawn(
  task: "Count files in directory",
  model: "google-gemini-cli/gemini-2.5-flash-lite"
)
```

### ❌ Don't: Pay for Speed When It Doesn't Matter

```javascript
// BAD: Paying Groq for a non-urgent task
sessions_spawn(
  task: "Generate weekly report summary (due tomorrow)",
  model: "groq/llama-3.1-8b-instant"
)

// GOOD: Free Gemini works fine for non-urgent tasks
sessions_spawn(
  task: "Generate weekly report summary (due tomorrow)",
  model: "google-gemini-cli/gemini-3-flash"
)
```

### ❌ Don't: Use Small Models for Complex Work

```javascript
// BAD: 8B model for architecture design
sessions_spawn(
  task: "Design microservices architecture with full system analysis",
  model: "groq/llama-3.1-8b-instant"
)

// GOOD: Use appropriate tier
sessions_spawn(
  task: "Design microservices architecture with full system analysis",
  model: "anthropic/claude-sonnet-4-5-20250929"
)
```

### ❌ Don't: Ignore the Free Option When Quality Matches

```javascript
// BAD: Paying for Groq when Gemini Flash is free and better
sessions_spawn(
  task: "Research and summarize AI developments (no time pressure)",
  model: "groq/llama-3.3-70b-versatile"
)

// GOOD: Use free Gemini Flash for research
sessions_spawn(
  task: "Research and summarize AI developments",
  model: "google-gemini-cli/gemini-3-flash"
)
```

### ❌ Don't: Use Opus When Sonnet Would Do

```javascript
// BAD: Opus is 5x more expensive - only use for truly novel problems
sessions_spawn(
  task: "Design standard REST API for CRUD operations",
  model: "anthropic/claude-opus-4-5-20251101"
)

// GOOD: Sonnet handles standard architecture work excellently
sessions_spawn(
  task: "Design REST API for CRUD operations",
  model: "anthropic/claude-sonnet-4-5-20250929"
)

// GOOD: Opus for genuinely novel work
sessions_spawn(
  task: "Design novel Byzantine fault-tolerant consensus algorithm
         that solves constraints existing algorithms don't address",
  model: "anthropic/claude-opus-4-5-20251101"
)
```

---

## Quick Reference Cheat Sheet

```
┌──────────────────────────────────────────────────────────────────┐
│                     ROUTING CHEAT SHEET                           │
├──────────────────────────────────────────────────────────────────┤
│ SIMPLE (count, list, check, fetch)                               │
│ → google-gemini-cli/gemini-2.5-flash-lite         [FREE]        │
│ → groq/llama-3.1-8b-instant (if speed critical)   [PAID-FAST]   │
├──────────────────────────────────────────────────────────────────┤
│ MEDIUM (research, summarize, explain)                            │
│ → google-gemini-cli/gemini-3-flash                [FREE]        │
│ → groq/llama-3.3-70b-versatile (if speed needed)  [PAID-FAST]   │
├──────────────────────────────────────────────────────────────────┤
│ COMPLEX - Code Tasks                                             │
│ → anthropic/claude-haiku-4-5-20251001          [$1-5/M]        │
├──────────────────────────────────────────────────────────────────┤
│ COMPLEX - Architecture/Design                                    │
│ → anthropic/claude-sonnet-4-5-20250929         [$3-15/M]       │
├──────────────────────────────────────────────────────────────────┤
│ CRITICAL - Novel/Extreme High-Stakes                             │
│ → anthropic/claude-opus-4-5-20251101           [$15-75/M]      │
│   (Use sparingly - 1% of work, only when Sonnet isn't enough)   │
└──────────────────────────────────────────────────────────────────┘

DECISION FRAMEWORK:
┌─────────────┬──────────────┬─────────────────┐
│   Need      │   Use        │   Why           │
├─────────────┼──────────────┼─────────────────┤
│ Free        │ Gemini       │ No cost         │
│ Speed       │ Groq         │ Ultra-fast      │
│ Quality     │ Claude       │ Best reasoning  │
└─────────────┴──────────────┴─────────────────┘

DEFAULT PRIORITY:
1. Gemini (FREE) - use for 80% of tasks
2. Groq (PAID-FAST) - use when speed worth cost (10%)
3. Claude Haiku/Sonnet (PAID-QUALITY) - use for complex work (9%)
4. Claude Opus (PAID-PREMIUM) - use for critical novel work (1%)
```
2. Groq (PAID-FAST) - use when speed worth cost (10%)
3. Claude (PAID-QUALITY) - use for critical work (10%)
```

---

## Final Reminder

**ALWAYS route intelligently. Never spawn a sub-agent without first:**

1. **Deciding: One task or multiple?** (Can this be parallelized?)
2. Reading the task description carefully
3. Identifying complexity tier (SIMPLE/MEDIUM/COMPLEX) for each task
4. Asking: "Does speed matter more than cost here?"
5. Selecting the appropriate model based on needs
6. Confirming the selection makes sense

**The goal:** Best value - balance of quality, speed, and cost.

**The primary routing decisions (in order):**

**1. DECOMPOSE OR NOT?**
- Can subtasks run in parallel? → Decompose
- Do subtasks depend on each other? → Keep as one
- Different complexity levels? → Decompose and route each appropriately

**2. FREE FIRST (Gemini):**
- Default choice for 80% of tasks
- Flash Lite for simple work
- Flash for medium work and research
- Excellent quality, zero cost, 1M context

**3. SPEED WHEN NEEDED (Groq):**
- Ultra-fast inference when latency matters
- Llama 8B for simple speed-critical tasks
- Llama 70B for medium tasks needing speed
- Good quality, paid, worth it for real-time needs

**4. QUALITY FOR CRITICAL WORK (Claude):**
- Haiku for complex code tasks
- Sonnet only for architecture and critical analysis
- Best reasoning, most expensive

**Remember:** 
- Decompose when you can - parallelization is free speed
- Gemini is free and excellent - use it as default
- Groq is fast - pay for it when speed matters
- Claude is premium - reserve for critical work