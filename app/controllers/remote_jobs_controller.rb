class RemoteJobsController < ApplicationController
  before_filter :onlyAdmin
  layout 'admin_base'
  
  active_scaffold :"remote_job" do |conf|
    conf.label = 'Remote Jobs'
    conf.actions = [:list, :search, :show]
    active_scaffold_config.search.live = true   #submit search terms as we type for more feedback
    conf.list.sorting = { :id => :desc}
    conf.columns = [ :id, :netid, :submitted, :completeted, :model, :epsilon, :output_unit, :updated_at, :created_at ]

    
  end
end
