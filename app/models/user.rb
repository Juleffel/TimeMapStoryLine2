class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :characters, inverse_of: :user, :dependent => :destroy
  has_many :topics, inverse_of: :user
  has_many :answers, inverse_of: :user

  def self.reset_xmpp
    self.all.each {|u| u.update_attributes(xmpp_valid: false)}
  end

  def number_of_messages
    @number_of_messages = @number_of_messages || User.all.joins(:answers).select(:id, 'COUNT(answers.id) AS c').group('users.id').where(id: self.id).first.c
  end

  def to_s
    pseudo
  end

  def jid
    "#{self.pseudo.parameterize}@timemapstoryline.no-ip.info"
  end

  def admin?
    role == "admin"
  end

  def other_jids
    hash = {}
    User.where('xmpp_valid = ? AND id != ?', true, self.id).map do |u|
      hash[u.jid] = u.pseudo
    end
    hash
  end

  def update_vcard
    ApplicationController.helpers.update_vcard(
      self.jid, self.xmpp_password,
      {
        'FN' => self.pseudo,
        'NICKNAME' => self.pseudo,
      })
  end
end
