# Routing Matrix — Copy Master Decision Table

> Referenciado pelo Copy Master (`.claude/agents/copy-master.md`, Story 4.5) no passo 2 do workflow (roteamento).
> Linkado de `docs/architecture/knowledge-base.md` como entrada principal de routing logic.

## Como ler

Cada linha é um **arquétipo de projeto**. Para cada arquétipo:

- **Squad sugerido** — 2-4 copywriters do roster de 15 agents (ou 1-2 + Researcher/Reviewer quando aplicável)
- **Justificativa** — 2 linhas explicando critério (mercado, sofisticação, formato, voz dominante)
- **Output esperado** — formato típico que sai do squad para esse arquétipo

Copy Master usa essa matriz como **starting point**. Sempre pode desviar com justificativa explícita ao usuário (ex.: "para esse brief específico, vou substituir Bencivenga por Makepeace porque vertical é fear-driven financial").

## Matriz

| # | Arquétipo de projeto | Squad sugerido | Justificativa | Output esperado |
|---|---------------------|----------------|---------------|-----------------|
| 1 | **Sales page longa (DR clássico)** — info-product, curso, programa $497-$2.997 | **Halbert + Sugarman + Bencivenga** | Halbert traz Florida-direct emotional; Sugarman traz slippery slide hipnose textual; Bencivenga traz proof stacking + believability engine. Trio cobre emoção + momentum + credibility. | Sales letter 3.000-8.000 palavras, 2 versões (uma mais aggressive, outra mais factual), nota da aposta, sugestões A/B headline+lead+CTA |
| 2 | **VSL lançamento** — vídeo 8-30 min, info-product premium $1.997-$9.997 | **Sugarman + Kennedy + Makepeace** | Sugarman traz slippery slide para roteiro; Kennedy traz Magnetic Marketing + premium pricing positioning; Makepeace traz outcomes-first opening + emotional escalation calibrada. Combo robusto para VSL premium. | Roteiro VSL 8-30 min, hook + storyline + product reveal + objection handling + CTA, com 2-3 variants de opening |
| 3 | **Headlines / capture page** — landing page de e-book gratuito, lead magnet, capture | **Caples + Sugarman + Bencivenga** | Caples traz 35 templates + headline-first methodology; Sugarman traz seeds of curiosity hooks; Bencivenga traz specificity engineering. Trio especialista em headline craft. | 20-30 headline variants categorizadas (curiosity, news, story, how-to, gee-whiz, etc.), recommendation A/B test setup, lead 50 palavras passa blink test |
| 4 | **Brand storytelling / positioning** — manifesto, posicionamento de marca, big idea | **Ogilvy + Bernbach + Burnett** | Ogilvy traz brand image philosophy + 38 perguntas; Bernbach traz creative revolution intellectual + visual+verbal fusion; Burnett traz inherent drama + character creation. Trio brand vertical canônico. | Manifesto de marca 500-1.500 palavras, 3 variations de tone (literary-aspirational / artisanal-warm / editorial-sophisticated), brand voice guidelines |
| 5 | **E-mail sequence** — onboarding, nurture, win-back, launch sequence | **Kennedy + Makepeace + Bird** | Kennedy traz continuity programs thinking + multiple P.S. agressivos; Makepeace traz outcomes-first + fear/greed amplification; Bird traz integration brand+DR + multi-channel + LTV thinking. Combo para sequências que constroem relacionamento. | Sequência 5-10 e-mails com cadência (D+0, D+3, D+7, D+14, D+30), cada um com angle distinto, recommendation channel mix |
| 6 | **Meta/Google Ads (paid social/search)** — anúncios curtos, alta rotação, A/B intensivo | **Caples + Sugarman + Halbert** | Caples traz 30-50 headlines testáveis; Sugarman traz slippery slide para mobile reading + ganchos curiosity; Halbert traz emotional rawness + ganchos brutais. Combo ad-driven com volume de variants. | 20-50 ad variants (headline + primary text + CTA) categorizadas por angle, recommendation budget allocation por variant |
| 7 | **Carta de renovação/reativação** — cliente lapsed, win-back, manutenção LTV | **Collier + Makepeace + Bird** | Collier traz "carta de amigo" elegante + relationship management heritage; Makepeace traz outcomes-first emocional; Bird traz LTV thinking + database segmentation. Trio especialista em retention. | Carta 800-2.500 palavras tom relacional + outcome reminder + offer especial, sequência opcional 2-3 emails follow-up |
| 8 | **Info-produto premium** — coaching, mastermind, programa $5K-$50K | **Kennedy + Bencivenga + Carlton** | Kennedy traz info-marketing model + premium pricing as filter; Bencivenga traz proof stacking + control philosophy + believability engine; Carlton traz Big Idea contraintuitiva + storytelling autêntico. Combo para tickets premium que exigem credibility + diferenciação. | Sales letter 8.000-15.000 palavras (ou VSL equivalente), value stack inflado, 4-6 bonus, garantia agressiva, multiple P.S., applicação seletiva |
| 9 | **Financial newsletter premium** — assinatura $99-$5.000/ano, vertical fear/greed driven | **Makepeace + Bencivenga + Bird** | Makepeace traz fear/greed amplification controlada + magalog architecture; Bencivenga traz proof stacking + control mindset; Bird traz integration brand+DR + LTV. Trio especialista financial publishing premium. | Magalog 32-64 páginas (ou sales letter equivalente em digital), guru featured + track record + janela de timing genuína |
| 10 | **Health/anti-aging product** — supplement, programa, livro premium | **Hopkins + Bencivenga + Makepeace** | Hopkins traz reason-why + scientific advertising + sampling; Bencivenga traz proof stacking médico + believability engine; Makepeace traz outcomes-first health + Health & Healing legacy. Trio especialista health vertical. | Sales letter ou magalog 5.000-15.000 palavras com mecanismo fisiológico explained, paciente cases nominais, science-backed claims |
| 11 | **Retail / consumer goods sophistication** — café especial, vinho, gourmet, premium consumer | **Ogilvy + Burnett + Abbott** | Ogilvy traz brand image cumulative + long-copy literário; Burnett traz inherent drama do produto cotidiano + Midwestern realism; Abbott traz UK editorial production excellence + retail brand sophistication (Sainsbury's heritage). | Brand manifesto + 5-10 ad variants + packaging copy + in-store materials, voz consistente multi-decade ready |
| 12 | **B2B SaaS / enterprise** — software, plataforma, B2B premium | **Bencivenga + Bird + Ogilvy** | Bencivenga traz proof stacking + USP refinement + control mindset; Bird traz integration brand+DR + multi-channel + LTV; Ogilvy traz brand image + research-driven creativity. Trio para B2B sophisticated audience cético. | Long-form sales page + email nurture + case studies, audience educated assumption, calmness factual sem hype |
| 13 | **Cause marketing / fundraising** — ONG, organização social, civic causes | **Abbott + Collier + Bernbach** | Abbott traz emotional storytelling em utility (J.R. Hartley heritage) + RSPCA cause marketing precedent; Collier traz "enter the conversation" + emotional appeals nuançados; Bernbach traz cultural transformation + diversity inclusive (Levy's heritage). | Carta de captação + email sequence + landing page com tone respeitoso emocional + action clarity + brand integrity |
| 14 | **Briefing vago / preciso de pesquisa primeiro** | **Researcher (only)** → depois reroute | Quando briefing carece de avatar/dores/linguagem nativa, invocar Copy Researcher antes de qualquer copywriter. Researcher entrega dossiê 7-seções que vira input para reroute correto. | Dossiê estruturado 7 seções → Copy Master rerruta com info de avatar para 2-4 copywriters apropriados |

## Notas operacionais

### Default fallback

Quando arquétipo não cabe perfeitamente em nenhuma linha, default é:
- **Vertical DR** com elemento emocional → **Halbert + Sugarman + Bencivenga** (trio versátil)
- **Vertical Brand** ou positioning → **Ogilvy + Bernbach + Abbott** (trio brand versátil)

### Substituição justificada

Copy Master sempre pode substituir copywriters do squad sugerido com **justificativa explícita** ao usuário. Exemplos válidos:

- **Vertical financial fear-driven**: substituir Bencivenga (calmly factual) por **Makepeace** (emotional visceral controlada) — match melhor ao vertical
- **Vertical kid-friendly food brand**: substituir Bernbach (NYC creative revolution intellectual) por **Burnett** (Midwestern character-driven) — match cultural correto
- **Vertical UK audience**: substituir Ogilvy (US-UK hybrid) por **Abbott** (full UK literary) — voz mais alinhada

### Reviewer obrigatório

Independente do squad sugerido na matriz, **Copy Reviewer é invocado em 100% dos casos** no passo 6 do workflow (quality pass final). Routing matrix cobre apenas a **fase de draft** (passo 4), não a fase de revisão.

## Limites desta matriz

- **Não é exhaustive** — cobre 13 arquétipos comuns, mas projetos podem ser híbridos ou nicho
- **Não substitui briefing inteligente** — sempre rodar Copy Master step 1 (esclarecer produto + avatar + promessa + formato + tom + métrica) antes de aplicar matriz
- **Não substitui judgment** — matriz é starting point; Copy Master pode (e deve) desviar com justificativa quando contexto pede

## Versioning

| Date | Version | Change | Author |
|------|---------|--------|--------|
| 2026-04-27 | 1.0 | Matriz inicial criada — 13 arquétipos cobertos + 1 fallback (Researcher) + 8 obrigatórios PRD AC3 | @dev (Dex) |

## Cross-references

- **PRD**: docs/prd.md#story-44-routing-matrix (FR15)
- **Architecture**: docs/architecture.md#13-quality-attributes
- **Knowledge base**: docs/architecture/knowledge-base.md (linkado lá)
- **Copy Master agent**: .claude/agents/copy-master.md (Story 4.5 — referência primária no system prompt)
- **15 copywriter agents**: .claude/agents/{halbert,schwartz,hopkins,caples,sugarman,kennedy,bencivenga,carlton,makepeace,collier,ogilvy,bernbach,burnett,abbott,bird}.md
- **Support agents**: .claude/agents/{copy-researcher,copy-reviewer}.md
- **15 research dossiers**: research/{nome}/
