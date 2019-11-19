# cpu-scheduler

GitHub repo located at: https://github.com/samuelludwig/cpu-scheduler

CPU Scheduler Simulation project for COM310

Task: Create an interactive webapp that displays the impact of different kinds 
of algorithms regarding the scheduling of CPU processes.

The tech stack employed will be as follows:

- Backend: Elixir (using Cowboy to manage the server connections)
- Frontend: Elm

## Project Structure

- `cpuscheduler`: Takes in a struct containing the parameters for the simulation, calculates the output of the simulation based on those parameters, and returns the output in another struct.
- `cpuscheduler_adapter`: Takes in a JSON object and transforms it into a struct that can be sent to the base `cpuscheduler`, it will then turn the returned struct *back* into JSON and return that.
- `cpuscheduler_http_server`: Starts up a server on `localhost:8085` with one available path- `/calculate`. The server waits for an HTTP POST request with a JSON body, which it then passes to the `cpuscheduler_adapter` component, it sends the JSON it gets back from the adapter as an HTTP response.
- `cpuscheduler_frontend`: Web client written in the Elm programming language, acts as the user interface for the simulator, will make POST requests to the HTTP server and receive the response.

![Diagram of CPU Scheduler components](../color_cpu_scheduler.png "CPU Scheduler Components")

## Raison D'être

- Elixir is a language that I am pretty confident with by now, but have done 
limited work with it at scale.
- I wanted to try out using Dave Thomas' "Component-based Design/Architecture" 
idea, meaning each part of my program should be built as if it were a separate 
library, with a well defined API that can be used by any module calling it.
- I wanted an opportunity to try out TDD on something more complex then a toy 
problem/kata.
- I've been looking for an excuse to try the Elm programming language since 
going through the tutorial some time ago, but I haven't needed to build a 
front-end for an application in quite some time.

***

## Note Regarding SJF and Priority Algorithms

- The implementation for the SJF and Priority algorithms make use of Elixir's `Enum.sort/2` function when determining the order in which processes are to be executed by the CPU. This sorting function is actually a Merge-Sort under the hood, this means that there may be situations in which (when identical values are entered for processes) the order is slightly different from what might be anticipated (but not erroneous).
- For example, in the SJF implementation, if the following process list was given:

```elixir
[
  %CpuProcess{p_name: "p1", burst_size: 6},
  %CpuProcess{p_name: "p2", burst_size: 3},
  %CpuProcess{p_name: "p3", burst_size: 8},
  %CpuProcess{p_name: "p4", burst_size: 6}
]
```

the processes would be sorted as follows:

```elixir
[
  %CpuProcess{p_name: "p2", burst_size: 3},
  %CpuProcess{p_name: "p4", burst_size: 6},
  %CpuProcess{p_name: "p1", burst_size: 6},
  %CpuProcess{p_name: "p3", burst_size: 8}
]
```

where process `p4` is placed ahead of process `p1`. Notice that this is not *incorrect*, but may perhaps be a different output than expected, where one might expect `p1` to come first.
