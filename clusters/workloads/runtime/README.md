# runtime

DevPlane workload cluster.

Kind cluster name: `devplane-runtime`

Node groups simulated with kind worker labels:

- `devplane.io/node-group=app`
- `devplane.io/node-group=observability`
- `devplane.io/node-group=databases`

ArgoCD-managed observability baseline:

- Grafana
- Loki
- Tempo
- Mimir
- OpenTelemetry Collector
- Vector

Workload addons are managed by ArgoCD ApplicationSet cluster generators.
Register this cluster in ArgoCD with:

- `devplane.io/workload=true`
