class Category < ActiveRecord::Base
  belongs_to :category, inverse_of: :categories
  has_many :categories, inverse_of: :category, :dependent => :destroy
  has_many :topics, inverse_of: :category, :dependent => :destroy
  
  validates :image_url, format: { with: /\Ahttps?:\/\//,
    message: "Must be like 'http://...'" }
  
  scope :roots, -> { where(category_id: nil) }
  default_scope {order(:num)}
  
  PERMISSION_LEVELS = [
      ["Visiteurs", "visitors"],
      ["Membres", "members"],
      ["Modérateurs", "moderators"],
      ["Admins", "admins"]
      ]
  SPECIALS = [
      ["Personnages validés", "valid"],
      ["En attente de validation", "no-valid"],
      ["Postes vacants", "pnj"],
      ]
  
  def supcategories
    cat = self.category
    supcats = []
    while cat and cat != self # Stupid guy, I will fucking kill you. (loop)
      supcats << cat
      cat = cat.category
    end
    supcats.reverse
  end
  def supcategory_ids
    self.supcategories.map(&:id)
  end
  
  def subcategories
    cats = self.categories
    subcats = []
    cat = nil
    while cats.length and cat != self # Stupid guy, I will fucking kill you. (loop)
      cat = cats.pop
      subcats << cat
      cats << cat.categories
    end
    subcats
  end
  def subcategory_ids
    self.subcategories.map(&:id)
  end
end
