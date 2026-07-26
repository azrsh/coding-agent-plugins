---
name: retrospective-capture
description: Use after repeated related user corrections, a reverted workaround, a behavior fix that passed checks but failed in use, or an explicit retrospective request. Helps reconstruct what happened, identify earlier catch points, and decide what project knowledge or process should be encoded without creating stale implementation summaries.
---

# Retrospective Capture

## Overview

Use this skill to turn a correction loop into a smaller future guardrail. The goal is not to write a long incident log; it is to identify what should change in the working process, tests, docs, ADRs, or repo-local skills so the same class of mistake is easier to catch.

## When To Use

Use this skill when any of these apply:

- The user has made two or more related corrections on the same behavior.
- A workaround or hack was added and then rolled back.
- A change passed local verification but failed in the user's actual workflow.
- The user asks how the issue could have been noticed earlier.
- The user asks how to encode a lesson, process, or retrospective outcome into the repository.

Do not use this for routine single-pass bug fixes unless the user asks for a retrospective.

## Workflow

1. Reconstruct the timeline from concrete sources: user reports, commits, diffs, relevant code, tests, docs, and ADRs. Separate observed facts from assumptions.
2. Name the intended invariant that should have guided the work. Prefer user-visible behavior and ownership of interaction state over implementation mechanisms.
3. Classify the miss. Common classes include missing product invariant, platform or framework constraint, verification gap, workaround smell, wrong abstraction boundary, and missing retrieval trigger.
4. Find the earliest catch point. Ask what signal first showed the direction was wrong, what question would have exposed it, and what test or manual scenario would have made it visible.
5. Run a documentation placement pass. Use the `documentation-principles` skill before deciding whether to encode anything, where it belongs, and what should deliberately remain in code or tests only.
6. Produce a compact outcome: what happened, what should have caught it earlier, what guardrail to add, and what not to document.

## Encoding Placement Pass

Do not copy placement rules into this skill. Treat `documentation-principles` as the source of truth for deciding whether the lesson belongs in an ADR, test, todo item, setup doc, code comment, `AGENTS.md` trigger, repo-local skill, or nowhere.

Use these prompts during the placement pass:

- Is this a durable decision, executable behavior, future work, operational procedure, or reusable agent workflow?
- Would documenting this duplicate behavior that code or tests already make clear?
- Does a future agent need a conditional reading trigger in `AGENTS.md` to find the right source at the right time?
- Is the smallest durable container enough, or would the proposed document become a stale current-state summary?

## Output Shape

When reporting the retrospective, keep it concise and actionable:

- Timeline: the smallest sequence of facts needed to understand the failure.
- Earliest catch: the first point where the issue could reasonably have been detected.
- Guardrail: the process, test, ADR, trigger, or skill change that would reduce recurrence.
- Non-goals: knowledge that should not be documented because the existing code, tests, or ADRs are already the better source of truth.

If the user asks to implement the guardrail, make the smallest scoped repository change, run the appropriate verification, and commit the unit of work.
