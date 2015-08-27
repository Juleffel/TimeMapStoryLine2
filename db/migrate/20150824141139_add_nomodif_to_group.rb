class AddNomodifToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :no_modif, :boolean, default: false
  end
end
