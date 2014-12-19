[![Lines of Code](http://img.shields.io/badge/lines_of_code-870-brightgreen.svg?style=flat)](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/)
[![Code Status](http://img.shields.io/codeclimate/github/hopsoft/ellington.svg?style=flat)](https://codeclimate.com/github/hopsoft/ellington)
[![Dependency Status](http://img.shields.io/gemnasium/hopsoft/ellington.svg?style=flat)](https://gemnasium.com/hopsoft/ellington)
[![Build Status](http://img.shields.io/travis/hopsoft/ellington.svg?style=flat)](https://travis-ci.org/hopsoft/ellington)
[![Coverage Status](https://img.shields.io/coveralls/hopsoft/ellington.svg?style=flat)](https://coveralls.io/r/hopsoft/ellington?branch=master)
[![Downloads](http://img.shields.io/gem/dt/ellington.svg?style=flat)](http://rubygems.org/gems/ellington)

# Ellington

### Important

__The wiki docs are out of date!__

You'll have to review the examples & code itself for now.
I'll be working to bring the wiki docs current soon.

---

Named after [Duke Ellington](http://www.dukeellington.com/) whose signature tune was ["Take the 'A' Train"](http://en.wikipedia.org/wiki/Take_the_%22A%22_Train).
The song was written about [New York City's A train](http://en.wikipedia.org/wiki/A_%28New_York_City_Subway_service%29).

![Subway Tunnel](https://raw.github.com/hopsoft/ellington/master/doc/tunnel.jpg)

#### Ellington is an architecture for modeling complex business processes.

Ellington brings discipline, organization, and modularity to a project.

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

- **[Conductor](https://github.com/hopsoft/ellington/wiki/Conductor)** - A supervisor responsible for putting `passengers` on a `route`.
- **[Passenger](https://github.com/hopsoft/ellington/wiki/Passenger)** - The stateful context that will be riding the virtual subway.
- **[Route](https://github.com/hopsoft/ellington/wiki/Route)** - A collection of `lines` and their `connections`.
- **[Line](https://github.com/hopsoft/ellington/wiki/Line)** - A linear track that moves the `passenger` from point A to point B.
- **[Station](https://github.com/hopsoft/ellington/wiki/Station)** - A discreet chunk of business logic.
- **[State](https://github.com/hopsoft/ellington/wiki/State)** - A status or disposition assigned to the `passenger`.

![Ellington Diagram](https://raw.github.com/hopsoft/ellington/master/doc/primary-terms.png)

**Note:** *We recommend Ellington for projects where a good understanding of the problem domain has been established.
You might want to [spike a solution](http://en.wikipedia.org/wiki/Software_prototyping) to learn your project's requirements before using Ellington.*

## Run the demo

```
git clone git://github.com/hopsoft/ellington.git
cd ellington
bundle
bundle exec ruby examples/social_media/demo.rb
```

Review the demo project [here](https://github.com/hopsoft/ellington/tree/master/examples/social_media).

