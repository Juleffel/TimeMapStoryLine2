class AddSomeIndexes < ActiveRecord::Migration
  def change
    add_index :categories, :special
    add_index :groups, :special
  end
end
