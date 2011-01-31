require 'machinist/active_record'
require 'faker'

Customer.blueprint do
  name { Faker::Name.name }
  company { Faker::Company.name }
  revenue { Faker::PhoneNumber.numerify('########') }
  state { %w(lead prospect opportunity client).rand }
  bought_products { [true, false].rand }
  deals_counter { rand(50) }
  rating { Faker::PhoneNumber.numerify("##.##").to_f }
end
