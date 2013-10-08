class CustomerManagement < ActiveRecord::Base

belongs_to :customer

include BCrypt
 validates :name, presence: true, length: { maximum: 50 }
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
validates :password, presence: true
validates_confirmation_of :password, on: :create
validates_presence_of :password_confirmation 
before_save :encrypt
 
def new_remember_token
  @token = SecureRandom.urlsafe_base64
  return @token  
  
end

def update_facebook_omniauth(auth)
  self.provider = auth.provider
  self.uid = auth.uid    
  self.oauth_token = auth.credentials.token
  self.password_confirmation = self.password  
  self.oauth_expires_at = Time.at(auth.credentials.expires_at)
end

def self.from_omniauth(auth)   

   where(auth.slice(:provider, :uid)).first_or_initialize.tap do |customerManagement|
      customerManagement.provider = auth.provider
      customerManagement.uid = auth.uid
      customerManagement.name = auth.info.name  
      customerManagement.password = "0"  
      customerManagement.password_confirmation = "0"
      customerManagement.email = auth.extra.raw_info.email
      customerManagement.oauth_token = auth.credentials.token
      customerManagement.oauth_expires_at = Time.at(auth.credentials.expires_at)
      customerManagement.save
    end
end

def encrypt_token(token)
  return Digest::SHA1.hexdigest(token.to_s)
end  

def send_password_reset
  self.password_reset_token = SecureRandom.urlsafe_base64
  self.password_reset_sent_at = Time.zone.now
  save(:validate => false)
  UserMailer.password_reset(self).deliver
end

private
def encrypt
  self.password = BCrypt::Password.create(self.password, :cost => 15)
end

end
