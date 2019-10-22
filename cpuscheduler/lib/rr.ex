defmodule Rr do
  # The implementation for the Round Robin algorithm is not as generic as the
  # implementation of the others, as it involves more than simply putting
  # processes in the right order.

  def generate_process_times_list(process_queue, quantum) do
    generate_gantt_data_list(process_queue, quantum)
    |> condense_gantt_data_into_process_time_data()
  end

  # We use a recursive solution for generating the gantt data list as we are
  # operating on two separate datastrucures whose contents are dependant on one
  # another on each iteration. We are working in a queue and each item needs to
  # be evaluated separately. Therefore, iteration is the correct approach.
  # We iterate over the process queue and move and remove things as needed,
  # building the gantt data list with each step, we do this until there are no
  # processes remaining in the queue. When there are no processes remaining in
  # the queue, we return the completed gantt_data_list datastructure.
  def generate_gantt_data_list(gantt_data_list \\ [], process_queue, quantum)

  def generate_gantt_data_list(gantt_data_list, [], _quantum) do
    gantt_data_list
  end

  def generate_gantt_data_list(gantt_data_list, process_queue, quantum) do
    {new_gantt_data_list, new_process_list} =
      calculate_next_gantt_data_list_cycle(gantt_data_list, process_queue, quantum)

    generate_gantt_data_list(new_gantt_data_list, new_process_list, quantum)
  end

  defp calculate_next_gantt_data_list_cycle(gantt_data_list, process_list, quantum) do
    start_time = get_stop_time_of_last_gantt_block(gantt_data_list)
    process = List.first(process_list)

    new_gantt_data_list = gantt_data_list ++ [calculate_gantt_block(process, start_time, quantum)]

    new_process_list = calculate_cycled_list(process_list, process, quantum)

    {new_gantt_data_list, new_process_list}
  end

  defp calculate_gantt_block(%CpuProcess{burst_size: burst_size} = process, start_time, quantum)
       when burst_size < quantum do
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

  defp calculate_cycled_list(process_list, %CpuProcess{burst_size: burst_size} = process, quantum)
       when burst_size > quantum do
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

  defp derive_wait_time_and_turnaround_time_from_map_of_gantt_data(p_name, gantt_list) do
    wait_time = List.first(gantt_list).start_time
    turnaround_time = List.last(gantt_list).stop_time
    %ProcessTimeDatum{p_name: p_name, wait_time: wait_time, turnaround_time: turnaround_time}
  end

  defp condense_gantt_data_into_process_time_data(gantt_data) do
    gantt_data
    |> Enum.group_by(fn %GanttDatum{p_name: p_name} -> p_name end)
    |> Enum.map(fn {p_name, process_gantt_list} ->
      derive_wait_time_and_turnaround_time_from_map_of_gantt_data(p_name, process_gantt_list)
    end)
  end
end
