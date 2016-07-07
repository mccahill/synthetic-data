class ShinyDockersController < ApplicationController
  active_scaffold :"shiny_docker" do |conf|
    conf.label = 'Docker Containers'
    conf.actions = [:list, :search, :show]
    active_scaffold_config.search.live = true   #submit search terms as we type for more feedback
    conf.list.sorting = { :port => :asc}
    conf.columns = [ :id, :host, :port, :netid, :pw, :job_submit_token, :appname,  :appdesc, :expired, :updated_at, :created_at ]
    conf.columns[:port].options[:format] = "%05d"    
  end
end
