class AddStatusToTopic < ActiveRecord::Migration
  def change
    add_reference :topics, :rp_status, index: true
  end
end
