require 'bundler'
Bundler::GemHelper.install_tasks

# PROJECT_ROOT = File.expand_path("..", __FILE__)
# $:.unshift "#{PROJECT_ROOT}/lib"

require "rspec/core/rake_task"
require "neo_active_graph/tasks"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = true
  t.rspec_opts = '--format documentation'
end

task :default => :spec
