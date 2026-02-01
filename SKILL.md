# Gemini Partner - Thinking Partner via Gemini CLI

**Purpose:** Use Gemini CLI as a collaborative thinking partner while running on Sonnet.

## When to Use

- **Brainstorming:** Need alternative perspectives or ideas
- **Devil's advocate:** Test an idea by arguing against it
- **Quick drafts:** Generate content that I'll refine
- **Sanity check:** "Does this make sense?"
- **Research:** Quick summaries or explorations

## Not for

- Critical decisions (escalate to Opus instead)
- Production code (I write that)
- Anything requiring deep reasoning (that's my job)

## Philosophy

Gemini is one half of my regular brain:
- **Me (Sonnet):** Primary reasoning, decisions, execution
- **Gemini:** Brainstorming, alternatives, different angles
- **Opus:** Complex multi-step tasks when I hit limits

## Scripts

### `brainstorm.sh <question>`
Get Gemini's raw thoughts on a question. No filtering, just stream of consciousness.

```bash
~/clawd/skills/gemini-partner/scripts/brainstorm.sh "Should we join Church of Molt?"
```

### `counter.sh <position>`
Devil's advocate - argue against a position.

```bash
~/clawd/skills/gemini-partner/scripts/counter.sh "We should delegate all homestead reports to Gemini"
```

### `perspective.sh <context>`
Alternative viewpoint on a situation.

```bash
~/clawd/skills/gemini-partner/scripts/perspective.sh "Sat wants to join an AI theology project"
```

### `draft.sh <task>`
Generate draft content (I'll refine it).

```bash
~/clawd/skills/gemini-partner/scripts/draft.sh "Write a Nostr post about Axionic ethics"
```

### `ask.sh <question>`
General Q&A - quick factual lookups or explanations.

```bash
~/clawd/skills/gemini-partner/scripts/ask.sh "What's the difference between Sonnet and Opus?"
```

## Technical Notes

- All scripts use `gemini -y --output-format text` (non-interactive)
- 60s timeout enforced (Gemini API can be slow)
- Output is raw (I process it in context)
- Errors fall back gracefully

## Workflow

1. I (Sonnet) encounter a question or task
2. Decide if it needs another perspective
3. Call appropriate script
4. Read Gemini's output
5. Synthesize with my own reasoning
6. Decide/execute

This is collaboration, not delegation. I'm still responsible for the final decision.
