class CustomersController < ApplicationController
  def index
    if params[:customer_search]
      @search = CustomerSearch.new params[:customer_search]
      @customers = @search.run
    else
      @customers = Customer.search do
        with(:revenue).greater_than(0)
      end
      @search = CustomerSearch.new 
    end

    configure_search
  end

  def configure_search
    @search.configuration do |form|
      # Condition configuration
      form.condition do |c|
        c.attribute = :revenue
        c.name = 'Revenue'
        c.type = :currency # Defines what operators are available
        c.extras = {:min => 10000, :max => 2000000, :step => 1000}
        c.hint = 'Example: 10.000,00'
      end

      form.condition do |c|
        c.attribute = :deals_counter
        c.name = '# Deals'
        c.type = :integer # Defines what operators are available
      end

      form.condition do |c|
        c.attribute = :rating
        c.name = 'Rating'
        c.type = :float
      end

      form.condition do |c|
        c.attribute = :state
        c.name = 'Kind'
        c.type = :string
        c.choices = Customer.all.map(&:state).inject({}) do |hash, state|
          hash[state] = state.titleize
          hash
        end
      end

      form.condition do |c|
        c.attribute = :last_contacted
        c.name = 'Last Contacted'
        c.type = :time
        c.hint = 'Example: 2011/01/25, or 2011/01/01-2011/01/15 when using "Between"'
      end

      # form.condition do |c|
      #   c.attribute = :created_at
      #   c.name = 'Added'
      #   c.type = :time
      # end

      # form.condition do |c|
      #   c.attribute = :last_contacted
      #   c.name = 'Contacted'
      #   c.type = :time
      # end


      # form.condition do |c|
      #   c.attribute = :bought_products
      #   c.name = 'Bought Products?'
      #   c.type = :boolean
      # end

      # Possible fields to search against
      form.search_field do |field|
        field.attribute = :name
        field.name = 'Name'
      end

      form.search_field do |field|
        field.attribute = :company
        field.name = 'Company'
      end

      # Sort configurations

      form.sort_option do |option|
        option.attribute = :sort_name
        option.name = 'Name'
      end
    
      form.sort_option do |option|
        option.attribute = :sort_name
        option.name = 'Company'
      end

      form.pagination_options = 50, 100, 150, 200
    end
  end
end
