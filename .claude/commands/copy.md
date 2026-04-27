---
description: "Aciona o Copy Squad — 15 copywriters lendários orquestrados por Copy Master para produzir copy direct response ou brand"
argument-hint: "<descrição da demanda: produto + audiência + formato + métrica>"
---

# `/copy` — Entry point do Copy Squad

Você acabou de invocar o **Copy Squad** — sistema de 15 subagentes copywriters lendários (Halbert, Schwartz, Hopkins, Caples, Sugarman, Kennedy, Bencivenga, Carlton, Makepeace, Collier, Ogilvy, Bernbach, Burnett, Abbott, Bird) orquestrados pelo **Copy Master**.

Acione o Copy Master agora passando a demanda do usuário:

@copy-master $ARGUMENTS

## Como funciona

O Copy Master (`@copy-master`) executa um workflow de 6 passos:

1. **Briefing inteligente** — esclarece produto, avatar, promessa, formato, tom, métrica (perguntas ordenadas por dependência; só pergunta o que não dá pra inferir)
2. **Roteamento** — escolhe 2-4 copywriters do squad via routing matrix (`docs/architecture/routing-matrix.md`)
3. **Pesquisa de avatar** — invoca `@copy-researcher` se necessário (mercado, dores, linguagem nativa, swipe file)
4. **Draft** — invoca os copywriters selecionados em paralelo, cada um produz sua versão lazy-loading `research/{nome}/`
5. **Revisão cruzada** — 1-2 copywriters reviewam crítica do output dos outros
6. **Quality pass final** — `@copy-reviewer` aplica checklist de 9 itens (4 U's headline, blink test, prova ancorada, top-3 objeções, CTA, PT-BR, compliance, etc.)

## Output esperado

Você recebe:

- **Versão final** sintetizada
- **3-5 variações alternativas** (headline / lead / CTA)
- **Sugestões A/B priorizadas** com hipótese de cada teste
- **Nota de quem do squad atuou em cada etapa** (transparência da orquestração)

## Exemplos de uso

### Exemplo 1 — VSL / Sales Letter long-form

```
/copy "VSL de 8min para curso de jiu-jitsu para iniciantes 35+, R$ 497, mercado problem-aware (já sabem que precisam de exercício, ainda não consideraram BJJ especificamente)"
```

**Esperado:** Copy Master roteia para **Halbert + Sugarman + Bencivenga** (DR triumvirate para problem-aware long-form). Produz roteiro de 8min com hook story-first + slippery slide + proof stacking + close emocional. 2 versões: uma mais aggressive (Halbert tone), outra mais factual (Bencivenga tone).

### Exemplo 2 — Headlines / Capture page

```
/copy "20 headlines variants para landing page de e-book gratuito sobre produtividade matinal — audience: profissionais 30-45 que se sentem overwhelmed com mornings caóticas"
```

**Esperado:** Copy Master invoca **Caples** (headline-craft 35 templates) + **Sugarman** (slippery slide curiosity hooks) + **Bencivenga** (specificity engineering). Entrega 20 variants categorized por type (curiosity, news, story, how-to, gee-whiz, etc.) + recommendation A/B test setup.

### Exemplo 3 — Brand storytelling / positioning

```
/copy "Brand storytelling para nova linha premium de cafés especiais (R$ 89/250g) — diferenciação: origem rastreável até fazenda + ritual matinal artesanal — target: classe AB urbana 30-50 que valoriza experiência sobre conveniência"
```

**Esperado:** Copy Master invoca brand vertical — **Ogilvy** (brand image philosophy + 38 perguntas) + **Burnett** (inherent drama do café/ritual) + **Abbott** (UK editorial + retail premium sophistication). Entrega manifesto de marca + 3 variations de tone (literary-aspirational / artisanal-warm / editorial-sophisticated) + sugestões A/B headline.

### Exemplo 4 — Email sequence (bonus)

```
/copy "Email sequence de 5 mensagens para reativação de leads frios de SaaS B2B — produto: ferramenta de project management R$ 197/mês — leads não engajam há 90+ dias"
```

**Esperado:** Copy Master invoca **Kennedy** (continuity + premium pricing positioning) + **Makepeace** (outcomes-first + fear/greed amplification para B2B churn) + **Bird** (integration brand+DR + multi-channel thinking). Entrega 5 emails com cadência (D+0, D+3, D+7, D+14, D+30 — cada um com angle distinto) + recommendation channel mix.

## Notas operacionais

- **Briefings vagos** — Copy Master vai esclarecer via 5-7 perguntas direcionadas antes de produzir; responda e ele continua
- **Briefings completos** — Copy Master pode produzir direto, sem perguntas
- **Você pode sugerir copywriters específicos** — ex.: `/copy "...sugiro Halbert + Bencivenga"` — Copy Master respeita a sugestão se fizer sentido para o brief
- **Lazy-load research** — agentes só leem `research/{nome}/` quando relevante ao briefing (NFR4); não há custo de contexto desnecessário no startup

## Referências

- Routing matrix: `docs/architecture/routing-matrix.md` (Story 4.4)
- Copy Master agent: `.claude/agents/copy-master.md` (Story 4.5)
- Copy Researcher agent: `.claude/agents/copy-researcher.md` (Story 4.2)
- Copy Reviewer agent: `.claude/agents/copy-reviewer.md` (Story 4.3)
- 15 copywriter agents: `.claude/agents/{halbert,schwartz,hopkins,caples,sugarman,kennedy,bencivenga,carlton,makepeace,collier,ogilvy,bernbach,burnett,abbott,bird}.md` (Stories 3.1-3.5 ✅ completed)
- 15 research dossiers: `research/{nome}/` (Epic 2 ✅ completed)
