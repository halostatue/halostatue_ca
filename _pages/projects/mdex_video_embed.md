---
title: MDExVideoEmbed
layout: HalostatueCa.ProjectLayout
related_tag: mdex_video_embed
categories: [Elixir, MDEx plugin]
description: |
  Makes it easy to embed videos from YouTube in Markdown with as much
  privacy-preservation as possible.
project_links:
  - Source Code: https://github.com/halostatue/mdex_video_embed
  - Hex Package: https://hex.pm/packages/mdex_video_embed
  - Documentation: https://hexdocs.pm/mdex_video_embed
---

Privacy-respecting video embeds for [MDEx][mdex] using Markdown code blocks.
Only supports video services with enhanced privacy options—currently YouTube via
`youtube-nocookie.com` with click-to-load consent.

<div class="code-transform">

````elixir
markdown = """
```video-embed source=youtube
1bt-FHaFVH8
title=Red Hands by Walk Off the Earth
start=15
```
"""

MDEx.to_html!(markdown, plugins: [MDExVideoEmbed])
````

```html
<div class="video-embed youtube-embed">
  <div class="consent-overlay">
    <p>Click to load video from YouTube</p>
    <button>Load Video</button>
  </div>
</div>
```

</div>

## Examples

### Basic Embed

```video-embed source=youtube
J9INnMMwvnk
title=Ohio by Crosby, Stills, Nash & Young
```

### With Time Range

```video-embed source=youtube
Tm7pZaT9EOs
title=Photosynthesis by Frank Turner
start=30
end=90
```

### Custom Button Text

```video-embed source=youtube
VYOjWnS4cMY
title=This Is America by Childish Gambino
button-text=Watch **{{ title }}**
```

### EmbedLite Mode (Direct Embed)

```video-embed source=youtube
wCDIYvFmgW8
title=Weapon of Choice by Fatboy Slim
mode=embedlite
```

[mdex]: https://hexdocs.pm/mdex
