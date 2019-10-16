defmodule GanttDatum do
  @enforce_keys [:p_name, :time_start, :time_stop]
  defstruct ~w[p_name time_start time_stop]a

  @type t() :: %__MODULE__{
          p_name: any(),
          time_start: integer(),
          time_stop: integer()
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
