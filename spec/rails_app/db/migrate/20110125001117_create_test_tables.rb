class CreateTestTables < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|

      t.string :name
      t.text :options
      t.string :type

      t.timestamps
    end

    create_table "customers", :force => true do |t|
      t.string   "name"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "company"
    end
  end

  def self.down
    drop_table :searches
  end
end
