class RemoteJob < ActiveRecord::Base
  attr_accessible :completeted, :epsilon, :model, :output_unit, :submitted, :uploadfile, :opaque_id, :job_submit_token
  
  mount_uploader :uploadfile, UploadfileUploader
  
end
