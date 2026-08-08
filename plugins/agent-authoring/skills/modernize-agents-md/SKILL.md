---
name: modernize-agents-md
description: >-
  Modernize an AGENTS.md or CLAUDE.md agent-instruction file against the latest
  official Claude Code and OpenAI prompt guidance. Use when asked to trim,
  restructure, or align persistent agent instructions with current models.
---

# Modernize Agent Instructions

Produce a short, human-readable instruction file containing only broadly
applicable, non-derivable guidance that changes agent behavior. Preserve the
user's explicit choices and repository-specific invariants; current provider
guidance informs the edit but does not override them.

## Ground The Edit In Live Guidance

Fetch both sources on every run because their recommendations and current model
names change:

- Claude Code best practices:
  `https://code.claude.com/docs/en/best-practices`, especially “Write an
  effective CLAUDE.md”.
- OpenAI's latest-model prompting guidance:
  `https://developers.openai.com/api/docs/guides/latest-model`. Use the newest
  model-specific guidance exposed there rather than a model name cached in this
  skill.

If one source is unavailable, disclose that limitation and use the available
guide plus the pruning criteria below. Report the actual guides and model page
used.

## Inspect The Effective Instructions

Read the target, its applicable parent or nested instruction files, and enough
of the repository to distinguish non-obvious rules from facts visible in code,
configuration, or command help.

Inspect `AGENTS.md` and `CLAUDE.md` with `ls -la`. When either is a symlink,
edit the real file and preserve the link. Use a provider-neutral heading when
one file is shared across agents.

## Keep Only Behavioral Leverage

Apply this test to every instruction: “Would removing this make the agent more
likely to make a repository-specific mistake?”

Keep:

- commands, test preferences, and environment quirks the repository does not
  make obvious;
- conventions that intentionally differ from language or tool defaults;
- architectural invariants, common gotchas, and accepted decision boundaries;
- repository etiquette and target, permission, or stop boundaries specific to
  this project.

Cut:

- facts recoverable from code, configuration, directory listings, or ordinary
  tool help;
- standard language conventions and self-evident advice;
- detailed API documentation, file-by-file tours, tutorials, line references,
  counts, and other frequently changing facts;
- platform defaults, generic approval rules, and instructions current models
  already follow without repository guidance.

Put conditional domain knowledge or workflows behind a precise pointer to an
existing document or skill. Create or relocate material only when that work is
within the user's requested scope. Prefer deterministic configuration or hooks
for zero-exception enforcement, without duplicating the same rule in the
instruction file.

## Rewrite Around Decisions

Lead with a one-line repository orientation, then group retained instructions
by the decisions they affect. There is no required outline. Add autonomy or
stop rules only when the repository has a non-default boundary to preserve;
do not manufacture a generic section merely to satisfy a template.

State the desired behavior positively. Reserve `must`, `only`, and `never`
for actual invariants. Preserve the source language, remove contradictions and
duplication, and introduce no facts that the target or an authoritative source
does not support.

## Verification

The edit is complete when every retained line passes the behavioral-leverage
test, conditional pointers resolve, the effective instruction hierarchy has no
contradictions, and any symlink still resolves to the edited file. Run
proportionate repository documentation or formatting checks. Report material
removals and the before/after line count as evidence, not as a target.
