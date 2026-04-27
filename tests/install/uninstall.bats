#!/usr/bin/env bats
# tests/install/uninstall.bats — BATS tests para uninstall-copy-squad.sh
#
# Cobertura PRD Story 5.7 AC13:
#   (a) clean uninstall em projeto com squad instalado
#   (b) --dry-run não modifica filesystem
#   (c) --force skipa confirmação
#   (d) path inexistente falha exit 1
#   (e) projeto sem squad falha exit 2
#   (f) backup é criado antes de remoção
#   (g) outros agentes do user permanecem intactos
#   (h) --help retorna ajuda

setup() {
  INSTALL_SCRIPT="$BATS_TEST_DIRNAME/../../install-copy-squad.sh"
  UNINSTALL_SCRIPT="$BATS_TEST_DIRNAME/../../uninstall-copy-squad.sh"
  TEST_TMPDIR="$(mktemp -d -t copy-squad-uninstall-bats.XXXXXX)"

  [ -x "$INSTALL_SCRIPT" ]
  [ -x "$UNINSTALL_SCRIPT" ]
}

teardown() {
  if [ -n "${TEST_TMPDIR:-}" ] && [ -d "$TEST_TMPDIR" ]; then
    rm -rf "$TEST_TMPDIR"
  fi
}

# ─── (a) clean uninstall ──────────────────────────────────────────────────────
@test "clean uninstall em projeto com squad instalado" {
  # Setup: install primeiro
  "$INSTALL_SCRIPT" "$TEST_TMPDIR" >/dev/null
  [ -f "$TEST_TMPDIR/.claude/agents/halbert.md" ]

  # Uninstall com --force
  run "$UNINSTALL_SCRIPT" --force "$TEST_TMPDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "desinstalado" ]]
  [[ "$output" =~ "Backup em:" ]]

  # Verificar agents do Copy Squad removidos
  [ ! -f "$TEST_TMPDIR/.claude/agents/halbert.md" ]
  [ ! -f "$TEST_TMPDIR/.claude/agents/copy-master.md" ]
  [ ! -d "$TEST_TMPDIR/research/halbert" ]
}

# ─── (b) --dry-run não modifica filesystem ─────────────────────────────────────
@test "--dry-run em projeto com squad — emite plano sem modificar" {
  "$INSTALL_SCRIPT" "$TEST_TMPDIR" >/dev/null

  run "$UNINSTALL_SCRIPT" --dry-run "$TEST_TMPDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DRY-RUN" ]] || [[ "$output" =~ "Plano impresso" ]]

  # Filesystem inalterado
  [ -f "$TEST_TMPDIR/.claude/agents/halbert.md" ]
  [ -d "$TEST_TMPDIR/research/halbert" ]
}

# ─── (c) --force skipa confirmação ─────────────────────────────────────────────
@test "--force skipa confirmação interativa" {
  "$INSTALL_SCRIPT" "$TEST_TMPDIR" >/dev/null

  # Sem --force, sem stdin pipe simulando, vamos confirmar comportamento via timeout
  # No --force, script remove sem perguntar
  run "$UNINSTALL_SCRIPT" --force "$TEST_TMPDIR"
  [ "$status" -eq 0 ]
}

# ─── (d) path inexistente — exit 1 ─────────────────────────────────────────────
@test "path inexistente — exit 1" {
  run "$UNINSTALL_SCRIPT" --force "/nonexistent-path-$(date +%s)"
  [ "$status" -eq 1 ]
}

# ─── (e) projeto sem squad — exit 2 ────────────────────────────────────────────
@test "projeto sem squad instalado — exit 2 (nada-pra-desinstalar)" {
  # TEST_TMPDIR está vazio (sem install)
  run "$UNINSTALL_SCRIPT" --force "$TEST_TMPDIR"
  [ "$status" -eq 2 ]
  [[ "$output" =~ "não detectado" ]] || [[ "$output" =~ "Nada para desinstalar" ]]
}

# ─── (f) backup criado antes de remoção ────────────────────────────────────────
@test "backup é criado em .claude.uninstall-backup-{timestamp}/" {
  "$INSTALL_SCRIPT" "$TEST_TMPDIR" >/dev/null

  run "$UNINSTALL_SCRIPT" --force "$TEST_TMPDIR"
  [ "$status" -eq 0 ]

  # Verificar backup criado
  BACKUP_DIRS="$(find "$TEST_TMPDIR" -maxdepth 1 -type d -name '.claude.uninstall-backup-*')"
  [ -n "$BACKUP_DIRS" ]

  # Verificar conteúdo do backup
  BACKUP_DIR="$(echo "$BACKUP_DIRS" | head -1)"
  [ -f "$BACKUP_DIR/_MANIFEST.txt" ]
  [ -f "$BACKUP_DIR/.claude/agents/halbert.md" ]
  [ -d "$BACKUP_DIR/research/halbert" ]
}

# ─── (g) outros agents do user permanecem intactos ─────────────────────────────
@test "outros agentes não-Copy-Squad permanecem intactos após uninstall" {
  "$INSTALL_SCRIPT" "$TEST_TMPDIR" >/dev/null

  # Adicionar agent customizado do usuário
  echo "# user custom agent" > "$TEST_TMPDIR/.claude/agents/my-custom-agent.md"

  # Adicionar settings.json
  echo "{}" > "$TEST_TMPDIR/.claude/settings.json"

  # Uninstall
  "$UNINSTALL_SCRIPT" --force "$TEST_TMPDIR" >/dev/null

  # Custom agent + settings.json devem permanecer
  [ -f "$TEST_TMPDIR/.claude/agents/my-custom-agent.md" ]
  [ -f "$TEST_TMPDIR/.claude/settings.json" ]

  # Mas Copy Squad agents devem ter sido removidos
  [ ! -f "$TEST_TMPDIR/.claude/agents/halbert.md" ]
  [ ! -f "$TEST_TMPDIR/.claude/agents/copy-master.md" ]
}

# ─── (h) --help retorna ajuda ──────────────────────────────────────────────────
@test "--help retorna texto de ajuda + exit 0" {
  run "$UNINSTALL_SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "USAGE" ]]
  [[ "$output" =~ "FLAGS" ]]
  [[ "$output" =~ "EXIT CODES" ]]
  [[ "$output" =~ "EXEMPLOS" ]]
}
