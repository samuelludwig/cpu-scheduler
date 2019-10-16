defmodule CpuProcess do
  @enforce_keys [:p_name, :burst_size]
  defstruct ~w[p_name burst_size priority]a

  @type t() :: %__MODULE__{
          p_name: any(),
          burst_size: integer(),
          priority: integer() | nil
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
