module ClearCMS
  class HistoryTracker
    include Mongoid::History::Tracker
  end
end