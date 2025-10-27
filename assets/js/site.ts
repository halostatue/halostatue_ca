// Progressive enhancement for halostatue.ca
// Minimal JavaScript for theme switching and other enhancements

const ThemeKey = 'halostatue-theme'
const Themes = { AUTO: 'auto', DARK: 'dark', LIGHT: 'light' } as const
type Theme = (typeof Themes)[keyof typeof Themes]
const ThemeIcons: Record<Theme, string> = {
  auto: '🖥',
  dark: '🌙',
  light: '☀️',
} as const
const ThemeLabels: Record<Theme, string> = {
  auto: 'Theme: Auto',
  light: 'Theme: Light',
  dark: 'Theme: Dark',
} as const

document.addEventListener('DOMContentLoaded', () => enableProgressiveEnhancement())

function enableProgressiveEnhancement() {
  const siteControls = document.querySelector<HTMLElement>('.site-controls')

  if (siteControls) {
    siteControls.classList.remove('no-js')
  }

  initializeThemeSwitcher()
  initializeExternalLinks()
  initializeSearchShortcut()
  initializeInlineSearch()
}

function initializeThemeSwitcher() {
  const themeToggle = document.getElementById('theme-toggle')
  const themeMenu = document.getElementById('theme-menu')
  const themeIcon = document.getElementById('theme-icon')
  const themeOptions = document.querySelectorAll('.theme-option')
  const htmlElement = document.documentElement

  if (!themeToggle || !themeMenu || !themeIcon) {
    return
  }

  applyTheme((localStorage.getItem(ThemeKey) as Theme) || Themes.AUTO)

  themeToggle.addEventListener('click', () => {
    const isExpanded = themeToggle.getAttribute('aria-expanded') === 'true'
    themeToggle.setAttribute('aria-expanded', (!isExpanded).toString())
    themeMenu.setAttribute('aria-hidden', isExpanded.toString())
  })

  document.addEventListener('click', (e) => {
    if (
      !themeToggle.contains(e.target as Node) &&
      !themeMenu.contains(e.target as Node)
    ) {
      themeToggle.setAttribute('aria-expanded', 'false')
      themeMenu.setAttribute('aria-hidden', 'true')
    }
  })

  for (const button of themeOptions) {
    button.addEventListener('click', () => {
      const theme = button.getAttribute('data-theme') as Theme
      applyTheme(theme)
      localStorage.setItem(ThemeKey, theme)

      themeToggle.setAttribute('aria-expanded', 'false')
      themeMenu.setAttribute('aria-hidden', 'true')
    })
  }

  function applyTheme(theme: Theme): void {
    htmlElement.removeAttribute('data-theme')

    if (theme !== Themes.AUTO) {
      htmlElement.setAttribute('data-theme', theme)
    }

    themeOptions.forEach((button) => {
      const isActive = button.getAttribute('data-theme') === theme
      button.setAttribute('data-active', isActive.toString())
    })

    if (themeIcon) {
      themeIcon.textContent = ThemeIcons[theme]
    }

    themeToggle?.setAttribute('data-label', ThemeLabels[theme])
  }

  if (window.matchMedia) {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      const currentTheme = (localStorage.getItem(ThemeKey) as Theme) || Themes.AUTO
      if (currentTheme === Themes.AUTO) {
        applyTheme(Themes.AUTO)
      }
    })
  }
}

function initializeExternalLinks() {
  for (const link of document.querySelectorAll<HTMLAnchorElement>('a[href^="http"]')) {
    if (link.hostname === window.location.hostname) {
      return
    }

    link.setAttribute('rel', 'noopener noreferrer')

    if (!link.querySelector('.external-link-icon')) {
      link.innerHTML += ' <span class="external-link-icon" aria-hidden="true">↗</span>'
    }
  }
}

// biome-ignore lint/suspicious/noExplicitAny: PagefindUI loaded from external script
declare const PagefindUI: any

let pagefindUI: typeof PagefindUI = null

function initializeSearchShortcut() {
  const modal = document.getElementById('search-modal')
  const modalSearch = document.getElementById('modal-search')

  if (!modal || !modalSearch) {
    return
  }

  function ensurePagefindUI() {
    if (!pagefindUI) {
      pagefindUI = new PagefindUI({
        element: '#modal-search',
        showSubResults: true,
        resetStyles: false,
        openFilters: ['Tag'],
      })

      setTimeout(addFilterToggle, 50)
    }
  }

  function addFilterToggle(retries = 10) {
    const filterPanel = document.querySelector<HTMLElement>('.pagefind-ui__filter-panel')
    const filterLabel = document.querySelector<HTMLElement>(
      '.pagefind-ui__filter-panel-label',
    )

    // biome-ignore lint/complexity/useLiteralKeys: tsc noPropertyAccessFromIndexSignature
    if (filterPanel?.dataset['filterToggleReady']) {
      return
    }

    if (!filterPanel || !filterLabel) {
      if (retries > 0) {
        setTimeout(() => addFilterToggle(retries - 1), 100)
      }

      return
    }

    // biome-ignore lint/complexity/useLiteralKeys: tsc noPropertyAccessFromIndexSignature
    filterPanel.dataset['filterToggleReady'] = 'true'

    filterLabel.addEventListener('click', () => {
      // biome-ignore lint/complexity/useLiteralKeys: tsc noPropertyAccessFromIndexSignature
      const isOpen = filterPanel.dataset['filtersOpen'] === 'true'
      // biome-ignore lint/complexity/useLiteralKeys: tsc noPropertyAccessFromIndexSignature
      filterPanel.dataset['filtersOpen'] = (!isOpen).toString()
    })
  }

  function openModal() {
    ensurePagefindUI()
    modal?.setAttribute('aria-hidden', 'false')
    document.body.style.overflow = 'hidden'

    const focus = () => {
      addFilterToggle()

      const searchInput = document.querySelector<HTMLInputElement>(
        '.pagefind-ui__search-input',
      )

      if (searchInput) {
        searchInput.focus()
      }
    }

    setTimeout(focus, 100)
  }

  function closeModal() {
    modal?.setAttribute('aria-hidden', 'true')
    document.body.style.overflow = ''
  }

  document.addEventListener('keydown', (e) => {
    const target = e.target as HTMLElement | null

    if (e.key === '/' && target?.tagName !== 'INPUT' && target?.tagName !== 'TEXTAREA') {
      e.preventDefault()
      openModal()
    }

    if (e.key === 'Escape' && modal?.getAttribute('aria-hidden') === 'false') {
      e.preventDefault()
      closeModal()
    }
  })

  const closeElements = modal.querySelectorAll('[data-search-close]')
  const searchTrigger = document.getElementById('search-trigger')

  closeElements.forEach((el) => {
    el.addEventListener('click', closeModal)
  })

  if (searchTrigger) {
    searchTrigger.addEventListener('click', openModal)
  }
}

function initializeInlineSearch() {
  const inlineSearch = document.getElementById('inline-search')
  if (!inlineSearch) return

  populateRandomPost()

  const searchTerms = extractSearchTermsFromUrl()

  // Lazy load PagefindUI
  loadPagefindUI().then(() => {
    new PagefindUI({
      element: '#inline-search',
      showSubResults: true,
      resetStyles: false,
      openFilters: ['Tag'],
    })

    if (searchTerms) {
      const prepopulate = () => {
        const input = inlineSearch.querySelector<HTMLInputElement>(
          '.pagefind-ui__search-input',
        )
        if (input) {
          input.value = searchTerms
          input.dispatchEvent(new Event('input', { bubbles: true }))
        }
      }

      setTimeout(prepopulate, 100)
    }
  })
}

interface Post {
  title: string
  url: string
}

type Posts = Array<Post>

function populateRandomPost() {
  const dataEl = document.getElementById('random-posts-data')
  const linkEl = document.getElementById('random-post-link')

  if (!dataEl || !linkEl) {
    return
  }

  const setPost = (post: Post) => {
    const link = document.createElement('a')
    link.href = post.url
    link.textContent = post.title
    linkEl.appendChild(link)
  }

  try {
    const posts = JSON.parse(dataEl.textContent || '[]') as Posts

    if (posts.length === 0) {
      return
    }

    const post =
      posts.length === 1 ? posts[0] : posts[Math.floor(Math.random() * posts.length)]

    if (post?.url && post?.title) {
      setPost(post)
    }
  } catch {}
}

const StopWords = new Set([
  'a',
  'an',
  'and',
  'are',
  'article',
  'articles',
  'as',
  'at',
  'be',
  'been',
  'blog',
  'but',
  'by',
  'can',
  'could',
  'dare',
  'did',
  'do',
  'does',
  'for',
  'from',
  'had',
  'has',
  'have',
  'in',
  'is',
  'may',
  'might',
  'must',
  'need',
  'of',
  'on',
  'or',
  'ought',
  'page',
  'pages',
  'post',
  'posts',
  'shall',
  'should',
  'the',
  'to',
  'used',
  'was',
  'were',
  'will',
  'with',
  'would',
])

function extractSearchTermsFromUrl(): string {
  return window.location.pathname
    .split(/\W+/)
    .map((w) => w.toLowerCase().trim())
    .filter((w) => w.length > 2 && !StopWords.has(w) && !/^\d+$/.test(w))
    .slice(0, 3)
    .join(' ')
}

// Lazy load PagefindUI script
function loadPagefindUI(): Promise<void> {
  if (typeof PagefindUI === 'function') {
    return Promise.resolve()
  }

  return new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.src = '/pagefind/pagefind-ui.js'
    script.onload = () => resolve()
    script.onerror = reject
    document.head.appendChild(script)
  })
}
