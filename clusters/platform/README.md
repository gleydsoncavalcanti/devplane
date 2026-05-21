# Platform Cluster

Configuracao do cluster principal da DevPlane. Aqui ficam os componentes de controle da plataforma, como ArgoCD, ingress, Vault, External Secrets e Kyverno.

## Addons

Os addons de plataforma nao ficam neste diretorio. Eles sao charts Helm empacotados em:

```text
charts/platform/
```

O ApplicationSet `gitops/applicationsets/platform-addons.yaml` reconcilia:

- `ingress-nginx`
- `argocd`
- `portal`
- `vault`
- `external-secrets`
- `kyverno`

KEDA e Karpenter foram deixados fora da instalacao local atual. Karpenter nao agrega valor em kind/local, e KEDA sera incluido futuramente junto com workloads event-driven/autoscaling.

## Instalacao

Crie o cluster kind com portas 80/443 mapeadas para o host:

```bash
kind create cluster --config clusters/platform/kind-config.yaml
```

Use o script na raiz do repositorio para criar o cluster, fazer bootstrap de `ingress-nginx` e `argocd`, e aplicar os ApplicationSets:

```bash
make up
```

Depois do bootstrap inicial, o ArgoCD assume a reconciliacao dos addons de plataforma usando os charts empacotados no proprio DevPlane.

## Dominios

- ArgoCD: `http://argo.localhost`
- Portal: `http://portal.localhost`
- Vault: `http://vault.localhost`
- Grafana: `http://grafana.localhost`

Atualize o `/etc/hosts`:

```bash
make hosts
```

Se precisar forcar o IP:

```bash
INGRESS_HOST_IP=127.0.0.1 make hosts
```
