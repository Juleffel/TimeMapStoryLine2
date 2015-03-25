class ChangeTextFromString < ActiveRecord::Migration
  def change
    change_column :answers, :title, :text
    change_column :categories, :image_url, :text
    change_column :categories, :permission_level, :text
    change_column :categories, :special, :text
    change_column :characters, :birth_place, :text
    change_column :characters, :avatar_name, :text
    change_column :characters, :copyright, :text
    change_column :characters, :last_name, :text
    change_column :characters, :first_name, :text
    change_column :factions, :name, :text
    change_column :groups, :name, :text
    change_column :groups, :special, :text
    change_column :links, :title, :text
    change_column :users, :pseudo, :text
  end
end
