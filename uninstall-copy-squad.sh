#!/usr/bin/env bash
# uninstall-copy-squad.sh — Copy Squad v2 uninstaller
#
# Remove apenas arquivos do Copy Squad. NÃO toca em outros agents customizados
# do usuário, settings.json, ou settings.local.json.
#
# Backup automático em {target}/.claude.uninstall-backup-{YYYYMMDDTHHMMSS}/
# antes de remover qualquer coisa.
#
# Usage:
#   ./uninstall-copy-squad.sh <target-path>          # uninstall de path específico
#   ./uninstall-copy-squad.sh --user                 # uninstall de ~/.claude/
#   ./uninstall-copy-squad.sh --force <path>         # skip confirmação interativa
#   ./uninstall-copy-squad.sh --dry-run <path>       # imprime plano sem executar
#   ./uninstall-copy-squad.sh --help | -h            # ajuda
#
# Exit codes:
#   0 = success
#   1 = path error
#   2 = nada-pra-desinstalar (squad não detectado)
#   3 = user cancelou (sem --force)

set -euo pipefail

# Defaults
USE_USER=false
FORCE=false
DRY_RUN=false
TARGET_PATH=""

# ─── Hardcoded list de arquivos do Copy Squad ──────────────────────────────────
# 18 agents (15 copywriters + 3 support)
COPYWRITER_AGENTS=(
  "halbert.md" "schwartz.md" "hopkins.md" "caples.md"
  "sugarman.md" "kennedy.md" "bencivenga.md"
  "carlton.md" "makepeace.md" "collier.md"
  "ogilvy.md" "bernbach.md" "burnett.md" "abbott.md" "bird.md"
)

SUPPORT_AGENTS=(
  "copy-master.md" "copy-researcher.md" "copy-reviewer.md"
)

# 15 research dirs
RESEARCH_DIRS=(
  "halbert" "schwartz" "hopkins" "caples"
  "sugarman" "kennedy" "bencivenga"
  "carlton" "makepeace" "collier"
  "ogilvy" "bernbach" "burnett" "abbott" "bird"
)

# ─── Help text ─────────────────────────────────────────────────────────────────
print_help() {
  cat <<'EOF'
uninstall-copy-squad.sh — Copy Squad v2 uninstaller

USAGE:
  ./uninstall-copy-squad.sh <target-path>          Uninstall de path específico
  ./uninstall-copy-squad.sh --user                 Uninstall de ~/.claude/
  ./uninstall-copy-squad.sh --force <path>         Skip confirmação interativa
  ./uninstall-copy-squad.sh --dry-run <path>       Imprime plano sem executar
  ./uninstall-copy-squad.sh --help                 Exibe esta ajuda

FLAGS:
  --user        Uninstall de ~/.claude/ (escopo global)
  --force       Skip prompt de confirmação
  --dry-run     Imprime plano de remoção sem executar
  --help, -h    Exibe esta ajuda

REMOVE:
  - 18 agents do Copy Squad em .claude/agents/ (lista hardcoded)
  - .claude/agents/_shared/ (frameworks + glossario shared)
  - .claude/commands/copy.md (slash command)
  - 15 research dirs em research/ (lista hardcoded)

NÃO TOCA:
  - Outros agents customizados em .claude/agents/ (não-Copy-Squad)
  - settings.json
  - settings.local.json
  - Outros arquivos do projeto

BACKUP AUTOMÁTICO:
  Antes de remover, cria backup em:
  {target}/.claude.uninstall-backup-{YYYYMMDDTHHMMSS}/

  Backup contém:
  - Todos os arquivos a serem removidos
  - _MANIFEST.txt documentando a operação

EXIT CODES:
  0  Success
  1  Path error (path não existe ou source missing)
  2  Nada-pra-desinstalar (squad não detectado em path)
  3  User cancelou (sem --force, prompt sim/não)

EXEMPLOS:
  # Uninstall com confirmação interativa
  ./uninstall-copy-squad.sh ~/meu-projeto

  # Uninstall sem confirmação
  ./uninstall-copy-squad.sh --force ~/meu-projeto

  # Simular uninstall global
  ./uninstall-copy-squad.sh --dry-run --user

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
  TARGET_PATH="$HOME"
fi

if [ -z "$TARGET_PATH" ]; then
  echo "❌ Erro: caminho do projeto destino não informado." >&2
  echo "Use: $0 <target-path>  ou  $0 --user" >&2
  exit 1
fi

# ─── Validar path destino ──────────────────────────────────────────────────────
if [ ! -d "$TARGET_PATH" ]; then
  echo "❌ Erro: caminho não existe ou não é um diretório: $TARGET_PATH" >&2
  exit 1
fi

# ─── Detectar Copy Squad ───────────────────────────────────────────────────────
DETECTED_FILES=()
DETECTED_DIRS=()

# Check copywriter agents
for agent in "${COPYWRITER_AGENTS[@]}"; do
  if [ -f "$TARGET_PATH/.claude/agents/$agent" ]; then
    DETECTED_FILES+=("$TARGET_PATH/.claude/agents/$agent")
  fi
done

# Check support agents
for agent in "${SUPPORT_AGENTS[@]}"; do
  if [ -f "$TARGET_PATH/.claude/agents/$agent" ]; then
    DETECTED_FILES+=("$TARGET_PATH/.claude/agents/$agent")
  fi
done

# Check _shared
if [ -d "$TARGET_PATH/.claude/agents/_shared" ]; then
  DETECTED_DIRS+=("$TARGET_PATH/.claude/agents/_shared")
fi

# Check command
if [ -f "$TARGET_PATH/.claude/commands/copy.md" ]; then
  DETECTED_FILES+=("$TARGET_PATH/.claude/commands/copy.md")
fi

# Check research dirs
for dir in "${RESEARCH_DIRS[@]}"; do
  if [ -d "$TARGET_PATH/research/$dir" ]; then
    DETECTED_DIRS+=("$TARGET_PATH/research/$dir")
  fi
done

TOTAL_DETECTED=$((${#DETECTED_FILES[@]} + ${#DETECTED_DIRS[@]}))

if [ "$TOTAL_DETECTED" -eq 0 ]; then
  echo "❌ Copy Squad não detectado em $TARGET_PATH" >&2
  echo "Nada para desinstalar." >&2
  exit 2
fi

# ─── Imprimir plano ────────────────────────────────────────────────────────────
echo "📋 Plano de uninstall — $TARGET_PATH"
echo ""
echo "Arquivos a remover (${#DETECTED_FILES[@]}):"
for f in "${DETECTED_FILES[@]}"; do
  echo "  - $f"
done
echo ""
echo "Diretórios a remover (${#DETECTED_DIRS[@]}):"
for d in "${DETECTED_DIRS[@]}"; do
  echo "  - $d/"
done
echo ""
echo "Total: $TOTAL_DETECTED itens"
echo ""
echo "NÃO será tocado:"
echo "  - Outros agents em .claude/agents/ (não-listados acima)"
echo "  - .claude/settings.json"
echo "  - .claude/settings.local.json"
echo ""

# ─── Dry-run ───────────────────────────────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Plano impresso. Nenhum arquivo foi modificado. Exit 0."
  exit 0
fi

# ─── Confirmação interativa (se sem --force) ───────────────────────────────────
if [ "$FORCE" = false ]; then
  printf "Confirma uninstall? (s/N): "
  read -r CONFIRM
  if [ "$CONFIRM" != "s" ] && [ "$CONFIRM" != "S" ] && [ "$CONFIRM" != "sim" ]; then
    echo "❌ Uninstall cancelado pelo usuário." >&2
    exit 3
  fi
fi

# ─── Backup ────────────────────────────────────────────────────────────────────
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"
BACKUP_DIR="$TARGET_PATH/.claude.uninstall-backup-$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

# Copy detected files preserving structure
for f in "${DETECTED_FILES[@]}"; do
  REL_PATH="${f#$TARGET_PATH/}"
  mkdir -p "$BACKUP_DIR/$(dirname "$REL_PATH")"
  cp "$f" "$BACKUP_DIR/$REL_PATH"
done

# Copy detected dirs preserving structure
for d in "${DETECTED_DIRS[@]}"; do
  REL_PATH="${d#$TARGET_PATH/}"
  mkdir -p "$BACKUP_DIR/$(dirname "$REL_PATH")"
  cp -R "$d" "$BACKUP_DIR/$REL_PATH"
done

# Manifest
cat > "$BACKUP_DIR/_MANIFEST.txt" <<EOF
Copy Squad Uninstall Backup
Timestamp: $TIMESTAMP
Target: $TARGET_PATH
Total items: $TOTAL_DETECTED
Files removed: ${#DETECTED_FILES[@]}
Dirs removed: ${#DETECTED_DIRS[@]}

Para restore:
  cp -R $BACKUP_DIR/.claude/agents/* $TARGET_PATH/.claude/agents/
  cp -R $BACKUP_DIR/.claude/commands/* $TARGET_PATH/.claude/commands/
  cp -R $BACKUP_DIR/research/* $TARGET_PATH/research/
EOF

echo "📦 Backup criado em: $BACKUP_DIR"

# ─── Remoção ───────────────────────────────────────────────────────────────────
for f in "${DETECTED_FILES[@]}"; do
  rm "$f"
done

for d in "${DETECTED_DIRS[@]}"; do
  rm -rf "$d"
done

# Cleanup empty dirs (research/ se ficou vazio)
if [ -d "$TARGET_PATH/research" ] && [ -z "$(ls -A "$TARGET_PATH/research")" ]; then
  rmdir "$TARGET_PATH/research"
fi

# ─── Relatório final ───────────────────────────────────────────────────────────
echo ""
echo "✅ Copy Squad desinstalado de $TARGET_PATH"
echo ""
echo "Estatísticas:"
echo "  - ${#DETECTED_FILES[@]} arquivos removidos"
echo "  - ${#DETECTED_DIRS[@]} diretórios removidos"
echo "  - Total: $TOTAL_DETECTED itens"
echo ""
echo "Backup em: $BACKUP_DIR"
echo ""
echo "Para restaurar:"
echo "  cp -R $BACKUP_DIR/.claude/* $TARGET_PATH/.claude/ 2>/dev/null"
echo "  [ -d $BACKUP_DIR/research ] && cp -R $BACKUP_DIR/research $TARGET_PATH/"
