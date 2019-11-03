defmodule CpuschedulerHttpServerTest do
  use ExUnit.Case
  doctest CpuschedulerHttpServer

  test "greets the world" do
    assert CpuschedulerHttpServer.hello() == :world
  end
end
