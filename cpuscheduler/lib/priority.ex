defmodule Priority do
  def generate_process_times_list(process_queue) do
    sorted_queue = order_process_list_by_priority(process_queue)

    Enum.map(sorted_queue, fn %CpuProcess{p_name: p_name} ->
      Util.build_process_time_datum_struct_from_queue(sorted_queue, p_name)
    end)
  end

  def generate_gantt_data_list(process_queue) do
    sorted_queue = order_process_list_by_priority(process_queue)

    Enum.map(sorted_queue, fn %CpuProcess{p_name: p_name} ->
      Util.build_gantt_datum_struct_from_queue(sorted_queue, p_name)
    end)
  end

  defp order_process_list_by_priority(process_queue) do
    Enum.sort(
      process_queue,
      &process_one_priority_is_higher_than_process_two_priority?(&1, &2)
    )
  end

  defp process_one_priority_is_higher_than_process_two_priority?(
         process_one,
         process_two
       ) do
    process_one.priority > process_two.priority
  end
end
