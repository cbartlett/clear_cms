module ClearCMS
  class ContentNote
    include Mongoid::Document
    include Mongoid::Timestamps
    
    embedded_in :content, class_name: 'ClearCMS::Content'
    belongs_to :user, class_name: 'ClearCMS::User'
    
    field :entry
      
  end
end