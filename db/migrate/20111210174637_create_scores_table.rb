class CreateScoresTable < ActiveRecord::Migration
  def up
    create_table :obedscores do |t|
      t.integer  :show_id
      t.string   :dog_id
      t.string   :classname
      t.float    :score
      t.integer  :placement
      t.string   :award
    end
  end

  def down
    drop_table :obedscores
  end
end

