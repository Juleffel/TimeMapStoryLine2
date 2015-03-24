class CreateSpacetimePositions < ActiveRecord::Migration
  def change
    create_table :spacetime_positions do |t|
      t.float :longitude
      t.float :latitude
      t.text :title
      t.text :subtitle
      t.text :resume
      t.text :weather
      t.datetime :begin_at
      t.datetime :end_at
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end
