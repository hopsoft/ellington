require "bundler"
Bundler.require
Bundler.require :development if ENV["DEV"]
Bundler.require :test if ENV["TEST"]

path = File.join(File.dirname(__FILE__), "ellington/**/*.rb")
Dir[path].each { |file| require file }

