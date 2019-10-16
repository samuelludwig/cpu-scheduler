# CpuScheduler

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cpu_scheduler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cpu_scheduler, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cpuscheduler](https://hexdocs.pm/cpu__scheduler).

## Algorithms

- FCFS
  - Processes are executed in the order they are brought in, regardless of the 
  time in which they are queued in.
  - P1 -> P2 -> P3 :: |P1|P2|P3|
  - Waiting time for Pn = Process time of (Pn-1 + Pn-2 + ... + P1)
  - Turnaround time for Pn = Waiting time of Pn + Process time of Pn 
- SJF

## FCFS API

- The data will come in as a map in the form of:

```elixir
%{algorithm: alg, process_burst_sizes: [{p1, x}, {p2, y}, ..., {pn, z}]}
```

- The data will be returned in a map in the form of:

```elixir
%{process_times: [%{p_name: p1, p_wait_time: n, p_turnaround_time: m}, 
                 ..., 
                 %{p_name: pn, p_wait_time: y, p_turnaround_time: z}],
  gantt_data: [%{p_name: p1, time_start: n, time_stop: m}, 
              ..., 
              %{p_name: pn, time_start: x, time_stop: y}]
}
```

## SJF API
