class AddSmallImageToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :small_image_url, :text
  end
end
