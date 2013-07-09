module ClearCMS
  class ContentObserver < Mongoid::Observer
     
    def after_rollback(model)
  
    end
    
    def after_save(model)
      if model.assignee_id && model.assignee_id_changed?
        ClearCMS::NotificationMailer.generic_content_notification(model.assignee, model, "New Content Assigned","You've been assigned to content:").deliver
      end
    end
    
  end
end