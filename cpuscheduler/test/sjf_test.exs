defmodule SjfTest do
  use ExUnit.Case
  import Sjf

  setup do
    [
      single_process: %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
      process_list: [
        %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
        %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
        %CpuProcess{p_name: "p3", burst_size: 8, priority: 3},
        %CpuProcess{p_name: "p4", burst_size: 6, priority: 2}
      ],
      sorted_process_list: [
        %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
        %CpuProcess{p_name: "p4", burst_size: 6, priority: 2},
        %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
        %CpuProcess{p_name: "p3", burst_size: 8, priority: 3}
      ],
      single_entry_process_times_list: [
        %ProcessTimeDatum{
          p_name: "p1",
          wait_time: 0,
          turnaround_time: 6
        }
      ],
      process_times_list: [
        %ProcessTimeDatum{p_name: "p2", wait_time: 0, turnaround_time: 3},
        %ProcessTimeDatum{p_name: "p4", wait_time: 3, turnaround_time: 9},
        %ProcessTimeDatum{p_name: "p1", wait_time: 9, turnaround_time: 15},
        %ProcessTimeDatum{p_name: "p3", wait_time: 15, turnaround_time: 23}
      ],
      single_entry_gantt_data_list: [
        %GanttDatum{
          p_name: "p1",
          start_time: 0,
          stop_time: 6
        }
      ],
      gantt_data_list: [
        %GanttDatum{p_name: "p2", start_time: 0, stop_time: 3},
        %GanttDatum{p_name: "p4", start_time: 3, stop_time: 9},
        %GanttDatum{p_name: "p1", start_time: 9, stop_time: 15},
        %GanttDatum{p_name: "p3", start_time: 15, stop_time: 23}
      ]
    ]
  end

  describe "generate_process_times_list/1" do
    test "return single datum when only one process is given", context do
      assert generate_process_times_list([context[:single_process]]) ==
               context[:single_entry_process_times_list]
    end

    test "return correct list of process times when given a list of unsorted processes",
         context do
      assert generate_process_times_list(context[:process_list]) ==
               context[:process_times_list]
    end
  end

  describe "generate_gantt_data_list/1" do
    test "return single datum when only one process is given", context do
      assert generate_gantt_data_list([context[:single_process]]) ==
               context[:single_entry_gantt_data_list]
    end

    test "return correct gantt data  when given a list of unsorted processes", context do
      assert generate_gantt_data_list(context[:process_list]) ==
               context[:gantt_data_list]
    end
  end
end
