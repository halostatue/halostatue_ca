---
title: TableauPageFeedbackExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau-page-feedback-extension
categories: [Elixir, Tableau extension]
description: |
  Generates feedback links (issues, discussions) for Tableau pages and posts.
project_links:
  - Source Code: https://github.com/halostatue/tableau_page_feedback_extension
  - Hex Package: https://hex.pm/packages/tableau_page_feedback_extension
  - Documentation: https://hexdocs.pm/tableau_page_feedback_extension
llm-editable: true
---

A [Tableau][tableau] extension that generates feedback links for every page and
post on a site. Each page gets a `feedback_urls` map in its frontmatter with
URLs for each enabled feedback type, and `$feedback:<type>` markers in Markdown
content are replaced with the actual URLs in the rendered HTML.

## Configuration

```elixir
config :tableau, TableauPageFeedbackExtension,
  enabled: true,
  forge: :github,
  repo: "owner/repo",
  title_prefix: "Re: ",
  body_suffix: "\n\n---\nPlease describe the issue above.",
  github: [
    discussion: [category: "General"]
  ]
```

Forge-specific options are nested under the forge key. Each feedback type may
have its own required configuration — types with missing required config are
silently disabled with a warning.

### GitHub

- `issue` — enabled by default, no additional config needed. Disable with
  `issue: nil`.
- `discussion` — disabled by default. Enable by providing the required
  `category`.

## Usage

### In Templates

```eex
<%= if assigns[:feedback_urls] do %>
  <a href="<%= @feedback_urls.issue %>">Report an issue</a>
  <a href="<%= @feedback_urls.discussion %>">Start a discussion</a>
<% end %>
```

### In Markdown Content

```markdown
[Report an issue]($feedback:issue)
[Start a discussion]($feedback:discussion)
```

Markers for disabled feedback types are left in place.

[tableau]: https://hexdocs.pm/tableau
