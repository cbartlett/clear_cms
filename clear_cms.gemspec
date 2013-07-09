$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "clear_cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "clear_cms"
  s.version     = ClearCMS::VERSION
  s.authors     = ["Joel Niedfeldt"]
  s.email       = ["clear_cms@coolhunting.com"]
  s.homepage    = "http://www.coolhunting.com/open_source/clear_cms"
  s.summary     = "A straight-forward CMS 'framework' using MongoDB, bootstrap and more..."
  s.description = "A straight-forward CMS 'framework' using MongoDB, boostrap, jquery, devise, carrierwave and direct to S3 image uploads."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
