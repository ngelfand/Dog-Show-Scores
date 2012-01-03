class AddClassorder < ActiveRecord::Migration
  def up
    add_column :ralscores, :classorder, :integer
  end

  def down
    delete_column :ralscores, :classorder
  end
end
