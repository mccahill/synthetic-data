class RemoteJobsController < ApplicationController

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
  #         http://localhost:3000/remote_jobs
  #
  # periodically, the backend processor in the protected data enclave asks for a list of
  # jobs that it should process like this:
  #
  # then, after the backend processor in the protected data enclave is done, 
  # it updates the record like this:
  #
  #   curl -X PUT \
  #        -H "Content-Type: multipart/form-data" \
  #        -H "Accept: application/json" \
  #        --form "uploadfile=@pretty-output.png" \
  #        http://localhost:3000/remote_jobs/5
  #        something li
  # ke this:
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
    # params[:job_submit_token]
    @remote_job = RemoteJob.new(
     {:job_submit_token => params[:job_submit_token],
      :epsilon => params[:epsilon], 
      :model => params[:model],
      :output_unit => params[:output_unit]}
    )
    @remote_job.completeted = false
    @remote_job.submitted = false
    # generate an :opaque_id
    respond_to do |format|
      if @remote_job.save
        Session.create(:action => 'remote_job-OK', :netid => '', 
          :notes => "#{@remote_job.model} - #{@remote_job.epsilon} - #{@remote_job.output_unit}")
        format.html { redirect_to @remote_job, notice: 'Remote_job was successfully created.' }
        format.json { render json: [{:status => 'OK'}, :created_at => @remote_job.created_at], status: :created }
#        format.json { render json: @remote_job, status: :created, location: @remote_job }
      else
        Session.create(:action => 'remote_job-ERROR', :netid => '', :notes => "#{@remote_job.model} - #{@remote_job.epsilon} - #{@remote_job.output_unit}")
        format.html { render action: "new" }
        format.json { render json: [{:status => 'ERROR'}, @remote_job.errors], status: :unprocessable_entity }      
#        format.json { render json: @remote_job.errors, status: :unprocessable_entity }
      end
    end
  end
   
  # PUT /remote_jobs
  # PUT /remote_jobs.json
  
  def update
    @article = Article.find(params[:id])
 
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def update
    # find the job
    @remote_job = RemoteJob.find(params[:id])
    @remote_job.completeted = true
    @remote_job.uploadfile = params[:uploadfile]
    respond_to do |format|
      if @remote_job.save
       Session.create(:action => 'remote_job#update-OK', :netid => '',  :notes => "#{@remote_job.model} - #{@remote_job.uploadfile}")
        format.html { redirect_to @remote_job, notice: 'Remote_job was successfully created.' }
        format.json { render json: [{:status => 'OK'}, :updated_at => @remote_job.updated_at], status: :created }
      else
        Session.create(:action => 'remote_job#update-ERROR', :netid => '', :notes => "#{@remote_job.model} - #{@remote_job.uploadfile}")
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
