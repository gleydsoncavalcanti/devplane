#!/usr/bin/env bash
set -euo pipefail

DEVPLANE_REPO="${DEVPLANE_REPO:-https://github.com/gleydsoncavalcanti/devplane.git}"
DEVPLANE_REF="${DEVPLANE_REF:-main}"
DEVPLANE_HOME="${DEVPLANE_HOME:-${HOME}/.devplane/devplane}"
BIN_DIR="${BIN_DIR:-${HOME}/.local/bin}"
CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
INSTALL_PREREQS="${INSTALL_PREREQS:-false}"

has_command() {
  command -v "$1" >/dev/null 2>&1
}

ensure_git() {
  if has_command git; then
    return 0
  fi

  echo "git is required to install DevPlane." >&2
  echo "Install git or rerun after installing system prerequisites." >&2
  exit 1
}

sync_repo() {
  mkdir -p "$(dirname "${DEVPLANE_HOME}")"

  if [[ -d "${DEVPLANE_HOME}/.git" ]]; then
    git -C "${DEVPLANE_HOME}" fetch origin "${DEVPLANE_REF}"
    git -C "${DEVPLANE_HOME}" checkout "${DEVPLANE_REF}"
    git -C "${DEVPLANE_HOME}" pull --ff-only origin "${DEVPLANE_REF}"
  else
    git clone --branch "${DEVPLANE_REF}" "${DEVPLANE_REPO}" "${DEVPLANE_HOME}"
  fi
}

install_cli() {
  mkdir -p "${BIN_DIR}"
  ln -sf "${DEVPLANE_HOME}/scripts/devplane" "${BIN_DIR}/devplane"
  chmod +x "${DEVPLANE_HOME}/scripts/devplane"
  echo "Installed devplane CLI at ${BIN_DIR}/devplane"
}

install_codex_skill() {
  local source_dir="${DEVPLANE_HOME}/skills/devplane"
  local target_dir="${CODEX_HOME}/skills/devplane"

  if [[ ! -d "${source_dir}" ]]; then
    echo "DevPlane skill not found at ${source_dir}" >&2
    exit 1
  fi

  mkdir -p "$(dirname "${target_dir}")"
  rm -rf "${target_dir}"
  cp -R "${source_dir}" "${target_dir}"
  echo "Installed DevPlane Codex skill at ${target_dir}"
}

main() {
  ensure_git
  sync_repo
  install_cli
  install_codex_skill

  if [[ "${INSTALL_PREREQS}" == "true" ]]; then
    "${DEVPLANE_HOME}/scripts/devplane" install-prereqs
  fi

  cat <<EOF

DevPlane installed.

Add this to your shell profile if needed:
  export PATH="${BIN_DIR}:\$PATH"

Try:
  devplane help
  devplane up

EOF
}

main "$@"
