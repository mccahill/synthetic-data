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
  end

  def show
  end
end
