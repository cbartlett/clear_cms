module ClearCMS
  class NotificationMailer < ActionMailer::Base

    default :from=>'cms@captainlucas.com'
  
    def generic_content_notification(user,content,subject,message)
      @content=content 
      @user=user
      @message=message
      mail(:to=>@user['email'],:subject=>subject)    
    end
    
  end
end