module ClearCMS
  module Devise

    class FailureApp < ::Devise::FailureApp

      #include ::ClearCMS::Engine.routes.url_helpers

      def redirect_url
        '/'
      end

    end

  end
end