module ClearCMS
  class ContentSerializer < ActiveModel::Serializer
    attributes *Content.fields.collect {|k,v| k}
    attributes :_type
    has_many :content_blocks, serializer: ContentBlockSerializer

  end
end
