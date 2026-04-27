#!/usr/bin/env bats
# tests/install/install.bats — BATS test suite para install-copy-squad.sh
#
# Cobertura PRD Story 5.3 AC2:
#   (a) install em path limpo
#   (b) install com conflito sem --force falha graceful (exit 2)
#   (c) install com --force cria backup correto
#   (d) install --user instala em ~/.claude/ (testado via TMPDIR override)
#   (e) install --dry-run não modifica filesystem
#   (f) install em path inexistente falha com exit 1
#   (g) install --help retorna texto de ajuda
#
# Run local: bats tests/install/
# Run CI: integrated em .github/workflows/validate.yml

setup() {
  # Resolver path do install script (raiz do repo, 2 níveis acima)
  INSTALL_SCRIPT="$BATS_TEST_DIRNAME/../../install-copy-squad.sh"

  # Criar TMPDIR para cada teste
  TEST_TMPDIR="$(mktemp -d -t copy-squad-bats.XXXXXX)"

  # Sanity: install script existe e é executável
  [ -x "$INSTALL_SCRIPT" ]
}

teardown() {
  # Cleanup TMPDIR
  if [ -n "${TEST_TMPDIR:-}" ] && [ -d "$TEST_TMPDIR" ]; then
    rm -rf "$TEST_TMPDIR"
  fi
}

# ─── Test (a): install em path limpo ──────────────────────────────────────────
@test "install em path limpo — sucesso (exit 0) + agents/commands/research copiados" {
  run "$INSTALL_SCRIPT" "$TEST_TMPDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Copy Squad v2 instalado" ]]
  [ -d "$TEST_TMPDIR/.claude/agents" ]
  [ -d "$TEST_TMPDIR/.claude/commands" ]
  [ -d "$TEST_TMPDIR/research" ]
  # Verifica copywriters específicos copiados
  [ -f "$TEST_TMPDIR/.claude/agents/halbert.md" ]
  [ -f "$TEST_TMPDIR/.claude/agents/copy-master.md" ]
  [ -f "$TEST_TMPDIR/.claude/commands/copy.md" ]
  [ -d "$TEST_TMPDIR/research/halbert" ]
}

# ─── Test (b): conflito sem --force falha graceful (exit 2) ────────────────────
@test "conflito sem --force — falha graceful exit 2" {
  # Setup: criar .claude/agents/ pré-existente
  mkdir -p "$TEST_TMPDIR/.claude/agents"
  touch "$TEST_TMPDIR/.claude/agents/preexisting.md"

  run "$INSTALL_SCRIPT" "$TEST_TMPDIR"
  [ "$status" -eq 2 ]
  [[ "$output" =~ "Conflito" ]] || [[ "$output" =~ "conflito" ]]
  [[ "$output" =~ "--force" ]]

  # Verifica que arquivo pré-existente não foi tocado
  [ -f "$TEST_TMPDIR/.claude/agents/preexisting.md" ]
}

# ─── Test (c): --force cria backup correto ─────────────────────────────────────
@test "--force com conflito — cria backup .claude.backup-{timestamp}/" {
  # Setup: pre-existing .claude
  mkdir -p "$TEST_TMPDIR/.claude/agents"
  echo "old content" > "$TEST_TMPDIR/.claude/agents/old-agent.md"

  run "$INSTALL_SCRIPT" --force "$TEST_TMPDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Backup criado" ]] || [[ "$output" =~ "backup" ]]

  # Verifica backup criado
  BACKUP_DIRS="$(find "$TEST_TMPDIR" -maxdepth 1 -type d -name '.claude.backup-*')"
  [ -n "$BACKUP_DIRS" ]

  # Verifica conteúdo antigo preservado em backup
  BACKUP_DIR="$(echo "$BACKUP_DIRS" | head -1)"
  [ -f "$BACKUP_DIR/.claude/agents/old-agent.md" ]
  grep -q "old content" "$BACKUP_DIR/.claude/agents/old-agent.md"

  # Verifica install procedeu (novos agents presentes)
  [ -f "$TEST_TMPDIR/.claude/agents/halbert.md" ]
}

# ─── Test (d): --user instala em ~/.claude/ ────────────────────────────────────
@test "--user instala em \$HOME (override via HOME env var)" {
  # Override HOME para test isolation
  export HOME="$TEST_TMPDIR"

  run "$INSTALL_SCRIPT" --user
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Copy Squad v2 instalado em $TEST_TMPDIR" ]]
  [ -d "$TEST_TMPDIR/.claude/agents" ]
  [ -d "$TEST_TMPDIR/research" ]
}

# ─── Test (e): --dry-run não modifica filesystem ───────────────────────────────
@test "--dry-run em path limpo — emite ops sem modify filesystem (exit 0)" {
  run "$INSTALL_SCRIPT" --dry-run "$TEST_TMPDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DRY-RUN" ]]
  [[ "$output" =~ "Simulation completed" ]]

  # Verifica filesystem inalterado
  [ ! -d "$TEST_TMPDIR/.claude/agents" ]
  [ ! -d "$TEST_TMPDIR/research" ]
}

# ─── Test (f): path inexistente — exit 1 ───────────────────────────────────────
@test "path inexistente — falha graceful exit 1" {
  run "$INSTALL_SCRIPT" "/nonexistent-path-$(date +%s)"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "não existe" ]] || [[ "$output" =~ "not exist" ]]
}

# ─── Test (g): --help retorna texto de ajuda ───────────────────────────────────
@test "--help retorna texto de ajuda + exit 0" {
  run "$INSTALL_SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "USAGE" ]]
  [[ "$output" =~ "FLAGS" ]]
  [[ "$output" =~ "EXIT CODES" ]]
  [[ "$output" =~ "EXEMPLOS" ]]
}

# ─── Test (h): -h short flag também funciona ───────────────────────────────────
@test "-h short flag funciona" {
  run "$INSTALL_SCRIPT" -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "USAGE" ]]
}

# ─── Test (i): unknown flag falha exit 1 ──────────────────────────────────────
@test "flag desconhecida — exit 1 com mensagem" {
  run "$INSTALL_SCRIPT" --unknown-flag "$TEST_TMPDIR"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "desconhecida" ]] || [[ "$output" =~ "unknown" ]]
}

# ─── Test (j): sem argumentos — falha exit 1 com hint ──────────────────────────
@test "sem argumentos — falha exit 1 com hint --help" {
  run "$INSTALL_SCRIPT"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "não informado" ]] || [[ "$output" =~ "--help" ]]
}
