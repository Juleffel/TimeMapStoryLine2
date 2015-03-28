class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :characters, inverse_of: :user, :dependent => :destroy
  has_many :topics, inverse_of: :user
  has_many :answers, inverse_of: :user
  
  def number_of_messages
    @number_of_messages = @number_of_messages || User.all.joins(:answers).select(:id, 'COUNT(answers.id) AS c').group('users.id').where(id: self.id).first.c
  end
  
  def to_s
    pseudo
  end
  
  def admin?
    role == "admin"
  end
end
