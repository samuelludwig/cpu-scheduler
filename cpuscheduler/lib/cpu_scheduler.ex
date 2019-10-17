defmodule CpuScheduler do
  def calculate_cpu_schedule_data(%SimParameters{
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
    process_times = Fcfs.generate_process_times_list(processes)

    average_wait_time = Fcfs.get_average_wait_time(process_times) |> Float.round(2)
    average_turn_around_time = Fcfs.get_average_turnaround_time(process_times) |> Float.round(2)

    gantt_data = Fcfs.generate_gantt_data_list(processes)

    %SimOutput{
      process_times: process_times,
      gantt_data: gantt_data,
      average_wait_time: average_wait_time,
      average_turn_around_time: average_turn_around_time
    }
  end
end
