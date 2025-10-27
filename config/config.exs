import Config

alias Floki.HTMLParser.FastHtml
alias Floki.HTMLParser.Html5ever

config :bun,
  version: "1.3.8",
  install: [
    args: ~w(install)
  ],
  default: [
    args: ~w(run build.js),
    cd: Path.expand("..", __DIR__)
  ],
  lighthouse: [
    args: ~w(lighthouse),
    cd: Path.expand("..", __DIR__)
  ]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :floki, :html_parser, Html5ever

config :tableau, Pagefindex.Tableau,
  enabled: true,
  run_with: :local,
  debounce_ms: 2000,
  on_error: :warn

config :tableau, Prosody.Tableau, enabled: true, words_per_minute: 225, min_reading_time: 2
config :tableau, Tableau.DataExtension, enabled: true

config :tableau, Tableau.PageExtension,
  enabled: true,
  layout: HalostatueCa.PageLayout

config :tableau, Tableau.PostExtension,
  enabled: true,
  permalink: "/posts/:year/:month/:title",
  layout: HalostatueCa.PostLayout

config :tableau, Tableau.RSSExtension,
  enabled: true,
  title: "halostatue.ca",
  description:
    "Austin Ziegler's personal website and blog - thoughts on software development, open source, and technology"

config :tableau, Tableau.SitemapExtension, enabled: true

config :tableau, Tableau.TagExtension,
  enabled: true,
  permalink: "/tags",
  layout: HalostatueCa.TagLayout

config :tableau, TableauEexExtension, enabled: true, dir: "_eex"
config :tableau, TableauExcerptExtension, enabled: true

config :tableau, TableauPaginationExtension,
  enabled: true,
  collections: [
    posts: [
      permalink: "/posts/:page?",
      layout: HalostatueCa.RootLayout,
      template: HalostatueCa.PostsPage,
      per_page: 5
    ]
  ]

config :tableau, TableauRedirectsExtension,
  enabled: true,
  html: %{
    enabled: true,
    message: "Redirecting to {{url}}…",
    external_message: "Redirecting to external site: {{url}}…"
  },
  json: %{
    enabled: true
  },
  redirects: %{
    "/mime-types/" => "https://github.com/mime-types/ruby-mime-types",
    "/code/mime-types/" => "https://github.com/mime-types/ruby-mime-types",
    "/code/ruby-mime-types/" => "https://github.com/mime-types/ruby-mime-types",
    "/desc/" => "/about/#old-content",
    "/desc/series-seven-languages/" => "/about/#old-content",
    "/desc/series-rubyconf-2006/" => "/about/#old-content",
    "/series/seven-languages/" => "/about/#old-content",
    "/2006/06/rubyists-in-london-germany-amsterdam/" => "/about/#old-content",
    "/2006/09/d-ck-t-ping-and-semantics/" => "/about/#old-content",
    "/2006/09/ruby-on-windows-a-note-for-microsoft/" => "/about/#old-content",
    "/2007/10/theres-a-ruby-debugger/" => "/about/#old-content",
    "/2008/11/mac-recipe-management-programs/" => "/about/#old-content",
    "/2009/04/fosslc-panels-and-me/" => "/about/#old-content",
    "/2009/04/mac-recipe-management-programs-planning-a-revisit/" => "/about/#old-content",
    "/2014/10/bastille-toronto-october-2014/" => "/about/#old-content",
    "/2014/10/plumage-rubymotion-cli-app/" => "/about/#old-content",
    "/2014/10/ruby-net-ldap-under-new-management/" => "/about/#old-content",
    "/2014/11/markdown-generating-heading-ids/" => "/about/#old-content",
    "/2015/04/a-message-from-the-ansible/" => "/about/#old-content",
    "/2015/04/the-mime-types-project/" => "/about/#old-content",
    "/posts/bastille-toronto-october-2014/" => "/about/#old-content",
    "/posts/d-ck-t-ping-and-semantics/" => "/about/#old-content",
    "/posts/fosslc-panels-and-me/" => "/about/#old-content",
    "/posts/mac-recipe-management-programs-planning-a-revisit/" => "/about/#old-content",
    "/posts/mac-recipe-management-programs/" => "/about/#old-content",
    "/posts/markdown-generating-heading-ids/" => "/about/#old-content",
    "/posts/plumage-rubymotion-cli-app/" => "/about/#old-content",
    "/posts/ruby-mime-types-3/" => "/about/#old-content",
    "/posts/ruby-net-ldap-under-new-management/" => "/about/#old-content",
    "/posts/ruby-on-windows-a-note-for-microsoft/" => "/about/#old-content",
    "/posts/the-mime-types-project/" => "/about/#old-content",
    "/posts/theres-a-ruby-debugger/" => "/about/#old-content"
  }

config :tableau, TableauRefLinkExtension,
  enabled: false,
  prefix: "$ref",
  base_prefix: "$base"

config :tableau, TableauSocialExtension,
  enabled: true,
  show_errors: true,
  css_prefix: "social",
  accounts: [
    github: "halostatue",
    mastodon: [
      "austin@ruby.social",
      "halostatue@cosocial.ca"
    ],
    linkedin: "austinziegler",
    bluesky: "halostatue.ca",
    hacker_news: "halostatue",
    keybase: "halostatue",
    newsblur: "halostatue",
    stack_overflow: "36378/austin-ziegler",
    tumblr: "halostatue"
  ]

config :tableau, :assets, bun: {Bun, :install_and_run, [:default, ~w(--watch)]}

config :tableau, :config,
  url: "http://localhost:4999",
  markdown: [
    mdex: [
      extension: [
        greentext: true,
        header_ids: "",
        highlight: true,
        math_code: true,
        spoiler: true
      ],
      parse: [smart: true],
      syntax_highlight: [
        formatter: {
          :html_multi_themes,
          themes: [light: "onelight", dark: "kanagawa_dragon"], default_theme: "light-dark()"
        }
      ],
      plugins: [
        MDExCustomHeadingId,
        MDExGFM,
        MDExMermaid,
        MDExVideoEmbed
      ]
    ]
  ]

config :tableau, :reloader,
  patterns: [
    ~r/^lib\/.*\.ex/,
    ~r/^(_posts|_pages|_drafts|_wip)\/.*\.md/,
    ~r/^assets\/(css|js)\/.*\.(css|js|ts)/
  ]

config :temple,
  engine: EEx.SmartEngine,
  attributes: {Temple, :attributes}

config :web_dev_utils, :reload_log, true

import_config "#{Mix.env()}.exs"
