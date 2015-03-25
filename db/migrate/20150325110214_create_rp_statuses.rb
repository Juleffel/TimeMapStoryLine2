class CreateRpStatuses < ActiveRecord::Migration
  def change
    create_table :rp_statuses do |t|
      t.text :name
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
