class RemoteJob < ActiveRecord::Base
  attr_accessible :completeted, :epsilon, :model, :output_unit, :submitted, :syntheticfile, :verificationfile, :opaque_id, :job_submit_token
  
  mount_uploader :verificationfile, VerificationfileUploader
  mount_uploader :syntheticfile, SyntheticfileUploader
  
end
