# Clusters

DevPlane uses one local kind cluster.

```text
clusters/
└── platform/
    └── kind-config.yaml
```

The platform cluster runs the control plane addons, agents, and observability stack. It has one control-plane node and two worker nodes labeled `devplane.io/node-pool=addons`; packaged addons use that selector so they do not run on the control-plane. ArgoCD reconciles everything from packaged charts through the ApplicationSets in `gitops/applicationsets/`.

Apps and sample services are maintained outside this repository in:

```text
https://github.com/gleydsoncavalcanti/devplane-apps
```
