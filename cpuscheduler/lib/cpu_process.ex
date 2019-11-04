defmodule CpuProcess do
  @enforce_keys [:p_name, :burst_size]
  defstruct ~w[p_name burst_size priority]a

  @type t() :: %__MODULE__{
          p_name: String.t(),
          burst_size: pos_integer(),
          priority: 0..127 | nil
        }

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
