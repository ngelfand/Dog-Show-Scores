class CreateRallyclassesTable < ActiveRecord::Migration
   def up
    create_table :ralclasses do |t|
      t.integer :judge_id
      t.integer :show_id
      t.string  :classname
      t.integer :dogs_in_class
    end
  end

  def down
    drop_table :ralclasses
  end
end
