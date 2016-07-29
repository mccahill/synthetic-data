class AddSyntheticfileToRemoteJob < ActiveRecord::Migration
  
  def change 
    remove_column :remote_jobs, :uploadfile
    add_column :remote_jobs, :syntheticfile, :string
    add_column :remote_jobs, :verificationfile, :string
  end
  
end
