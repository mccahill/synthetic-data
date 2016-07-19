class VerifyJobsController < ApplicationController
 
  before_filter :authorize
  
  layout "home"
  
  def index
    @user = User.find_by_netid session[:user_id]
  end
  
  # GET /stream_residual_png?the_opaque_job_id=953170ab-d039-42e2-bf48-aaaa94f72b5a
  def stream_residual_png
    opaque_job_id = params[:the_opaque_job_id]
    the_job = RemoteJob.find_by_opaque_id( opaque_job_id )
    unless the_job.nil?
      a_file = the_job.uploadfile.url
      unless a_file.nil?
        # stream a file to the client with default type of application/octet-stream
        file_contents = File.read(a_file)
        send_data file_contents, :disposition => 'inline', :filename => "#{opaque_job_id}-residuals.png" 
      end
    end 
  end
  
  
end
