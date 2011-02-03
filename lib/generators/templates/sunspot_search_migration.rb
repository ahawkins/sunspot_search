class CreateSunspotSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|

      t.string :name
      t.string :keywords
      t.string :sort_by
      t.string :sort_direction
      t.string :per_page
      
      # things that need to be serialized
      t.text :fields
      t.text :conditions

      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end

