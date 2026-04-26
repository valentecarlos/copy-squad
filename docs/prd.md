# Copy Squad v2 Product Requirements Document (PRD)

> **Version:** 2.0.0 (draft)
> **Status:** In progress — Section 1 ratified
> **Owner:** @pm (Morgan)
> **Last Updated:** 2026-04-26

---

## 1. Goals and Background Context

### Goals

- Disponibilizar um **squad de 15 copywriters lendários** como subagentes Claude Code, cada um com voz autêntica baseada em pesquisa profunda real (não conhecimento genérico).
- Centralizar o ponto de entrada via **Copy Master orquestrador**, que conduz briefing, roteia tarefas e sintetiza entrega final.
- Reduzir o tempo de produção de copy de alta qualidade (sales page, VSL, anúncios pagos, e-mail sequence) de **dias para horas**, mantendo padrão direct-response/brand reconhecível por especialista.
- Garantir **portabilidade total**: o squad instala em qualquer projeto Claude Code com 1 comando ou globalmente em `~/.claude/`.
- Estabelecer um **sistema de pesquisa profunda versionada** (`research/{copywriter}/`) que serve como base obrigatória para cada agente antes de escrever qualquer linha.
- Entregar copy em **português brasileiro nativo** por padrão, com capacidade de inglês on-demand.

### Background Context

O mercado brasileiro de copywriting digital sofre de uma assimetria: técnicas refinadas por décadas em direct response (Halbert, Schwartz, Sugarman) e brand (Ogilvy, Bernbach, Burnett) raramente são aplicadas com fidelidade. O resultado é copy genérica, traduzida ou diluída por "guru wisdom" de segunda mão. Ao mesmo tempo, sistemas de IA atuais para copy operam com instruções superficiais ("escreva como Halbert") sem material de referência real, produzindo pastiche sem alma.

Copy Squad v2 ataca os dois problemas simultaneamente: cada agente carrega **dossiê próprio** (biografia, estilo, frameworks, peças canônicas com trechos) montado via WebSearch/WebFetch antes da execução, e o orquestrador escolhe o squad ideal por tipo de projeto (sales page longa, VSL, headlines, brand storytelling, e-mail sequence). A v1 (já desinstalada e nukada) provou o conceito mas falhou em densidade de pesquisa e na ausência de Researcher/Reviewer. A v2 corrige esses gaps.

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-04-26 | 2.0.0-draft.1 | Draft inicial — Section 1 (Goals & Background) ratificada | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.2 | Section 2 (Requirements) ratificada — 16 FR + 9 NFR | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.3 | Section 3 (UI Goals) skipped por não aplicar a sistema CLI/agent | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.4 | Section 4 (Technical Assumptions) ratificada | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.5 | Section 5 (Epic List) ratificada — 5 epics sequenciais | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.6 | Section 6 (Epic Details) ratificada — 28 stories com ACs | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.7 | Section 7 (pm-checklist) executada + gaps HIGH corrigidos inline | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.8 | Section 8 (Next Steps) preenchida — PRD finalizado | @pm (Morgan) |
| 2026-04-26 | 2.0.0-draft.9 | Reconciliation pós-Architecture: Story 5.7 (uninstall) adicionada à Section 6 Epic 5 (per ADR-015); total stories: 28 → 29 | @po (Pax) |

---

## 2. Requirements

### Roster oficial dos 15 copywriters

> **Direct Response (10):** Gary Halbert, Eugene Schwartz, Claude Hopkins, John Caples, Joe Sugarman, Dan Kennedy, Gary Bencivenga, John Carlton, Clayton Makepeace, Robert Collier
>
> **Brand / Big Idea (5):** David Ogilvy, Bill Bernbach, Leo Burnett, David Abbott, Drayton Bird
>
> **Substitutos pré-aprovados** (caso pesquisa de Abbott/Bird seja considerada rasa pelo critério NFR2): Helen Lansdowne Resor, Rosser Reeves, Mary Wells Lawrence, Howard Gossage, Maxwell Sackheim.

### 2.1 Functional Requirements (FR)

- **FR1 [P0]:** O sistema deve disponibilizar **15 subagentes copywriters individuais** em `.claude/agents/`, cada um com voz, frameworks e peças de referência próprias baseadas em pesquisa real.
- **FR2 [P0]:** Cada agente copywriter deve ter **system prompt com identidade, voz, frameworks, peças de referência e regras duras** referenciando explicitamente arquivos de pesquisa em `research/{nome}/`.
- **FR3 [P0]:** O **Copy Master orquestrador** (`.claude/agents/copy-master.md`) deve receber demanda, conduzir briefing inteligente (sem perguntas óbvias), rotear para 2-4 copywriters do squad, sintetizar entregável final.
- **FR4 [P0]:** O Copy Master **nunca escreve copy direto** — apenas orquestra. Sempre invoca um copywriter do squad para qualquer ato de redação.
- **FR5 [P0]:** Cada copywriter deve **ler `research/{nome}/` inteiro antes** de produzir qualquer output (biografia, estilo, frameworks, exemplos).
- **FR6 [P0]:** O sistema deve incluir **dossiê de pesquisa por copywriter** em 4 arquivos densos (`biografia.md`, `estilo.md`, `frameworks.md`, `exemplos.md`) — equivalente a 8-15 páginas de conteúdo por copywriter.
- **FR7 [P0]:** Slash command **`/copy`** (`.claude/commands/copy.md`) deve servir como ponto único de entrada para invocar o Copy Master.
- **FR8 [P0]:** O sistema deve incluir **install script (`install-copy-squad.sh`)** que copia toda a estrutura `.claude/` + `research/` para qualquer projeto destino, com flag `--force` (sobrescreve com backup), `--user` (instala em `~/.claude/` global) e `--dry-run` (mostra o que faria sem aplicar).
- **FR9 [P0]:** Toda copy entregue deve ser em **português brasileiro nativo** por padrão (zero cara de tradução), com capacidade de inglês quando explicitamente solicitado.
- **FR10 [P0]:** Documentos compartilhados em **`.claude/agents/_shared/`** — `frameworks.md` (AIDA, PAS, 4 U's, 5 estágios de consciência de Schwartz, slippery slide de Sugarman, etc.) e `glossario.md` (gatilhos, big idea, lead, kicker, USP) — referenciados por todos os agentes.
- **FR11 [P1]:** **Copy Researcher agent** (`.claude/agents/copy-researcher.md`) — especialista em pesquisa de avatar, linguagem nativa, concorrência e gatilhos emocionais; produz dossiê estruturado pronto para alimentar copywriters.
- **FR12 [P1]:** **Copy Reviewer agent** (`.claude/agents/copy-reviewer.md`) — passe técnico final com checklist obrigatório (4 U's no headline, blink test no lead, prova ancorada, top-3 objeções, CTA único, PT-BR natural, compliance básico) e score 0-100.
- **FR13 [P1]:** Copy Master deve gerar **revisão cruzada** — 1-2 copywriters como reviewers críticos cada um pelo seu ângulo (Bencivenga = credibilidade, Sugarman = fluidez, Kennedy = CTA).
- **FR14 [P1]:** Entrega final deve incluir **versão final + 3-5 variações alternativas** (de headline/lead/CTA) + **sugestões de teste A/B priorizadas** + nota de quem do squad atuou em cada etapa.
- **FR15 [P1]:** Sistema de **roteamento por tipo de projeto** (matriz de matching projeto→squad documentada): sales page longa, VSL de lançamento, headlines, brand storytelling, e-mail sequence, anúncios Meta/Google Ads, carta de renovação, info-produto premium.
- **FR16 [P2]:** Comando de **atualização de pesquisa** (ex: `/copy update {nome}`) que re-roda WebSearch/WebFetch para um copywriter específico e re-popula `research/{nome}/`.

### 2.2 Non-Functional Requirements (NFR)

- **NFR1 [P0] usability:** System prompt de cada copywriter deve ter **densidade ≥ 600 palavras** (não stub).
- **NFR2 [P0] reliability:** Pasta `research/{nome}/` deve totalizar **equivalente a 8-15 páginas densas** (≥ ~3.500 palavras). Pesquisa que cabe em 3 parágrafos é considerada falha.
- **NFR3 [P0] reliability:** Install script deve ser **idempotente** (rodar 2x não corrompe), com **backup automático** em `.claude.backup-{timestamp}/` quando sobrescreve, validação que não permite overwrite sem `--force`, e suporte a **`--dry-run`** que reporta o que seria modificado sem alterar nada.
- **NFR4 [P1] performance:** Agentes devem fazer **lazy-load** dos arquivos de pesquisa (só leem quando invocados, não no startup), para evitar custo de contexto desnecessário.
- **NFR5 [P1] usability:** Pesquisa profunda usa **WebSearch + WebFetch agressivamente**, com mínimo de **3 fontes distintas por copywriter** (não confiar em uma única página da Wikipedia).
- **NFR6 [P1] reliability:** Se a pesquisa de um copywriter for considerada rasa pelo critério da NFR2, o sistema deve **avisar e sugerir substituto** dentre os pré-aprovados (Resor, Reeves, Wells Lawrence, Gossage, Sackheim).
- **NFR7 [P1] security:** Agentes copywriters operam **bounded** ao contexto da tarefa + `research/` — não exfiltram credenciais, não alteram arquivos fora do escopo da entrega.
- **NFR8 [P2] usability:** Compatibilidade primária em **macOS**; Linux e Windows como secundários — install script funciona em `bash`/`zsh` e WSL.
- **NFR9 [P0] usability:** Idioma de operação dos agentes (system prompts, comentários internos, mensagens) e idioma default das entregas é **português brasileiro**. Inglês é capability on-demand, não default.

### 2.3 Out of Scope (v2.0.0)

Explicitamente **fora** do MVP v2.0.0 — não implementar nesta versão:

- **Web UI / dashboard** — Copy Squad é CLI/agent system; nenhuma interface gráfica.
- **LLM evals quantitativos automatizados** — qualidade dos prompts validada via review humano + score do Reviewer; benchmarks formais ficam para v2.1+.
- **Integração com plataformas de e-mail/anúncios** (Mailchimp, Meta Ads, Google Ads APIs) — entrega é texto markdown; integração com ferramentas externas é manual no MVP.
- **Multi-language além de PT-BR + EN** — espanhol, francês e outros idiomas ficam para v2.x.
- **Suporte a outros LLMs** (GPT, Gemini, Llama) — Copy Squad é Claude Code-only por design.
- **Marketplace de copywriters customizados** — usuários criando seus próprios copywriters fica para v3.0.
- **Telemetria / analytics de uso** — sistema é stateless; sem coleta de dados.
- **Versionamento de prompts por usuário** — agentes são imutáveis a menos que o usuário fork; sem layer de personalização runtime.

### 2.4 Future Enhancements (v2.1+)

Roadmap pós-v2.0.0 (não compromisso, apenas direção):

- **v2.1** — `/copy update {nome}` (FR16 promovido), CI mais robusto com lint de markdown, dashboard estático em GitHub Pages com lista do squad.
- **v2.2** — LLM evals leves (consistência de voz por copywriter, regression de qualidade quando research é atualizada).
- **v2.3** — Pacote npm distribuído via `npm install -g @valentecarlos/copy-squad` como alternativa ao install script bash.
- **v3.0 (visão de longo prazo)** — Marketplace de copywriters customizados, suporte a múltiplos LLMs, integração nativa com plataformas de e-mail/anúncios.

---

## 3. User Interface Design Goals

> **SKIPPED.** Copy Squad v2 é um sistema de subagentes Claude Code operado via CLI (slash command `/copy` + invocação direta de agentes) e arquivos markdown. Não há interface gráfica, não há telas, não há fluxos UX visuais. Diretrizes de comunicação dos agentes (tom, formato de output) estão capturadas em FRs (FR9, FR14) e NFRs (NFR9), e serão detalhadas na fase de implementação por agente.

---

## 4. Technical Assumptions

### 4.1 Repository Structure: Monorepo único

Repositório: `github.com/valentecarlos/copy-squad`. Único repositório contendo:

- `.claude/` — agentes, commands, skills (consumido pelo Claude Code)
- `research/` — 15 dossiês de pesquisa por copywriter (4 arquivos densos cada)
- `docs/` — PRD, stories, architecture, READMEs internos
- `install-copy-squad.sh` — instalador portável (raiz)
- `CLAUDE.md`, `COPY-SQUAD-README.md` — documentação humana

**Justificativa:** o squad é distribuído como unidade atômica. Monorepo simplifica versionamento (uma tag = um snapshot consistente de prompts + research + install). Polyrepo seria overkill para 30-40 arquivos markdown + 1 script bash.

### 4.2 System Architecture: Plugin-based Agent System (file-based, stateless)

> Adaptação da seção do template — Copy Squad v2 não tem backend de serviço.

- **Runtime:** Claude Code (Anthropic CLI) — não é serviço, não tem backend, não tem banco de dados.
- **Padrão:** Subagentes Claude Code com YAML frontmatter (`name`, `description`, `tools`) + corpo markdown como system prompt.
- **Persistência:** Apenas filesystem (`.claude/agents/*.md`, `research/{nome}/*.md`). Sem state, sem cache, sem DB.
- **Ferramentas externas:** WebSearch + WebFetch (Anthropic Tool API) durante fase de pesquisa profunda. Nenhuma API externa em runtime de produção.
- **Composição:** Copy Master invoca outros agentes via Tool `Agent` do Claude Code (subagent pattern oficial).

**CRITICAL DECISION:** sistema é **stateless por design**. Toda "memória" vive em arquivos versionados em git. Isso simplifica portabilidade (FR8/NFR3) e auditabilidade (todo prompt e dossiê é diff-eável).

### 4.3 Testing Requirements: Pirâmide adaptada

Sem unit tests de prompts (prompts são string, não código). Estratégia em 5 camadas:

| Camada | O que testa | Como |
|--------|-------------|------|
| **Validação estrutural** | YAML frontmatter de cada agente (campos obrigatórios, tools válidas, nomes únicos) | Script Node.js |
| **Validação de densidade** | NFR1 (≥600 palavras por system prompt) + NFR2 (≥3.500 palavras por `research/{nome}/`) | Script Node.js (rodando contra todos os arquivos) |
| **Install script** | Idempotência, dry-run, --force com backup, --user, falha graceful sem --force | Bash test suite (BATS ou shell test) — alvo: macOS + Linux + WSL |
| **Manual review** | Voz, tom, fidelidade às fontes, qualidade da pesquisa | Review humano (você + checklist do Reviewer agent) |
| **E2E simulation** | Squad orquestra ponta-a-ponta com briefing fictício | Snapshot test: capturar output de demanda padrão e diff em PRs |

**OUT OF SCOPE (v2.0):** LLM evals quantitativos automatizados (entram em v2.1+).

### 4.4 Additional Technical Assumptions and Requests

- **Linguagens:** Markdown (conteúdo) + YAML (frontmatter) + **Bash puro** (install script — zero dependências) + **Node.js** (validação estrutural e de densidade — já presente via AIOX).
- **Formato de agente:** padrão oficial Anthropic — frontmatter com `name`, `description`, `tools`; body com system prompt.
- **Slash command:** padrão oficial — arquivo em `.claude/commands/copy.md` com prompt template.
- **Versionamento:** semver (`v2.0.0`, `v2.1.0`). Tags git anotadas. Release notes em `CHANGELOG.md`.
- **CI/CD:** GitHub Actions com workflow único executando **validação estrutural + densidade** em todo PR contra `main`. Incluído no MVP como P1.
- **Distribuição:**
  - **Primária:** curl one-liner — `curl -fsSL https://raw.githubusercontent.com/valentecarlos/copy-squad/main/install-copy-squad.sh | bash` — adoção rápida, modelo da v1.
  - **Alternativa:** `git clone https://github.com/valentecarlos/copy-squad.git && cd copy-squad && bash install-copy-squad.sh` — mesma funcionalidade, sem executar script remoto.
  - Ambos os fluxos suportados pelo mesmo `install-copy-squad.sh`. README documenta as duas opções.
- **Modelo Anthropic:** sistema é **agnóstico de modelo** — funciona com qualquer modelo Claude que o usuário tenha configurado no Claude Code. Sem fixação ou recomendação rígida.
- **Encoding:** UTF-8 obrigatório em todos os arquivos (markdown, YAML, bash). Acentos e diacríticos PT-BR preservados.

---

## 5. Epic List

5 epics sequenciais. Cada epic entrega bloco end-to-end testável. Pesquisa (Epic 1+2) precede agentes (Epic 3) que precedem orquestração (Epic 4) que precede distribuição (Epic 5).

### Epic 1: Foundation & Research Infrastructure
> Estabelecer estrutura base do repo, scaffolding dos agentes, sistema de pesquisa e validação automática — entregando como funcionalidade testável o **dossiê completo do primeiro copywriter (Halbert)** + **CI workflow validando densidade**.

### Epic 2: 15 Copywriter Research Dossiers
> Pesquisa profunda dos 14 copywriters restantes em **5 lotes de 3 sequenciais** (Schwartz/Hopkins/Caples → Sugarman/Kennedy/Bencivenga → Carlton/Makepeace/Collier → Ogilvy/Bernbach/Burnett → Abbott/Bird/+1) — cada dossier passando pela pipeline de validação da Epic 1.

### Epic 3: Copywriter Subagents (15 individual agents)
> Criar os 15 subagentes copywriters em `.claude/agents/{nome}.md`, cada um com system prompt ≥600 palavras (NFR1) referenciando explicitamente os arquivos de pesquisa da Epic 2.

### Epic 4: Copy Master + Researcher + Reviewer
> Implementar os 3 agentes de orquestração: Copy Master (orquestrador puro, FR3+FR4), Copy Researcher (FR11), Copy Reviewer (checklist + score 0-100, FR12). Inclui matriz de roteamento (FR15), revisão cruzada (FR13) e slash command `/copy` (FR7).

### Epic 5: Portability, Documentation & E2E Validation
> Install script (FR8/NFR3), uninstall script (Story 5.7 promovida via ADR-015), documentação humana, simulação E2E end-to-end e release `v2.0.0`.

---

## 6. Epic Details

> **Total:** 29 stories. Cada story dimensionada para single Claude Code session (junior dev em 2-4h). ACs verificáveis (passa ou falha — sem ambiguidade).

---

### Epic 1: Foundation & Research Infrastructure

**Goal expandido:** estabelecer a fundação técnica do projeto (estrutura de pastas, scripts de validação, CI workflow) e provar a pipeline ponta-a-ponta com o **primeiro dossier (Halbert) validado**. Após esse epic, qualquer dossier ou agente futuro tem rota clara de produção e gates automáticos. Sem essa fundação, o restante do projeto vira improviso sem rede de segurança.

#### Story 1.1: Project scaffolding

As a developer,
I want estrutura de pastas e arquivos base criada no repositório,
so that os epics seguintes têm onde colocar agentes, pesquisa, scripts e testes sem decidir layout no meio do caminho.

**Acceptance Criteria:**
1. Pasta `research/` criada na raiz com `.gitkeep`
2. Pasta `.claude/agents/_shared/` criada com `.gitkeep`
3. Pasta `scripts/` criada com `.gitkeep`
4. Pasta `tests/install/` criada com `.gitkeep`
5. Pasta `docs/architecture/` criada com `.gitkeep`
6. `package.json` mínimo na raiz declarando `name`, `version: 2.0.0-draft.1`, `private: true`, sem dependências obrigatórias
7. `docs/architecture/folder-structure.md` documenta a árvore final esperada com 1 linha por pasta explicando propósito
8. Commit único contém todas as criações; CI ainda não roda nada (próximas stories habilitam)

#### Story 1.2: Density validation script

As a maintainer,
I want script `scripts/validate-density.js` que conta palavras de prompts e dossiers,
so that NFR1 (≥600 palavras por system prompt) e NFR2 (≥3500 palavras por dossier) sejam aplicados automaticamente em CI.

**Acceptance Criteria:**
1. Script executável via `node scripts/validate-density.js`
2. Lê todos `.claude/agents/*.md` e `.claude/agents/_shared/*.md`, conta palavras do body (excluindo YAML frontmatter)
3. Lê todos `research/{nome}/*.md`, soma palavras por dossier (4 arquivos por copywriter)
4. Falha com exit code 1 se qualquer system prompt < 600 palavras; mensagem clara aponta arquivo
5. Falha com exit code 1 se qualquer dossier < 3500 palavras; mensagem aponta dossier e contagem atual
6. Output em tabela markdown legível: arquivo, palavras, status (PASS/FAIL/WARN)
7. Suporta flag `--report-only` (sem exit 1, só relatório) para inspeção local
8. Roda contra fixture de teste em `tests/fixtures/density/` — fixtures incluem caso PASS e caso FAIL

#### Story 1.3: Structure validation script

As a maintainer,
I want script `scripts/validate-structure.js` que valida YAML frontmatter dos agentes,
so that erros estruturais (campos faltando, names duplicados, tools inválidas) sejam pegos antes do merge.

**Acceptance Criteria:**
1. Script executável via `node scripts/validate-structure.js`
2. Parsea YAML frontmatter de cada `.claude/agents/*.md`
3. Valida campos obrigatórios presentes: `name`, `description`, `tools`
4. Valida `name` único entre todos os agentes
5. Valida `tools` contém apenas tools válidas (whitelist documentada: Read, Write, Grep, Glob, WebSearch, WebFetch, Bash, Edit, Agent)
6. Valida que cada agente referencia pelo menos 1 vez `research/{name}/` no body (FR5)
7. Falha com exit 1 em qualquer violação; mensagem aponta arquivo + violação específica
8. Roda contra fixtures de teste cobrindo: agente válido, agente sem `name`, agente com `tools` inválida, agente sem ref a research/

#### Story 1.4: GitHub Actions workflow

As a maintainer,
I want CI workflow `.github/workflows/validate.yml` rodando os scripts em todo PR,
so that nenhum PR mergea com agente ou dossier abaixo dos critérios.

**Acceptance Criteria:**
1. Arquivo `.github/workflows/validate.yml` criado
2. Trigger: `pull_request` contra `main` + `push` em qualquer branch
3. Job `validate` executa em `ubuntu-latest`
4. Setup Node.js 20+, npm ci se houver dependências
5. Roda `node scripts/validate-density.js` (sem `--report-only`)
6. Roda `node scripts/validate-structure.js`
7. Workflow obrigatório (status check) configurado em GitHub branch protection — bloqueia merge se falhar
8. Workflow do próprio PR que cria o arquivo passa em verde (rodando contra fixtures, ainda sem agentes reais)

#### Story 1.5: Shared frameworks knowledge base

As a copywriter agent,
I want documento `_shared/frameworks.md` com frameworks consolidados de copywriting,
so that eu (e os outros 14 copywriters) possa referenciá-lo sem duplicar conteúdo.

**Acceptance Criteria:**
1. Arquivo `.claude/agents/_shared/frameworks.md` criado
2. Cobre 8 frameworks com explicação ≥3 parágrafos cada: AIDA, PAS, 4 U's (Útil/Urgente/Único/Ultraespecífico), 5 estágios de consciência (Schwartz), 5 níveis de sofisticação de mercado (Schwartz), slippery slide (Sugarman), inherent drama (Burnett), reason-why (Hopkins)
3. Cada framework: definição + quando usar + exemplo concreto + atribuição ao copywriter de origem
4. Total ≥ 2500 palavras (denso, não stub)
5. Sumário/index navegável no topo
6. Linguagem PT-BR, terminologia técnica preservada
7. Linkado de `docs/architecture/knowledge-base.md` para descoberta

#### Story 1.6: Shared glossary

As a copywriter agent,
I want documento `_shared/glossario.md` com termos canônicos PT-BR,
so that o squad use vocabulário consistente em todas as entregas (não traduzir "lead" como "líder", etc.).

**Acceptance Criteria:**
1. Arquivo `.claude/agents/_shared/glossario.md` criado
2. ≥30 termos: big idea, lead, kicker, USP, headline, subhead, hook, gatilhos psicológicos (escassez, prova social, autoridade, reciprocidade, compromisso, afinidade), garantia (incondicional/condicional), urgência, escassez, oferta, stack de bônus, CTA, P.S., closer, features, benefits, advertorial, controle, swipe file, magnetic copy
3. Cada termo: definição PT-BR (1-2 frases) + sinônimos comuns + uso típico em copy
4. Total ≥ 2000 palavras
5. Ordenação alfabética
6. Cross-references entre termos relacionados (ex: "headline → ver subhead, hook")
7. Linguagem PT-BR

#### Story 1.7: Halbert dossier (reference)

As a developer,
I want o primeiro dossier completo (Halbert) produzido e validado,
so that a pipeline da Epic 1 seja provada ponta-a-ponta antes de escalar para 14 dossiers.

**Acceptance Criteria:**
1. `research/halbert/biografia.md`: anos de atuação, agências, clientes principais, mercados onde brilhou, marcos. ≥800 palavras
2. `research/halbert/estilo.md`: marcadores estilísticos (frase curta, parágrafos de 1 linha), tom emocional, ritmo, pontuação, o que evita. ≥800 palavras
3. `research/halbert/frameworks.md`: estruturas que ele criou/popularizou (Boron Letters principles, AIDA aplicada, A-pile/B-pile thinking). ≥800 palavras
4. `research/halbert/exemplos.md`: 3-5 peças canônicas com texto/trechos longos + análise (Coat-of-Arms Letter, Tova Borgnine, Nutritional Supplements, Killer ad). ≥1100 palavras
5. Total agregado ≥ 3500 palavras (NFR2 PASS)
6. ≥3 fontes distintas pesquisadas via WebSearch+WebFetch, citadas em seção "Fontes" de cada arquivo
7. `validate-density` retorna PASS para `research/halbert/`
8. Pesquisa documenta o path de busca (queries usadas) em `docs/architecture/research-trail.md` para reprodutibilidade

---

### Epic 2: 15 Copywriter Research Dossiers

**Goal expandido:** produzir os 14 dossiers restantes em 5 lotes de ~3 copywriters cada. A pipeline da Epic 1 valida cada PR. Critério crítico (NFR6): se Abbott ou Bird falharem densidade após esforço razoável, sistema sugere e aceita substituto pré-aprovado, mantendo o roster final em exatos 15 copywriters.

#### Story 2.1: Lote 1 — Direct Response clássico

As a developer,
I want dossiers de Schwartz, Hopkins, Caples produzidos e validados,
so that os fundadores teóricos do direct response moderno estejam disponíveis para os agentes da Epic 3.

**Acceptance Criteria:**
1. `research/schwartz/{biografia,estilo,frameworks,exemplos}.md` criados — total ≥3500 palavras
2. `research/hopkins/{biografia,estilo,frameworks,exemplos}.md` criados — total ≥3500 palavras
3. `research/caples/{biografia,estilo,frameworks,exemplos}.md` criados — total ≥3500 palavras
4. `frameworks.md` cobre frameworks específicos: Schwartz (5 awareness levels, market sophistication), Hopkins (Scientific Advertising principles), Caples (35 headlines testadas, "Tested Advertising Methods")
5. `exemplos.md` inclui ≥3 peças canônicas por copywriter com trechos longos: Caples "They Laughed When I Sat Down at the Piano", Hopkins "Schlitz beer", Schwartz "Burton Pike Memory Course"
6. Validação `validate-density` PASS para os 3 dossiers
7. ≥3 fontes distintas por copywriter, documentadas em seção "Fontes"

#### Story 2.2: Lote 2 — Direct Response moderno

As a developer,
I want dossiers de Sugarman, Kennedy, Bencivenga produzidos e validados,
so that o squad cubra a evolução do direct response do meio do século XX até hoje.

**Acceptance Criteria:**
1. `research/sugarman/...` criado — total ≥3500 palavras (cobre Triggers, slippery slide, BluBlocker, copy conversacional)
2. `research/kennedy/...` criado — total ≥3500 palavras (cobre Magnetic Marketing, No B.S. philosophy, info-marketing)
3. `research/bencivenga/...` criado — total ≥3500 palavras (cobre Marketing Bullets, controles imbatíveis, "the man who outsold David Ogilvy")
4. Validação `validate-density` PASS para os 3 dossiers
5. ≥3 fontes distintas por copywriter
6. `exemplos.md` de Sugarman inclui ≥1 advertorial completo da JS&A; Kennedy ≥1 sales letter de info-produto; Bencivenga ≥1 Marketing Bullet famoso

#### Story 2.3: Lote 3 — Direct Response completion

As a developer,
I want dossiers de Carlton, Makepeace, Collier produzidos e validados,
so that os 10 copywriters de direct response do roster estejam completos.

**Acceptance Criteria:**
1. `research/carlton/...` criado — total ≥3500 palavras (cobre "The Most Ripped-Off Writer", ganchos brutais, sales letter style)
2. `research/makepeace/...` criado — total ≥3500 palavras (cobre direct response financeiro/saúde, emoção visceral)
3. `research/collier/...` criado — total ≥3500 palavras (cobre "The Robert Collier Letter Book", "entrar na conversa que já está na cabeça do leitor")
4. Validação `validate-density` PASS para os 3 dossiers
5. ≥3 fontes distintas por copywriter
6. `exemplos.md` cobre peças canônicas: Carlton "The Rant", Makepeace pacotes financeiros, Collier carta de coat hangers

#### Story 2.4: Lote 4 — Brand mainstream

As a developer,
I want dossiers de Ogilvy, Bernbach, Burnett produzidos e validados,
so that os 3 maiores nomes de brand advertising estejam disponíveis para projetos de posicionamento e big idea.

**Acceptance Criteria:**
1. `research/ogilvy/...` criado — total ≥3500 palavras (cobre Confessions of an Advertising Man, 38 perguntas, Hathaway Eyepatch, Rolls-Royce, Schweppes)
2. `research/bernbach/...` criado — total ≥3500 palavras (cobre DDB philosophy, "Think Small" Volkswagen, Avis "We Try Harder")
3. `research/burnett/...` criado — total ≥3500 palavras (cobre Marlboro Man, Tony the Tiger, Pillsbury Doughboy, "inherent drama")
4. Validação `validate-density` PASS
5. ≥3 fontes distintas por copywriter
6. `exemplos.md` inclui peças canônicas com imagens descritas em texto + copy completo quando disponível

#### Story 2.5: Lote 5 — Brand completion + substitution gate

As a developer,
I want dossiers de Abbott e Bird tentados e, se densidade falhar, substitutos pré-aprovados acionados,
so that o roster final seja exatos 15 copywriters todos com dossiers densos validados.

**Acceptance Criteria:**
1. `research/abbott/...` tentativa de produção — total ≥3500 palavras
2. `research/bird/...` tentativa de produção — total ≥3500 palavras
3. SE Abbott falhar densidade após 3 rodadas de pesquisa com ≥5 fontes, NFR6 aciona: substituto da lista (Resor, Reeves, Wells Lawrence, Gossage, Sackheim) é selecionado, dossier é refeito sob o substituto
4. SE Bird falhar idem; substituto diferente do de Abbott
5. Decisão de substituição (se houver) documentada em `docs/architecture/roster-decisions.md` com justificativa: queries tentadas, fontes encontradas, contagem final, escolha do substituto
6. Total roster final = exatamente 15 copywriters, todos com dossier validado
7. Validação `validate-density` PASS para os 2 dossiers finais

---

### Epic 3: Copywriter Subagents (15 individual agents)

**Goal expandido:** transformar os 15 dossiers em 15 subagentes Claude Code funcionais. Cada agente é um system prompt denso (≥600 palavras) que referencia explicitamente sua pasta `research/{nome}/`. Story 3.1 (Halbert) define o template; stories 3.2-3.5 replicam o padrão para os outros 14.

#### Story 3.1: Halbert agent (template reference)

As a copywriter user (Carlos),
I want um agente `halbert` invocável via @halbert ou pelo Copy Master,
so that eu possa pedir copy no estilo Halbert e receber peça baseada em pesquisa real, não pastiche.

**Acceptance Criteria:**
1. `.claude/agents/halbert.md` criado com YAML frontmatter padrão Anthropic
2. `name: halbert`, `description` clara sobre quando invocar (mercados, tipos de copy)
3. `tools: [Read, Write, Grep, Glob, WebSearch, WebFetch]`
4. System prompt em 6 seções obrigatórias: (1) Identidade, (2) Voz e estilo, (3) Frameworks que domina, (4) Peças de referência, (5) Como opera no squad, (6) Regras duras
5. ≥600 palavras de system prompt (NFR1 PASS)
6. Referencia explicitamente os 4 arquivos `research/halbert/` no corpo (FR5)
7. Inclui mantras verificáveis ("Motion beats meditation", referência a "The Boron Letters")
8. Output esperado documentado: 2 versões + nota explicando aposta de cada
9. Validação `validate-structure` PASS
10. Halbert agent é o **template de referência** — outros 14 agentes seguem essa estrutura

#### Story 3.2: Direct Response clássico — agentes

As a copywriter user,
I want agentes `schwartz`, `hopkins`, `caples` criados,
so that o squad cubra os fundadores de direct response.

**Acceptance Criteria:**
1. `.claude/agents/schwartz.md`, `hopkins.md`, `caples.md` criados seguindo template da Story 3.1
2. Cada um ≥600 palavras de system prompt
3. Cada um referencia sua respectiva pasta `research/{nome}/`
4. `description` distintivo por agente (quando invocar Schwartz vs. Hopkins vs. Caples)
5. Frameworks específicos no prompt: Schwartz (awareness levels), Hopkins (reason-why, scientific), Caples (35 headlines)
6. Validações `validate-density` + `validate-structure` PASS
7. CI verde após o lote

#### Story 3.3: Direct Response moderno — agentes

As a copywriter user,
I want agentes `sugarman`, `kennedy`, `bencivenga` criados,
so that o squad cubra direct response moderno e contemporâneo.

**Acceptance Criteria:**
1. `.claude/agents/sugarman.md`, `kennedy.md`, `bencivenga.md` criados seguindo template
2. ≥600 palavras cada
3. Cada um referencia `research/{nome}/`
4. Especialidades: Sugarman (slippery slide, conversational), Kennedy (info-marketing, no-BS), Bencivenga (controles, bullet copy)
5. Validações PASS
6. CI verde

#### Story 3.4: Direct Response completion — agentes

As a copywriter user,
I want agentes `carlton`, `makepeace`, `collier` criados,
so that os 10 agentes de direct response do squad estejam completos.

**Acceptance Criteria:**
1. `.claude/agents/carlton.md`, `makepeace.md`, `collier.md` criados seguindo template
2. ≥600 palavras cada
3. Cada um referencia `research/{nome}/`
4. Especialidades: Carlton (ganchos brutais, sales letter), Makepeace (financeiro/saúde, visceral), Collier (carta íntima, "conversa na cabeça")
5. Validações PASS

#### Story 3.5: Brand agents

As a copywriter user,
I want agentes `ogilvy`, `bernbach`, `burnett`, `abbott`, `bird` (ou substitutos) criados,
so that o squad cubra brand/big idea para projetos de posicionamento.

**Acceptance Criteria:**
1. 5 agentes brand criados (`.claude/agents/{ogilvy,bernbach,burnett,abbott,bird}.md` ou os substitutos definidos na Story 2.5)
2. ≥600 palavras cada
3. Cada um referencia sua pasta de research/
4. Especialidades: Ogilvy (autoridade elegante, 38 perguntas), Bernbach (criatividade com substância), Burnett (inherent drama, mascotes), Abbott (elegância emocional), Bird (direct britânico)
5. Se houver substituto da Story 2.5, frontmatter `description` reflete o copywriter substituto
6. Validações PASS
7. CI verde — squad de 15 agentes completo após este lote

---

### Epic 4: Copy Master + Researcher + Reviewer

**Goal expandido:** entregar a camada de orquestração que torna o squad utilizável. Sem Copy Master, o usuário precisaria invocar copywriters manualmente e sintetizar entrega — nega o valor central do produto. Inclui também os 2 agentes de suporte (Researcher, Reviewer) e o slash command como entry point.

#### Story 4.1: Slash command /copy

As a copywriter user,
I want digitar `/copy "<demanda>"` no Claude Code,
so that o squad seja acionado sem eu lembrar @copy-master toda vez.

**Acceptance Criteria:**
1. `.claude/commands/copy.md` criado
2. Frontmatter com `argument-hint`, `description` clara
3. Body invoca `@copy-master` passando os argumentos do usuário
4. Inclui ≥3 exemplos de uso documentados no próprio command
5. Testado funcionalmente: `/copy "demanda fictícia"` aciona Copy Master corretamente
6. Documentado em README.md como ponto de entrada primário

#### Story 4.2: Copy Researcher agent

As a Copy Master,
I want um agente especializado em pesquisa de avatar/mercado,
so that eu possa delegar dossiê de público antes do draft sem misturar com o trabalho criativo dos copywriters.

**Acceptance Criteria:**
1. `.claude/agents/copy-researcher.md` criado, ≥600 palavras
2. Especialidade documentada: pesquisa de avatar (fóruns, reviews, comentários), linguagem nativa, concorrência (swipe file), gatilhos emocionais ativos
3. `tools: [WebSearch, WebFetch, Read, Write, Grep]`
4. Output structure obrigatória definida no prompt: 7 seções (Avatar / Dores / Desejos / Linguagem nativa / Objeções / Concorrentes / Provas sociais disponíveis)
5. Validações PASS

#### Story 4.3: Copy Reviewer agent

As a Copy Master,
I want um agente que faça passe técnico final na entrega,
so that copy não saia com violação de checklist (compliance, blink test, prova fraca, CTA ambíguo).

**Acceptance Criteria:**
1. `.claude/agents/copy-reviewer.md` criado, ≥600 palavras
2. Checklist obrigatório de 9 itens documentado: 4 U's no headline, blink test no lead (50 palavras), promessa específica e crível, prova ancorada (números/casos/fontes), top-3 objeções tratadas, CTA único e razão para agir agora, PT-BR natural (zero anglicismo desnecessário), densidade emocional adequada ao avatar, compliance básico (sem promessa absoluta em saúde/financeiro/jurídico)
3. Output: relatório markdown com flags + correções sugeridas + score 0-100
4. `tools: [Read, Grep]`
5. Validações PASS
6. Aciona automaticamente NFR9 (validação PT-BR) usando regex/heurísticas

#### Story 4.4: Routing matrix

As a Copy Master,
I want tabela documentada projeto→squad sugerido,
so that eu possa rotear sem improviso e justificar a escolha em 2 linhas.

**Acceptance Criteria:**
1. `docs/architecture/routing-matrix.md` criado
2. Tabela com ≥8 linhas: tipo de projeto → squad sugerido (2-4 copywriters) → justificativa (2 linhas)
3. Cobre obrigatoriamente: sales page longa, VSL lançamento, headlines/captura, brand storytelling, e-mail sequence, Meta/Google Ads, carta de renovação/reativação, info-produto premium
4. Cada combinação justificada com critério explícito (mercado, sofisticação, formato)
5. Referenciado pelo Copy Master no system prompt (FR15)
6. Linkado de `docs/architecture/knowledge-base.md`

#### Story 4.5: Copy Master agent (orchestrator)

As a copywriter user (Carlos),
I want um orquestrador que receba demanda e devolva copy final pronto + variações + sugestões A/B,
so that eu não precise gerenciar 15+3 agentes manualmente.

**Acceptance Criteria:**
1. `.claude/agents/copy-master.md` criado, ≥1200 palavras (denso — é o cérebro do squad)
2. Workflow de 6 passos documentado: (1) briefing inteligente, (2) roteamento via matriz da Story 4.4, (3) pesquisa via Copy Researcher se necessário, (4) draft invocando copywriters do squad, (5) revisão cruzada (1-2 copywriters como reviewers críticos), (6) entrega final via Copy Reviewer
3. Regra crítica explícita no prompt: **"Copy Master nunca escreve copy direto"** — sempre invoca copywriter do squad para ato de redação
4. Briefing inteligente: lista de perguntas ordenadas por dependência (produto, avatar, promessa, formato, tom, tamanho, métrica), com inferência onde possível (não perguntar o que dá pra deduzir)
5. Output template definido: versão final + 3-5 variações alternativas (headline/lead/CTA) + sugestões A/B priorizadas + nota de quem do squad atuou em cada etapa
6. `tools: [Read, Grep, Glob, Agent]` (Agent para invocar subagentes)
7. Validações `validate-density` + `validate-structure` PASS
8. Roda contra simulação de demanda fictícia ("VSL de 8min para curso de jiu-jitsu para iniciantes 35+, R$ 497, mercado problem-aware") e produz workflow completo testável

---

### Epic 5: Portability, Documentation & E2E Validation

**Goal expandido:** transformar o squad em produto distribuível e atestar funcionamento ponta-a-ponta antes de marcar `v2.0.0`. Sem essa etapa, o squad é só um repo pessoal — não cumpre FR8 (portabilidade) e o release fica sem validação E2E.

#### Story 5.1: Install script core

As a copywriter user instalando em outro projeto,
I want `install-copy-squad.sh <path>` que copie `.claude/` e `research/` para o destino,
so that eu tenha o squad disponível em qualquer projeto Claude Code com 1 comando.

**Acceptance Criteria:**
1. `install-copy-squad.sh` criado na raiz do repo, com `chmod +x`
2. Aceita 1 argumento posicional: caminho do projeto destino (ou `~/.claude/` se `--user`)
3. Valida que o caminho existe e é acessível (read+write)
4. Copia `.claude/agents/`, `.claude/commands/`, `research/` para o destino (NÃO copia `.claude/settings.local.json`)
5. Sucesso: log "✅ Copy Squad v2 instalado em {path}"
6. Falha graceful: mensagem clara em stderr e exit code != 0
7. Funciona em macOS (`bash` + `zsh`)
8. Shebang `#!/usr/bin/env bash`

#### Story 5.2: Install script flags (--force, --user, --dry-run)

As a copywriter user em projeto com Copy Squad já instalado,
I want flags para controlar overwrite, escopo e simulação,
so that eu possa instalar com segurança sem perder customizações ou poder testar antes.

**Acceptance Criteria:**
1. Flag `--force`: sobrescreve `.claude/` existente; antes faz backup automático em `{path}/.claude.backup-{timestamp}/`
2. Flag `--user`: ignora caminho posicional, instala em `~/.claude/` (squad fica disponível globalmente)
3. Flag `--dry-run`: imprime todas as operações que faria (mkdir, cp, mv) sem aplicar nenhuma; exit 0 se nada falharia
4. Sem nenhuma flag: detecta conflito; se houver `.claude/` no destino, recusa e sugere `--force`
5. Combinação `--user --force` válida; `--user --dry-run` válida
6. Help text com `--help` ou `-h` mostrando todas as flags + exemplos
7. Exit codes documentados: 0=success, 1=path error, 2=conflict sem --force, 3=permission denied
8. Backup criado por `--force` é diff-eável (estrutura original preservada)

#### Story 5.3: BATS test suite

As a maintainer,
I want test suite automatizado validando todos os caminhos do install script,
so that mudanças futuras no install não quebrem comportamentos críticos sem CI gritar.

**Acceptance Criteria:**
1. Pasta `tests/install/` com testes BATS (`*.bats`)
2. Test cases obrigatórios: (a) install em path limpo, (b) install com conflito sem --force falha graceful, (c) install com --force cria backup correto, (d) install --user instala em ~/.claude/, (e) install --dry-run não modifica filesystem, (f) install em path inexistente falha com exit 1, (g) install --help retorna texto de ajuda
3. Tests rodam localmente via `bats tests/install/`
4. Tests integrados no GitHub Actions workflow (.github/workflows/validate.yml) como job adicional
5. CI verde após Story 5.3

#### Story 5.4: CLAUDE.md (project instructions)

As a Claude Code working in a project where Copy Squad is installed,
I want um `CLAUDE.md` na raiz instruindo sobre o squad,
so that eu saiba que existe, como invocar, e que agentes leem `research/` antes de produzir.

**Acceptance Criteria:**
1. `CLAUDE.md` criado na raiz do projeto Copy Squad
2. Seções obrigatórias: visão geral (1 parágrafo), arquitetura (15+3 agentes em `.claude/agents/`), comandos principais (`/copy`, `@copy-master`, `@halbert`, etc.), localização da pesquisa (`research/{nome}/`), regras (agentes leem dossier antes, Copy Master não escreve copy direto, output PT-BR default)
3. ≥500 palavras
4. Linguagem PT-BR
5. Linkado do `COPY-SQUAD-README.md`

#### Story 5.5: COPY-SQUAD-README.md (human docs)

As a potential user finding the repo on GitHub,
I want um README humano que explique o que é o squad e como usar,
so that eu decida em 30 segundos se vou instalar.

**Acceptance Criteria:**
1. `COPY-SQUAD-README.md` criado na raiz
2. Seções obrigatórias: hero (o que é em 1 frase), instalação (curl + git clone), invocação (`/copy` + exemplos), lista 15+3 (cada um com 2 linhas), tabela de matching projeto→squad (resumo da Story 4.4), fluxos típicos por tipo de projeto, FAQ, link pra CHANGELOG e LICENSE
3. ≥1500 palavras
4. Inclui ≥1 exemplo real de invocação ponta-a-ponta (pode ser excerpt da simulação E2E da Story 5.6)
5. Renderiza bem no GitHub (badges opcionais, sumário automático, headings com hierarquia)
6. Linguagem PT-BR
7. README.md na raiz (sem prefixo) é symlink ou cópia do COPY-SQUAD-README.md (GitHub mostra automaticamente)

#### Story 5.6: CHANGELOG + E2E simulation + Release v2.0.0

As a developer marking the project as v2.0.0,
I want CHANGELOG documentado, simulação E2E rodada com sucesso e tag git criada,
so that release seja oficial e auditável.

**Acceptance Criteria:**
1. `CHANGELOG.md` criado seguindo Keep a Changelog format; entrada `[2.0.0] - 2026-XX-XX` lista todas as features (FR1-16) e melhorias (NFR1-9) implementadas
2. Simulação E2E executada e documentada em `docs/e2e-simulation.md`:
   - **Briefing fictício:** "VSL de 8 minutos para curso de jiu-jitsu para iniciantes 35+, R$ 497, mercado problem-aware (sabem que estão fora de forma) mas não solution-aware (não conhecem jiu-jitsu como caminho)"
   - Output completo: briefing → roteamento (justificado) → pesquisa via Researcher (avatar/dores/linguagem) → draft (copywriter principal nomeado) → revisão cruzada (1-2 copywriters críticos com seus pareceres) → entrega final do Copy Master
   - Output passa pelo Copy Reviewer e recebe score ≥70/100
3. Cada step da simulação tem timestamp e identifica quem (do squad) atuou
4. Tag git `v2.0.0` annotated criada com mensagem referenciando CHANGELOG
5. Release notes criadas no GitHub via `gh release create` com link pro CHANGELOG
6. `LICENSE` (MIT) criado na raiz
7. Repo home no GitHub renderiza: README + LICENSE + CHANGELOG + tag v2.0.0 visível

#### Story 5.7: Uninstall script + tests

As a copywriter user querendo remover Copy Squad de um projeto,
I want um script de uninstall que remova apenas arquivos do squad sem tocar em outros agentes ou configurações do usuário,
so that eu posso desinstalar o squad de forma limpa, com backup automático, sem precisar de `rm -rf` manual e sem arriscar perder customizações de outros agentes.

**Acceptance Criteria:**
1. `uninstall-copy-squad.sh` executável criado na raiz do repo (`chmod +x`); shebang `#!/usr/bin/env bash`; bash 3.2-compat (ADR-006)
2. Aceita argumento posicional (path do projeto) OU flag `--user` (remove de `~/.claude/`)
3. Lista hardcoded de arquivos do Copy Squad é definida no script: 18 agents (`copy-master.md`, `copy-researcher.md`, `copy-reviewer.md`, 15 copywriters), `commands/copy.md`, `agents/_shared/`, e `research/{15 dirs}/`
4. **NÃO toca** em outros agentes em `.claude/agents/` (fora da lista hardcoded) — usuário pode ter agents customizados
5. **NÃO toca** em `settings.json` ou `settings.local.json`
6. Backup automático em `{target}/.claude.uninstall-backup-{YYYY-MM-DDTHHMMSS}/` antes de remover qualquer coisa, contendo todos os arquivos a serem removidos + `_MANIFEST.txt` documentando a operação
7. Suporta `--dry-run` (imprime plano de remoção sem executar)
8. Suporta `--force` (skipa confirmação interativa)
9. Sem `--force`: confirma com usuário (prompt sim/não) antes de remover
10. `--help` ou `-h`: imprime usage + exemplos
11. Imprime relatório final: contagem de arquivos removidos + path do backup + comando de rollback
12. Exit codes: 0 success, 1 path error, 2 nada-pra-desinstalar (squad não detectado), 3 user cancelou
13. BATS tests em `tests/install/uninstall.bats` cobrindo: (a) clean uninstall em projeto com squad instalado, (b) `--dry-run` não modifica filesystem, (c) `--force` skipa confirmação, (d) path inexistente falha exit 1, (e) projeto sem squad falha exit 2, (f) backup é criado antes de remoção, (g) outros agentes do user permanecem intactos após uninstall, (h) `--help` retorna ajuda

> **Nota:** Story 5.7 promovida ao MVP via Architecture ADR-015. Dependência: Story 5.1 (install script core estabelece convenções compartilhadas como bash 3.2-compat, exit codes, manifest format).

---

## 7. Checklist Results Report

> **Auditor:** @pm (Morgan)
> **Checklist:** `pm-checklist.md` (9 seções × ~140 critérios)
> **Modo:** comprehensive
> **Executado em:** 2026-04-26

### 7.1 Executive Summary

- **PRD completeness:** ~88% (PASS condicional)
- **MVP scope appropriateness:** **Just Right** (P0/P1/P2 claramente segmentados, 28 stories sized para single AI session)
- **Readiness for architecture phase:** **Ready**
- **Critical gaps remediados inline:**
  - Adicionada seção **2.3 Out of Scope** (gap HIGH) — explicita o que NÃO faz parte de v2.0.0
  - Adicionada seção **2.4 Future Enhancements** (gap HIGH) — roadmap v2.1, v2.2, v2.3, v3.0
- **Gaps remanescentes (aceitos com justificativa):**
  - KPIs quantitativos: usuário declinou explicitamente ("Por enquanto não") — PRD aceita gap por decisão de produto
  - Timeline expectations: projeto pessoal sem deadline formal — gap aceito
  - Tech debt approach: não material para greenfield — aceito como out-of-scope para PRD inicial

### 7.2 Category Analysis

| # | Category | Status | Critical Issues |
|---|----------|--------|-----------------|
| 1 | Problem Definition & Context | **PARTIAL (80%)** | Sem KPIs quantitativos (declinado pelo usuário) |
| 2 | MVP Scope Definition | **PASS (95%)** | Out of Scope + Future Enhancements adicionadas inline |
| 3 | UX Requirements | **PASS** (interpretado como CLI/agent — UI sub-section N/A) | Skipped intencionalmente per template `condition` |
| 4 | Functional Requirements | **PASS (100%)** | — |
| 5 | Non-Functional Requirements | **PARTIAL (70%)** | Performance/security checklist parcialmente N/A para sistema stateless file-based |
| 6 | Epic & Story Structure | **PASS (100%)** | — |
| 7 | Technical Guidance | **PASS (90%)** | Tech debt approach não abordado (aceito para greenfield) |
| 8 | Cross-Functional Requirements | **PARTIAL (75%)** | Operational (monitoring/alerting) N/A para sistema local |
| 9 | Clarity & Communication | **PASS (95%)** | Diagramas/visuais minimalistas (acceptable para sistema text-first) |

**Score agregado:** 88% (média ponderada). PRD aprovado para fase de arquitetura.

### 7.3 Top Issues by Priority

#### BLOCKERS
- ✅ **Nenhum.** Não há blocker que impeça avanço para arquitetura.

#### HIGH (corrigidos inline neste PRD)
- ✅ **Out of Scope explícito** — adicionado em Section 2.3
- ✅ **Future Enhancements** — adicionado em Section 2.4

#### MEDIUM (aceitos como gaps justificados)
- ⚠️ **KPIs quantitativos** — usuário declinou explicitamente; revisitar antes de v2.1
- ⚠️ **Timeline expectations** — projeto pessoal sem deadline; revisitar se houver lançamento público

#### LOW (sugestões para pós-v2.0)
- 💡 Diagrama visual da arquitetura do squad (mermaid) na Section 4 (cosmético)
- 💡 Persona expandida de "Carlos" (background, contexto de uso, frequência) — útil para futuros copywriters externos

### 7.4 MVP Scope Assessment

- **Features que poderiam ser cortadas para MVP mais enxuto:** nenhuma. P0 atual é o mínimo viável; cortar Researcher (FR11) ou Reviewer (FR12) comprometeria FR13 (revisão cruzada) e qualidade da entrega.
- **Features ausentes essenciais:** nenhuma. 16 FRs cobrem produção, validação, distribuição, documentação.
- **Complexity concerns:** Story 4.5 (Copy Master) é a mais densa do projeto (≥1200 palavras de prompt + 6-step workflow). Risco moderado de iteração; mitigado por roteamento documentado (Story 4.4) feito ANTES.
- **Timeline realism:** 28 stories, ~2-4h cada = ~80-110h de trabalho focado. Para Carlos solo, ~4-6 semanas em ritmo regular. Realista.

### 7.5 Technical Readiness

- **Clarity of technical constraints:** ALTA. Section 4 explícita sobre stack (Markdown + YAML + Bash + Node.js), arquitetura (file-based stateless), distribuição (curl + git clone), CI/CD (GitHub Actions).
- **Identified technical risks:**
  1. Densidade de pesquisa para Abbott/Bird — mitigado pela substituição automática (NFR6, Story 2.5)
  2. Token budget do Copy Master ao orquestrar 4+ subagentes — mitigado pelo modelo agnóstico + recomendação implícita de modelo com 1M context
  3. Idempotência do install script em projetos com `.claude/` customizado — mitigado por backup automático + dry-run
- **Areas needing architect investigation:**
  1. Padrão exato de invocação subagent → subagent (Copy Master invocando copywriter) — verificar se Tool `Agent` do Claude Code suporta a topologia
  2. Estratégia de research-trail (NFR5) — formato canônico de citar fontes em cada arquivo
  3. Schema de validação YAML — definir whitelist final de tools permitidas

### 7.6 Recommendations

- ✅ **Avançar para fase de arquitetura.** PRD está pronto para `@architect *create-doc architecture` — Aria pode receber o PRD e produzir o documento de arquitetura técnica.
- ✅ **Iniciar Epic 1 em paralelo** — Story 1.1 (scaffolding) pode rodar enquanto arquitetura é desenhada; é trabalho mecânico de criação de pastas.
- 📋 **Antes de Epic 4:** validar com prova-de-conceito que Tool `Agent` do Claude Code permite Copy Master → copywriter (subagent → subagent). Caso negativo, redesenhar fluxo (alternativa: Copy Master gera prompts em sequência para o usuário invocar manualmente).

### 7.7 Final Decision

> **READY FOR ARCHITECT** ✅
>
> O PRD é compreensivo, properly estruturado e pronto para design arquitetural. Gaps remanescentes são justificados (decisões de produto explícitas) ou cosméticos (sugestões de melhoria pós-MVP).

---

## 8. Next Steps

### 8.1 UX Expert Prompt

> **Não aplicável.** Copy Squad v2 não tem interface gráfica — sistema é CLI/agent only. UX Expert não é invocado nesta fase. Diretrizes de comunicação dos agentes (tom, formato de output PT-BR) já capturadas em FR9, FR14, NFR9 e na Story 4.5 (Copy Master template).

### 8.2 Architect Prompt

```
@architect

Criar Architecture Document para Copy Squad v2 baseado no PRD em docs/prd.md.

Contexto:
- Sistema: subagentes Claude Code orquestrados (15 copywriters + Copy Master + Researcher + Reviewer)
- Stack: Markdown + YAML + Bash + Node.js (validações)
- Persistência: file-based stateless (sem DB, sem state, sem cache)
- Distribuição: install script bash com flags --force / --user / --dry-run
- CI: GitHub Actions com validate-density + validate-structure

Foco do Architecture Document:
1. Topologia de invocação Copy Master → subagentes (verificar se Tool Agent do Claude Code suporta; investigar e propor alternativa se necessário)
2. Schema final do YAML frontmatter (campos obrigatórios, whitelist de tools)
3. Estrutura canônica de research/{nome}/{biografia,estilo,frameworks,exemplos}.md (templates exatos, formato de fontes)
4. Pipeline de CI detalhado (jobs, steps, fixtures, branch protection)
5. Estratégia de research-trail para reprodutibilidade (como cada agente cita as fontes da pesquisa)
6. Mapeamento de dependências entre stories da Section 6 — diagrama de critical path

Decisões críticas pendentes que devem ser resolvidas no Architecture Document:
- DEC-001: Padrão de subagent → subagent invocation (Tool Agent vs. fallback manual)
- DEC-002: Schema de fontes em research/ (URL + título + accessed-at? ou só URL?)
- DEC-003: Whitelist exata de tools por tipo de agente (copywriter vs. orquestrador vs. researcher vs. reviewer)

Output: docs/architecture.md (versão única — não shardar até validação inicial)

Próximo agente após Architecture: @sm para criar primeira story (1.1 Project scaffolding).
```

### 8.3 Sequência canônica pós-PRD

1. **`@architect *create-doc architecture`** — Aria produz Architecture Document
2. **`@po`** — Pax valida PRD + Architecture (story-draft-checklist + po-master-checklist)
3. **`@sm *draft`** — River cria primeira story (Story 1.1) seguindo Story Development Cycle
4. **`@dev *develop-story`** — Dex implementa
5. **`@qa *qa-gate`** — Quinn valida
6. **Loop:** SDC repete para Stories 1.2 → 5.6

---

## Appendix: Document Status

- **Estado:** ✅ FINALIZADO + reconciliado pós-Architecture (8/8 sections, 29 stories)
- **Versão:** 2.0.0-draft.9
- **Próxima ação:** invocar `@sm *draft 1.1` para criar primeira story (Project scaffolding)
- **Reconciliations aplicadas:** Story 5.7 (uninstall) adicionada via ADR-015 do Architecture
- **Localização:** `docs/prd.md`
