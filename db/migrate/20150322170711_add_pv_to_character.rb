class AddPvToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :npc, :boolean
    add_column :characters, :image_url, :text
    remove_column :characters, :resume, :text
    add_column :characters, :summary, :text
    add_column :characters, :quote, :text
    add_column :characters, :middle_name, :text
    add_column :characters, :nickname, :text
    add_column :users, :role, :string
  end
end
