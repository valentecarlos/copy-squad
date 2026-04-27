#!/usr/bin/env bash
# install-copy-squad.sh — Copy Squad v2 installer
#
# Usage:
#   ./install-copy-squad.sh <target-path>           # install em path específico
#   ./install-copy-squad.sh --user                  # install global em ~/.claude/
#   ./install-copy-squad.sh --force <path>          # overwrite + backup automático
#   ./install-copy-squad.sh --dry-run <path>        # simula sem modificar filesystem
#   ./install-copy-squad.sh --help | -h             # exibe ajuda
#
# Exit codes:
#   0 = success (ou dry-run sem erros)
#   1 = path error / source missing / unknown flag
#   2 = conflict sem --force (.claude/ existe no destino)
#   3 = permission denied
#
# Copia: .claude/agents/ + .claude/commands/ + research/
# NÃO copia: .claude/settings.json + .claude/settings.local.json

set -euo pipefail

# Resolver SCRIPT_DIR (compatible bash 3.2 macOS)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Defaults
USE_USER=false
FORCE=false
DRY_RUN=false
TARGET_PATH=""

# ─── Help text ─────────────────────────────────────────────────────────────────
print_help() {
  cat <<'EOF'
install-copy-squad.sh — Copy Squad v2 installer

USAGE:
  ./install-copy-squad.sh <target-path>           Install em path específico
  ./install-copy-squad.sh --user                  Install global em ~/.claude/
  ./install-copy-squad.sh --force <path>          Overwrite com backup automático
  ./install-copy-squad.sh --dry-run <path>        Simula sem modificar filesystem
  ./install-copy-squad.sh --help                  Exibe esta ajuda

FLAGS:
  --user        Instala em ~/.claude/ (escopo global)
  --force       Sobrescreve .claude/ existente; backup automático em .claude.backup-{timestamp}/
  --dry-run     Imprime operações sem executar (exit 0 se nenhuma falharia)
  --help, -h    Exibe esta ajuda

COMBINAÇÕES VÁLIDAS:
  --user --force                                   Overwrite ~/.claude/ com backup
  --user --dry-run                                 Simula install global
  --force --dry-run                                Simula overwrite + backup

EXIT CODES:
  0  Success (ou dry-run sem erros detectados)
  1  Path error / source missing / unknown flag
  2  Conflict sem --force (.claude/ ou research/ já existe no destino)
  3  Permission denied (sem read+write em path destino)

EXEMPLOS:
  # Install em projeto novo
  ./install-copy-squad.sh ~/meu-projeto

  # Install global (disponível em qualquer projeto Claude Code)
  ./install-copy-squad.sh --user

  # Reinstall em projeto que já tem .claude/ (com backup)
  ./install-copy-squad.sh --force ~/meu-projeto

  # Simular install global antes de aplicar
  ./install-copy-squad.sh --user --dry-run

INSTALA:
  - .claude/agents/      18 agents (15 copywriters + 3 support)
  - .claude/commands/    Slash command /copy
  - research/            15 dossiers (60 arquivos)

NÃO TOCA:
  - .claude/settings.json (config local)
  - .claude/settings.local.json (config local)
  - Outros agentes não-Copy-Squad em .claude/agents/

DOCS:
  https://github.com/valentecarlos/copy-squad
EOF
}

# ─── Parse args ────────────────────────────────────────────────────────────────
while [ $# -gt 0 ]; do
  case "$1" in
    --user)
      USE_USER=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help|-h)
      print_help
      exit 0
      ;;
    --*)
      echo "❌ Erro: flag desconhecida: $1" >&2
      echo "Use --help para ver flags disponíveis." >&2
      exit 1
      ;;
    *)
      if [ -z "$TARGET_PATH" ]; then
        TARGET_PATH="$1"
      else
        echo "❌ Erro: múltiplos argumentos posicionais. Apenas 1 path permitido." >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# ─── Resolve TARGET_PATH ───────────────────────────────────────────────────────
if [ "$USE_USER" = true ]; then
  if [ -n "$TARGET_PATH" ]; then
    echo "⚠️  Aviso: --user ignora <target-path>. Usando ~/.claude/ como destino." >&2
  fi
  TARGET_PATH="$HOME"
fi

if [ -z "$TARGET_PATH" ]; then
  echo "❌ Erro: caminho do projeto destino não informado." >&2
  echo "" >&2
  echo "Use: $0 <target-path>  ou  $0 --user" >&2
  echo "Veja --help para mais opções." >&2
  exit 1
fi

# ─── Validar path destino ──────────────────────────────────────────────────────
if [ ! -d "$TARGET_PATH" ]; then
  echo "❌ Erro: caminho não existe ou não é um diretório: $TARGET_PATH" >&2
  exit 1
fi

if [ ! -r "$TARGET_PATH" ] || [ ! -w "$TARGET_PATH" ]; then
  echo "❌ Erro: sem permissão read+write em: $TARGET_PATH" >&2
  exit 3
fi

# ─── Validar source existe ─────────────────────────────────────────────────────
if [ ! -d "$SCRIPT_DIR/.claude" ] || [ ! -d "$SCRIPT_DIR/research" ]; then
  echo "❌ Erro: source files não encontrados em $SCRIPT_DIR" >&2
  echo "    Esperado: .claude/agents/, .claude/commands/, research/" >&2
  exit 1
fi

# ─── Detectar conflito (.claude/ ou research/ já existe) ──────────────────────
HAS_CONFLICT=false
if [ -d "$TARGET_PATH/.claude/agents" ] || [ -d "$TARGET_PATH/research" ]; then
  HAS_CONFLICT=true
fi

if [ "$HAS_CONFLICT" = true ] && [ "$FORCE" = false ]; then
  echo "❌ Conflito: .claude/agents/ ou research/ já existe em $TARGET_PATH" >&2
  echo "" >&2
  echo "Opções:" >&2
  echo "  - $0 --force $TARGET_PATH    (overwrite com backup automático)" >&2
  echo "  - $0 --dry-run $TARGET_PATH  (simular operação primeiro)" >&2
  exit 2
fi

# ─── Backup (se --force e conflito) ────────────────────────────────────────────
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"
BACKUP_DIR="$TARGET_PATH/.claude.backup-$TIMESTAMP"

if [ "$FORCE" = true ] && [ "$HAS_CONFLICT" = true ]; then
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] mkdir -p $BACKUP_DIR"
    [ -d "$TARGET_PATH/.claude" ] && echo "[DRY-RUN] cp -R $TARGET_PATH/.claude $BACKUP_DIR/"
    [ -d "$TARGET_PATH/research" ] && echo "[DRY-RUN] cp -R $TARGET_PATH/research $BACKUP_DIR/"
  else
    mkdir -p "$BACKUP_DIR"
    if [ -d "$TARGET_PATH/.claude" ]; then
      cp -R "$TARGET_PATH/.claude" "$BACKUP_DIR/"
    fi
    if [ -d "$TARGET_PATH/research" ]; then
      cp -R "$TARGET_PATH/research" "$BACKUP_DIR/"
    fi
    echo "📦 Backup criado em: $BACKUP_DIR"
  fi
fi

# ─── Operações de install ─────────────────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] mkdir -p $TARGET_PATH/.claude"
  echo "[DRY-RUN] cp -R $SCRIPT_DIR/.claude/agents $TARGET_PATH/.claude/"
  echo "[DRY-RUN] cp -R $SCRIPT_DIR/.claude/commands $TARGET_PATH/.claude/"
  echo "[DRY-RUN] cp -R $SCRIPT_DIR/research $TARGET_PATH/"
  echo ""
  echo "[DRY-RUN] ✅ Simulation completed. Nenhum arquivo foi modificado."
  exit 0
fi

# Criar destino .claude se não existir
mkdir -p "$TARGET_PATH/.claude"

# Copiar agents (overwrite-friendly via cp -R)
cp -R "$SCRIPT_DIR/.claude/agents" "$TARGET_PATH/.claude/"

# Copiar commands
cp -R "$SCRIPT_DIR/.claude/commands" "$TARGET_PATH/.claude/"

# Copiar research
cp -R "$SCRIPT_DIR/research" "$TARGET_PATH/"

echo "✅ Copy Squad v2 instalado em $TARGET_PATH"
if [ "$FORCE" = true ] && [ "$HAS_CONFLICT" = true ]; then
  echo "📦 Backup do .claude/research anterior em: $BACKUP_DIR"
fi
echo ""
echo "Próximo passo: abrir $TARGET_PATH no Claude Code e digitar /copy \"<demanda>\""
