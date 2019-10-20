defmodule FcfsTest do
  use ExUnit.Case
  import Fcfs

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
