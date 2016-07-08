class RemoteJob < ActiveRecord::Base
  attr_accessible :completeted, :epsilon, :model, :netid, :output_unit, :submitted, :uploadfile, :opaque_id
  
  mount_uploader :uploadfile, UploadfileUploader
  
end
