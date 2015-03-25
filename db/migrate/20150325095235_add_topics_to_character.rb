class AddTopicsToCharacter < ActiveRecord::Migration
  def change
    add_reference :characters, :links_topic, index: true
    add_reference :characters, :rps_topic, index: true
  end
end
