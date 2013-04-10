require "bundler/gem_tasks"

task :default => [:test]

task :test do
  output = `TEST=1 && bundle exec mt`
  puts output
  exit output.include?("0 Failed")
end
