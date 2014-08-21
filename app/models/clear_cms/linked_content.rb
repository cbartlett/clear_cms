class ClearCMS::LinkedContent
  include Mongoid::Document
  #include Mongoid::Timestamps
  validate :linked_content_exists

  embedded_in :content, class_name: 'ClearCMS::Content', inverse_of: :linked_contents

  #has_one :linked_content, class_name: 'ClearCMS::Content'
  
  field :linked_content_id
  field :order, type: Integer
  
  default_scope ->{asc(:order)}

  validates_presence_of :linked_content_id
  
  def linked_content
    ClearCMS::Content.find(linked_content_id)
  end

private 

  def linked_content_exists
    unless ClearCMS::Content.where(id: linked_content_id).exists?
      errors.add(:linked_content_id, 'must be a valid content id.')
    end
  end

end