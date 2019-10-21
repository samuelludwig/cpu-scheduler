defmodule CpuScheduler do
  import Util

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
