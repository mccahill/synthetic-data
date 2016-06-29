class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :netid
      t.string :action
      t.string :notes

      t.timestamps
    end
  end
end
