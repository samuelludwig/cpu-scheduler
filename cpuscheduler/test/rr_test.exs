defmodule RrTest do
  use ExUnit.Case
  import Rr

  setup do
    [
      sim_params_rr: %SimParameters{
        algorithm: :round_robin,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
          %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
          %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
          %CpuProcess{p_name: "p4", burst_size: 6, priority: 2}
        ],
        quantum: 6
      },
      sim_params_rr_single_process: %SimParameters{
        algorithm: :round_robin,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1}
        ],
        quantum: 5
      },
      sim_output_rr: %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
          %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9},
          %ProcessTimeDatum{p_name: "p3", wait_time: 9, turnaround_time: 23},
          %ProcessTimeDatum{p_name: "p4", wait_time: 15, turnaround_time: 21}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p1", start_time: 0, stop_time: 6},
          %GanttDatum{p_name: "p2", start_time: 6, stop_time: 9},
          %GanttDatum{p_name: "p3", start_time: 9, stop_time: 15},
          %GanttDatum{p_name: "p4", start_time: 15, stop_time: 21},
          %GanttDatum{p_name: "p3", start_time: 21, stop_time: 23}
        ],
        average_wait_time: 7.5,
        average_turnaround_time: 14.75
      }
    ]
  end

  describe "generate_gantt_data_list/3" do
    test "returns a single process's gantt data when given a single process", context do
      assert generate_gantt_data_list(
               context[:sim_params_rr_single_process].processes,
               context[:sim_params_rr_single_process].quantum
             ) == [
               %GanttDatum{p_name: "p1", start_time: 0, stop_time: 5},
               %GanttDatum{p_name: "p1", start_time: 5, stop_time: 6}
             ]
    end

    test "returns correct gantt data list when multiple processes are given", context do
      assert generate_gantt_data_list(
               context[:sim_params_rr].processes,
               context[:sim_params_rr].quantum
             ) == context[:sim_output_rr].gantt_data
    end
  end

  describe "generate_process_times_list/2" do
    test "returns correctly given one process", context do
      assert generate_process_times_list(
               context[:sim_params_rr_single_process].processes,
               context[:sim_params_rr_single_process].quantum
             ) == [
               %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6}
             ]
    end
  end
end
