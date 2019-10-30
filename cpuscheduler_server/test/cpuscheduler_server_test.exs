defmodule CpuschedulerServerTest do
  use ExUnit.Case
  doctest CpuschedulerServer

  test "greets the world" do
    assert CpuschedulerServer.hello() == :world
  end
end
