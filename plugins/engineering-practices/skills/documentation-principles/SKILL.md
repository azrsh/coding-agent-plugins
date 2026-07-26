---
name: documentation-principles
description: Use before changing documentation or encoding project knowledge into docs, ADRs, AGENTS.md, skills, setup docs, integration docs, known issues, or code comments. Applies source-of-truth boundaries and prevents stale implementation summaries.
---

# Documentation Principles

Use this skill when encoding project knowledge into documentation, ADRs, repo-local skills, AGENTS.md, or code comments.

## Goal

Help future agents and developers reach the right knowledge at the moment they need it, without creating a stale second copy of the implementation.

## Workflow

1. Identify the kind of knowledge being encoded.
2. Choose the smallest durable container for that knowledge.
3. Avoid duplicating behavior that is obvious from the source and test trees.
4. Add or update reading triggers in the repository's agent instructions (`AGENTS.md`, or `CLAUDE.md` when that is the entry point) only when future agents need conditional guidance.
5. If a code change invalidates setup instructions, ADR consequences, known issues, or todo items, update the relevant document in the same unit of work.

## Source of Truth

Code is the source of truth for current behavior.

ADRs explain durable architectural decisions and their consequences.

Setup and integration docs explain external configuration and operational knowledge.

The repository's todo document tracks future work.

Superseded design documents are historical context, not current specification.

## Placement Rules

Put durable decisions in ADRs.

Put procedures in setup docs.

Put third-party service configuration in service-specific docs.

Put verification caveats in known issues.

Put future work in the repository's todo document.

Put reusable agent workflows in repo-local skills under the repository's skills directory, as `<skills-dir>/<skill-name>/SKILL.md`.

## Retrieval Rules

Use file names and headings future agents are likely to search for, such as `setup`, `known issues`, `rules`, `ADR`, or the name of the external service the document configures.

When a document matters only for certain work, add a short trigger in the agent instructions instead of expecting agents to read every document.

## What Not to Do

Do not create broad `current-state` documents that summarize the whole implementation. They become stale quickly. If a capability is easy to verify from code, let code be the reference.

Do not document a complete inventory of files, types, or functions unless the structure itself is a decision or a non-obvious operational contract.

Do not copy implementation logic into prose as a current-state summary.

Do not use historical documents as current specification. Link to ADRs and code instead.

Do not add new docs when a short agent-instruction trigger, ADR update, todo item, or skill update is enough.
