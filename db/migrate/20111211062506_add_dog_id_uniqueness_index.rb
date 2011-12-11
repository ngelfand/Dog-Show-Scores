class AddDogIdUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :dogs, :akc_id, :unique => true
  end

  def down
    remove_index :dogs, :akc_id
  end
end
