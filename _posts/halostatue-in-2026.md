---
title: "halostatue.ca in 2026"
date: 2026-02-24
tags:
  - Blogging
  - Elixir
---

After a long hiatus, I've decided to restart my website and blog this year. I'm
moving from [Hugo][hugo] to [Tableau][tableau] and from AWS to Hetzner.

<!--more-->

## Build on what you love or what's easy

There are many ~~excuses~~reasons. I was too busy with work and the rest of my
life. The start of the ongoing COVID-19 pandemic in 2020 wasn't inspirational
for writing, at least for me. I didn't love anything about what I had put
together, and the time it had taken to switch and customize it wore me out.

Ultimately, I didn't love working with [Hugo][hugo][^1]. I had a fantastic
static site deployment mechanism dependent on Terraform[^2] that nonetheless
felt like too much work to update because I had no automation.

I've been working slowly over the last couple of years to rebuild using various
tools, and I ultimately settled on [Tableau][tableau] with [Temple][temple] for
templating. Relatively new and written in Elixir, it feels accessible and
extensible in ways that its older siblings like Hugo and Jekyll do not.

## The Elephant In the Room: Generative "AI"

During the last several months, I worked with [Kiro][kiro] as a programming
agent. The results have been astonishing -- it all works, but there was a high
volume of WTFs per minute at some of the output and endless spinning on things
that don't matter. The number of times that Kiro got stuck investigating
something that I had indicated was not broken -- even when running exclusively
on the latest frontier model -- is disturbing. The fact that I was able to fill
in the gaps on things for which I am knowledgeable but not an expert is exciting
(if it weren't for the bad behaviour[^3] of pretty much every "AI" company out
there).

Despite my reservations, it was useful. I would have continued spinning on a
redesign for years because I'm _not_ a great visual designer and my requirements
are too vague: I can't afford my indecision at professional CSS designer rates.
I'm not a CSS expert, but I am a knowledgeable, interested bystander. It's
extremely powerful and misunderstood by most developers, which is what leads to
the development of popular mistakes like Tailwind,
[the worst of all worlds][worst]. Good defaults and modern tools like CSS layers
make a massive difference in terms of quality. I saw Chris Coyier's
[CSS starter][coyier-starter] and knew that it was the base that I wanted. So I
instructed Kiro to use that as the base "reset" and then develop the remaining
CSS for my site with several constraints: no Tailwind, everything must be in CSS
layers, and absolutely no use of `!important` (except for a single instance in
the starter CSS). I've reviewed the results and made some changes myself, but
most of it is generated.

> My promise: you will not see AI-written **content** on this website. Every
> word here is mine.

## Extensions

Not everything I wanted to keep from previous versions of my site worked with
Tableau and Temple out of the box, so I developed and published several Tableau
extensions and MDEx plugins:

- [`mdex_custom_heading_id`][custom_heading_id]: Extends MDEx to support custom
  heading IDs using `{#id}` syntax.
- [`mdex_video_embed`][video_embed]: Makes it easy to embed videos from YouTube
  in Markdown with as much privacy-preservation as possible.
- [`pagefindex`][pagefindex]: Integrated [Pagefind][pagefind] with Tableau for
  site search.
- [`prosody`][prosody]: Calculates reading time and other content metrics
- [`tableau_eex_extension`][eex]: Adds support for pages that are EEX templates.
  This is used to generate [`humans.txt`](/humans.txt).
- [`tableau_excerpt_extension`][excerpt]: Excerpts content from posts.
- [`tableau_pagination_extension`][pagination]: provides paginated collections
  for indexes, tags, tag pages, and more.
- [`tableau_redirects_extension`][redirects]: Generates redirects for moved
  content (because cool URIs don't change).
- [`tableau_ref_link_extension`][ref_link]: Makes it easy to have cross-content
  links.
- [`tableau_social_extension`][social]: Makes it easy to have your social media
  profile links visible.

I also developed a webhook receiver for my Hetzner configuration so that I can
more easily update my website.

- [`dchook`][dchook]

All of these were developed with [Kiro][kiro] and heavily reviewed before
publishing in December 2025, January 2026, and February 2026.

## What's Next?

Who knows? I can almost certainly guarantee that there will be posts with a
political bent, because to not acknowledge that the "feeping crascism" of the
last several decades is now being displayed openly is to try to hide in a hole
of my own privilege. I'm unapologetically Canadian -- a large part of my recent
moves are to be as much "elbows up" as I can in certain choices.

There will also be other posts, about Ruby, Elixir, open source project
maintenance, software architecture and design, conferences, and recipes.
Basically, whatever comes to mind.

There's more that I'm going to build out for this site in terms of extensions
and functionality. I'm planning on building a sort of "Today I Learned" database
section -- except that it won't _just_ be stuff that I learned _today_ -- I've
been around too long.

[^1]: I doubt many of my contributions remain, but I contributed to both Hugo
    and its dependencies. This was my first experience using Go in anything
    other than tutorial projects. I don't love the language, but it works. What
    I truly **despise** in Hugo is [Go text/template][go-template]. It forces
    too many compromises in your content when you want formatting. Maybe in the
    time since I last updated my website this has been fixed, but I also
    disliked the way that themes worked in Hugo and found the design my website
    wore uninspired and hard to work with.

[^2]: It's a good enough model that we used it four or five times for various
    projects at Kinetic. OpenTofu has replaced Terraform and deploying a VPS is
    very different than AWS S3 and Cloudfront, but automation makes _everything_
    better.

[^3]: There is no ethical development of or use of generative AI systems.
    There's not a single "Pure AI" company or AI-pivoted company that isn't a
    bad actor: at a minimum, they all developed their frontier models on massive
    copyright infringement. Most of these companies are so overselling the
    capabilities and reliability of their models that it would be called fraud
    for any other industry. Some of these companies are run by loathsome men who
    make everyone else's lives worse.

    But. All of the projects published in the last eight weeks would not exist
    without an AI coding agent. They're good software. I hope other people find
    them useful. But I simply don't have the time or expertise in each of these
    to have developed them from scratch.

[coyier-starter]: https://frontendmasters.com/blog/the-coyier-css-starter/
[custom_heading_id]: https://hex.pm/packages/mdex_custom_heading_id
[dchook]: https://github.com/halostatue/dchook
[eex]: https://hex.pm/packages/tableau_eex_extension
[excerpt]: https://hex.pm/packages/tableau_excerpt_extension
[go-template]: https://pkg.go.dev/text/template
[hugo]: https://gohugo.io
[kiro]: https://kiro.dev
[pagefind]: https://pagefind.app/
[pagefindex]: https://hex.pm/packages/pagefindex
[pagination]: https://hex.pm/packages/tableau_pagination_extension
[prosody]: https://hex.pm/packages/prosody
[redirects]: https://hex.pm/packages/tableau_redirects_extension
[ref_link]: https://hex.pm/packages/tableau_ref_link_extension
[social]: https://hex.pm/packages/tableau_social_extension
[tableau]: https://hexdocs.pm/tableau
[temple]: https://hexdocs.pm/temple
[video_embed]: https://hex.pm/packages/mdex_video_embed
[worst]: https://colton.dev/blog/tailwind-is-the-worst-of-all-worlds/
