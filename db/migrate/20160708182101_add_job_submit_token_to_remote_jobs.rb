class AddJobSubmitTokenToRemoteJobs < ActiveRecord::Migration
  def change
    add_column :remote_jobs, :job_submit_token, :string
  end
end
