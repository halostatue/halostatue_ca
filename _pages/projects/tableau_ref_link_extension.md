---
title: TableauRefLinkExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau_ref_link_extension
categories: [Elixir, Tableau extension]
description: |
  Makes it easy to have cross-content links.
project_links:
  - Source Code: https://github.com/halostatue/tableau_ref_link_extension
  - Hex Package: https://hex.pm/packages/tableau_ref_link_extension
  - Documentation: https://hexdocs.pm/tableau_ref_link_extension
---

This is a [Tableau][tableau] extension that resolves reference links to pages,
posts, and static assets without having to know the precise location of the
referenced content. This works with elements that support `href` or `src`
attributes.

- _Links_: `<a>`, `<link>`
- _Media_: `<img>`, `<audio>`, `<video>`, `<source>`, `<track>`
- _Embedded_: `<embed>`, `<iframe>`, `<script>`

## Content Link Resolution (`$ref:<content>`)

Links with `$ref:<content>` resolve to content files (pages, posts) or static
assets.

<div class="code-transform">

```markdown
[My Post]($ref:_posts/2024-01-15-my-post.md) [About Page]($ref:_pages/about.md)
![Logo]($ref:logo.png) [With Anchor]($ref:post.md#section)
```

```html
<a href="/posts/2024/01/15/my-post">My Post</a>
<a href="/about">About Page</a>
<img src="/logo.png" alt="Logo">
<a href="/posts/post#section">With Anchor</a>
```

</div>

If the content reference is just the filename (no `/`), files are searched
across all content and static assets.

```markdown
[My Post]($ref:my-post.md)
```

If the content reference is a path (contains `/`), the file paths are matched
from the workspace root.

```markdown
[Specific Post]($ref:_posts/2024-01-15-my-post.md) [Asset]($ref:images/logo.png)
```

`$ref` links are resolved from content before static assets. Missing references
(`$ref:no-file.md`) become `#ref-not-found:path` with a logged warning.
Ambiguous matches (`$ref:one.md`) use the first match with a logged warning.

## Site Link Resolution (`$site:<path>`)

Links with `$site:<path>` resolve to files relative to the site base URL.

<div class="code-transform">

```markdown
[Download PDF]($site:downloads/guide.pdf) [Secret File]($site:secret/file.txt)
```

```html
<a href="/base/downloads/guide.pdf">Download PDF</a>
<a href="/base/secret/file.txt">Secret File</a>
```

</div>

No content lookup or validation is performed.

[tableau]: https://hexdocs.pm/tableau
