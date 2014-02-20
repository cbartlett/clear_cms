require 'carrierwave/processing/mime_types'

class ClearCMS::Uploaders::ContentAssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  #include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  attr_accessor :store_dir

  attr_accessor :override_path
  #TODO: This should not be a class variable
  @@override_path


  storage :fog
  process :set_content_type


  def override_path=(path)
    @@override_path=path
  end

  def override_path
    @@override_path
  end

  version :large do
    process :convert => 'jpg'
    process :resize_to_fit => [1600,1600]
  end

  version :thumb, :from_version => :large do
    process :resize_to_fill => [200,200]
  end

  def thumbnail #alias for thumb
    thumb
  end


  #half w307 full w620
  #slideshow 930x690 or 620x460
  #feature 300x300 (uploading to square, cropped to sq otherwise)
  #listview 150x150
  #pager 140x140

  def only_first_frame
    manipulate! do |img|
      if img.mime_type.match /gif/
        if img.scene == 0
          img = img.cur_image #Magick::ImageList.new( img.base_filename )[0]
          else
            img = nil # avoid concat all frames
        end
      end
      img
    end
  end

  # Hacked from File lib/carrierwave/processing/mini_magick.rb, line 180
  def resize_to_fill_with_quality(width, height, quality, gravity = 'Center')
    manipulate! do |img|
      cols, rows = img[:dimensions]
      img.combine_options do |cmd|
        if width != cols || height != rows
          scale = [width/cols.to_f, height/rows.to_f].max
          cols = (scale * (cols + 0.5)).round
          rows = (scale * (rows + 0.5)).round
          cmd.resize "#{cols}x#{rows}"
        end
        cmd.gravity gravity
        cmd.extent "#{width}x#{height}" if cols != width || rows != height

        # Added by CC
        cmd.strip
        cmd.quality quality
      end
      img = yield(img) if block_given?
      img
    end
  end

  def resize_to_fit_with_quality(width, height, quality)
    manipulate! do |img|
      img.combine_options do |cmd|
        cmd.resize "#{width}x#{height}"

        # Added by CC
        cmd.strip
        cmd.quality quality
      end
      img = yield(img) if block_given?
      img
    end
  end

  def remove!
    #do nothing, prefer to have images remain on S3 even during destroy callbacks
  end


  def store_dir
    if self.model
      self.model.respond_to?(:path) && !self.model.path.nil? ? self.model.path : super
    elsif self.override_path
      self.override_path
    else
      super
    end
  end

  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # version list for CMS UI, allows for easy decoration in local app
  def self.version_list
    list = []
    versions.each do |version,i|
      list.push({:prefix => version[0], :label => version[0], :default => (i == 0 ? true : false) });
    end
    list
  end
end
