module ClearCMS
  class Site
    include Mongoid::Document
    #include Mongoid::Versioning
    # keep at most 5 versions of a record
    #max_versions 5

    after_destroy :remove_permissions


    has_many :contents, class_name: 'ClearCMS::Content', :inverse_of => :site #, :dependent => :destroy

    field :name
    field :domain
    field :slug
    field :keywords
    field :description
    field :language

    field :source_id
    field :source_attributes, type: Hash

    validates_presence_of :name

    validates_presence_of :slug
    validates_uniqueness_of :slug

    validates_presence_of :domain
    validates_uniqueness_of :domain


    def self.content_columns
      fields.collect {|f| f[1]}
    end

    def categories
      ClearCMS::Content.collection.aggregate([
        {"$match" => {"site_id" => self.id}},
        {"$unwind" => "$categories"},
        {"$group" => {_id: "$categories", :count => {"$sum" => 1}}},
        {"$sort" => {_id: 1}}])
    end

private

    def remove_permissions
      ClearCMS::User.where('permissions.site_id'=>self.id).each do |u|
        u.permissions.where(:site_id=>self.id).destroy_all
      end
    end


  end
end
