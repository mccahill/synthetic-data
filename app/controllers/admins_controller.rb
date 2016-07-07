class AdminsController < ApplicationController
  before_filter :onlyAdmin
  layout 'admin_base'
  active_scaffold :"admin" do |conf|
  end
end
