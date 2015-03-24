class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :title
      t.text :content
      t.belongs_to :character, index: true
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end
