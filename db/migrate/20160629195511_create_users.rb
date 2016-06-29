class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :displayName
      t.string :netid
      t.string :duid

      t.timestamps
    end
  end
end
