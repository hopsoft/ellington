# Ellington
Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

![Subway Tunnel](https://raw.github.com/hopsoft/ellington/master/doc/tunnel.jpg)

#### Ellington is an architecture for modeling complex business processes.

Ellington is a collection of simple concepts designed to bring discipline, organization, and modularity to a project.

The nomenclature is taken from [New York's subway system](http://en.wikipedia.org/wiki/New_York_City_Subway).
We've found that using consistent and cohesive physical metaphors helps people reason more clearly about the complexities of software.
*The subway analogy isn't perfect but gets pretty close.*

### Goals

- Provide a consistent nomenclature thats simple enough to be shared by engineering and the business team.
- Establish constraints which ensure complex projects are easy to manage, develop, and maintain.

## Start Here

* Skim the intro [slides on Speaker Deck](https://speakerdeck.com/hopsoft/ellington-intro).
* Review one of the [example apps](https://github.com/hopsoft/ellington/tree/master/examples/social_media).

## Lexicon

- **[Conductor](https://github.com/hopsoft/ellington/wiki/Conductor)** - A supervisor responsible for gathering `passengers` and putting them on a `route`.
- **[Passenger](https://github.com/hopsoft/ellington/wiki/Passenger)** - The stateful context that will be riding the virtual subway.
- **[Route](https://github.com/hopsoft/ellington/wiki/Route)** - A collection of `lines` and their `connections`.
- **[Line](https://github.com/hopsoft/ellington/wiki/Line)** - A linear track that moves the `passenger` from point A to point B.
- **[Station](https://github.com/hopsoft/ellington/wiki/Station)** - A discreet chunk of business logic.
- **[State](https://github.com/hopsoft/ellington/wiki/State)** - A status or disposition assigned to the `passenger`.

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/primary-terms.png)

**Note:** *We recommend Ellington for projects where a good understanding of the problem domain has been established.
You might want to [spike a solution](http://en.wikipedia.org/wiki/Software_prototyping) to learn your project's requirements before using Ellington.*

## Run the demo

```sh
git clone git://github.com/hopsoft/ellington.git
cd ellington
bundle
bundle exec ruby examples/social_media/demo.rb
```

Review the demo code [here](https://github.com/hopsoft/ellington/tree/master/examples/social_media).

