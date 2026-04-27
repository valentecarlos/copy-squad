# Knowledge Base — Index

> Documento de discovery para os arquivos de `.claude/agents/_shared/`.
> Os 15 copywriters do squad referenciam esses arquivos como base de conhecimento compartilhada.

## Arquivos disponíveis

### `frameworks.md`

[`/.claude/agents/_shared/frameworks.md`](../../.claude/agents/_shared/frameworks.md)

8 frameworks consolidados de copywriting com definição, quando usar, exemplo concreto e atribuição:
AIDA, PAS, 4 U's, 5 Estágios de Consciência (Schwartz), 5 Níveis de Sofisticação de Mercado (Schwartz), Slippery Slide (Sugarman), Inherent Drama (Burnett), Reason-Why (Hopkins).

≥ 2.500 palavras de body. Adicionado em **Story 1.5**.

### `glossario.md`

[`/.claude/agents/_shared/glossario.md`](../../.claude/agents/_shared/glossario.md)

**41 termos canônicos PT-BR** de copywriting com definição, sinônimos, uso típico e cross-references:
big idea, lead, kicker, USP, headline, subhead, hook, gatilhos psicológicos (escassez, prova social, autoridade, reciprocidade, compromisso, afinidade), garantia (incondicional/condicional), urgência, oferta, stack de bônus, CTA, P.S., closer, features, benefits, advertorial, controle, swipe file, magnetic copy, VSL, avatar, direct response, promessa, bullets, curiosity gap, copy, long copy.

**2.408 palavras**, ordenação alfabética A → Z. Adicionado em **Story 1.6** (commit referenciado no Change Log do glossário).

## Convenções

- Arquivos em `_shared/` são **knowledge base**, não agent files
- Sem YAML frontmatter de schema agent (não têm `name`, `tools`, `type`, etc.)
- Validados por `validate-density.js` (NFR1 ≥600 words minimum) e `encoding-check`
- **Não** validados por `validate-structure.js` (que é específico para agent files)
- Linguagem: PT-BR nativo (NFR9), terminologia técnica em inglês preservada (`headline`, `lead`, `USP`)

## Cross-references

- [`docs/architecture.md#3.1`](../architecture.md#31-folder-structure-canônica) — Folder structure
- [`docs/architecture.md#3.5`](../architecture.md#35-shared-knowledge-base-format) — Schema format dos shared files
- [`docs/architecture.md#5.3`](../architecture.md#53-job-specifications) — Validation pipeline (jobs CI)
