---
title: Pontil
layout: HalostatueCa.ProjectLayout
related_tag: pontil
categories: [Gleam, GitHub Actions]
description: |
  A Gleam port of GitHub's actions/toolkit for writing GitHub Actions in Gleam.
project_links:
  - Source Code: https://github.com/halostatue/pontil
  - "pontil docs": https://hexdocs.pm/pontil
  - "pontil_core docs": https://hexdocs.pm/pontil_core
  - "pontil_platform docs": https://hexdocs.pm/pontil_platform
  - "pontil_summary docs": https://hexdocs.pm/pontil_summary
---

> **pontil**[^1] | ˈpɒntɪl | (punty | ˈpʌnti |) noun
>
> (in glass-making) an iron rod used to hold or shape soft glass.

Pontil is a [Gleam][gleam] port of GitHub [actions/toolkit][toolkit] to ease
writing GitHub Actions in Gleam. It is a monorepo currently with four packages,
each published independently to [Hex][hex]:

| Package                              | Description                              | Targets            |
| ------------------------------------ | ---------------------------------------- | ------------------ |
| [`pontil`][pontil]                   | High-level API for GitHub Actions        | JavaScript         |
| [`pontil_core`][pontil_core]         | Core workflow commands and input parsing | Erlang, JavaScript |
| [`pontil_platform`][pontil_platform] | Runtime, OS, and architecture detection  | Erlang, JavaScript |
| [`pontil_summary`][pontil_summary]   | Job summary builder                      | Erlang, JavaScript |

Most users should depend on `pontil` directly. The sub-packages exist for use
cases that don't need the full toolkit or need Erlang target support.

Pontil was extracted from [`halostatue/starlist`][starlist-project].

## Installation

```sh
gleam add pontil@1
```

## Core Features

The initial release covers [`@actions/core`][actions-core], providing idiomatic
Gleam APIs for:

- **Inputs**: Read action inputs (`get_input`, `get_boolean_input`,
  `get_multiline_input`)

- **Outputs**: Set step output values and save/restore state across job phases

- **Logging**: Structured logging with `debug`, `info`, `warning`, `error`, and
  `notice` — including annotation properties for file/line references

- **Environment**: Export variables and modify `PATH` for the current and
  subsequent steps

- **Secrets**: Register values for log masking via `set_secret`

- **Groups**: Collapsible output groups in the Actions log

- **Job Summaries**: A builder API for constructing rich Markdown summaries with
  headings, tables, lists, links, images, and quotes

- **Path Utilities**: Cross-platform path conversion (POSIX, Win32, platform)

- **OIDC Token Retrieval**

## Quick Example

```gleam
import pontil
import pontil/summary

pub fn main() {
  let name = pontil.get_input("name")
  pontil.info("Hello, " <> name <> "!")

  pontil.group("Creating summary", fn() {
    summary.new()
    |> summary.h2("Results")
    |> summary.raw("All checks passed.")
    |> summary.append()
  })
}
```

## Packages

### `pontil`

The main package providing a high-level API for GitHub Actions targeting
JavaScript runtimes. It re-exports and extends `pontil_core` with features
specific to the Actions runtime environment.

### `pontil_core`

Core workflow commands and input parsing supporting both Erlang and JavaScript
targets. Provides input reading, output setting, structured logging with
annotation properties, environment variable export, secret masking, and
collapsible output groups.

### `pontil_platform`

Cross-runtime platform detection returning the runtime environment, operating
system, and CPU architecture. Works on Erlang, Node, Bun, and Deno. Originally
ported from the toolkit's platform functionality, with runtime detection adapted
from [DitherWither/platform][ditherwither-platform].

### `pontil_summary`

Job summary builder ported from [actions/core summary][actions-summary]. Builds
rich Markdown summaries with headings, tables, lists, links, images, and quotes.
Works on all Gleam targets and runtimes.

[^1]: "pontil." Apple Dictionary / _Oxford English Dictionary_, Version 2.3.0
    (294), Apple Inc., 2025.

[actions-core]: https://github.com/actions/toolkit/tree/main/packages/core
[actions-summary]: https://github.com/actions/toolkit/blob/main/packages/core/src/summary.ts
[ditherwither-platform]: https://github.com/DitherWither/platform
[gleam]: https://gleam.run
[hex]: https://hex.pm
[pontil]: https://hex.pm/packages/pontil
[pontil_core]: https://hex.pm/packages/pontil_core
[pontil_platform]: https://hex.pm/packages/pontil_platform
[pontil_summary]: https://hex.pm/packages/pontil_summary
[starlist-project]: $ref:starlist.md
[toolkit]: https://github.com/actions/toolkit
