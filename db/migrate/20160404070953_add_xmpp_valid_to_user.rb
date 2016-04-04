class AddXmppValidToUser < ActiveRecord::Migration
  def change
    add_column :users, :xmpp_valid, :boolean, default: false
  end
end
