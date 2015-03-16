module ClearCMS
  class Preference
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::EmberData
    
    embedded_in :user, :class_name=>'ClearCMS::Preference'
    belongs_to :site, :class_name=>'ClearCMS::Site'
    
    field :notifications
      
  end
end