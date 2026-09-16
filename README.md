# coding-agent-plugins

Personal plugin marketplace shared by **Claude Code** and **Codex CLI**.

Both CLIs read the same `.claude-plugin/` manifests, so every plugin here is authored once and
registered twice.

## Plugins

| Plugin | Contents |
| --- | --- |
| `subagent-orchestration` | `subagent-routing`, `planning-sidecar`, `parallel-implementation`, `self-review` |
| `engineering-practices` | `maintained-artifact-principle`, `change-shaping`, `documentation-principles`, `adr`, `abstraction-boundaries`, `retrospective-capture`, `review-feedback-disposition`, `reviewable-change-stacking` |
| `agent-authoring` | `modernize-agents-md` |
| `technical-communication` | `architecture-diagramming` |

## Register the marketplace

```bash
claude plugin marketplace add azrsh/coding-agent-plugins
```

```bash
codex plugin marketplace add azrsh/coding-agent-plugins
```

To work on the plugins themselves, register your clone by path instead:

```bash
claude plugin marketplace add /path/to/coding-agent-plugins
```

```bash
codex plugin marketplace add /path/to/coding-agent-plugins
```

## Install a plugin

```bash
claude plugin install engineering-practices@azrsh
```

```bash
codex plugin add engineering-practices@azrsh
```

`azrsh` is the `name` field of `.claude-plugin/marketplace.json`; renaming it changes every
`<plugin>@<marketplace>` id.

## Verify

```bash
./scripts/validate.sh
```

Then confirm each CLI resolved the marketplace and loaded the skills:

```bash
claude plugin list
```

```bash
codex plugin list
```

## Edit loop

Plugin components are read at session start, so restart the CLI after an edit. If a change still
does not appear, refresh the marketplace snapshot:

```bash
claude plugin marketplace update azrsh
```

```bash
codex plugin marketplace upgrade
```

`codex plugin marketplace upgrade` only refreshes Git sources; a marketplace registered by local
path is read from that path.
