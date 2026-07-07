---
title: MDExCustomHeadingId
layout: HalostatueCa.ProjectLayout
related_tag: MDExCustomHeadingId
categories: [Elixir, MDEx plugin]
description: |
  Extends MDEx to support custom heading IDs using `{#id}` syntax.
project_links:
  - GitHub: https://github.com/halostatue/mdex_custom_heading_id
  - hex.pm: https://hex.pm/packages/mdex_custom_heading_id
  - hexdocs: https://mdex-custom-heading-id.hexdocs.pm
  - Apache 2.0: https://github.com/halostatue/mdex_custom_heading_id/main/blocl/LICENCE.md
---

`MDExCustomHeadingID` is an [MDEx][mdex] plugin that supports custom heading IDs
using the widely-accepted `{#id}` syntax. When the `header_id_prefix` extension
is enabled, custom heading IDs override the automatic header ID generation, but
will reuse the `header_id_prefix` prefix provided.

<div class="code-transform">

```elixir
MDEx.to_html!(
  "## My Heading {#custom-id}\n\n## My Other Heading",
  plugins: [MDExCustomHeadingId],
  extension: [header_id_prefix: ""]
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

[mdex]: https://mdex.hexdocs.pm
