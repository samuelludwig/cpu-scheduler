# CpuScheduler

- This component is responsible for taking in a `%SimParameters{}` struct and using it to calculate and return a `%SimOutput{}` struct.
- The `%SimParameters{}` struct will contain all the information necessary to calculate/create the appropriate output, including name of the algorithm being used, a list of processes to be scheduled + their associated data (name/burst size/priority), and the quantum (if necessary).
- The produced `%SimOutput{}` struct will contain the average wait and turnaround time for all processes, in addition to a list of data on individual process times, and a list of data that can be used to create a meaningful gantt-chart or similar representation.
- The public API for this component consists of the `CpuScheduler` module, which possesses one public function `calculate_cpu_schedule_data`. You can read more about the module, and the data structures involved within it by taking a look at its documentation.

## Algorithms

- The algorithms supported by this component are:
  - First-Come-First-Serve (FCFS)
  - Shortest-Job-First (SJF)
  - Priority
  - Round Robin
