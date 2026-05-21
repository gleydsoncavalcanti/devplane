# DevPlane Addon Contract

Addons are packaged Helm charts inside this repository and reconciled into the single local kind cluster by ArgoCD.

## Chart Layout

```text
charts/
├── platform/
│   ├── argocd/
│   ├── ingress-nginx/
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

`gitops/applicationsets/platform-addons.yaml` reconciles:

- `ingress-nginx`
- `argocd`
- `vault`
- `external-secrets`
- `kyverno`

The local bootstrap installs `ingress-nginx` and `argocd` first so ArgoCD can start and then reconcile the declared platform state, including itself.

## Agent And Observability Addons

`gitops/applicationsets/agent-addons.yaml` reconciles:

- `opentelemetry-collector`
- `vector`

`gitops/applicationsets/observability-addons.yaml` reconciles:

- `grafana`
- `loki`
- `tempo`
- `mimir`

All of them target the in-cluster Kubernetes API:

```text
https://kubernetes.default.svc
```

## Application Templates

Application chart templates and sample apps live outside this repo:

```text
https://github.com/gleydsoncavalcanti/devplane-apps
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
- MinIO is enabled by the Loki and Mimir charts for local object storage.

Use Mimir for metrics. Do not reintroduce Prometheus/kube-prometheus-stack into the local baseline.
