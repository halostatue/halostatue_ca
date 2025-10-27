---
redirects:
  aliases:
    - /2007/08/beyond-time/
    - /posts/beyond-time/
date: 2007-08-04T22:26:35-04:00
revisions:
  - date: 2014-09-28
    rev: |
      This article has been updated to update links and to provide footnotes
      indicating the current status of the projects mentioned.
  - date: 2026-02-15
    rev: |
      Nearly twelve years after the last update and almost nineteen years
      after the original post and it's fascinating what has and has not
      changed. [Prawn PDF][prawn] still exists, but a new release hasn't been
      made since 2020.

      `Transaction::Simple` hasn't been touched since the original post, other
      than moving it to [GitHub][hts], where I archived it in 2021.

      [`color`][hco], on the other hand, became active again last year when
      I reimplemented the entire library to be Ruby 3.2+ compatible and
      started using Data classes. Still not using matrix math, but it's better
      than it was and has some future. Contributions are still welcome.

      [prawn]: https://github.com/prawnpdf/prawn
      [hts]: https://github.com/halostatue-archive/transaction-simple
      [hco]: https://github.com/halostatue/color

tags:
  - Ruby
title: Beyond time
---

In Twitteriffic today, I hit the wrong button on a message sent by
[Nathaniel Talbott](https://www.twitter.com/ntalbott) and it took me to his
[blog](http://blog.talbott.ws), which had his entry about
[handing off test/unit](http://blog.talbott.ws/articles/2007/6/20/test-unit-a-time-to-maintain-and-time-to-hand-off)
to Ryan Davis.<!--more-->

It has taken me a long time to reach this point, but it has to happen: I no
longer have time to maintain PDF::Writer and most of its support libraries. I
need a successor. Over the last year (since RubyConf 2006), I have been talking
with several people, but no one has actually submitted patches for me to review
so we could push out some fixes. I don't really want to give up PDF::Writer or
its ancillary libraries, but I owe it to the community to find a maintainer who
will be more responsive and put more effort into it than I have. There are some
issues to sort out regarding the pieces of the projects, and some changes that I
would like to see someone implement. There are basically three projects:

1. `Transaction::Simple`. This has improved significantly since the last
   release, but I have not yet implemented the Ruby 1.9 Marshal.load block trick
   that Matz implemented for me after a minimal case for a `#become`-like
   behaviour was shown.[^tsimple]
2. `color` (née color-tools): This involves someone else, because after some
   preliminary discussion last year, I moved the color-tools codebase to the
   Color project on RubyForge and restructured things to be a bit smarter.
   There's also some work that should happen hear regarding colour profiles, but
   that's manageable. I basically want to work with the current owner of the
   Color project to hand this entire project off to someone who is interested in
   the math behind colours, and has the expertise to do something with it.[^color]
3. `PDF::Writer`. The big one. ~~I need someone to take care of this.~~ No, the
   community needs someone to take care of this. I'm more than willing to share
   some thoughts about the code, but it's a bit of a mess, and there are better
   ways to do what I did. The code can't support the ultimate goal of reading.[^pdf-writer]

None of this means that I'm giving up on Ruby, or on PDF generation[^pdf]; if I
find time, you may yet find a different set of PDF tools from me in the future.
But PDF::Writer is here and it needs someone to help maintain it. Could that be
you? Comments open on this post for interested parties to let me know. Be
warned: I'm not just handing off PDF::Writer. I'm going to be looking at code
samples; wanting patches. I need to know that you're going to give the care the
PDF::Writer needs and deserves before I hand off the virtual keys to the
project.

[^tsimple]: `Transaction::Simple` has not been handed off to anyone. I'm still
    open to offering it to someone who wants to, but I suspect it would do very
    well being updated to be Ruby 1.9-only or even Ruby 2.x-only and using some
    of the new functionality offered by Ruby. It will probably be 2015 before I
    can look at doing this work myself.

[^color]: `color` has also not been handed off to anyone. I've started working
    more closely with it, but it's not been a top priority. I'm working toward a
    2.0 release and hope to have at least one co-maintainer based on the work
    people have put into the code going into 2.0 by late 2015.

[^pdf-writer]: `PDF::Writer` was successfully handed off (to
    [@sandal](https://github.com/sandal)) and ultimately retired in preference
    to [Prawn](https://github.com/prawnpdf).

[^pdf]: Yes, I did give up on PDF generation. There are other projects that have
    been more important to me, and the Prawn team ~~is doing~~ did awesome work.
