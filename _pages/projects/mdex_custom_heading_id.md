---
title: MDExCustomHeadingId
layout: HalostatueCa.ProjectLayout
related_tag: MDExCustomHeadingId
categories: [Elixir, MDEx plugin]
project_links:
  - Source Code: https://github.com/halostatue/mdex_custom_heading_id
  - Hex Package: https://hex.pm/packages/mdex_custom_heading_id
  - Documentation: https://hexdocs.pm/mdex_custom_heading_id
---

`MDExCustomHeadingID` is an [MDEx][mdex] plugin that supports custom heading IDs
using the widely-accepted `{#id}` syntax. When the `header_ids` extension is
enabled, custom heading IDs override the automatic header ID generation, but
will reuse the `header_ids` prefix provided.

<div class="code-transform">

```elixir
MDEx.to_html!(
  "## My Heading {#custom-id}\n\n## My Other Heading",
  plugins: [MDExCustomHeadingId],
  extension: [header_ids: ""]
)
```

```html
<h2>
  <a href="#custom-id" aria-hidden="true" class="anchor" id="custom-id"></a>
  My Heading
</h2>
<h2>
  <a
    href="#my-other-heading"
    aria-hidden="true"
    class="anchor"
    id="my-other-heading"
  ></a>
  My Other Heading
</h2>
```

</div>

[mdex]: https://hexdocs.pm/mdex
