# ParseDemo

This repository contains a few different approaches to parsing string representations
of key access with optional array notation. The goal of each parser is to transform
an input string like the following:

```plain
foo
foo[1]
foo[1][2][3]
```

into an array access list that can be passed to `Access` functions like `Kernel.get_in/2`:

```elixir
["foo"]
["foo", Access.at(1)]
["foo", Access.at(1), Access.at(2), Access.at(3)]
```

## Benchmarks

To run the benchmark suite, simply do

```bash
mix run scripts/benchmark.exs
```

## Parsers

Three parsing approaches are considered:

- regular expression-based parsing
- hand-coded parsing with recursive binary pattern matching
- parser combinators via `:nimble_parsec`

### Regular Expressions

This parser uses a regular expression and `Regex.run/3` to pick out matching substrings
and parse the result. It can be found at `ParseDemo.Parsers.Regex`. It's the most concise
of the three, but also a bit difficult to understand at a glance.

### Hand-coded

This parser uses recursion and binary pattern matching to iterate over the input string
character-by-character and translate the input. It contains the most complex implementation,
but also allows for very granular error messages. It can be found at `ParseDemo.Parsers.Manual`.

### Parser Combinators with `:nimble_parsec`

This parser uses parser combinators to build a top-level parser out of many smaller building
block parsers. It provides good error messages and is written in a very declarative way, so
it should be very easy to understand at a glance. It can be found at `ParseDemo.Parsers.NimbleParsec`.

If you're unfamiliar with parser combinators, `ParseDemo` contains a very rudimentary implementation
of a few common parser combinator building blocks. For more information, you should check
out [this article](http://theorangeduck.com/page/you-could-have-invented-parser-combinators).
