---
title: "Gleam in (an) Action"
date: 2026-04-05
tags:
  - Gleam
  - GitHub Actions
revisions:
  - date: 2026-04-06
    rev: |
      Modified the Gleam commentary to remove discussion of the deprecated
      `@target` attribute while keeping the essential complaint alive.
---

I recently released a GitHub Action written in [Gleam][gleam] so that I could
learn more about Gleam and to prove that it could be done.

I maintain a few GitHub Actions in addition to various Ruby and Elixir
libraries. The simplest of these ([`dependabot-automerge`][da]) is a composite
action, but others are written in TypeScript. For the most part, they're easy to
maintain with few code changes and mostly keeping the packages up to date. Yet
[`halostatue/starlist`][starlist] (used to maintain my [star list][stars])
languished[^languished] because I was no longer interested in the direction I
had mapped out, and the TypeScript codebase was complex and difficult to modify.

I've been wanting to explore Gleam seriously for a while — so I set myself a
challenge: translate this to Gleam using the JavaScript build target[^gleamjs].
An opportunity to throw away the cruft I hadn't touched in eighteen months and
start fresh.

I launched [Kiro][kiro] and began planning (`requirements.md`, `design.md`, and
`tasks.md`)[^kirocli]. The initial implementation went quickly, but as I
reviewed the code I realized that it was subtly _wrong_. There was heavy use of
<abbr title="foreign function interface">FFI</abbr> wrapping packages like
[`@actions/core`][gha-ac] and there are conventions (`use`) in Gleam unlike any
other in my [experience][polyglot] which weren't being well-used -- it didn't
_feel_ idiomatic. Worse, as I started to make changes to the generated code, I
realized that fundamental configuration design questions had not been answered.
Far from _removing_ the cruft, I now had the same in a language I was still
learning.

While considering the configuration question, I decided that the action should
be 100% Gleam with no external packages[^npm]. Bundling for GitHub actions was
solved with [`esgleam`][esgleam]. In order to test things until I resolved the
configuration, I implemented a CLI implementation with three subcommands
matching the three execution phases for `starlist`: fetch (reading starred
repositories from the GitHub API[^gql]), render (generating Markdown from the
collected repositories), and git (committing the modified data and markdown to
the repository and pushing it back to GitHub). This exercise suggested the
configuration structure that is now used with only minor changes (but
significant specialization for action and CLI).

About three weeks after I started working on it, I have shipped the new
[`starlist`][starlist-project] written in Gleam. There were a few stumbling
blocks related to reading default templates and required permissions, but those
have been resolved and the newest version uses [pontil][pontil-project],
extracted from the wrapper for `actions/core`.

I have some ideas for future releases, but the core functionality is working
reasonably well. I've learned Gleam (tho I'm far from an expert) and have
shipped two projects that will see continued use. Based on the readability of
the code in `starlist`, I think that there's a good chance I will port other
actions to Gleam and I can see extending pontil to cover not just
`actions/toolkit`, but other functionality I use in GitHub Actions.

Gleam's story is still evolving, and there are gaps. In particular, there's no
supported way in Gleam 1.15 to have a single `main()` which can make HTTP
requests with `gleam_httpc` (BEAM) or `gleam_fetch` (JavaScript) because of
differing concurrency models and return types.

```gleam
// gleam_httpc
pub fn send(request: Request(a)) -> Result(b, e)

// gleam_fetch
pub fn send(request: Request(a)) -> Promise(Result(b, e))
```

In most cases, this is fine. The JavaScript `async` concurrency model permeates
and undermines the procedural nature of GitHub Actions. If one could write
JavaScript that does something like:

```javascript
const fetchSync = sync (request) => {
  await fetch(request)
}
```

And the runtime halts execution of that thread just as if there were a native
`fetchSync` instead of just `fetch`, it would be ideal for a certain class of
application. But this doesn't exist, and it means that as of right now, I would
likely need to have duplication of control flows in separate modules or packages
with distinct `main()` functions for BEAM and JavaScript targets. This may be
unavoidable, but it is a disappointing wart for writing _tools_[^byoc] that
should be able to work similarly.

If I'm misunderstanding something, [drop a line][feedback].

[^languished]: I have ~4900 stars collected over 19 years. This generates a
    single Markdown file more than 2 MiB in size. I need to prune them because
    there are probably hundreds of repos I'm no longer interested in, but it's
    hard to know what to prune when you can't open the file that shows you what
    you've starred.

[^gleamjs]: Gleam supports JavaScript build targets on all three major runtimes
    (Node, Bun, and Deno) and because it generates modern JavaScript, it can run
    in the browser as long as no Node or Deno-only features are used.

[^kirocli]: I mostly use Kiro CLI personally and Cursor CLI at work. This is
    largely because I use Vim[^abcd]. The Kiro IDE planning mode is better at
    building usable plans than Kiro CLI's planning , and beats the pants off
    anything that Cursor does in any mode.

[^abcd]: To quote Montgomery Scott, ["no bloody A, B, C, or D"][ncc1701].

[^gql]: Specifically the GitHub GraphQL API, because it allows for better
    querying of related data than the REST API does. To use the GitHub GraphQL
    API correctly in TypeScript, no fewer than four packages are required:
    `@octokit/core`, `@octokit/plugin-paginate-graphql`,
    `@octokit/plugin-throttling`, and `@octokit/graphql-schema`. The first three
    are used to build the `octokit` instance with the pagination and throttling
    and the last is for proper typing.

    In Gleam, I needed two packages (`squall` and `gleam_fetch`) and a
    query[^squall].

[^squall]: There were bugs in [squall][squall] for which I have opened three
    pull requests.

    In [#2][squall#2], I upgraded dependencies and refactored some duplicate
    code out in favour of features present in `gleam_stdlib`.

    In [#3][squall#3], I refactored the code generator and added authenticated
    endpoint support, as the GitHub GraphQL API requires authentication for
    introspection.

    Finally, in [#4][squall#4], I modified (with the assistance of Kiro) the
    code generation to add a type disambiguation phase after the type collection
    phase. The presence of two fields in a query with the same GraphQL type
    (`Repository`) but different selections would both result in `Repository`
    types with no disambiguation. Disambiguation is conservative, adding variant
    names only when required, and types are sorted before writing so that the
    generated code is stable.

[^npm]: Eliminating JavaScript packages also eliminated the need for any amount
    of Gleam FFI involving those packages. It also eliminated the need for a
    `package.json` and a second package manager. The Gleam packages can be
    considered as three groups: build (`cog`, `esgleam`, `gleeunit`, `qcheck`),
    common (`envoy`, `filepath`, `gleam_fetch`, `gleam_javascript`,
    `gleam_json`, `gleam_stdlib`, `glemplate`, `pontil`, `shellout`,
    `simplifile`, `squall`, `tom`, `youid`), and CLI support (`argv`, `clip`).

[^byoc]: The rule of thumb in Gleam is "bring your own client". If you're
    building something to assist with requests, build (or use) three packages:
    the core request and response processing logic, the BEAM request client, and
    the JavaScript request client. `gleam_http` builds requests and processes
    responses that are usable by `gleam_httpc` and `gleam_fetch`, but does not
    interact with the HTTP clients on either platform.

[da]: https://github.com/halostatue/dependabot-automerge
[esgleam]: https://hexdoc.pm/esgleam
[feedback]: $feedback:discussion
[gha-ac]: https://github.com/actions/toolkit/tree/main/core
[gleam]: https://gleam.run
[kiro]: https://kiro.dev
[ncc1701]: https://www.youtube.com/watch?v=I1TDgQFkOq4&t=42
[polyglot]: $ref:polyglot.md
[pontil-project]: $ref:pontil.md
[squall#2]: https://github.com/bigmoves/squall/pull/2
[squall#3]: https://github.com/bigmoves/squall/pull/3
[squall#4]: https://github.com/bigmoves/squall/pull/4
[squall]: https://hexdoc.pm/squall
[starlist-project]: $ref:starlist.md
[starlist]: https://github.com/halostatue/starlist
[stars]: https://github.com/halostatue/stars
