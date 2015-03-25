class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :characters, inverse_of: :user, :dependent => :destroy
  has_many :topics, inverse_of: :user
  has_many :answers, through: :characters
  
  def to_s
    email
  end
  
  def admin?
    role == "admin"
  end
end
