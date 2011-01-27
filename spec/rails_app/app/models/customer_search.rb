# this is a class to test to see if the
# search container is correctly 
# detected from the class name
class CustomerSearch < SolrSearch::Search

  configuration do |form|
    form.sort_option do |option|
      option.attribute :sort_name
      option.name 'Name'
    end
  
    form.sort_option do |option|
      option.attribute :sort_name
      option.name 'Company'
    end
  end
  
  # Set the form configurations options
  
  # configuration do |form|
  #   form.order_option do |option|
  #     options.attribute 'sort_name'
  #     options.name 'Name'
  #   end
  # 
  #   form.order_option do |option|
  #     options.attribute 'sort_company'
  #     options.name 'Company'
  #   end
  # end

  # run do
  #   keywords 'double legit programmers'
  #   highlight :name, :bio
  #
  #   condition do |c|
  #     c.match :salary
  #     c.more_than 100000
  #   end
  #
  #   condition do |c|
  #     c.match :exprience
  #     c.between 2..4
  #   end
  #
  #   condition do |c|
  #     c.match :skills
  #     c.all_of %w(ruby cucumber rspec jquery)
  #   end
  #
  #   condition do |c|
  #     c.match :accounts
  #     c.any_of %w(twitter github)
  #   end
  #
  #   match :all # or match any
  #
  #   order :rate
  #   per_page 50
  # end
end
