class RemoveTopicIdFromSpacetimePosition < ActiveRecord::Migration
  def change
    remove_column :spacetime_positions, :topic_id, :integer
  end
end
