defmodule ParseDemo.ParserCombinators do
  @moduledoc "Basic parser combinators."

  defmodule Parsers do
    @moduledoc false

    @type parse_result :: {{:ok, term()}, String.t()} | {:error, String.t()}
    @type parser :: (String.t() -> parse_result())

    @spec utf8_char(pos_integer()) :: parser()
    def utf8_char(c) do
      fn input ->
        case input do
          <<^c::utf8, rest::binary>> ->
            {{:ok, c}, rest}

          rest ->
            {:error, rest}
        end
      end
    end

    @spec digit :: parser()
    def digit do
      fn input ->
        case input do
          <<c::utf8, rest::binary>> when c in ?0..?9 ->
            {{:ok, c}, rest}

          rest ->
            {:error, rest}
        end
      end
    end

    @spec end_of_string :: parser()
    def end_of_string do
      fn input ->
        case input do
          "" ->
            {{:ok, ""}, ""}

          rest ->
            {:error, rest}
        end
      end
    end

    @spec concat(parser(), parser()) :: parser()
    def concat(p1, p2) do
      fn input ->
        with {{:ok, p1_output}, rest} <- p1.(input),
             {{:ok, p2_output}, rest} <- p2.(rest) do
          {{:ok, [p1_output, p2_output]}, rest}
        else
          {:error, rest} ->
            {:error, rest}
        end
      end
    end

    @spec zero_or_more(parser()) :: parser()
    def zero_or_more(parser) do
      fn input ->
        do_zero_or_more(parser, input)
      end
    end

    defp do_zero_or_more(parser, rest, acc \\ [])

    defp do_zero_or_more(parser, rest, acc) do
      case parser.(rest) do
        {{:ok, output}, rest} ->
          do_zero_or_more(parser, rest, [output | acc])

        {:error, rest} ->
          {{:ok, Enum.reverse(acc)}, rest}
      end
    end
  end

  def demo do
    parse_a = Parsers.utf8_char(?a)
    IO.inspect(parse_a.("a"))
    IO.inspect(parse_a.("b"))

    parse_a_eos = Parsers.concat(Parsers.utf8_char(?a), Parsers.end_of_string())
    IO.inspect(parse_a.("ab"))
    IO.inspect(parse_a_eos.("ab"))

    parse_ab = Parsers.concat(Parsers.utf8_char(?a), Parsers.utf8_char(?b))
    IO.inspect(parse_ab.("ab"))

    parse_number = Parsers.zero_or_more(Parsers.digit())
    IO.inspect(parse_number.("123"))
    IO.inspect(parse_number.("abc"))
  end
end
