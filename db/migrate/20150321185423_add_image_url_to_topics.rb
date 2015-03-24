class AddImageUrlToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :image_url, :text
    add_column :topics, :title, :text
    add_column :topics, :subtitle, :text
    add_column :topics, :summary, :text
    add_column :topics, :weather, :text
  end
end
