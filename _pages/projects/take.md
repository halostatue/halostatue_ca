---
title: Take
layout: HalostatueCa.ProjectLayout
related_tag: take
categories: [Gleam, Testing]
description: |
  IO capture for Gleam tests — intercepts stdout, stderr, or both and returns
  captured output as a string.
project_links:
  - Source Code: https://github.com/halostatue/take
  - "take docs": https://hexdocs.pm/take
  - "take_promise docs": https://hexdocs.pm/take_promise
---

Take provides IO capture for Gleam tests, replicating parts of Elixir's
`ExUnit.CaptureIO` module. It intercepts `stdout`, `stderr`, or both and returns
the captured output as a string.

The repository contains two packages:

| Package                        | Description                              | Targets            |
| ------------------------------ | ---------------------------------------- | ------------------ |
| [`take`][take]                 | Synchronous IO capture                   | Erlang, JavaScript |
| [`take_promise`][take_promise] | Async IO capture for `Promise` callbacks | JavaScript         |

## Installation

```sh
gleam add --dev take@1
# If you need async capture on JavaScript:
gleam add --dev take_promise@1
```

## Quick Example

```gleam
import take

pub fn prints_greeting_test() {
  let #(result, output) = take.with_stdout(fn() {
    io.println("Hello, world!")
    42
  })

  assert 42 == result
  assert "Hello, world!\n" == output
}
```

## Packages

### take

Synchronous IO capture for both Erlang and JavaScript targets. Wraps a callback,
captures everything written to `stdout`, `stderr`, or both during execution, and
returns the result alongside the captured output.

### `take_promise`

Async IO capture for JavaScript targets. Like `take`, but accepts callbacks that
return `Promise(a)` and awaits them before returning captured output.

```gleam
import gleam/javascript/promise
import take_promise

pub fn async_greeting_test() {
  use #(result, output) <- promise.await(
    take_promise.with_stdout(fn() {
      io.println("Hello, world!")
      promise.resolve(42)
    }),
  )

  assert 42 == result
  assert "Hello, world!\n" == output
  promise.resolve(Nil)
}
```

[take]: https://hexdocs.pm/take
[take_promise]: https://hexdocs.pm/take_promise
