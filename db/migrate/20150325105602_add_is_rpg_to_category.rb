class AddIsRpgToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :is_rpg, :boolean
    add_column :categories, :is_flood, :boolean
  end
end
