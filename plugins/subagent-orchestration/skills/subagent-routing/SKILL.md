---
name: subagent-routing
description: Use before every subagent spawn to resolve the runtime model, reasoning effort, fork context, and available slot. Applies to planning, research, implementation, review, and other delegated agents, including spawns requested by another skill.
---

# Subagent Routing

## Overview

Apply one shared operational policy whenever the parent is about to spawn a subagent. Let the calling skill decide the
role-specific difficulty or risk; this skill resolves that decision into a supported model, effort, fork, and slot.

## Route Contract

Accept one of these routes from the calling skill:

- `balanced-medium`: Resolve the balanced model class with medium reasoning.
- `frontier-medium`: Resolve the frontier model class with medium reasoning.
- `frontier-high`: Resolve the frontier model class with high reasoning.
- `frontier-xhigh`: Resolve the frontier model class with xhigh reasoning.

Let the calling skill own route eligibility and its role-specific classification evidence. Do not reinterpret, upgrade,
or downgrade a requested route based on task subject, file count, boundary count, or prior attempts. When a spawn
request arrives without a route — for example from a skill that does not classify difficulty — the parent classifies it
before spawning and records the evidence; default to `frontier-medium` when no classification evidence points elsewhere. No route authorizes
outsourcing unresolved architecture, ownership, lifecycle, persistence, provider side-effect, or task/action state
decisions; keep those decisions parent-owned.

Honor an explicit user or repository model requirement before this default route contract. If the required model is not
advertised at runtime, stop and report the mismatch instead of silently substituting another model.

## Runtime Model Resolution

Resolve the requested model class from the models advertised by the subagent tool at runtime. Never invent or permanently
pin a model identifier in repository instructions.

For a balanced route:

1. Prefer a coding model described as `balanced` or `everyday`.
2. Otherwise prefer one described as `fast` or `low-latency`.
3. Otherwise fall back to a frontier candidate, then any advertised coding model.

For a frontier route:

1. Prefer a coding model described as `latest frontier` or `frontier`.
2. Otherwise prefer one described as `most capable` or `advanced`.
3. Otherwise fall back to a balanced candidate, then any advertised coding model.

When candidates remain tied, choose the lexicographically first advertised model identifier for a stable result. Select
the requested effort when supported. If it is unavailable, select the highest supported effort that does not exceed the
request and report the downgrade to the parent.

## Fork Policy

When specifying a model or reasoning override, set `fork_turns` to `"none"` or a bounded positive turn count:

- Use `"none"` by default and pass a self-contained prompt with the goal, ownership, constraints, relevant context, and
  verification.
- Use a bounded positive count only when recent conversation turns materially affect the delegated task. Include any
  older required context explicitly.
- Do not use a full-history fork with a model or reasoning override.

## Slot and Phase Policy

Read the concurrency limit advertised by the collaboration environment and count the parent as one slot. Before spawning,
inspect live agents and calculate the remaining child capacity. Under the current four-slot limit, never run more than
three children at once.

- Run at most one planning sidecar at a time. It may overlap only with useful parent read-only discovery.
- Finish planning before starting workers whose ownership or behavior depends on that plan.
- Run up to three disjoint workers when no planning sidecar consumes a child slot. Do not let children spawn children.
- Finish or interrupt every worker before integrated self-review.
- Run one fresh reviewer after integration and initial verification. Do not reuse a planner or worker as the reviewer.

Completed agents require no close operation. Interrupt only abandoned work and verify that it is no longer running before
reusing its slot.

## Worker Lifecycle

Prefer asynchronous handling over blocking on each spawn: continue non-overlapping parent work while children run, and
collect results when the next parent step depends on them.

A worker may stay alive across sequential subtasks within the same ownership slice and route; continuing an existing
worker preserves its context and costs less than a fresh spawn. Do not reuse a worker across ownership slices, do not
continue a worker whose subtask needs a different route, and never reuse any agent as a reviewer: reviewers always
start fresh, because independent context is what makes their review worth having.

## Escalation

Ask a subagent that encounters work above its assigned route to stop before broadening scope and report the evidence. The
parent must resolve any newly exposed decision, narrow the task, reclassify it, and spawn a fresh subagent. A follow-up
message cannot change the existing agent's model or reasoning effort.

Record the requested route, selected model and effort, fork choice, classification evidence, and any fallback in the
ownership or review packet.
