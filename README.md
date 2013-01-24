# Ellington

Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

![Subway Tunnel](https://raw.github.com/hopsoft/ellington/master/doc/tunnel.jpg)

### Decomposing complex business processes

Ellington's nomenclature is taken from [New York's subway system](http://en.wikipedia.org/wiki/New_York_City_Subway).
We've found that drawing parallels to the physical world helps us reason 
more clearly about the complexities of software.
*The subway analogy isn't perfect but gets pretty close.*

## Goals

- Provide a nomenclature simple enough to be shared by engineering and business folks.
- Establish constraints to ensure that complex projects are easy to manage, develop, and maintain.

## Lexicon

- **Passenger** - The stateful context or passenger that will be riding our virtual subway.
- **Ticket** - An authorization token that indicates the passenger can ride a specific route.
- **State** - The status or disposition assigned to the passenger.
- **State Transition** - The transition, performed on the passenger, from one state to another state.
- **Conductor** - A supervisor responsible assembling passengers and putting them on a route.
- **Attendant** - A helper that determines whether or not a station's logic should run for a given passenger.
- **Station** - A stop where business logic is applied. 
                The passenger's state can change once per stop.
                Note: A station may be skipped depending upon the passenger's state.
- **Line** - A rigid track that moves the passenger from point A to point B.
- **Sub Line** - A line invoked by a station owned by another line within the same route.
- **Connection** - A link between lines.
- **Route** - A collection of lines and their connections.
              Routes are synonymous with projects 
              (e.g. a physical collection of lines into a single repo).
- **Transfer** - A link between routes.
- **Network** - An entire system of routes & transfers designed to work together.

## Rules

- The passenger's state may only transition once per station.
- A station may be skipped depending upon the passenger's state. 
- A station may invoke a sub-line that tranports the same type of passenger.
- Any station may perform a connection to another line if all stations after it are skipped.
- Any station may perform a transfer to another route if all lines and stations after it are skipped.
- Any station may invoke a new route for a different passenger.

## Visualizations

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/diagram.png)

## Implementation

### Logging

Ellington exposes a logger that logs all of the following at each station.

- Date/Time
- Ticket
- Passenger - *Its possible to customize what properties get logged from the passenger.*
- State
- Transition
- Route
- Line
- Station

*The log output coupled with technologies like [map/reduce](http://en.wikipedia.org/wiki/MapReduce)
provides powerful analytics capabilities.*

