---
title: TableauPaginationExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau_pagination_extension
categories: [Elixir, Tableau extension]
description: |
  Provides paginated collections for indexes, tags, tag pages, and more.
project_links:
  - Source Code: https://github.com/halostatue/tableau_pagination_extension
  - Hex Package: https://hex.pm/packages/tableau_pagination_extension
  - Documentation: https://hexdocs.pm/tableau_pagination_extension
---

This is a [Tableau][tableau] extension for creating paginated index pages for
collections: posts, tags, or custom data.

<div class="code-transform">

```elixir
config :tableau, TableauPaginationExtension,
  enabled: true,
  collections: [
    posts: [
      permalink: "/posts/:page?",
      layout: MySite.RootLayout,
      template: MySite.PostsPage,
      per_page: 5
    ]
  ]
```

```
/posts      → Page 1 (5 posts)
/posts/2    → Page 2 (5 posts)
/posts/3    → Page 3 (5 posts)
```

</div>

Map-like collections (mostly tags) can be paginated both on keys (tag names) and
on key/value pairs (paginated pages within a tag).

## Collection Types

### Posts/Pages

Paginate simple lists:

```elixir
posts: [
  permalink: "/posts/:page?",
  layout: MySite.RootLayout,
  template: MySite.PostsPage,
  per_page: 10
]
```

### Tag Index

Paginate list of all tags:

```elixir
tag_index: [
  key_path: [:tags],
  permalink: "/tags/:page?",
  layout: MySite.RootLayout,
  template: MySite.TagIndexPage,
  per_page: 50
]
```

### Tag Pages

Paginate posts within each tag:

```elixir
tag_pages: [
  key_path: [:tags],
  permalink: "/tags/:tag/:page?",
  layout: MySite.RootLayout,
  template: MySite.TagPage,
  per_page: 20
]
```

## Permalink Patterns

Collection permalink strings have to end with `/:page` or `/:page?`

- **`prefix/:page?`**: Omitted first page: `/prefix`, `/prefix/2`, `/prefix/3`
- **`prefix/:page`**: Required page number: `/prefix/1`, `/prefix/2`,
  `/prefix/3`
- **`%{first: "/prefix/start", rest: "/prefix/:page"}`**: Custom URL structure
  for first page and subsequent pages. (`first` does not need to end with
  `:page`, but `rest` must.)

## Template Variables

Templates receive these assigns:

- `@posts`: Items for current page
- `@page_number`: Current page (1-indexed)
- `@total_pages`: Total number of pages
- `@prev_page_url` / `@next_page_url`: Navigation URLs
- `@first_page_url` / `@last_page_url`: Jump to endpoints

[tableau]: https://hexdocs.pm/tableau
