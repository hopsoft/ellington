# Ellington

Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

## Decomposing complex business processes

Ellington's nomenclature is taken from [New York's subway system](http://en.wikipedia.org/wiki/New_York_City_Subway).
We've found that drawing parallels to the physical world helps us reason 
more clearly about the complexities of software.

### Lexicon

- **Context** - The passenger that will be riding our virtual subway.
- **State** - The status or disposition assigned to the context.
- **Station** - A stop where business logic is applied. 
                The context's state can change once per stop.
                Note: A station may be skipped depending upon the context's state.
- **Line** - A rigid track that moves the context from point A to point B.
- **Connection** - A link between lines.
- **Route** - A collection of lines and their connections.
- **Transfer** - A link between routes.
- **Network** - An entire system.

### Rules

- The context's state may only change once per station.
- A station may be skipped depending upon the context's state. 
  Stations are responsible for determining whether or not they should be skipped.
- Any station may perform a connection to another line.
  This means that lines may be invoked in a non-linear fashion.
- Any station may perform a transfer to any route.
  This means that routes may be invoked in a non-linear fashion.

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/diagram.png)
