defmodule Sjf do
  import Util

  def generate_process_times_list(process_queue) do
    sorted_queue = order_process_list_by_burst_size(process_queue)

    Enum.map(sorted_queue, fn %CpuProcess{p_name: p_name} ->
      build_process_time_datum_struct_from_queue(sorted_queue, p_name)
    end)
  end

  def generate_gantt_data_list(process_queue) do
    sorted_queue = order_process_list_by_burst_size(process_queue)

    Enum.map(sorted_queue, fn %CpuProcess{p_name: p_name} ->
      build_gantt_datum_struct_from_queue(sorted_queue, p_name)
    end)
  end

  def order_process_list_by_burst_size(process_queue) do
    Enum.sort(
      process_queue,
      &process_one_burst_size_is_less_than_process_two_burst_size?(&1, &2)
    )
  end

  defp process_one_burst_size_is_less_than_process_two_burst_size?(
         process_one,
         process_two
       ) do
    process_one.burst_size < process_two.burst_size
  end
end
