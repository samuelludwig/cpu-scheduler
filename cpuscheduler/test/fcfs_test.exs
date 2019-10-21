defmodule FcfsTest do
  use ExUnit.Case
  import Fcfs

  setup do
    [
      single_process: %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
      process_list: [
        %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
        %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
        %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
        %CpuProcess{p_name: "p4", burst_size: 6, priority: 2}
      ],
      single_entry_process_times_list: [
        %ProcessTimeDatum{
          p_name: "p1",
          wait_time: 0,
          turnaround_time: 6
        }
      ],
      process_times_list: [
        %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
        %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9},
        %ProcessTimeDatum{p_name: "p3", wait_time: 9, turnaround_time: 17},
        %ProcessTimeDatum{p_name: "p4", wait_time: 17, turnaround_time: 23}
      ],
      single_entry_gantt_data_list: [
        %GanttDatum{
          p_name: "p1",
          start_time: 0,
          stop_time: 6
        }
      ],
      gantt_data_list: [
        %GanttDatum{p_name: "p1", start_time: 0, stop_time: 6},
        %GanttDatum{p_name: "p2", start_time: 6, stop_time: 9},
        %GanttDatum{p_name: "p3", start_time: 9, stop_time: 17},
        %GanttDatum{p_name: "p4", start_time: 17, stop_time: 23}
      ]
    ]
  end

  describe "generate_process_times_list/1" do
    test "returns correct process_times_list when given a list of processes", context do
      assert generate_process_times_list(context[:process_list]) ==
               context[:process_times_list]
    end

    test "returns list with single process time when only one process is given", context do
      assert generate_process_times_list([context[:single_process]]) ==
               context[:single_entry_process_times_list]
    end
  end

  describe "generate_gantt_data_list/1" do
    test "returns list with single gantt datum when only one process is given", context do
      assert generate_gantt_data_list([context[:single_process]]) ==
               context[:single_entry_gantt_data_list]
    end

    test "return correct gantt_data list when a list or process are given", context do
      assert generate_gantt_data_list(context[:process_list]) ==
               context[:gantt_data_list]
    end
  end
end
