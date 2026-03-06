---
title: Prosody
layout: HalostatueCa.ProjectLayout
related_tag: prosody
categories: [Elixir, Tableau extension, Text analysis]
project_links:
  - Source Code: https://github.com/halostatue/prosody
  - Hex Package: https://hex.pm/packages/prosody
  - Documentation: https://hexdocs.pm/prosody
---

> **prosody**[^1] | ˈprɒsədi, ˈprəʊzədi | noun _[mass noun]_
>
> 1. **the patterns of rhythm and sound used in poetry**: _the translator is not
>    obliged to reproduce the prosody of the original._
>    - **the theory or study of prosody**: _a general theory of prosody._
> 2. **the patterns of stress and intonation in a language**: _the salience of
>    prosody in child language acquisition_

Prosody is a content analysis library that attempts to measure the reading
effort and cognitive load for mixed text and code content. Most visibly, it
calculates the reading time and makes adjustments when it finds code blocks to
balance the context switching and overall code complexity.

<div class="code-transform">

````elixir
content = """
# Hello World

This is some text.

```elixir
IO.puts("Hello")
```
"""

Prosody.analyze!(content, parser: :markdown)
````

```elixir
%{
  code: %{words: 10, lines: 1},
  text: %{words: 6},
  metadata: %{},
  words: 16,
  reading_time: 1
}
```

</div>

It runs through a three-stage pipeline for analysis. Both parsers and analyzers
can be extended with custom modules.

1. **Parse**: Format-specific parsers ([MDEx][mdex], plain text) convert content
   into blocks.
2. **Analyze**: Block analyzers apply rules for counting words in the detected
   blocks; code blocks have cognitive load adjustments applied.
3. **Summarize**: The analysis results are aggregated into reading time and
   metrics.

During the analysis phase, text blocks can use one of three different baseline
algorithms that can be further configured.

| Example           | Balanced | Minimal | Maximal |
| ----------------- | -------- | ------- | ------- |
| `two words`       | 2        | 2       | 2       |
| `and/or`          | 2        | 1       | 2       |
| `fast-paced`      | 2        | 1       | 2       |
| `1,234.56`        | 1        | 1       | 3       |
| `www.example.com` | 1        | 1       | 3       |

The **balanced** algorithm mostly matches human intuition in splitting
hyphenated words but not splitting URLs or numbers. The **minimal** algorithm
acts like Microsoft Word and LibreOffice, only splitting on spaces. The
**maximal** algorithm splits words on spaces and punctuation, resulting in the
highest word count.

Prosody includes a [Tableau][tableau] extension, `Prosody.Tableau`, to
automatically processes posts and adds reading time to frontmatter for use in
rendering.

[^1]: "prosody." Apple Dictionary / _Oxford English Dictionary_, Version 2.3.0
    (294), Apple Inc., 2025.

[mdex]: https://hexdocs.pm/mdex
[tableau]: https://hexdocs.pm/tableau
