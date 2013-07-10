require 'devise'
require 'devise-encryptable'
require 'carrierwave'
require 'carrierwave/mongoid'
require 'sunspot'
require 'sunspot/mongoid'
require 'kaminari'
require 'cancan'
require 'delayed_job_mongoid'
require 'twitter-bootstrap-rails'
require 'sass-rails'
require 'coffee-rails'
require 'less-rails'
require 'jquery-ui-rails'
require 'formtastic'
require 'formtastic-plus-bootstrap'
require 'jquery-fileupload-rails'
require 'nested_form'

module ClearCMS
  class Engine < ::Rails::Engine
    isolate_namespace ClearCMS
  end
end
