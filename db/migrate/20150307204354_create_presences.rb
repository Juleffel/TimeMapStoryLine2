class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.belongs_to :node, index: true
      t.belongs_to :character, index: true

      t.timestamps
    end
  end
end
