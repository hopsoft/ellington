# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib", "ellington", "version")

Gem::Specification.new do |gem|
  gem.name          = "ellington"
  gem.license       = "MIT"
  gem.version       = Ellington::VERSION
  gem.authors       = ["Nathan Hopkins"]
  gem.email         = ["natehop@gmail.com"]
  gem.homepage      = "https://github.com/hopsoft/ellington"
  gem.summary       = "An opinionated framework for modeling complex business processes."
  gem.description   = "An opinionated framework for modeling complex business processes."

  gem.files         = Dir["lib/**/*.rb", "[A-Z]*"]
  gem.test_files    = Dir["test/**/*.rb"]
  gem.require_paths = ["lib"]

  gem.add_dependency "hero", "~> 0.2.0"
  gem.add_dependency "state_jacket", "~> 0.1.1"
  gem.add_dependency "ruby-graphviz", "~> 1.2.1"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "awesome_print"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-test"
  gem.add_development_dependency "pry-stack_explorer"
  gem.add_development_dependency "pry-rescue"
  gem.add_development_dependency "pry-byebug"
  gem.add_development_dependency "spoof"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "coveralls"
end
