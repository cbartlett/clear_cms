module ClearCMS
  class PasswordsController < ::Devise::PasswordsController
    layout 'clear_cms/application'

    protected

    def after_sending_reset_password_instructions_path_for(resource_name)
      clear_cms.new_user_session_path
    end

  end
end