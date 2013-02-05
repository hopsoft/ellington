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
- **Goal** - A list of expected states that should be assigned to the passenger.
- **Conductor** - A supervisor responsible assembling passengers and putting them on a route.
- **Attendant** - A helper that monitors the passenger's activity at a station.
- **Station** - A stop where business logic is applied. 
                The passenger's state can change once per stop.
- **Line** - A rigid track that moves the passenger from point A to point B.
- **Sub Line** - A line invoked by a station owned by another line within the same route.
- **Connection** - A link between lines.
- **Route** - A collection of lines and their connections.
              Routes are synonymous with projects 
              (e.g. a physical collection of lines into a single repo).
- **Transfer** - A link between routes.
- **Network** - An entire system of routes & transfers designed to work together.

## Rules

- The passenger's state must transition at each station if the station's logic runs.
- The passenger's state may only transition once per station.

## Visualizations

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/diagram.png)

