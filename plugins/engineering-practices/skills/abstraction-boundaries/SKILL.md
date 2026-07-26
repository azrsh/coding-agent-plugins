---
name: abstraction-boundaries
description: Use before introducing or broadening shared abstractions, normalization layers, provider-neutral models, cross-provider schemas, common lifecycle models, or generalized domain objects. Helps separate common lifecycle concerns from domain semantics that may not actually be shared.
---

# Abstraction Boundaries

## Overview

Use this skill before designing a shared model or normalization layer. The goal is to avoid giving common names to concepts whose meanings differ across domains, providers, workflows, or external systems.

## Core Principle

First separate common lifecycle concerns from domain semantics.

Common lifecycle concerns may include receiving, deduplicating, persisting, routing, linking, retrying, state transitions, error recording, authorization checks, and audit history.

Domain semantics include identities, ownership, tenancy, actor, conversation, thread, status, priority, event type, action names, resources, and completion meanings unless the target domains prove they share those concepts.

## Workflow

1. Name the concrete domains being unified. Use at least three examples when the abstraction is meant to grow beyond the current provider or workflow.
2. For every proposed common field or type, ask whether it is a lifecycle concern, an operational concern, or a semantic claim.
3. Keep source-of-truth data in its native form when the semantics are provider-specific or externally owned.
4. Treat extracted references, metadata, display fields, and summaries as projections. State whether each projection exists for routing, indexing, UI, task linking, action execution, or debugging.
5. Do not introduce common fields such as `actor`, `owner`, `tenant`, `conversation`, `thread`, `kind`, `status`, or `summary` until their semantics are valid across the target domains.
6. Prefer native selectors or domain-specific adapters for hand-authored rules when the user is expected to know the external system's identifiers or API shape.
7. Add materialized indexes or convenience projections only when there is a concrete query, UI, or performance need.
8. Keep the shared lifecycle small and explicit; let domain-specific meaning remain behind adapters or native payloads.

## Design Review Questions

- What exact behavior becomes simpler because this abstraction exists?
- Which fields are source of truth, and which are derived projections?
- What would this abstraction look like for Slack, GitHub, Jira, and one non-chat provider?
- Would a user still need to know provider-local IDs or API semantics? If yes, do not claim the model hides those semantics.
- Can a future domain opt out of a field without fake values, empty placeholders, or misleading names?
- Is the shared type describing what this system does with data, or what the external data means?

## Example

A provider event model can apply this principle by keeping provider-native raw payloads as the source of truth and sharing only the source event lifecycle: persistence, deduplication, routing decisions, and task linkage. It does not require source events to expose common `actor`, `conversation`, `thread`, `kind`, `summary`, or display fields.
