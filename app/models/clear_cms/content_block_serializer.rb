# this is currently not getting used unless you redefine the content_blocks method in the content serializer


# module ClearCMS
#   class ContentBlockSerializer < ActiveModel::Serializer
#     attributes :_id
#     # attribute :type, :key => :content_type

#     def _id
#       object._id.to_s
#     end

#     # def content_block_type
#     #   # needed because Ember reserves 'type' property
#     #   object.type.to_s
#     # end

#   end
# end
