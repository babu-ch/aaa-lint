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

module.exports = {
  meta: {
    type: 'suggestion',
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
      missing: 'Missing "{{section}}" comment in test block.',
      order: 'AAA comments must appear in order: arrange → act → assert (found "{{found}}" after "{{previous}}").',
      empty: 'Section "{{section}}" has no statements.',
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

        for (const section of SECTIONS) {
          if (!seen[section]) {
            context.report({ node, messageId: 'missing', data: { section } })
            return
          }
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
