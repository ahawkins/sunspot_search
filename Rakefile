require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ['-c', '-d']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

namespace :cucumber do
  Cucumber::Rake::Task.new(:ok, 'Run all features that should pass')
  Cucumber::Rake::Task.new(:wip, 'Run features that are being worked in') do |t|
    t.profile = 'wip'
  end

  task :default => :ok
end
task :cucumber => 'cucumber:ok'


task :default => [:spec, :cucumber]
