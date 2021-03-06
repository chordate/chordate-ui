require_all "securerandom"

class Application < ActiveRecord::Base
  TOKEN = "%010d%020d"

  belongs_to :account
  belongs_to :user

  has_many :events
  has_many :application_users
  has_many :users, :through => :application_users

  before_validation -> { self.account = user.account }, :on => :create, :unless => -> { account.present? }

  validates :name, :user, :presence => true

  before_create -> { self.token = generate_token }
  after_create  -> { self.users << user }

  private

  def generate_token
    (TOKEN % [Time.now.to_i, user.id]).to_i.to_s(36) + SecureRandom.hex(9)
  end
end
