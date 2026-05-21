# DevPlane Application Template

The application chart lives at:

```text
charts/apps/application
```

The portal will use this chart to create application directories in the local
DevPlane installation. A generated app should contain a values file based on one
of the portal templates:

```text
examples/apps/produtos/values.yaml
examples/apps/contabilidade/values.yaml
examples/apps/logistica/values.yaml
```

## Flow

```text
Portal selection -> generated app values -> ArgoCD Application -> application chart rollout
```

The generated values define:

- app name and domain;
- container image;
- Postgres database settings;
- observability toggles for logs, metrics, and traces;
- observability datastores: Loki, Mimir, and Tempo.

## Telemetry

Apps are born with OpenTelemetry environment variables pointing at the workload
OpenTelemetry Collector. The collector forwards telemetry to Vector, and Vector
routes data to Loki, Mimir, and Tempo.
