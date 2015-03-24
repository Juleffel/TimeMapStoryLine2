class CreateLinkNatures < ActiveRecord::Migration
  def change
    create_table :link_natures do |t|
      t.text :name
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
