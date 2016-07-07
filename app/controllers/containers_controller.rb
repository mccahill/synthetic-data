class ContainersController < ApplicationController
  
  before_filter :authorize
  
  require 'rest_client'
  
  def docker_app_types
    return ShinyDocker.select("DISTINCT appname, appdesc").order(:appname).reverse
  end
  
  def index
    @user = User.find_by_netid session[:user_id]
    @user_app_collection = []
    docker_app_types.each do |app_type|
      reserved_instance = ShinyDocker.find_by_netid_and_appname(@user.netid, app_type.appname) 
      if reserved_instance.nil? then
        @user_app_collection.push(:container_type=>app_type.appname, :container_desc=> app_type.appdesc, 
        :app_path=> "containers/#{app_type.appname.downcase}",
        :first_visit=> true )
      else # they already have a reserved instance
        @user_app_collection.push(:container_type=>app_type.appname, :container_desc=> app_type.appdesc, 
        :app_path=> "containers/#{app_type.appname.downcase}",
        :app_expired=> reserved_instance.expired,
        :first_visit=> false )
      end     
    end    
    respond_to do |format|
      format.html # index.html.erb
    end
    
  end

  def renew
    user = User.find_by_netid session[:user_id]
    containertype = params[:containertype]
    
    expired_instance = ShinyDocker.find_by_netid_and_appname(user.netid, containertype) 
    expired_instance.expired = false
    expired_instance.save

    #ActivityLog.log(session[:user_id], 'Docker renew',"Docker: #{user.netid} renewed #{containertype} at #{expired_instance.host}:#{expired_instance.port}" )                
  end

  def show
    user = User.find_by_netid session[:user_id]
    container_type = request.path.split("/").last
    if container_type == 'renew' then
      self.renew
    else
      @first_visit = true
      reserved_instance = ShinyDocker.find(:first, :conditions=> ["netid = ? and lower(appname) = ?", user.netid, container_type])
      if reserved_instance.nil? then # they have never reserved an instance
        new_instance = ShinyDocker.find_by_netid_and_appname(nil, container_type)
        if new_instance.nil? then 
            logger.error "Failed to reserve Docker #{container_type} instance for user: #{user.netid}"
            flash[:error] = "ERROR: Cannot find an unused Docker container for #{container_type}"
            redirect_to "/containers" and return
        else
          # reserve this instance
          new_instance.netid = user.netid
          new_instance.save
            
          @docker_host = new_instance.host
          @docker_port = new_instance.port
          @docker_guest_pw = new_instance.pw  
          #ActivityLog.log(session[:user_id], 'Docker containers',"Docker: #{user.netid} reserved #{container_type} at #{@docker_host}:#{@docker_port}" )                
        end
      else #send them to the instance they previously reserved
        @first_visit = false
        @docker_host = reserved_instance.host
        @docker_port = reserved_instance.port
        @docker_guest_pw = reserved_instance.pw    
      end 
      if container_type == 'shiny'           
        # shiny-specific code here 
      end
      #ActivityLog.log(session[:user_id], 'Docker containers',"Docker: #{user.netid} logging into #{container_type} at #{@docker_host}:#{@docker_port}" )    
    end
    render :template => "containers/#{container_type.downcase}" 
  end
end
