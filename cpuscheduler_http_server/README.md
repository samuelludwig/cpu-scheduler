# CpuschedulerHttpServer

- This component consists of a server which expects an HTTP POST request containing JSON-formatted data which can be used to create a `%SimParameters{}` struct. This JSON is passed to the `CpuschedulerAdapter` component, which will parse the data and eventually return the JSON-encoded output, which this component sends back to the client as a response.
- The HTTP contract between the client and the server is outlined below.

## HTTP Contract

- The CPU Scheduler HTTP server expects a POST request with a JSON object body, the body must be in the form of:

```javascript
{
  "algorithm":algorithm_name,
  "processes":[list_of_processes],
  "quantum":quantum
}
```

where

```javascript
algorithm_name = "fcfs" | "sjf" | "priority" | "round_robin"
quantum = positive_integer | null
```

and each `process` in the `list_of_processes` is in the form

```javascript
{"p_name":string, "burst_size":positive_integer, "priority":integer_from_0_to_127 | null},
```

- The response from the server will arrive as another JSON object, in the form of:

```javascript
{
  "average_turnaround_time":average_turnaround_time_of_all_processes,
  "average_wait_time":average_wait_time_of_all_processes,
  "process_times":[list_of_process_time_datum],
  "gantt_data":[list_of_gantt_datum]
}
```

where

```javascript
average_turnaround_time_of_all_processes = number
average_wait_time_of_all_processes = number
```

and each `process_time_datum` in the `list_of_process_time_datum` is in the form

```javascript
{"p_name":string, "wait_time":integer, "turnaround_time":integer}
```

and each `gantt_datum` in the `list_of_gantt_datum` is in the form

```javascript
{"p_name":string, "start_time":integer, "stop_time":integer}
```

- **Expect any violation of the contract to result in failure or other undefined behavior.**
