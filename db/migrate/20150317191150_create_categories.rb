class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.belongs_to :category, index: true
      t.text :title
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
