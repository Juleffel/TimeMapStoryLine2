class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.belongs_to :user, index: true
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :birth_place
      t.boolean :sex
      t.text :avatar_url
      t.string :avatar_name
      t.string :copyright
      t.belongs_to :topic, index: true
      t.text :story
      t.text :resume
      t.text :anecdote
      t.text :test_rp
      t.text :psychology
      t.text :appearance
      t.belongs_to :faction, index: true
      t.belongs_to :group, index: true

      t.timestamps
    end
  end
end
