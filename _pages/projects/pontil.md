---
title: Pontil
layout: HalostatueCa.ProjectLayout
related_tag: pontil
categories: [Gleam, GitHub Actions]
description: |
  A Gleam port of GitHub's actions/toolkit for writing GitHub Actions in Gleam.
project_links:
  - Source Code: https://github.com/halostatue/pontil
  - Hex Package: https://hex.pm/packages/pontil
  - Documentation: https://hexdocs.pm/pontil
---

> **pontil**[^1] | ˈpɒntɪl | (punty | ˈpʌnti |) noun
>
> (in glass-making) an iron rod used to hold or shape soft glass.

Pontil is a [Gleam][gleam] port of GitHub [actions/toolkit][toolkit] to ease
writing GitHub Actions in Gleam, targeting both Erlang and JavaScript runtimes.
JavaScript compatibility is the priority since non-composite GitHub Actions run
on Node. Pontil was extracted from [`halostatue/starlist`][starlist-project].

## Installation

```sh
gleam add pontil@0
```

## Core Features

The initial release covers most of [`@actions/core`][actions-core], providing
idiomatic Gleam APIs for:

- **Inputs**: Read action inputs (`get_input`, `get_boolean_input`,
  `get_multiline_input`) with optional validation and trimming
- **Outputs**: Set step outputs and save/restore state across job phases
- **Logging**: Structured logging with `debug`, `info`, `warning`, `error`, and
  `notice` — including annotation properties for file/line references
- **Environment**: Export variables and modify `PATH` for the current and
  subsequent steps
- **Secrets**: Register values for log masking via `set_secret`
- **Groups**: Collapsible output groups in the Actions log
- **Job Summaries**: A builder API for constructing rich Markdown summaries with
  headings, tables, lists, links, images, and quotes
- **Path Utilities**: Cross-platform path conversion (POSIX, Win32, platform)

## Quick Example

```gleam
import pontil
import pontil/summary

pub fn main() {
  let name = pontil.get_input("name")
  pontil.info("Hello, " <> name <> "!")

  summary.new()
  |> summary.h2("Results")
  |> summary.raw("All checks passed.")
  |> summary.append()
}
```

## What's Not Yet Covered

Only `getIdToken` from `@actions/core` is currently unimplemented. Additional
toolkit packages (`@actions/exec`, `@actions/io`, `@actions/cache`, etc.) are
not yet ported.

[^1]: "pontil." Apple Dictionary / _Oxford English Dictionary_, Version 2.3.0
    (294), Apple Inc., 2025.

[actions-core]: https://github.com/actions/toolkit/tree/main/packages/core
[gleam]: https://gleam.run
[starlist-project]: $ref:starlist.md
[toolkit]: https://github.com/actions/toolkit
