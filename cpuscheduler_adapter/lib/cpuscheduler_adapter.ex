defmodule CpuschedulerAdapter do
  @moduledoc """
  The CpuschedulerAdapter module is responsible for acting as an interface
  between the base Cpuscheduler API and whatever is making calls to it. Input
  will be expected to come in as a JSON object, anything else will fail.

  The input will be taken as JSON, decoded into a `%SimParameters{}` struct, and
  passed to the Cpuscheduler API. The Cpuscheduler API will return a
  `%SimOutput{}` struct which will then be encoded back into a JSON object and
  returned by this module.
  """
end
