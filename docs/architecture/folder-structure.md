# Copy Squad — Folder Structure

> Estrutura canônica do repositório ao final de **v2.0.0**.
> Status atual indica o que existe hoje vs. o que será criado em stories futuras.
> Cross-reference completa: [`docs/architecture.md#3.1-folder-structure-canônica`](../architecture.md#31-folder-structure-canônica)

---

## Tree

```
copy-squad/
├── .claude/                        # configurações Claude Code (existe — populado por AIOX install)
│   ├── agents/                     # 18 subagents do Copy Squad (criado nesta story; populado em Epics 3+4)
│   │   ├── _shared/                # knowledge base compartilhada (criado nesta story)
│   │   │   ├── frameworks.md       # AIDA, PAS, 4 U's, awareness levels (Story 1.5)
│   │   │   └── glossario.md        # termos canônicos PT-BR de copywriting (Story 1.6)
│   │   ├── copy-master.md          # orquestrador (Story 4.5)
│   │   ├── copy-researcher.md      # support agent — avatar/mercado (Story 4.2)
│   │   ├── copy-reviewer.md        # support agent — passe técnico final (Story 4.3)
│   │   ├── halbert.md              # primeiro copywriter agent (Story 3.1, template referência)
│   │   ├── schwartz.md             # (Story 3.2)
│   │   ├── hopkins.md              # (Story 3.2)
│   │   ├── caples.md               # (Story 3.2)
│   │   ├── sugarman.md             # (Story 3.3)
│   │   ├── kennedy.md              # (Story 3.3)
│   │   ├── bencivenga.md           # (Story 3.3)
│   │   ├── carlton.md              # (Story 3.4)
│   │   ├── makepeace.md            # (Story 3.4)
│   │   ├── collier.md              # (Story 3.4)
│   │   ├── ogilvy.md               # (Story 3.5)
│   │   ├── bernbach.md             # (Story 3.5)
│   │   ├── burnett.md              # (Story 3.5)
│   │   ├── abbott.md               # (Story 3.5, ou substituto via NFR6 gate)
│   │   └── bird.md                 # (Story 3.5, ou substituto via NFR6 gate)
│   └── commands/                   # slash commands (existe)
│       └── copy.md                 # entry point /copy (Story 4.1)
├── research/                       # 15 dossiers densos (criado nesta story; populado em Epics 1.7 + 2)
│   ├── halbert/                    # (Story 1.7 — referência primeira)
│   │   ├── biografia.md            # ≥800 palavras
│   │   ├── estilo.md               # ≥800 palavras
│   │   ├── frameworks.md           # ≥800 palavras
│   │   └── exemplos.md             # ≥1100 palavras
│   ├── schwartz/                   # (Story 2.1)
│   ├── hopkins/                    # (Story 2.1)
│   ├── caples/                     # (Story 2.1)
│   ├── sugarman/                   # (Story 2.2)
│   ├── kennedy/                    # (Story 2.2)
│   ├── bencivenga/                 # (Story 2.2)
│   ├── carlton/                    # (Story 2.3)
│   ├── makepeace/                  # (Story 2.3)
│   ├── collier/                    # (Story 2.3)
│   ├── ogilvy/                     # (Story 2.4)
│   ├── bernbach/                   # (Story 2.4)
│   ├── burnett/                    # (Story 2.4)
│   ├── abbott/                     # (Story 2.5, ou substituto)
│   └── bird/                       # (Story 2.5, ou substituto)
├── docs/                           # documentação do projeto (existe parcialmente)
│   ├── prd.md                      # ✅ existe (Product Requirements Document v2.0.0-draft.9)
│   ├── architecture.md             # ✅ existe (Architecture Document v2.0.0-arch)
│   ├── stories/                    # ✅ existe — story files numerados
│   │   ├── 1.1.project-scaffolding.md   # esta story
│   │   ├── 1.2.*.md                # Story 1.2 e seguintes
│   │   └── ...
│   ├── e2e-simulation.md           # simulação E2E (Story 5.6)
│   └── architecture/               # decision artifacts (criado nesta story)
│       ├── folder-structure.md     # este arquivo
│       ├── routing-matrix.md       # projeto→squad (Story 4.4)
│       ├── roster-decisions.md     # substituições NFR6 (Story 1.7 skeleton)
│       ├── research-trail.md       # queries de pesquisa (Story 1.7 skeleton)
│       └── knowledge-base.md       # index dos _shared/
├── scripts/                        # validation scripts Node.js (criado nesta story)
│   ├── validate-density.js         # NFR1 + NFR2 validation (Story 1.2)
│   ├── validate-structure.js       # YAML frontmatter + tools whitelist (Story 1.3)
│   └── validate-research-format.js # DEC-002 sources schema (Story 1.4)
├── tests/                          # test fixtures e BATS suites (criado nesta story)
│   ├── fixtures/                   # fixtures para validation scripts (Story 1.2-1.4)
│   └── install/                    # BATS tests para install/uninstall (Story 5.3)
│       ├── install.bats            # (Story 5.3)
│       └── uninstall.bats          # (Story 5.7)
├── .github/                        # CI/CD workflows (existe parcialmente)
│   └── workflows/
│       └── validate.yml            # 5 jobs paralelos (Story 1.4)
├── install-copy-squad.sh           # bash 3.2-compat installer (Story 5.1, 5.2)
├── uninstall-copy-squad.sh         # bash 3.2-compat uninstaller (Story 5.7)
├── package.json                    # ✅ criado nesta story (metadata + engine Node 20+)
├── CLAUDE.md                       # instructions per-project (Story 5.4)
├── COPY-SQUAD-README.md            # README humano (Story 5.5)
├── README.md                       # symlink/copy de COPY-SQUAD-README.md (Story 5.5)
├── CHANGELOG.md                    # Keep a Changelog format (Story 5.6)
├── LICENSE                         # MIT (Story 5.6)
├── .gitattributes                  # força LF + UTF-8 (Story 1.4)
├── .editorconfig                   # consistência cross-editor (Story 1.4)
└── .gitignore                      # ✅ existe (proteção .env, node_modules, .claude/settings.local.json)
```

---

## Por pasta/arquivo top-level

- **`.claude/agents/`** — 18 subagents do Copy Squad (15 copywriters + Copy Master + Researcher + Reviewer). Adicionados em Epics 3 e 4.
- **`.claude/agents/_shared/`** — knowledge base referenciada por todos os agentes (frameworks, glossário). Adicionada em Stories 1.5 e 1.6.
- **`research/{nome}/`** — dossiers densos de 4 arquivos por copywriter (≥3.500 palavras agregadas). Adicionados em Stories 1.7 e 2.1-2.5.
- **`docs/`** — PRD, Architecture, stories, decision artifacts.
- **`docs/stories/`** — story files numerados `{epic}.{story}.{slug}.md` no fluxo SDC.
- **`docs/architecture/`** — decision artifacts e registries (folder-structure, routing-matrix, roster-decisions, research-trail).
- **`scripts/`** — validation scripts em Node.js (validate-density, validate-structure, validate-research-format). Adicionados em Stories 1.2-1.4.
- **`tests/install/`** — BATS tests para install/uninstall scripts. Adicionados em Stories 5.3 e 5.7.
- **`.github/workflows/`** — GitHub Actions CI workflows. Adicionado em Story 1.4.
- **`install-copy-squad.sh`** — bash 3.2-compat installer. Adicionado em Stories 5.1 e 5.2.
- **`uninstall-copy-squad.sh`** — bash 3.2-compat uninstaller. Adicionado em Story 5.7.
- **`package.json`** — metadata do projeto, declarando engine Node 20+ e (futuramente) `js-yaml@^4.1.0`.
- **`CLAUDE.md`** — instructions para Claude Code do projeto sobre como invocar o squad. Adicionado em Story 5.4.
- **`COPY-SQUAD-README.md`** — documentação humana do squad. Adicionado em Story 5.5.
- **`CHANGELOG.md`** — log de versões em formato Keep a Changelog. Adicionado em Story 5.6.
- **`LICENSE`** — MIT License. Adicionado em Story 5.6.
- **`.gitattributes`** — força LF line endings cross-platform. Adicionado em Story 1.4.
- **`.editorconfig`** — convenções de editor (UTF-8, LF, 2-space indent). Adicionado em Story 1.4.

---

## Status atual (após Story 1.1)

| Pasta/Arquivo | Status | Story |
|---------------|--------|-------|
| `.claude/` | ✅ existe (parcial — AIOX) | — |
| `.claude/agents/_shared/` | ✅ criado vazio | **1.1 (esta story)** |
| `research/` | ✅ criado vazio | **1.1 (esta story)** |
| `scripts/` | ✅ criado vazio | **1.1 (esta story)** |
| `tests/install/` | ✅ criado vazio | **1.1 (esta story)** |
| `docs/architecture/` | ✅ criado | **1.1 (esta story)** |
| `package.json` | ✅ criado mínimo | **1.1 (esta story)** |
| `docs/architecture/folder-structure.md` | ✅ este arquivo | **1.1 (esta story)** |
| `docs/prd.md` | ✅ existe | (commit `d030554`) |
| `docs/architecture.md` | ✅ existe | (commit `9156124`) |
| `.gitignore` | ✅ existe | (commit `141f5fe`) |
| Demais arquivos da tree acima | ❌ pendente | conforme stories futuras |

---

## Cross-references

- Folder structure detalhada (com schemas YAML, formatos de arquivo): [`docs/architecture.md#3.1`](../architecture.md#31-folder-structure-canônica)
- Convenções de naming: [`docs/architecture.md#8.6`](../architecture.md#86-naming-conventions)
- Schema YAML frontmatter de agentes: [`docs/architecture.md#3.2`](../architecture.md#32-agent-file-format-yaml-frontmatter--markdown-body)
- Schema research dossier: [`docs/architecture.md#3.3`](../architecture.md#33-research-dossier-file-format)
- Schema sources DEC-002: [`docs/architecture.md#3.4`](../architecture.md#34-dec-002--resolução-schema-de-fontes)
