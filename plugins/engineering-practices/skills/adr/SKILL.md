---
name: adr
description: Use when deciding whether an architectural decision needs an ADR, or when creating or reviewing one. Applies Michael Nygard's canonical format and decision-record principles.
---

# Architecture Decision Records

Capture an architecturally significant decision in a concise record that lets
future readers understand the forces, chosen response, and consequences.
Before editing, read the repository's existing ADRs and instructions; they own
local numbering, paths, statuses, and lineage conventions.

Use Michael Nygard's
[“Documenting Architecture Decisions”](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
as the canonical source when format guidance conflicts.

## When A Record Is Warranted

Create or offer an ADR only when the decision is:

- hard to reverse at meaningful cost;
- surprising without the context that produced it; and
- a real trade-off among viable alternatives.

An easily reversed, self-evident, or alternative-free choice does not need an
ADR. Preserve existing records as history; represent a changed decision through
the repository's status and lineage conventions rather than rewriting the old
decision as if it had never existed.

## Canonical Record

Keep the record to roughly one or two pages and use Michael Nygard's structure:

- **Title:** a short noun phrase naming the decision, with the repository's ADR
  number when it uses one.
- **Date:** the decision or proposal date in the repository's established
  format.
- **Status:** `Proposed`, `Accepted`, `Deprecated`, or `Superseded`, plus only a
  brief lineage reference when needed.
- **Context:** a value-neutral account of the technological, organizational,
  project, and social forces that require a decision. State tensions without
  advocating the selected answer.
- **Decision:** full sentences in active voice beginning with “We will ...”.
  State the response to the context, not an implementation checklist.
- **Consequences:** the positive, negative, and neutral effects, including real
  costs, risks, and constraints on future work.

Include implementation detail only when the decision itself fixes that detail.
A proposed ADR does not change the binding decision set until it is accepted.

## Review Standard

The ADR is complete when the decision meets the significance test, every
material force is represented without invented rationale, the Decision is
specific enough to guide future choices, the Consequences expose the actual
trade-off, and the status and lineage agree with the current ADR corpus.
