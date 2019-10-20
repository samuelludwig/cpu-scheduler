defmodule CpuSchedulerTest do
  use ExUnit.Case
  import CpuScheduler

  describe "calculate_cpu_schedule_data/1" do
    test "returns a map with no data when given no processes" do
      map = %SimParameters{algorithm: :first_come_first_serve, processes: []}

      assert calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [],
               gantt_data: [],
               average_wait_time: nil,
               average_turn_around_time: nil
             }

      map = %SimParameters{algorithm: :first_come_first_serve, processes: nil}

      assert calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [],
               gantt_data: [],
               average_wait_time: nil,
               average_turn_around_time: nil
             }
    end

    test "fails pattern match for invalid algorithm with processes" do
      catch_error(
        calculate_cpu_schedule_data(%SimParameters{
          algorithm: :bad_alg,
          processes: [
            %CpuProcess{p_name: "p1", burst_size: 6},
            %CpuProcess{p_name: "p2", burst_size: 8}
          ]
        })
      )
    end

    test "returns process time `0, burst_size` when given one process" do
      map = %SimParameters{
        algorithm: :first_come_first_serve,
        processes: [%CpuProcess{p_name: "p1", burst_size: 6}]
      }

      assert calculate_cpu_schedule_data(map) == %SimOutput{
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

      assert calculate_cpu_schedule_data(map) ==
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
end
