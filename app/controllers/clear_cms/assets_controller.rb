module ClearCMS
  class AssetsController < ApplicationController

    before_filter :authenticate_user!
    skip_before_filter :verify_authenticity_token, :only=>[:email]
    
    load_and_authorize_resource :class=>'ClearCMS::Asset'


    def create
      @clear_cms_site = ClearCMS::Site.find(params[:site_id])
      
      if params[:asset][:image_url]
        @clear_cms_asset = ClearCMS::Asset.new(:original_file_url=>params[:asset][:image_url],:path=>File.join([@clear_cms_site.slug,Time.now.strftime('%Y/%m/%d')]))
      else
        @clear_cms_asset = ClearCMS::Asset.new(:file=>params[:files][0],:path=>File.join([@clear_cms_site.slug,Time.now.strftime('%Y/%m/%d')]))
      end
      #@clear_cms_content_asset.content_logs.build(:user=>current_user, :entry=>"created")
  
      respond_to do |format|
        if @clear_cms_asset.save
          if params[:asset][:image_url]
            format.json {render json: @clear_cms_asset, status: :created, location: clear_cms_site_asset_url(@clear_cms_site,@clear_cms_asset) }
          else
          #format.html { redirect_to([:edit, @clear_cms_content], notice: 'Content was successfully created.')}
            format.json { render json: "{\"files\": [#{@clear_cms_asset.uploader_json}]}", status: :created, location: clear_cms_site_asset_url(@clear_cms_site,@clear_cms_asset)}
          end
        else
          #format.html { render action: "new" }
          format.json { render json: @clear_cms_asset.errors, status: :unprocessable_entity }
        end
      end
    end
    
    
    def show
      @clear_cms_asset=ClearCMS::Asset.find(params[:id])
      respond_to do |format|
        format.json { render json: @clear_cms_asset}
      end
    end
    
    
    def resize
      
    
    end    


# {"files": [
#   {
#     "name": "picture1.jpg",
#     "size": 902604,
#     "url": "http:\/\/example.org\/files\/picture1.jpg",
#     "thumbnail_url": "http:\/\/example.org\/files\/thumbnail\/picture1.jpg",
#     "delete_url": "http:\/\/example.org\/files\/picture1.jpg",
#     "delete_type": "DELETE"
#   },
#   {
#     "name": "picture2.jpg",
#     "size": 841946,
#     "url": "http:\/\/example.org\/files\/picture2.jpg",
#     "thumbnail_url": "http:\/\/example.org\/files\/thumbnail\/picture2.jpg",
#     "delete_url": "http:\/\/example.org\/files\/picture2.jpg",
#     "delete_type": "DELETE"
#   }
# ]}




   
#     def index
#       if params[:q]
#         @clear_cms_contents=current_site.contents.includes(:site).search {fulltext params[:q]; paginate page: params[:page]; with :site_id, current_site.id}.results
#       else
#         #@clear_cms_contents=current_site.contents.where("content_blocks.body"=>/#{Regexp.escape(params[:search]||'')}/i).desc(:updated_at).page(params[:page])
#         @clear_cms_contents=current_site.contents.includes(:site).desc(:updated_at).page(params[:page])
#       end
#     end
#     
#     def show
#       @content=Content.find(params[:id])
#     end
# 
#     def new
#       @clear_cms_content = ClearCMS::Content.new
# #       @clear_cms_content.content_notes.build
# #       @clear_cms_content.content_blocks.build
#       @clear_cms_content.source='web'
#       @clear_cms_content.content_blocks.build
#   
#       respond_to do |format|
#         format.html # new.html.erb
#         format.json { render json: @clear_cms_content }
#       end
#     end    
#        
#     def edit
#       @clear_cms_content=Content.find(params[:id])
#       # @clear_cms_content.content_notes.build
# #       @clear_cms_content.content_notes.build
# #       @clear_cms_content.content_blocks.build
#     end
#     
#     def update 
#       @clear_cms_content=Content.find(params[:id])
#       
#       @clear_cms_content.content_logs.build(:user=>current_user, :entry=>"edited")
#       
#       if @clear_cms_content.update_attributes(params[:clear_cms_content])
#         redirect_to({:action=>:edit}, notice: 'Content was successfully updated.')
#       else
#         flash.now[:notice]='Error saving content!'
#         render :action=>:edit
#       end           
#     end



  end
end

