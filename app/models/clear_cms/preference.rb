module ClearCMS
  class Preference
    include Mongoid::Document
    include Mongoid::Timestamps
    
    embedded_in :user, :class_name=>'ClearCMS::Preference'
    belongs_to :site, :class_name=>'ClearCMS::Site'
    
    field :notifications
      
  end
end