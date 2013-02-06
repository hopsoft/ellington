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

- **Conductor** - A supervisor responsible assembling passengers and putting them on a route.
- **Passenger** - The stateful context or passenger that will be riding our virtual subway.
- **Route** - A collection of lines and their connections.
              Routes are synonymous with projects
              (e.g. a physical collection of lines into a single repo).
- **Line** - A rigid track that moves the passenger from point A to point B.
- **Station** - A discreet chunk of business logic.
- **State** - The status or disposition assigned to the passenger.
- **State Transition** - The transition, performed on the passenger, from one state to another state.

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/primary-terms.png)

#### Secondary Terms

- **Goal** - A list of expected states that should be assigned to the passenger.
- **Ticket** - An authorization token that indicates the passenger can ride a specific route.
- **Connection** - A link between lines.
- **Transfer** - A link between routes.
- **Network** - An entire system of routes & transfers designed to work together.

## Rules

- The passenger's state must transition exactly once per station.

## Visualizations

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/diagram.png)

## Directory Structure

```
|- lib
  |- ellington
    |- routes
      |- route_name
        |- stations
          |- foo_station.rb
          |- bar_station.rb
        |- conductor.rb
        |- intializer.rb
```

