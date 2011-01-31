module SolrSearch
  class SearchBuilder
    def self.run(model)
      sunspot_search = Sunspot.search model.search_class do
        # now translate the options

        if model.keywords
          keywords(model.keywords) do
            modelable_fields = model.fields.reject(&:blank?)
            fields(*modelable_fields) if !modelable_fields.empty?
          end
        end

        model.conditions.select(&:valid?).each do |c|
          case c.operator.to_sym
          when :less_than, :greater_than, :all_of, :any_of
            with(c.attribute).send(c.operator, c.attribute_value)
          else
            with(c.attribute, c.attribute_value)
          end
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
