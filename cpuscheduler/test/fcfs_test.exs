defmodule FcfsTest do
  use ExUnit.Case

  describe "Fcfs.calculate_cpu_schedule_data/1" do
    test "fails pattern match for wrong algorithm" do
      catch_error(CpuScheduler.calculate_cpu_schedule(%SimParameters{algorithm: :bad_alg, processes: []}))
    end

    test "returns a map with no data when given no processes" do
      map = %SimParameters{algorithm: :first_come_first_serve, processes: []}

      assert CpuScheduler.calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [],
               gantt_data: [],
               average_wait_time: nil,
               average_turn_around_time: nil
             }

      map = %SimParameters{algorithm: :first_come_first_serve, processes: nil}

      assert CpuScheduler.calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [],
               gantt_data: [],
               average_wait_time: nil,
               average_turn_around_time: nil
             }
    end

    test "returns process time `0, burst_size` when given one process" do
      map = %SimParameters{
        algorithm: :first_come_first_serve,
        processes: [%CpuProcess{p_name: "p1", burst_size: 6}]
      }

      assert CpuScheduler.calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [%ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6}],
               gantt_data: [%GanttDatum{p_name: "p1", time_start: 0, time_stop: 6}],
               average_wait_time: 0,
               average_turn_around_time: 6
             }
    end

    test "returns correctly given multiple processes" do
      map = %SimParameters{
        algorithm: :first_come_first_serve,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6},
          %CpuProcess{p_name: "p2", burst_size: 8},
          %CpuProcess{p_name: "p3", burst_size: 3}
        ]
      }

      assert CpuScheduler.calculate_cpu_schedule_data(map) ==
               %SimOutput{
                 process_times: [
                   %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
                   %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 14},
                   %ProcessTimeDatum{p_name: "p3", wait_time: 14, turnaround_time: 17}
                 ],
                 gantt_data: [
                   %GanttDatum{p_name: "p1", time_start: 0, time_stop: 6},
                   %GanttDatum{p_name: "p2", time_start: 6, time_stop: 14},
                   %GanttDatum{p_name: "p3", time_start: 14, time_stop: 17}
                 ],
                 average_wait_time: 6.67,
                 average_turn_around_time: 12.33
               }
    end
  end

  describe "Fcfs.get_wait_time_of_process/2" do
    test "returns nil when the queue is empty or the process does not exist inside of the queue" do
      assert Fcfs.get_wait_time_of_process([], "failure") == nil

      assert Fcfs.get_wait_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 6},
                 %CpuProcess{p_name: "p2", burst_size: 8},
                 %CpuProcess{p_name: "p3", burst_size: 3}
               ],
               "failure"
             ) == nil
    end

    test "returns 0 when only one process is given in the queue or the process given is the first one in the queue" do
      assert Fcfs.get_wait_time_of_process([%CpuProcess{p_name: "p1", burst_size: 8}], "p1") == 0

      assert Fcfs.get_wait_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 8},
                 %CpuProcess{p_name: "p2", burst_size: 5}
               ],
               "p1"
             ) == 0
    end

    test "returns the sum of the burst times of all processes in the queue preceeding the given process" do
      assert Fcfs.get_wait_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 6},
                 %CpuProcess{p_name: "p2", burst_size: 8},
                 %CpuProcess{p_name: "p3", burst_size: 3}
               ],
               "p3"
             ) == 14
    end
  end

  describe "Fcfs.get_turnaround_time_of_process/2" do
    test "returns nil when the queue is empty or the process does not exist inside of the queue" do
      assert Fcfs.get_turnaround_time_of_process([], "failure") == nil

      assert Fcfs.get_turnaround_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 6},
                 %CpuProcess{p_name: "p2", burst_size: 8},
                 %CpuProcess{p_name: "p3", burst_size: 3}
               ],
               "failure"
             ) ==
               nil
    end

    test "returns burst size of process when only one process is given in the queue or the process given is the first one in the queue" do
      assert Fcfs.get_turnaround_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 8}
               ],
               "p1"
             ) == 8

      assert Fcfs.get_turnaround_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 8},
                 %CpuProcess{p_name: "p2", burst_size: 5}
               ],
               "p1"
             ) == 8
    end

    test "returns the sum of the burst times of all processes in the queue preceeding the given process plus the burst time of the given process" do
      assert Fcfs.get_turnaround_time_of_process(
               [
                 %CpuProcess{p_name: "p1", burst_size: 6},
                 %CpuProcess{p_name: "p2", burst_size: 8},
                 %CpuProcess{p_name: "p3", burst_size: 3}
               ],
               "p3"
             ) == 17
    end
  end
end
