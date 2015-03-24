class AddPermitionLevelToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :permission_level, :string
  end
end
