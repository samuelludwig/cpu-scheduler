defmodule Fcfs do
  @moduledoc """
  First-Come-First-Serve Algorithm:
  Waiting time for Pn = Process time of (Pn-1 + Pn-2 + ... + P1)
  Turnaround time for Pn = Waiting time of Pn + Process time of Pn
  """
  import Util

  def generate_process_times_list(process_queue) do
    Enum.map(process_queue, fn %CpuProcess{p_name: p_name} ->
      build_process_time_datum_struct(process_queue, p_name)
    end)
  end

  def generate_gantt_data_list(process_queue) do
    Enum.map(process_queue, fn %CpuProcess{p_name: p_name} ->
      build_gantt_datum_struct(process_queue, p_name)
    end)
  end

  def get_wait_time_of_process_in_queue(process_queue, process_name) do
    if process_exists_in_queue?(process_queue, process_name) do
      position = get_index_of_process_in_queue(process_queue, process_name)
      add_process_burst_sizes_up_to_queue_position(process_queue, position)
    end
  end

  def get_turnaround_time_of_process_in_queue(process_queue, process_name) do
    if process_exists_in_queue?(process_queue, process_name) do
      add_burst_size_and_wait_time_of_process_in_queue(process_queue, process_name)
    end
  end

  defp add_burst_size_and_wait_time_of_process_in_queue(process_queue, process_name) do
    get_burst_size_of_process_in_queue(process_queue, process_name) +
      get_wait_time_of_process_in_queue(process_queue, process_name)
  end

  defp add_process_burst_sizes_up_to_queue_position(process_queue, position) do
    Enum.take(process_queue, position)
    |> Enum.reduce(0, fn %CpuProcess{burst_size: burst_size}, acc -> acc + burst_size end)
  end

  defp build_process_time_datum_struct(process_queue, p_name) do
    %ProcessTimeDatum{
      p_name: p_name,
      wait_time: get_wait_time_of_process_in_queue(process_queue, p_name),
      turnaround_time: get_turnaround_time_of_process_in_queue(process_queue, p_name)
    }
  end

  defp build_gantt_datum_struct(process_queue, p_name) do
    %GanttDatum{
      p_name: p_name,
      time_start: get_wait_time_of_process_in_queue(process_queue, p_name),
      time_stop: get_turnaround_time_of_process_in_queue(process_queue, p_name)
    }
  end
end
