class SunspotSearchGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "create_sunspot_searches"

      m.directory "public/javascripts"
      m.file 'jquery.sunspot_search.js', 'public/javascripts/jquery.sunspot_search.js'
    end
  end
end
