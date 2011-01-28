module SolrSearch
  class Search < ActiveRecord::Base
    cattr_accessor :form_configuration

    attr_accessor :page

    serialize :fields

    after_initialize :initialize_conditions

    class << self
      def searches(klass)
        @searches = klass
      end

      def search_class
        return @searches if @searches

        name = to_s
        name.match(/(.+)Search/)[1].constantize
      end

      def configuration
        new_configuration = FormConfiguration.new
        yield(new_configuration)
        self.form_configuration = new_configuration
      end
    end

    def form_configuration
      self.class.form_configuration
    end

    def search_class
      self.class.search_class
    end

    def initialize_conditions
      self.conditions ||= []
      self.conditions << Condition.new(:search => self)
    end

    def conditions_attributes=(attributes)
      attributes.each_pair do |_, condition_attributes|
        condition_attributes.merge!(:search => self)
        self.conditions << Condition.new(condition_attributes)
      end
    end

    def run
      SolrSearch::SearchBuilder.run(self)
    end
  end
end
