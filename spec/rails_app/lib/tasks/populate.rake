task :populate => :environment do
  require 'blueprints'

  250.times do
    Customer.make
  end
end
