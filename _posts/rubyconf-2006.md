---
redirects:
  aliases:
    - /2006/10/rubyconf-2006-day-0/
    - /posts/rubyconf-2006-day-0/
    - /series/rubyconf-2006/
  fragments:
    "/2006/10/rubyconf-2006-day-1/": "#day-1"
    "/2006/10/rubyconf-2006-day-1-evening/": "#day-1"
    "/2006/10/rubyconf-2006-day-2/": "#day-2"
    "/2006/10/rubyconf-2006-day-2-matz-keynote/": "#day-2"
    "/2006/10/rubyconf-2006-day-3/": "#day-3"
    "/posts/rubyconf-2006-day-1/": "#day-1"
    "/posts/rubyconf-2006-day-1-evening/": "#day-1"
    "/posts/rubyconf-2006-day-2/": "#day-2"
    "/posts/rubyconf-2006-day-2-matz-keynote/": "#day-2"
    "/posts/rubyconf-2006-day-3/": "#day-3"
date: 2006-10-22
revisions:
  - date: 2014-09-25
    rev: |
      The original versions of these articles were written as travelogue
      stream-of-consciousness that were a little hard to read. I have tried to
      make them a bit clearer, and have added some comments about how things
      have turned out in the years since.
  - date: 2025-01-01
    rev: |
      Combined the six original RubyConf 2006 posts into a single
      retrospective.
tags:
  - Ruby
  - RubyConf
title: RubyConf 2006 (Denver, Colorado)
---

RubyConf 2006 was held in Denver, Colorado from October 19–22, 2006. This is a
combined retrospective of my notes from the conference.

<!--more-->

## Day 0: Thursday, 19 October 2006 {#day0}

I landed safely in Denver and managed to find the express shuttle to the Embassy
Suites. Somehow, I didn't manage to find the ticket desk for the express
shuttle, but I was allowed on the shuttle and paid cash when we arrived. Both
Caleb Claussen and Ogino Jun-ichi were on the platform. Of the eleven people in
the van, five of us were Rubyists coming to the conference (I believe the other
two were Mike and Claire from England; I may have the names wrong).

Shortly after arriving, Jim Freeze, Bil Kleb, Hal Fulton, Chris Lehman, and Alan
Whitaker and I went to Casa Bonita: a Mexican restaurant with third-rate food
(especially the vegetarian food; Velveeta is not Mexican) and second-rate
entertainment, including a sketch artist, a too-loud Mariachi band, and a gal
who did high dives into a pool not too far from our table. I'm not sure I'd go
back to it, but it was well worth the visit, especially with the folks who were
there. We had a really good time and had some interesting discussions. RubyConf
is off to a great start.

## Day 1: Friday, 20 October 2006 {#day-1}

The first official day of RubyConf started with several announcements.

- Bil Kleb and NASA provided power cords throughout the room, and attendees were
  warned against daisy-chaining these cords.

- Josh Susser had the flu, and would not be presenting his scheduled talk ("More
  than enough rope to hang yourself"). Instead, there would be nine five-minute
  lightning talks.

- I made an announcement about some discussions I was having at the time with
  the VisualStudio development team at Microsoft, and requested examples of
  problems people were having with Win32 extensions. I indicated that I would
  post a summary of the discussion to my blog later.

- Ryan Davis re-announced RejectConf scheduled for after Matz's keynote.

The first talk was Masayoshi Takahashi (the inventor of the
[Takahashi method][tm] of presentation) about the history of Ruby, which was
both highly entertaining and informative. Most people may not have been aware
that there was no Ruby-only conference in Japan prior to 2006, although there
were conferences that included Ruby (the LL day/weekend conferences, culminating
in this year's LL Ring; also the YAPRC (Yet Another Perl and Ruby Conference)
events for a few years. The reason for this? There wasn't enough passion in the
Japanese Ruby community to spur the planning of such a conference. There were so
many books published for Ruby in Japan that there was a bubble that burst
in 2003.

[tm]: https://en.wikipedia.org/wiki/Takahashi_method

The second talk was Evan Phoenix's discussion of Sydney and Rubinius. This is a
fascinating project that may provide some direction in the future[^rubinius],
but is something Evan will be working on over the next while and will be worth
watching as it possibly becomes another Ruby interpreter.

After lunch, Geoffrey Grosenbach gave his talk about the various dynamic graphic
libraries in Ruby with demonstrations of why one would use graphical
representation of data with example Ruby code on how to generate many of them.
There's definitely a lot of things to consider for future projects. I may be
pulling some of this into PDF::Writer (both SVG and PNG generation will be
directly useful) when I finally get back to working on that[^fail].

Kevin Clark's presentation about `mkrf` (a Rake-based replacement for `mkmf`)
was fascinating, and I think that there's a possibility that it could be a very
useful thing in the future, especially if `distutils` style capabilities are
added in the near future, increasing the ability to use alternative compilers. I
think it'll be a little while before `mkrf` is really production-ready. Chad
(Fowler) asked Kevin to write some code for RubyGems to help look for external
capabilities (such as the presence of the MySQL library); I'd have some concern
about this working well on Windows because `mkrf` doesn't yet really have good
Windows support, but I think it's very important to add.

Zed Shaw gave an interesting presentation about security testing with fuzzing
and some statistical analysis. If you're doing anything with anything that has
to do security checking, you really want to read his slides when he's posted
them—the concepts he presents are good for that. By the way: if you're writing
software that people use, you're writing something that needs security checking.

Finally, John Long talked about Radiant, the Rails-based CMS which now runs
ruby-lang.org. It seems like it could turn out to be a very interesting CMS in
the future, but it has a ways to go now.

[^rubinius]: Rubinius had some interesting directions initially, but there was a
    long period of instability, so none of my projects test against Rubinius. I
    consider TruffleRuby and Artichoke to be far more interesting than Rubinius
    ever was.

[^fail]: I really never got back into it, but that's OK, as I handed PDF::Writer
    over to the very capable hands of Greg Brown
    ([@sandal](https://github.com/sandal)) who ultimately replaced it with
    [prawn](https://github.com/prawnpdf/prawn).

### Friday Evening

Dinner tonight was at Old Chicago with Hal Fulton, Ara Howard, Patrick Hurley,
Tim Pease, and various others whose names I can't remember offhand. Great
dinner, and I was able to fully explain the problem with **why** the Ruby
extension situation on Windows is so bad.

I also started talking about **the** big problem that I have with
[`Transaction::Simple`](https://github.com/halostatue/transaction-simple) and
haven't figured out how to solve in a general way (details below). They weren't
quite understanding it, so before Matz's Round Table, I showed them a test case
that I had come up with while talking with Francis Cianfrocca.

The Round Table was pretty short; not too many questions were asked this year,
and the discussion didn't continue for an hour as it did the year before. I was
shot down when asking for "become" behaviour (related to the Transaction::Simple
bug). After the Round Table, I managed to snag Matz to talk about the problem
which led me to request this. I showed him the test case:

```ruby
require 'rubygems'
require 'transaction/simple'

class Child
  attr_accessor :parent
end

class Parent
  include Transaction::Simple

  attr_reader :children

  def initialize
    @children = []
  end

  def <<(child)
    child.parent = self
    @children << child
  end
end

parent = Parent.new
puts "parent.object_id: #{parent.object_id}"
parent << Child.new
puts "parent.children[0].parent.object_id: #{parent.children[0].parent.object_id}"
puts "starting transaction"
parent.start_transaction parent << Child.new
puts "parent.children[1].parent.object_id: #{parent.children[1].parent.object_id}"
puts "aborting transaction"
parent.abort_transaction
puts "aborted transaction"
puts "parent.object_id: #{parent.object_id}"
puts "parent.children[0].parent.object_id: #{parent.children[0].parent.object_id}"
parent << Child.new
puts "parent.children[1].parent.object_id: #{parent.children[1].parent.object_id}"
```

This produces the output:

```
parent.object_id: 3265800
parent.children[0].parent.object_id: 3265800
starting transaction
parent.children[1].parent.object_id: 3265800
aborting transaction
aborted transaction
parent.object_id: 3265800
parent.children[0].parent.object_id: 3265500
parent.children[1].parent.object_id: 3265800
```

This bug affects `PDF::Writer`'s table generation and contributes significantly
to the high memory usage. What's happening is that when you call
`Parent#start_transaction`, `Transaction::Simple` creates a transaction
checkpoint with `Marshal.dump`. When you call `Parent#rewind_transaction` or or
`Parent#abort_transaction`, the transaction checkpoint is reverted. This
reversion is extremely robust except for this one item. What we really need is
something like `self = Marshal.restore(checkpoint)`.

Obviously, that won't work and this leads to the problem that is illustrated
above. After long discussion with Tim Pease, Patrick Hurley, and Matz, we came
up with a workaround that can work for the example bug and for `PDF::Writer`.
It's not super-efficient, though. Essentially, I will modify
`Transaction::Simple` to have callback methods for post-processing after a
transactional operation. Something like this:

```ruby
# Extending the above definition
class Parent
  def post_restore_hook
    @children.map! { |child|
      child.parent = self unless self.object_id == child.parent.object_id
      child
    }
  end
end

parent = Parent.new
puts "parent.object_id: #{parent.object_id}"
parent << Child.new
puts "parent.children[0].parent.object_id: #{parent.children[0].parent.object_id}"
puts "starting transaction"
parent.start_transaction parent << Child.new
puts "parent.children[1].parent.object_id: #{parent.children[1].parent.object_id}"
puts "aborting transaction"
parent.abort_transaction
parent.post_restore_hook # would be called automatically in the real case
puts "aborted transaction"
puts "parent.object_id: #{parent.object_id}"
puts "parent.children[0].parent.object_id: #{parent.children[0].parent.object_id}"
parent << Child.new
puts "parent.children[1].parent.object_id: #{parent.children[1].parent.object_id}"
```

This produces the output:

```
parent.object_id: 3265800
parent.children[0].parent.object_id: 3265800
starting transaction
parent.children[1].parent.object_id: 3265800
aborting transaction
aborted transaction
parent.object_id: 3265800
parent.children[0].parent.object_id: 3265500
parent.children[1].parent.object_id: 3265500
```

This isn't great: it doesn't feel very Ruby to me, but it does get the job done.
It's also not very efficient. After thinking about this for the better part of
an hour, Matz has suggested that there might be a very ugly hack that's possible
that he'll look at for me, which may be able to implement everything in
`Transaction::Simple`.

## Day 2: Saturday, 21 October 2006 {#day-2}

I overslept today and have a high-altitude headache. I ended up missing
Nathaniel Talbott's talk on how he's running his Ruby consulting company and
approaches that others can take.

Laurent Sansonetti's demonstration on OS X integration with Ruby was very well
done, with excellent demonstrations of controlling iTunes with Ruby from irb and
with a Ruby/Cocoa GUI. It's nice to see Apple committing at least Laurent's time
to Ruby support[^hipbyte]. It'd be nice to see Microsoft committing resources,
too.

My headache was too bad for me to attend Glenn Vandenburg's talk about Rinda in
the real world, which is too bad, because the parts of it that I caught seemed
really interesting[^rinda].

I had lunch, and then I came back half-way through the lightning talks. Very
interesting stuff. Rich Kilmer presented because Jim Weirich couldn't be here
this year, and he presented about the Indi service that he and Tom have been
working on. Very interesting, and I think it could be an interesting service.
I'll probably play with it soon. (Or at least as he makes it available.)

Tim Bray presented on I18N and M17N as they relate to Ruby. The most extensive
effort so far for identifying characters in human writing forms is Unicode; the
Unicode Standard 5.0 is soon to be released[^unicode7]. Unicode 5.0 and ISO
10646 are identical. Unicode characters are represented in 17 planes; the first
plane is called the Basic Multilingual Plane. There's only 9% usage in the total
plane (1,114,112 available). Tim's presentation was mostly a survey over what
various languages do—and what Ruby should do. I had a chat with him after his
presentation to clarify a few things, and I think we're mostly in agreement. One
interesting point: when Tim asked the audience if they understood Unicode, only
about FIVE of us raised our hands (myself included). Tim recommends reading
[The World's Writing Systems][twwsptd] by Peter T. Daniels, the W3C's
[Character Model for the WWW 1.0: Fundamentals][charmod] and the current Unicode
Standard.

[twwsptd]: https://search.worldcat.org/title/31969720
[charmod]: http://www.w3.org/TR/charmod

Michael Granger presented the Linguistics package. Really neat. When it was
done, I offered him the Text::Hyphen package for multilingual hyphenation. I
need someone to pick it up and maintain it as I no longer have time to maintain
most of the projects that I work on. He seemed interested, but I'll catch him
tomorrow and talk with him in more detail—or I'll try to catch him after the
conference by email.

Dinner was acceptable (barely; the vegetarian dish was the same thing that they
had served for lunch on Day 1), but I met Kirill Sheynkman who may end up
joining the PDF::Writer project in the near future to work on things that I
don't have time to work on, freeing me up from having to worry about certain
maintenance issues so I can work on the next generation that includes reading.
After that, Matz's keynote.

[^hipbyte]: Laurent has moved on to found HipByte, which shipped
    [RubyMotion](http://rubymotion.com), now owned by DragonRuby LLP.

[^rinda]: I had
    [The dRuby Book: Distributed and Parallel Computing with Ruby][druby-book]
    in my PragProg wishlist, but it's available online.

[^unicode7]: As of 2014-09-25, Unicode 7.0 is the current specification release.

[druby-book]: https://www.druby.org/sidruby/the-druby-book.html

### Matz's Keynote

Matz's keynote this year was entitled "The Return of the Bikeshed, or Nuclear
Plant in the Backyard".

Ruby is often seen by people as either a scripting language (which in the West
is often seen as derogatory), a programming language (so vague as to be
useless), a lightweight language (popular in Japan), and a dynamic language
(relatively new). Matz applied the insights of the [Agile Manifesto][agile] to
programming languages (Steve Yegge is right that most people take the Agile
Manifesto wrong and do it wrong; Steve Yegge is wrong in thinking that it's
therefore useless).

[agile]: http://agilemanifesto.org/

- Individuals and interactions over processes and tools: the language design
  should focus on users.
- Working software over comprehensive documentation: the language should
  encourage readability.
- Customer collaboration over contract negotiation: the language should be
  expressive, and helps communication between developers.
- Responding to change over following a plan: the language should embrace
  changes, and be dynamic.

Looking at this, Matz concludes that Ruby is an **Agile Language**.

Matz noted that Ruby has Good things (it's a sweet language, Rails, the
community—as Martin Fowler says, Ruby people are nice); Ugly things (eval.c,
parse.y); and Bad things (Ruby 2 being vapourware for such a long time: it's
close to being the longest vapourware in open source—Rite the concept is older
than Parrot and Perl 6)[^ruby2].

The Bikeshed represents an easy problem. People tend to argue about little
things that they know enough about to do so, such as what colour a bikeshed
should be. The amount of argument caused by a change is inversely proportional
to the size of the change. Ruby has several bikesheds: the discussions on String
and Symbol; the possible removal of private and protected; whether Ruby needs
(optional) static typing.

On the other hand, nuclear plants are complex and important, so we tend to leave
discussing them to the experts. So we spend most of our time discussing
relatively unimportant things, leaving important things yet to be discussed.

Some consider Ruby a fragile language, but Ruby 1.8 is generally good enough.
This means that although Matz would like to get Ruby 2.0 out, we're not in a
hurry and each idea has its own value which must be discussed. Instead of
stopping bikeshed arguments, Matz says we should accelerate them: Extreme
Arguing. If arguing is good, we should make things easy enough to be argued by
anyone.

The RCR process hasn't worked out as well as Matz wanted it to. Some people
didn't take RCRs very seriously; some took RCRs far too seriously. Thus, Matz is
introducing what he calls the Design Game. The purpose of the Design Game is to
open language design to everyone in an accessible manner. It will:

- Gather Wild & Weird Ideas
- Try to make Ruby the Best Language Ever
- Shed light to undefined corners of Ruby
- Finally (if possible), document Ruby specification.

There are some fundamental rules of the Design Game:

1. Ruby will stay Ruby. We're not creating a new language or a new Smalltalk or
   a new Lisp. About 80–90% compatibility will be preserved, if not more. Each
   proposal must follow the same philosophy we love about Ruby.
2. Design Game proposals must not be vague ideas. It's hard to impossible to
   start useful discussions with vague ideas.
3. Design Game proposals must have rationale and analysis. Entries that don't
   have a rationale and analysis section will be rejected out of hand. Matz will
   probably use a format similar to the Python Enhancement Proposal (PEP).
4. Discussion will happen on one or more mailing lists, possibly a single
   mailing list per proposal. RCRchive[^dead] will probably be a starting point,
   but there may be a new system to control traffic: possibly qwik or
   trac[^modern].
5. Proposals with a prototype implementation will be favourably smiled upon as
   concrete code helps a fruitful discussion.
6. Matz is still the Benevolent Dictator…but promises to be as open as possible.

Matz is doing this because he wants to share the fun of language design among
the community and is tired of the slow evolution of Ruby (despite him being the
bottleneck). Most of us are using technology from three years ago and if we
(Ruby) don't accelerate, others will catch up. This is also to help educate
developers in the community: language design shares much in common with other
software design. Additionally, Matz wants the process to be continuable if he
were to be hit by a truck (heaven forfend).

Matz may or may not set a deadline for the Design Game and has tentatively
considered 2007-04-30 as such a date. After that, we (the community) will
classify proposals as either Good, Bad, or Ugly and as targeted for 1.9 or 2.0.
The good proposals will be implemented, and if they are ready, they will be
merged. If the game doesn't work, it's not a problem: we'll try something else,
we've lost nothing but time.

Matz is still planning on releasing a stable version of Ruby 1.9 (1.9.1) for
Christmas 2007 with YARV and other changes to come.

Important notes:

- The Game will apply to changes to core and standard libraries, but core is
  preferred.
- They will be keeping up with Windows changes as Vista came.
- Not necessarily for enterprisey stuff.
- Tests should probably included with proposals, too.
- The parser could theoretically be replaced in a non-backwards-compatible form.

[^ruby2]: It took another seven years to release Ruby 2.0, but it feels like it
    has a better take-up rate than Python 3, at least to me.

[^dead]: RCRchive no longer exists.

[^modern]: Modern design discussions occur on the Ruby
    [bug tracking system](https://bugs.ruby-lang.org/) and
    [ruby-core](http://blade.nagaokaut.ac.jp/ruby/ruby-core/index.shtml).

## Day 3: Sunday, 22 October 2006 {#day-3}

Justin Gehtland presented the sole Rails-related talk, as he was presenting
Streamlined[^streamlined]. I'm quite impressed and would have loved to have
known about this for my simple wedding guest list manager application that I
wrote in Rails. The purpose of Streamlined is to fill in the stuff that's
necessary for the administrative work for a Rails application. It wholly rocks.
By the new year, Streamlined will have a visual configuration mode for this.

While waiting for Sasada Koichi to set up, I suggested to Matz that perhaps
something like RubyInline be included with the Ruby 1.9/2.0 release so that
Transaction::Simple can dump singleton objects and the marshal format would be
compatible between the various interpreters.

Sasada Koichi presented on the current state of YARV. He has recently gotten a
job in Akihabara Sanctuary. The advances of YARV look impressive. He was running
a Rails application on YARV with no problems. Nice.

John Lam reported on his Ruby/CLR bridge, which was started because he writes
programs for his son's birthday. Fascinating work, and amazing enough that
Microsoft finally twisted his arms well enough for him to work on them to
improve the CLR so that it better supports dynamic language. As someone—possibly
James Gray—suggested at lunch: we've heard from three major platform vendors
that they are taking Ruby very seriously. That rocks.

This afternoon we heard from [Adam Keys](http://therealadam.com/) with a one-act
"play" (Adam Keys and the USS Ruby), originally from the RejectConf evening.
I've embedded[^embed] it below for your viewing pleasure.

{ embed -- https://www.youtube.com/watch?v=yJ-bnIKbOwM }

I gave a quick introduction to the Google Summer of Code process and what it did
for Ruby. The introduction was an adaptation of the talk that I gave at LRUG in
July. The numbers: 17 volunteers; 96 applications; 84 eligible; ~25 desired; 10
accepted; 7 or 8 completed (I know we had 8 at the beginning of July; I think
one more dropped out in the interim). Greg Brown presented about his experience
of doing Ruport for the Summer of Code. He was mentored by David Pollak. Jeff
Hughes talked about porting Ruby to Symbian phones. He was mentored by Dibya
Prikash. Jason Morrison spoke on Ruby Type Inference & Code Completion for RDT.
The approach he used was naïve, but based on DDP by Lex Spoon (S. Alexander
Spoon), which is Demand-Driven Analysis with Goal Pruning. Type flow analysis;
it unions types over contours. He was mentored by Chris Williams.

That ended RubyConf 2006.

[^streamlined]: The original link from here is dead.

[^embed]: My hosted version of the video no longer exists, but yay for YouTube.
