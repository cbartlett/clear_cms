module ClearCMS
  class UserSerializer < ActiveModel::Serializer
    attributes *(User.fields.collect {|k,v| k} - ['id'])

    attributes :readonly_attributes

    def readonly_attributes
      object.mounted_avatar
    end
  end
end