---
name: self-review
description: Run a review-only subagent over the current unit-of-work diff before committing non-trivial code, test, documentation, ADR, or repo-local skill changes. Use when a coherent implementation unit is ready for commit; skip only for read-only answers, tiny typo fixes, or purely mechanical changes where the user explicitly does not want review.
---

# Self Review

## Overview

Use this skill as a final quality gate before committing a meaningful unit of work. The main agent keeps responsibility for the implementation and final judgment; the subagent provides an independent review of the diff and must not edit files.

## Decision Rules

Run self-review before committing any non-trivial unit of work that changes behavior, tests, project instructions, docs, ADRs, repo-local skills, or multiple files.

Skip self-review only for:

- Read-only answers with no repository changes.
- Tiny typo fixes with no behavioral or process impact.
- Purely mechanical changes where the user explicitly does not want review.

If subagent tools are unavailable, report that the self-review could not be performed. Do not invent a subagent review.

Run self-review only after:

- All workers, including read-only research workers, are inactive.
- Their work is fully integrated.
- Initial verification for the integrated unit has completed.

Use `$subagent-routing` as the source of truth for runtime model resolution, fork rules, and slot lifecycle. Select a logical review route from the risk classification below, then follow `$subagent-routing` without hard-pinning a model ID or reproducing its routing algorithm:

- `frontier-medium`: an ordinary non-trivial diff with no high-risk boundary.
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

Please review for:
1. Behavioral bugs or regressions.
2. Missed repository instructions.
3. Missing or weak tests.
4. Documentation, ADR, or todo-tracking conflicts.
5. Verification gaps.

Return findings only, ordered by severity. Each finding must include:
- Severity: P0/P1/P2/P3
- File and line if possible
- Why it matters
- Suggested fix

Avoid style nits unless they indicate a real correctness, maintainability, or process risk.
```

## Output Use

Treat the subagent result as review input, not authority. If a finding conflicts with repository instructions, ADRs, code, tests, or the user's request, prefer the stronger source of truth and briefly note the reason if it affects the final result.

The parent agent owns finding disposition, fixes, final verification, and the commit. When reporting completion, mention that self-review ran and summarize only material findings and fixes.
