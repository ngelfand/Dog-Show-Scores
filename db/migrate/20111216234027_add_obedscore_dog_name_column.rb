class AddObedscoreDogNameColumn < ActiveRecord::Migration
  def up
    add_column :obedscores, :dog_name, :string
  end

  def down
    delete_column :obedscores, :dog_name
  end
end
