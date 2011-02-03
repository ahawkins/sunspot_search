require 'rails/generators/base'

module SunspotSearch
  module Generators
    class PluginGenerator < Rails::Generators::Base
      desc "Copies jquery.sunspot_search.js into public/javascripts"

      source_root File.expand_path("../templates", __FILE__)

      def copy_files
        template 'jquery.sunspot_search.js', 'public/javascripts/jquery.sunspot_search.js'
      end
    end
  end
end
