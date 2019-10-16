defmodule ProcessTimeDatum do
  @enforce_keys [:p_name, :wait_time, :turnaround_time]
  defstruct ~w[p_name wait_time turnaround_time]a

  @type t() :: %__MODULE__{
          p_name: any(),
          wait_time: integer(),
          turnaround_time: integer()
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
