---
name: documentation-principles
description: Use when deciding where project knowledge belongs, preventing duplicated sources of truth, or restructuring knowledge across documentation, ADRs, agent instructions, skills, proposals, logs, and code comments.
---

# Documentation Principles

Apply `maintained-artifact-principle` to establish each knowledge unit's
authority, lifetime, and `source`, `projection`, or `verification` role. This
skill owns the documentation-specific questions of placement and retrieval.

## Placement

Treat a mixed request as separate knowledge units. For each unit, identify:

- the source that determines whether it is true;
- the event that would make it stale;
- the reader and decision it supports;
- whether it is current guidance, a dated record, or executable behavior;
- the next task or trigger that must retrieve it.

Choose the smallest durable container that is loaded for that trigger. A
separate document earns its maintenance cost when it serves a distinct reader,
decision, or lifetime. Otherwise update the existing source or add only the
retrieval pointer needed to reach it.

Use these source roles:

- Code, configuration, schemas, and scripts own executable behavior.
- Tests and CI own independent verification and supported check commands.
- ADRs own durable decisions and their consequences.
- README, setup, and integration guides own human-facing usage and external
  configuration.
- Proposals and todo documents own intended or future work.
- Dated logs and incident records preserve what was known at a point in time;
  they are not current specifications.
- Skills and agent instructions own non-obvious executable agent behavior.

## Human-Facing Documents

Source-of-truth discipline does not justify removing the procedures, examples,
URLs, and command snippets that make an operational document useful. Preserve
that detail unless it is wrong, stale, or duplicated by a better nearby source.

## Retrieval

Use names and headings that readers will search for. When knowledge matters only
for a conditional task, add a concise trigger in the nearest agent instruction
file or skill description rather than requiring every document to be read.

Project-specific workflows belong with the project. Cross-project workflows
belong in a user-level or installed skill only when their references and
assumptions remain valid outside the source project.

## Completion

Documentation work is complete when every added statement has a source and a
retrieval purpose, every affected current document is updated, and no second
hand-maintained copy claims authority over the same knowledge.
