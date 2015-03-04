module ClearCMS
  class UserSerializer < ActiveModel::Serializer
    attributes :_id, :full_name
  end
end