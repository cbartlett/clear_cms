module ClearCMS
  class PasswordsController < ::Devise::PasswordsController

    protected

    def after_sending_reset_password_instructions_path_for(resource_name)
      clear_cms.new_account_session_path
    end

  end
end