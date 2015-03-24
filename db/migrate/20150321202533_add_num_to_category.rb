class AddNumToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :num, :integer
  end
end
