# config/initializers/mongoid-history.rb
# initializer for mongoid-history
# assuming HistoryTracker is your tracker class
Mongoid::History.tracker_class_name = 'ClearCMS::HistoryTracker'
#Mongoid::History.modifier_class_name = 'ClearCMS::User'
