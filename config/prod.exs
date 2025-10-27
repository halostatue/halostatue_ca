import Config

config :tableau, Tableau.PageExtension, dir: ["_pages"]
config :tableau, Tableau.PostExtension, future: false, dir: ["_posts"]

config :tableau, TableauPaginationExtension,
  collections: [
    posts: [per_page: 15]
  ]

config :tableau, :config, url: "https://halostatue.ca"
