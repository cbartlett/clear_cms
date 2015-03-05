module ClearCMS
  class Site
    include Mongoid::Document
    #include Mongoid::Versioning
    # keep at most 5 versions of a record
    #max_versions 5
    
    include_root_in_json=true

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
      map = %Q{
        function() {
           exclude_categories=/(view_by|[0-9])/i;
           for (var idx = 0; idx < this.categories.length; idx++) {
               var key = this.categories[idx];
               if(!(exclude_categories.test(key))) {
                emit(key, {count: 1});
               }
           }
        }
      }
      
      reduce = %Q{
        function(key, values) {
          var result = { count: 0 };
          values.forEach(function(value) {
            result.count += value.count;
          });
          return result;
        }
      }

      contents.count > 1 ? contents.map_reduce(map,reduce).out(inline:true) : []
    end

private 

    def remove_permissions
      ClearCMS::User.where('permissions.site_id'=>self.id).each do |u|
        u.permissions.where(:site_id=>self.id).destroy_all
      end
    end

      
  end
end