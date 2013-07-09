require 'carrierwave/processing/mime_types'

class ClearCMS::Uploaders::MtAssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick
  #include CarrierWave::RMagick

  attr_accessor :store_dir
  attr_accessor :append_path

  storage :fog
  process :set_content_type


  def store_dir
    "coolhunting/mt_asset_cache#{append_path}"
  end
  
  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end
end