class AddBirthToSpacetimePosition < ActiveRecord::Migration
  def change
    add_column :spacetime_positions, :birth, :boolean
  end
end
