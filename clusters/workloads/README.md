# Workload Clusters

Este diretorio guarda os clusters adicionais da DevPlane. Eles sao ambientes de runtime para apps, bancos, mensageria, integracoes e componentes de observabilidade.

Cada cluster fica em uma pasta propria:

```text
clusters/workloads/<nome>/
└── kind-config.yaml
```

Crie uma nova definicao sem subir o cluster:

```bash
./scripts/devplane cluster generate <nome>
```

Crie o cluster. Addons de workload sao gerados pelo ArgoCD quando o cluster for registrado com `devplane.io/workload=true`:

```bash
./scripts/devplane cluster add <nome>
```

Liste os clusters declarados:

```bash
./scripts/devplane cluster workloads
```
