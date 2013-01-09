FactoryGirl.define do
  factory :application do |u|
    u.sequence(:name) {|i| "John Doe + #{i}" }
    u.association(:account, :factory => :account)
    u.association(:user, :factory => :user)
  end
end
