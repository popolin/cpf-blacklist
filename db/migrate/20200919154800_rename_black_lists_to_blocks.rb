class RenameBlackListsToBlocks < ActiveRecord::Migration[6.0]
  def change
    rename_table :black_lists, :blocks
  end
end
