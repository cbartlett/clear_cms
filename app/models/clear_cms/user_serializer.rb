module ClearCMS
  class UserSerializer < ActiveModel::Serializer
    attributes *User.fields.collect {|k,v| k}

        
  end
end