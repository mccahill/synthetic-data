class RemoteJob < ActiveRecord::Base
  attr_accessible :completeted, :epsilon, :model, :output_unit, :submitted, :syntheticfile, :verificationfile, :opaque_id, :job_submit_token
  
  mount_uploader :verificationfile, VerificationfileUploader
  mount_uploader :syntheticfile, SyntheticfileUploader
  
  def synthetic_residual_image
		if self.syntheticfile.length > 0 then
      s = "<a href='/stream_synthetic_residual_png?the_opaque_job_id=#{self.opaque_id}' target='_blank'> 
			<img src='/stream_synthetic_residual_png?the_opaque_job_id=#{self.opaque_id}' style='width:304px;height:228px;'></a>"
      return s.html_safe
		else
		  return "-"
		end
  end
  
  def verification_residual_image
		if self.verificationfile.length > 0 then
      s = "<a href='/stream_verification_residual_png?the_opaque_job_id=#{self.opaque_id}' target='_blank'> 
			<img src='/stream_verification_residual_png?the_opaque_job_id=#{self.opaque_id}' style='width:304px;height:228px;'></a>"
      return s.html_safe
		else
		  return "-"
		end
    
  end
  
end
