class AdvancedSearch < SunspotSearch::Base
  after_initialize :configure_form

  def configure_form
    configuration do |form|
      # Condition configuration
      form.condition do |c|
        c.attribute = :downloads
        c.name = 'Downloads'
        c.type = :integer
        c.extras = {:min => 0, :max => 1239487}
      end

      form.condition do |c|
        c.attribute = :ruby_19_supported?
        c.name = 'Ruby 1.9.x supported?'
        c.type = :boolean
        c.allow = [:equal]
      end

      form.condition do |c|
        c.attribute = :rating
        c.name = 'Rating'
        c.type = :float
        c.extras = {:min => 0, :max => 100}
      end

      form.condition do |c|
        c.attribute = :unit_test_type
        c.name = "Unit Test Type"
        c.type = :string
        c.choices = {
          'rspec' => 'Rspec', 
          'test_unit' => 'Test::Unit',
          'mini_test' => 'MiniTest'
        }
        c.allow = [:equal]
      end

      form.condition do |c|
        c.attribute = :integration_test_type
        c.type = :string
        c.name = 'Integration Test Type'
        c.allow = [:equal]
        c.choices = {
          'das_cuke' => 'Cucumber',
          'lol_wut' => 'Steak'
        }
      end

      form.condition do |c|
        c.attribute = :created_at
        c.type = :time
        c.name = 'Added'
      end

      # Possible fields to search against
      form.search_field do |field|
        field.attribute = :author
        field.name = 'Author'
      end

      form.search_field do |field|
        field.attribute = :description
        field.name = 'Description'
      end

      form.search_field do |f|
        f.attribute = :summary
        f.name = 'Summary'
      end

      form.search_field do |f|
        f.attribute = :readme
        f.name = 'Readme'
      end

      # Sort configurations
      form.sort_option do |o|
        o.attribute = :downloads
        o.name = 'Downloads'
      end

      form.sort_option do |o|
        o.attribute = :name
        o.name = 'Name'
      end

      form.sort_option do |o|
        o.attribute = :author
        o.name = 'Author'
      end

      form.pagination_options = 50, 100, 150, 200
    end
  end
end
