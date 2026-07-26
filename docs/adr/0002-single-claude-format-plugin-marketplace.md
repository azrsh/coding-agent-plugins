# ADR 2: Single Claude-Format Plugin Marketplace for Both CLIs

Date: 2026-07-26

## Status

Accepted

## Context

This repository holds personal agent plugins that are used from both Claude Code and Codex CLI. Each CLI documents its own manifest convention. Claude Code reads `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`. Codex documents `.codex-plugin/plugin.json`, and the marketplaces bundled with Codex carry `.agents/plugins/marketplace.json`.

Inspection of the installed toolchain on 2026-07-26, with Claude Code 2.1.212 and codex-cli 0.144.6, showed that Codex resolves both manifest names. The `codex` binary probes `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json` for a plugin root, and the already-configured `claude-plugins-official` marketplace is loaded by Codex from `.claude-plugin/marketplace.json`. Both CLIs accept a local path or a Git remote as a marketplace source. Codex supports skills, hooks, subagents, and MCP servers; Claude Code additionally supports LSP server declarations in a marketplace entry.

Three arrangements were available. The repository could carry both manifest sets side by side, it could carry one set and generate the other at build time, or it could carry only the set that both CLIs already read. The first two require every plugin addition to be mirrored, and a mirror that drifts is worse than no mirror because each CLI would then load a different definition of the same plugin.

Agent instructions have the same shape of problem: Codex reads `AGENTS.md` and Claude Code reads `CLAUDE.md`.

## Decision

We will keep `.claude-plugin/marketplace.json` as the only marketplace manifest and `.claude-plugin/plugin.json` as the only plugin manifest in this repository. We will not add `.codex-plugin/` or `.agents/plugins/` manifests, and we will not generate per-CLI copies of a plugin.

We will register the same directory, and later the same Git remote, in each CLI rather than publishing separate per-CLI sources.

We will keep the repository's agent instructions in `AGENTS.md` and expose them to Claude Code through a `CLAUDE.md` symlink, so that both CLIs read one file.

We will record in `AGENTS.md` which components are verified to work in both CLIs, along with the versions the verification was performed against, so that a reader can tell a verified claim from an assumed one.

## Consequences

Positive: A plugin is authored once. There is no mirroring step to forget, no generated artifact to review, and no way for the two CLIs to disagree about what a plugin contains.

Positive: A plugin written here is in the same format as the public Claude Code plugin ecosystem, so it can be published or consumed alongside those plugins without conversion.

Negative: This depends on Codex continuing to accept the Claude manifest names. That behavior was verified by inspection rather than read from a compatibility guarantee, so a future Codex release could drop it and make every plugin here invisible to Codex at once. The recovery is to add `.codex-plugin/plugin.json` files, which is mechanical but touches every plugin.

Negative: Claude-Code-only features, such as LSP server declarations, produce a silent capability gap under Codex rather than an error. A plugin that relies on one will appear to install correctly and then do less than expected.

Neutral: The component parity recorded in `AGENTS.md` is a snapshot of two specific CLI versions. It has to be re-checked when either CLI changes, and it will go stale quietly if it is not.

Neutral: Plugin identifiers carry the marketplace name from `.claude-plugin/marketplace.json`, currently `azrsh`. Renaming the marketplace renames every `<plugin>@<marketplace>` identifier that users have already installed.
