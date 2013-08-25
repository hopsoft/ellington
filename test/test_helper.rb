require "logger"
require "delegate"
require "micro_test"
require "micro_mock"
require 'simplecov'
require "coveralls"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.command_name 'micro_test'
SimpleCov.start do
  add_filter "/test/"
end
Coveralls.wear!

require_relative "example"
require_relative "../lib/ellington"

