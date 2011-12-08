class CreateJudges < ActiveRecord::Migration
  def self.up
    create_table :judges  do |t|
      t.integer :judge_id
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
  
  def self.down
      drop_table :judges
  end
end
