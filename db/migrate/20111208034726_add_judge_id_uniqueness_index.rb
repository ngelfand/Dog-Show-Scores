class AddJudgeIdUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :judges, :judge_id, :unique => true
  end

  def down
    remove_index :judges, :judge_id
  end
end
