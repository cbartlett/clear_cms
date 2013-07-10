require 'devise'
require 'devise-encryptable'
require 'carrierwave'
require 'carrierwave/mongoid'
require 'sunspot'
require 'kaminari'
require 'cancan'
require 'delayed_job_mongoid'

module ClearCMS
  class Engine < ::Rails::Engine
    isolate_namespace ClearCMS
  end
end
