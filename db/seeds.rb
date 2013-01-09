account = Account.where(:name => "First Account - Seeded").first_or_create!

user = User.where(:email => "john-doe-seeded@example.com").first_or_create!(
  :account => account,
  :name => "John Doe (Seeded)",
  :password => "password"
)

Application.where(:name => "First Application - Seeded").first_or_create!(
  :user => User.first
)
