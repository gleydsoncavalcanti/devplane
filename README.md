# DevPlane

DevPlane is a local platform foundation for kind-based development, packaged for CLI and GitOps workflows.

## Model

DevPlane is self-contained: Helm charts live in this repository under `charts/`, and ArgoCD applies them through ApplicationSets into one local kind cluster.

![DevPlane flow](docs/assets/devplane-flow.svg)

## Structure

```text
charts/
├── platform/
│   ├── argocd/
│   ├── ingress-nginx/
│   ├── vault/
│   ├── external-secrets/
│   └── kyverno/
├── agents/
│   └── opentelemetry-collector/
└── observability/
    ├── grafana/
    ├── loki/
    ├── tempo/
    └── mimir/
clusters/platform/
gitops/applicationsets/
scripts/
skills/
docs/
```

Application examples and rollout templates live in a separate repository:

```text
https://github.com/gleydsoncavalcanti/devplane-apps
```

## Install The CLI And Prerequisites

After cloning the repository:

```bash
make install-cli
devplane install-prereqs
```

`install-prereqs` is idempotent: if `git`, `make`, `docker`, `kubectl`, `helm`, or `kind` are already installed, it skips them.

To install DevPlane as a package from GitHub, including the Codex skill:

```bash
curl -fsSL https://raw.githubusercontent.com/gleydsoncavalcanti/devplane/main/packaging/install.sh | bash
```

This installs:

- the `devplane` CLI in `~/.local/bin`;
- the Codex skill in `~/.codex/skills/devplane`;
- the repository in `~/.devplane/devplane`.

## Start The Local Platform

```bash
devplane up
```

The command creates one kind cluster with one control-plane node and two addon workers, installs the minimum bootstrap stack `ingress-nginx` and `argocd` from packaged charts, and applies the ApplicationSets in `gitops/applicationsets/`.

After bootstrap, ArgoCD reconciles in the same cluster:

- platform addons: ArgoCD, ingress-nginx, Vault, External Secrets, and Kyverno;
- agents: OpenTelemetry Collector;
- observability stack: Grafana, Loki, Tempo, and Mimir.

## Telemetry

The default telemetry flow is:

```text
OpenTelemetry Collector agents -> OpenTelemetry Collector gateway -> Loki / Tempo / Mimir
```

- OpenTelemetry Collector agents collect pod logs, host metrics, and kubelet metrics on each node.
- OpenTelemetry Collector gateway receives OTLP logs, metrics, and traces and routes them to the datastores.
- Loki receives logs.
- Tempo receives traces.
- Mimir receives metrics.
- MinIO is enabled by the Loki and Mimir charts for local object storage.

Use Mimir for metrics. Do not use Prometheus/kube-prometheus-stack in the local baseline.

## Local Domains

```bash
devplane hosts
```

The command updates the DevPlane-managed block in `/etc/hosts` with:

- `argo.localhost`
- `vault.localhost`
- `grafana.localhost`

## Useful Commands

```bash
devplane status
devplane cluster appsets
devplane down
```
