require 'rails/generators/migration'

module SunspotSearch
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Generates a migration for storing your searches"

      source_root File.expand_path("../templates", __FILE__)

      class_option :orm

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_sunspot_searches'
      end
    end
  end
end
