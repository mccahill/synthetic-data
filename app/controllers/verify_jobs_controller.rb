class VerifyJobsController < ApplicationController
 
  before_filter :authorize
  
  layout "home"
  
  def index
    @user = User.find_by_netid session[:user_id]
  end
  
end
