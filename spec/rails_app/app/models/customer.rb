class Customer < ActiveRecord::Base
  searchable do 
    text :name, :company

    string :sort_name do
      name.downcase
    end

    string :sort_company do
      company.downcase
    end
  end
end
