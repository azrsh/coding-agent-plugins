---
name: change-shaping
description: Shape a proposed code or system change when it may add unnecessary maintained surface or when the requirement itself is uncertain. Applies to new components, APIs, durable state, workflows, dependencies, and cross-cutting changes; skip local fixes and implementations already fixed by a governing source.
---

# Change Shaping

Achieve the user's intended observable outcome with the smallest honest change.
Treat the requested implementation as a candidate solution unless the user or
a current governing source fixes it as a constraint. A supported no-change
conclusion is a successful result.

Preserve explicit user choices and authorization boundaries. A named
deliverable may itself be part of the intended outcome; behavioral equivalence
alone does not make it dispensable.

## Scope The Shaping

Take the fast path when current behavior or a failing check already establishes
the contract, the change is local and reversible, and it does not materially
alter a public contract, durable data, a trust boundary, or cross-system
rollout. Implement and verify that change without producing a shaping report.

Run the full shaping pass when the proposal adds or substantially changes a
component, API, state model, dependency, workflow, operational responsibility,
or other maintained surface, or when the purpose and proposed solution are
entangled.

## Outcome And Evidence

Read the smallest current evidence set that can establish the problem:
implementation, tests, configuration, governing decisions, and the user's
reported scenario.

Express the desired result as an observable outcome. Establish the actor or
system affected, the behavior that distinguishes success, the concrete failure
of doing nothing, and the constraints fixed by authority, compatibility,
safety, or an accepted decision. Keep preferences, candidate solutions, and
unverified assumptions separate from those constraints.

A change has a supported purpose when both the failure of doing nothing and its
evidence are clear. An unsupported request may legitimately end in no change.

## Minimize The Requirement

For every requested component, field, API, state, document, workflow, and
compatibility mechanism, identify the observable scenario that would fail if
it were omitted and the evidence for that scenario.

Prefer solutions in this order:

1. Drop an unsupported or unnecessary requirement.
2. Eliminate the condition or branching that creates the requirement.
3. Use behavior the system already provides.
4. Satisfy the outcome through existing configuration or composition.
5. Extend an existing responsibility boundary when it remains coherent.
6. Create a new maintained surface only for the residual capability.

Preserve explicit security, compliance, compatibility, data-integrity, and user
constraints. Requirement removal needs current evidence rather than taste or
speculative product judgment.

## Existing Capability

Search only as far as the decision requires, starting with current code, tests,
configuration, governing decisions, and nearby extension points. Include
history or adjacent systems only when they can change the boundary decision.

Existing capability is equivalent only when its success, refusal, and failure
behavior, invariants, lifecycle, ownership, and operational dependencies meet
the requirement. Stop when equivalence is established, a concrete residual gap
is proven, or further sources are unlikely to change the decision.

## Maintained Boundary

Compare total maintained surface rather than lines of code, including state,
APIs, configuration, dependencies, migrations, compatibility, tests,
documentation, rollout, operations, and ownership.

Reuse or extend an existing component when its responsibility, owner, change
drivers, lifecycle, and failure domain align with the outcome. Prefer a small
new boundary over distorting an existing component or coupling unrelated
lifecycles.

Describe the residual capability as the smallest semantic difference between
the current system and the intended outcome, and establish how it will be
verified before selecting implementation details.

## Uncertainty And Authority

Resolve source and evidence questions from available material. A bounded
prototype is useful when it can answer a concrete design question; current
conventions are sufficient for reversible local choices.

Pause production implementation only when reasonable choices materially differ
in an external contract, durable data, a trust boundary, an irreversible
migration, or cross-system rollout and the answer depends on user intent,
authority, or risk preference. Present the evidence, viable choices,
consequences, and smallest required decision.

When a smaller solution would remove or materially change an explicitly named
deliverable, first establish whether it is a fixed constraint, part of the
observable outcome, or a candidate means. Show any difference in user
affordance, ownership, lifecycle, and failure behavior before replacing it.

## Completion

Proceed when no user-only decision remains. Surface the shaping result when it
removes material scope, selects a materially different solution, discovers an
ownership boundary, or requires a user decision. Do not preserve the analysis
as a durable artifact unless a distinct reader, decision, or lifetime justifies
one.

Apply `maintained-artifact-principle` to the resulting diff before completion
so every retained artifact and boundary is independently justified.
