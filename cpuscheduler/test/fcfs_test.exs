defmodule FcfsTest do
  use ExUnit.Case

  describe "Fcfs.calculate/1" do
    test "will fail pattern match for wrong algorithm" do
      catch_error(Fcfs.calculate(%{algorithm: :bad_alg, process_burst_sizes: []}))
    end

    test "will return a map with no data when given no processes" do
      map = %{algorithm: :first_come_first_serve, process_burst_sizes: []}
      assert Fcfs.calculate(map) == %{process_times: [], gantt_data: []}
    end

    test "will return process time `0, burst_size` when given one process" do
      map = %{algorithm: :first_come_first_serve, process_burst_sizes: [{"p1", 6}]}

      assert Fcfs.calculate(map) == %{
               process_times: [%{p_name: "p1", wait_time: 0, turnaround_time: 6}],
               gantt_data: [%{p_name: "p1", time_start: 0, time_stop: 6}]
             }
    end

    test "will return correctly given multiple processes" do
      map = %{
        algorithm: :first_come_first_serve,
        process_burst_sizes: [{"p1", 6}, {"p2", 8}, {"p3", 3}]
      }

      assert Fcfs.calculate(map) ==
               %{
                 process_times: [
                   %{p_name: "p1", wait_time: 0, turnaround_time: 6},
                   %{p_name: "p2", wait_time: 6, turnaround_time: 14},
                   %{p_name: "p3", wait_time: 14, turnaround_time: 17}
                 ],
                 gantt_data: [
                   %{p_name: "p1", time_start: 0, time_stop: 6},
                   %{p_name: "p2", time_start: 6, time_stop: 14},
                   %{p_name: "p3", time_start: 14, time_stop: 17}
                 ]
               }
    end
  end
end
