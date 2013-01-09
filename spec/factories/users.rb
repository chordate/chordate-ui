FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) {|i| "john+#{i}@example.com" }
    u.sequence(:name) {|i| "John Doe + #{i}" }
    u.password "password"
    u.association(:account, :factory => :account)
  end
end
