class AddOnlyadminToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :only_admin, :boolean, default: false
  end
end
