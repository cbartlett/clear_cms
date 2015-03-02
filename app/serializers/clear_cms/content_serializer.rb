module ClearCMS
  class ContentSerializer < ActiveModel::Serializer
    attributes :_id, :title, :basename, :_type, :content_blocks

  end
end
