class SessionsController < ApplicationController
  before_filter :onlyAdmin
  layout 'admin_base'
  
  active_scaffold :"session" do |conf|
    conf.label = 'Sessions and Activity'
    conf.actions = [:list, :search, :show]
    active_scaffold_config.search.live = true   #submit search terms as we type for more feedback
    conf.list.sorting = { :id => :desc}
    conf.columns = [ :id, :netid, :action,  :notes, :updated_at, :created_at ]
  end
end
