class Session
  attr_reader :user

  def initialize(options = {})
    @user = User.where(:email => options[:email]).first
    @password = options[:password]
  end

  def token
    @user.token
  end

  def login
    (@user && @user.valid_password?(@password)) ? @user.update_token : false
  end
end
