class CreateShinyDockers < ActiveRecord::Migration
  def change
    create_table :shiny_dockers do |t|
      t.text :host
      t.integer :port
      t.string :pw
      t.string :appname
      t.text :appdesc
      t.boolean :expired
      t.string :netid

      t.timestamps
    end
  end
end
