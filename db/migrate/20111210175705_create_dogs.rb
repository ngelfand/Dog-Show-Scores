class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :akc_id
      t.string :owner
      t.string :akc_name
      t.string :breed

      t.timestamps
    end
  end
end
