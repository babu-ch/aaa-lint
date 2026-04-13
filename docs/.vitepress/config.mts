import { defineConfig, type DefaultTheme } from 'vitepress'

const guideSidebar = (prefix: string, labels: {
  gettingStarted: string
  eslint: string
  rubocop: string
  phpcs: string
  guide: string
}): DefaultTheme.SidebarItem[] => [
  {
    text: labels.guide,
    items: [
      { text: labels.gettingStarted, link: `${prefix}/guide/getting-started` },
      { text: labels.eslint, link: `${prefix}/guide/eslint` },
      { text: labels.rubocop, link: `${prefix}/guide/rubocop` },
      { text: labels.phpcs, link: `${prefix}/guide/phpcs` }
    ]
  }
]

export default defineConfig({
  title: 'aaa-lint',
  description: 'Enforce the Arrange-Act-Assert pattern in your tests.',
  base: '/aaa-lint/',
  cleanUrls: true,
  lastUpdated: true,

  head: [
    ['link', { rel: 'icon', href: '/aaa-lint/favicon.svg', type: 'image/svg+xml' }]
  ],

  themeConfig: {
    socialLinks: [
      { icon: 'github', link: 'https://github.com/babu-ch/aaa-lint' }
    ],
    search: { provider: 'local' }
  },

  locales: {
    root: {
      label: 'English',
      lang: 'en',
      link: '/',
      themeConfig: {
        nav: [
          { text: 'Guide', link: '/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('', {
          guide: 'Guide',
          gettingStarted: 'Getting Started',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: 'Previous', next: 'Next' }
      }
    },
    ja: {
      label: '日本語',
      lang: 'ja',
      link: '/ja/',
      themeConfig: {
        nav: [
          { text: 'ガイド', link: '/ja/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/ja', {
          guide: 'ガイド',
          gettingStarted: 'はじめに',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: '前のページ', next: '次のページ' }
      }
    },
    zh: {
      label: '中文',
      lang: 'zh',
      link: '/zh/',
      themeConfig: {
        nav: [
          { text: '指南', link: '/zh/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/zh', {
          guide: '指南',
          gettingStarted: '快速开始',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: '上一页', next: '下一页' }
      }
    },
    ko: {
      label: '한국어',
      lang: 'ko',
      link: '/ko/',
      themeConfig: {
        nav: [
          { text: '가이드', link: '/ko/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/ko', {
          guide: '가이드',
          gettingStarted: '시작하기',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: '이전', next: '다음' }
      }
    },
    es: {
      label: 'Español',
      lang: 'es',
      link: '/es/',
      themeConfig: {
        nav: [
          { text: 'Guía', link: '/es/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/es', {
          guide: 'Guía',
          gettingStarted: 'Primeros pasos',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: 'Anterior', next: 'Siguiente' }
      }
    },
    fr: {
      label: 'Français',
      lang: 'fr',
      link: '/fr/',
      themeConfig: {
        nav: [
          { text: 'Guide', link: '/fr/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/fr', {
          guide: 'Guide',
          gettingStarted: 'Démarrage',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: 'Précédent', next: 'Suivant' }
      }
    },
    de: {
      label: 'Deutsch',
      lang: 'de',
      link: '/de/',
      themeConfig: {
        nav: [
          { text: 'Leitfaden', link: '/de/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/de', {
          guide: 'Leitfaden',
          gettingStarted: 'Erste Schritte',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: 'Vorherige', next: 'Nächste' }
      }
    },
    pt: {
      label: 'Português',
      lang: 'pt',
      link: '/pt/',
      themeConfig: {
        nav: [
          { text: 'Guia', link: '/pt/guide/getting-started' },
          { text: 'GitHub', link: 'https://github.com/babu-ch/aaa-lint' }
        ],
        sidebar: guideSidebar('/pt', {
          guide: 'Guia',
          gettingStarted: 'Primeiros passos',
          eslint: 'ESLint (JS / TS)',
          rubocop: 'RuboCop (Ruby)',
          phpcs: 'PHP_CodeSniffer (PHP)'
        }),
        docFooter: { prev: 'Anterior', next: 'Próximo' }
      }
    }
  }
})
