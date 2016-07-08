class AddOpaqueIdToRemoteJobs < ActiveRecord::Migration
  def change
    add_column :remote_jobs, :opaque_id, :string
  end
end
