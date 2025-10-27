import Config

config :tableau, Tableau.PageExtension,
  dir: ["_pages", "_wip"],
  layout: HalostatueCa.PageLayout

config :tableau, Tableau.PostExtension,
  future: true,
  dir: ["_posts", "_drafts"],
  layout: HalostatueCa.PostLayout
