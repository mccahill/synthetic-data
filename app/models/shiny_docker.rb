class ShinyDocker < ActiveRecord::Base
  attr_accessible :appdesc, :appname, :expired, :host, :netid, :port, :pw, :job_submit_token
end
