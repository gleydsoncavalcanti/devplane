# DevPlane Package

Install DevPlane as a local CLI and Codex skill:

```bash
curl -fsSL https://raw.githubusercontent.com/gleydsoncavalcanti/devplane/main/packaging/install.sh | bash
```

The installer:

- clones or updates DevPlane into `~/.devplane/devplane`;
- installs the `devplane` CLI symlink into `~/.local/bin`;
- installs the DevPlane Codex skill into `~/.codex/skills/devplane`.

Optional environment variables:

```bash
DEVPLANE_REPO=https://github.com/gleydsoncavalcanti/devplane.git
DEVPLANE_REF=main
DEVPLANE_HOME=~/.devplane/devplane
BIN_DIR=~/.local/bin
CODEX_HOME=~/.codex
INSTALL_PREREQS=true
```

Example with prerequisites:

```bash
curl -fsSL https://raw.githubusercontent.com/gleydsoncavalcanti/devplane/main/packaging/install.sh | INSTALL_PREREQS=true bash
```
