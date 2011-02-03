class SearchesController < ApplicationController
  def index
    @search = BasicSearch.new
  end

  def advanced
    @search = AdvancedSearch.new
  end
end
