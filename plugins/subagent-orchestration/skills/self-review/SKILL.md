---
name: self-review
description: Run a review-only subagent over the current unit-of-work diff before committing when the change crosses a high-risk boundary, follows repeated failed fix cycles, concludes a long autonomous run, or when the user or repository instructions explicitly request review. Do not add a reviewer subagent to ordinary diffs with no high-risk boundary; current models verify routine work themselves.
---

# Self Review

## Overview

Use this skill as a final quality gate before committing a meaningful unit of work. The main agent keeps responsibility for the implementation and final judgment; the subagent provides an independent review of the diff and must not edit files.

## Decision Rules

Run self-review before committing when at least one of these holds:

- The diff crosses one or more high-risk boundaries (defined below).
- Two or more fix or review cycles for the same behavior have already failed.
- The unit of work concludes a long autonomous run whose intermediate output the user has not been reviewing.
- The user or repository instructions explicitly request a review.

Otherwise skip the reviewer subagent and rely on the model's own verification. A mandatory reviewer on ordinary diffs causes over-verification: it adds cost and latency without improving quality on current models.

If a review is warranted but subagent tools are unavailable, report that the self-review could not be performed. Do not invent a subagent review.

Run self-review only after:

- All workers, including read-only research workers, are inactive.
- Their work is fully integrated.
- Initial verification for the integrated unit has completed.

Use `$subagent-routing` as the source of truth for runtime model resolution, fork rules, and slot lifecycle. Select a logical review route from the risk classification below, then follow `$subagent-routing` without hard-pinning a model ID or reproducing its routing algorithm:

- `frontier-medium`: a review triggered by a long autonomous run or an explicit request, with no high-risk boundary.
- `frontier-high`: exactly one high-risk boundary.
- `frontier-xhigh`: two or more independent high-risk boundaries, or two or more failed fix/review cycles for the same behavior.

High-risk boundaries include runtime state persistence or migrations, provider side-effect boundaries, task/action state machines, security boundaries, public interfaces, major ADR or architecture changes, and shared abstraction boundary changes. Count independent boundaries, not files or modules. File or module count alone must not raise the route.

## Workflow

1. Gather a review packet:
   - User request and intended outcome.
   - `git status --short`.
   - Relevant `git diff` for the current unit of work.
   - Verification already run, including skipped checks and why.
   - Relevant repo instructions, docs, ADRs, or todo considerations if the diff touches those areas.
2. Classify the review route and record the risk evidence. Do not raise the route for file or module count alone.
3. Resolve the route and spawn arguments through `$subagent-routing`.
4. Spawn one fresh, dedicated reviewer. Never reuse a planner, implementation worker, or earlier reviewer.
5. Ask for findings only, ordered by severity, and wait for the result before committing.
6. Have the parent agent disposition every finding, apply valid fixes, and run final verification.
7. If a fix is substantial, repeat the gate with another fresh reviewer. Do not send a follow-up review to the previous reviewer.
8. Commit only after findings are handled and final verification passes.

Do not include unrelated dirty worktree changes in the review packet unless they are part of the current unit of work.

## Delegation Prompt

Use or adapt this prompt:

```text
You are a read-only self-reviewer. Do not edit files. Do not spawn subagents.

Goal:
<user request and intended outcome>

Current unit of work:
<short summary of changed behavior and files>

Risk classification:
<frontier-medium, frontier-high, or frontier-xhigh>

Risk evidence:
<identified high-risk boundaries or evidence that none apply; failed fix/review cycles if relevant>

Review packet:
<git status, relevant diff, verification already run, skipped checks, and relevant repo instructions/docs/ADRs>

Review along two separate axes and report each under its own heading. Do not merge or rerank findings across axes: a diff can pass one axis and fail the other, and keeping them separate stops one axis from masking the other.

Axis 1 — Implementation quality:
1. Behavioral bugs or regressions.
2. Missed repository instructions.
3. Missing or weak tests.
4. Documentation, ADR, or todo-tracking conflicts.
5. Verification gaps.

Axis 2 — Spec fidelity:
1. Requested behavior that is missing or partial.
2. Behavior in the diff that was not requested (scope creep).
3. Behavior that looks implemented but appears wrong against the stated goal.

Return findings only, ordered by severity within each axis. Each finding must include:
- Severity: P0/P1/P2/P3
- Whether it is a hard violation (contradicts documented instructions, tests, or observed behavior) or a judgement call
- File and line if possible
- Why it matters
- Suggested fix

Report everything you find, including low-severity issues. Do not self-filter by severity or suppress findings you consider minor; the parent agent filters findings in a separate pass.
```

## Output Use

Treat the subagent result as review input, not authority. If a finding conflicts with repository instructions, ADRs, code, tests, or the user's request, prefer the stronger source of truth and briefly note the reason if it affects the final result.

The parent agent owns finding disposition, fixes, final verification, and the commit. When reporting completion, mention that self-review ran and summarize only material findings and fixes.
