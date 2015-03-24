class Answer < ActiveRecord::Base
  belongs_to :topic, inverse_of: :answers
  belongs_to :character, inverse_of: :answers
  has_one :user, through: :character
  
  default_scope {order(:created_at)}
end
