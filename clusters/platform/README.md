# Platform Cluster

Configuration for the single local DevPlane kind cluster.

The cluster has one control-plane node and two worker nodes. Workers are labeled
with `devplane.io/node-pool=addons`, and packaged addons use that label so they
do not run on the control-plane.

## Addons

Addons are not stored under this directory. They are packaged Helm charts in:

```text
charts/platform/
charts/agents/
charts/observability/
```

The ApplicationSets reconcile:

- platform: `ingress-nginx`, `argocd`, `vault`, `external-secrets`, and `kyverno`;
- agents: `opentelemetry-collector` and `vector`;
- observability: `grafana`, `loki`, `tempo`, and `mimir`.

## Install

Use the script from the repository root to create the cluster, bootstrap `ingress-nginx` and `argocd`, and apply the ApplicationSets:

```bash
make up
```

After the initial bootstrap, ArgoCD reconciles the packaged charts from this repository.

## Domains

- ArgoCD: `http://argo.devplane`
- Vault: `http://vault.devplane`
- Grafana: `http://grafana.devplane`

Update `/etc/hosts`:

```bash
make hosts
```

If you need to force the IP:

```bash
INGRESS_HOST_IP=127.0.0.1 make hosts
```
