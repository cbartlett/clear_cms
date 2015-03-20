require 'devise'
#require 'devise-encryptable'
require 'carrierwave'
require 'carrierwave/mongoid'
require 'sunspot'
require 'sunspot/mongoid'
#require 'sunspot_solr'
#require 'sunspot/solr/tasks'
require 'kaminari'
require 'cancan'
#require 'delayed_job_mongoid'
require 'twitter-bootstrap-rails'
require 'sass-rails'
require 'coffee-rails'
require 'less-rails'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'formtastic'
require 'formtastic-bootstrap'
#require 'formtastic-plus-bootstrap'
require 'jquery-fileupload-rails'
require 'nested_form'
require 'kaminari-bootstrap'
require 'htmlentities'
require 'tagmanager-rails'
require 'markitup-rails'
require 'sidekiq'
#require 'kiqstand'
require 'compass-rails'
require 'mongoid-history'
require 'mongoid_userstamp'
require 'ember-rails'
require 'responders'
require 'mongoid'
require 'faye/websocket'
require 'clear_cms/middleware/pub_sub'


module ClearCMS
  class Engine < ::Rails::Engine
    isolate_namespace ClearCMS
    
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
 	  
    config.assets.paths << File.join("#{config.root}", 'app', 'assets', 'bower_components')

    def self.activate
	    Dir.glob(File.join(Rails.application.root, "app/**/*_decorator*.rb")) do |c|
	      Rails.configuration.cache_classes ? require(c) : load(c)
	    end
  	end

    #config.autoload_paths += Dir["#{config.root}/app/serializers/**/"]

    config.to_prepare &method(:activate).to_proc


    initializer 'clear_cms.setup_middleware' do |app|
      app.middleware.use ClearCMS::Middleware::PubSub
    end


  end
end
