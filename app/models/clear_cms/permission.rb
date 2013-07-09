module ClearCMS
  class Permission
    include Mongoid::Document
    include Mongoid::Timestamps
    
    embedded_in :user, class_name: 'ClearCMS::User'
    belongs_to :site, class_name: 'ClearCMS::Site'
    
    validates :site, :presence=>true
    validates :role, :presence=>true
    validates :site_id, :uniqueness=>{:message=>' site role is already assigned.'}
    
    field :role

  end
end