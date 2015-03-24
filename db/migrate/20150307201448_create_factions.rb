class CreateFactions < ActiveRecord::Migration
  def change
    create_table :factions do |t|
      t.string :name
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
