require "bundler"
Bundler.require
#Bundler.require :development, :test

path = File.join(File.dirname(__FILE__), "ellington/**/*.rb")
Dir[path].each { |file| require file }

