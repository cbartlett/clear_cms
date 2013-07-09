# atom_feed do |content|
#   feed.title(content.site.name)
#   feed.updated(content.publish_at) 
#   feed.entry(content, published: content.publish_at, updated: (content.publish_at > content.updated_at ? content.publish_at : content.updated_at) ,url: "http://www.coolhunting.com#{content.friendly_url}") do |entry|
# 
#       entry.title(content.title)
# 
#       entry.content(content.default_content_block.body, :type => 'html')
# 
#       entry.author do |author|
#         author.name(content.author.full_name)
#       end
#     end
#   end
# end