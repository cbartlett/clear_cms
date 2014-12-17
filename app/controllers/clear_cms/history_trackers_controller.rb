module ClearCMS
  class HistoryTrackersController < ClearCMS::ApplicationController
    # layout 'clear_cms/application'
    # before_filter :authenticate_user!
    before_filter :authenticate_user!
    skip_before_filter :verify_authenticity_token, :only=>[:email]

    def index
      @user = current_user
      @content=Content.find(params[:content_id])
      @trackers = @content.history_tracks.sort_by(&:created_at).reverse!
    end

    def show
      @tracker = ClearCMS::HistoryTracker.find(params[:id])
    end

    def edit
      @trackers
    end

    def update
      @user = current_user
      @tracker = ClearCMS::HistoryTracker.find(params[:id])
      # @cms_content = ClearCMS::Content.find(@tracker.association_chain.last[:id])
      @tracker.undo_or_redo(params[:commit], @user)
      redirect_to :back
    end

  end
end
