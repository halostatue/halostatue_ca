---
redirects:
  aliases:
    - /2014/10/mime-types-io/
    - /posts/mime-types-io/
date: 2014-10-01
tags:
  - Io
  - Ruby
  - Seven Languages
title: mime-types for Io
revisions:
  - date: 2026-02-23
    rev: |
      As the second and third footnotes indicate, none of the further
      explorations with this happened for a lot of reasons, and I archived
      mime-types for Io in 2025.
---

I recently finished reading [Seven Languages in Seven Weeks][7l7w]. As an
exercise, I ported [mime-types for Ruby][rmt] to [Io][io] on September 17.

[7l7w]: https://pragprog.com/titles/btlang/seven-languages-in-seven-weeks/
[io]: http://iolanguage.org/
[iospec2]: https://github.com/quag/iospec2
[rmt]: https://github.com/mime-types/ruby-mime-types
[imt]: https://github.com/mime-types/io-mime-types

<!--more-->

[`mime-types` for Io][imt] is both a library and a registry for type information
(and reuses the JSON registry from the Ruby library). It works similarly to the
Ruby version[^no-deprecations]:

```io
plaintext := MimeTypes["text/plain"] # => returns list(text/plain)
text := plaintext first
text mediaType println # => text
text subType println # => plain
text extensions join(" ") println # => asc c cc h hh…
text encoding println # => quoted-printable
text isBinary println # => false
text isAscii println # => true
text isObsolete println # => false
text isRegistered println # => true
text isLike("text/plain") println # => true
MimeType simplifiedFor("x-appl/x-zip") println # => "appl/zip"
```

I'm reasonably happy with the code that I wrote in the port, although I am not
sure if it would count as “idiomatic” Io. The most difficult part was
implementing `foreach`. Let's compare how you do this in Ruby versus Io.

```ruby
class Collection
  def each
    @inner_collection.each { |v| yield v }
  end
end
```

This is fairly simple to understand; when you iterate over a `Collection`
registry, you will loop through each item and yield it to the provided block.

The implementation of the equivalent method in Io is a little more complex. The
canonical `foreach` method accepts either two or three parameters, and the
_first_ parameter is the optional parameter:

```io
collection foreach(value, message)
collection foreach(index, value, message)
```

An additional difficulty is that the `index` and `value` parameters are _names_
that will be used in the `message`. Understanding this and implementing it
properly is _key_ to understanding Io. It took me a while, but the key is to
treat the provided names as slots on the `call sender`. So, as you're iterating
through an inner collection for which you're exposing `foreach`, you set the
slot to the iterated value. This is what a two-parameter
`foreach(value, method)` implementation might look like:

```io
foreach := method(
  name := call argAt(0) name
  result := nil

  innerCollection foreach(
    item, call sender setSlot(name, item)
    result := call evalArgAt(1)
  )

  result
)
```

How does it work? If we follow the execution of `foreach(v, v println)`, we will
be working with a slot called `v`. As we step through `innerCollection`, we set
the `call sender`'s `v` slot with the value of `item`. We then evaluate the
message argument (`call evalArgAt(1)`)—which executes in the context of
`call sender`, which is how it can access the `v` slot.

The next step is to support the optional index parameter. It's not hard, but it
requires modification to the loop in the `innerCollection`. The main thing to
remember is that the `message` argument _may_ be at offset 1, but if there is an
`index` parameter, it will be at offset 2. (This would be easier if the message
were guaranteed to be in a fixed position, but such is life.) So we need to
store the message offset in a slot within the function.

```io
foreach := method( // Assume value, message by default
  indexName := nil
  valueName := call argAt(0) name
  msgOffset := 1

  if(
    call argCount == 3, // But we have index, value, message
    indexName := call argAt(0) name
    valueName := call argAt(1) name
    msgOffset := 2
  )

  result := nil

  innerCollection foreach(
    index, item, if(
      indexName isNil not, call sender setSlot(indexName, index)
    )
    call sender setSlot(valueName, item)
    result := call evalArgAt(msgOffset)
  )

  result
)
```

Now, if we follow `foreach(i, v, list(i, v) println)`, slots for `i` and `v`
will be set on the `call sender`, so that when `call evalArgAt(msgOffset)` is
evaluated, both the index and the value will be available to the message.
Because `innerCollection` is just a simple collection, it is possible to use the
`foreach(index, value, message)` version—but in the implementation for
MimeTypes, the collection is a `Map` and each value is a `list`—and the
iteration is across the items in the contained `list`, so the index needs to be
managed inside of the created `foreach` loop.

All in all, I found Io interesting to work with and plan on maintaining this
library moving forward to keep in practice with Io[^hah], even if I don't end up
shipping anything else in Io. I will also port `mime-types` to Prolog, Scala,
Erlang, Clojure, and Haskell—but each of these languages are not as accessible
as Io turned out to be, especially as I wish to continue using the
infrastructure provided by the Ruby version[^haha].

[^no-deprecations]: None of the then-deprecated methods or behaviours in the
    Ruby version of mime-types were carried over.

[^hah]: That didn't happen.

[^haha]: That didn't happen, either.
