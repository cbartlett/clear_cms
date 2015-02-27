module ClearCMS
  class ContentSerializer < ActiveModel::Serializer
    attributes :_id, :title, :basename, :_type, :content_blocks

    def _id
      object._id.to_s
    end

  end
end
