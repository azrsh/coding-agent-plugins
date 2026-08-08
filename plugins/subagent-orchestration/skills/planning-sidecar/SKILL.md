---
name: planning-sidecar
description: Decide whether to run one planning-only subagent before implementation when the user explicitly requests planning delegation, invokes this skill, grants standing permission for planning subagents, or repository instructions authorize them. Use for broad, ambiguous, architectural, risky, multi-path, documentation-heavy, or high-blast-radius work where an independent planning pass can identify scope, evidence, unresolved decisions, and verification before edits begin, and after two or more failed fixes for the same behavior, where an independent root-cause pass should replace another fix attempt.
---

# Planning Sidecar

## Authorization and Entry Gate

Confirm planning subagents are authorized by the user, the current conversation, or repository instructions. Do not treat this skill's existence as authorization.

Run one planning-only subagent when independent investigation would materially improve the plan, especially for ambiguous scope, architectural boundaries, conflicting implementation paths, required ADR or project-document research, or high-blast-radius changes.

Also run one before the next fix attempt when two or more fixes for the same behavior have failed. Repeated failed fixes are evidence that the diagnosis, not the implementation, is wrong; have the sidecar re-derive the root cause from scratch and question whether the surrounding design is sound, instead of attempting another fix on the same theory.

Skip the subagent for small, clear, routine work or when it cannot perform useful read-only investigation. State the decision briefly before editing.

## Route Selection

Classify the planning task by risk:

- Use `frontier-medium` for ordinary planning.
- Use `frontier-high` when the task crosses exactly one high-risk architectural boundary.
- Use `frontier-xhigh` when the task crosses two or more independent high-risk architectural boundaries, or when materially conflicting or missing evidence prevents a reliable plan.

Treat persistence, security or provider side-effect ownership, public interfaces, process or lifecycle authority, and shared abstraction ownership as examples of high-risk architectural boundaries. File or module count alone must not raise the tier.

Load and follow `$subagent-routing` as the source of truth for runtime model resolution, fork rules, and slot lifecycle. Pass the selected route to that workflow; do not pin a model ID or restate its routing algorithm here.

## Workflow

1. Form a brief local plan and identify the evidence needed before edits.
2. Select the risk route and record the concrete evidence for that classification.
3. Run at most one planning-only subagent at a time, following `$subagent-routing`.
4. While it runs, perform only non-overlapping, read-only discovery in the parent.
5. Wait for planning to finish before dependent decomposition or any edits.
6. Reconcile the result with repository instructions, ADRs, code, and tests.
7. Keep final architecture, decomposition, verification, and implementation decisions with the parent.

Treat the planning result as evidence, not authority. If it exposes an unresolved architecture decision, return that decision to the parent rather than selecting an alternative.

## Delegation Prompt

Use or adapt this prompt:

```text
You are the planning-only subagent for this task. Do not edit files and do not spawn subagents.

Goal: <summarize the requested outcome>
Selected risk tier: <frontier-medium | frontier-high | frontier-xhigh>
Tier evidence: <concrete risk boundaries or conflicting/missing evidence>

Inspect the relevant code, tests, documentation, and ADRs. Return:
1. Recommended implementation approach.
2. Files and authoritative evidence that matter.
3. Risks, edge cases, and unresolved architecture decisions.
4. Focused verification steps.

If the task touches task/action state, persistence, or provider side-effect boundaries, include:
1. User-visible invariant.
2. Owner of interaction state.
3. Owner of durable state.
4. Owner of provider side effects.
5. Tactical and architectural options.

Do not make final architecture, decomposition, verification, or implementation decisions.
Return unresolved architecture choices to the parent. Keep the response concise and actionable.
```
