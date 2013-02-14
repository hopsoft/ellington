# -*- encoding: utf-8 -*-
require "rake"
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ellington/version"

Gem::Specification.new do |gem|
  gem.name          = "ellington"
  gem.version       = Ellington::VERSION
  gem.authors       = ["Nathan Hopkins"]
  gem.email         = ["natehop@gmail.com"]
  gem.summary       = "A framework for moving stateful objects through a complex series of business rules."
  gem.description   = %Q{
    Ellington is a collection of simple concepts designed to bring discipline, organization, and modularity to a project.

    The nomenclature is taken from New York's subway system.
    We've found that using cohesive physical metaphors helps people reason more clearly about the complexities of software.
    The subway analogy isn't perfect but gets pretty close.

    The Ellington architecture should only be applied after a good understanding of the problem domain has been established.
    We recommend spiking a solution to learn your project's requirements and then coming back to Ellington.
  }
  gem.homepage      = "https://github.com/hopsoft/ellington"

  gem.files = FileList[
    "lib/**/*.rb",
    "[A-Z]*",
    "test/**/*.rb"
  ]

  gem.test_files    = FileList[
    "test/**/*.rb"
  ]

  gem.require_paths = ["lib"]
  gem.add_dependency "hero", "~> 0.1.7"
  gem.add_dependency "state_jacket", "~> 0.0.7"
end
