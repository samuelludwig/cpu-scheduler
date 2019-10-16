defmodule SimOutput do
  defstruct ~w[process_times gantt_data average_wait_time average_turn_around_time]a

  @type t() :: %__MODULE__{
          process_times: [%ProcessTimeDatum{}],
          gantt_data: [%GanttDatum{}],
          average_wait_time: number(),
          average_turn_around_time: number()
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
