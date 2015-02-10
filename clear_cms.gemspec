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

  s.add_dependency "rails", "~>4.2.0"

  #Redis caches/needed for sidekiq
  s.add_dependency "redis-rails"

  #Delayed jobs/workers
  #s.add_dependency "delayed_job_mongoid"
  s.add_dependency "sidekiq"

  s.add_dependency 'compass-rails'

  #Mongo DB ORM and support

  s.add_dependency "mongoid" #, "~>4.0.0", :git=>'git://github.com/mongoid/mongoid.git'
  #s.add_dependency "kiqstand" #handles connections for sidekiq
  s.add_dependency 'mongoid-history'
  s.add_dependency 'mongoid_userstamp' # needed for History Tracking


  #Authentication and Roles
  s.add_dependency 'devise'
  #s.add_dependency 'devise-encryptable'
  s.add_dependency 'cancan'

  #File upload and storage on S3
  s.add_dependency 'carrierwave'
  s.add_dependency 'carrierwave-mongoid' #, :git=>'git://github.com/jnicklas/carrierwave-mongoid.git', :branch => 'mongoid-3.0', :require => 'carrierwave/mongoid'
  s.add_dependency 'fog' #, '~>1.12.0'
  s.add_dependency 'net-scp' #, '1.0.4'
  s.add_dependency 'mini_magick'

  #Form Builder
  s.add_dependency 'formtastic' #, "~> 2.1.0"
  #s.add_dependency 'formtastic-plus-bootstrap'
  s.add_dependency 'formtastic-bootstrap' #, :git => 'https://github.com/niedfelj/formtastic-bootstrap.git', :branch => 'bootstrap2-rails3-2-formtastic-2-2' #, :require=>'formtastic-bootstrap'
  s.add_dependency 'nested_form' #, :git => 'git://github.com/niedfelj/nested_form.git', :branch=> 'formtastic_bootstrap'

  #Result pagination
  s.add_dependency 'kaminari' #, '~> 0.15.0'
  s.add_dependency 'kaminari-bootstrap'

  #Websolr search
  s.add_dependency 'sunspot_rails'
  #s.add_dependency 'sunspot_solr' #had to add this to the main app

  #Asset related gems
  #s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'jquery-fileupload-rails'
  s.add_dependency 'twitter-bootstrap-rails' #, '2.2.8'
  s.add_dependency 'sass-rails' #, '~> 3.2.3'
  s.add_dependency 'coffee-rails' #, '~> 3.2.1'
  s.add_dependency 'therubyracer' #, '0.10.2'
  s.add_dependency 'less-rails'
  s.add_dependency 'markitup-rails'
  s.add_dependency 'tagmanager-rails' #, '3.0.0.1'
  s.add_dependency 'ember-rails'
  s.add_dependency 'ember-source' #, '~> 1.9.0'


  #Utilities
  s.add_dependency "htmlentities"
  s.add_dependency "highline"

end
