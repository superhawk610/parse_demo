inputs = ~w(
  foo
  foo[1]
  foo[1][2]
  foo[1][2][3]
  foo[123]
  foo[123][456]
)

benchmark = fn parser ->
  fn ->
    for input <- inputs do
      parser.(input)
    end
  end
end

variants = %{
  "manual" => benchmark.(&ParseDemo.Parsers.Manual.parse/1),
  "regex" => benchmark.(&ParseDemo.Parsers.Regex.parse/1),
  "nimble_parsec" => benchmark.(&ParseDemo.Parsers.NimbleParsec.parse/1)
}

Benchee.run(variants)
