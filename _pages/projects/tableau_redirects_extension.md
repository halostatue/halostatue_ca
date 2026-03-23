---
title: TableauRedirectsExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau_redirects_extension
categories: [Elixir, Tableau extension]
description: |
  Generates redirects for moved content (because cool URIs don't change).
project_links:
  - Source Code: https://github.com/halostatue/tableau_redirects_extension
  - Hex Package: https://hex.pm/packages/tableau_redirects_extension
  - Documentation: https://hexdocs.pm/tableau_redirects_extension
---

This is a [Tableau][tableau] extension for generating redirects because
[Cool URIs don't change][uri]. Redirects are specified in configuration and
content metadata and can generate HTML redirects or a JSON redirect map to
produce redirect configurations for Caddy, nginx, Apache, or other servers.

## Redirect Types

### HTML Meta-Refresh Redirects

When serving a Tableau site via AWS S3 or similar scenarios, it is often
necessary to produce browser-based redirects using HTML files with the "meta
refresh" approach. This is generated for directory-style paths and HTML-like
files (`.html`, `.htm`, and `.php`).

<div class="code-transform">

```elixir
config :tableau, TableauRedirectsExtension,
  redirects: %{"/old-url/" => "/new-url/"}
```

```html
<!DOCTYPE html>
<!-- /old-url/index.html -->
<meta charset="utf-8">
<title>Redirecting to /new-url/…</title>
<link rel="canonical" href="/new-url/">
<meta http-equiv="refresh" content="0; url=/new-url/">
<p>Redirecting to <a href="/new-url/">/new-url/</a>…</p>
```

</div>

### JSON Manifest

When a Tableau site is behind another server like Caddy, Apache, or nginx it is
often better to use the generated `redirects.json` to generate appropriate
redirect configuration files. The configuration (and content metadata) produce
the mapping:

<div class="code-transform">

```elixir
config :tableau, TableauRedirectsExtension,
  redirects: %{"/old-url/" => "/new-url/"}
```

```json
{
  "permanent_redirects": [
    {
      "from": ["/old", "/old/", "/old/index.html"],
      "type": "path",
      "to": "/new/",
      "target_type": "internal"
    }
  ]
}
```

</div>

And the mapping can produce the redirect configuration:

<div class="code-transform">

```json
{
  "permanent_redirects": [
    {
      "from": ["/old", "/old/", "/old/index.html"],
      "type": "path",
      "to": "/new/",
      "target_type": "internal"
    }
  ]
}
```

```caddyfile
redir /old-url /new-url permanent
redir /old-url/ /new-url permanent
redir /old-url/index.html /new-url permanent
```

</div>

## Configuration

Configuration may be either global (for content that has been removed but
redirects to somewhere that is either useful or explains) or specified in the
content frontmatter metadata.

### Global Redirects

```elixir
config :tableau, TableauRedirectsExtension,
  enabled: true,
  html: %{enabled: true, message: "Redirecting..."},
  json: %{enabled: true},
  redirects: %{
    "/old-path/" => "/new-path/",
    "/external/" => "https://example.com",
    "/bad-info/" => "/removed/#bad-info"
  }
```

### Frontmatter Redirects

```yaml
---
title: My Post
permalink: /posts/my-post/
redirects:
  aliases:
    - /blog/old-post
    - /old-location/post
  fragments:
    /other-old-post: "#new-section"
---
```

An `alias` redirect goes to the content's permalink, whereas a `fragment`
redirect goes to the content's permalink at a specific URI fragment.

[tableau]: https://hexdocs.pm/tableau
[uri]: https://www.w3.org/Provider/Style/URI
