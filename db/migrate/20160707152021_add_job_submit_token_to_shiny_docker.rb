class AddJobSubmitTokenToShinyDocker < ActiveRecord::Migration
  def change
    add_column :shiny_dockers, :job_submit_token, :string
  end
end
