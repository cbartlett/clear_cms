module ClearCMS
  class ContentBlockSerializer < ActiveModel::Serializer
    attributes :id, :content_block_type
    # attribute :type, :key => :content_type

    def id
      object._id.to_s
    end

    def content_block_type
      object.type.to_s
    end

  end
end
