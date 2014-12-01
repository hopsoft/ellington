require "logger"
require "delegate"
require "pry-test"
require "spoof"
require "simplecov"
require "coveralls"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.command_name "pry-test"
SimpleCov.start do
  add_filter "/test/"
end

require_relative "../lib/ellington"
require_relative "example"

