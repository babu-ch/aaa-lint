'use strict'

const SECTIONS = ['arrange', 'act', 'assert']

const DEFAULT_OPTIONS = {
  labels: {
    arrange: ['arrange'],
    act: ['act'],
    assert: ['assert'],
  },
  testFunctions: ['it', 'test'],
  caseSensitive: false,
  allowEmptySection: true,
}

function normalizeOptions(raw) {
  const opts = { ...DEFAULT_OPTIONS, ...(raw || {}) }
  opts.labels = { ...DEFAULT_OPTIONS.labels, ...((raw && raw.labels) || {}) }
  return opts
}

function matchSection(commentText, labels, caseSensitive) {
  const text = commentText.trim()
  const target = caseSensitive ? text : text.toLowerCase()
  for (const section of SECTIONS) {
    const candidates = labels[section] || []
    for (const label of candidates) {
      const normalized = caseSensitive ? label : label.toLowerCase()
      if (target === normalized) return section
    }
  }
  return null
}

function getTestCallback(node) {
  if (node.arguments.length === 0) return null
  const last = node.arguments[node.arguments.length - 1]
  if (last.type === 'ArrowFunctionExpression' || last.type === 'FunctionExpression') {
    if (last.body && last.body.type === 'BlockStatement') return last
  }
  return null
}

function getCalleeName(node) {
  const callee = node.callee
  if (callee.type === 'Identifier') return callee.name
  if (callee.type === 'MemberExpression' && callee.property && callee.property.type === 'Identifier') {
    return callee.property.name
  }
  return null
}

// Preferred label used when the rule inserts new comments.
function preferredLabel(labels, section) {
  return (labels[section] && labels[section][0]) || section
}

// Indentation to use inside the block body. Picks up the first statement's
// leading whitespace if present, otherwise the block-opening line's indent + 2.
function bodyIndent(sourceCode, body) {
  if (body.body.length > 0) {
    const firstStmt = body.body[0]
    const text = sourceCode.getText()
    let i = firstStmt.range[0] - 1
    while (i >= 0 && (text[i] === ' ' || text[i] === '\t')) i--
    return text.slice(i + 1, firstStmt.range[0])
  }
  // Fallback: indent of the `{` line + two spaces.
  const openToken = sourceCode.getFirstToken(body)
  const line = sourceCode.lines[openToken.loc.start.line - 1] || ''
  const lead = line.match(/^\s*/)[0]
  return lead + '  '
}

module.exports = {
  meta: {
    type: 'suggestion',
    fixable: 'code',
    docs: {
      description: 'Enforce Arrange-Act-Assert comments in test blocks',
      recommended: false,
    },
    schema: [
      {
        type: 'object',
        additionalProperties: false,
        properties: {
          labels: {
            type: 'object',
            additionalProperties: false,
            properties: {
              arrange: { type: 'array', items: { type: 'string' } },
              act: { type: 'array', items: { type: 'string' } },
              assert: { type: 'array', items: { type: 'string' } },
            },
          },
          testFunctions: { type: 'array', items: { type: 'string' } },
          caseSensitive: { type: 'boolean' },
          allowEmptySection: { type: 'boolean' },
        },
      },
    ],
    messages: {
      missingAll:
        'Missing arrange/act/assert section comments. Insert `// {{arrange}}`, `// {{act}}`, and `// {{assert}}` to mark each section — auto-fix will scaffold a template at the top of the block.',
      missingArrange:
        'Missing "arrange" comment. Insert `// {{label}}` before the code that sets up test state.',
      missingAct:
        'Missing "act" comment. Insert `// {{label}}` before the code that triggers the behavior under test.',
      missingAssert:
        'Missing "assert" comment. Insert `// {{label}}` before the code that verifies the result.',
      order:
        'AAA comments must appear in order: arrange → act → assert. Found "{{found}}" after "{{previous}}" — move "{{found}}" down or "{{previous}}" up.',
      empty:
        'Section "{{section}}" has no statements. Add code between `// {{section}}` and the next section, or remove the `// {{section}}` comment if the section is not needed.',
    },
  },

  create(context) {
    const options = normalizeOptions(context.options[0])
    const sourceCode = context.sourceCode || context.getSourceCode()

    return {
      CallExpression(node) {
        const name = getCalleeName(node)
        if (!name || !options.testFunctions.includes(name)) return

        const fn = getTestCallback(node)
        if (!fn) return

        const body = fn.body
        const comments = sourceCode.getCommentsInside(body)

        const found = []
        for (const c of comments) {
          const section = matchSection(c.value, options.labels, options.caseSensitive)
          if (section) found.push({ section, comment: c })
        }

        const seen = {}
        for (const entry of found) {
          if (!seen[entry.section]) seen[entry.section] = entry
        }

        const missing = SECTIONS.filter((s) => !seen[s])

        if (missing.length === SECTIONS.length) {
          const labels = {
            arrange: preferredLabel(options.labels, 'arrange'),
            act: preferredLabel(options.labels, 'act'),
            assert: preferredLabel(options.labels, 'assert'),
          }
          context.report({
            node,
            messageId: 'missingAll',
            data: labels,
            fix(fixer) {
              const openBrace = sourceCode.getFirstToken(body)
              const indent = bodyIndent(sourceCode, body)
              const template =
                `\n${indent}// ${labels.arrange}\n` +
                `${indent}// ${labels.act}\n` +
                `${indent}// ${labels.assert}`
              return fixer.insertTextAfter(openBrace, template)
            },
          })
          return
        }

        if (missing.length > 0) {
          for (const section of missing) {
            context.report({
              node,
              messageId:
                section === 'arrange'
                  ? 'missingArrange'
                  : section === 'act'
                  ? 'missingAct'
                  : 'missingAssert',
              data: { label: preferredLabel(options.labels, section) },
            })
          }
          return
        }

        const orderedSections = [seen.arrange, seen.act, seen.assert]
        for (let i = 1; i < orderedSections.length; i++) {
          const prev = orderedSections[i - 1]
          const curr = orderedSections[i]
          if (curr.comment.range[0] < prev.comment.range[1]) {
            context.report({
              node: curr.comment,
              messageId: 'order',
              data: { found: curr.section, previous: prev.section },
            })
            return
          }
        }

        if (!options.allowEmptySection) {
          const boundaries = [
            { section: 'arrange', start: seen.arrange.comment.range[1], end: seen.act.comment.range[0] },
            { section: 'act', start: seen.act.comment.range[1], end: seen.assert.comment.range[0] },
            { section: 'assert', start: seen.assert.comment.range[1], end: body.range[1] - 1 },
          ]
          for (const b of boundaries) {
            const hasStatement = body.body.some(
              (stmt) => stmt.range[0] >= b.start && stmt.range[1] <= b.end,
            )
            if (!hasStatement) {
              context.report({
                node: seen[b.section].comment,
                messageId: 'empty',
                data: { section: b.section },
              })
            }
          }
        }
      },
    }
  },
}
