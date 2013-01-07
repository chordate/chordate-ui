class UserDecorator
  include Decorator

  allow :name, :email

  def save
    user.save
  end
end
