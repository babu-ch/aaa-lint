'use strict'

const { RuleTester } = require('eslint')
const rule = require('../src/rules/pattern')

const ruleTester = new RuleTester({
  languageOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
  },
})

ruleTester.run('pattern', rule, {
  valid: [
    {
      code: `
        it('adds', () => {
          // arrange
          const a = 1
          // act
          const b = a + 1
          // assert
          expect(b).toBe(2)
        })
      `,
    },
    {
      code: `
        test('works', () => {
          // arrange
          const x = 1
          // act
          const y = x
          // assert
          expect(y).toBe(1)
        })
      `,
    },
    {
      code: `
        it('gwt', () => {
          // given
          const a = 1
          // when
          const b = a + 1
          // then
          expect(b).toBe(2)
        })
      `,
      options: [
        {
          labels: {
            arrange: ['given'],
            act: ['when'],
            assert: ['then'],
          },
        },
      ],
    },
    {
      code: `
        it('jp', () => {
          // 準備
          const a = 1
          // 実行
          const b = a + 1
          // 検証
          expect(b).toBe(2)
        })
      `,
      options: [
        {
          labels: {
            arrange: ['準備', '前準備'],
            act: ['実行'],
            assert: ['検証', '確認'],
          },
        },
      ],
    },
    {
      code: `
        it('case insensitive by default', () => {
          // ARRANGE
          const a = 1
          // Act
          const b = a
          // assert
          expect(b).toBe(1)
        })
      `,
    },
    {
      code: `
        it('non-test call is ignored', () => {
          // arrange
          const a = 1
          // act
          const b = a
          // assert
          expect(b).toBe(1)
        })
        describe('group', () => {
          const shared = 1
        })
      `,
    },
  ],

  invalid: [
    {
      // Only arrange missing — message IDs pinpoint which section
      code: `
        it('missing arrange', () => {
          // act
          const a = 1
          // assert
          expect(a).toBe(1)
        })
      `,
      errors: [{ messageId: 'missingArrange' }],
    },
    {
      code: `
        it('missing assert', () => {
          // arrange
          const a = 1
          // act
          const b = a
        })
      `,
      errors: [{ messageId: 'missingAssert' }],
    },
    {
      // Two missing — one error per missing section
      code: `
        it('missing two', () => {
          // arrange
          const a = 1
        })
      `,
      errors: [{ messageId: 'missingAct' }, { messageId: 'missingAssert' }],
    },
    {
      // All three missing — auto-fixable with a scaffold template
      code:
        "it('all missing', () => {\n" +
        '  const a = 1\n' +
        '  const b = a + 1\n' +
        '  expect(b).toBe(2)\n' +
        '})\n',
      errors: [{ messageId: 'missingAll' }],
      output:
        "it('all missing', () => {\n" +
        '  // arrange\n' +
        '  // act\n' +
        '  // assert\n' +
        '  const a = 1\n' +
        '  const b = a + 1\n' +
        '  expect(b).toBe(2)\n' +
        '})\n',
    },
    {
      // Auto-fix uses the configured labels, not the English defaults
      code:
        "it('all missing jp', () => {\n" +
        '  const a = 1\n' +
        '  expect(a).toBe(1)\n' +
        '})\n',
      options: [
        {
          labels: {
            arrange: ['準備'],
            act: ['実行'],
            assert: ['検証'],
          },
        },
      ],
      errors: [{ messageId: 'missingAll' }],
      output:
        "it('all missing jp', () => {\n" +
        '  // 準備\n' +
        '  // 実行\n' +
        '  // 検証\n' +
        '  const a = 1\n' +
        '  expect(a).toBe(1)\n' +
        '})\n',
    },
    {
      code: `
        it('wrong order', () => {
          // act
          const b = 1
          // arrange
          const a = 0
          // assert
          expect(b).toBe(1)
        })
      `,
      errors: [{ messageId: 'order' }],
    },
    {
      code: `
        it('empty arrange section', () => {
          // arrange
          // act
          const a = 1
          // assert
          expect(a).toBe(1)
        })
      `,
      options: [{ allowEmptySection: false }],
      errors: [{ messageId: 'empty', data: { section: 'arrange' } }],
    },
    {
      code: `
        it('case sensitive rejects uppercase', () => {
          // ARRANGE
          const a = 1
          // act
          const b = a
          // assert
          expect(b).toBe(1)
        })
      `,
      options: [{ caseSensitive: true }],
      errors: [{ messageId: 'missingArrange' }],
    },
  ],
})

console.log('pattern rule: all tests passed')
