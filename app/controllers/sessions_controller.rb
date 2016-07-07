class SessionsController < ApplicationController
  before_filter :onlyAdmin
  layout 'admin_base'
  
  active_scaffold :"session" do |conf|
  end
end
