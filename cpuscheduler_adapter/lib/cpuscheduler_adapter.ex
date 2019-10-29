defmodule CpuschedulerAdapter do
  @moduledoc """
  The CpuschedulerAdapter module is responsible for acting as an interface
  between the base Cpuscheduler API and whatever is making calls to it. Input
  will be expected to come in as a JSON object, anything else will fail.

  The input will be taken as JSON, decoded into a `%SimParameters{}` struct, and
  passed to the Cpuscheduler API. The Cpuscheduler API will return a
  `%SimOutput{}` struct which will then be encoded back into a JSON object and
  returned by this module.
  """

  def decode_input_into_sim_parameters_struct(json) do
    json
    |> Jason.decode!(keys: :atoms!)
    |> convert_input_map_into_sim_parameters_struct()
  end

  def encode_output_into_json_object(%SimOutput{} = struct) do
    struct
    |> convert_sim_output_struct_into_json_encodable_map()
    |> Jason.encode!()
  end

  defp convert_input_map_into_sim_parameters_struct(input_map) do
    input_map
    |> convert_input_algorithm_field_from_string_to_atom()
    |> convert_processes_into_cpu_process_structs()
    |> cast_map_to_sim_parameters_struct()
  end

  defp convert_sim_output_struct_into_json_encodable_map(struct) do
    struct
    |> Map.from_struct()
    |> convert_process_time_structs_to_maps()
    |> convert_gantt_data_structs_to_maps()
  end

  defp convert_input_algorithm_field_from_string_to_atom(input_map) do
    %{input_map | algorithm: String.to_atom(input_map.algorithm)}
  end

  defp convert_processes_into_cpu_process_structs(%{processes: processes} = input_map)
       when is_nil(processes) do
    input_map
  end

  defp convert_processes_into_cpu_process_structs(%{processes: processes} = input_map)
       when not is_nil(processes) do
    %{input_map | processes: Enum.map(input_map.processes, &cast_map_to_cpu_process_struct/1)}
  end

  defp convert_process_time_structs_to_maps(%{process_times: process_times} = output)
       when is_nil(process_times) do
    output
  end

  defp convert_process_time_structs_to_maps(%{process_times: process_times} = output)
       when not is_nil(process_times) do
    %{output | process_times: Enum.map(output.process_times, &Map.from_struct/1)}
  end

  defp convert_gantt_data_structs_to_maps(%{gantt_data: gantt_data} = output)
       when is_nil(gantt_data) do
    output
  end

  defp convert_gantt_data_structs_to_maps(%{gantt_data: gantt_data} = output)
       when not is_nil(gantt_data) do
    %{output | gantt_data: Enum.map(output.gantt_data, &Map.from_struct/1)}
  end

  defp cast_map_to_sim_parameters_struct(map) do
    struct!(SimParameters, map)
  end

  defp cast_map_to_cpu_process_struct(map) do
    struct!(CpuProcess, map)
  end
end
