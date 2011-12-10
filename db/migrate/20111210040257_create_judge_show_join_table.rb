class CreateJudgeShowJoinTable < ActiveRecord::Migration
  def up
    create_table :obedclasses do |t|
      t.integer :judge_id
      t.integer :show_id
      t.string  :classname
    end
  end

  def down
    drop_table :obedclasses
  end
end
