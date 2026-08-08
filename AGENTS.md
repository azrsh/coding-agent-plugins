# Authoring rules for this repository

This repository is a single plugin marketplace consumed by both Claude Code and Codex CLI.
See README.md for registration and installation commands.

## Decisions

Durable decisions live in `docs/adr/`, in Nygard format. Use the `adr` skill from
`plugins/engineering-practices/` to add one, and update the affected ADR in the same unit of work
when a change invalidates it.

## Source of truth

- `.claude-plugin/marketplace.json` is the only marketplace manifest. Do not add a
  `.agents/plugins/marketplace.json` or a `.codex-plugin/plugin.json`
  ([ADR 2](docs/adr/0002-single-claude-format-plugin-marketplace.md)).
- A plugin lives entirely under `plugins/<name>/`. Nothing outside that directory may be required
  for it to work, because each CLI resolves the plugin directory on its own.

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` with `name`, `description`, `version`, and
   `author`.
2. Add the components (see the parity table below).
3. Add an entry to `.claude-plugin/marketplace.json` with `"source": "./plugins/<name>"`.
4. Run `./scripts/validate.sh`, which checks that the directory name, the plugin manifest, and the
   marketplace entry agree.
5. Restart both CLIs and exercise one component in each.

## Writing style for skills

Write skills as judgment criteria, not procedures: state the outcome, the boundaries that must not
be crossed, and the completion standard, and leave the path to the model. Current frontier models
degrade under prescriptive step lists and blanket gates.

When adding or revising a skill, apply the no-op test to every sentence: if deleting it would not
change the model's behavior, delete it. Phrase instructions positively — state the target behavior
rather than prohibiting the failure — and reserve absolute wording for hard boundaries such as
security, permissions, and data loss. The `writing-for-agents` skill from the mattpocock-skills
plugin is the fuller reference for this style when that plugin is installed.

## Skills that reference other skills

Keep a skill's references to other skills inside the same plugin, and write each reference with a
name that matches the target skill's directory
([ADR 3](docs/adr/0003-plugin-boundaries-follow-skill-reference-closure.md)).

## Importing a skill from a project repository

Strip what only holds in the source project: repository paths (`Sources/`, `docs/todo.md`), numbered
ADR references, and product names. If removing them empties the skill, it is project-specific — leave
it in that repository
([ADR 4](docs/adr/0004-generalization-requirement-for-imported-skills.md)).

## Cross-CLI parity

This table is the living record of what works in which CLI.
[ADR 2](docs/adr/0002-single-claude-format-plugin-marketplace.md) cites the same verification as
evidence for a decision, but that copy is frozen at the decision date and is not maintained: update
this table, not the ADR.

Re-verify after either CLI is updated. Install a plugin from this marketplace in both and exercise
one component of each kind the table claims support for; nothing else detects a regression here,
because a dropped component fails silently rather than erroring.

Verified against Claude Code 2.1.212 and codex-cli 0.144.6 on 2026-07-26.

| Component | Path | Notes |
| --- | --- | --- |
| Plugin manifest | `.claude-plugin/plugin.json` | Verified: Codex resolves both `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json`. |
| Marketplace manifest | `.claude-plugin/marketplace.json` | Verified: Codex loads Git and local marketplaces from this path. |
| Skills | `skills/<skill>/SKILL.md` | Supported by both. |
| Hooks | `hooks/hooks.json` | Supported by both. Codex normalizes `PreToolUse` to `pre_tool_use` and requires per-hook trust approval on first run. |
| MCP servers | `.mcp.json` | Supported by both. |
| Subagents | `agents/*.md` | Codex has a subagent concept but this repository has not exercised it; test before relying on it. |
| LSP servers | `lspServers` in the marketplace entry | Claude Code only. |

When a component is Claude-Code-only, keep it in a plugin whose remaining components still work
under Codex, and say so in that plugin's README.

## Secrets

Do not put tokens or API keys in `.mcp.json` or any committed file, including values copied from
`~/.codex/config.toml` or `~/.claude/settings.json`. Reference environment variables instead.
