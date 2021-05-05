defmodule ParseDemo.Parsers.Manual do
  @moduledoc "Hand-coded parser."

  @doc "Parse an input string."
  @spec parse(String.t()) :: {:ok, [term(), ...]} | {:error, String.t()}
  def parse(input), do: do_parse(input)

  def do_parse(input, acc \\ [""])

  def do_parse("", [""]), do: {:error, "empty input"}

  def do_parse("", [{:parse, _} | _]), do: {:error, "missing closing array bracket"}

  def do_parse("", acc), do: {:ok, Enum.reverse(acc)}

  def do_parse(<<"[", _rest::binary>>, [""]) do
    {:error, "must provide a prefix key before array brackets"}
  end

  def do_parse(<<"[", rest::binary>>, acc) do
    do_parse(rest, [{:parse, ""} | acc])
  end

  def do_parse(<<"]", _rest::binary>>, [{:parse, ""} | _acc]) do
    {:error, "empty array brackets ([]) are not allowed"}
  end

  def do_parse(<<"]", rest::binary>>, [{:parse, parsing} | acc]) do
    case Integer.parse(parsing) do
      {index, _} -> do_parse(rest, [Access.at(index) | acc])
      :error -> {:error, "invalid array index: #{parsing}"}
    end
  end

  def do_parse(<<"]", _rest::binary>>, _acc) do
    {:error, "unexpected closing bracket"}
  end

  def do_parse(<<char::utf8, rest::binary>>, [{:parse, parsing} | acc]) do
    do_parse(rest, [{:parse, parsing <> <<char>>} | acc])
  end

  def do_parse(<<char::utf8, rest::binary>>, [prefix | acc]) do
    do_parse(rest, [prefix <> <<char>> | acc])
  end
end
