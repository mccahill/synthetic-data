class RemoteJob < ActiveRecord::Base
  attr_accessible :completeted, :epsilon, :model, :netid, :output_unit, :submitted
end
