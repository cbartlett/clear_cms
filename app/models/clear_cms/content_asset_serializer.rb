module ClearCMS
  class ContentAssetSerializer < ActiveModel::Serializer
    attributes *ContentAsset.fields.collect {|k,v| k}

    attributes :readonly_attributes

    def readonly_attributes
      object.mounted_file
    end

  end
end