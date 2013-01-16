# Ellington

Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

## Decomposing complex business processes

Ellington's nomenclature is taken from [New York's subway system](http://en.wikipedia.org/wiki/New_York_City_Subway).
We've found that drawing parallels to the physical world helps us reason 
more clearly about the complexities of software.

The subway analogy isn't perfect but does provide enough terminology to express the major architectural components.

### Lexicon

- **Context** - The passenger that will be riding our virtual subway.
- **State** - The status or disposition assigned to the context.
- **State Transition** - The transition, *performed on the context*, from one state to another state.
- **Station** - A stop where business logic is applied. 
                The context's state can change once per stop.
                Note: A station may be skipped depending upon the context's state.
- **Line** - A rigid track that moves the context from point A to point B.
- **Sub Line** - A line invoked by a station owned by another line within the same route.
- **Connection** - A link between lines.
- **Route** - A collection of lines and their connections.
              Routes are synonymous with projects 
              (e.g. a physical collection of lines into a single repo).
- **Transfer** - A link between routes.
- **Network** - An entire system of routes & transfers designed to work together.

### Rules

- The context's state may only transition once per station.
- A station may be skipped depending upon the context's state. 
- A station may invoke a sub-line that operates on the same context.
- Any station may perform a connection to another line if all stations after it are skipped.
- Any station may perform a transfer to another route if all lines and stations after it are skipped.
- Any station may invoke a new route for a different context.

### Logging

Ellington exposes a logger that logs all of the following at each station.

- Context
- Route
- Line
- Station
- Transition - *The **state transition** that was performed on the context.*

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/diagram.png)
