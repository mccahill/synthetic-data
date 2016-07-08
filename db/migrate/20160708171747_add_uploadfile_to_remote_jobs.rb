class AddUploadfileToRemoteJobs < ActiveRecord::Migration
  def change
    add_column :remote_jobs, :uploadfile, :string
  end
end
