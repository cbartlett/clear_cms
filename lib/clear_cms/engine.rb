require 'devise'
require 'devise-encryptable'
require 'carrierwave'
require 'carrierwave/mongoid'
require 'sunspot'
require 'kaminari'

module ClearCMS
  class Engine < ::Rails::Engine
    isolate_namespace ClearCMS
  end
end
