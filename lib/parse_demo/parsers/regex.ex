defmodule ParseDemo.Parsers.Regex do
  @moduledoc "Regular expression-based parser."

  @regex ~r/(?<key>[a-z0-9]+)(?:\[(\d+)\])*/i

  @doc "Parse an input string."
  @spec parse(String.t()) :: {:ok, [term(), ...]} | {:error, String.t()}
  def parse(input) do
    case Regex.run(@regex, input, capture: :all_but_first) do
      [key_prefix | indices] ->
        accessors =
          indices
          |> Enum.map(&Integer.parse/1)
          |> Enum.map(&elem(&1, 0))
          |> Enum.map(&Access.at/1)

        {:ok, [key_prefix | accessors]}

      nil ->
        {:error, "invalid array notation"}
    end
  end
end
