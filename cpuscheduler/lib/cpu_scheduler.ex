defmodule CpuScheduler do
  import Util

  @moduledoc """
  Public API for CpuScheduler

  Each function in the CpuScheduler module expects a `%SimParameters{}` struct
  in the following form:

  ```Elixir
  %SimParameters{
    algorithm: algorithm_name,
    processes: list_of_processes,
    quantum: quantum_to_be_used
  }
  ```

  Where `algorithm_name` must be one of four options:
  `:first_come_first_serve`, `:shortest_job_first`, `:priority`, or `:round_robin`

  The `quantum` field is only necessary if the Round Robin algorithm is being used.

  Each function will return a `%SimOutput{}` struct in the form of:

  ```Elixir
  %SimOutput{
    process_times: list of process with there wait times and turnaround times,
    gantt_data: ordered blocks of gantt data containing the process name, and start/end time,
    average_wait_time: average wait time of all processes according to algorithm used,
    average_turnaround_time: average turnaround time of all processes according to algorithm used
  }
  ```

  `average_wait_time` and `average_turnaround_time` are returned as floats with a
  default precision of 2.
  """

  @precision 2

  def calculate_cpu_schedule_data(%SimParameters{processes: nil}) do
    %SimOutput{
      process_times: [],
      gantt_data: [],
      average_wait_time: nil,
      average_turnaround_time: nil
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{processes: []}) do
    %SimOutput{
      process_times: [],
      gantt_data: [],
      average_wait_time: nil,
      average_turnaround_time: nil
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :first_come_first_serve,
        processes: processes
      }) do
    process_times = Fcfs.generate_process_times_list(processes)

    gantt_data = Fcfs.generate_gantt_data_list(processes)

    average_wait_time = get_average_wait_time(process_times) |> Float.round(@precision)

    average_turnaround_time =
      get_average_turnaround_time(process_times) |> Float.round(@precision)

    %SimOutput{
      process_times: process_times,
      gantt_data: gantt_data,
      average_wait_time: average_wait_time,
      average_turnaround_time: average_turnaround_time
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :shortest_job_first,
        processes: processes
      }) do
    process_times = Sjf.generate_process_times_list(processes)

    gantt_data = Sjf.generate_gantt_data_list(processes)

    average_wait_time = get_average_wait_time(process_times) |> Float.round(@precision)

    average_turnaround_time =
      get_average_turnaround_time(process_times) |> Float.round(@precision)

    %SimOutput{
      process_times: process_times,
      gantt_data: gantt_data,
      average_wait_time: average_wait_time,
      average_turnaround_time: average_turnaround_time
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :priority,
        processes: processes
      }) do
    process_times = Priority.generate_process_times_list(processes)

    gantt_data = Priority.generate_gantt_data_list(processes)

    average_wait_time = get_average_wait_time(process_times) |> Float.round(@precision)

    average_turnaround_time =
      get_average_turnaround_time(process_times) |> Float.round(@precision)

    %SimOutput{
      process_times: process_times,
      gantt_data: gantt_data,
      average_wait_time: average_wait_time,
      average_turnaround_time: average_turnaround_time
    }
  end

  def calculate_cpu_schedule_data(%SimParameters{
        algorithm: :round_robin,
        processes: processes,
        quantum: quantum
      }) do
    process_times = Rr.generate_process_times_list(processes, quantum)

    gantt_data = Rr.generate_gantt_data_list(processes, quantum)

    average_wait_time = get_average_wait_time(process_times) |> Float.round(@precision)

    average_turnaround_time =
      get_average_turnaround_time(process_times) |> Float.round(@precision)

    %SimOutput{
      process_times: process_times,
      gantt_data: gantt_data,
      average_wait_time: average_wait_time,
      average_turnaround_time: average_turnaround_time
    }
  end
end
