module ClearCMS
  class NotificationMailer < ActionMailer::Base

    default :from=>ClearCMS.config.mailer_sender
  
    def generic_content_notification(user,content,subject,message)
      @content=content 
      @user=user
      @message=message
      mail(:to=>@user['email'],:subject=>subject)    
    end
    
  end
end