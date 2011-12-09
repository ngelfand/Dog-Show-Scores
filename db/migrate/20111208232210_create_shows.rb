class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.integer :show_id
      t.string :name
      t.string :city
      t.string :state
      t.datetime :date

      t.timestamps
    end
  end
end
