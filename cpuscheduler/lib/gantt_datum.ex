defmodule GanttDatum do
  @enforce_keys [:p_name, :start_time, :stop_time]
  defstruct ~w[p_name start_time stop_time]a

  @type t() :: %__MODULE__{
          p_name: any(),
          start_time: integer(),
          stop_time: integer()
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
