class ClearCMS::Asset
  include Mongoid::Document

  #after_initialize :generate_path

  
  #before_save :output_contents
  #before_create :append_site_to_path   

  #embedded_in :content_block, class_name: 'ClearCMS::ContentBlock'

  mount_uploader :file, ClearCMS::Uploaders::ContentAssetUploader
  
  after_save :enqueue_processing
  
  field :path
  field :caption
  field :order, type: Integer
  field :title
  field :description
  field :credit
  field :file
  field :original_file_url
  field :processed_at, type: DateTime

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

  
#   def path 
# #     #debugger
# #     return nil if self[:path].blank?
# # 
# #     self.content_block && self.content_block.content && site=self.content_block.content.site      
# #     if site
# #       self[:path].start_with?(site.slug) ? self[:path] : File.join(site.slug,self[:path])
# #     else        
# #       self[:path]
# #     end
#   end
  
#   def remote_file_url=(url)
#     self[:path]=File.dirname(URI.parse(url).path)[1..-1]
#     super(url)
#   end
  
  def uploader_json
   json=%Q{  {
        "name": "#{file.file.filename}",
        "size": #{file.size},
        "url": "#{file.url}",
        "path": "#{path}",
        "thumbnail_url": "#{file.url}",
        "delete_url": "http:\/\/none",
        "delete_type": "DELETE"
      } 
    }
  end

  class ImageWorker
    include Sidekiq::Worker 
    
    def perform(id)
      asset = ::ClearCMS::Asset.find(id)
      asset.remote_file_url = asset.original_file_url
      asset.save!
      asset.update_attribute(:processed_at,Time.now)
    end
  end
  

private 


  def enqueue_processing
    if original_file_url_changed?
      ImageWorker.perform_async(id.to_s)    
    end
  end

#   def generate_path
#     self.path=Time.now.strftime('%Y/%m/%d')
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