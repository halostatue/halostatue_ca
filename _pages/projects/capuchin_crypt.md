---
title: Capuchin Crypt
layout: HalostatueCa.ProjectLayout
related_tag: capuchin_crypt
categories: [Gleam]
description: |
  An in-memory persistent cache for Gleam. Expensive to update, cheap to read.
  In Erlang, this uses `persistent_term`; in JavaScript, values are stored in
  a module level `Map`.
project_links:
  - GitHub: https://github.com/halostatue/capuchin_crypt
  - hex.pm: https://hex.pm/packages/capuchin_crypt
  - hexdocs: https://capuchin-crypt.hexdocs.pm
  - Apache 2.0: https://github.com/halostatue/capuchin_crypt/main/blob/LICENCE.md
---

An in-memory persistent cache for [Gleam][gleam], expensive to update and cheap
to read, like the [Capuchin Crypt][ccrypt] in Rome.

If you think you need this, think again — you probably don't. As the warning at
the top of [`persistent_term`][pterm] says:

> Persistent terms is an advanced feature and is not a general replacement for
> ETS tables. Before using persistent terms, make sure to fully understand the
> consequence to system performance when updating or deleting persistent terms.

[gleam]: https://gleam.run
[ccrypt]: https://en.wikipedia.org/wiki/Capuchin_Crypt
[pterm]: https://www.erlang.org/doc/apps/erts/persistent_term.html
