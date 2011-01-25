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
      t.string   "email"
      t.string   "phone"
      t.string   "time_zone"
      t.string   "address"
      t.string   "town"
      t.string   "locality"
      t.string   "country"
      t.string   "postcode"
      t.string   "company_name"
      t.integer  "account_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "import_id"
      t.datetime "contacted_at"
      t.string   "state"
      t.datetime "became_lead_at"
      t.datetime "became_prospect_at"
      t.datetime "became_opportunity_at"
      t.datetime "became_client_at"
      t.datetime "became_dead_end_at"
    end
  end

  def self.down
    drop_table :searches
  end
end
