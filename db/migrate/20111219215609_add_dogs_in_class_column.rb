class AddDogsInClassColumn < ActiveRecord::Migration
  def up
    add_column :obedclasses, :dogs_in_class, :integer
  end

  def down
    drop_column :obedclasses, :dogs_in_class
  end
end
