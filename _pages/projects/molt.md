---
title: Molt
layout: HalostatueCa.ProjectLayout
related_tag: molt
categories: [Gleam]
description: |
  TOML transformed.
project_links:
  - GitHub: https://github.com/halostatue/molt
  - hex.pm: https://hex.pm/packages/molt
  - hexdocs: https://molt.hexdocs.pm
  - Apache 2.0: https://github.com/halostatue/molt/main/blob/LICENCE.md
---

Molt is a [Gleam][gleam] TOML transformation library intended to help tool
authors make modifications to configuration TOML files without accidentally
affecting any comments or formatting that preexists. Molt provides complete TOML
1.0 and 1.1 specification compliance. It provides both logical and structural
manipulation API surfaces by parsing TOML into a concrete syntax tree (CST)
rather than just extracting values, so edits don't destroy the human-authored
structure of the file.

Molt is _not_ a general-purpose TOML library, but specifically built for safe
programmatic editing of TOML files. For general TOML reading, prefer [tom][tom].

Molt is built on top of [Greenwood][greenwood].

## Installation

```sh
gleam add molt@1
```

## Usage

Molt offers two APIs that are thoroughly documented

- **`molt`** (the high-level API): path-addressed logical operations (`set`,
  `remove`, `move`, …) that keep the document semantically valid and preserve
  representation. Each wraps an `molt/ops` `Operation`, applied through
  `molt.run`; the [Operations Reference][ops] catalogues them all.

- **`molt/cst`**: direct, lossless manipulation of concrete syntax tree nodes.
  This lower level API can produce structurally valid (but semantically invalid)
  TOML. Use it for surgery the high-level API can't express (see the
  [Repairing Invalid TOML][rit] guide).

For more details, see the [Usage Guide][usage].

## Quick Example

```gleam
import molt
import molt/value

const config = "[server]
host = \"localhost\"
port = 8080

# TLS settings
[server.tls]
enabled = false
"

pub fn main() {
  let assert Ok(doc) = molt.parse(config)

  // Read a value
  let assert Ok(port) = molt.get(doc, "server.port")
  let assert Ok(8080) = value.unwrap_int(port)

  // Edit: change port and enable TLS — comments and formatting preserved
  let assert Ok(doc) = molt.set(doc, "server.port", value.int(443))
  let assert Ok(doc) = molt.set(doc, "server.tls.enabled", value.bool(True))

  molt.to_string(doc)
  // [server]
  // host = "localhost"
  // port = 443
  //
  // # TLS settings
  // [server.tls]
  // enabled = true
}
```

[gleam]: https://gleam.run
[greenwood]: $ref:greenwood.md
[molt]: https://hex.pm/packages/molt
[ops]: https://molt.hexdocs.pm/operations.html
[rit]: https://molt.hexdocs.pm/invalid-toml.html
[tom]: https://tom.hexdocs.pm/
[usage]: https://molt.hexdocs.pm/usage.html
