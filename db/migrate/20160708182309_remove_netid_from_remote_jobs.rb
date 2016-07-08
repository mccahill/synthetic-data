class RemoveNetidFromRemoteJobs < ActiveRecord::Migration
  def up
    remove_column :remote_jobs, :netid
  end

  def down
    add_column :remote_jobs, :netid, :string
  end
end
