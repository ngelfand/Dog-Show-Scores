class CreateRalshows < ActiveRecord::Migration
  def up
    create_table :ralshows do |t|
      t.integer :show_id
      t.string :name
      t.string :city
      t.string :state
      t.datetime :date
      t.timestamps
    end
      add_index :ralshows, :show_id, :unique => true
  end
  
  def down
    drop_table :ralshows
  end
end
