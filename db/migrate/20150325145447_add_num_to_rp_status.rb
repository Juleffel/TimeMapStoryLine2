class AddNumToRpStatus < ActiveRecord::Migration
  def change
    add_column :rp_statuses, :num, :integer
  end
end
