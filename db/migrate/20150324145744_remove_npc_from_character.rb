class RemoveNpcFromCharacter < ActiveRecord::Migration
  def change
    remove_column :characters, :npc, :boolean
  end
end
