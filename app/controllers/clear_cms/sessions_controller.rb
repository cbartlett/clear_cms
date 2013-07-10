module ClearCMS
  class SessionsController < ::Devise::SessionsController
    layout 'clear_cms/application'

    protected

    def after_sign_in_path_for(resource)
      users_url
    end

    def after_sign_out_path_for(resource)
      request.protocol + request.host_with_port
    end

    # def set_locale
    #   I18n.locale = current_site.accounts.first.locale
    # end

  end
end