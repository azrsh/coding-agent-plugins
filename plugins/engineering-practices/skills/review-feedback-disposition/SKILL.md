---
name: review-feedback-disposition
description: Use when receiving code review feedback from any reviewer — a human, Copilot or another bot, CI annotations, or a review subagent — before implementing the suggestions. Treat findings as evidence to verify against the codebase, not instructions to follow; push back with technical reasoning when a finding is wrong.
---

# Review Feedback Disposition

## Core Rule

Review findings are evidence, not authority. Verify each finding against the codebase, tests, repository instructions, and ADRs before implementing it. The agent handling the feedback owns the disposition of every finding: implement, push back, or escalate to the user.

## Disposition

For each finding:

1. Restate the technical requirement in your own words. If any finding in the batch is unclear, resolve all unclear items before implementing any of them; findings are often related, and implementing a partial understanding produces wrong changes.
2. Verify against reality: does the suggestion hold for this codebase, this platform matrix, this version floor? Is there a deliberate reason the current implementation is the way it is?
3. If the finding is correct, fix it and state the fix. Skip performative agreement and gratitude; the fix itself is the acknowledgment.
4. If the finding is wrong, push back with technical reasoning: cite the code, tests, or constraints that contradict it. If you cannot verify it either way, say so and ask how to proceed instead of implementing blind.
5. If the finding conflicts with the user's prior decisions or an ADR, surface the conflict to the user instead of choosing a side.

When a reviewer asks to "implement X properly," check whether X is used at all before expanding it. If nothing calls it, propose removing it instead.

## Implementation Order

Resolve every unclear item first, then implement: blocking issues, then simple fixes, then complex fixes. Test each fix individually and confirm no regressions before moving to the next.

## Correcting Your Own Pushback

If you pushed back and turn out to be wrong, state the correction factually with what you checked, then fix it. Skip extended apologies and do not defend the original pushback.
