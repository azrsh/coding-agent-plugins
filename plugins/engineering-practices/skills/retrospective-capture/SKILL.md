---
name: retrospective-capture
description: Use after repeated related corrections, a reverted workaround, a change that passed checks but failed in use, or an explicit retrospective request. Finds the intended invariant, earliest catch point, and smallest durable guardrail.
---

# Retrospective Capture

Turn a correction loop into a smaller future guardrail, not a long incident
summary.

## Analysis

Reconstruct the shortest evidence-backed timeline from the user reports, diffs,
commands, tests, documentation, logs, and observed workflow. Separate facts from
assumptions.

Name the intended invariant that should have guided the work. Prefer the
user-visible behavior, workflow expectation, or source-of-truth boundary over
the mechanism that happened to fail.

Find the earliest reasonable catch point: the first signal, question, test,
preview, or manual scenario that would have shown the direction was wrong.
Classify why it was missed, such as an absent invariant, stale source
assumption, wrong boundary, verification gap, workaround smell, or missing
retrieval trigger.

Use the `documentation-principles` skill to place a reusable lesson in the
smallest workflow, verification, or instruction surface that would have
changed the behavior. Keep case-specific or mutable facts in their own source.

## Output

Report only what changes future work:

- Timeline: the minimum facts needed to understand the miss.
- Intended invariant: the rule that should have guided the work.
- Earliest catch: where the direction first became detectably wrong.
- Guardrail: the smallest process, verification, documentation, instruction,
  or test change that reduces recurrence.
- Non-goals: facts already owned by code, tests, decisions, or dated records.

When implementation is requested, apply only the supported guardrail and verify
the behavior it is meant to change.
