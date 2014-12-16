module ClearCMS
  class HistoryTrackersController < ClearCMS::ApplicationController
    # layout 'clear_cms/application'
    # before_filter :authenticate_user!
    before_filter :authenticate_user!
    skip_before_filter :verify_authenticity_token, :only=>[:email]

    def index
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
      @tracker = ClearCMS::HistoryTracker.find(params[:id])
      @cms_content = ClearCMS::Content.find(@tracker.association_chain.last[:id])
      @tracker.undo_or_redo(params[:change])
      redirect_to clear_cms.content_history_trackers_path(@cms_content)
    end

  end
end
