class VerifyJobsController < ApplicationController
 
  before_filter :authorize
  
  layout "home"
  
  def index
    @user = User.find_by_netid session[:user_id]
    docker_container = ShinyDocker.find_by_netid session[:user_id]
    if !(docker_container.nil?)
      user_job_submit_token = docker_container.job_submit_token
      @jobs_for_this_user = RemoteJob.find_all_by_job_submit_token( user_job_submit_token )
      render
    end
  end
  
  # GET /stream_verification_residual_png?the_opaque_job_id=953170ab-d039-42e2-bf48-aaaa94f72b5a
  def stream_verification_residual_png
    this_opaque_job_id = params[:the_opaque_job_id]
    the_job = RemoteJob.find_by_opaque_id( this_opaque_job_id )
    unless the_job.nil?
      a_file = the_job.verificationfile.url
      unless a_file.nil?
        # stream a file to the client with default type of application/octet-stream
        file_contents = File.read(a_file)
        send_data file_contents, :disposition => 'inline', :filename => "#{this_opaque_job_id}-verification-residuals.png" 
      end
    end 
  end

  # GET /stream_synthetic_residual_png?the_opaque_job_id=953170ab-d039-42e2-bf48-aaaa94f72b5a
  def stream_synthetic_residual_png
    this_opaque_job_id = params[:the_opaque_job_id]
    the_job = RemoteJob.find_by_opaque_id( this_opaque_job_id )
    unless the_job.nil?
      a_file = the_job.syntheticfile.url
      unless a_file.nil?
        # stream a file to the client with default type of application/octet-stream
        file_contents = File.read(a_file)
        send_data file_contents, :disposition => 'inline', :filename => "#{this_opaque_job_id}-synthetic-residuals.png" 
      end
    end 
  end
  
  
end
