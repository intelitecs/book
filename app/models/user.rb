class User < ActiveRecord::Base
  #attr_accessor :email, :username, :password, :password_confirmation
  after_create :generate_remember_token
  default_scope{ order('created_at DESC')}
  has_attached_file :image, styles: {small:'200x150',medium:'400x350>', large: '600x500>'}
  has_secure_password
  validates :username, :email,presence: :true
  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  validates :username, :email, uniqueness: :true
  validates :username, length: {minimum: 6, maximum: 15}
  validates :password, length: {minimum: 7, maximum: 21}
  #EmailRegex = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{3,63}\.[a-zA-Z]{2,6})\z/i
  #validates :email, format: {with: self::EmailRegex}
  has_many :comments, dependent: :destroy
  has_many :articles, through: :comments


  #def self.from_omniauth(auth)
   # where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
  #    user.provider = auth.provider
  #    user.uid = auth.uid
  #    user.username = auth.info.name
  #    user.oauth_token = auth.credentials.token
  #    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
  #    user.save!
  #  end
    
  #end



  private
  def generate_remember_token
    self.remember_token= SecureRandom.urlsafe_base64
  end


end
