module SunspotSearch
  class Base < ActiveRecord::Base
    set_table_name 'sunspot_searches'

    attr_accessor :form_configuration, :page
    attr_accessor :scopes

    serialize :fields

    class << self
      def searches(klass)
        @searches = klass
      end

      def search_class
        return @searches if @searches

        name = to_s
        name.match(/(.+)Search/)[1].constantize
      end

      def processor(klass = nil)
        @processor = klass if klass
        @processor
      end
    end

    def configuration
      self.form_configuration = FormConfiguration.new if form_configuration.blank?
      yield(form_configuration)
    end

    def search_class
      self.class.search_class
    end

    def processor
      self.class.processor
    end

    def conditions_attributes=(attributes)
      self.conditions = []
      attributes.values.each do |condition_attributes|
        condition_attributes.merge!(:search => self)
        condition = Condition.new(condition_attributes)
        conditions << condition if condition.valid?
      end
    end

    def run(scope_attributes = {})
      self.scopes = scope_attributes
      SunspotSearch::SearchBuilder.run(self)
    end
  end
end
