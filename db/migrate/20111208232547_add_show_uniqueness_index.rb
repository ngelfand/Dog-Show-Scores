class AddShowUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :shows, :show_id, :unique => true
  end

  def down
    remove_index :shows, :show_id 
  end
end
