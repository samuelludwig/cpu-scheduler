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

  def calculate(%{algorithm: :first_come_first_serve, process_burst_sizes: []} = _map) do
    %{process_times: [], gantt_data: []}
  end

  def calculate(%{algorithm: :first_come_first_serve, process_burst_sizes: processes} = _map) do
    process_times =
      Enum.reduce(processes, [], fn {p_name, burst_size}, acc ->
        [%{p_name: p_name, wait_time: 0, turnaround_time: burst_size}] ++ acc
      end)

    gantt_data =
      Enum.reduce(processes, [], fn {p_name, burst_size}, acc ->
        [%{p_name: p_name, time_start: 0, time_stop: burst_size}] ++ acc
      end)

    %{process_times: process_times, gantt_data: gantt_data}
  end
end
