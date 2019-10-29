defmodule SimOutput do
  defstruct ~w[process_times gantt_data average_wait_time average_turnaround_time]a

  @type t() :: %__MODULE__{
          process_times: [%ProcessTimeDatum{}] | nil,
          gantt_data: [%GanttDatum{}] | nil,
          average_wait_time: number(),
          average_turnaround_time: number()
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
