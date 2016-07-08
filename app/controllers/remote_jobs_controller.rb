class RemoteJobsController < ApplicationController

  ##############
  # generally we assume that apps will be programatically posting files here
  # instead of users visiting the web pages, so this is mostly a REST-style interface
  # You can validate that this works via a CURL command something like this:
  #
  #      curl -X POST \
  #        -H "Content-Type: multipart/form-data" \
  #        -H "Accept: application/json"
  #        --form "sha1hash=put-the-hash-for-the-file-here" \
  #        --form "uploadfile=@filname.zip" \
  #        http://localhost:3000/phoneuploads
  #
  # the json returned will look like this:
  #
  #     [{"status":"OK"},{"created_at":"2016-06-05T21:38:41Z"}]
  #
  #  or like this in the event of a failure:
  #
  #     [{"status":"ERROR"},
  #          {"ERROR":["SHA1 hash 36454383da993f976f5c22e6d73856f46c2ec044 sent with file does 
  #                     not match hash calculated on file received at server:
  #                     36454383da993f976f5c22e6d73856f46c2ec045"]
  #           }]
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
    @remote_job = RemoteJob.new({:sha1hash => params[:sha1hash], :uploadfile => params[:uploadfile]})

    respond_to do |format|
      if @remote_job.save
        Session.create(:action => 'remote_job-OK', :netid => '', :notes => "#{@remote_job.uploadfile}")
        format.html { redirect_to @remote_job, notice: 'Remote_job was successfully created.' }
        format.json { render json: [{:status => 'OK'}, :created_at => @remote_job.created_at], status: :created }
#        format.json { render json: @remote_job, status: :created, location: @remote_job }
      else
        Session.create(:action => 'remote_job-ERROR', :netid => '', :notes => "#{@remote_job.uploadfile}")
        format.html { render action: "new" }
        format.json { render json: [{:status => 'ERROR'}, @remote_job.errors], status: :unprocessable_entity }      
#        format.json { render json: @remote_job.errors, status: :unprocessable_entity }
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
    conf.columns = [ :id, :opaque_id, :netid, :submitted, :completeted, :model, :epsilon, :output_unit, :uploadfile, :updated_at, :created_at ]
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
