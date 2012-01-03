class CreateRalshowsIndex < ActiveRecord::Migration
  def up
    add_index :ralscores, :ralshow_id
    add_index :ralscores, :dog_id
  end

  def down
    remove_index :ralscores, :ralshow_id
    remove_index :ralscores, :dog_id
  end
end
