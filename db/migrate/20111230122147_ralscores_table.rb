class RalscoresTable < ActiveRecord::Migration
  def up
    create_table :ralscores do |t|
      t.integer  :show_id
      t.integer  :dog_id
      t.string   :classname
      t.float    :score
      t.integer  :placement
      t.string   :award
      t.string   :dog_name
    end
  end

  def down
    drop_table :ralscores
  end

end
