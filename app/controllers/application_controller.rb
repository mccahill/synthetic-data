class ApplicationController < ActionController::Base
  protect_from_forgery

  layout "base"
  
  before_filter :authorize

  private
  def authorize
    
    if ENV['RAILS_ENV'] == 'development'
      # duid = '0198623'
      @duid = '0435319'
      @netid = 'mccahill'
      @displayName = 'Mark McCahill'
      @affiliation = 'staff'
    else
      @duid = request.env['unique-id']
      @netid = request.env['eppn'].split("@").first
      @displayName = request.env['displayName']
      @affiliation = request.env['affiliation'].split("@").first
    end
 
    @this_user = User.find_or_create_by_duid(duid: @duid)
    @this_user.netid = @netid
    @this_user.displayName = @displayName
    @this_user.save
    
    session[:user_id] = @duid        
    if Admin.find_by_netid( @netid )
      session[:is_admin] = true
    else
      session[:is_admin] = false
    end
  end    
	def onlyAdmin
    unless( session[:is_admin])
			flash[:error] = "You do not have access to that function"
      logger.warn "User #{session[:user_id]} tried to access an Admin-Only Controller: #{params[:controller]}"
      redirect_to "/"
    end
	end
  
end
