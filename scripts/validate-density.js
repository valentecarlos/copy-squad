#!/usr/bin/env node
/**
 * validate-density.js — NFR1 (≥600 palavras/agente) + NFR2 (≥3500 palavras/dossier)
 *
 * Valida densidade de:
 *   - .claude/agents/*.md e .claude/agents/_shared/*.md (NFR1: ≥600 palavras body)
 *   - research/{nome}/*.md agregados por dossier (NFR2: ≥3500 palavras)
 *
 * Usage:
 *   node scripts/validate-density.js                 # exit 1 se qualquer FAIL
 *   node scripts/validate-density.js --report-only   # sempre exit 0, só relatório
 *   node scripts/validate-density.js --root <path>   # custom root (default: cwd)
 *
 * Source refs:
 *   - PRD §6 Story 1.2 (8 ACs)
 *   - Architecture §5.3 (CI job validate-density)
 *   - Architecture §8.5 (CommonJS + Node 20+)
 *   - ADR-021 (js-yaml@^4.1.0 única dep externa)
 */

'use strict';

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const NFR1_MIN_WORDS = 600;   // agent system prompt
const NFR2_MIN_WORDS = 3500;  // research dossier (sum of *.md files)
const WARN_MARGIN = 0.10;     // 10% acima do limit = WARN

// Parse CLI args
const args = process.argv.slice(2);
const reportOnly = args.includes('--report-only');
const rootIdx = args.indexOf('--root');
const projectRoot = rootIdx >= 0 ? path.resolve(args[rootIdx + 1]) : process.cwd();

/**
 * Separa YAML frontmatter (entre delimitadores `---`) do body markdown.
 * Retorna { frontmatter, body }. Se não houver frontmatter, frontmatter=null e body=content.
 */
function parseFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (match) {
    let frontmatter = null;
    try {
      frontmatter = yaml.load(match[1]);
    } catch (err) {
      throw new Error(`YAML parse error: ${err.message}`);
    }
    return { frontmatter, body: match[2] };
  }
  return { frontmatter: null, body: content };
}

/**
 * Conta palavras: split por whitespace, filtra strings vazias.
 */
function countWords(text) {
  if (!text) return 0;
  return text.trim().split(/\s+/).filter(Boolean).length;
}

/**
 * Determina status: PASS (≥ limit), WARN (entre limit e limit+10%), FAIL (< limit).
 */
function getStatus(words, limit) {
  if (words < limit) return 'FAIL';
  if (words < limit * (1 + WARN_MARGIN)) return 'WARN';
  return 'PASS';
}

/**
 * Recursive directory listing (Node stdlib only — sem dep glob).
 * Retorna array de full paths para arquivos com extensão .md (exclui .gitkeep).
 */
function listMarkdownFiles(dir) {
  const results = [];
  if (!fs.existsSync(dir)) return results;

  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...listMarkdownFiles(full));
    } else if (entry.isFile() && entry.name.endsWith('.md') && entry.name !== '.gitkeep') {
      results.push(full);
    }
  }
  return results;
}

/**
 * Lista subdirectories diretos (não-recursivo).
 */
function listSubdirs(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true })
    .filter(e => e.isDirectory())
    .map(e => path.join(dir, e.name));
}

/**
 * Valida agentes (NFR1).
 * Lê .md de agents/ e agents/_shared/, conta palavras do body, compara com NFR1_MIN_WORDS.
 */
function validateAgents(root) {
  const dirs = [
    path.join(root, '.claude/agents'),
    path.join(root, '.claude/agents/_shared'),
  ];
  const results = [];

  for (const dir of dirs) {
    if (!fs.existsSync(dir)) continue;
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      if (entry.isFile() && entry.name.endsWith('.md')) {
        const fullPath = path.join(dir, entry.name);
        const content = fs.readFileSync(fullPath, 'utf8');
        const { body } = parseFrontmatter(content);
        const words = countWords(body);
        const status = getStatus(words, NFR1_MIN_WORDS);
        const relPath = path.relative(root, fullPath);
        results.push({ file: relPath, words, status, limit: NFR1_MIN_WORDS });
      }
    }
  }
  return results;
}

/**
 * Valida dossiers (NFR2).
 * Para cada subdirectory de research/, soma palavras de todos os *.md dentro.
 */
function validateDossiers(root) {
  const researchDir = path.join(root, 'research');
  const results = [];
  const dossiers = listSubdirs(researchDir);

  for (const dossierDir of dossiers) {
    const files = listMarkdownFiles(dossierDir);
    if (files.length === 0) continue; // skip empty dossiers (only .gitkeep)

    let totalWords = 0;
    for (const file of files) {
      const content = fs.readFileSync(file, 'utf8');
      const { body } = parseFrontmatter(content);
      totalWords += countWords(body);
    }

    const dossierName = path.basename(dossierDir);
    const status = getStatus(totalWords, NFR2_MIN_WORDS);
    results.push({
      dossier: dossierName,
      file_count: files.length,
      words: totalWords,
      status,
      limit: NFR2_MIN_WORDS,
    });
  }
  return results;
}

/**
 * Renderiza tabela markdown.
 */
function renderAgentsTable(rows) {
  if (rows.length === 0) return '_Nenhum agente encontrado._\n';
  let out = '| Arquivo | Palavras | Limite | Status |\n';
  out += '|---------|----------|--------|--------|\n';
  for (const r of rows) {
    const icon = r.status === 'PASS' ? '✅' : r.status === 'WARN' ? '⚠️' : '❌';
    out += `| \`${r.file}\` | ${r.words} | ${r.limit} | ${icon} ${r.status} |\n`;
  }
  return out;
}

function renderDossiersTable(rows) {
  if (rows.length === 0) return '_Nenhum dossier encontrado._\n';
  let out = '| Dossier | Files | Palavras (total) | Limite | Status |\n';
  out += '|---------|-------|------------------|--------|--------|\n';
  for (const r of rows) {
    const icon = r.status === 'PASS' ? '✅' : r.status === 'WARN' ? '⚠️' : '❌';
    out += `| \`research/${r.dossier}/\` | ${r.file_count} | ${r.words} | ${r.limit} | ${icon} ${r.status} |\n`;
  }
  return out;
}

/**
 * Main entry point.
 */
function main() {
  let agentResults, dossierResults;
  try {
    agentResults = validateAgents(projectRoot);
    dossierResults = validateDossiers(projectRoot);
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(2);
  }

  console.log('# Density Validation Report');
  console.log('');
  console.log(`**Project root:** \`${projectRoot}\``);
  console.log(`**Mode:** ${reportOnly ? 'report-only (exit 0 always)' : 'strict (exit 1 on FAIL)'}`);
  console.log('');
  console.log('## Agents (NFR1 — ≥600 palavras body)');
  console.log('');
  console.log(renderAgentsTable(agentResults));
  console.log('## Dossiers (NFR2 — ≥3500 palavras agregadas)');
  console.log('');
  console.log(renderDossiersTable(dossierResults));

  const allResults = [...agentResults, ...dossierResults];
  const failures = allResults.filter(r => r.status === 'FAIL');
  const warnings = allResults.filter(r => r.status === 'WARN');

  console.log('## Summary');
  console.log('');
  console.log(`- Total checks: ${allResults.length}`);
  console.log(`- ✅ PASS: ${allResults.filter(r => r.status === 'PASS').length}`);
  console.log(`- ⚠️  WARN: ${warnings.length}`);
  console.log(`- ❌ FAIL: ${failures.length}`);
  console.log('');

  if (failures.length > 0) {
    console.log('### Failures');
    console.log('');
    for (const f of failures) {
      const name = f.file || `research/${f.dossier}/`;
      console.log(`- ❌ \`${name}\` — ${f.words} palavras (esperado ≥${f.limit})`);
    }
    console.log('');

    if (!reportOnly) {
      console.error('❌ Density validation FAILED. Use --report-only to bypass.');
      process.exit(1);
    }
  }

  console.log('✅ Density validation passed.');
  process.exit(0);
}

main();
