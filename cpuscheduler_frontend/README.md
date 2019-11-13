# CpuschedulerFrontend

- This component acts as the frontend for the CPU Scheduler project and provides a GUI for the user via a web client. The user will have the opportunity to edit the simulation parameters as they please before hitting the `CALCULATE` button, at which point the current simulation parameters will be encoded into JSON and sent in a POST request to the HTTP server. The server will send a JSON-formatted response, which this component then decodes and -using the decoded information- displays the output of the simulation.

## mind the mess

- This component does not house any business logic (thankfully), and contains a large amount of poorly thought-out code, which I would like to blame on my inexperience with the language. Were I to rewrite this component, there is a good deal of things I would like to do differently using what I know now. I am pleased with the code quality of the other components in this project, but not in this one- please mind the mess. 
