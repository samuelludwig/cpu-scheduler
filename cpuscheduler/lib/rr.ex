defmodule Rr do
  import Util

  # This module will have it's own version of the build_process_time_datum_struct_from_queue and build_gantt_datum_struct_from_queue functions as the algorithm is not as simple as simply sorting the processes in a certain way.

  def generate_process_times_list(process_queue, quantum) do
  end

  def generate_gantt_data_list(gantt_data_list \\ [], process_queue, quantum)

  def generate_gantt_data_list(gantt_data_list, [], quantum) do
    gantt_data_list
  end

  def generate_gantt_data_list(gantt_data_list, process_queue, quantum) do
    start = get_stop_time_of_last_gantt_block(gantt_data_list)
    [process] = Enum.take(process_queue, 1)
    {new_gantt_data_list, new_process_list} =
      calculate_next_gantt_data_list_cycle(
        gantt_data_list,
        process_queue,
        process,
        start,
        quantum
      )
    generate_gantt_data_list(new_gantt_data_list, new_process_list, quantum)
  end

  defp calculate_gantt_block(%CpuProcess{burst_size: burst_size} = process, start_time, quantum) when burst_size < quantum do
    %GanttDatum{
      p_name: process.p_name,
      start_time: start_time,
      stop_time: start_time + process.burst_size
    }
  end

  defp calculate_gantt_block(process, start_time, quantum) do
    %GanttDatum{
      p_name: process.p_name,
      start_time: start_time,
      stop_time: start_time + quantum
    }
  end

  defp calculate_next_gantt_data_list_cycle(
    gantt_data_list,
    process_list,
    process,
    start_time,
    quantum) do
    new_gantt_data_list = gantt_data_list ++ [calculate_gantt_block(process, start_time, quantum)]
    new_process_list = calculate_cycled_list(process_list, process, quantum)
    {new_gantt_data_list, new_process_list}
  end

  defp calculate_cycled_list(process_list, %CpuProcess{burst_size: burst_size} = process, quantum) when burst_size > quantum do
    Enum.drop(process_list, 1) ++ [%{process | burst_size: process.burst_size - quantum}]
  end

  defp calculate_cycled_list(process_list, _process, _quantum) do
    Enum.drop(process_list, 1)
  end

  defp get_stop_time_of_last_gantt_block([]), do: 0
  defp get_stop_time_of_last_gantt_block(gantt_data_list) do
    last_block = List.last(gantt_data_list)
    last_block.stop_time
  end
end
