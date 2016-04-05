class AddLastAvatarDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_avatar_date, :datetime
  end
end
