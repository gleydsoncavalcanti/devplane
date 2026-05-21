# DevPlane Addon Contract

Addons are packaged Helm charts inside this repository.

## Chart Layout

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
```

Do not create:

```text
clusters/platform/addons/<addon>/
clusters/workloads/<cluster>/addons/<addon>/
```

## Adding Or Changing An Addon

1. Add or update the Helm chart under `charts/platform`, `charts/agents`, or `charts/observability`.
2. Run:

```bash
helm lint charts/<group>/<chart>
helm template test charts/<group>/<chart> --namespace <namespace>
```

3. Reference the chart from an ApplicationSet under `gitops/applicationsets/`.
4. Run:

```bash
./scripts/devplane cluster appsets
```

Do not edit `scripts/devplane` just to add a new addon.

## Platform Addons

`gitops/applicationsets/platform-addons.yaml` reconciles platform addons into the platform cluster:

- `ingress-nginx`
- `argocd`
- `portal`
- `vault`
- `external-secrets`
- `kyverno`

The local bootstrap still installs `ingress-nginx` and `argocd` first so ArgoCD can start and then reconcile the declared platform state, including itself.

## Workload Baseline

Workload clusters are generated under:

```text
clusters/workloads/<name>/
```

They start with kind node groups simulated as worker labels:

- `devplane.io/node-group=app`
- `devplane.io/node-group=observability`
- `devplane.io/node-group=databases`

Workload addon ApplicationSets target clusters labeled:

```yaml
devplane.io/workload: "true"
```

The baseline is:

- Grafana
- Loki
- Tempo
- Mimir
- OpenTelemetry Collector
- Vector

## Application Template Contract

The reusable application chart lives at:

```text
charts/apps/application
```

Packaged app templates live at:

```text
apps/produtos
apps/contabilidade
apps/logistica
```

Each packaged app contains:

- `Chart.yaml`: wrapper chart depending on `charts/apps/application`.
- `values.yaml`: app-specific values for image, Postgres, and observability.
- `application.yaml`: ArgoCD Application applied by the portal/CLI.

The portal-backed command is:

```bash
./scripts/devplane app create <template>
```

## Telemetry Contract

Telemetry flow:

```text
OpenTelemetry Collector -> Vector -> Loki / Tempo / Mimir
```

- OpenTelemetry Collector collects logs, metrics, and traces and exports them to Vector over OTLP.
- Vector receives OTLP logs, metrics, and traces.
- Vector sends logs to Loki.
- Vector sends traces to Tempo.
- Vector sends metrics to Mimir using Prometheus remote write.
- MinIO is used as object storage for the observability stack where supported.

Use Mimir for metrics. Do not reintroduce Prometheus/kube-prometheus-stack into the workload baseline.
