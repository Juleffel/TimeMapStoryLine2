class User < ActiveRecord::Base
  require 'fastimage'
  require "base64"
  require 'open-uri'
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

  def avatar_url
    @avatar_url || (rand_char = self.characters.offset(rand(self.characters.count)).first
    if rand_char
      @avatar_url = rand_char.small_image_url
    else
      nil
    end)
  end

  def avatar_type
    @avatar_type || (FastImage.type(@avatar_url) if avatar_url)
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
    vcard = {
      'FN' => self.pseudo,
      'NICKNAME' => self.pseudo,
    }
    if not self.last_avatar_date or self.last_avatar_date.days_since(2) < DateTime.now
      vcard['TYPE'] = vcard['PHOTO/TYPE'] = self.avatar_type.to_s.upcase if self.avatar_type
      vcard['BINVAL'] = vcard['PHOTO/BINVAL'] = Base64.encode64(open(self.avatar_url) { |io| io.read }) if self.avatar_url
    end
    ApplicationController.helpers.update_vcard(self.jid, self.xmpp_password, vcard)
  end
end
