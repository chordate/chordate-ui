require_all "securerandom"

class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :application

  validates :email, :user, :application, :presence => true

  before_create -> { self.token = generate_token }

  private

  def generate_token
    SecureRandom.hex(24)
  end
end
