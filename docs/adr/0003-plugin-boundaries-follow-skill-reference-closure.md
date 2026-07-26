# ADR 3: Plugin Boundaries Follow Skill Reference Closure

Date: 2026-07-26

## Status

Accepted

## Context

The skills imported into this repository are not independent. Three of them, `planning-sidecar`, `parallel-implementation`, and `self-review`, classify a task by risk and then delegate model, effort, fork, and slot resolution to `subagent-routing`. `retrospective-capture` defers every documentation placement decision to `documentation-principles`. In each case the referring skill deliberately does not restate the referenced policy, which is what keeps one operational rule in one place.

A plugin is the unit that both CLIs install, enable, and disable. A user can install one plugin and not another. If two skills that reference each other are placed in different plugins, one can be present while the other is absent, and the referring skill then instructs the agent to follow a policy that is not loaded.

Three groupings were considered. One plugin per skill gives the finest selection but breaks every reference. A single plugin containing everything keeps all references valid but forces unrelated skills to be adopted together and gives the repository no meaningful structure. Grouping by reference closure sits between the two.

The two CLIs also spell cross-skill references differently. Codex treats `$skill-name` as an explicit skill reference, while Claude Code reads the same text literally and resolves a skill by name from its own listing.

## Decision

We will make the plugin boundary follow reference closure. Every reference a skill makes to another skill must resolve inside the same plugin.

We will not split mutually referencing skills across plugins, and we will not merge unrelated skills into one plugin merely to avoid a dangling reference. When a new skill references an existing one, it joins that skill's plugin or it drops the reference.

We will write each cross-skill reference using a name that matches the target skill's directory name, so that Codex resolves it through the `$` sigil and a Claude Code agent can still match it against the skill listing. We will not maintain per-CLI wording for the same reference.

The current grouping is `subagent-orchestration` for the four delegation skills and `engineering-practices` for the four knowledge and design skills.

## Consequences

Positive: Installing one plugin yields a working policy rather than a set of instructions pointing at something absent. The failure mode this avoids is quiet: a missing referenced skill does not raise an error, it just makes the agent improvise the policy it was told to follow.

Positive: The rule gives an objective answer to which plugin a new skill belongs in, so the grouping does not have to be re-argued each time.

Negative: Selection is coarser than the skills themselves. Someone who wants only `adr` also gets `documentation-principles`, `abstraction-boundaries`, and `retrospective-capture`. The cost is bounded, because both CLIs load only a skill's name and description until it is invoked, but the listing is longer than the user asked for.

Negative: A skill that would naturally reference across the two current plugins has no good home. Resolving that will mean either duplicating a policy, merging the plugins, or removing the reference, and none of the three is free.

Neutral: Reference closure describes the current grouping but does not by itself justify the two plugin names. A future split along different lines remains possible as long as it keeps references closed.
