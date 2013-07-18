module ClearCMS
  class ApplicationController < ActionController::Base

    protect_from_forgery

    def default_url_options
      {host: ClearCMS.config.default_host }
    end
    
    layout 'clear_cms/application'
    
    helper_method :current_site
    #helper 'clear_cms/upload'
    
    #before_filter :check_permissions


    rescue_from CanCan::AccessDenied do |exception|
      #Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      if current_user
        redirect_to [:edit,current_user], :alert => exception.message
      else
        session['user_return_to'] = request.original_fullpath
        redirect_to new_user_session_url#, :alert => exception.message
      end
    end



    private   
      def detect_layout
        return params[:layout] if params[:layout]
        
        case controller_name
        when 'frontend'
          'frontend'
        else
          'clear_cms/application'
        end
      end
    
  #   def check_permissions
  #     if current_user && current_user.permissions.empty?
  #       redirect_to no_permissions_clear_cms_users_path, :notice=>"You don't have any permissions set in the CMS."
  #     end
  #   end


    def after_sign_out_path_for(user)
      '/clear_cms'
    end
    
    def after_sign_in_path_for(user)
      # super.after_sign_in_path_for(user)
      '/clear_cms/sites'
    end
    
    
    def current_site
      set_site
    end
    
    def set_site
      return @current_site if @current_site
      
      case 
      when params[:site_id]
        session[:site_id]
        @current_site = ClearCMS::Site.find(params[:site_id])
      when session[:site_id]
        @current_site = ClearCMS::Site.find(session[:site_id])
      when current_user && current_user.default_site
        @current_site = current_user.default_site 
      else
        @current_site = ClearCMS::Site.first             
      end
      
      @current_site
    end
  
  end
end