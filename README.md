# Ellington 
Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

![Subway Tunnel](https://raw.github.com/hopsoft/ellington/master/doc/tunnel.jpg)

#### Ellington is an architecture for modeling complex business processes.

Ellington is a collection of simple concepts designed to bring discipline, organization, and modularity to a project.
The base implementation is very light, weighing in around 500 lines.

The nomenclature is taken from [New York's subway system](http://en.wikipedia.org/wiki/New_York_City_Subway).
We've found that drawing parallels to the physical world helps to reason
more clearly about the complexities of software.
*The subway analogy isn't perfect but gets pretty close.*

### Important

The Ellington architecture should be applied **after** a good understanding of the problem domain has been established.
*We recommend [spiking a solution](http://en.wikipedia.org/wiki/Software_prototyping) to learn your project's requirements and then coming back to Ellington.*

## Goals

- Provide a nomenclature simple enough to be shared by engineering and the business team.
- Establish constraints to ensure that complex projects are easy to manage, develop, and maintain.

## Lexicon

- **Conductor** - A supervisor responsible assembling `passengers` and putting them on a `route`.
- **Passenger** - The stateful context that will be riding the virtual subway.
- **Route** - A collection of `lines` and their `connections`.
- **Line** - A linear track that moves the `passenger` from point A to point B.
- **Station** - A discreet chunk of business logic.
- **State** - A status or disposition assigned to the `passenger`.
- **State Transition** - The `transition`, performed on the `passenger`, from one `state` to another.

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/primary-terms.png)

#### Additional Terms

- **Ticket** - An authorization token that indicates the `passenger` can ride a specific `route`.
- **Goal** - A list of expected `states`.
- **Connection** - A link between `lines`.
- **Transfer** - A link between `routes`.
- **Network** - An entire system of `routes` & `transfers` designed to work together.

