# CpuschedulerAdapter

- This component is responsible for receiving formatted JSON data and turning it into a `%SimParameters{}` struct, which it then passes to the core `cpuscheduler` module for calculation. Upon receiving the returned `%SimOutput{}` struct, it converts *that* back into JSON, which it then returns.
