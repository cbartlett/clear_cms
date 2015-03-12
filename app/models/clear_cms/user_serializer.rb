module ClearCMS
  class UserSerializer < ActiveModel::Serializer
    attributes *(User.fields.collect {|k,v| k} - ['id'])

  end
end