require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec => 'db:prepare') do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ['-c', '-d']
end

namespace :cucumber do
  Cucumber::Rake::Task.new({:ok => 'db:prepare'}, 'Run all features that should pass')
  Cucumber::Rake::Task.new({:wip => 'db:prepare'}, 'Run features that are being worked in') do |t|
    t.profile = 'wip'
  end

  task :default => :ok
end
task :cucumber => 'cucumber:ok'


task :default => [:spec, :cucumber]

namespace :db do
  desc "Prepares the test database"
  task :prepare do
    %x(cd spec/rails_app ; rake db:migrate:reset RAILS_ENV=test)
  end
end
