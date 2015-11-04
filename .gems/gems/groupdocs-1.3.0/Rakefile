require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = %w(--color --require fuubar --format Fuubar)
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec
