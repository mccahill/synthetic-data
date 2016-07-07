class UsersController < ApplicationController
  before_filter :onlyAdmin
  layout 'admin_base'
  
  active_scaffold :"user" do |conf|
  end
end
