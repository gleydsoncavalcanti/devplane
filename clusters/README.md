# Clusters

A estrutura de clusters separa o plano da plataforma dos ambientes onde as aplicacoes rodam.

```text
clusters/
├── platform/
│   └── kind-config.yaml
└── workloads/
    └── <cluster>/
        └── kind-config.yaml
```

## `platform/`

Cluster principal da DevPlane. Ele concentra os componentes de controle da plataforma, como ArgoCD, ingress, Vault, External Secrets e Kyverno.

## `workloads/`

Clusters adicionais criados pelo `devplane` para executar apps, bancos, mensageria, ferramentas de runtime e a stack de observabilidade. Cada cluster de workload nasce com node groups simulados no kind:

- `app`
- `observability`
- `databases`

O baseline de workload e gerado pelo ArgoCD e inclui Grafana, Loki, Tempo, Mimir, OpenTelemetry Collector e Vector. Prometheus/kube-prometheus-stack nao faz parte do baseline; metricas devem ir para Mimir.

## Comandos

```bash
./scripts/devplane cluster generate runtime
./scripts/devplane cluster add runtime
./scripts/devplane cluster workloads
./scripts/devplane cluster remove runtime
```

Os addons de workload nao sao instalados pelo `scripts/devplane`. Eles sao gerados pelos ApplicationSets em `gitops/applicationsets/`.
