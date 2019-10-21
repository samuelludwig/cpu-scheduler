defmodule Fcfs do
  @moduledoc """
  First-Come-First-Serve Algorithm:
  Waiting time for Pn = Process time of (Pn-1 + Pn-2 + ... + P1)
  Turnaround time for Pn = Waiting time of Pn + Process time of Pn
  """
  import Util

  def generate_process_times_list(process_queue) do
    Enum.map(process_queue, fn %CpuProcess{p_name: p_name} ->
      build_process_time_datum_struct_from_queue(process_queue, p_name)
    end)
  end

  def generate_gantt_data_list(process_queue) do
    Enum.map(process_queue, fn %CpuProcess{p_name: p_name} ->
      build_gantt_datum_struct_from_queue(process_queue, p_name)
    end)
  end
end
