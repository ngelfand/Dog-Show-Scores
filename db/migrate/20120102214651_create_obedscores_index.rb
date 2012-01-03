class CreateObedscoresIndex < ActiveRecord::Migration
  def up
    add_index :obedscores, :show_id
    add_index :obedscores, :dog_id
  end

  def down
    remove_index :obedscores, :show_id
    remove_index :obedscores, :dog_id
  end
end
