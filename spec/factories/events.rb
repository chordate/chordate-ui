FactoryGirl.define do
  factory :event do |e|
    e.env "ninja_env"
    e.sequence(:klass) {|i| "ErrorClass + #{i}"}
    e.sequence(:message) {|i| "A Nice Error Message + #{i}"}
    e.generated_at { Time.now }
    e.association(:application)
  end
end
