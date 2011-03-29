module SunspotSearch
  module Matchers
    def have_condition(attribute_name)
      ConditionMatcher.new(attribute_name)
    end

    def sort_by(attribute_name)
      SortMatcher.new(attribute_name)
    end

    def search_for(search_class)
      SearchForMatcher.new search_class
    end

    class ConditionMatcher
      def initialize(attribute_name)
        @expected_attribute = attribute_name
      end

      def named(expected_name)
        @expected_name = expected_name
        self
      end

      def as_a(expected_type)
        @expected_type = expected_type
        self
      end

      def allowing(*args)
        @expected_operators = args
        self
      end

      def matches?(target)
        @target = target

        return false if @target.form_configuration.condition_attributes.blank?

        @actual_condition = @target.form_configuration.condition_attributes.select do |c|
          c.attribute == @expected_attribute
        end.first

        return false unless @actual_condition

        flag = true

        if @expected_name
          flag = flag && @actual_condition.name == @expected_name
        end

        if @expected_type
          flag = flag && @actual_condition.type == @expected_type
        end

        if @expected_operators
          flag = flag && @actual_condition.allow.sort == @expected_operators.sort
        end

        flag
      end

      def failure_message_for_should
        msg = "expected the search to have a condition for #{@expected_attribute}, but it did not"
        if @actual_condition
          msg =+ %Q{Expected attribute: #{@expected_attribute}, Actual: #{@actual_condition.attribute}}
          msg =+ %Q{Expected name: #{@expected_name}, Actual: #{@actual_condition.name}} if @expected_name
          msg =+ %Q{Expected type: #{@expected_type}, Actual: #{@actual_condition.type}} if @expected_type
          msg =+ %Q{Expected operators: #{@expected_operators}, Actual: #{@actual_condition.allow}} if @expected_operators
        end
        msg
      end

      def failure_message_for_should_not
        msg = "expected the search to not have a condition for #{@expected_attribute}, but it did"
        if @actual_condition
          msg =+ %Q{Expected attribute: #{@expected_attribute}, Actual: #{@actual_condition.attribute}}
          msg =+ %Q{Expected name: #{@expected_name}, Actual: #{@actual_condition.name}} if @expected_name
          msg =+ %Q{Expected type: #{@expected_type}, Actual: #{@actual_condition.type}} if @expected_type
          msg =+ %Q{Expected operators: #{@expected_operators}, Actual: #{@actual_condition.allow}} if @expected_operators
        end
        msg
      end

      def description
        "The search does not have a correct condition"
      end
    end

    class SortMatcher
      def initialize(attribute_name)
        @expected_attribute = attribute_name
      end

      def named(expected_name)
        @expected_name = expected_name
        self
      end

      def matches?(target)
        @target = target

        return false if @target.form_configuration.sort_attributes.blank?

        @actual_attribute = @target.form_configuration.sort_attributes.select do |c|
          c.attribute == @expected_attribute
        end.first

        return false unless @actual_attribute

        flag = true

        if @expected_name
          flag = flag && @actual_attribute.name == @expected_name
        end

        flag
      end

      def description
        "search did not match the sort criteria"
      end

      def failure_message_for_should
        msg = "expected the search to sort by #{@expected_attribute}, but it did not"
        if @actual_attribute
          msg =+ %Q{Expected attribute: #{@expected_attribute}, Actual: #{@actual_condition.attribute}}
          msg =+ %Q{Expected name: #{@expected_name}, Actual: #{@actual_attribute.name}} if @expected_name
        end
        msg
      end

      def failure_message_for_should_not
        msg = "expected the search to not sort by #{@expected_attribute}, but it did"
        if @actual_attribute
        msg =+ %Q{Expected attribute: #{@expected_attribute}, Actual: #{@actual_condition.attribute}}
          msg =+ %Q{Expected name: #{@expected_name}, Actual: #{@actual_attribute.name}} if @expected_name
        end
        msg
      end
    end

    class SearchForMatcher
      def initialize(expected_search)
        @expected_search = expected_search
      end

      def matches?(target)
        @target = target

        @actual_search = @target.class.search_class
        @actual_search == @expected_search
      end

      def description
        "class does not search for correct objects"
      end

      def failure_message_for_should
        "expected to search for #{@expected_search}, but searched for #{@actual_search}"
      end

      def failure_message_for_should_not
        "expected to not search for #{@expected_search}, but searched for #{@actual_search}"
      end
    end
  end
end
