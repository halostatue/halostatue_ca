---
title: Starlist
layout: HalostatueCa.ProjectLayout
related_tag: starlist
categories: [Gleam, GitHub Actions]
description: |
  A GitHub Action tool that generates categorized Markdown lists of starred
  repositories.
project_links:
  - Source Code: https://github.com/halostatue/starlist
  - Example Output: https://github.com/halostatue/stars
---

`halostatue/starlist` generates categorized Markdown lists of GitHub starred
repositories. It runs as a **GitHub Action** on a schedule or manually. An
example of its output and configuration can be seen at
[halostatue/stars][stars].

Stars are fetched via the GitHub GraphQL API, grouped and optionally
partitioned, then rendered through customizable [`glemplate`][glemplate]
templates.

## GitHub Action

```yaml
name: Update star list

on:
  workflow_dispatch:
  schedule:
    - cron: "0 0 * * *"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
        with:
          persist-credentials: false

      - uses: halostatue/starlist@v2.1.0
        with:
          token: ${{ secrets.STARLIST_PAT }}
```

The action fetches stars, renders Markdown, and commits the result back to the
repository. Configuration is via TOML, either inline or from a file.

## Features

- **Grouping**: by language (default), topic, or licence.
- **Partitioning**: split output across files by language, topic, year, or
  year-month. If a user has more than 2,000 stars, partitioning will
  automatically be enabled by year.
- **Templates**: customizable output via [`glemplate`][glemplate] templates.

[glemplate]: https://hexdocs.pm/glemplate
[stars]: https://github.com/halostatue/stars
