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
require 'formtastic-plus-bootstrap'
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


module ClearCMS
  class Engine < ::Rails::Engine
    isolate_namespace ClearCMS

 	def self.activate
	    Dir.glob(File.join(Rails.application.root, "app/**/*_decorator*.rb")) do |c|

	      Rails.configuration.cache_classes ? require(c) : load(c)
	    end
  	end

    config.to_prepare &method(:activate).to_proc

  end
end
