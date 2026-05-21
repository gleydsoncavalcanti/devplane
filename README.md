# DevPlane

DevPlane is a local platform foundation for kind-based development, packaged for CLI and GitOps workflows.

## Model

DevPlane is self-contained: Helm charts live in this repository under `charts/`, and ArgoCD applies them through ApplicationSets.

![DevPlane flow](docs/assets/devplane-flow.svg)

## Structure

```text
charts/
├── apps/
│   └── application/
├── platform/
│   ├── argocd/
│   ├── ingress-nginx/
│   ├── portal/
│   ├── vault/
│   ├── external-secrets/
│   └── kyverno/
├── agents/
│   ├── opentelemetry-collector/
│   └── vector/
└── observability/
    ├── grafana/
    ├── loki/
    ├── tempo/
    └── mimir/
clusters/
gitops/applicationsets/
scripts/
skills/
docs/
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

The command creates the kind cluster, installs the minimum bootstrap stack `ingress-nginx` and `argocd` from packaged charts in `charts/platform/`, and applies the ApplicationSets in `gitops/applicationsets/`.

After bootstrap, ArgoCD reconciles:

- platform addons: ArgoCD, ingress-nginx, DevPlane Portal, Vault, External Secrets, and Kyverno;
- agents: OpenTelemetry Collector and Vector;
- observability profile: Grafana, Loki, Tempo, and Mimir.

## Telemetry

The default telemetry flow is:

```text
OpenTelemetry Collector -> Vector -> Loki / Tempo / Mimir
```

- OpenTelemetry Collector collects logs, metrics, and traces and forwards them to Vector over OTLP.
- Vector receives logs, metrics, and traces, then sends them to the datastores.
- Loki receives logs.
- Tempo receives traces.
- Mimir receives metrics.
- MinIO is used as object storage for the observability stack where supported by the charts.

Use Mimir for metrics. Do not use Prometheus/kube-prometheus-stack in the workload baseline.

## Workload Clusters

```bash
devplane cluster generate runtime
devplane cluster add runtime
devplane cluster workloads
devplane cluster remove runtime
```

Workload clusters must be registered in ArgoCD with:

```yaml
devplane.io/workload: "true"
```

Then they receive the agent and observability ApplicationSets.

## Application Template

DevPlane includes an application chart at:

```text
charts/apps/application
```

The portal will use this chart to generate app directories and values files.
Initial templates are available for:

- Produtos
- Contabilidade
- Logistica

Each generated app can choose Postgres settings and observability options for
logs, metrics, traces, and datastores.

Packaged app templates are available in:

```text
apps/produtos
apps/contabilidade
apps/logistica
```

The portal workflow is backed by:

```bash
devplane app create produtos
```

This creates a local app directory and applies the generated ArgoCD
`application.yaml`.

The sample apps are real FastAPI services with Postgres access and
OpenTelemetry auto-instrumentation, published by the `sample-apps` GitHub
Actions workflow to GHCR.

## Local Domains

```bash
devplane hosts
```

The command updates the DevPlane-managed block in `/etc/hosts` with:

- `argo.devplane`
- `portal.devplane`
- `vault.devplane`
- `grafana.devplane`

## Useful Commands

```bash
devplane status
devplane cluster appsets
devplane down
```
