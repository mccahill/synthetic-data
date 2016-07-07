class CreateRemoteJobs < ActiveRecord::Migration
  def change
    create_table :remote_jobs do |t|
      t.string :netid
      t.string :model
      t.string :output_unit
      t.string :epsilon
      t.boolean :submitted
      t.boolean :completeted

      t.timestamps
    end
  end
end
