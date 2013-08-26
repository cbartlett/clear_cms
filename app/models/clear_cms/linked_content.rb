class ClearCMS::LinkedContent
  include Mongoid::Document
  #include Mongoid::Timestamps
    
  embedded_in :content, class_name: 'ClearCMS::Content', inverse_of: :linked_contents

  #has_one :linked_content, class_name: 'ClearCMS::Content'
  
  field :linked_content_id
  field :order

  validates_presence_of :linked_content_id
  
  def linked_content
    ClearCMS::Content.find(linked_content_id)
  end

end