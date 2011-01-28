# this is a class to test to see if the
# search container is correctly 
# detected from the class name
class CustomerSearch < Search

  configuration do |form|
    form.search_field do |field|
      field.attribute = :name
      field.name = 'Name'
    end

    form.search_field do |field|
      field.attribute = :company
      field.name = 'Company'
    end

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
