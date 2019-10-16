defmodule Fcfs do
  @moduledoc """
  First-Come-First-Serve Algorithm:
  Waiting time for Pn = Process time of (Pn-1 + Pn-2 + ... + P1)
  Turnaround time for Pn = Waiting time of Pn + Process time of Pn

  The data will be returned in a map in the form of:

  %{process_times: [%{p_name: p1, wait_time: n, turnaround_time: m},
  ...,
  %{p_name: pn, wait_time: y, turnaround_time: z}],
  gantt_data: [%{p_name: p1, time_start: n, time_stop: m},
  ...,
  %{p_name: pn, time_start: x, time_stop: y}]
  }
  """

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :first_come_first_serve,
        processes: []
      }) do
    %SimOutput{
      process_times: [],
      gantt_data: [],
      average_wait_time: nil,
      average_turn_around_time: nil
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :first_come_first_serve,
        processes: nil
      }) do
    %SimOutput{
      process_times: [],
      gantt_data: [],
      average_wait_time: nil,
      average_turn_around_time: nil
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :first_come_first_serve,
        processes: processes
      }) do
    process_times = generate_process_times_list(processes)

    average_wait_time = get_average_wait_time(process_times) |> Float.round(2)
    average_turn_around_time = get_average_turnaround_time(process_times) |> Float.round(2)

    gantt_data = generate_gantt_data_list(processes)

    %SimOutput{
      process_times: process_times,
      gantt_data: gantt_data,
      average_wait_time: average_wait_time,
      average_turn_around_time: average_turn_around_time
    }
  end

  def get_wait_time_of_process(process_queue, name_of_wanted_process) do
    position = get_index_of_process_in_queue(process_queue, name_of_wanted_process)

    case position do
      nil ->
        nil

      _ ->
        Enum.take(process_queue, position)
        |> Enum.reduce(0, fn %CpuProcess{burst_size: burst_size}, acc -> acc + burst_size end)
    end
  end

  def get_turnaround_time_of_process(process_queue, name_of_wanted_process) do
    position = get_index_of_process_in_queue(process_queue, name_of_wanted_process)

    case position do
      nil ->
        nil

      _ ->
        %CpuProcess{burst_size: burst_size} = Enum.at(process_queue, position)
        burst_size + get_wait_time_of_process(process_queue, name_of_wanted_process)
    end
  end

  defp get_average_wait_time(process_times) do
    Enum.reduce(process_times, 0, fn %ProcessTimeDatum{
                                       p_name: _p_name,
                                       wait_time: wait_time,
                                       turnaround_time: _turnaround_time
                                     },
                                     acc ->
      acc + wait_time
    end)
    |> Kernel./(Enum.count(process_times))
  end

  defp get_average_turnaround_time(process_times) do
    Enum.reduce(process_times, 0, fn %ProcessTimeDatum{
                                       p_name: _p_name,
                                       wait_time: _wait_time,
                                       turnaround_time: turnaround_time
                                     },
                                     acc ->
      acc + turnaround_time
    end)
    |> Kernel./(Enum.count(process_times))
  end

  defp generate_process_times_list(process_queue) do
    Enum.reduce(process_queue, [], fn %CpuProcess{p_name: p_name}, acc ->
      [
        %ProcessTimeDatum{
          p_name: p_name,
          wait_time: get_wait_time_of_process(process_queue, p_name),
          turnaround_time: get_turnaround_time_of_process(process_queue, p_name)
        }
      ] ++ acc
    end)
    |> Enum.reverse()
  end

  defp generate_gantt_data_list(process_queue) do
    Enum.reduce(process_queue, [], fn %CpuProcess{p_name: p_name}, acc ->
      [
        %GanttDatum{
          p_name: p_name,
          time_start: get_wait_time_of_process(process_queue, p_name),
          time_stop: get_turnaround_time_of_process(process_queue, p_name)
        }
      ] ++ acc
    end)
    |> Enum.reverse()
  end

  defp get_index_of_process_in_queue(process_queue, name_of_wanted_process) do
    Enum.find_index(process_queue, fn %CpuProcess{p_name: p_name} ->
      p_name == name_of_wanted_process
    end)
  end
end
