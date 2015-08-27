class AddDefaultgroupToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :default_group, :boolean, default: false
  end
end
