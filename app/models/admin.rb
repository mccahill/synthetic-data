class Admin < ActiveRecord::Base
  attr_accessible :displayName, :duid, :netid
end
