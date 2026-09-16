---
name: maintained-artifact-principle
description: Use when deciding whether a maintained artifact or boundary is necessary, separating sources from projections and verification, or removing duplicated representations across code, tests, configuration, schemas, documentation, policy, and procedures.
---

# Maintained Artifact Principle

A maintained artifact earns its ongoing cost by adding a semantic contribution
that would be lost if the artifact disappeared. Apply this standard to code,
tests, configuration, schemas, documentation, comments, policy, and operational
procedures rather than treating executable artifacts as self-justifying.

## Semantic Contribution

Retain an artifact when it does at least one of these jobs:

- implements behavior;
- prevents or makes an invalid state unrepresentable;
- detects an error or regression independently;
- preserves a reason, invariant, gotcha, or reference that cannot be derived
  from a stronger source;
- reduces the search or inference burden for a named reader and decision.

Remove an artifact that only restates another representation. Prefer a
generated projection over a hand-maintained copy when another audience needs
the same knowledge. A wrapper that only renames existing behavior, an
abstraction that excludes no invalid state, and a test that merely repeats a
compiler guarantee carry the same synchronization cost as a redundant comment.

## Change Fingerprint

Compare artifacts and boundaries by the change that would invalidate them:

- the reason or requirement that changes;
- the authority that determines the correct meaning;
- the reader and decision the artifact supports;
- whether it stays current, records a point in time, or is consumed once;
- whether its role is `source`, `projection`, or `verification`.

Treat representations with the same fingerprint as one body of knowledge even
when their formats or locations differ. Give that knowledge one logical
`source`. A source may span several files when one authoritative entry point
still determines its meaning.

A `projection` serves a different reader or decision without becoming a second
authority. Keep its synchronization route explicit through generation,
reference, or another maintained mechanism. A `verification` earns a separate
representation only when it has an independent failure path and can detect a
mistake in the source rather than reproducing the same mistake.

Use the same fingerprint for functions, modules, and change boundaries. Group
work that changes for the same reason and separate work whose authority or
lifetime differs; directory layout and runtime call paths are supporting
evidence, not the boundary by themselves.

Meaning authority does not grant permission to modify an external artifact.
Keep repository, service, publication, and other mutation authority as a
separate execution boundary.

## Strongest Representation

Prefer the representation with the smallest lifetime maintenance and failure
cost:

1. Eliminate the problem or branch when doing so reduces total cost.
2. Enforce the invariant with a type, compiler, generator, tool, or CI check.
3. Put executable behavior in the smallest authoritative code or configuration.
4. Place only non-derivable reasons nearest to the behavior they explain.
5. Create a separate maintained artifact when a distinct reader, decision, or
   lifetime supplies its semantic contribution.

Generated views delegate synchronization to their generator. Dated records
such as accepted decisions and incident timelines preserve what was true at a
point in time rather than acting as current specifications. One-time teaching
or presentation material may repeat information for comprehension; it becomes
a maintained projection when readers expect it to stay current.

## Completion Standard

The boundary is justified when every retained artifact has a named semantic
contribution, each body of knowledge has one logical source, every projection
has a synchronization route, and every verification can fail independently.
Investigate facts that could change this result, and return only unresolved
value, scope, authority, or permission decisions to the user. Surface the
analysis when it removes or relocates meaningful scope; otherwise apply it
without creating another maintained report.
