---
name: reviewable-change-stacking
description: Use when planning, reviewing, implementing, or restacking a change that mixes mechanical transformations such as moves, generated output, or import rewrites with semantic API, contract, or behavior changes. Separates independently buildable PRs by reviewer question.
---

# Reviewable Change Stacking

## Outcome

A reviewable stack gives each PR one high-level reviewer question, bounds its
mechanical fallout, and keeps every intermediate branch buildable and testable.

## Change Axes

Classify the intended final diff by the identity or behavior it changes:

- physical source or file location;
- serialized or wire identity, package, or namespace;
- language module, package, or import identity;
- semantic API or contract behavior and user-visible features.

Treat schema shape and meaning as semantic contract behavior. Serialized names
and namespaces belong to the identity axis.

Keep independently testable axes in separate PRs. Place generated artifacts
with the source or generator configuration that owns them: generated output is
mechanical evidence of that change, not an independent review unit.

Combine axes only when separation would leave an unbuildable intermediate
state or require compatibility for consumers that actually exist. Make that
coupling the explicit reviewer question.

## Review Boundaries

Order the stack by dependency so identity and producer changes land before
their consumers. Each PR should have one immediate base, one reviewer question,
an expected direct diff, and checks that prove its intermediate state.

Judge a stacked PR against its immediate base rather than only against the
repository default branch. Bulk imports, renames, and generated output should
not obscure unrelated schema or behavioral changes.

When a predecessor merges, update the remaining branch ancestry and recheck
the direct diff and description. The dependency note must describe the current
stack rather than its historical arrangement.

## Completion Standard

The stack is ready when every final change appears in exactly one direct PR
diff, every intermediate state passes its focused generation and test checks,
and every PR asks one high-level reviewer question.
