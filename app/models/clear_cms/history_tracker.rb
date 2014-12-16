module ClearCMS
  class HistoryTracker
    include Mongoid::History::Tracker

    def undo_or_redo(change)
      if change.downcase == 'undo'
        self.undo! #current_user
      elsif change.downcase == 'redo'
        self.redo! #current_user
      else
        flash.now[:notice]='Error Undoing or Redoing'
      end
    end

  end
end
