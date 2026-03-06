---
title: Pagefindex
layout: HalostatueCa.ProjectLayout
related_tag: pagefindex
categories: [Elixir, Tableau extension, Search]
project_links:
  - Source Code: https://github.com/halostatue/pagefindex
  - Hex Package: https://hex.pm/packages/pagefindex
  - Documentation: https://hexdocs.pm/pagefindex
---

Runs [Pagefind][pagefind] search indexing for static sites. Works as a
[Tableau][tableau] extension or standalone via Mix task.

When `Pagefindex.Tableau` is used, it uses the Tableau configuration (`out_dir`)
for the site location for indexing.

```elixir
config :tableau, Pagefindex.Tableau,
  enabled: true,
  run_with: :auto,
  debounce_ms: 2000
```

Alternatively, you can use the `pagefind` Mix task:

```bash
mix pagefind # defaults to --site=_site --run-with=auto
mix pagefind --site=dist
mix pagefind --run-with=bun
mix pagefind --use-version=1.4.0
```

[tableau]: https://hexdocs.pm/tableau
[pagefind]: https://pagefind.app
