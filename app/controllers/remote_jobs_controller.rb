class RemoteJobsController < ApplicationController

  require 'securerandom'
  
  ##############
  # Generally we assume that apps will be programatically posting files here
  # instead of users visiting the web pages, so this is mostly a REST-style interface
  # You can validate that this works via CURL commands.
  #
  # The Shiny docker containers submit jobs for remote processing like this:
  #
  #    curl -X POST \
  #         -H "Content-Type: multipart/form-data" \
  #         -H "Accept: application/json" \
  #         --form "job_submit_token=fhuyr7437ferf487" \
  #         --form "model=this ~ is^2 + a * model" \
  #         --form "epsilon=0.9" \
  #         --form "output_unit=1000" \
  #         http://localhost:3000/app_install/remote_jobs
  #
  # periodically, the backend processor in the protected data enclave asks for a list of
  # jobs that it should process like this:
  #
  #   curl -X POST \
  #        -H "Content-Type: multipart/form-data" \
  #        -H "Accept: application/json" \
  #        http://localhost:3000/app_install/awaiting_remote_processing      
  #
  # the results returned will look like this:
  #
  #     [{"status":"OK"},
  #        [{"opaque_id":"953170ab-d039-42e2-bf48-aaaa94f72b5a"},
  #         {"opaque_id":"f24449f5-3cc2-4f6f-8f9f-e66e2a078afd"}]]
  #
  # Now that the backend processor knows the opaque_ids for jobs needing processing it can fetch
  # them (one at a time), and start processing by calling app_install/starting_remote_processing.
  # Here is how the backend processor signals that it is starting:
  #
  #    curl -X PUT \
  #         -H "Content-Type: multipart/form-data" \
  #         -H "Accept: application/json" \
  #         --form "opaque_id=953170ab-d039-42e2-bf48-aaaa94f72b5a" \
  #         http://localhost:3000/app_install/starting_remote_processing
  #
  # Note that app_install/starting_remote_processing has the side effect of marking the job as 
  # having been submitted (so it is not returned in later calls to app_install/awaiting_remote_processing)
  #
  # Finally, after the backend processor in the protected data enclave is done, 
  # it updates the record like this:
  #
  #   curl -X PUT \
  #        -H "Content-Type: multipart/form-data" \
  #        -H "Accept: application/json" \
  #        --form "opaque_id=953170ab-d039-42e2-bf48-aaaa94f72b5a"
  #        --form "uploadfile=@pretty-output.png" \
  #        http://localhost:3000/app_install/completed_remote_processing       
  #
  #
  # For creating and updating jobs, the json returned will look something like this:
  #
  #     [{"status":"OK"},{"created_at":"2016-06-05T21:38:41Z"}]
  #
  #  or like this in the event of a failure:
  #
  #     [{"status":"ERROR"},{"ERROR":["something bad happened"]}]
  #
  #############
  
  
  # GET /remote_jobs/new
  # GET /remote_jobs/new.json
  def new
    @remote_job = RemoteJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @remote_job }
    end
  end


  # POST /remote_jobs
  # POST /remote_jobs.json
  def create
    # first validate that the job_submit_token is one we have heard of
    @request_submit_token = ShinyDocker.find_by_job_submit_token( params[:job_submit_token] )
    if @request_submit_token.nil?
      respond_to do |format|
          Session.create(:action => 'remote_job-ERROR', :netid => '', :notes => "invalid job_submit_token: #{params[:job_submit_token]}")
          format.html { render action: "new" }
          format.json { render json: [{:status => 'ERROR'}, "invalid job_submit_token: #{params[:job_submit_token]}"], status: :unprocessable_entity }      
      end
    else
      @remote_job = RemoteJob.new(
       {:job_submit_token => params[:job_submit_token],
        :epsilon => params[:epsilon], 
        :model => params[:model],
        :output_unit => params[:output_unit]}
      )
      @remote_job.completeted = false
      @remote_job.submitted = false
    
      # generate an :opaque_id which we can use to identify this job independently of the id in the mysql table
      @remote_job.opaque_id = SecureRandom.uuid
    
      respond_to do |format|
        if @remote_job.save
          Session.create(:action => 'remote_job-OK', :netid => '', 
            :notes => "token:#{params[:job_submit_token]} model:'#{@remote_job.model}' epsilon:'#{@remote_job.epsilon}' output_unit:'#{@remote_job.output_unit}'")
          format.html { redirect_to @remote_job, notice: 'Remote_job was successfully created.' }
          format.json { render json: [{:status => 'OK'}, :created_at => @remote_job.created_at], status: :created }
        else
          Session.create(:action => 'remote_job-ERROR', :netid => '', :notes => "token:#{params[:job_submit_token]} model:'#{@remote_job.model}' epsilon:'#{@remote_job.epsilon}' output_unit:'#{@remote_job.output_unit}'")
          format.html { render action: "new" }
          format.json { render json: [{:status => 'ERROR'}, @remote_job.errors], status: :unprocessable_entity }      
        end
      end
    end
  end
  
 
  # POST /remote_jobs#awaiting_remote_processing.json  
  def awaiting_remote_processing
    # find the jobs that have not been submitted for remote processing yet
    @unsubmitted_remote_jobs = RemoteJob.find_all_by_submitted(false)
    @unsubmitted_remote_jobs.map! {|item| {opaque_id: item.opaque_id}}
    respond_to do |format|
        format.json { render json: [{:status => 'OK'}, @unsubmitted_remote_jobs] }
    end   
  end
 

  # PUT /remote_jobs#starting_remote_processing.json  
  def starting_remote_processing
    # find the job that processing is going to start on
    @starting_remote_job = RemoteJob.find_by_opaque_id(params[:opaque_id])
    @starting_remote_job.submitted = true
    respond_to do |format|
        if @starting_remote_job.save
          Session.create(:action => 'remote_job#starting_remote_processing-OK', :netid => '',  :notes => "#{params[:opaque_id]}")
          format.json { render json: [{:status => 'OK'}, :updated_at => @starting_remote_job.updated_at], status: :updated }
        else
          Session.create(:action => 'remote_job#starting_remote_processing-ERROR', :netid => '', :notes => "#{params[:opaque_id]}")
          format.html { render action: "new" }
          format.json { render json: [{:status => 'ERROR'}, @starting_remote_job.errors], status: :unprocessable_entity }      
        end
    end   
  end
   
   
  # PUT /remote_jobs#completed_remote_processing
  # PUT /remote_jobs#completed_remote_processing.json  
  def completed_remote_processing
    # find the job we are going to mark complete
    @remote_job = RemoteJob.find_by_opaque_id(params[:opaque_id])
    @remote_job.completeted = true
    @remote_job.uploadfile = params[:uploadfile]
    respond_to do |format|
      if @remote_job.save
       Session.create(:action => 'remote_job#completed_remote_processing-OK', :netid => '',  :notes => "#{@remote_job.opaque_id} - #{@remote_job.uploadfile}")
        format.html { redirect_to @remote_job, notice: 'Remote_job was completed.' }
        format.json { render json: [{:status => 'OK'}, :updated_at => @remote_job.updated_at], status: :updated }
      else
        Session.create(:action => 'remote_job#completed_remote_processing-ERROR', :netid => '', :notes => "#{@remote_job.opaque_id} - #{@remote_job.uploadfile}")
        format.html { render action: "new" }
        format.json { render json: [{:status => 'ERROR'}, @remote_job.errors], status: :unprocessable_entity }      
      end
    end
  end
  
  
  #############################################################
  # fix this to limit the vewing of previously uploaded stuff to admins only
  #
  # this should be limit access to everything except uploads to the app admins
  # so - everything below this line is app admin only
  #############################################################
  
#  before_filter :onlyAdmin
  layout 'admin_base'
  
  active_scaffold :"remote_job" do |conf|
    conf.label = 'Remote Jobs'
    conf.actions = [:list, :search, :show]
    active_scaffold_config.search.live = true   #submit search terms as we type for more feedback
    conf.list.sorting = { :id => :desc}
    conf.columns = [ :id, :opaque_id, :job_submit_token, :submitted, :completeted, :model, :epsilon, :output_unit, :uploadfile, :updated_at, :created_at ]
  end
  
	# Override authorize in application_controller.rb
  def authorize
    case request.format
    when Mime::JSON
      return true
    else
      super
    end
  end
  
end
