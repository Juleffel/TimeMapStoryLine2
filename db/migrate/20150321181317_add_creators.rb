class AddCreators < ActiveRecord::Migration
  def change
    add_reference :spacetime_positions, :user, index: true
    add_reference :topics, :user, index: true
    add_reference :topics, :spacetime_position, index: true
    add_reference :topics, :category, index: true
  end
end
