FactoryGirl.define do
  factory :invite do |i|
    i.sequence(:email) {|i| "john+invited+#{i}@example.com" }
    i.association(:user)
    i.association(:application)
  end
end
