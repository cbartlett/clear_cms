module ClearCMS
  class ContentSerializer < ActiveModel::Serializer
    attributes *Content.fields.collect {|k,v| k}
    attributes :_type
    attributes :content_blocks
  end
end
