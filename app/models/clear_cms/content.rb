module ClearCMS
  class Content 
    include Mongoid::Document
    include Mongoid::Versioning
    # keep at most 5 versions of a record
    max_versions 20
    include Mongoid::Timestamps

    #@@form_fields = {}
    cattr_accessor :form_fields do 
      {}
    end
    #include SitemapNotifier::ActiveRecord #TODO: submit a PR for a better way to do this for mongoid
    

    def self.form_field(field_name, options={})
      self.form_fields ||= {}  
      self.form_fields[field_name] ||= {:models=>[],:formtastic_options=>{}}
      
      formtastic_options=options.delete(:formtastic_options)||{}
      #options={}

      case self.name 
      when 'ClearCMS::Content'
        field field_name, options
      else
        self.superclass.field field_name
      end
      
      self.form_fields[field_name][:models] << self.name
      self.form_fields[field_name][:formtastic_options].merge!(formtastic_options)
    end


    STATUSES={'Draft'=>'1','Scheduled'=>'2', 'Review'=>'3', 'Published'=>'4'}
    #MT Has States of 1=Draft, 2=Scheduled, 3=Review, 4=Published
    
    STATES=%w(Assigned Entered First_Edit_Complete Second_Edit_Complete Finished Unpublished )
    #STATES=%w(Production 1st_Edit 2nd_Edit Published)

    
    #after_save :update_search_index #OLD FOR INDEXTANK
    before_save :set_publish_at
    after_save :schedule_cache_clear

    embeds_many :content_blocks, class_name: 'ClearCMS::ContentBlock', cascade_callbacks: true
    embeds_many :content_notes, class_name: 'ClearCMS::ContentNote', cascade_callbacks: true
    embeds_many :content_logs, class_name: 'ClearCMS::ContentLog', cascade_callbacks: true
    
    accepts_nested_attributes_for :content_blocks, :content_notes, :content_logs

    #attr_accessible :_type
  
    belongs_to :site, class_name: 'ClearCMS::Site', :inverse_of => :contents
    belongs_to :creator, class_name: 'ClearCMS::User', :inverse_of => :created_contents
    belongs_to :author, class_name: 'ClearCMS::User', :inverse_of => :authored_contents
    belongs_to :assignee, class_name: 'ClearCMS::User', :inverse_of => :assigned_contents
    
  #   has_many :translations, class_name: 'Content'
  #   belongs_to :original_translation, class_name: 'Content'
  
    has_many :translations, :class_name => 'ClearCMS::Content', :inverse_of => :original_translation
    belongs_to :original_translation, :class_name => 'ClearCMS::Content', :inverse_of => :translations
    
  
    #field :type  
    field :title
    field :subtitle
    field :basename
    field :language   
    
    field :status
    field :state

    field :tags, type: Array
    field :categories, type: Array

    field :publish_at, type: DateTime
    field :deadline_at, type: DateTime
    
    index({updated_at: -1})
    index({created_at: -1})
    index({publish_at: -1, '_id'=>-1})
    #index({publish_at: -1})
    
    validates_presence_of :title,:subtitle,:author,:basename,:tags,:categories,:site
    validates_uniqueness_of :basename, :scope=>:site_id
 
    scope :published, lambda{ all.or({:state.in => ['Finished']},{:status.in => [2,4]}).and({:publish_at.lte => Time.now}).desc(:publish_at) }
    scope :recently_published, ->(limit){ published.limit(limit) }
    scope :tagged, ->(tag){ tag_regex=Regexp.new("^(#{tag})$",Regexp::IGNORECASE); where(tags: tag_regex) }       
    
    include Sunspot::Mongoid
    
    searchable do
      text :title #, :boost => 500.0
      text :subtitle #, :boost => 50.0 
      text :tags #, :boost=>5.0
      text :categories #, :boost=>1.0
      text :content, :more_like_this => true do 
        content_blocks.map &:body
      end

      
      string :site_id
      string :status do 
        #status=''
        if state=='Finished' || status==2 || status==4
          'PUBLISHED'
        else
          'DRAFT'
        end
      end
      string :categories, :multiple=>true 
      string :_type
      time :publish_at
      time :created_at
      time :updated_at
    end
    
    def self.boosted_search(params)
      search do 
        fulltext params[:search] do 
          boost_fields :title => 500.0, :subtitle => 500.0
          #fields(:title,:subtitle,:tags)
        end        
        paginate page: params[:page]
        with :site_id, params[:site_id]
        with :status, 'PUBLISHED'
        with :categories, params[:category] if (params[:category] && params[:category] != 'any')
        with :_type, params[:type] if (params[:type] && params[:type] != 'any')
        with(:publish_at).less_than Time.now
        
        if params[:sort_by] == "date" 
          order_by :publish_at, :desc 
        else 
          order_by :score, :desc
          order_by :publish_at, :desc
        end
      end
    end
    
    
    def published?
      if state=='Finished' || status==2 || status==4
        true
      else
        false
      end      
    end
    
    def scheduled?
      published? && (publish_at > Time.now)
    end
    
    def numeric_id
      source_id.present? ? source_id : created_at.to_i
      #id.generation_time.to_i
    end
    
    # def safe_title
    #   self[:title].html_safe unless self[:title].blank?
    # end
    
    # def safe_subtitle
    #   self[:subtitle].html_safe unless self[:subtitle].blank?
    # end
    
    def related(limit=25)
      result = Sunspot.more_like_this(self) do
        fields :content
        minimum_term_frequency 5
        paginate per_page: limit
        with :site_id, self.site.id
        with :status, 'PUBLISHED'
        with(:publish_at).less_than Time.now     
      end
      result.results
    end
    
    def tags=(tag_list)
      self[:tags] = (tag_list.kind_of?(String) ? tag_list.gsub(/[^a-zA-Z,\-_\ ]/,'').split(',').collect {|s| s.strip} : tag_list)     
    end
    
    def categories=(category_list)
      self[:categories] = (category_list.kind_of?(String) ? category_list.gsub(/[^a-zA-Z,\-_\ ]/,'').split(',').collect {|s| s.strip; s.downcase} : category_list)
    end
    
    
    def next_state
      if self[:state].blank?
        STATES.first
      else
        index=STATES.index(self[:state])+1
        STATES[index].blank? ? STATES.last : STATES[index]
      end  
      #self[:state].blank? ? STATES[1] : STATES.last 
    end


    
    def next_content 
      #self
      @next_content ||= site.contents.published.where(:publish_at.gt => publish_at).asc(:publish_at).limit(1).first
    end
    
    def previous_content
      #self
      @previous_content ||= site.contents.published.where(:publish_at.lt => publish_at).limit(1).first 
    end



    def self.find_in_batches(opts = {})
      batch_size = opts[:batch_size] || 1000
      start = opts.delete(:start).to_i || 0
      objects = self.limit(batch_size).skip(start)
      t = Time.new
      while objects.any?
        yield objects
        start += batch_size
        # Rails.logger.debug("processed #{start} records in #{Time.new - t} seconds") if Rails.logger.debug?
        break if objects.size < batch_size
        objects = self.limit(batch_size).skip(start)
      end
    end    
         
         
private 

    def update_search_index
      if self.published?
        self.content_blocks.each do |block|
          Rails.logger.debug(self.id)
          INDEXTANK.document("#{self.id}").add({:text=>block.body,:timestamp=>self.created_at.to_i}) if INDEXTANK
        end
      end
    end
    
    def set_publish_at
#       if self[:state]=='Finished' && self[:publish_at].blank?
      self[:publish_at] ||= Time.now
    end
   
    def schedule_cache_clear
      if scheduled?
        puts "Scheduling a cache clear for #{title} at #{publish_at}"
        ClearCMS::ContentCache.delay_until(publish_at+1.minute).clear      
      end
    end
         
  end
  
  class ContentCache
    def self.clear
      puts "Clearing cache due to scheduled posting."
      Rails.cache.clear
    end
  end

end

#Testing this to see if we need to do it to get the classes to register for building forms in development where they are not eager loaded/and or while making changes to CMS code
#require_dependency File.join([Rails.application.root,'app/models/city'])


