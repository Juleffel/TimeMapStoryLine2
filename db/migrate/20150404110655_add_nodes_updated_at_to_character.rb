class AddNodesUpdatedAtToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :map_nodes_updated_at, :datetime
  end
end
