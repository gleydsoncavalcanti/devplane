---
name: devplane
description: Operate and evolve the DevPlane developer platform. Use when working on DevPlane CLI packaging, the local kind runtime, ArgoCD ApplicationSets, packaged Helm charts, observability, platform agent workflows, or repository conventions managed through the DevPlane CLI.
---

# DevPlane

Use this skill to work on DevPlane, a developer platform/runtime where the local cluster is managed by the CLI and reconciled by ArgoCD from packaged Helm charts.

The implemented local module is `cluster`. Prefer the CLI, packaged Helm charts, and ArgoCD ApplicationSets over ad hoc commands.

## Repositories

- This repo owns the local kind definition, ApplicationSets, docs, skills, DevPlane CLI, and packaged Helm charts.
- `charts/platform` owns ArgoCD, ingress-nginx, Vault, External Secrets, and Kyverno.
- `charts/agents` owns OpenTelemetry Collector and Vector.
- `charts/observability` owns Grafana, Loki, Tempo, and Mimir.
- Application examples and the reusable app rollout chart live in `https://github.com/gleydsoncavalcanti/devplane-apps`.

Do not add addon directories under `clusters/platform/addons`.

## Core Commands

Run from the repository root:

```bash
./scripts/devplane up
./scripts/devplane install-prereqs
./scripts/devplane status
./scripts/devplane hosts
./scripts/devplane down
./scripts/devplane cluster create
./scripts/devplane cluster appsets
```

Make targets are equivalent:

```bash
make up
make install-cli
make install-prereqs
make status
make hosts
make down
make cluster-create
make cluster-appsets
```

Package install for users:

```bash
curl -fsSL https://raw.githubusercontent.com/gleydsoncavalcanti/devplane/main/packaging/install.sh | bash
```

This installs the CLI and copies this skill to `~/.codex/skills/devplane`.

## Safety Rules

- Confirm with the user before changing a live cluster, editing `/etc/hosts`, or deleting resources.
- Before install/bootstrap, check or state the intended Kubernetes context.
- Do not hardcode new addons in `scripts/devplane`; add charts under `charts/` and wire them through ApplicationSets.
- Use Mimir for metrics, not Prometheus/kube-prometheus-stack.
- Keep telemetry flow as OpenTelemetry Collector -> Vector -> Loki/Tempo/Mimir.

## Cluster Workflow

1. Install the CLI and prerequisites when needed:

```bash
make install-cli
devplane install-prereqs
```

2. Create the local kind cluster, bootstrap ingress-nginx and ArgoCD from packaged charts, then apply ApplicationSets:

```bash
./scripts/devplane up
```

3. If you need separate steps:

```bash
./scripts/devplane cluster create
./scripts/devplane cluster appsets
```

4. Check health:

```bash
./scripts/devplane status
```

5. Sync local domains only with user confirmation:

```bash
./scripts/devplane hosts
```

## Addon Work

For addon changes, read `references/addon-contract.md`.

Keep addon implementation in packaged Helm charts under `charts/`. ApplicationSets define where those charts are applied.

## Application Work

App templates and sample services are outside this repository:

```text
https://github.com/gleydsoncavalcanti/devplane-apps
```

Do not reintroduce portal or application template directories in this repo until the product direction changes.

## Future Modules

The CLI may later gain modules such as:

```bash
devplane app create
devplane integration enable postgres
devplane integration enable kafka
devplane observability dashboard
```

Until those exist, operate only the `cluster` module and update docs/plans for future capabilities without pretending they are implemented.
