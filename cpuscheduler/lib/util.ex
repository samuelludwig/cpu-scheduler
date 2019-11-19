defmodule Util do
  def build_process_time_datum_struct_from_queue(process_queue, p_name) do
    %ProcessTimeDatum{
      p_name: p_name,
      wait_time: get_wait_time_of_process_in_queue(process_queue, p_name),
      turnaround_time: get_turnaround_time_of_process_in_queue(process_queue, p_name)
    }
  end

  def build_gantt_datum_struct_from_queue(process_queue, p_name) do
    %GanttDatum{
      p_name: p_name,
      start_time: get_wait_time_of_process_in_queue(process_queue, p_name),
      stop_time: get_turnaround_time_of_process_in_queue(process_queue, p_name)
    }
  end

  def get_average_wait_time(process_times) do
    get_sum_of_all_wait_times(process_times) / Enum.count(process_times)
  end

  def get_average_turnaround_time(process_times) do
    get_sum_of_all_turnaround_times(process_times) / Enum.count(process_times)
  end

  def process_exists_in_queue?(process_queue, name_of_wanted_process) do
    Enum.any?(
      process_queue,
      &p_name_matches_name_of_wanted_process?(&1, name_of_wanted_process)
    )
  end

  def get_index_of_process_in_queue(process_queue, name_of_wanted_process) do
    Enum.find_index(
      process_queue,
      &p_name_matches_name_of_wanted_process?(&1, name_of_wanted_process)
    )
  end

  def get_process_from_queue(process_queue, name_of_wanted_process) do
    Enum.find(
      process_queue,
      &p_name_matches_name_of_wanted_process?(&1, name_of_wanted_process)
    )
  end

  def get_burst_size_of_process_in_queue(process_queue, process_name) do
    process = get_process_from_queue(process_queue, process_name)

    unless is_nil(process) do
      %CpuProcess{burst_size: burst_size} = process
      burst_size
    end
  end

  def get_sum_of_all_wait_times(process_times) do
    Enum.reduce(process_times, 0, fn %ProcessTimeDatum{wait_time: wait_time}, acc ->
      acc + wait_time
    end)
  end

  def get_sum_of_all_turnaround_times(process_times) do
    Enum.reduce(process_times, 0, fn %ProcessTimeDatum{turnaround_time: turnaround_time}, acc ->
      acc + turnaround_time
    end)
  end

  def p_name_matches_name_of_wanted_process?(
        %CpuProcess{p_name: p_name} = _process,
        name_of_wanted_process
      ) do
    p_name == name_of_wanted_process
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

  def add_burst_size_and_wait_time_of_process_in_queue(process_queue, process_name) do
    get_burst_size_of_process_in_queue(process_queue, process_name) +
      get_wait_time_of_process_in_queue(process_queue, process_name)
  end

  def add_process_burst_sizes_up_to_queue_position(process_queue, position) do
    Enum.take(process_queue, position)
    |> Enum.reduce(0, fn %CpuProcess{burst_size: burst_size}, acc -> acc + burst_size end)
  end
end
