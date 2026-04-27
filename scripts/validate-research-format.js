#!/usr/bin/env node
/**
 * validate-research-format.js — Validação DEC-002 (sources schema)
 *
 * Para cada arquivo em research/{nome}/*.md valida:
 *   - Section "## Fontes" presente (case-insensitive)
 *   - ≥3 itens em numbered list após o header (NFR5)
 *   - Cada item match regex: `^\d+\.\s\*\*[^*]+\*\*\s—\s(https?://\S+)\s\(accessed\s\d{4}-\d{2}-\d{2}\)\s—\s.+$`
 *   - Accessed dates são YYYY-MM-DD válido (range 2024-01-01..hoje)
 *
 * Usage:
 *   node scripts/validate-research-format.js                # exit 1 em qualquer violation
 *   node scripts/validate-research-format.js --report-only  # sempre exit 0
 *   node scripts/validate-research-format.js --root <path>  # custom root
 *
 * Source refs:
 *   - PRD §6 Story 1.7 + Story 1.4 (CI workflow)
 *   - Architecture §3.4 (DEC-002 schema de fontes)
 *   - Architecture §5.3 Job 3 (validate-research-format)
 *   - ADR-002 (DEC-002 resolved)
 */

'use strict';

const fs = require('fs');
const path = require('path');
const { listSubdirs, listMarkdownFiles } = require('./lib/markdown-utils');

const SOURCES_REGEX = /^\d+\.\s\*\*[^*]+\*\*\s—\s(https?:\/\/\S+)\s\(accessed\s(\d{4}-\d{2}-\d{2})\)\s—\s.+$/;
const MIN_SOURCES = 3;
const MIN_DATE = '2024-01-01';

// Parse CLI args
const args = process.argv.slice(2);
const reportOnly = args.includes('--report-only');
const rootIdx = args.indexOf('--root');
const projectRoot = rootIdx >= 0 ? path.resolve(args[rootIdx + 1]) : process.cwd();

/**
 * Valida um research file. Retorna array de violations.
 */
function validateResearchFile(filePath, content) {
  const violations = [];

  // 1. Section "## Fontes" presente
  const fontesMatch = content.match(/##\s+Fontes\s*\n([\s\S]+?)(?=\n##\s|\n---|\s*$)/i);
  if (!fontesMatch) {
    violations.push({ rule: 'missing-fontes-section', message: 'Section `## Fontes` não encontrada' });
    return violations;
  }

  const fontesContent = fontesMatch[1];
  // Extrai itens de numbered list (começam com dígito + ponto)
  const itemLines = fontesContent.split('\n')
    .map(l => l.trim())
    .filter(l => /^\d+\.\s/.test(l));

  // 2. ≥3 itens
  if (itemLines.length < MIN_SOURCES) {
    violations.push({
      rule: 'insufficient-sources',
      message: `Apenas ${itemLines.length} fontes citadas (esperado ≥${MIN_SOURCES} per NFR5)`,
    });
  }

  // 3 + 4. Cada item match regex + data válida
  const today = new Date();
  today.setHours(23, 59, 59, 999);
  const minDate = new Date(MIN_DATE);

  for (let i = 0; i < itemLines.length; i++) {
    const item = itemLines[i];
    const m = item.match(SOURCES_REGEX);
    if (!m) {
      violations.push({
        rule: 'invalid-format',
        message: `Item ${i + 1} mal-formatado (esperado \`N. **título** — URL (accessed YYYY-MM-DD) — relevância\`): ${item.substring(0, 100)}`,
      });
      continue;
    }
    const [, , dateStr] = m;
    const date = new Date(dateStr);
    if (isNaN(date.getTime()) || date < minDate || date > today) {
      violations.push({
        rule: 'invalid-date',
        message: `Item ${i + 1}: accessed date \`${dateStr}\` fora do range válido (${MIN_DATE} até hoje)`,
      });
    }
  }

  return violations;
}

/**
 * Main entry point.
 */
function main() {
  const researchDir = path.join(projectRoot, 'research');
  if (!fs.existsSync(researchDir)) {
    console.log('# Research Format Validation Report');
    console.log('');
    console.log(`**Project root:** \`${projectRoot}\``);
    console.log('');
    console.log('_Pasta `research/` não encontrada — nada a validar._');
    console.log('');
    console.log('✅ Research format validation passed.');
    process.exit(0);
  }

  const dossiers = listSubdirs(researchDir);
  const allResults = [];

  for (const dossierDir of dossiers) {
    const files = listMarkdownFiles(dossierDir);
    for (const file of files) {
      const content = fs.readFileSync(file, 'utf8');
      const violations = validateResearchFile(file, content);
      const relPath = path.relative(projectRoot, file);
      allResults.push({ file: relPath, violations });
    }
  }

  console.log('# Research Format Validation Report');
  console.log('');
  console.log(`**Project root:** \`${projectRoot}\``);
  console.log(`**Mode:** ${reportOnly ? 'report-only (exit 0 always)' : 'strict (exit 1 on FAIL)'}`);
  console.log('');
  console.log('## Files');
  console.log('');

  if (allResults.length === 0) {
    console.log('_Nenhum research file encontrado._');
  } else {
    console.log('| Arquivo | Violations | Status |');
    console.log('|---------|------------|--------|');
    for (const r of allResults) {
      const icon = r.violations.length === 0 ? '✅' : '❌';
      const status = r.violations.length === 0 ? 'PASS' : 'FAIL';
      console.log(`| \`${r.file}\` | ${r.violations.length} | ${icon} ${status} |`);
    }
  }

  const totalViolations = allResults.reduce((acc, r) => acc + r.violations.length, 0);
  const failedFiles = allResults.filter(r => r.violations.length > 0).length;

  console.log('');
  console.log('## Summary');
  console.log('');
  console.log(`- Total files: ${allResults.length}`);
  console.log(`- ✅ PASS: ${allResults.length - failedFiles}`);
  console.log(`- ❌ FAIL: ${failedFiles}`);
  console.log(`- Total violations: ${totalViolations}`);

  if (failedFiles > 0) {
    console.log('');
    console.log('## Violation Details');
    console.log('');
    for (const r of allResults.filter(x => x.violations.length > 0)) {
      console.log(`### \`${r.file}\``);
      console.log('');
      for (const v of r.violations) {
        console.log(`- **[${v.rule}]** ${v.message}`);
      }
      console.log('');
    }

    if (!reportOnly) {
      console.error('❌ Research format validation FAILED. Use --report-only to bypass.');
      process.exit(1);
    }
  }

  console.log('');
  console.log('✅ Research format validation passed.');
  process.exit(0);
}

main();
