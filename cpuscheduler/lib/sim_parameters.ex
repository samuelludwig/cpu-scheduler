defmodule SimParameters do
  @enforce_keys [:algorithm]
  defstruct ~w[algorithm processes]a

  @type t() :: %__MODULE__{
          algorithm:
            :first_come_first_serve
            | :shortest_job_first
            | :round_robin
            | :priority,
          processes: [CpuProcess.t()] | nil
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
