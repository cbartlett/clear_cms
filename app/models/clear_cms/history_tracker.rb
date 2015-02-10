module ClearCMS
  class HistoryTracker
    include Mongoid::History::Tracker
    include Mongoid::Userstamp

    mongoid_userstamp user_model: 'ClearCMS::User', created_name: :modifier, updated_name: :modifier

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
