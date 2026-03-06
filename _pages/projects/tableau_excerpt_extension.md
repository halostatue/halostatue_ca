---
title: TableauExcerptExtension
layout: HalostatueCa.ProjectLayout
related_tag: tableau_excerpt_extension
categories: [Elixir, Tableau extension]
project_links:
  - Source Code: https://github.com/halostatue/tableau_excerpt_extension
  - Hex Package: https://hex.pm/packages/tableau_excerpt_extension
  - Documentation: https://hexdocs.pm/tableau_excerpt_extension
---

This is a [Tableau][tableau] extension that can automatically extract excerpts
from posts for use in index pages. Posts with an existing `excerpt` field will
be unmodified, and there are three strategies for excerpt extraction.

## Extraction Strategies

Each of the strategies may be disabled by setting its configuration to `false`.

### Excerpt Range Markers

Excerpt specific content from anywhere in the post.

<div class="code-transform">

```markdown
---
title: My Post
---

Opening paragraph.

<!--excerpt:start-->This specific section becomes the excerpt.<!--excerpt:end-->

More content.
```

```elixir
%{excerpt: "This specific section becomes the excerpt."}
```

</div>

### Excerpt Split Marker

The content before the split marker becomes the excerpt.

<div class="code-transform">

```markdown
---
title: My Post
---

This is the first paragraph that will become the excerpt.<!--more-->

This is the rest of the post content.
```

```elixir
%{excerpt: "This is the first paragraph that will become the excerpt."}
```

</div>

### Structural Excerpt Extraction

As a fallback, when no markers are found, content structural extraction is
performed. This strategy is configurable to extract:

- `:paragraph`: extract the first `N` paragraphs (default 1)
- `:sentence`: extract the first `N` sentences (default 2) from the first
  paragraph
- `:word`: extract the first `N` words (default 25) from the first word; if the
  last word does not correspond to the end of a sentence, a continuation marker
  (usually `…`) will be appended.

The definitions of `paragraph`, `sentence`, and `word` are simplistic.
Paragraphs end with two newlines, sentences end with typical English punctuation
(`.?!` with some awareness of quotes), and words are simply split by spaces.

## Markdown Processing

When excerpts are pulled from Markdown content, there is some automatic
cleaning:

- Footnotes are removed from the excerpted text;
- Reference links are converted to inline (`[text][ref]` → `[text](url)`)
- Whitespace is normalized

## Rendering Excerpts

Excerpts are captured in the source content format, so it will be necessary to
call the appropriate content formatter for the excerpt.

```elixir
defmodule MySite.PostsPage do
  def template(assigns) do
    temple do
      for post <- posts do
        if post[:excerpt] do
          div class: "excerpt" do
            Tableau.markdown(post.excerpt)
          end
        end
      end
    end
  end
end
```

[tableau]: https://hexdocs.pm/tableau
