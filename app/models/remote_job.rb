class RemoteJob < ActiveRecord::Base
  attr_accessible :completeted, :epsilon, :model, :output_unit, :submitted, :verificationfile, :opaque_id, :job_submit_token
  
  mount_uploader :verificationfile, VerificationfileUploader
  
end
