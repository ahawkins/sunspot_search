# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sunspot_search/version"

Gem::Specification.new do |s|
  s.name        = "sunspot_search"
  s.version     = SunspotSearch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Adam Hawkins'
  s.email       = 'adman1965@gmail.com'
  s.homepage    = "http://github.com/Adman65/sunspot_search"
  s.summary     = %q{Generate complicated search forms with ease}
  s.description = %q{Generate complicates search form with things like: selecting fields, 
    adding conditions, chaning sorting and pagination options--then run w/Sunspot}

  s.rubyforge_project = "sunspot_search"

  s.add_dependency 'sunspot_rails'
  s.add_dependency 'formtastic', '~> 1.2.3'

  s.add_development_dependency 'rails', '~> 3.0.3'
  s.add_development_dependency 'rspec', '~> 2.3.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'cucumber-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'infinity_test'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'will_paginate'
  s.add_development_dependency 'machinist'
  s.add_development_dependency 'faker'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
