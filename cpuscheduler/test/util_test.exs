defmodule UtilTest do
  use ExUnit.Case
  import Util

  setup do
    [
      single_process: %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
      process_list: [
        %CpuProcess{p_name: "p1", burst_size: 6, priority: 1},
        %CpuProcess{p_name: "p2", burst_size: 3, priority: 2},
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
        %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
        %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9},
        %ProcessTimeDatum{p_name: "p3", wait_time: 9, turnaround_time: 17}
      ]
    ]
  end

  describe "get_average_wait_time/1" do
    test "returns the sum of all wait times divided by the amount of processes", context do
      assert get_average_wait_time(context[:process_times_list]) ==
               (0 + 6 + 9) / 3
    end

    test "returns 0 when only one process is given in the list", context do
      assert get_average_wait_time(context[:single_entry_process_times_list]) == 0
    end
  end

  describe "get_average_turnaround_time/1" do
    test "returns the sum of all turnaround times divided by the amount of processes", context do
      assert get_average_turnaround_time(context[:process_times_list]) ==
               (6 + 9 + 17) / 3
    end

    test "returns burst size of process when only one process is given in the list", context do
      assert get_average_turnaround_time(context[:single_entry_process_times_list]) == 6
    end
  end

  describe "process_exists_in_queue?/2" do
    test "returns true when process `name` is in process_list", context do
      assert process_exists_in_queue?(context[:process_list], "p1") == true
    end

    test "returns false when process `name` is not in process_list", context do
      assert process_exists_in_queue?(context[:process_list], "failure") == false
    end

    test "returns false when process_list is empty" do
      assert process_exists_in_queue?([], "failure") == false
    end
  end

  describe "get_index_of_process_in_queue/2" do
    test "returns `n` when searching for the nth process in the queue", context do
      assert get_index_of_process_in_queue(context[:process_list], "p2") == 1
    end

    test "returns `nil` when the process is not in the queue or the queue is empty", context do
      assert get_index_of_process_in_queue(context[:process_list], "failure") == nil
      assert get_index_of_process_in_queue([], "failure") == nil
    end
  end

  describe "get_process_from_queue/2" do
    test "returns `process` when searching the process's name in the queue", context do
      assert get_process_from_queue(context[:process_list], "p2") ==
               %CpuProcess{p_name: "p2", burst_size: 3, priority: 2}
    end

    test "returns `nil` when the process is not in the queue or the queue is empty", context do
      assert get_process_from_queue(context[:process_list], "failure") == nil
      assert get_process_from_queue([], "failure") == nil
    end
  end

  describe "get_burst_size_of_process_in_queue/2" do
    test "returns `burst_size` when searching the process's name in the queue", context do
      assert get_burst_size_of_process_in_queue(context[:process_list], "p2") == 3
    end

    test "returns `nil` when the process is not in the queue or the queue is empty", context do
      assert get_burst_size_of_process_in_queue(context[:process_list], "failure") == nil
      assert get_burst_size_of_process_in_queue([], "failure") == nil
    end
  end

  describe "get_sum_of_all_wait_times/1" do
  end

  describe "get_sum_of_all_turnaround_times/1" do
  end

  describe "p_name_matches_name_of_wanted_process?" do
    test "returns true when p_name of the given process matches the given name", context do
      assert p_name_matches_name_of_wanted_process?(context[:single_process], "p1") == true
    end

    test "returns false when p_name of the given process doesn't match the given name", context do
      assert p_name_matches_name_of_wanted_process?(context[:single_process], "failure") == false
    end

    test "raises exception when the given process is `nil`" do
      catch_error(p_name_matches_name_of_wanted_process?(nil, "failure"))
    end
  end

  describe "get_wait_time_of_process/2" do
    test "returns nil when the queue is empty or the process does not exist inside of the queue" do
      assert get_wait_time_of_process_in_queue([], "failure") == nil

      assert get_wait_time_of_process_in_queue(
               [
                 %CpuProcess{p_name: "p1", burst_size: 6},
                 %CpuProcess{p_name: "p2", burst_size: 8},
                 %CpuProcess{p_name: "p3", burst_size: 3}
               ],
               "failure"
             ) == nil
    end

    test "returns 0 when only one process is given in the queue or the process given is the first one in the queue" do
      assert get_wait_time_of_process_in_queue([%CpuProcess{p_name: "p1", burst_size: 8}], "p1") ==
               0

      assert get_wait_time_of_process_in_queue(
               [
                 %CpuProcess{p_name: "p1", burst_size: 8},
                 %CpuProcess{p_name: "p2", burst_size: 5}
               ],
               "p1"
             ) == 0
    end

    test "returns the sum of the burst times of all processes in the queue preceeding the given process" do
      assert get_wait_time_of_process_in_queue(
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
      assert get_turnaround_time_of_process_in_queue([], "failure") == nil

      assert get_turnaround_time_of_process_in_queue(
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
      assert get_turnaround_time_of_process_in_queue(
               [
                 %CpuProcess{p_name: "p1", burst_size: 8}
               ],
               "p1"
             ) == 8

      assert get_turnaround_time_of_process_in_queue(
               [
                 %CpuProcess{p_name: "p1", burst_size: 8},
                 %CpuProcess{p_name: "p2", burst_size: 5}
               ],
               "p1"
             ) == 8
    end

    test "returns the sum of the burst times of all processes in the queue preceeding the given process plus the burst time of the given process" do
      assert get_turnaround_time_of_process_in_queue(
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
