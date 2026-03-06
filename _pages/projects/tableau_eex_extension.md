---
title: TableauEexExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau_eex_extension
categories: [Elixir, Tableau extension]
project_links:
  - Source Code: https://github.com/halostatue/tableau_eex_extension
  - Hex Package: https://hex.pm/packages/tableau_eex_extension
  - Documentation: https://hexdocs.pm/tableau_eex_extension
---

This is a [Tableau][tableau] extension that renders EEx templates to static
files during site generation. Templates have access to the Tableau (`@token`)
and site configuration (`@config`), making it easy to generate files like
`robots.txt`, `humans.txt`, or other well-known files with dynamic content.

It processes all `.eex` files recursively in the configured directory.

## Usage

Create EEx template files in the configured directory (default: `_eex/`), such
as `_eex/hunans.txt.eex`.

<div class="code-transform">

```eex
# _eex/humans.txt.eex
/* TEAM */
Author: <%= @config.author %>
Site: <%= @config.url %>

/* SITE */
Last update: <%= Date.to_iso8601(Date.utc_today()) %>
```

```
/* TEAM */
Author: Austin Ziegler
Site: https://halostatue.ca

/* SITE */
Last update: 2026-03-06
```

</div>

The extension renders templates to the output directory, stripping the `.eex`
extension.

[tableau]: https://hexdocs.pm/tableau
