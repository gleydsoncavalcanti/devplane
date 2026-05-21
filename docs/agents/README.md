# DevPlane Agents

Este diretorio guarda instrucoes para agentes de IA que operam a DevPlane.

O primeiro agente e o `devplane-platform-agent.md`. Ele foi escrito para ser copiado como prompt de sistema/instrucoes customizadas em ferramentas como Codex, Cursor, Copilot Chat, Continue, agentes internos ou uma futura extensao do VS Code.

Para uso como skill, veja tambem:

```text
skills/devplane/SKILL.md
```

## Agente disponivel

- `devplane-platform-agent.md`: agente para preparar o cluster local, aplicar GitOps e orientar a evolucao da plataforma.

## Como usar

Copie o conteudo do arquivo do agente para a ferramenta de IA escolhida e abra este repositorio como workspace.

O agente deve operar preferencialmente pelo CLI:

```bash
./scripts/install-cli
./scripts/devplane install-prereqs
./scripts/devplane up
./scripts/devplane cluster appsets
./scripts/devplane status
./scripts/devplane hosts
```

Alteracoes em `/etc/hosts` e instalacoes no cluster devem ser feitas somente com confirmacao do usuario.
