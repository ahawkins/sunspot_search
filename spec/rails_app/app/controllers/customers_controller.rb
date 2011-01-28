class CustomersController < ApplicationController
  def index
    if params[:customer_search]
      @search = CustomerSearch.new params[:customer_search]
      @customers = @search.run
    else
      @search = CustomerSearch.new 
      @search.conditions << SolrSearch::Condition.new(:search => @search)
    end
  end
end
