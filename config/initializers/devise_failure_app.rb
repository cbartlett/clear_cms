module ClearCMS
  module Devise

    class FailureApp < ::Devise::FailureApp

      include ClearCMS::Engine.routes.url_helpers

      def redirect_url
        new_user_session_path
      end

    end

  end
end