# encoding: utf-8

class UserIconUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process :crop

  version :gray do
    process :convert_to_grayscale
  end

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private
  def crop
    crop_x = model.image_x.to_i
    crop_y = model.image_y.to_i
    crop_w = model.image_w.to_i
    crop_h = model.image_h.to_i
    return if !([crop_x, crop_y, crop_w, crop_h].all?)
    manipulate! do |img|
      img.crop "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
      img = yield(img) if block_given?
      img
    end
  end


  def convert_to_grayscale
    manipulate! do |img|
      img.colorspace("Gray")
      img = yield(img) if block_given?
      img
    end
  end

end
