class AddNpcToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :npc, :boolean, default: false
  end
end
