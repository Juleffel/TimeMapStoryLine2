class AddUserToAnswer < ActiveRecord::Migration
  def change
    add_reference :answers, :user, index: true
  end
end
