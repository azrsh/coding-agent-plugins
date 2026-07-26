---
name: parallel-implementation
description: Use when the user asks to parallelize implementation or bounded read-only research with subagents, worker agents, fan-out execution, or multiple agents making changes. Helps split work into disjoint ownership slices, route workers by difficulty, delegate safely, integrate results, and keep final verification centralized.
---

# Parallel Implementation

Use this skill when implementation, refactoring, test, documentation, ADR, repo-local skill work, or bounded read-only
research should be executed by multiple worker subagents in parallel. Use `$subagent-routing` before every worker spawn.

## Core Rule

Parallelize only across clear ownership boundaries. The parent agent owns unresolved architecture and lifecycle decisions,
decomposition, integration, final verification, self-review, and commits.

Workers may edit their assigned slice, but they must not commit, push, run destructive commands, or revert changes outside their ownership.

## Preflight

1. Read repository instructions and any skills triggered by the requested work.
2. Check `git status --short` and identify unrelated dirty files.
3. Decide whether a planning-only sidecar is required before edits.
4. Identify the smallest coherent implementation slices and the files each slice may own.
5. Keep any tightly coupled or architectural decision local to the parent unless a worker can handle a bounded implementation after the decision is made.

Good worker slices:

- Disjoint files or modules.
- Clear input/output behavior.
- Localized tests or fixtures.
- Mechanical refactors with a narrow pattern.
- Documentation or skill updates that do not need to summarize current implementation broadly.

Poor worker slices:

- Multiple workers editing the same file.
- Changes whose correctness depends on another unmerged worker result.
- Architecture, persistence, lifecycle, provider side-effect, or task/action boundary decisions that are still unresolved.
- Broad formatting, generated files, or repository-wide rewrites likely to conflict with other work.

## Ownership Map

Before spawning workers, write a short ownership map:

- Parent-owned decisions and integration work.
- Worker name or number.
- Worker mode: editing or read-only research.
- Owned files/modules.
- Explicit non-owned files/modules.
- Expected output.
- Difficulty tier and classification evidence.
- Requested subagent route and current slot budget.
- Focused verification the worker should run if practical.

If slices cannot be made mostly disjoint, do not parallelize implementation. Use parallel exploration only, then implement serially.

## Model Routing

Classify every worker slice before spawning it and record the tier in the ownership map. Base the tier on task
characteristics rather than estimated line count:

- **Routine**: Use when the work is mechanical or localized, follows an established pattern, has direct acceptance
  criteria, and needs no architectural or cross-module judgment, or when research is a bounded direct lookup. Request
  `balanced-medium`.
- **Standard**: Use when the work is bounded but needs implementation judgment, non-trivial debugging, coordinated edits
  within one slice, or new edge-case tests, or when bounded research must synthesize several sources around an established
  question. Request `frontier-medium`.
- **Complex**: Use only after the parent has resolved architecture and ownership boundaries, when the bounded slice still
  contains subtle algorithms, concurrency, performance, security, cross-module behavior, difficult invariant
  reconstruction, or evidence reconciliation. Request `frontier-high`.
- **Exceptional**: Use only for rare bounded implementation or research that combines two or more independent high-risk
  concerns or when concrete evidence shows that high reasoning was insufficient. Request `frontier-xhigh`.

When a slice matches multiple tiers, choose the highest one. Apply `$subagent-routing` to resolve the requested route
without pinning a model identifier here. File or module count alone does not raise the tier.

Do not route unclear ownership, unresolved architecture, persistence boundaries, lifecycle choices, provider side-effect
boundaries, or task/action state decisions to a stronger worker. Keep those decisions parent-owned, use
`planning-sidecar` when warranted, then classify and delegate only bounded implementation slices.

Ask a worker that discovers complexity above its assigned tier to stop before broadening scope and report the new
information. The parent must resolve any newly exposed boundary decision, narrow the slice, update the ownership map and
tier, and spawn a new worker through `$subagent-routing`. Do not continue the lower-tier worker with broadened scope.

## Worker Prompt

Use or adapt this prompt for each worker:

```text
You are a worker subagent for a parallel work task.

Goal:
<specific slice outcome>

Mode:
<editing or read-only research; research workers must not edit files>

Ownership:
- You own: <files/modules>
- Do not edit: <files/modules owned by others or unrelated dirty work>

Repository constraints:
- You are not alone in the codebase. Do not revert changes made by others.
- Keep edits scoped to your ownership.
- Do not commit, push, or run destructive commands.
- Do not spawn subagents.
- Stop before editing outside the stated scope or taking on higher-tier complexity; report the evidence to the parent.
- Follow repository instructions and relevant skills.

Task notes:
<behavioral invariants, docs/ADRs to read, patterns to preserve>
Difficulty routing:
<routine, standard, complex, or exceptional; requested route and classification evidence>

Verification:
<focused checks to run, or explain why skipped>

Final response:
- Files inspected or changed.
- Findings or changes produced.
- Verification run and results.
- Risks, conflicts, or follow-up needed.
```

## While Workers Run

Apply the slot and phase policy from `$subagent-routing`. Finish planning before spawning workers whose ownership depends
on it. Use only the currently available child slots and spawn only disjoint slices.

Continue with non-overlapping parent work: read docs, prepare integration checks, inspect unrelated areas, or implement
parent-owned glue. Avoid duplicating a worker's assigned slice. Wait only when the next parent step depends on worker
output.

## Integration

For each returned worker result:

1. Review the changed files and diff.
2. Confirm the worker stayed inside ownership.
3. Resolve conflicts yourself.
4. Apply any necessary parent-owned glue.
5. Run focused verification for affected areas.
6. Consolidate accepted follow-up work into the repository's todo document when repository instructions require todo tracking.

After every worker has finished or been interrupted, complete integration and run the repository-required final checks for
the touched file types. For non-trivial work, spawn a fresh `self-review` agent over the integrated diff before
committing.

## Reporting

Summarize parallelization in the final response:

- Worker slices completed.
- Material integration changes made by the parent.
- Verification run.
- Any skipped checks or residual risks.
