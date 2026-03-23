---
title: TableauSocialExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau_social_extension
categories: [Elixir, Tableau extension]
description: |
  Makes it easy to have your social media profile links visible.
project_links:
  - Source Code: https://github.com/halostatue/tableau_social_extension
  - Hex Package: https://hex.pm/packages/tableau_social_extension
  - Documentation: https://hexdocs.pm/tableau_social_extension
---

This is a [Tableau][tableau] extension that replaces HTML tags with social media
profile links based on site configuration and content frontmatter. All generated
links include `rel="nofollow noopener noreferrer"` automatically.

## Supported Tags

### Social Block

Replaces the social block `<dl>` with a definition list with all configured
social accounts. Filters may be applied for custom lists.

<div class="code-transform">

```html
<dl social-block></dl>
```

```html
<dl class="social-block">
  <dt class="social-platform-label social-platform-github">GitHub</dt>
  <dd class="social-links social-platform-github">
    <a
      href="https://github.com/username"
      class="social-link social-platform-github"
      rel="nofollow noopener noreferrer"
    >username</a>
  </dd>
</dl>
```

</div>

### Individual Links

Replaces the `<a>` link anchor with a link anchor for the configured account.

<div class="code-transform">

```html
<!-- Uses first configured account -->
<a social-github></a>

<!-- Uses specific account identifier -->
<a social-github="different-user">Text</a>

<!-- For platforms with lookup keys (e.g., Stack Overflow) -->
<a social-stack-overflow-id="12345"></a>
```

```html
<a
  href="https://github.com/username"
  class="social-link social-platform-github"
  rel="nofollow noopener noreferrer"
>@username</a>

<a
  href="https://github.com/different-user"
  class="social-link social-platform-github"
  rel="nofollow noopener noreferrer"
>Text</a>

<a
  href="https://stackoverflow.com/users/12345"
  class="social-link social-platform-stack-overflow"
  rel="nofollow noopener noreferrer"
>Example User</a>
```

</div>

## Configuration

```elixir
config :tableau, TableauSocialExtension,
  accounts: [
    # Simple username
    github: "username",
    twitter: "username",
    
    # Email-style for federated platforms
    mastodon: "user@instance.social",
    pixelfed: "user@pixelfed.social",
    
    # Numeric ID with username -- custom parsing format
    stack_overflow: "12345/username",
    
    # Multiple accounts per platform (as list)
    github: ["personal-username", "work-username"],
    mastodon: ["user@instance.social", "alt@other.instance"]
  ],
  css_prefix: "social",
  labels: %{
    github: "GitHub",
    mastodon: "Mastodon"
  }
```

## Frontmatter Overrides

```yaml
---
title: About
social_accounts:
  github: page-specific-username
  mastodon: different@instance.social
---
```

Frontmatter settings for `social_accounts` override the site configurations for
that page by default, but there are directives for appending or prepending the
account lists.

```yaml
---
title: About
social_accounts:
  github[prepend]: page-specific-username
  mastodon[append]: different@instance.social
---
```

[tableau]: https://hexdocs.pm/tableau
