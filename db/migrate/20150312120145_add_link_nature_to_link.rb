class AddLinkNatureToLink < ActiveRecord::Migration
  def change
    add_reference :links, :link_nature, index: true
  end
end
