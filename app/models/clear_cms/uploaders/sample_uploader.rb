module SampleUploader
  def change_geometry(geometry)
    manipulate! do |img|
      img.change_geometry!(geometry){ |cols, rows, image|
        image.resize!(cols, rows)
      }
    end
  end

  def crop(x,y,width,height)
    manipulate! do |img|
      img.crop!(x,y,width,height)
    end
  end

  def crop_with_gravity(gravity,width,height)
    manipulate! do |img|
      img.crop!(gravity,width,height,true)
    end
  end

  def crop_with_repage(x,y,width,height)
    manipulate! do |img|
      img.crop!(x,y,width,height,true)
    end
  end

  def adaptive_sharpen(radius,sigma)
    manipulate! do |img|
      img.adaptive_sharpen(radius,sigma)
    end
  end

  # Rotates the image based on the EXIF Orientation
  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient!
      img = yield(img) if block_given?
      img
    end
  end

  # Strips out all embedded information from the image
  def strip
    manipulate! do |img|
      img.strip!
      img = yield(img) if block_given?
      img
    end
  end

  # Reduces the quality of the image to the percentage given
  def quality(percentage)
    manipulate! do |img|
      img.write(current_path){ self.quality = percentage }
      img = yield(img) if block_given?
      img
    end
  end

  def store_geometry
    if model
        img = ::Magick::Image::read(self.file.to_file).first
        model.file_properties.original_width = img.columns
        model.file_properties.original_height = img.rows
        model.file_properties.original_size = img.filesize
    end
  end
end




#   storage :fog
# 
#   process :set_sha1
#   process :store_geometry
# 
#   def extension_white_list
#     %w(jpg jpeg gif png)
#   end
# 
# 
#   version :large do #TODO: add :from_version=>:large to other versions to limit processing
#     # Imagemagick command:
#     # convert file.ext -resize '1600x1600>' -quality 85 -strip large.ext
#     process :change_geometry => '1600x1600>'
#     process :quality => 80
#     process :strip
#   end
# 
# 
#   version :thumb, :from_version => :large do
#     # Imagemagick command:
#     # convert file.ext -resize '150x150' -adaptive-sharpen '0x0.6' -quality 85 -strip thumbnail.ext
#     process :change_geometry => '150^'
#     process :crop_with_gravity => [Magick::CenterGravity, 150, 150]
#     process :adaptive_sharpen => [0,0.6]
#     process :quality => 75
#     process :strip
#   end
# 
#   def social
#     #returns thumb for now, they are the same size
#     thumb
#   end
# 
# #   version :social do
# #     # Imagemagick command:
# #     # convert file.ext -resize '150x150' -adaptive-sharpen '0x0.6' -quality 85 -strip social.ext
# #
# #   end
# 
# 
# #   version :small do
# #     process :resize_to_fit => [250, 250]
# #   end
# 
#   version :medium, :from_version => :large do
#     # Imagemagick command:
#     # convert file.ext -resize '250' -adaptive-sharpen '0x0.6' -quality 85 -strip medium.ext
#     process :change_geometry => '250'
#     process :adaptive_sharpen => [0,0.6]
#     process :quality => 75
#     process :strip
#   end
# 
# 
# 
#   version :cover, :from_version => :large do
#     # Imagemagick command:
#     # convert file.ext -resize '210x300^' -crop '180x270+15+15' -adaptive-sharpen '0x0.6' -quality 85 -strip cover.ext
#     process :change_geometry => '210x300^'
#     process :crop_with_repage => [15,15,180,270]
#     process :adaptive_sharpen => [0,0.6]
#     process :quality => 75
#     process :strip
#   end
# 
#   def remove!
#     #TODO do nothing…storing files using SHA1 would not allow us to remove them as they may be shared across media
#   end
# 
#   def store_dir
#     "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.file_sha1[0..1]}/#{model.file_sha1[2..3]}/#{model.file_sha1[4..-1]}"
#   end
# 
# 
#   #TODO should probably store files using the full SHA1 also, as to avoid duplicates or we
#   #will end up with the same files with different names in the SHA1 directory
# 
#   #TODO should make sha1 independent of processing because it isn't set for other versions they end up being small_.png etc
#   def filename
#     if original_filename.present?
#      #file_ext=file.content_type.match(/image\/([a-z]-)?(?<extension>[a-z]+)/)[:extension]
#      #file_ext = "jpg"
#      file_ext = File.extname original_filename
#      file_ext = (file_ext=='jpeg') ? 'jpg' : file_ext
#      @sha1_filename ||= "#{@sha1}.#{file_ext}"
#     end
#   end
# 
#   def full_filename(for_file)
#     if version_name.nil?
#       for_file
#     else
#       parent_file = super(for_file)
#       "#{version_name}_#{File.extname(parent_file)}"
#     end
#   end
# 
# 
#   def set_sha1(working_file=file)
# 
#     unless working_file.nil? || working_file.path.nil?
#       #puts working_file.path
#       @sha1 ||= Digest::SHA1.file(working_file.path)
#       model.file_sha1=@sha1.hexdigest
#     end
#   end
# 
# 
# 
# 
# 
# #   def default_url
# #     "/images/fallback/" + [version_name, "default.png"].compact.join('_')
# #   end
# 
# 
#   # Override the filename of the uploaded files:
#   # Avoid using model.id or version_name here, see uploader/store.rb for details.
#   # def filename
#   #   "something.jpg" if original_filename
#   # end
# 
# end


# :: MEDIUM
#
# - Sizing: Fit to 250px wide
# - Compression 85%
# - edge sharpening
# - strip headers
#
# NOTE: Medium is the size we will be loading on first page view of content the vast majority of the time
#
# Imagemagick command:
# convert file.ext -resize '250' -adaptive-sharpen '0x0.6' -quality 85 -strip medium.ext
#
#
# :: LARGE
#
# - No resizing, longest edge no bigger than 1600px
# - Compression 85%
# - No sharpening
# - strip headers
#
# Imagemagick command:
# convert file.ext -resize '1600x1600>' -quality 85 -strip large.ext
#
#
# :: COVER
#
# - resized to *fill* 210px wide x 300px tall
# - cropped to 180px wide x 270px tall
# - compression 85%
# - edge sharpening
# - strip headers
#
# NOTE: this is for automated center cropping of image, if we will be creating a UI to user select over images soon, we can skip this size for now, and use the MEDIUM in the code until that UI is available
# NOTE 2: I don't know if we
#
# Imagemagick command:
# convert file.ext -resize '210x300^' -crop '180x270+15+15' -adaptive-sharpen '0x0.6' -quality 85 -strip cover.ext
#
#
#
# :: THUMBNAIL
#
# - Sizing: Fit to 150px on longest edge
# - Compression 85%
# - edge sharpening
# - strip headers
#
# NOTE: Currently not using the "Thumbnail" version at any point on the site, though we could use the Thumbnail to double as the social version below.
#
# Imagemagick command:
# convert file.ext -resize '150x150' -adaptive-sharpen '0x0.6' -quality 85 -strip thumbnail.ext
#
#
#
#
# :: SOCIAL
#
# - Sizing: Fit to 150px on longest edge
# - Compression 85%
# - edge sharpening
# - strip headers
#
# NOTE: We could use a small image to be optimized for social media sharing (facebook, G+)
#
# Imagemagick command:
# convert file.ext -resize '150x150' -adaptive-sharpen '0x0.6' -quality 85 -strip social.ext

