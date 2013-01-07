require "digest/sha2"
require "securerandom"

class User < ActiveRecord::Base
  validates :name, :email, :password, :presence => true
  validates_uniqueness_of :email

  before_create :generate_password
  before_create lambda { self.token = generate_token }

  before_update :generate_password, :if => lambda { password_changed? }

  def valid_password?(other)
    digest(:other => other) == password
  end

  def update_token
    update_attributes(:token => generate_token)
  end

  private

  def generate_password
    self.salt = Time.now.to_i
    self.password = digest
  end

  def generate_token
    SecureRandom.hex(32)
  end

  def digest(options = {})
    Digest::SHA2.hexdigest("#{(options[:other] || password)}_#{salt}")
  end
end
