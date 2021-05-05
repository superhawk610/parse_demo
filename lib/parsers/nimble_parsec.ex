defmodule ParseDemo.Parsers.NimbleParsec do
  @moduledoc "Parser built on `nimble_parsec`."

  defmodule Parser do
    @moduledoc false

    import NimbleParsec

    key_prefix =
      utf8_string([{:not, ?[}, {:not, ?]}], min: 1)
      |> label("leading key prefix")

    access_at =
      integer(min: 1)
      |> map(:to_access_at)

    defp to_access_at(n), do: Access.at(n)

    array_notation =
      ignore(string("["))
      |> concat(access_at)
      |> ignore(string("]"))

    defparsec :parse,
              key_prefix
              |> concat(repeat(array_notation))
              |> eos()
  end

  @doc "Parse an input string."
  @spec parse(String.t()) :: {:ok, [term(), ...]} | {:error, String.t()}
  def parse(input) do
    case Parser.parse(input) do
      {:ok, access_keys, _, _, _, _} ->
        {:ok, access_keys}

      {:error, "expected leading key prefix", _, _, _, _} ->
        {:error, "expected leading key prefix"}

      {:error, _, _, _, _, _} ->
        {:error, "invalid array notation"}
    end
  end
end
