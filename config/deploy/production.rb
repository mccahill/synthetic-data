server 'synthetic-web-01.oit.duke.edu', :app, :web, :db, :primary => true
set :rails_env, 'production'
set :deploy_via, :export
# Deploy from local working copy
#set :repository, "."
#set :scm, :none
#set :deploy_via, :copy
#set :copy_exclude, [".git/*", 'config/database.yml', 'config/dukeapps-creds.yml']

set :vhost, 'synthetic.oit.duke.edu'

default_environment.delete :http_proxy
default_environment.delete :HTTPS_PROXY
