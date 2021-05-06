defmodule ParseDemo do
  @moduledoc "Array notation parser demo."

  @parsers %{
    manual: ParseDemo.Parsers.Manual,
    regex: ParseDemo.Parsers.Regex,
    nimble_parsec: ParseDemo.Parsers.NimbleParsec
  }

  @default_parser :nimble_parsec

  @typedoc "The name of an available parser."
  @type parser_name :: :manual | :regex | :nimble_parsec

  @spec parse_with(parser_name(), String.t()) :: {:ok, [term(), ...]} | {:error, String.t()}
  def parse_with(parser \\ @default_parser, input) do
    case Map.fetch(@parsers, parser) do
      {:ok, parser} ->
        parser.parse(input)

      :error ->
        raise "no parser named #{parser}"
    end
  end

  @spec parse(String.t()) :: {:ok, [term(), ...]} | {:error, String.t()}
  def parse(input), do: parse_with(@default_parser, input)
end
