# CLAUDE.md — Copy Squad v2 Project Instructions

> Este arquivo instrui o Claude Code sobre o **Copy Squad** instalado neste projeto. Leia antes de invocar qualquer agent ou produzir copy.

## Visão geral

**Copy Squad v2** é um sistema de **18 subagentes Claude Code** especializado em copywriting de direct response e brand. Composto por **15 copywriters lendários** (Halbert, Schwartz, Hopkins, Caples, Sugarman, Kennedy, Bencivenga, Carlton, Makepeace, Collier, Ogilvy, Bernbach, Burnett, Abbott, Bird) + **3 agents de suporte** (`copy-master` orquestrador, `copy-researcher`, `copy-reviewer`). Cada copywriter é um system prompt denso (≥600 palavras) ancorado em **dossier de pesquisa real** (4 arquivos × 15 copywriters = 60 arquivos em `research/`). A operação é **stateless**, **file-based**, **lazy-load** — agentes leem dossiers sob demanda quando invocados, nunca no startup.

## Arquitetura

```
.
├── .claude/
│   ├── agents/                # 18 agents (15 copywriters + 3 support)
│   │   ├── halbert.md         # 15 copywriters individuais
│   │   ├── schwartz.md
│   │   ├── ... (13 outros)
│   │   ├── copy-master.md     # orquestrador (Tool Agent)
│   │   ├── copy-researcher.md # pesquisa avatar/mercado
│   │   ├── copy-reviewer.md   # quality pass 9-itens
│   │   └── _shared/
│   │       ├── frameworks.md  # AIDA/PAS/4 U's/Schwartz/Sugarman/Burnett/Hopkins
│   │       └── glossario.md   # 41 termos canônicos PT-BR
│   └── commands/
│       └── copy.md            # slash command /copy (entry point primário)
├── research/                  # 15 dossiers (60 arquivos)
│   └── {copywriter}/
│       ├── biografia.md       # 800+ palavras
│       ├── estilo.md          # 800+ palavras
│       ├── frameworks.md      # 800+ palavras
│       └── exemplos.md        # 1.100+ palavras
└── docs/
    └── architecture/
        └── routing-matrix.md  # Tabela projeto → squad sugerido
```

## Comandos principais

### Slash command (entry point primário)

```
/copy "<descrição da demanda: produto + audiência + formato + métrica>"
```

Aciona Copy Master que executa workflow de 6 passos (briefing → roteamento → pesquisa → draft → revisão cruzada → quality pass) e devolve copy final + variações + sugestões A/B.

### Invocação direta de agents

```
@copy-master "<demanda complexa multi-etapa>"   # workflow completo
@copy-researcher "<vertical + audiência>"        # apenas pesquisa avatar/mercado
@copy-reviewer "<copy a ser revisada>"           # apenas quality pass

# Copywriters individuais (quando você sabe exatamente quem invocar)
@halbert "<peça emocional Florida-direct>"
@schwartz "<peça em mercado saturado/sofisticado>"
@hopkins "<peça factual com reason-why>"
@caples "<headlines tested + A/B testing>"
@sugarman "<peça com slippery slide hipnótico>"
@kennedy "<info-product premium No-BS>"
@bencivenga "<control candidate proof-stacked>"
@carlton "<sales letter Marketing Rebel edge>"
@makepeace "<financial/health fear-greed driven>"
@collier "<carta-de-amigo elegante por categoria>"
@ogilvy "<brand image factual research-driven>"
@bernbach "<creative revolution counter-positioning>"
@burnett "<character/archetype creation>"
@abbott "<UK literary brand premium>"
@bird "<integration brand+DR + multi-channel>"
```

## Localização da pesquisa

Cada copywriter tem **dossier completo** em `research/{copywriter}/`:

- `biografia.md` — vida + carreira + clientes + datas
- `estilo.md` — tom + ritmo + marcas operacionais + anti-patterns
- `frameworks.md` — frameworks que codificou + aplicação concreta
- `exemplos.md` — peças canônicas com texto + análise + atribuições

**Total acumulado:** ~82.000 palavras em 60 arquivos research validados via CI (DEC-002 schema, ≥3 fontes por arquivo).

## Regras críticas

### 1. Agentes leem dossier antes de produzir
Todo copywriter referencia `research/{nome}/` no system prompt e usa Tool **Read** sob demanda (NFR4 lazy-load). Nunca tente produzir copy "do zero" baseando-se apenas no system prompt do agent — o dossier é a fonte de pesquisa real.

### 2. Copy Master nunca escreve copy direto
Regra crítica não-negociável (DEC-001): `copy-master` é **orquestrador**, não copywriter. Toda redação delegada aos 15 copywriters especialistas via Tool **Agent**. Copy Master sintetiza outputs, não redige.

### 3. Output em PT-BR default (NFR9)
Todos os agents operam em **português brasileiro nativo**. Inglês apenas em copy citado verbatim de peças históricas + termos técnicos consagrados (headline, hook, lead, CTA, briefing, copy, swipe). Anglicismo desnecessário ("performance" → "desempenho", "feedback" → "retorno") é violação detectada por `copy-reviewer` Item 7 do checklist.

### 4. Single-level orchestration (anti-recursion DEC-001)
Apenas `copy-master` tem Tool **Agent** no whitelist. Os 15 copywriters + 2 support são **terminal subagents** (Tools `[Read, Grep]` apenas) — não invocam outros subagents. Profundidade máxima de invocação = 2 (Copy Master → Copywriter).

### 5. Tools whitelist por tipo de agent
| Tipo | Tools permitidas |
|------|------------------|
| `orchestrator` (copy-master) | Read, Grep, Glob, **Agent** |
| `copywriter` (15 individuais) | Read, Grep |
| `researcher` (copy-researcher) | WebSearch, WebFetch, Read, Write, Grep |
| `reviewer` (copy-reviewer) | Read, Grep |

### 6. Output protocol obrigatório dos copywriters
Todo copywriter retorna **2 versões + nota da aposta**. Devolver versão única é violação de protocolo. Nota da aposta explica em 2-3 frases qual a aposta de cada versão e quando uma vence a outra.

### 7. Reviewer obrigatório antes de entrega final
`copy-reviewer` aplica checklist de 9 itens (4 U's headline, blink test lead, promessa específica/crível, prova ancorada, top-3 objeções, CTA único+urgência, PT-BR natural, densidade emocional, compliance) + score 0-100. Threshold: score ≥70 entrega; <70 loop volta ao draft (max 1 iteração).

## Routing matrix

`docs/architecture/routing-matrix.md` documenta **14 arquétipos de projeto** (sales page longa, VSL, headlines, brand storytelling, email sequence, ads, renovação/reativação, info-produto premium + 6 bonus) → squad sugerido (2-4 copywriters) → justificativa explícita (mercado, sofisticação, formato).

Copy Master consulta a matriz no Passo 2 do workflow (roteamento). Sempre pode desviar com justificativa.

## Tipos de demanda comuns

| Demanda | Use isto |
|---------|----------|
| "Quero copy para vender X" | `/copy "<demanda>"` (Copy Master orquestra tudo) |
| "Preciso de pesquisa de avatar" | `@copy-researcher "<vertical + audiência>"` |
| "Tenho copy escrita, quero revisão" | `@copy-reviewer "<copy>"` |
| "Quero copy específico do estilo de X" | `@<copywriter>` direto (ex.: `@halbert`) |

## Documentos relacionados

- **README humano** (visão geral + instalação): [`COPY-SQUAD-README.md`](./COPY-SQUAD-README.md)
- **PRD** (requisitos completos): `docs/prd.md`
- **Arquitetura técnica**: `docs/architecture.md`
- **Routing matrix**: `docs/architecture/routing-matrix.md`
- **Frameworks compartilhados**: `.claude/agents/_shared/frameworks.md`
- **Glossário PT-BR**: `.claude/agents/_shared/glossario.md`

## Notas para Claude Code

- **Lazy-load research** — não tente memorizar dossiers no startup; use Tool Read sob demanda
- **Bounded scope** (NFR7) — agents operam dentro de `research/{nome}/` + briefing recebido; não exfiltram credenciais nem acessam fora do escopo
- **Stateless** — toda "memória" vive em arquivos versionados em git; sem state, sem cache, sem DB
- **Idempotent install** — `install-copy-squad.sh` é seguro para re-rodar (com `--force` cria backup automático)
