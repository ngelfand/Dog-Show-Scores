class RenameShowsToRalshows < ActiveRecord::Migration
  def up
    rename_column :ralscores, :show_id, :ralshow_id
    rename_column :ralclasses, :show_id, :ralshow_id
  end

  def down
    rename_column :ralscores, :ralshow_id, :show_id
    rename_column :ralclasses, :ralshow_id, :show_id
    
  end
end
