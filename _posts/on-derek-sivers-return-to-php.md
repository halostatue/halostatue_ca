---
redirects:
  aliases:
    - /2007/09/on-derek-sivers-return-to-php/
    - /posts/on-derek-sivers-return-to-php/
date: 2007-09-23
tags:
  - Ruby
revisions:
  - date: 2026-02-15
    rev: |
      Wow. PHP4/PHP5 -- current PHP is 8.5 and I still don't use it. I believe
      that many of the worst parts of PHP have been fixed, but I have had no
      reason to investigate them. Maybe one day.
title: On Derek Sivers's return to PHP…
---

Derek Sivers, [recently abandoned][back2php] his CD Baby rewrite from PHP to
Rails. This isn't bad news for Rails or Ruby, nor is it good news for PHP. It's
good news for CD Baby. Anyone who reads it otherwise is missing the lesson.

[back2php]: https://web.archive.org/web/20071128141900/http://www.oreillynet.com/ruby/blog/2007/09/7_reasons_i_switched_back_to_p_1.html

<!--more-->

There are plenty of reasons to dislike PHP (although all of my criticisms have
to be aimed at PHP4 right now, as I haven't done anything with PHP5), but it is
a useful general purpose language. It has different philosophies than Ruby, and
I think that _in general_ it isn't nearly as good a language as either Ruby or
Python. But it is just fine for a lot of people and projects. Derek's planned
migration to Rails was probably doomed from the beginning for several reasons:

1. Derek chose the technology for the wrong reasons. He chose it partially based
   on the hype of Rails, but he envisioned it as a silver bullet that would
   magically make his application better just because it's in Rails. Rails has
   advantages (not least of which is its language, Ruby), but it has drawbacks
   and weaknesses, too.

2. Rails didn't fit Derek's application model for CD Baby, and Derek's
   application model is more important than the technology to be used, since it
   represents a business he understands well. Rails requires that your
   application fits its model, not the other way around. As Derek says:

   > I hired one of the best Rails programmers…Jeremy [Kemper] could not have
   > been more amazing, twisting the deep inner guts of Rails to make it do
   > things it was never intended to do. But at every step, it seemed our needs
   > clashed with Rails' preferences.

3. He ignored his existing experts for the new technology. Neither he nor his
   employees knew Ruby aside, perhaps, from playing around with it. This wasn't
   a technology that was deemed to be appropriate from experience; this was a
   technology deemed appropriate by management (sorry Derek, you might still be
   getting your hands dirty with code, but you're still management).

   > I've wanted to introduce Ruby in my workplace for several years, but aside
   > from a number of compile-time helper scripts, it hasn't been appropriate to
   > do so. First, our product isn't in Ruby's sweet spot. Second, none of my
   > co-workers know how to deal with it or its development environment. Even
   > when Ruby is a superior choice, it's hard to introduce it, because I'm the
   > only Ruby expert at work.

4. Derek approached the project as a whole-environment ground-up rewrite with a
   One Big Day deployment, without considering ways to phase it in over time.
   It's almost always possible to find interface points where you can replace
   one broken piece at a time. Ultimately, this is what the Rails folks
   ~~would~~should tell you anyway: replace one area at a time, each with a
   different codebase. Interface them as REST-ful services. Don't make them
   depend on a single database schema.

Derek is wrong, though: language matters. A _"better"_ language may not be the
right choice for your environment, but its lessons will help you immensely.
Without the Ruby and Rails experience, Derek would not have known to apply the
lessons Ruby teaches to his PHP rewrite. I find that I write both C++ and C#
with strong Ruby flavours these days. My boss, who has only used Ruby casually,
has come to prefer the Ruby method naming convention (`like_this`) and a number
of Rubyisms that I've introduced. Ultimately, though, Derek's Rails rewrite
failed because he made a number of classic technology management mistakes. Not
because of Ruby, Rails, or PHP. Because of management decisions made for the
wrong reasons. Fortunately, he recognised this and was willing to reverse an
expensive decision to fit his business better.
