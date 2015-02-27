module ClearCMS
  class ContentSerializer < ActiveModel::Serializer
    attributes :id, :title, :basename, :_type, :content_blocks
    # has_many :content_blocks, serializer: ClearCMS::ContentBlockSerializer

    def id
      object._id.to_s
    end

    # def content_blocks
    #   object.content_blocks.map do |content_block|
    #     ContentBlockSerializer.new(content_block, scope: scope, root: false)
    #   end
    # end

  end
end
