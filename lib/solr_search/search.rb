module SolrSearch
  class Search < ActiveRecord::Base
    attr_accessor :form_configuration, :page

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
    end

    def configuration
      self.form_configuration = FormConfiguration.new if form_configuration.blank?
      yield(form_configuration)
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
