defmodule CpuSchedulerTest do
  use ExUnit.Case
  import CpuScheduler

  setup do
    [
      sim_params_fcfs: %SimParameters{
        algorithm: :first_come_first_serve,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
          %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
          %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
          %CpuProcess{p_name: "p4", burst_size: 6, priority: 2}
        ]
      },
      sim_params_fcfs_single_process: %SimParameters{
        algorithm: :first_come_first_serve,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1}
        ]
      },
      sim_output_fcfs: %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
          %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9},
          %ProcessTimeDatum{p_name: "p3", wait_time: 9, turnaround_time: 17},
          %ProcessTimeDatum{p_name: "p4", wait_time: 17, turnaround_time: 23}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p1", start_time: 0, stop_time: 6},
          %GanttDatum{p_name: "p2", start_time: 6, stop_time: 9},
          %GanttDatum{p_name: "p3", start_time: 9, stop_time: 17},
          %GanttDatum{p_name: "p4", start_time: 17, stop_time: 23}
        ],
        average_wait_time: 8.0,
        average_turnaround_time: 13.75
      },
      sim_params_sjf: %SimParameters{
        algorithm: :shortest_job_first,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
          %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
          %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
          %CpuProcess{p_name: "p4", burst_size: 6, priority: 2}
        ]
      },
      sim_params_sjf_single_process: %SimParameters{
        algorithm: :shortest_job_first,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1}
        ]
      },
      sim_output_sjf: %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p2", wait_time: 0, turnaround_time: 3},
          %ProcessTimeDatum{p_name: "p4", wait_time: 3, turnaround_time: 9},
          %ProcessTimeDatum{p_name: "p1", wait_time: 9, turnaround_time: 15},
          %ProcessTimeDatum{p_name: "p3", wait_time: 15, turnaround_time: 23}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p2", start_time: 0, stop_time: 3},
          %GanttDatum{p_name: "p4", start_time: 3, stop_time: 9},
          %GanttDatum{p_name: "p1", start_time: 9, stop_time: 15},
          %GanttDatum{p_name: "p3", start_time: 15, stop_time: 23}
        ],
        average_wait_time: 6.75,
        average_turnaround_time: 12.50
      },
      sim_params_priority: %SimParameters{
        algorithm: :priority,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
          %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
          %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
          %CpuProcess{p_name: "p4", burst_size: 6, priority: 2}
        ]
      },
      sim_params_priority_single_process: %SimParameters{
        algorithm: :priority,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1}
        ]
      },
      sim_output_priority: %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p3", wait_time: 0, turnaround_time: 8},
          %ProcessTimeDatum{p_name: "p4", wait_time: 8, turnaround_time: 14},
          %ProcessTimeDatum{p_name: "p2", wait_time: 14, turnaround_time: 17},
          %ProcessTimeDatum{p_name: "p1", wait_time: 17, turnaround_time: 23}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p3", start_time: 0, stop_time: 8},
          %GanttDatum{p_name: "p4", start_time: 8, stop_time: 14},
          %GanttDatum{p_name: "p2", start_time: 14, stop_time: 17},
          %GanttDatum{p_name: "p1", start_time: 17, stop_time: 23}
        ],
        average_wait_time: 9.75,
        average_turnaround_time: 15.50
      },
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
        quantum: 6
      },
      sim_output_rr: %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
          %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9},
          %ProcessTimeDatum{p_name: "p3", wait_time: 15, turnaround_time: 23},
          %ProcessTimeDatum{p_name: "p4", wait_time: 15, turnaround_time: 21}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p1", start_time: 0, stop_time: 6},
          %GanttDatum{p_name: "p2", start_time: 6, stop_time: 9},
          %GanttDatum{p_name: "p3", start_time: 9, stop_time: 15},
          %GanttDatum{p_name: "p4", start_time: 15, stop_time: 21},
          %GanttDatum{p_name: "p3", start_time: 21, stop_time: 23}
        ],
        average_wait_time: 9,
        average_turnaround_time: 14.75
      },
      single_process_sim_output: %SimOutput{
        process_times: [
          %ProcessTimeDatum{
            p_name: "p1",
            wait_time: 0,
            turnaround_time: 6
          }
        ],
        gantt_data: [
          %GanttDatum{
            p_name: "p1",
            start_time: 0,
            stop_time: 6
          }
        ],
        average_wait_time: 0.0,
        average_turnaround_time: 6.0
      }
    ]
  end

  describe "calculate_cpu_schedule_data/1" do
    test "returns a map with no data when given no processes" do
      map = %SimParameters{algorithm: :first_come_first_serve, processes: []}

      assert calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [],
               gantt_data: [],
               average_wait_time: nil,
               average_turnaround_time: nil
             }

      map = %SimParameters{algorithm: :first_come_first_serve, processes: nil}

      assert calculate_cpu_schedule_data(map) == %SimOutput{
               process_times: [],
               gantt_data: [],
               average_wait_time: nil,
               average_turnaround_time: nil
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

    test "returns the same correct process times list and gantt data when only one process is given",
         context do
      assert calculate_cpu_schedule_data(context[:sim_params_fcfs_single_process]) ==
               context[:single_process_sim_output]

      assert calculate_cpu_schedule_data(context[:sim_params_sjf_single_process]) ==
               context[:single_process_sim_output]

      assert calculate_cpu_schedule_data(context[:sim_params_priority_single_process]) ==
               context[:single_process_sim_output]

      assert calculate_cpu_schedule_data(context[:sim_params_rr_single_process]) ==
               context[:single_process_sim_output]
    end
  end

  describe "caclulate_cpu_shcedule_data/1 with FCFS" do
    test "returns correctly when given a list of processes", context do
      assert calculate_cpu_schedule_data(context[:sim_params_fcfs]) ==
               context[:sim_output_fcfs]
    end
  end

  describe "caclulate_cpu_shcedule_data/1 with SJF" do
    test "returns correctly when given a list of processes", context do
      assert calculate_cpu_schedule_data(context[:sim_params_sjf]) ==
               context[:sim_output_sjf]
    end
  end

  describe "caclulate_cpu_shcedule_data/1 with Priority" do
    test "returns correctly when given a list of processes", context do
      assert calculate_cpu_schedule_data(context[:sim_params_priority]) ==
               context[:sim_output_priority]
    end
  end

  describe "caclulate_cpu_shcedule_data/1 with RR" do
    test "returns correctly when given a list of processes", context do
      assert calculate_cpu_schedule_data(context[:sim_params_rr]) ==
               context[:sim_output_rr]
    end

    test "returns correctly when given a list of process with multiple process burst sizes above quantum" do
      params = %SimParameters{
        algorithm: :round_robin,
        processes: [
          %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
          %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
          %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
          %CpuProcess{p_name: "p4", burst_size: 6, priority: 2},
          %CpuProcess{p_name: "p5", burst_size: 7, priority: 2},
          %CpuProcess{p_name: "p6", burst_size: 6, priority: 2},
          %CpuProcess{p_name: "p7", burst_size: 13, priority: 2}
        ],
        quantum: 6
      }

      output = %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
          %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9},
          %ProcessTimeDatum{p_name: "p3", wait_time: 33, turnaround_time: 41},
          %ProcessTimeDatum{p_name: "p4", wait_time: 15, turnaround_time: 21},
          %ProcessTimeDatum{p_name: "p5", wait_time: 35, turnaround_time: 42},
          %ProcessTimeDatum{p_name: "p6", wait_time: 27, turnaround_time: 33},
          %ProcessTimeDatum{p_name: "p7", wait_time: 36, turnaround_time: 49}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p1", start_time: 0, stop_time: 6},
          %GanttDatum{p_name: "p2", start_time: 6, stop_time: 9},
          %GanttDatum{p_name: "p3", start_time: 9, stop_time: 15},
          %GanttDatum{p_name: "p4", start_time: 15, stop_time: 21},
          %GanttDatum{p_name: "p5", start_time: 21, stop_time: 27},
          %GanttDatum{p_name: "p6", start_time: 27, stop_time: 33},
          %GanttDatum{p_name: "p7", start_time: 33, stop_time: 39},
          %GanttDatum{p_name: "p3", start_time: 39, stop_time: 41},
          %GanttDatum{p_name: "p5", start_time: 41, stop_time: 42},
          %GanttDatum{p_name: "p7", start_time: 42, stop_time: 48},
          %GanttDatum{p_name: "p7", start_time: 48, stop_time: 49}
        ],
        average_wait_time: 21.71,
        average_turnaround_time: 28.71
      }

      assert calculate_cpu_schedule_data(params) == output
    end
  end
end
