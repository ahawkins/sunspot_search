class SunspotSearchGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join('public', 'javascripts')
      m.template 'jquery.sunspot_search.js',   File.join('public', 'javascripts', 'jquery.sunspot_search.js')
    end
  end

  protected

  def banner
    %{Usage: #{$0} #{spec.name}\nCopies sunspot_search.js to public/javascripts/}
  end
  
  def source_root
    File.expand_path('../../../lib/generators/templates', __FILE__)
  end
end

