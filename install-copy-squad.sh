#!/usr/bin/env bash
# install-copy-squad.sh — Copy Squad v2 installer
#
# Usage: ./install-copy-squad.sh <target-path>
#
# Copia:
#   - .claude/agents/      → 18 agents (15 copywriters + 3 support)
#   - .claude/commands/    → slash command /copy
#   - research/            → 15 dossiers (60 arquivos)
#
# NÃO copia:
#   - .claude/settings.json (config local)
#   - .claude/settings.local.json (config local)
#
# Exit codes:
#   0 = success
#   1 = path error (não existe ou não tem permissão)

set -euo pipefail

# Resolver SCRIPT_DIR (compatible bash 3.2 macOS)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Argumentos
TARGET_PATH="${1:-}"

# Validar argumento
if [ -z "$TARGET_PATH" ]; then
  echo "❌ Erro: caminho do projeto destino não informado." >&2
  echo "" >&2
  echo "Usage: $0 <target-path>" >&2
  echo "" >&2
  echo "Exemplo: $0 ~/meu-projeto" >&2
  exit 1
fi

# Validar que path existe
if [ ! -d "$TARGET_PATH" ]; then
  echo "❌ Erro: caminho não existe ou não é um diretório: $TARGET_PATH" >&2
  exit 1
fi

# Validar acesso read+write
if [ ! -r "$TARGET_PATH" ] || [ ! -w "$TARGET_PATH" ]; then
  echo "❌ Erro: sem permissão read+write em: $TARGET_PATH" >&2
  exit 1
fi

# Validar source existe
if [ ! -d "$SCRIPT_DIR/.claude" ] || [ ! -d "$SCRIPT_DIR/research" ]; then
  echo "❌ Erro: source files não encontrados em $SCRIPT_DIR" >&2
  echo "    Esperado: .claude/agents/, .claude/commands/, research/" >&2
  exit 1
fi

# Criar destino .claude se não existir
mkdir -p "$TARGET_PATH/.claude"

# Copiar agents
cp -R "$SCRIPT_DIR/.claude/agents" "$TARGET_PATH/.claude/"

# Copiar commands
cp -R "$SCRIPT_DIR/.claude/commands" "$TARGET_PATH/.claude/"

# Copiar research
cp -R "$SCRIPT_DIR/research" "$TARGET_PATH/"

echo "✅ Copy Squad v2 instalado em $TARGET_PATH"
echo ""
echo "Próximo passo: abrir $TARGET_PATH no Claude Code e digitar /copy \"<demanda>\""
