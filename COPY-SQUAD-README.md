# Copy Squad v2

> **15 copywriters lendários como subagentes Claude Code, orquestrados pelo Copy Master para produzir copy direct response e brand baseado em pesquisa real, não pastiche.**

[![CI](https://github.com/valentecarlos/copy-squad/actions/workflows/validate.yml/badge.svg)](https://github.com/valentecarlos/copy-squad/actions/workflows/validate.yml)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---

## O que é

**Copy Squad v2** é um sistema de **18 subagentes Claude Code** especializado em copywriting profissional. Composto por **15 copywriters históricos lendários** (Halbert, Schwartz, Hopkins, Caples, Sugarman, Kennedy, Bencivenga, Carlton, Makepeace, Collier, Ogilvy, Bernbach, Burnett, Abbott, Bird) + **3 agents de suporte** (`copy-master` orquestrador, `copy-researcher` para avatar/mercado, `copy-reviewer` para quality pass). Cada copywriter é um **system prompt denso (≥600 palavras)** ancorado em **dossier de pesquisa real** — 60 arquivos (`research/{nome}/`) totalizando ~82.000 palavras de biografia, estilo, frameworks e exemplos canônicos com fontes citadas.

**Não é pastiche IA**. É pesquisa real do ofício de copywriting traduzida em agents que respeitam a voz histórica de cada copywriter, as peças canônicas de cada um, e os frameworks que cada um codificou. Halbert escreve como Halbert (Florida-direct vendedor-de-rua). Ogilvy escreve como Ogilvy (literary British+American factual research-driven). Bencivenga produz controles factuais elegantes. Cada um diferente, todos integrados via Copy Master.

## Por que existe

Copywriters profissionais têm acesso a **swipe files físicos**: pastas com peças vencedoras de Halbert/Schwartz/Caples para estudar antes de produzir copy nova. Mas:

1. **Swipe files são manuais** — você precisa lembrar quem fazia o quê e abrir os PDFs
2. **Não há voz "consultiva"** — você não pode "perguntar" ao Halbert sobre seu briefing específico
3. **Síntese é trabalhosa** — combinar approach de 3 copywriters num briefing real custa horas

Copy Squad resolve os 3 — você digita `/copy "<demanda>"` no Claude Code e o **Copy Master** orquestra 2-4 copywriters apropriados (via routing matrix), coordena pesquisa de avatar, sintetiza outputs e devolve **2-3 versões + sugestões A/B + nota de quem do squad atuou em cada etapa**. Workflow de 6 passos. PT-BR nativo. Lazy-load research (NFR4 — sem custo de contexto desnecessário).

## Instalação

### Opção 1 — Install em projeto específico

```bash
git clone https://github.com/valentecarlos/copy-squad.git
cd copy-squad
./install-copy-squad.sh ~/meu-projeto
```

Squad disponível em `~/meu-projeto/.claude/agents/` + `~/meu-projeto/research/`.

### Opção 2 — Install global (todos os projetos Claude Code)

```bash
./install-copy-squad.sh --user
```

Squad disponível em `~/.claude/` — qualquer projeto Claude Code consegue invocar.

### Opção 3 — Reinstall com backup automático

```bash
./install-copy-squad.sh --force ~/meu-projeto
```

Backup automático em `~/meu-projeto/.claude.backup-{timestamp}/` antes de sobrescrever.

### Opção 4 — Simular antes de aplicar

```bash
./install-copy-squad.sh --dry-run ~/meu-projeto
```

Imprime operações `mkdir` + `cp` sem modificar filesystem.

### Help completo

```bash
./install-copy-squad.sh --help
```

## Invocação

### Slash command (entry point primário)

```
/copy "<descrição da demanda>"
```

Aciona Copy Master que executa workflow completo de 6 passos.

### Invocação direta

```
@copy-master "<demanda multi-etapa>"   # workflow completo
@copy-researcher "<vertical + audiência>"  # apenas pesquisa
@copy-reviewer "<copy a revisar>"      # apenas quality pass
@halbert "<peça emocional cru>"        # copywriter específico
@ogilvy "<brand premium literary>"
# ... 13 outros copywriters disponíveis
```

## O squad — 15 copywriters + 3 support

### Copywriters Direct Response (10/10)

| Copywriter | Voz/especialidade | Mercados ideais |
|------------|-------------------|-----------------|
| **Halbert** | Florida-direct vendedor-de-rua, voz "amigo no bar com edge", emoção crua | Saúde, dinheiro, relacionamento, info-produto, oportunidade |
| **Schwartz** | Arquiteto cognitivo (5 awareness + 5 sophistication), mass desire, mechanism | Mercados saturados/sofisticados (saúde, finanças premium) |
| **Hopkins** | Vendedor factual scientific, reason-why, sampling, specificity | Consumer goods (alimentos, higiene, cosméticos) |
| **Caples** | Headline-craft executive BBDO, 35 templates, A/B testing rigoroso | Info-product, headlines testáveis, mail order |
| **Sugarman** | Slippery slide hipnose textual, 17 axiomas, 30+ triggers, advertorial pioneer | Tech gadgets, eyewear, consumer products direct |
| **Kennedy** | No-BS info-marketing premium, Magnetic Marketing, 29-step formula | Coaching, mastermind, info-product premium $5K-$50K |
| **Bencivenga** | Editorial factual elegante, proof stacking, control philosophy, 12 maxims | Financial newsletters premium, health/anti-aging, B2B sofisticado |
| **Carlton** | Marketing Rebel agency-formal-edge, Big Idea contraintuitiva | Internet marketing, masculine markets, oportunidade |
| **Makepeace** | Emoção visceral controlada financeiro/saúde, magalog inventor | Financial newsletters premium, health/anti-aging |
| **Collier** | Carta-de-amigo elegante 1930s pioneer, "enter the conversation" | Subscription products, books, insurance, retail tradicional |

### Copywriters Brand (5/5)

| Copywriter | Voz/especialidade | Mercados ideais |
|------------|-------------------|-----------------|
| **Ogilvy** | Literary British+American factual, brand image cumulative, research-driven | Luxury (auto, spirits), consumer goods premium, financial elite |
| **Bernbach** | Creative revolution NYC sophisticated, paired teams, honest advertising | Brand reinvention, underdog positioning, automotive premium |
| **Burnett** | Inherent drama Midwestern character-driven, mascot creation longeva | Family-friendly food brands, consumer goods, household, mass market |
| **Abbott** | UK literary AMV BBDO production excellence, retail elevation | UK audience, premium subscription, luxury heritage, retail premium |
| **Bird** | Bridge brand+DR Ogilvy heritage extended, Commonsense direct marketing | DR campaigns brand-conscious, financial DR, subscription multi-channel |

### Support (3/3)

| Agent | Função | Tools |
|-------|--------|-------|
| **copy-master** | Orquestrador (workflow 6 passos: briefing → routing → research → draft → cross-review → quality) | Read, Grep, Glob, **Agent** |
| **copy-researcher** | Pesquisa avatar/mercado (output 7 seções: Avatar/Dores/Desejos/Linguagem/Objeções/Concorrentes/Provas) | WebSearch, WebFetch, Read, Write, Grep |
| **copy-reviewer** | Quality pass 9-itens checklist + score 0-100 + verdict (SHIP/MINOR/MAJOR/REJECT) | Read, Grep |

## Routing matrix — quando usar quem

`docs/architecture/routing-matrix.md` documenta **14 arquétipos de projeto** mapeados para squad sugerido. Resumo:

| Arquétipo | Squad sugerido |
|-----------|----------------|
| Sales page longa DR | Halbert + Sugarman + Bencivenga |
| VSL lançamento info-product premium | Sugarman + Kennedy + Makepeace |
| Headlines / capture page | Caples + Sugarman + Bencivenga |
| Brand storytelling / positioning | Ogilvy + Bernbach + Burnett |
| Email sequence (onboarding/win-back) | Kennedy + Makepeace + Bird |
| Meta/Google Ads (paid social/search) | Caples + Sugarman + Halbert |
| Carta de renovação/reativação | Collier + Makepeace + Bird |
| Info-produto premium $5K+ | Kennedy + Bencivenga + Carlton |
| Financial newsletter premium | Makepeace + Bencivenga + Bird |
| Health/anti-aging product | Hopkins + Bencivenga + Makepeace |
| Retail/consumer goods sophisticated | Ogilvy + Burnett + Abbott |
| B2B SaaS / enterprise | Bencivenga + Bird + Ogilvy |
| Cause marketing / fundraising | Abbott + Collier + Bernbach |
| Briefing vago (precisa pesquisa primeiro) | Researcher → reroute |

Copy Master consulta a matriz no Passo 2 (roteamento) e pode desviar com justificativa explícita.

## Exemplo real ponta-a-ponta

**Briefing:**
```
/copy "VSL de 8min para curso de jiu-jitsu para iniciantes 35+, R$ 497, mercado problem-aware (sabem que estão fora de forma) mas não solution-aware (não conhecem jiu-jitsu como caminho)"
```

**O que acontece:**

**Passo 1 — Briefing inteligente.** Copy Master infere produto + formato + tamanho + sugestão de tom. Pergunta ao usuário (apenas o que não dá pra deduzir):
- "Qual o avatar mais específico — homens 35+ urbanos? Pais que querem dar exemplo? Ex-atletas?"
- "Qual a métrica primária — conversion rate em VSL embed ou cliques no checkout pós-VSL?"

**Passo 2 — Roteamento.** Routing matrix: linha "VSL lançamento info-product premium" → **Sugarman + Kennedy + Makepeace**. Justificativa em 2 linhas: Sugarman traz slippery slide para roteiro de 8min; Kennedy traz Magnetic Marketing premium pricing positioning; Makepeace traz outcomes-first opening + emotional escalation calibrada para problem-aware → solution-aware shift.

**Passo 3 — Pesquisa.** `@copy-researcher` invocado. Dossiê 7 seções: avatar (homens 35+ desk job, sedentários, "panela de pressão" emocional, querem hobby + saúde), dores (não-encaixe em academia tradicional, intimidação de levantar peso, falta de competitividade), desejos (corpo funcional, comunidade masculine grounded, mental clarity), linguagem nativa ("voltar à forma", "sair do sedentarismo", "algo diferente de academia chata"), objeções (idade alta para começar, medo de lesão, falta de tempo), concorrentes (HIIT/CrossFit, academias tradicionais, yoga), provas sociais (depoimentos de iniciantes 35+ que voltaram à forma via BJJ + transformação física).

**Passo 4 — Draft.** Copy Master invoca em paralelo:
- `@sugarman` produz **roteiro 8min** com slippery slide (15 primeiras frases progressivamente curtas), seeds of curiosity plantadas, advertorial structure
- `@kennedy` produz **CTA + value stack** com premium pricing positioning, multiple P.S. agressivos, antagonista narrativo (academias inúteis para 35+)
- `@makepeace` produz **opening outcome-first** + emotional escalation calibrada (fear de continuar como está → hope de transformação concreta) + proof stacking de iniciantes 35+

**Passo 5 — Revisão cruzada.** Copy Master invoca `@bencivenga` (factual elegante) para revisar outputs Sugarman+Makepeace — flags de proof gaps + sugestões de specificity. Copy Master invoca `@halbert` (Florida-direct cru) para revisar Kennedy CTA — sugestão de adicionar storytelling autobiográfico mais raw em P.S.

**Passo 6 — Quality pass.** `@copy-reviewer` aplica checklist 9-itens. Score 87/100. Flags Minor: Item 7 (1 anglicismo "performance" → "desempenho"), Item 9 (suavizar "garante transformação" para "ajuda transformação"). Verdict: SHIP com correções aplicadas.

**Output ao usuário:**

```markdown
# Copy Squad — Entrega

**Briefing:** VSL 8min curso jiu-jitsu iniciantes 35+ R$497 problem-aware
**Squad acionado:** Sugarman + Kennedy + Makepeace + Bencivenga (cross-review) + Halbert (cross-review), Reviewer score 87/100, SHIP

## Versão Final
[Roteiro 8min consolidado: opening outcome-first → slippery slide hooks → mecanismo
do BJJ → cases de iniciantes 35+ → value stack → multiple P.S.]

## Variações Alternativas (3)
- Variação Alt 1 — opening fear-driven (consequência de continuar sedentário aos 50)
- Variação Alt 2 — opening identity-shift (de "homem desencaixado" para "homem grounded")
- Variação Alt 3 — opening curiosity-hook (segredo do BJJ que pais 35+ não sabem)

## Sugestões A/B Priorizadas
1. Headline VSL: "Por que homens 35+ estão abandonando academias por jiu-jitsu" vs.
   "O que acontece quando um homem 38 anos sedentário começa BJJ"
2. CTA: "Quero começar agora" vs. "Quero ver se serve para mim"
3. Hook P.S.: storytelling Halbert (autobiográfico raw) vs. Kennedy (antagonista narrativo)

## Nota de Atuação do Squad
| Etapa | Quem |
|-------|------|
| Briefing | Copy Master (2 perguntas avatar + métrica) |
| Roteamento | Copy Master (routing matrix linha "VSL premium") |
| Pesquisa | Copy Researcher (dossiê 7 seções) |
| Draft | Sugarman (roteiro) + Kennedy (CTA) + Makepeace (opening) |
| Revisão cruzada | Bencivenga (proof gaps) + Halbert (P.S. raw) |
| Quality pass | Copy Reviewer (87/100, SHIP com 2 correções Minor aplicadas) |
```

## FAQ

### Posso editar os agents?

Sim. Cada agent é arquivo markdown em `.claude/agents/{nome}.md`. Edite frontmatter ou body como quiser — Claude Code carrega o arquivo modificado na próxima invocação. Cuidado para não quebrar regras críticas (como "Copy Master nunca escreve copy direto").

### Posso adicionar copywriters customizados?

Sim. Crie `.claude/agents/<seu-copywriter>.md` seguindo o template (YAML frontmatter + 6 sections). Adicione dossier em `research/<seu-copywriter>/` com 4 arquivos. Roda `npm run validate` para confirmar conformidade. Lembre: Copy Master só conhece copywriters listados na routing matrix — atualize `docs/architecture/routing-matrix.md` se quiser que ele rote para o novo.

### Como funciona o lazy-load?

Cada copywriter referencia `research/{nome}/` no system prompt mas só **lê o arquivo quando relevante ao briefing**. Tool Read é invocado sob demanda. Resultado: contexto não é poluído com 80K palavras de research no startup; só carrega o que importa para a demanda específica.

### Quanto custa rodar?

Custa **tokens da API Anthropic** que sua conta Claude Code já paga. Tipicamente uma demanda complexa (workflow 6 passos completo) consome 30K-80K tokens (input + output) — depende do briefing + tamanho de research carregada + número de copywriters invocados. Não há custo adicional do Copy Squad — é arquivo markdown + bash, zero infra.

### Posso usar offline?

Não. Copy Squad roda no Claude Code que requer API Anthropic online. Mas o repo é git-cloneable (sem dependências runtime além de Node.js para validation scripts opcionais).

### O que é a routing matrix?

Tabela de 14 arquétipos de projeto → squad sugerido (2-4 copywriters) → justificativa em `docs/architecture/routing-matrix.md`. Copy Master consulta no Passo 2 (roteamento) e pode desviar com justificativa explícita ao usuário.

### Como atualizar o squad?

```bash
cd copy-squad
git pull
./install-copy-squad.sh --force ~/meu-projeto  # backup automático antes de sobrescrever
```

### Como desinstalar?

Story 5.7 entrega `uninstall-copy-squad.sh` que remove apenas arquivos do squad (sem tocar em outros agents customizados ou settings).

## Documentos relacionados

- **Project instructions para Claude Code**: [`CLAUDE.md`](./CLAUDE.md)
- **PRD completo**: [`docs/prd.md`](./docs/prd.md)
- **Arquitetura técnica**: [`docs/architecture.md`](./docs/architecture.md)
- **Routing matrix**: [`docs/architecture/routing-matrix.md`](./docs/architecture/routing-matrix.md)
- **CHANGELOG**: [`CHANGELOG.md`](./CHANGELOG.md)
- **License**: [`LICENSE`](./LICENSE)

## Stats do projeto

- **15 copywriter agents** (Direct Response 10/10 + Brand 5/5)
- **3 support agents** (master + researcher + reviewer)
- **60 research files** (~82.000 palavras de pesquisa real validada)
- **18 agents body** ~17.300 palavras de system prompts
- **5 epics** completos (scaffolding + research + agents + orquestração + portabilidade)
- **CI 5 jobs** validando estrutura + densidade + format + encoding + BATS install tests
- **PT-BR nativo** em todo agent + documentação

## Contribuir

Ver `CONTRIBUTING.md` (futuro). Por enquanto:
1. Fork
2. Branch feature
3. PR com test pass (`npm run validate` + `bats tests/install/`)

## License

[MIT](./LICENSE) — fork-friendly, modify-friendly, distribute-friendly.

## Créditos

Squad construído em ~3 dias usando o framework **AIOX** (AI-Orchestrated System for Full Stack Development) com Claude Opus 4.7 (1M context). Os 15 copywriters históricos representados no squad — Halbert, Schwartz, Hopkins, Caples, Sugarman, Kennedy, Bencivenga, Carlton, Makepeace, Collier, Ogilvy, Bernbach, Burnett, Abbott, Bird — produziram coletivamente bilhões de dólares em vendas ao longo de ~120 anos da história do direct response e brand advertising. Suas vozes vivem em peças canônicas, livros referenciais e dezenas de copywriters subsequentes que estudaram seus métodos. Copy Squad busca tornar essa herança **acessível**, **invocável**, **diff-eável** — não substituir os mestres, mas **multiplicar acesso ao trabalho deles**.

---

**Versão:** 2.0.0
**Última atualização:** 2026-04-27
