defmodule JsonHandlerTest do
  use ExUnit.Case

  import JsonHandler

  setup do
    [
      basic_json_object: "{\"algorithm\":\"priority\",\"processes\":null,\"quantum\":null}",
      complex_json_object:
        "{\"algorithm\":\"round_robin\",\"processes\":[{\"burst_size\":6,\"p_name\":\"p1\",\"priority\":2},{\"burst_size\":13,\"p_name\":\"p2\",\"priority\":1},{\"burst_size\":8,\"p_name\":\"p3\",\"priority\":5}],\"quantum\":6}",
      basic_sim_output: %SimOutput{
        process_times: nil,
        gantt_data: nil,
        average_wait_time: 0.0,
        average_turnaround_time: 0.0
      },
      complex_sim_output: %SimOutput{
        process_times: [
          %ProcessTimeDatum{p_name: "p1", wait_time: 0, turnaround_time: 6},
          %ProcessTimeDatum{p_name: "p2", wait_time: 6, turnaround_time: 9}
        ],
        gantt_data: [
          %GanttDatum{p_name: "p1", start_time: 0, stop_time: 6},
          %GanttDatum{p_name: "p2", start_time: 6, stop_time: 9}
        ],
        average_wait_time: 7.5,
        average_turnaround_time: 14.75
      }
    ]
  end

  describe "decode_input_into_sim_parameters_struct/1" do
    test "fails on non-JSON input" do
      assert catch_error(decode_input_into_sim_parameters_struct("I'm not a JSON object"))
    end

    test "fails if input cannot be converted into a `%SimParameters{}` struct" do
      assert catch_error(decode_input_into_sim_parameters_struct("{}"))
    end

    test "converts basic valid JSON input into correct `%SimParameters{}` struct", context do
      assert decode_input_into_sim_parameters_struct(context[:basic_json_object]) ==
               %SimParameters{
                 algorithm: :priority,
                 processes: nil,
                 quantum: nil
               }
    end

    test "converts complex valid JSON input into correct `%SimParameters{}` struct", context do
      assert decode_input_into_sim_parameters_struct(context[:complex_json_object]) ==
               %SimParameters{
                 algorithm: :round_robin,
                 processes: [
                   %CpuProcess{p_name: "p1", burst_size: 6, priority: 2},
                   %CpuProcess{p_name: "p2", burst_size: 13, priority: 1},
                   %CpuProcess{p_name: "p3", burst_size: 8, priority: 5}
                 ],
                 quantum: 6
               }
    end
  end

  describe "encode_output_into_json_object/1" do
    test "fails when not given valid `%SimOutput{}` struct" do
      assert catch_error(encode_output_into_json_object("FAIL"))
    end

    test "converts basic `%SimOutput{}` struct into correct JSON", context do
      assert encode_output_into_json_object(context[:basic_sim_output]) ==
               "{\"average_turnaround_time\":0.0,\"average_wait_time\":0.0,\"gantt_data\":null,\"process_times\":null}"
    end

    test "converts complex `%SimOutput{}` struct into correct JSON", context do
      assert encode_output_into_json_object(context[:complex_sim_output]) ==
               "{\"average_turnaround_time\":14.75,\"average_wait_time\":7.5,\"gantt_data\":[{\"p_name\":\"p1\",\"start_time\":0,\"stop_time\":6},{\"p_name\":\"p2\",\"start_time\":6,\"stop_time\":9}],\"process_times\":[{\"p_name\":\"p1\",\"turnaround_time\":6,\"wait_time\":0},{\"p_name\":\"p2\",\"turnaround_time\":9,\"wait_time\":6}]}"
    end
  end
end
