module ClearCMS
  class HistoryTracker
    include Mongoid::History::Tracker

    # belongs_to :modifier, class_name: 'ClearCMS::User'

    def undo_or_redo(change, user)
      if change.downcase == 'undo'
        self.undo! user
      elsif change.downcase == 'redo'
        self.redo! user
      else
        flash.now[:notice]='Error Undoing or Redoing'
      end
    end

  end
end
