# DevPlane Application Template

The application chart lives at:

```text
charts/apps/application
```

The portal uses this chart to create application directories in the local
DevPlane installation. A generated app contains a wrapper chart, a values file,
and an ArgoCD `Application` manifest.

```text
apps/produtos/
apps/contabilidade/
apps/logistica/
```

## Flow

```text
Portal selection -> local app directory -> kubectl apply application.yaml -> ArgoCD rollout
```

The generated values define:

- app name and domain;
- container image;
- Postgres database settings;
- observability toggles for logs, metrics, and traces;
- observability datastores: Loki, Mimir, and Tempo.

The CLI command used by the portal is:

```bash
devplane app create produtos
devplane app create contabilidade
devplane app create logistica
```

It copies the selected app into `local/apps/<name>/` and applies:

```text
local/apps/<name>/application.yaml
```

## Telemetry

Apps are born with OpenTelemetry environment variables pointing at the workload
OpenTelemetry Collector. The collector forwards telemetry to Vector, and Vector
routes data to Loki, Mimir, and Tempo.
