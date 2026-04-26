'use strict';

/**
 * markdown-utils.js — helpers compartilhados entre validation scripts
 *
 * Exports:
 *   - parseFrontmatter(content): { frontmatter, body }
 *   - countWords(text): number
 *   - listMarkdownFiles(dir): string[] (recursive)
 *   - listSubdirs(dir): string[] (non-recursive)
 *
 * Source refs:
 *   - Architecture §3.2 (Agent File Format YAML frontmatter + body)
 *   - Architecture §8.5 (CommonJS + Node 20+)
 *   - ADR-021 (js-yaml@^4.1.0)
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

/**
 * Separa YAML frontmatter (entre delimitadores `---`) do body markdown.
 * Retorna { frontmatter, body }. Se não houver frontmatter, frontmatter=null e body=content.
 *
 * @throws Error se YAML for mal-formado
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

module.exports = {
  parseFrontmatter,
  countWords,
  listMarkdownFiles,
  listSubdirs,
};
