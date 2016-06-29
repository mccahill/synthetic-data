class Session < ActiveRecord::Base
  attr_accessible :action, :netid, :notes
end
