# ADR 4: Generalization Requirement for Imported Skills

Date: 2026-07-26

## Status

Accepted

## Context

The first eight skills in this repository were imported from an application repository of ours, where they lived as repo-local skills. That project held ten skills at the time of import.

Skills written in a project accumulate references to it. Of the ten, one was built entirely on that project's SQLite migrator, its fixture layout, and a numbered ADR, and another carried more than a dozen references to the app's UI source directory, a specific ADR number, the project's minimum macOS version, and its local QA helper directory. The remaining eight carried a small number of such references: an example section naming the product and one of its ADRs, and a handful of `docs/todo.md`, source, and test paths.

A plugin installed from this marketplace runs in an unknown repository. A skill that instructs an agent to read `docs/todo.md` in a project that has no such file produces either a wasted search or a plausible-looking substitution. This is a correctness problem for the skill, not a cosmetic one.

Two other options existed. The skills could have been copied verbatim, accepting the broken references as noise. Alternatively the source project could have remained their home, with this repository depending on it, which keeps one copy but ties a general-purpose marketplace to one product repository.

The second excluded skill also overlapped with `build-macos-apps@openai-curated`, an already-enabled plugin covering the same platform guidance.

## Decision

We will remove source-project coupling when importing a skill: repository paths, numbered ADR references, product names, and examples that only hold in the source project. Where the underlying instruction is real but the path is not portable, we will restate it by role, such as the repository's todo document, rather than delete it.

We will treat a skill as project-specific when removing those references leaves nothing behind, and leave it in the project repository.

We will not import a skill whose guidance is already covered by a plugin available from another marketplace.

We will treat the imported copy as the source of truth here. We will not track the source-project copy, and we will not attempt to keep the two synchronized.

## Consequences

Positive: A skill installed from this marketplace names only things that any repository can be expected to have, so its instructions stay executable outside their project of origin.

Positive: The emptiness test gives a concrete criterion for the import decision, rather than a judgment about how general a skill feels.

Negative: Generalization loses grounding. The concrete example in `abstraction-boundaries` was persuasive partly because it pointed at a real decision in a real system, and the generalized version is weaker for it.

Negative: Two copies of these eight skills now exist, here and in the source project, and they will drift. Converging that project onto this marketplace would remove the duplication, but it is a change to that repository and is not decided here.

Neutral: The two excluded skills are excluded on their current content. If the project-coupled parts of either are later separated from the general parts, the general remainder can be imported under the same test.
