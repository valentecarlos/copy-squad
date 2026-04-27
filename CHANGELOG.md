# Changelog

All notable changes to **Copy Squad** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-04-27

### 🎯 First production release — Squad 15+3 agents complete

Copy Squad v2.0.0 entrega o sistema completo de **18 subagentes Claude Code** (15 copywriters lendários + 3 support) com **research foundation 100% validada** + **camada de orquestração operacional** + **distribuição via install script**.

### Added

#### Epic 1 — Scaffolding & Validation
- **FR1** Project scaffolding com validation pipeline (Story 1.1)
- **NFR2** `validate-density.js` — checa NFR1 (agent body ≥600 words) + NFR2 (research dirs ≥3500 words) (Story 1.2)
- **FR1** `validate-structure.js` — checa YAML frontmatter dos agents (required fields + tools whitelist + research_path FR5 + name unique) (Story 1.3)
- **CI/CD** GitHub Actions workflow validating 4 jobs paralelos: structure + density + research-format + encoding (Story 1.4)
- **FR5** `_shared/frameworks.md` — knowledge base compartilhada com 8 frameworks (AIDA, PAS, 4 U's, Schwartz Awareness, Schwartz Sophistication, Sugarman Slippery Slide, Burnett Inherent Drama, Hopkins Reason-Why) (Story 1.5)
- **NFR9** `_shared/glossario.md` — 41 termos canônicos PT-BR (Story 1.6)
- **FR2** Halbert dossier complete (5.361 words, 4 arquivos) — primeiro dossier validado, template para Epic 2 (Story 1.7)

#### Epic 2 — Research Foundation (15 dossiers)
- **FR3** Lote 1 — Schwartz/Hopkins/Caples dossiers (Story 2.1, 13.115 words +25%)
- **FR3** Lote 2 — Sugarman/Kennedy/Bencivenga dossiers (Story 2.2, 15.378 words +46%)
- **FR3** Lote 3 — Carlton/Makepeace/Collier dossiers (Story 2.3, 17.377 words +65%)
- **FR3** Lote 4 — Ogilvy/Bernbach/Burnett dossiers (Story 2.4, 18.789 words +79%)
- **FR3** Lote 5 — Abbott/Bird dossiers (Story 2.5, 12.005 words +71%)
- **NFR5** `validate-research-format.js` — DEC-002 schema enforcement (≥3 fontes por arquivo, formato literal) com 60/60 arquivos PASS
- **Total Epic 2**: ~82.000 words em 60 arquivos research validados via CI; 250+ fontes únicas documentadas em `research-trail.md`
- **NFR6 substitution gate**: NOT activated — Abbott + Bird passaram density target (substitutos pré-aprovados Resor/Reeves/Wells Lawrence/Gossage/Sackheim remain unused per design)

#### Epic 3 — 15 Copywriter Agents
- **FR4** Halbert agent (Story 3.1, 1.051 words body) — template reference para os outros 14
- **FR4** DR clássico — Schwartz/Hopkins/Caples agents (Story 3.2, 2.947 words body +64%)
- **FR4** DR moderno — Sugarman/Kennedy/Bencivenga agents (Story 3.3, 2.826 words body +57%)
- **FR4** DR completion — Carlton/Makepeace/Collier agents (Story 3.4, 3.265 words body +81%)
- **FR4** Brand — Ogilvy/Bernbach/Burnett/Abbott/Bird agents (Story 3.5, 5.716 words body +91%)
- **NFR1**: Todos 15 copywriter agents ≥600 words body (todos +56% a +112% acima do mínimo)
- **NFR4 lazy-load**: Cada agent referencia `research/{nome}/` com Tool Read sob demanda
- **NFR7 bounded scope**: Tools whitelist `[Read, Grep]` (terminal subagents, anti-recursion)

#### Epic 4 — Orchestration Layer
- **FR9** `/copy` slash command — entry point primário (Story 4.1, 693 words)
- **FR11** `copy-researcher` agent — pesquisa avatar/mercado, output 7 seções (Story 4.2, 1.055 words)
- **FR12** `copy-reviewer` agent — quality pass 9-itens checklist + score 0-100 (Story 4.3, 1.207 words)
- **FR15** `routing-matrix.md` — 14 arquétipos cobrindo 8 verticais obrigatórios + 6 bonus (Story 4.4)
- **FR10/FR13/FR14** `copy-master` orchestrator — workflow 6 passos, agent mais denso do squad (Story 4.5, 1.496 words)
- **DEC-001 single-level orchestration**: Apenas Copy Master tem Tool **Agent**; subagents são terminal (anti-recursion)

#### Epic 5 — Portability, Documentation & E2E
- **FR8** `install-copy-squad.sh` core — install em path específico ou `--user` global (Story 5.1)
- **NFR3** Install script flags `--force` (backup automático) + `--dry-run` + `--help` + exit codes documentados 0/1/2/3 (Story 5.2)
- **CI/CD** BATS test suite 10 cases cobrindo 7 PRD obrigatórios + 3 bonus, integrado em GitHub Actions (Story 5.3)
- **FR8** `CLAUDE.md` project instructions para Claude Code (Story 5.4, 1.026 words)
- **FR8** `COPY-SQUAD-README.md` human docs com hero + install + squad table + routing + exemplo E2E + FAQ (Story 5.5, 2.250 words)
- **NFR8** macOS bash + zsh compatibility validated; bash 3.2 compat preserved
- **CHANGELOG.md** + **LICENSE (MIT)** + **E2E simulation** documentada + **git tag v2.0.0** (Story 5.6)
- **FR8** `uninstall-copy-squad.sh` com lista hardcoded + backup automático (Story 5.7)

### Quality Stats
- **18 agents** validados via CI (15 copywriters + 3 support)
- **60 research files** validados (DEC-002 schema, ≥3 fontes cada)
- **17 dossiers** density PASS (15 + 2 _shared)
- **35 density checks** PASS (research dirs + agents + shared)
- **5 CI jobs paralelos** verde: structure + density + research-format + encoding + BATS install
- **~82.000 words** research foundation
- **~17.300 words** agents body
- **~99.300 words** acumulados em produção (research + agents + commands)

### NFRs delivered
- **NFR1** Density agents ≥600w PASS (todos com folga ≥56%)
- **NFR2** Density research ≥3500w PASS (todos com folga ≥19%)
- **NFR3** Install idempotent + auto-backup + dry-run + --force enforcement
- **NFR4** Lazy-load research (Tool Read sob demanda)
- **NFR5** ≥3 fontes per research file (DEC-002 schema)
- **NFR6** Substitution gate available (não acionado — não foi necessário)
- **NFR7** Bounded tool authorization (whitelist por tipo)
- **NFR8** macOS/Linux/WSL compatibility (bash + zsh)
- **NFR9** PT-BR default em todos agents + docs

### Architecture Decisions Records
- **DEC-001**: Single-level orchestration (Copy Master invoca diretos; subagents terminal)
- **DEC-002**: Markdown numbered list para sources schema em research files
- **DEC-003**: YAML frontmatter schema canônico para agents

### Notes
- **Out of scope v2.0.0** (aceitos per PRD §2.3): Web UI/dashboard, LLM evals quantitativos automatizados, integrações externas (Mailchimp/Meta/Google APIs), multi-language além PT-BR/EN, suporte a outros LLMs além Claude, marketplace de copywriters customizados, telemetria, versionamento de prompts por usuário.

### Future Enhancements (v2.1+)
- v2.1: `/copy update {nome}` (FR16 promovido), CI mais robusto com lint markdown, dashboard estático GitHub Pages
- v2.2: LLM evals leves (consistência de voz por copywriter, regression de qualidade)
- v2.3: Pacote npm distribuído (`npm install -g @valentecarlos/copy-squad`)
- v3.0: Marketplace de copywriters customizados, multi-LLM support, native plataform integrations

---

## Links

- [Repo](https://github.com/valentecarlos/copy-squad)
- [README](./COPY-SQUAD-README.md)
- [PRD](./docs/prd.md)
- [Architecture](./docs/architecture.md)
