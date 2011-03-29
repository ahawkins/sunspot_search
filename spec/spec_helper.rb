$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))

# Boot the test application
ENV['RAILS_ENV'] = 'test'
require 'rails_app/config/environment'

# Create the test application's database
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = nil

ActiveRecord::Migrator.migrate(File.expand_path("../rails_app/db/migrate/", __FILE__))

require 'sunspot_search'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include SunspotSearch::Matchers
end
