class Account < ActiveRecord::Base
  has_one :owner, :class_name => User, :order => :id

  has_many :users
end
