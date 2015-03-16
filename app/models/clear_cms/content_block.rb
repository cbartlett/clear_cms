class ClearCMS::ContentBlock
  include Mongoid::Document
  include Mongoid::Timestamps

  include Mongoid::History::Trackable

  include Mongoid::EmberData

  TYPES=%w(raw more sidebar)

  embedded_in :content, class_name: 'ClearCMS::Content'
  embeds_many :content_assets, class_name: 'ClearCMS::ContentAsset', cascade_callbacks: true

  accepts_nested_attributes_for :content_assets, :allow_destroy=>true
  # git test


  field :body
  field :type
  field :has_gallery, type: Boolean
  field :order, type: Integer

  default_scope ->{asc(:order)}

  track_history :track_create => true, :track_destroy => true, scope: :clear_cms_content, :modifier_field => :modifier, :modifier_field_inverse_of => :nil

  def body
    self[:body].html_safe unless self[:body].blank?
  end

  def body_excerpt
    body.blank? ? '' : body.split[0...50].join(" ").html_safe
  end

  def self.types
    TYPES
  end
end
