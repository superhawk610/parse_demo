defmodule ParseDemoTest do
  use ExUnit.Case
  doctest ParseDemo

  test "greets the world" do
    assert ParseDemo.hello() == :world
  end
end
