FactoryGirl.define do
  factory :account do |u|
    u.sequence(:name) {|i| "Account + #{i}" }
  end
end
