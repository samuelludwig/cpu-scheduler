defmodule CpuschedulerAdapterTest do
  use ExUnit.Case
  import CpuschedulerAdapter

  setup do
    [
      basic_json_object_input: "{\"algorithm\":\"priority\",\"processes\":null,\"quantum\":null}",
      basic_json_object_output:
      "{\"average_turnaround_time\":null,\"average_wait_time\":null,\"gantt_data\":[],\"process_times\":[]}",
      complex_json_object_input: "{\"algorithm\":\"round_robin\",\"processes\":[{\"burst_size\":6,\"p_name\":\"p1\",\"priority\":2},{\"burst_size\":13,\"p_name\":\"p2\",\"priority\":1}],\"quantum\":6}",
      complex_json_object_output:
      "{\"average_turnaround_time\":12.5,\"average_wait_time\":3.0,\"gantt_data\":[{\"p_name\":\"p1\",\"start_time\":0,\"stop_time\":6},{\"p_name\":\"p2\",\"start_time\":6,\"stop_time\":12},{\"p_name\":\"p2\",\"start_time\":12,\"stop_time\":18},{\"p_name\":\"p2\",\"start_time\":18,\"stop_time\":19}],\"process_times\":[{\"p_name\":\"p1\",\"turnaround_time\":6,\"wait_time\":0},{\"p_name\":\"p2\",\"turnaround_time\":19,\"wait_time\":6}]}"
    ]
  end

  describe "calculate_cpu_schedule_data_from_json_object/1" do
    test "fails on invalid JSON" do
      assert catch_error(calculate_cpu_schedule_data_from_json_object("FAIL"))
    end

    test "sending a basic json object returns the correct `%SimOutput{}` struct", context do
      assert calculate_cpu_schedule_data_from_json_object(context[:basic_json_object_input]) ==
        context[:basic_json_object_output]
    end

    test "sending a complex json object returns the correct `%SimOutput{}` struct", context do
      assert calculate_cpu_schedule_data_from_json_object(context[:complex_json_object_input]) ==
        context[:complex_json_object_output]
    end
  end
end
