class RemoveNodeFromPresence < ActiveRecord::Migration
  def change
    remove_reference :presences, :node, index: true
    add_reference :presences, :spacetime_position, index: true
  end
end
