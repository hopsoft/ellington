# Ellington 
Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

![Subway Tunnel](https://raw.github.com/hopsoft/ellington/master/doc/tunnel.jpg)

#### Ellington is an architecture for modeling complex business processes.

Ellington is a collection of simple concepts designed to bring discipline, organization, and modularity to a project.
The base implementation is very light, weighing in around 500 lines.

The nomenclature is taken from [New York's subway system](http://en.wikipedia.org/wiki/New_York_City_Subway).
We've found that using cohesive physical metaphors helps people reason more clearly about the complexities of software.
*The subway analogy isn't perfect but gets pretty close.*

### Important

The Ellington architecture should only be applied **after** a good understanding of the problem domain has been established.
*We recommend [spiking a solution](http://en.wikipedia.org/wiki/Software_prototyping) to learn your project's requirements and then coming back to Ellington.*

## Goals

- Provide a nomenclature simple enough to be shared by engineering and the business team.
- Establish constraints to ensure that complex projects are easy to manage, develop, and maintain.

## Lexicon

- **[Conductor](https://github.com/hopsoft/ellington/wiki/Conductor)** - A supervisor responsible assembling `passengers` and putting them on a `route`.
- **[Passenger](https://github.com/hopsoft/ellington/wiki/Passenger)** - The stateful context that will be riding the virtual subway.
- **[Route](https://github.com/hopsoft/ellington/wiki/Route)** - A collection of `lines` and their `connections`.
- **[Line](https://github.com/hopsoft/ellington/wiki/Line)** - A linear track that moves the `passenger` from point A to point B.
- **[Station](https://github.com/hopsoft/ellington/wiki/Station)** - A discreet chunk of business logic.
- **[State](https://github.com/hopsoft/ellington/wiki/State)** - A status or disposition assigned to the `passenger`.
- **[State Transition](https://github.com/hopsoft/ellington/wiki/State)** - The `transition`, performed on the `passenger`, from one `state` to another.

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/primary-terms.png)

#### Additional Terms

- **[Ticket](https://github.com/hopsoft/ellington/wiki/Ticket)** - An authorization token that indicates the `passenger` can ride a specific `route`.
- **[Goal](https://github.com/hopsoft/ellington/wiki/Goal)** - A list of expected `states`.
- **[Connection](https://github.com/hopsoft/ellington/wiki/Connection)** - A link between `lines`.
- **[Transfer](Transfer)** - A link between `routes`.
- **[Network](Network)** - An entire system of `routes` & `transfers` designed to work together.

