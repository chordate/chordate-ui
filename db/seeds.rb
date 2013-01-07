User.where(:email => "john-doe-seeded@example.com").first_or_create!(
  :name => "John Doe (Seeded)",
  :password => "password"
)
