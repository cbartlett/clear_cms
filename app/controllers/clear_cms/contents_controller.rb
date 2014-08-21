module ClearCMS
  class ContentsController < ClearCMS::ApplicationController
    require 'mail'
    #require 'mongoid'
    before_filter :authenticate_user!, :except=>[:email] 
    skip_before_filter :verify_authenticity_token, :only=>[:email]
    
    load_and_authorize_resource :class=>'ClearCMS::Content', :except=>[:email]
    

   
    def index
      
      types=[]
    
      if params[:filter]
        params[:filter][:types].present? ? types=params[:filter][:types].split(',').collect{|t| /^#{t}$/i } : ''
      end
      
      
      if params[:q]
        @clear_cms_contents=current_site.contents.includes(:site).search {
              fulltext params[:q]
              paginate page: params[:page]
              with :site_id, current_site.id
              with :_type, params[:filter][:types] if params[:filter] && !params[:filter][:types].blank? 
            }.results
      elsif types.any?
        @clear_cms_contents=current_site.contents.includes(:site).where(:_type.in=>types).desc(:created_at).page(params[:page])
      else
        #@clear_cms_contents=current_site.contents.where("content_blocks.body"=>/#{Regexp.escape(params[:search]||'')}/i).desc(:updated_at).page(params[:page])
        @clear_cms_contents=current_site.contents.includes(:site).desc(:publish_at).page(params[:page])
      end

      respond_to do |format|
        format.html
        format.json { render json: @clear_cms_contents }
      end
    end
    
    def show
      @content=Content.find(params[:id])
    end

    def new
      @clear_cms_content = current_site.contents.build
#       @clear_cms_content.content_notes.build
#       @clear_cms_content.content_blocks.build
      @clear_cms_content.source='web'
      #@clear_cms_content.linked_contents.build
      @clear_cms_content.content_blocks.build(:type=>'raw')
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @clear_cms_content }
      end
    end    
       
    def edit
      @clear_cms_content=Content.find(params[:id]) #.becomes(Content)
      # @clear_cms_content.content_notes.build
#       @clear_cms_content.content_notes.build
#       @clear_cms_content.content_blocks.build
    end
    
    def update 
      @clear_cms_content=Content.find(params[:id])

      #@clear_cms_content.assign_attributes(params[:content])
      
      @clear_cms_content.content_logs.build(:user=>current_user, :entry=>"edited")

      #@clear_cms_content=@clear_cms_content.becomes(params[:content]['_type'].constantize)
      #@clear_cms_content.flag_children_persisted #TODO: this is due to a bug in mongoid where it is duplicating > 2nd tier children

      #@clear_cms_content._type=params[:content].delete '_type' 

      #TODO: NOTE: not able to use becomes at the moment, too many bugs, was trying to hack mongoid because it's duplicating 2nd-tier documents, but trying to mark the documents all as new_record=new_record? 
      #of the parent (basically to false) is causing update attributes to not work correctly.  trying to work around that by assigning_attributes and then using becomes was throwing all kinds of weird callback
      # errors and document find issues related to callbacks and mongoid thinking the state of these embedded relationships were already persisted...so, i'm going to override the _type manually on updating
      # using with_protection and move on.  Generally speaking, this means we can't use any special subclass of Content functions or validations until it's fixed (and that the validations WILL run for the previous type)
      # since it's instantiated as that by Mongoid BEWARE****
      
      #if @clear_cms_content.save
      if @clear_cms_content.update_attributes(params[:content].permit!)
        redirect_to({:action=>:edit}, notice: 'Content was successfully updated.')
      else
        flash.now[:notice]='Error saving content!'
        render :action=>:edit
      end           
    end


    def create
      @clear_cms_content = params[:content]['_type'].constantize.new(params[:content].permit!)
      #@clear_cms_content = Content.new(params[:content])
      @clear_cms_content.content_logs.build(:user=>current_user, :entry=>"created")
  
      respond_to do |format|
        if @clear_cms_content.save
          format.html { 
            redirect_to(clear_cms.edit_site_content_path(@clear_cms_content.site_id,@clear_cms_content.id), notice: 'Content was successfully created.')
          }
          format.json { render json: @clear_cms_content, status: :created, location: clear_cms.content_path(@clear_cms_content)}
        else
          format.html {
              flash.now[:notice]='Error creating content!' 
              render action: "new" 
            }
          format.json { render json: @clear_cms_content.errors, status: :unprocessable_entity }
        end
      end
    end
    
    
    def import
      site=ClearCMS::Site.find(params[:site_import][:id])
      
      params[:import_content].each do |content_id|
        content=ClearCMS::Content.find(content_id[0])
        content=content.dup
        content.site=site
        content.save 
      end
      
      redirect_to({:action=>:index}, notice: 'Content imported successfully.')
    end
  

    def destroy
      @clear_cms_content = ClearCMS::Content.find(params[:id])
      
      @clear_cms_site = @clear_cms_content.site
      
  
      # respond_to do |format|
      #   format.html { redirect_to clear_cms.site_contents_path(@clear_cms_site), notice: "Successfully deleted content." }
      #   format.json { head :ok }
      # end
  
      if @clear_cms_content.destroy
        redirect_to(clear_cms.site_contents_path(@clear_cms_site), notice: "Successfully deleted content.")
      else
        flash.now[:notice]='Error deleting content!'
        render :action=>:edit
      end  

    end

    
    def email
  #       message = Mail.new(params[:message])
  #       Rails.logger.log message.subject #print the subject to the logs
  #       Rails.logger.log message.body.decoded #print the decoded body to the logs
  #       Rails.logger.log message.attachments.first.inspect #inspect the first attachment
  #   
  #       # Do some other stuff with the mail message
  
      c=ClearCMS::Content.new       
      c.title=params[:subject]
      c.source=params[:from]
      c.content_notes.build(:entry=>params[:plain])
      c.save 
  
      render :text => 'success', :status => 200 # a status of 404 would reject the mail      
    end
  
  end
end

