require 'rails/generators/base'

module SunspotSearch
  class InstallGenerator < Rails::Generator::Base

    def manifest
      record do |m|
        m.directory File.join('public', 'javascripts')
        m.template 'jquery.sunspot_search.js',   File.join('public', 'javascripts', 'jquery.sunspot_search.js')
        m.migration_template 'migration.rb', 'db/migrate/create_sunspot_searches.rb'
      end
    end

    protected

    def banner
      %{Usage: #{$0} #{spec.name}\nCopies sunspot_search.js to public/javascripts/}
    end
    
    def source_root
      File.expand_path('../templates', __FILE__)
    end
  end
end
