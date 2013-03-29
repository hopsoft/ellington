require "bundler"
Bundler.require
Bundler.require :development, :test if ENV["ELLINGTON_DEV"]

path = File.join(File.dirname(__FILE__), "ellington/**/*.rb")
Dir[path].each { |file| require file }

# Require Generators separately
gen_path = File.join(File.dirname(__FILE__), "generator/**/*.rb")
Dir[gen_path].each { |file| require file }
