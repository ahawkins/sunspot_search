require 'machinist/active_record'
require 'faker'

times_this_year = (Date.today.at_beginning_of_year..Date.today.at_end_of_year).to_a

Customer.blueprint do
  name { Faker::Name.name }
  company { Faker::Company.name }
  revenue { Faker::PhoneNumber.numerify('########') }
  state { %w(lead prospect opportunity client).rand }
  bought_products { [true, false].rand }
  deals_counter { rand(50) }
  rating { Faker::PhoneNumber.numerify("##.##").to_f }
  last_contacted { times_this_year.rand }
end
