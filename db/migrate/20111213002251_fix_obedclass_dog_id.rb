class FixObedclassDogId < ActiveRecord::Migration
  def up
    change_column :obedscores, :dog_id, :integer
  end

  def down
  end
end
