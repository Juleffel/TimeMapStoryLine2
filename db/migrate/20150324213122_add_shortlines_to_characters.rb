class AddShortlinesToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :shortline1, :text
    add_column :characters, :shortline2, :text
  end
end
