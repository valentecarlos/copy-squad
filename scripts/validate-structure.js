#!/usr/bin/env node
/**
 * validate-structure.js — Validação de YAML frontmatter dos agentes
 *
 * Aplica schema canônico:
 *   - Required fields (name, description, tools, type, specialty, research_path, language)
 *   - type ∈ {orchestrator, copywriter, researcher, reviewer}
 *   - specialty ∈ {direct-response, brand, orchestrator, support}
 *   - tools ⊂ ALLOWED_TOOLS_BY_TYPE[type]
 *   - Apenas type=orchestrator pode ter Agent (anti-recursion)
 *   - name único entre todos os agentes
 *   - body referencia research/{name}/ (FR5)
 *   - language: pt-BR (NFR9)
 *
 * Usage:
 *   node scripts/validate-structure.js                # exit 1 em qualquer violation
 *   node scripts/validate-structure.js --report-only  # sempre exit 0
 *   node scripts/validate-structure.js --root <path>  # custom root
 *
 * Source refs:
 *   - PRD §6 Story 1.3 (8 ACs)
 *   - Architecture §3.2 (Agent File Format)
 *   - Architecture §4.2 (Tool Authorization Matrix)
 *   - Architecture §4.4 (Threat Model — anti-recursion)
 *   - ADR-003 (DEC-003 resolved)
 */

'use strict';

const fs = require('fs');
const path = require('path');
const { parseFrontmatter } = require('./lib/markdown-utils');

const REQUIRED_FIELDS = [
  'name',
  'description',
  'tools',
  'type',
  'specialty',
  'research_path',
  'language',
];

const VALID_TYPES = ['orchestrator', 'copywriter', 'researcher', 'reviewer'];

const VALID_SPECIALTIES = ['direct-response', 'brand', 'orchestrator', 'support'];

const ALLOWED_TOOLS_BY_TYPE = {
  orchestrator: ['Read', 'Grep', 'Glob', 'Agent', 'TodoWrite'],
  copywriter:   ['Read', 'Grep'],
  researcher:   ['Read', 'Grep', 'Write', 'WebSearch', 'WebFetch'],
  reviewer:     ['Read', 'Grep'],
};

// Parse CLI args
const args = process.argv.slice(2);
const reportOnly = args.includes('--report-only');
const rootIdx = args.indexOf('--root');
const projectRoot = rootIdx >= 0 ? path.resolve(args[rootIdx + 1]) : process.cwd();

/**
 * Valida um agente individual. Retorna array de violations encontradas.
 * Cada violation: { rule, message }
 */
function validateAgent(filePath, content, allNames) {
  const violations = [];
  let parsed;

  // Validation 1: YAML frontmatter parseável
  try {
    parsed = parseFrontmatter(content);
  } catch (err) {
    violations.push({ rule: 'yaml-parse', message: err.message });
    return violations;
  }

  if (!parsed.frontmatter) {
    violations.push({ rule: 'no-frontmatter', message: 'Frontmatter YAML ausente (esperado entre `---`)' });
    return violations;
  }

  const fm = parsed.frontmatter;
  const body = parsed.body;

  // Validation 2: Required fields presentes
  for (const field of REQUIRED_FIELDS) {
    if (fm[field] === undefined || fm[field] === null || fm[field] === '') {
      violations.push({ rule: 'required-field', message: `Campo obrigatório ausente ou vazio: \`${field}\`` });
    }
  }

  // Se faltam campos críticos, abortar restante das validations específicas
  if (!fm.type || !fm.tools) {
    return violations;
  }

  // Validation 3: type ∈ VALID_TYPES
  if (!VALID_TYPES.includes(fm.type)) {
    violations.push({ rule: 'invalid-type', message: `\`type: ${fm.type}\` inválido. Permitidos: ${VALID_TYPES.join(', ')}` });
  }

  // Validation 4: specialty ∈ VALID_SPECIALTIES
  if (fm.specialty && !VALID_SPECIALTIES.includes(fm.specialty)) {
    violations.push({ rule: 'invalid-specialty', message: `\`specialty: ${fm.specialty}\` inválido. Permitidos: ${VALID_SPECIALTIES.join(', ')}` });
  }

  // Validation 5: tools é array
  if (!Array.isArray(fm.tools)) {
    violations.push({ rule: 'tools-not-array', message: '`tools` deve ser array (YAML flow style: `[Read, Grep]`)' });
    return violations; // sem array, não dá pra validar conteúdo
  }

  // Validation 6: Tools ⊂ ALLOWED_TOOLS_BY_TYPE[type]
  const allowedForType = ALLOWED_TOOLS_BY_TYPE[fm.type];
  if (allowedForType) {
    for (const tool of fm.tools) {
      if (!allowedForType.includes(tool)) {
        violations.push({
          rule: 'tool-not-allowed',
          message: `Tool \`${tool}\` não permitida para \`type: ${fm.type}\`. Permitidas: ${allowedForType.join(', ')}`,
        });
      }
    }
  }

  // Validation 7: CRITICAL — Apenas orchestrator pode ter Agent
  if (fm.tools.includes('Agent') && fm.type !== 'orchestrator') {
    violations.push({
      rule: 'orphan-agent-tool',
      message: `Tool \`Agent\` apenas permitida para \`type: orchestrator\` (defesa anti-recursão, Architecture §4.4). Este agente é \`type: ${fm.type}\`.`,
    });
  }

  // Validation 8: name único
  if (fm.name) {
    if (allNames.has(fm.name)) {
      violations.push({
        rule: 'duplicate-name',
        message: `\`name: ${fm.name}\` já está em uso por outro agente (collision detected)`,
      });
    } else {
      allNames.add(fm.name);
    }
  }

  // Validation 9: body referencia research/{name}/ (FR5)
  if (fm.name && body) {
    const researchPattern = new RegExp(`research/${fm.name}/`);
    if (!researchPattern.test(body)) {
      violations.push({
        rule: 'fr5-no-research-ref',
        message: `Body do agente não referencia \`research/${fm.name}/\` (FR5 enforcement). Adicione pelo menos 1 menção.`,
      });
    }
  }

  // Validation 10: language: pt-BR (NFR9)
  if (fm.language && fm.language !== 'pt-BR') {
    violations.push({
      rule: 'language-not-pt-br',
      message: `\`language: ${fm.language}\` deveria ser \`pt-BR\` (NFR9). Suporte a outros idiomas é capability on-demand, não default.`,
    });
  }

  return violations;
}

/**
 * Lista todos os arquivos .md em .claude/agents/ (incluindo _shared/).
 */
function listAgentFiles(root) {
  const dirs = [
    path.join(root, '.claude/agents'),
    path.join(root, '.claude/agents/_shared'),
  ];
  const files = [];

  for (const dir of dirs) {
    if (!fs.existsSync(dir)) continue;
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      if (entry.isFile() && entry.name.endsWith('.md') && entry.name !== '.gitkeep') {
        files.push(path.join(dir, entry.name));
      }
    }
  }
  return files;
}

/**
 * Renderiza tabela de resultados.
 */
function renderTable(results) {
  if (results.length === 0) return '_Nenhum agente encontrado._\n';
  let out = '| Arquivo | Violations | Status |\n';
  out += '|---------|------------|--------|\n';
  for (const r of results) {
    const icon = r.violations.length === 0 ? '✅' : '❌';
    const status = r.violations.length === 0 ? 'PASS' : 'FAIL';
    out += `| \`${r.file}\` | ${r.violations.length} | ${icon} ${status} |\n`;
  }
  return out;
}

/**
 * Renderiza detalhes das violations.
 */
function renderViolations(results) {
  const failed = results.filter(r => r.violations.length > 0);
  if (failed.length === 0) return '';

  let out = '\n## Violation Details\n\n';
  for (const r of failed) {
    out += `### \`${r.file}\`\n\n`;
    for (const v of r.violations) {
      out += `- **[${v.rule}]** ${v.message}\n`;
    }
    out += '\n';
  }
  return out;
}

/**
 * Main entry point.
 */
function main() {
  let agentFiles;
  try {
    agentFiles = listAgentFiles(projectRoot);
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(2);
  }

  const allNames = new Set();
  const results = [];

  for (const file of agentFiles) {
    const content = fs.readFileSync(file, 'utf8');
    const violations = validateAgent(file, content, allNames);
    const relPath = path.relative(projectRoot, file);
    results.push({ file: relPath, violations });
  }

  console.log('# Structure Validation Report');
  console.log('');
  console.log(`**Project root:** \`${projectRoot}\``);
  console.log(`**Mode:** ${reportOnly ? 'report-only (exit 0 always)' : 'strict (exit 1 on FAIL)'}`);
  console.log('');
  console.log('## Agents');
  console.log('');
  console.log(renderTable(results));

  const totalViolations = results.reduce((acc, r) => acc + r.violations.length, 0);
  const failedFiles = results.filter(r => r.violations.length > 0).length;

  console.log('## Summary');
  console.log('');
  console.log(`- Total agents: ${results.length}`);
  console.log(`- ✅ PASS: ${results.length - failedFiles}`);
  console.log(`- ❌ FAIL: ${failedFiles}`);
  console.log(`- Total violations: ${totalViolations}`);

  if (failedFiles > 0) {
    console.log(renderViolations(results));

    if (!reportOnly) {
      console.error('❌ Structure validation FAILED. Use --report-only to bypass.');
      process.exit(1);
    }
  }

  console.log('\n✅ Structure validation passed.');
  process.exit(0);
}

main();
