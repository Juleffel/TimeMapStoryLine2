class AddSpecialToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :special, :string
  end
end
