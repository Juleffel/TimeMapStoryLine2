class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.belongs_to :from_character, index: true
      t.belongs_to :to_character, index: true
      t.string :title
      t.text :description
      t.integer :force

      t.timestamps
    end
  end
end
