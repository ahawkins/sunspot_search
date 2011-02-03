module SunspotSearch
  class SearchBuilder
    def self.run(model)
      sunspot_search = Sunspot.search model.search_class do
        # now translate the options

        if model.keywords
          keywords(model.keywords) do
            if model.fields.present?
              modelable_fields = model.fields.reject(&:blank?)
              fields(*modelable_fields) if !modelable_fields.empty?
            end
          end
        end

        if model.conditions.present?
          model.conditions.each do |c|
            case c.operator.to_sym
            when :less_than, :greater_than, :all_of, :any_of, :between
              with(c.attribute).send(c.operator, c.attribute_value)
            when :before
              with(c.attribute).less_than(c.attribute_value)
            when :after
              with(c.attribute).greater_than(c.attribute_value)
            when :blank
              with(c.attribute, nil)
            when :not_blank
              without(c.attribute, nil)
            when :equal
              with(c.attribute, c.attribute_value)
            end
          end
        end

        # Scopes are one off and are not part of the conditions
        # they should be used in the controller to scope searches
        # to specific acccounts or users. Things you dont' want the users
        # to be able to control
        model.scopes.each_pair do |attribute, value|
          with(attribute, value)
        end

        if model.sort_by.present? && model.sort_direction.present?
          order_by model.sort_by, model.sort_direction
        end

        if model.per_page.present?
          paginate :per_page => model.per_page, :page => (model.page.blank? ? 1 : model.page)
        end
      end

      sunspot_search
    end
  end
end
