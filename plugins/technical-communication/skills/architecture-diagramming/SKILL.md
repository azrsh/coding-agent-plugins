---
name: architecture-diagramming
description: Create or review source-grounded architecture diagrams that explain system structure, runtime or lifecycle flow, semantic boundaries, or current-versus-candidate designs in technical documents, proposals, and slide decks.
---

# Architecture Diagramming

Create diagrams that answer a system question rather than inventory components.
Establish a diagram contract—purpose, audience, state and scope, disclosure
boundary, and primary relationship—and keep the model no larger than needed to
satisfy it.

## Source And Abstraction

Separate observed facts from inferred structure. Verify unstable terminology,
product names, and resource relationships against current primary sources
before encoding them. Use established domain terms; distinguish selectors or
requests, control-plane components, desired-state resources, and runtime
workloads whenever collapsing them would misstate behavior.

Show stable responsibilities and relationships at the abstraction level the
audience needs. Each node should have a role, each arrow a relationship or
interaction, and each boundary a semantic meaning such as provider, network,
environment, ownership, control plane, runtime plane, or external dependency.

## Structural Semantics

Match the view to the question:

- Runtime architecture distinguishes control plane, runtime or data plane,
  dependencies, and traffic paths.
- Sequence or lifecycle views show ordering and actor responsibility.
- Comparisons keep current and candidate views structurally parallel so
  differences are intentional and explainable.
- Evaluation criteria, risks, costs, quotas, and open questions belong in
  adjacent prose or a separate evaluation view unless they are the subject of
  the diagram. An unresolved choice should not appear as existing runtime state.

Represent control-plane actions separately from workload traffic, and
repository or configuration ownership separately from execution. Show metrics,
secrets, caches, identity, and external endpoints as dependencies rather than
unexplained peers.

Use the representation least likely to imply the wrong behavior. For example,
qualify an edge with a gateway, proxy, or NAT path when drawing that
intermediary as a node would falsely imply that traffic terminates there. Use a
node when the intermediary itself is part of the question.

## Disclosure And Rendering

For externally shareable diagrams, prefer stable concepts and abstract or omit
account IDs, CIDRs, raw policies, machine image IDs, exact endpoints,
credentials, incident details, and internal resource names. Include concrete
identifiers in an internal diagram only when the question requires them and the
audience may receive them.

Use the repository's existing diagram tooling when available and keep the
render path reproducible. Preview the result at its destination size and
medium; source readability does not prove that an exported document or slide
is legible. When a destination has a private-image workflow, use it rather than
widening asset visibility to satisfy an insertion mechanism.

## Completion Standard

The diagram is complete when:

- its title or caption identifies whether it is current, candidate, draft, or
  target state;
- it answers the diagram contract without unrelated inventory;
- terminology and relationships trace to sources or are clearly identified as
  inference;
- every node, edge, and boundary contributes meaning;
- comparison views use compatible abstractions and explain intentional
  asymmetry;
- the disclosure boundary is respected; and
- the rendered result is readable in the destination medium.
