# encoding: utf-8

class VerificationfileUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
      Rails.root.join('uploads', "#{model.class.to_s.underscore}", "#{mounted_as}", "#{model.id}" ).to_s
  end

  # also override where the temp/cache uploads are stored
  def cache_dir
    Rails.root.join('uploads', "#{model.class.to_s.underscore}-cache").to_s
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
  # we are assuming we get image files in png jpeg or jpg format
  def extension_white_list
     %w(png jpg jpeg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    # be very paranoid about filenames - anything that is not a word character is
    # first turned into a '.', and then we turn all '.' occurances into an underscore
     original_filename.gsub(/[^\w]/, '.').gsub(/[.]+/,'_') if original_filename
  end

end