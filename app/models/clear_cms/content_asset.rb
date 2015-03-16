class ClearCMS::ContentAsset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  include Mongoid::EmberData

  #before_save :output_contents
  #before_create :append_site_to_path

  #after_initialize :generate_path
  PLACEMENTS=['Feature','Primary','Secondary']

  embedded_in :content_block, class_name: 'ClearCMS::ContentBlock'
  #embedded_in :content_assetable, polymorphic: true

  mount_uploader :mounted_file, ClearCMS::Uploaders::ContentAssetUploader, :mount_on => :file

  field :path
  field :caption
  field :order, type: Integer #using order of first to show as default image
  field :title
  field :description
  field :credit
  field :placement
  field :file
  field :width, type: Integer
  field :height, type: Integer

  field :source_id
  field :tags, type: Array

  default_scope ->{asc(:order)}

  scope :gallery_assets, ->{self.in(:tags=>"gallery")}

  track_history :track_update => true, :track_create => true, :track_destroy => true, :modifier_field => :modifier, :modifier_field_inverse_of => :nil, :scope => :clear_cms_content

#   def remote_file_url(url)
#     self.file.store_dir=File.dirname(url)
#     super(url)
#   end
#   def path_prefix
#     site=self.content_block.content.site
#     if site
#       site.slug
#     end
#   end

  def tags=(tag_list)
    self[:tags] = (tag_list.kind_of?(String) ? tag_list.gsub(/[^a-zA-Z,\-_\ ]/,'').split(',').collect {|s| s.strip} : tag_list)
  end


  def path
    self[:path].blank? ? nil : self[:path]
  end

  def path=(path)
    self.content_block && self.content_block.content && site=self.content_block.content.site
    if site
      self[:path]=path.start_with?(site.slug) ? path : File.join(site.slug,path)
    else
      self[:path]=path
    end
    self[:path]
  end


#   def remote_file_url=(url)
#     #binding.pry
#     #path=File.dirname(URI.parse(url).path)[1..-1]
#     super(url)
#   end

private

#   def generate_path
#     logger.debug self.path=Time.now.strftime('%Y/%m/%d')
#   end

#   def output_contents
#     logger.info self.inspect
#   end
#
#   def append_site_to_path
#     self.content_block && self.content_block.content && site=self.content_block.content.site
#     if site
#       #logger.info "string #{site.slug}, #{path}"
#       path=File.join(site.slug,(path||'content_assets'))
#     end
#   end

end
