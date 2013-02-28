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
  gem.summary       = "A micro framework to ensure your projects are easy to manage, develop, & maintain."
  gem.description   = %Q{
    A micro framework to ensure your projects are easy to manage, develop, & maintain.
  }
  gem.homepage      = "https://github.com/hopsoft/ellington"

  gem.files = FileList[
    "lib/**/*.rb",
    "[A-Z]*",
  ]

  gem.test_files    = FileList[
    "test/**/*.rb"
  ]

  gem.require_paths = ["lib"]
  gem.add_dependency "hero", "~> 0.1.7"
  gem.add_dependency "state_jacket", "~> 0.0.7"
  gem.add_dependency "ruby-graphviz", "~> 1.0.8"
  gem.license       = "MIT"
end
