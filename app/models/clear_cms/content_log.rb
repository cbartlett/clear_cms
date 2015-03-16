module ClearCMS
  class ContentLog
    include Mongoid::Document
    include Mongoid::Timestamps

    include Mongoid::EmberData
    
    embedded_in :content, class_name: 'ClearCMS::Content'
    belongs_to :user, class_name: 'ClearCMS::User'
    
    field :entry
      
  end
end