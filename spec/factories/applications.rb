FactoryGirl.define do
  factory :application do |u|
    u.sequence(:name) {|i| "John Doe + #{i}" }
    u.association(:account)
    u.association(:user)
  end
end
