module ClearCMS
  class ContentBlockSerializer < ActiveModel::Serializer
    attributes *ContentBlock.fields.collect {|k,v| k}

    has_many :content_assets, serializer: ContentAssetSerializer

  end
end
