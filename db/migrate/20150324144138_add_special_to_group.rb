class AddSpecialToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :special, :string
  end
end
