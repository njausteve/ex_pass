defmodule ExPassTest do
  use ExUnit.Case
  doctest ExPass

  test "greets the world" do
    assert ExPass.hello() == :world
  end
end
