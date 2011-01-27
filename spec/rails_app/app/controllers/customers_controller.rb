class CustomersController < ApplicationController
  def index
    if params[:customer_search]
      @search = CustomerSearch.new params[:customer_search]
      @customers = @search.run
    else
      @search = CustomerSearch.new :sort_by => 'sort_name', :sort_direction => :desc
    end
  end
end
