# this is a class to test to see if the
# search container is correctly 
# detected from the class name
class CustomerSearch < Search

  configuration do |form|

    # Condition configuration
    form.condition do |c|
      c.attribute = :revenue
      c.name = 'Revenue'
      c.type = :integer # Defines what operators are available
      # Using integer creates a drop down with operators
      # for <, >, <=, =>, !=, and ==
    end

    # Possible fields to search against
    form.search_field do |field|
      field.attribute = :name
      field.name = 'Name'
    end

    form.search_field do |field|
      field.attribute = :company
      field.name = 'Company'
    end

    # Sort configurations

    form.sort_option do |option|
      option.attribute = :sort_name
      option.name = 'Name'
    end
  
    form.sort_option do |option|
      option.attribute = :sort_name
      option.name = 'Company'
    end

    form.pagination_options = 50, 100, 150, 200
  end
end
