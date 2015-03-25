class AddDisplayLastToRpStatus < ActiveRecord::Migration
  def change
    add_column :rp_statuses, :display_last, :boolean
  end
end
